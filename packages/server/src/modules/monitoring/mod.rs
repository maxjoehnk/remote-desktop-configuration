mod psutil;
mod sensors;
mod api;

use lazy_static::lazy_static;

use self::sensors::SensorsApi;

use self::api::*;
use self::psutil::PsUtilApi;
use pinboard::NonEmptyPinboard;
use std::thread;
use std::collections::HashMap;
use std::time::Duration;

lazy_static! {
    static ref DATA: NonEmptyPinboard<HashMap<String, MonitoringItem>> = NonEmptyPinboard::new(HashMap::new());
}

const SLEEP_DURATION: u64 = 2;
const MAX_HISTORY_ITEMS: usize = 30;

#[derive(Default, Clone, Copy)]
pub struct MonitoringModule;

pub struct MonitoringTask {
    sensors: SensorsApi,
    sys_info: PsUtilApi,
}

impl MonitoringTask {
    pub fn new() -> anyhow::Result<Self> {
        Ok(MonitoringTask {
            sensors: SensorsApi::new(),
            sys_info: PsUtilApi::new()?,
        })
    }

    pub fn start(mut self) {
        thread::spawn(move || {
            loop {
                self.update_data();
                thread::sleep(Duration::from_secs(SLEEP_DURATION));
            }
        });
    }

    fn update_data(&mut self) {
        let snapshots = vec![
            self.sensors.get_snapshot(),
            self.sys_info.get_snapshot(),
        ].into_iter()
            .filter_map(|snapshots| match snapshots {
                Ok(snapshots) => Some(snapshots),
                Err(e) => {
                    eprintln!("{:?}", e);
                    None
                }
            })
            .flatten()
            .collect::<Vec<_>>();

        let mut history = DATA.read();

        for snapshot in snapshots {
            if let Some(history_entry) = history.get_mut(&snapshot.name) {
                let prev = history_entry.current.clone();
                history_entry.current = snapshot.value;
                history_entry.history.push_front(prev);
                if history_entry.history.len() > MAX_HISTORY_ITEMS {
                    history_entry.history.pop_back();
                }
            }else {
                history.insert(snapshot.name.clone(), snapshot.into());
            }
        }

        DATA.set(history);
    }
}

impl MonitoringModule {
    pub fn new() -> Self {
        MonitoringModule::default()
    }

    pub fn get_data(&self) -> Vec<MonitoringItem> {
        DATA.read().values().cloned().collect()
    }
}
