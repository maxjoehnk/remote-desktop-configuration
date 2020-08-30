use bluez::client::{BlueZClient, ConnectionInfo};
use serde::{Serialize, Deserialize};
use bluez::interface::controller::{ControllerInfo, Controller};
use std::str::FromStr;

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct BluetoothController {
    pub cursor: String,
    pub address: String,
    pub name: String,
    pub manufacturer: u16,
}

impl From<(Controller, ControllerInfo)> for BluetoothController {
    fn from((controller, info): (Controller, ControllerInfo)) -> Self {
        let cursor: u16 = controller.into();
        BluetoothController {
            cursor: format!("{}", cursor),
            address: format!("{}", info.address),
            name: info.name.into_string().unwrap(),
            manufacturer: info.manufacturer,
        }
    }
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct BluetoothConnection {
    cursor: String,
}

impl From<ConnectionInfo> for BluetoothConnection {
    fn from(connection: ConnectionInfo) -> Self {
        BluetoothConnection {
            cursor: format!("{:?}", connection.address)
        }
    }
}

pub struct BluetoothModule<'a> {
    client: BlueZClient<'a>
}

impl<'a> BluetoothModule<'a> {
    pub fn new() -> anyhow::Result<Self> {
        Ok(BluetoothModule {
            client: BlueZClient::new()?
        })
    }

    pub async fn list_controllers(&mut self) -> anyhow::Result<Vec<BluetoothController>> {
        let mut controllers = Vec::new();
        let list = self.client.get_controller_list().await?;
        for controller in list {
            let info = self.client.get_controller_info(controller).await?;
            controllers.push((controller, info).into());
        }
        Ok(controllers)
    }

    pub async fn list_connections(&mut self, address: &str) -> anyhow::Result<Vec<BluetoothConnection>> {
        let controller = self.get_controller(address).await?.unwrap();
        let addresses = self.client.get_connections(controller).await?;
        let mut connections = Vec::new();
        for (address, address_type) in addresses {
            let connection = self.client.get_connection_info(controller, address, address_type).await?;
            connections.push(connection.into());
        }
        Ok(connections)
    }

    async fn get_controller(&mut self, address: &str) -> anyhow::Result<Option<Controller>> {
        let address = u16::from_str(address)?;
        let controllers = self.client.get_controller_list().await?;
        Ok(controllers.into_iter().find(|c| {
            let c: u16 = (*c).into();
            c == address
        }))
    }
}
