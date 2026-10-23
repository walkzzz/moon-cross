///|
/// ASAN 配置 | ASAN configuration
pub(all) struct AsanConfig {
  enabled : Bool
  detect_leaks : Bool
  detect_undefined_behavior : Bool
  detect_stack_use_after_return : Bool
} derive(Debug, Eq)

pub extend AsanConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend AsanConfig with Eq::{not_equal, equal}

///|
/// ASAN 验证结果 | ASAN verification result
pub(all) struct AsanResult {
  passed : Bool
  errors : Array[String]
  warnings : Array[String]
  duration_ms : Int
} derive(Debug, Eq)

pub extend AsanResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend AsanResult with Eq::{not_equal, equal}

///|
/// 默认 ASAN 配置 | Default ASAN configuration
pub fn default_asan_config() -> AsanConfig {
  { enabled: true, detect_leaks: true, detect_undefined_behavior: true, detect_stack_use_after_return: false }
}

///|
/// 禁用 ASAN 配置 | Disabled ASAN configuration
pub fn disabled_asan_config() -> AsanConfig {
  { enabled: false, detect_leaks: false, detect_undefined_behavior: false, detect_stack_use_after_return: false }
}

///|
/// ASAN 编译标志 | ASAN compile flags
pub fn asan_compile_flags(config : AsanConfig) -> Array[String] {
  if !config.enabled {
    return []
  }
  let flags = ["-fsanitize=address"]
  if config.detect_undefined_behavior {
    flags.push("-fsanitize=undefined")
  }
  flags.push("-fno-omit-frame-pointer")
  flags.push("-g")
  flags
}

///|
/// ASAN 链接标志 | ASAN link flags
pub fn asan_link_flags(config : AsanConfig) -> Array[String] {
  if !config.enabled {
    return []
  }
  let flags = ["-fsanitize=address"]
  if config.detect_undefined_behavior {
    flags.push("-fsanitize=undefined")
  }
  flags
}

///|
/// ASAN 运行时环境变量 | ASAN runtime environment variables
pub fn asan_env_vars(config : AsanConfig) -> Array[String] {
  if !config.enabled {
    return []
  }
  let vars = []
  if config.detect_leaks {
    vars.push("ASAN_OPTIONS=detect_leaks=1")
  } else {
    vars.push("ASAN_OPTIONS=detect_leaks=0")
  }
  if config.detect_stack_use_after_return {
    vars.push("ASAN_OPTIONS=detect_stack_use_after_return=1")
  }
  vars
}

///|
/// 分析 ASAN 输出 | Analyze ASAN output
pub fn analyze_asan_output(output : String) -> AsanResult {
  let errors = []
  let warnings = []
  if output.contains("ERROR: AddressSanitizer") {
    errors.push("AddressSanitizer error detected")
  }
  if output.contains("heap-buffer-overflow") {
    errors.push("heap-buffer-overflow detected")
  }
  if output.contains("stack-buffer-overflow") {
    errors.push("stack-buffer-overflow detected")
  }
  if output.contains("use-after-free") {
    errors.push("use-after-free detected")
  }
  if output.contains("WARNING: AddressSanitizer") {
    warnings.push("AddressSanitizer warning")
  }
  if output.contains("memory leak") {
    warnings.push("memory leak detected")
  }
  { passed: errors.length() == 0, errors, warnings, duration_ms: 0 }
}

///|
/// 创建 ASAN 通过结果 | Create ASAN pass result
pub fn asan_passed(duration_ms : Int) -> AsanResult {
  { passed: true, errors: [], warnings: [], duration_ms }
}

///|
/// 创建 ASAN 失败结果 | Create ASAN fail result
pub fn asan_failed(errors : Array[String], duration_ms : Int) -> AsanResult {
  { passed: false, errors, warnings: [], duration_ms }
}

///|
/// ASAN 版本 | ASAN version
pub fn asan_version() -> String {
  "moon-cross security/asan v0.0.9"
}