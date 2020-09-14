use serde::{Serialize, Deserialize};
use std::process::{Command, Stdio};
use std::path::{PathBuf};

#[derive(Clone, Debug)]
pub struct LutrisModule {
    binary: String
}

impl Default for LutrisModule {
    fn default() -> Self {
        LutrisModule {
            binary: "lutris".to_string()
        }
    }
}

impl LutrisModule {
    pub fn new<S: Into<String>>(binary: S) -> Self {
        LutrisModule {
            binary: binary.into()
        }
    }

    pub fn get_game_list(&self) -> anyhow::Result<Vec<LutrisGame>> {
        let output = Command::new(&self.binary)
            .arg("-olj")
            .stdout(Stdio::piped())
            .output()?;
        let games = serde_json::from_slice(&output.stdout)?;
        Ok(games)
    }

    pub fn get_banner_path<'a>(&self, slug: &str) -> PathBuf {
        PathBuf::from(&format!("/home/max/.local/share/lutris/banners/{}.jpg", slug))
    }
}

#[derive(Debug, Clone, Deserialize, Serialize)]
pub struct LutrisGame {
    pub id: u64,
    pub slug: String,
    pub name: String,
    pub runner: String,
    pub platform: Option<String>,
}
