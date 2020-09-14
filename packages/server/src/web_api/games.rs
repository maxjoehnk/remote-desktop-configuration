use tide::{Server, Response, Body};
use crate::modules::lutris::LutrisModule;
use crate::web_api::util::{to_json, Request};

fn create_module() -> LutrisModule {
    LutrisModule::new("/home/max/Code/9_applications/lutris/bin/lutris")
}

pub fn create_games_api(app: &mut Server<()>) {
    let mut route = app.at("/api/games");
    route.get(|_| async {
        let module = create_module();
        let games = module.clone().get_game_list()?;
        to_json(&games)
    });
    route.at("/:game/banner").get(|req: Request| async move {
        let module = create_module();
        let cursor = req.param::<String>("game")?;

        let path = module.get_banner_path(&cursor);

        let mut res = Response::new(200);
        res.set_body(Body::from_file(path).await?);
        Ok(res)
    });
}
