use evdev_rs::Device;
use std::fs::File;
use serde::{Serialize, Deserialize};

// pub fn get_gamepad_2(file: &'static str) -> anyhow::Result<Gamepad> {
//     let dev = evdev::Device::open(file)?;
//
//     Ok(dev.into())
// }

pub fn get_gamepad(file: &str) -> anyhow::Result<Gamepad> {
    let fd = File::open(file)?;
    let dev = evdev_rs::Device::new_from_fd(fd)?;

    Ok(dev.into())
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct Gamepad {
    pub name: String,
    pub player: u32
}

impl From<evdev_rs::Device> for Gamepad {
    fn from(dev: Device) -> Self {
        let name = dev.name().unwrap().to_string();
        println!("{:?}", dev.num_slots());

        Gamepad {
            name,
            player: 0
        }
    }
}

impl From<evdev::Device> for Gamepad {
    fn from(dev: evdev::Device) -> Self {
        let name = dev.name().clone().into_string().unwrap();

        Gamepad {
            name,
            player: 0
        }
    }
}
