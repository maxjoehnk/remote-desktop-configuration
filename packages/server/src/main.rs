mod modules;
mod web_api;

use crate::web_api::create_api;
// use crate::modules::evdev::get_gamepad;

#[async_std::main]
async fn main() -> anyhow::Result<()> {
    tide::log::start();

    // println!("{:?}", get_gamepad("/dev/input/event29")?);

    let api = create_api();

    api.listen("0.0.0.0:5560").await?;

    Ok(())
}

