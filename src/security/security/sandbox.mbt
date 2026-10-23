///|
/// 沙箱配置 | Sandbox configuration
pub(all) struct SandboxConfig {
  work_dir : String
  timeout_ms : Int
  max_memory_mb : Int
  isolated : Bool
  read_only : Bool
} derive(Debug, Eq)

pub extend SandboxConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SandboxConfig with Eq::{not_equal, equal}

///|
/// 沙箱执行结果 | Sandbox execution result
pub(all) struct SandboxResult {
  success : Bool
  exit_code : Int
  stdout : String
  stderr : String
  duration_ms : Int
  timed_out : Bool
} derive(Debug, Eq)

pub extend SandboxResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SandboxResult with Eq::{not_equal, equal}

///|
/// 默认沙箱配置 | Default sandbox configuration
pub fn default_sandbox_config() -> SandboxConfig {
  { work_dir: ".moon-cross-sandbox", timeout_ms: 60000, max_memory_mb: 512, isolated: true, read_only: false }
}

///|
/// 创建临时沙箱目录名 | Create temporary sandbox directory name
pub fn sandbox_work_dir(platform : @core.Platform) -> String {
  ".moon-cross-sandbox-" + platform.to_id()
}

///|
/// 沙箱编译命令包装 | Sandbox compile command wrapper
pub fn sandbox_compile_command(config : SandboxConfig, base_command : String) -> String {
  let mut cmd = ""
  if config.isolated {
    cmd = cmd + "cd \{config.work_dir} && "
  }
  cmd = cmd + base_command
  if config.timeout_ms > 0 {
    cmd = "timeout \{config.timeout_ms / 1000} " + cmd
  }
  cmd
}

///|
/// 沙箱清理命令 | Sandbox cleanup command
pub fn cleanup_sandbox(config : SandboxConfig) -> String {
  if config.isolated {
    "rm -rf \{config.work_dir}"
  } else {
    ""
  }
}

///|
/// 创建沙箱成功结果 | Create sandbox success result
pub fn sandbox_success(stdout : String, duration_ms : Int) -> SandboxResult {
  { success: true, exit_code: 0, stdout, stderr: "", duration_ms, timed_out: false }
}

///|
/// 创建沙箱失败结果 | Create sandbox failure result
pub fn sandbox_failure(exit_code : Int, stderr : String, duration_ms : Int) -> SandboxResult {
  { success: false, exit_code, stdout: "", stderr, duration_ms, timed_out: false }
}

///|
/// 创建沙箱超时结果 | Create sandbox timeout result
pub fn sandbox_timeout(timeout_ms : Int) -> SandboxResult {
  { success: false, exit_code: 124, stdout: "", stderr: "Execution timed out after \{timeout_ms}ms", duration_ms: timeout_ms, timed_out: true }
}

///|
/// 检查沙箱配置安全性 | Check sandbox config safety
pub fn validate_sandbox_config(config : SandboxConfig) -> String? {
  if config.timeout_ms <= 0 {
    Some("timeout must be positive")
  } else if config.max_memory_mb <= 0 {
    Some("max memory must be positive")
  } else if config.work_dir.length() == 0 {
    Some("work directory must not be empty")
  } else {
    None
  }
}

///|
/// 沙箱版本 | Sandbox version
pub fn sandbox_version() -> String {
  "moon-cross security/sandbox v0.0.9"
}