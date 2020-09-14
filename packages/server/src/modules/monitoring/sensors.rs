use serde::{Serialize, Deserialize};
use sensors::Sensors;
use super::api::*;

pub struct SensorsApi(Sensors);

impl SensorsApi {
    pub fn new() -> Self {
        SensorsApi(Sensors::new())
    }

    fn get_sensors(&self) -> anyhow::Result<Vec<Device>> {
        self.0.detected_chips("")?
            .map(|chip| {
                let name = chip.get_name()?;
                let sensors = chip.into_iter()
                    .map::<anyhow::Result<Sensor>, _>(|feature| {
                        let name = feature.name().to_string();
                        let label = feature.get_label()?.to_string();

                        Ok(Sensor {
                            name,
                            label,
                            sensor_type: SensorType::Temperature
                        })
                    })
                    .collect::<Result<Vec<_>, _>>()?;

                Ok(Device { name, sensors })
            })
            .collect()
    }
}

impl MonitoringApi for SensorsApi {
    fn get_snapshot(&mut self) -> anyhow::Result<Vec<MonitoringSnapshot>> {
        Ok(Vec::new())
    }
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct Device {
    name: String,
    sensors: Vec<Sensor>
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct Sensor {
    name: String,
    label: String,
    sensor_type: SensorType,
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub enum SensorType {
    In,
    Fan,
    Temperature,
    Power,
    Energy,
    Current,
    Humidity,
    MaxMain,
    Vid,
    Intrusion,
    MaxOther,
    BeepEnable,
    Max,
    Unknown
}
