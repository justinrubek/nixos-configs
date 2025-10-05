use crate::error::Result;
use std::path::PathBuf;

#[derive(clap::Subcommand, Debug)]
pub(crate) enum Subcommands {
    /// serves the directory contents via http
    ServeDir { 
        #[arg(default_value = "0.0.0.0:3502", long, short)]
        address: std::net::SocketAddr,
        #[arg(short, long)]
        directory: PathBuf

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
            Subcommands::ServeDir { address, directory, .. } => {
                tokio::runtime::Builder::new_multi_thread()
                    .enable_all()
                    .build()
                    .unwrap()
                    .block_on(async {
                        let app = axum::Router::new().fallback_service(tower_http::services::ServeDir::new(directory));
                        let listener = tokio::net::TcpListener::bind(address).await.unwrap();
                        axum::serve(listener, app).await.unwrap();
                    });
                Ok(())
            }
        }
    }
}
