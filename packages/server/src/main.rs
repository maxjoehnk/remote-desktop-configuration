mod modules;
mod web_api;

use crate::web_api::create_api;

#[async_std::main]
async fn main() -> anyhow::Result<()> {
    tide::log::start();

    let api = create_api();

    api.listen("0.0.0.0:5560").await?;

    Ok(())
}

