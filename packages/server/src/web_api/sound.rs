use tide::{Server, Response};
use crate::modules::pulseaudio::PulseModule;
use crate::web_api::util::{to_json, Request};

pub fn create_sound_api(app: &mut Server<()>) {
    // app.at("/api/sound/devices").get(|_| async {
    //     let mut pulse = PulseModule::new();
    //     let devices = pulse.get_devices()?;
    //     to_json(&devices)
    // });
    create_pulse_input_api(app);
    create_pulse_output_api(app);
    create_pulse_playback_api(app);
    create_pulse_recording_api(app);
}

fn create_pulse_input_api(app: &mut Server<()>) {
    let mut input_route = app.at("/api/sound/inputs");
    input_route.get(|_| async {
        let mut pulse = PulseModule::new()?;
        let devices = pulse.get_input_devices()?;
        to_json(&devices)
    });
    input_route.at("/:device/volume/:value").post(|req: Request| async move {
        let cursor = req.param::<String>("device")?;
        let value = req.param::<f64>("value")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_input_volume(&cursor, value)?;

        Ok(Response::new(204))
    });
    input_route.at("/:device/mute/:muted").post(|req: Request| async move {
        let cursor = req.param::<String>("device")?;
        let value = req.param::<bool>("muted")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_input_mute(&cursor, value)?;

        Ok(Response::new(204))
    });
}

fn create_pulse_output_api(app: &mut Server<()>) {
    let mut output_route = app.at("/api/sound/outputs");
    output_route.get(|_| async {
        let mut pulse = PulseModule::new()?;
        let devices = pulse.get_output_devices()?;
        to_json(&devices)
    });
    output_route.at("/:device/volume/:value").post(|req: Request| async move {
        let cursor = req.param::<String>("device")?;
        let value = req.param::<f64>("value")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_output_volume(&cursor, value)?;

        Ok(Response::new(204))
    });
    output_route.at("/:device/mute/:muted").post(|req: Request| async move {
        let cursor = req.param::<String>("device")?;
        let value = req.param::<bool>("muted")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_output_mute(&cursor, value)?;

        Ok(Response::new(204))
    });
}

fn create_pulse_playback_api(app: &mut Server<()>) {
    let mut playback_route = app.at("/api/sound/applications/playback");
    playback_route.get(|_| async {
        let mut pulse = PulseModule::new()?;
        let applications = pulse.get_playback_applications()?;
        to_json(&applications)
    });
    playback_route.at("/:application/volume/:value").post(|req: Request| async move {
        let cursor = req.param::<String>("application")?;
        let value = req.param::<f64>("value")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_playback_volume(&cursor, value)?;

        Ok(Response::new(204))
    });
    playback_route.at("/:application/mute/:muted").post(|req: Request| async move {
        let cursor = req.param::<String>("application")?;
        let value = req.param::<bool>("muted")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_playback_mute(&cursor, value)?;

        Ok(Response::new(204))
    });
}

fn create_pulse_recording_api(app: &mut Server<()>) {
    let mut recording_route = app.at("/api/sound/applications/record");
    recording_route.get(|_| async {
        let mut pulse = PulseModule::new()?;
        let applications = pulse.get_record_applications()?;
        to_json(&applications)
    });
    recording_route.at("/:application/volume/:value").post(|req: Request| async move {
        let cursor = req.param::<String>("application")?;
        let value = req.param::<f64>("value")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_recording_volume(&cursor, value)?;

        Ok(Response::new(204))
    });
    recording_route.at("/:application/mute/:muted").post(|req: Request| async move {
        let cursor = req.param::<String>("application")?;
        let value = req.param::<bool>("muted")?;
        let mut pulse = PulseModule::new()?;

        pulse.set_recording_mute(&cursor, value)?;

        Ok(Response::new(204))
    });
}
