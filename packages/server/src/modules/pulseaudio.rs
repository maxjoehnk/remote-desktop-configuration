use serde::{Serialize, Deserialize};
use pulsectl::controllers::{SinkController, SourceController, AppControl};
use pulsectl::controllers::DeviceControl;
use pulsectl::controllers::types::{DeviceInfo, ApplicationInfo};
use libpulse_binding::volume::{VolumeLinear, ChannelVolumes};
use std::str::FromStr;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct DeviceChannel {
    pub cursor: String,
    pub name: String,
    pub volume: Vec<f64>,
    pub mute: bool,
}

impl From<DeviceInfo> for DeviceChannel {
    fn from(device: DeviceInfo) -> Self {
        DeviceChannel {
            volume: from_volume(&device.volume),
            cursor: format!("{}", device.index),
            name: device.description.unwrap_or_else(|| "<unnamed>".to_string()),
            mute: device.mute,
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Application {
    cursor: String,
    name: String,
    stream: String,
    volume: Vec<f64>,
    mute: bool,
    icon: Option<String>
}

impl From<ApplicationInfo> for Application {
    fn from(app: ApplicationInfo) -> Self {
        log::info!("{:?}", &app.proplist);

        Application {
            volume: from_volume(&app.volume),
            mute: app.mute,
            cursor: format!("{}", app.index),
            stream: app.name.unwrap(),
            name: app.proplist.get_str("application.name").unwrap(),
            icon: app.proplist.get_str("application.icon_name")
        }
    }
}

fn from_volume(volume: &ChannelVolumes) -> Vec<f64> {
    volume.get().iter().map(|volume| VolumeLinear::from(*volume).0).collect()
}

pub struct PulseModule {
    sink: SinkController,
    source: SourceController,
}

impl PulseModule {
    pub fn new() -> anyhow::Result<Self> {
        let sink = SinkController::create()?;
        let source = SourceController::create()?;

        Ok(PulseModule {
            sink,
            source
        })
    }

    pub fn get_input_devices(&mut self) -> anyhow::Result<Vec<DeviceChannel>> {
        let devices = self.source
            .list_devices()
            .unwrap()
            .into_iter()
            .map(DeviceChannel::from)
            .collect();

        Ok(devices)
    }

    pub fn get_output_devices(&mut self) -> anyhow::Result<Vec<DeviceChannel>> {
        let devices = self.sink
            .list_devices()
            .unwrap()
            .into_iter()
            .map(DeviceChannel::from)
            .collect();

        Ok(devices)
    }

    pub fn get_playback_applications(&mut self) -> anyhow::Result<Vec<Application>> {
        let apps = self.sink.list_applications()
            .unwrap()
            .into_iter()
            .map(Application::from)
            .collect();

        Ok(apps)
    }

    pub fn get_record_applications(&mut self) -> anyhow::Result<Vec<Application>> {
        let apps = self.source.list_applications()
            .unwrap()
            .into_iter()
            .map(Application::from)
            .collect();

        Ok(apps)
    }

    pub fn set_playback_volume(&mut self, app: &str, volume: f64) -> anyhow::Result<()> {
        let index = u32::from_str(app)?;
        let mut app = self.sink.get_app_by_index(index).unwrap();
        let len = app.volume.len();
        let volume = VolumeLinear(volume);
        app.volume.set(len as u32, volume.into());
        Ok(())
    }

    pub fn set_recording_volume(&mut self, app: &str, volume: f64) -> anyhow::Result<()> {
        let index = u32::from_str(app)?;
        let mut app = self.source.get_app_by_index(index).unwrap();
        let len = app.volume.len();
        let volume = VolumeLinear(volume);
        app.volume.set(len as u32, volume.into());
        Ok(())
    }

    pub fn set_playback_mute(&mut self, device: &str, mute: bool) -> anyhow::Result<()> {
        let index = u32::from_str(device)?;

        self.sink.set_app_mute(index, !mute).unwrap();
        Ok(())
    }

    pub fn set_recording_mute(&mut self, device: &str, mute: bool) -> anyhow::Result<()> {
        let index = u32::from_str(device)?;

        self.source.set_app_mute(index, !mute).unwrap();
        Ok(())
    }

    pub fn set_output_volume(&mut self, device: &str, volume: f64) -> anyhow::Result<()> {
        let index = u32::from_str(device)?;
        let volume = VolumeLinear(volume);

        let device = self.sink.get_device_by_index(index).unwrap();
        let mut channel_volume = device.volume;
        let len = channel_volume.len();
        channel_volume.set(len as u32, volume.into());
        self.sink.set_device_volume_by_index(index, &channel_volume);
        Ok(())
    }

    pub fn set_input_volume(&mut self, device: &str, volume: f64) -> anyhow::Result<()> {
        let index = u32::from_str(device)?;
        let volume = VolumeLinear(volume);

        let device = self.source.get_device_by_index(index).unwrap();
        let mut channel_volume = device.volume;
        let len = channel_volume.len();
        channel_volume.set(len as u32, volume.into());
        self.source.set_device_volume_by_index(index, &channel_volume);
        Ok(())
    }

    pub fn set_output_mute(&mut self, device: &str, mute: bool) -> anyhow::Result<()> {
        let index = u32::from_str(device)?;

        self.sink.set_device_mute(index, !mute).unwrap();
        Ok(())
    }

    pub fn set_input_mute(&mut self, device: &str, mute: bool) -> anyhow::Result<()> {
        let index = u32::from_str(device)?;

        self.source.set_device_mute(index, !mute).unwrap();
        Ok(())
    }
}
