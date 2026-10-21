///|
/// 依赖信息 | Dependency information
pub(all) struct DependencyInfo {
  name : String
  version : String
  license : String
  checksum : String
} derive(Debug, Eq)

pub extend DependencyInfo with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DependencyInfo with Eq::{not_equal, equal}

///|
/// 许可证兼容性结果 | License compatibility result
pub(all) struct LicenseCompatResult {
  compatible : Bool
  reason : String
} derive(Debug, Eq)

pub extend LicenseCompatResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LicenseCompatResult with Eq::{not_equal, equal}

///|
/// 依赖锁定文件条目 | Dependency lock file entry
pub(all) struct LockEntry {
  name : String
  version : String
  checksum : String
  source : String
} derive(Debug, Eq)

pub extend LockEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LockEntry with Eq::{not_equal, equal}

///|
/// 创建依赖信息 | Create dependency info
pub fn make_dependency(name : String, version : String, license : String, checksum : String) -> DependencyInfo {
  { name, version, license, checksum }
}

///|
/// 验证校验和 | Verify checksum
pub fn verify_checksum(expected : String, actual : String) -> Bool {
  expected == actual && expected.length() > 0
}

///|
/// 检查许可证兼容性 | Check license compatibility
pub fn check_license_compatibility(project_license : String, dep_license : String) -> LicenseCompatResult {
  match (project_license, dep_license) {
    ("MIT", "MIT") => { compatible: true, reason: "MIT is compatible with MIT" }
    ("MIT", "Apache-2.0") => { compatible: true, reason: "Apache-2.0 is compatible with MIT" }
    ("MIT", "BSD-3-Clause") => { compatible: true, reason: "BSD-3-Clause is compatible with MIT" }
    ("MIT", "ISC") => { compatible: true, reason: "ISC is compatible with MIT" }
    ("Apache-2.0", "Apache-2.0") => { compatible: true, reason: "Apache-2.0 is compatible with Apache-2.0" }
    ("Apache-2.0", "MIT") => { compatible: true, reason: "MIT is compatible with Apache-2.0" }
    ("GPL-3.0", "MIT") => { compatible: true, reason: "MIT is compatible with GPL-3.0" }
    ("GPL-3.0", "GPL-3.0") => { compatible: true, reason: "GPL-3.0 is compatible with GPL-3.0" }
    ("GPL-3.0", "Apache-2.0") => { compatible: false, reason: "Apache-2.0 is NOT compatible with GPL-3.0" }
    (_, "UNLICENSED") => { compatible: false, reason: "unlicensed dependency is not allowed" }
    (_, "PROPRIETARY") => { compatible: false, reason: "proprietary license is not allowed" }
    (_, _) => { compatible: true, reason: "unknown license combination, allowing by default" }
  }
}

///|
/// 创建锁定条目 | Create lock entry
pub fn make_lock_entry(dep : DependencyInfo, source : String) -> LockEntry {
  { name: dep.name, version: dep.version, checksum: dep.checksum, source }
}

///|
/// 生成锁定文件内容 | Generate lock file content
pub fn generate_lock_file(entries : Array[LockEntry]) -> String {
  let mut content = "# moon-cross lock file\n"
  content = content + "# auto-generated, do not edit manually\n\n"
  for entry in entries {
    content = content + "[\{entry.name}]\n"
    content = content + "version = \"\{entry.version}\"\n"
    content = content + "checksum = \"\{entry.checksum}\"\n"
    content = content + "source = \"\{entry.source}\"\n\n"
  }
  content
}

///|
/// 检查依赖安全性 | Check dependency safety
pub fn check_dependency_safety(dep : DependencyInfo) -> String? {
  if dep.name.length() == 0 {
    Some("dependency name must not be empty")
  } else if dep.version.length() == 0 {
    Some("dependency version must not be empty")
  } else if dep.license == "UNLICENSED" {
    Some("unlicensed dependency: \{dep.name}")
  } else if dep.license == "PROPRIETARY" {
    Some("proprietary dependency: \{dep.name}")
  } else if dep.checksum.length() == 0 {
    Some("missing checksum for \{dep.name}")
  } else {
    None
  }
}

///|
/// 批量检查依赖安全性 | Batch check dependency safety
pub fn batch_check_dependencies(deps : Array[DependencyInfo]) -> Array[String] {
  let issues = []
  for dep in deps {
    let issue = check_dependency_safety(dep)
    match issue {
      Some(msg) => issues.push(msg)
      None => ()
    }
  }
  issues
}

///|
/// 供应链安全版本 | Supply chain security version
pub fn supply_chain_version() -> String {
  "moon-cross security/supply_chain v0.0.9"
}

///|
/// DependencyInfo 实现 Named trait | DependencyInfo implements Named
pub impl @trait.Named for DependencyInfo with name(self) {
  self.name
}
pub extend DependencyInfo with @trait.Named::{name}

///|
/// LockEntry 实现 Named trait | LockEntry implements Named
pub impl @trait.Named for LockEntry with name(self) {
  self.name
}
pub extend LockEntry with @trait.Named::{name}