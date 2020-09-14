use serde::{Serialize, Deserialize};
use std::collections::VecDeque;

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MonitoringItem {
    pub name: String,
    pub current: MonitoringValue,
    pub history: VecDeque<MonitoringValue>
}

#[derive(Debug, Clone)]
pub struct MonitoringSnapshot {
    pub name: String,
    pub value: MonitoringValue,
}

impl From<MonitoringSnapshot> for MonitoringItem {
    fn from(snapshot: MonitoringSnapshot) -> Self {
        MonitoringItem {
            name: snapshot.name,
            current: snapshot.value,
            history: VecDeque::new()
        }
    }
}

#[derive(Debug, Clone, Serialize, Deserialize)]
pub struct MonitoringValue {
    pub value: f64,
    pub max: Option<f64>
}

pub trait MonitoringApi {
    fn get_snapshot(&mut self) -> anyhow::Result<Vec<MonitoringSnapshot>>;
}
