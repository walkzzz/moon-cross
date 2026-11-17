///|
/// 重试配置 | Retry configuration
#derive(Debug, Eq)
pub(all) struct RetryConfig {
  max_attempts : Int32
  initial_delay_ms : Int32
  backoff_multiplier : Int32
  timeout_ms : Int32
}

///|
pub extend RetryConfig with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RetryConfig with Eq::{not_equal, equal}

///|
/// 重试结果 | Retry result
#derive(Debug, Eq)
pub(all) struct RetryResult {
  success : Bool
  attempts : Int32
  last_error : String?
  total_delay_ms : Int32
}

///|
pub extend RetryResult with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend RetryResult with Eq::{not_equal, equal}

///|
/// 默认重试配置 | Default retry configuration
pub fn default_retry_config() -> RetryConfig {
  {
    max_attempts: 3,
    initial_delay_ms: 100,
    backoff_multiplier: 2,
    timeout_ms: 30000,
  }
}

///|
/// 指数退避延迟计算 | Exponential backoff delay calculation
pub fn exponential_backoff(config : RetryConfig, attempt : Int32) -> Int32 {
  if attempt <= 0 {
    return 0
  }
  let mut result = config.initial_delay_ms
  let mut i = 1
  while i < attempt {
    result = result * config.backoff_multiplier
    i = i + 1
  }
  result
}

///|
/// 创建成功重试结果 | Create successful retry result
pub fn retry_success(attempts : Int32, total_delay_ms : Int32) -> RetryResult {
  { success: true, attempts, last_error: None, total_delay_ms, }
}

///|
/// 创建失败重试结果 | Create failed retry result
pub fn retry_failure(
  attempts : Int32,
  error : String,
  total_delay_ms : Int32,
) -> RetryResult {
  { success: false, attempts, last_error: Some(error), total_delay_ms, }
}

///|
/// 检查是否应继续重试 | Check if should continue retrying
pub fn should_retry(config : RetryConfig, current_attempt : Int32) -> Bool {
  current_attempt < config.max_attempts
}

///|
/// 计算总超时时间 | Calculate total timeout
pub fn total_timeout(config : RetryConfig) -> Int32 {
  let mut total = 0
  let mut i = 0
  while i < config.max_attempts {
    total = total + exponential_backoff(config, i + 1)
    i = i + 1
  }
  total
}

///|
/// 重试策略版本 | Retry strategy version
pub fn retry_version() -> String {
  "moon-cross robust/retry v0.0.8"
}

///|
/// RetryResult 实现 Checkable trait | RetryResult implements Checkable
pub impl @trait.Checkable for RetryResult with fn check(self) {
  self.success
}

///|
pub extend RetryResult with @trait.Checkable::{check}
