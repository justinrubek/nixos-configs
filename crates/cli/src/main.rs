use crate::error::Result;
use clap::Parser;

mod error;
mod ingress;
mod http_proxy;

fn main() -> Result<()> {
    tracing_subscriber::fmt::init();

    let args = Args::parse();
    match args.command {
        Commands::HTTPProxy(command) => command.run(),
        Commands::Ingress(command) => command.run(),
    }
}

#[derive(clap::Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub(crate) struct Args {
    #[clap(subcommand)]
    pub command: Commands,
}

#[derive(clap::Subcommand, Debug)]
pub(crate) enum Commands {
    HTTPProxy(crate::http_proxy::Args),
    Ingress(crate::ingress::Args),
}

