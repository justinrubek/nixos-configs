use crate::error::Result;
use pingora::{
    prelude::HttpPeer,
    proxy::{http_proxy_service, ProxyHttp, Session},
    server::{configuration::ServerConf, Server},
};
use std::{collections::HashMap, net::SocketAddr, str::FromStr};

#[derive(clap::Subcommand, Debug)]
pub(crate) enum Subcommands {
    Run {
        #[arg(short, long)]
        upgrade_socket: Option<String>,
    },
}

#[derive(clap::Args, Debug)]
pub(crate) struct Args {
    #[clap(subcommand)]
    pub command: Subcommands,
}

impl Args {
    pub(crate) fn run(self) -> Result<()> {
        match self.command {
            Subcommands::Run { upgrade_socket, .. } => {
                let mut server = Server::new(None).unwrap();

                let mut server_conf = ServerConf::default();
                if let Some(sock) = upgrade_socket {
                    server_conf.upgrade_sock = sock;
                    server_conf.grace_period_seconds = Some(30);
                }

                server.bootstrap();

                let mut mappings = HashMap::new();
                mappings.insert(Host::Auth, SocketAddr::from_str("10.0.0.50:3500").unwrap());
                mappings.insert(Host::Blobs, SocketAddr::from_str("10.0.0.50:3501").unwrap());
                mappings.insert(Host::Files, SocketAddr::from_str("10.0.0.50:3502").unwrap());
                mappings.insert(
                    Host::Webhooks,
                    SocketAddr::from_str("10.0.0.50:3503").unwrap(),
                );
                let resolver = Resolver::new(mappings);
                let router = Router::new(resolver);

                let mut proxy_service = http_proxy_service(&server.configuration, router);
                proxy_service.add_tcp("0.0.0.0:8080");

                server.add_service(proxy_service);

                server.run_forever();
            }
        }
    }
}

#[derive(Clone, Copy, Eq, Hash, PartialEq, serde::Deserialize, serde::Serialize)]
pub enum Host {
    Auth,
    Blobs,
    Files,
    Webhooks,
}

#[derive(Clone)]
struct Resolver {
    mappings: HashMap<Host, SocketAddr>,
}

impl Resolver {
    fn new(mappings: HashMap<Host, SocketAddr>) -> Resolver {
        Resolver { mappings }
    }

    fn resolve(&self, host: Host) -> Option<SocketAddr> {
        self.mappings.get(&host).copied()
    }
}

pub struct Router {
    resolver: Resolver,
}

impl Router {
    fn new(resolver: Resolver) -> Self {
        Router { resolver }
    }

    fn get_service_upstream(&self, session: &Session) -> Option<SocketAddr> {
        let host = match session.req_header().headers.get("host") {
            Some(h) => h.to_str().unwrap_or(""),
            None => "",
        };

        if host.eq_ignore_ascii_case("auth.rubek.cloud") {
            return self.resolver.resolve(Host::Auth);
        }
        if host.eq_ignore_ascii_case("blobs.rubek.cloud") {
            return self.resolver.resolve(Host::Blobs);
        }
        if host.eq_ignore_ascii_case("files.rubek.cloud") {
            return self.resolver.resolve(Host::Files);
        }
        if host.eq_ignore_ascii_case("webhooks.rubek.cloud") {
            return self.resolver.resolve(Host::Webhooks);
        }

        None
    }
}

#[async_trait::async_trait]
impl ProxyHttp for Router {
    type CTX = ();
    fn new_ctx(&self) -> Self::CTX {}

    async fn upstream_peer(
        &self,
        session: &mut Session,
        _ctx: &mut Self::CTX,
    ) -> pingora::Result<Box<HttpPeer>> {
        match self.get_service_upstream(session) {
            Some(upstream) => {
                let peer = Box::new(HttpPeer::new(upstream, false, String::new()));
                Ok(peer)
            }
            None => Err(pingora_error::Error::explain(
                pingora::HTTPStatus(404),
                "not found",
            )),
        }
    }
}
