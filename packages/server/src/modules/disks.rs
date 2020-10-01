use systemstat::{System, Platform, Filesystem};
use serde::Serialize;

pub struct DisksModule(System);

const MOUNT_TYPE_IGNORE_LIST: [&'static str; 19] = [
    "sysfs",
    "tmpfs",
    "devtmpfs",
    "proc",
    "efivarfs",
    "securityfs",
    "devpts",
    "cgroup",
    "cgroup2",
    "fusectl",
    "configfs",
    "tracefs",
    "debugfs",
    "mqueue",
    "autofs",
    "pstore",
    "bpf",
    "hugetlbfs",
    "binfmt_misc"
];

impl DisksModule {
    pub fn new() -> Self {
        DisksModule(System)
    }

    pub fn get_mounts(&self) -> anyhow::Result<Vec<DiskMount>> {
        let mounts = self.0.mounts()?;

        let mounts = mounts.into_iter()
            .map(DiskMount::from)
            .filter(|mount| !MOUNT_TYPE_IGNORE_LIST.contains(&mount.mount_type.as_str()))
            .filter(|mount| !mount.mount_type.starts_with("fuse."))
            .collect();

        Ok(mounts)
    }
}

#[derive(Debug, Clone, Serialize)]
pub struct DiskMount {
    pub path: String,
    pub name: String,
    pub mount_type: String,
    pub used: u64,
    pub free: u64,
    pub total: u64
}

impl From<Filesystem> for DiskMount {
    fn from(fs: Filesystem) -> Self {
        DiskMount {
            path: fs.fs_mounted_on,
            name: fs.fs_mounted_from,
            mount_type: fs.fs_type,
            used: fs.total.as_u64() - fs.avail.as_u64(),
            free: fs.avail.as_u64(),
            total: fs.total.as_u64(),
        }
    }
}
