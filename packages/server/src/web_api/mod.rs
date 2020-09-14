mod sound;
mod util;
mod games;

use tide::{Server, Response, Body};
use serde::Serialize;
use crate::modules::bluetooth::BluetoothModule;
use crate::web_api::sound::create_sound_api;
use crate::web_api::games::create_games_api;
use crate::modules::monitoring::{MonitoringModule, MonitoringTask};

type Request = tide::Request<()>;

pub fn create_api() -> Server<()> {
    let mut app = tide::new();
    create_bluetooth_api(&mut app);
    create_sound_api(&mut app);
    create_games_api(&mut app);
    create_monitoring_api(&mut app);
    app.at("/api/icons/:name").get(|req: Request| async move {
        let name = req.param::<String>("name")?;
        let icon = std::fs::read_to_string(format!("/usr/share/icons/Papirus/128x128/apps/{}.svg", name))?;
        let mut res = Response::new(200);
        res.set_body(Body::from(icon));
        res.set_content_type("image/svg");
        Ok(res)
    });

    app
}

fn create_monitoring_api(app: &mut Server<()>) {
    MonitoringTask::new().unwrap().start();
    app.at("/api/monitoring").get(|req: Request| async move {
        let module = MonitoringModule::new();
        let monitoring = module.get_data();

        to_json(&monitoring)
    });
}

fn create_bluetooth_api(app: &mut Server<()>) {
    app.at("/api/bluetooth/controllers").get(|_| async {
        let mut module = BluetoothModule::new()?;
        let controllers = module.list_controllers().await?;
        to_json(&controllers)
    });
    app.at("/api/bluetooth/controllers/:controller/connections").get(|req: Request| async move {
        let controller = req.param::<String>("controller")?;
        let mut module = BluetoothModule::new()?;
        let connections = module.list_connections(&controller).await?;
        to_json(&connections)
    });
}

fn to_json(body: &impl Serialize) -> tide::Result<Response> {
    let mut res = Response::new(200);
    res.set_body(Body::from_json(body)?);
    Ok(res)
}
