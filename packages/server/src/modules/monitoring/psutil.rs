use super::api::*;
use psutil::memory::virtual_memory;
use psutil::cpu::CpuPercentCollector;
use psutil::network::NetIoCountersCollector;
use psutil::sensors::temperatures;

pub struct PsUtilApi {
    cpu: CpuPercentCollector,
    network: NetIoCountersCollector,
}

impl PsUtilApi {
    pub fn new() -> anyhow::Result<Self> {
        Ok(PsUtilApi {
            cpu: CpuPercentCollector::new()?,
            network: NetIoCountersCollector::default(),
        })
    }

    fn get_memory() -> anyhow::Result<MonitoringSnapshot> {
        let memory = virtual_memory()?;

        let total = memory.total() as f64;
        let used = MonitoringSnapshot {
            name: "Memory Used".to_string(),
            value: MonitoringValue {
                value: memory.used() as f64,
                max: Some(total)
            }
        };

        Ok(used)
    }

    fn get_cpu_usage(&mut self) -> anyhow::Result<MonitoringSnapshot> {
        let percent = self.cpu.cpu_percent()?;

        Ok(MonitoringSnapshot {
            name: "CPU Usage".to_string(),
            value: MonitoringValue {
                value: percent as f64,
                max: Some(100f64)
            },
        })
    }

    fn get_temps() -> Vec<MonitoringSnapshot> {
        temperatures().into_iter()
            .filter_map(|temp| temp.ok())
            .filter(|temp| temp.label().is_some())
            .map(|temp| {
                MonitoringSnapshot {
                    name: temp.label().map(|l| l.to_string()).unwrap(),
                    value: MonitoringValue {
                        value: temp.current().celsius(),
                        max: None
                    }
                }
            })
            .collect()
    }
}

impl MonitoringApi for PsUtilApi {
    fn get_snapshot(&mut self) -> anyhow::Result<Vec<MonitoringSnapshot>> {
        let cpu = self.get_cpu_usage()?;
        let memory = Self::get_memory()?;
        let mut sensors = vec![cpu, memory];
        let mut temps = Self::get_temps();
        sensors.append(&mut temps);

        Ok(sensors)
    }
}
