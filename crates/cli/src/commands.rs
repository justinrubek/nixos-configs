#[derive(clap::Parser, Debug)]
#[command(author, version, about, long_about = None)]
pub(crate) struct Args {
    #[clap(subcommand)]
    pub command: Commands,
}

#[derive(clap::Subcommand, Debug)]
pub(crate) enum Commands {
    Hello(Hello),
}

#[derive(clap::Args, Debug)]
pub(crate) struct Hello {
    #[clap(subcommand)]
    pub command: HelloCommands,
}

#[derive(clap::Subcommand, Debug)]
pub(crate) enum HelloCommands {
    World,
    Name {
        #[arg()]
        name: String,
    },
    Error,
}
