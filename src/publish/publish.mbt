///|
/// 发布配置 | Publish configuration
pub(all) struct PublishConfig {
  module_name : String
  version : String
  license : String
  description : String
  repository : String
  readme_path : String
  keywords : Array[String]
} derive(Debug, Eq)
pub extend PublishConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PublishConfig with Eq::{not_equal, equal}

///|
/// 发布就绪检查项 | Publish readiness check item
pub(all) struct PublishCheck {
  name : String
  passed : Bool
  message : String
} derive(Debug, Eq)
pub extend PublishCheck with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PublishCheck with Eq::{not_equal, equal}

///|
/// 发布就绪结果 | Publish readiness result
pub(all) struct PublishReadiness {
  checks : Array[PublishCheck]
  ready : Bool
  summary : String
} derive(Debug, Eq)
pub extend PublishReadiness with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PublishReadiness with Eq::{not_equal, equal}

///|
/// mooncakes 注册表元数据 | mooncakes registry metadata
pub(all) struct MooncakesMetadata {
  name : String
  version : String
  license : String
  description : String
  repository : String
  readme : String
  keywords : Array[String]
  checksum : String
} derive(Debug, Eq)
pub extend MooncakesMetadata with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MooncakesMetadata with Eq::{not_equal, equal}

///|
/// 默认发布配置 | Default publish configuration
pub fn default_publish_config() -> PublishConfig {
  {
    module_name: "walkzzz/moon-cross",
    version: "0.1.9",
    license: "MIT",
    description: "MoonBit cross-platform native framework: write once, deliver to iOS/Android/Windows/HarmonyOS",
    repository: "https://github.com/walkzzz/moon-cross",
    readme_path: "README.md",
    keywords: [
      "cross-platform",
      "ffi",
      "native",
      "ios",
      "android",
      "windows",
      "harmonyos",
      "scaffold",
      "code-generation",
    ],
  }
}

///|
/// 检查模块名是否合法 | Check if module name is valid
pub fn check_module_name(name : String) -> PublishCheck {
  let valid = name.length() > 0 && name.contains("/")
  if valid {
    { name: "module_name", passed: true, message: "Module name is valid: " + name }
  } else {
    { name: "module_name", passed: false, message: "Module name must contain '/' separator" }
  }
}

///|
/// 检查版本号格式 | Check version format
pub fn check_version_format(version : String) -> PublishCheck {
  let parts = version.split(".")
  let mut count = 0
  for _ in parts {
    count = count + 1
  }
  let valid = count == 3
  if valid {
    { name: "version_format", passed: true, message: "Version format is valid: " + version }
  } else {
    { name: "version_format", passed: false, message: "Version must be X.Y.Z format (3 segments)" }
  }
}

///|
/// 检查许可证是否设置 | Check if license is set
pub fn check_license(license : String) -> PublishCheck {
  let valid = license.length() > 0
  if valid {
    { name: "license", passed: true, message: "License is set: " + license }
  } else {
    { name: "license", passed: false, message: "License must be specified" }
  }
}

///|
/// 检查描述是否设置 | Check if description is set
pub fn check_description(description : String) -> PublishCheck {
  let valid = description.length() > 10
  if valid {
    { name: "description", passed: true, message: "Description is set" }
  } else {
    { name: "description", passed: false, message: "Description must be at least 10 characters" }
  }
}

///|
/// 检查仓库 URL 是否设置 | Check if repository URL is set
pub fn check_repository(repository : String) -> PublishCheck {
  let valid = repository.length() > 0 && repository.contains("://")
  if valid {
    { name: "repository", passed: true, message: "Repository URL is set: " + repository }
  } else {
    { name: "repository", passed: false, message: "Repository URL must be a valid URL" }
  }
}

///|
/// 检查 README 路径是否设置 | Check if README path is set
pub fn check_readme(readme_path : String) -> PublishCheck {
  let valid = readme_path.length() > 0 && readme_path.contains(".md")
  if valid {
    { name: "readme", passed: true, message: "README path is set: " + readme_path }
  } else {
    { name: "readme", passed: false, message: "README path must be a .md file" }
  }
}

///|
/// 检查关键词是否足够 | Check if keywords are sufficient
pub fn check_keywords(keywords : Array[String]) -> PublishCheck {
  let valid = keywords.length() >= 3
  if valid {
    { name: "keywords", passed: true, message: "Keywords count: " + keywords.length().to_string() }
  } else {
    { name: "keywords", passed: false, message: "At least 3 keywords are required" }
  }
}

///|
/// 验证发布就绪状态 | Validate publish readiness
pub fn validate_publish_readiness(config : PublishConfig) -> PublishReadiness {
  let checks = [
    check_module_name(config.module_name),
    check_version_format(config.version),
    check_license(config.license),
    check_description(config.description),
    check_repository(config.repository),
    check_readme(config.readme_path),
    check_keywords(config.keywords),
  ]
  let mut all_passed = true
  for check in checks {
    if !check.passed {
      all_passed = false
    }
  }

  let summary = if all_passed {
    "All checks passed. Ready to publish."
  } else {
    "Some checks failed. Please fix before publishing."
  }
  { checks, ready: all_passed, summary }
}

///|
/// 生成 mooncakes 注册表元数据 | Generate mooncakes registry metadata
pub fn generate_mooncakes_metadata(config : PublishConfig) -> MooncakesMetadata {
  {
    name: config.module_name,
    version: config.version,
    license: config.license,
    description: config.description,
    repository: config.repository,
    readme: config.readme_path,
    keywords: config.keywords,
    checksum: generate_checksum(config),
  }
}

///|
/// 生成校验和（简化版） | Generate checksum (simplified)
pub fn generate_checksum(config : PublishConfig) -> String {
  let mut hash = 0
  for c in config.module_name.to_array() {
    hash = hash + c.to_int()
  }
  for c in config.version.to_array() {
    hash = hash + c.to_int()
  }
  hash = hash % 1000000
  "sha256:" + hash.to_string()
}

///|
/// 生成发布命令 | Generate publish command
pub fn generate_publish_command(config : PublishConfig) -> String {
  "moon publish --version " + config.version
}

///|
/// 生成安装命令 | Generate install command
pub fn generate_install_command(config : PublishConfig) -> String {
  "moon add " + config.module_name
}

///|
/// 检查版本一致性 | Check version consistency
pub fn check_version_consistency(
  mod_version : String,
  cli_version : String,
) -> PublishCheck {
  let consistent = mod_version == cli_version
  if consistent {
    { name: "version_consistency", passed: true, message: "Versions are consistent: " + mod_version }
  } else {
    {
      name: "version_consistency",
      passed: false,
      message: "Version mismatch: moon.mod=" + mod_version + " cli=" + cli_version,
    }
  }
}

///|
/// 生成发布前检查清单 | Generate pre-publish checklist
pub fn publish_checklist(config : PublishConfig) -> Array[String] {
  let readiness = validate_publish_readiness(config)
  let result = []
  for check in readiness.checks {
    let status = if check.passed {
      "[x]"
    } else {
      "[ ]"
    }
    result.push(status + " " + check.name + ": " + check.message)
  }
  result
}

///|
/// 许可证兼容性检查 | License compatibility check
pub fn check_license_compatibility(license : String) -> Bool {
  let compatible_licenses = ["MIT", "Apache-2.0", "BSD-3-Clause", "MPL-2.0", "ISC"]
  let mut found = false
  for lic in compatible_licenses {
    if lic == license {
      found = true
    }
  }
  found
}

///|
/// 生成 mooncakes.toml 配置内容 | Generate mooncakes.toml config content
pub fn generate_mooncakes_toml(config : PublishConfig) -> String {
  let mut result = "[package]\n"
  result = result + "name = \"" + config.module_name + "\"\n"
  result = result + "version = \"" + config.version + "\"\n"
  result = result + "license = \"" + config.license + "\"\n"
  result = result + "description = \"" + config.description + "\"\n"
  result = result + "repository = \"" + config.repository + "\"\n"
  result = result + "readme = \"" + config.readme_path + "\"\n"
  result = result + "keywords = ["
  for i in 0..<config.keywords.length() {
    if i > 0 {
      result = result + ", "
    }
    result = result + "\"" + config.keywords[i] + "\""
  }
  result = result + "]\n"
  result
}

///|
/// 发布状态 | Publish status
pub(all) enum PublishStatus {
  NotPublished
  Staging
  Published
  Failed(String)
} derive(Debug, Eq)
pub extend PublishStatus with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PublishStatus with Eq::{not_equal, equal}

///|
/// 发布结果 | Publish result
pub(all) struct PublishResult {
  status : PublishStatus
  message : String
  metadata : MooncakesMetadata?
} derive(Debug, Eq)
pub extend PublishResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PublishResult with Eq::{not_equal, equal}

///|
/// 模拟发布流程 | Simulate publish flow
pub fn simulate_publish(config : PublishConfig) -> PublishResult {
  let readiness = validate_publish_readiness(config)
  if readiness.ready {
    {
      status: Published,
      message: "Publish successful: " + config.module_name + "@" + config.version,
      metadata: Some(generate_mooncakes_metadata(config)),
    }
  } else {
    { status: Failed(readiness.summary), message: readiness.summary, metadata: None }
  }
}

///|
/// 检查是否已发布 | Check if already published
pub fn is_published(result : PublishResult) -> Bool {
  match result.status {
    Published => true
    _ => false
  }
}

///|
/// 获取发布元数据 | Get publish metadata
pub fn get_publish_metadata(result : PublishResult) -> MooncakesMetadata? {
  result.metadata
}