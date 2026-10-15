///|
/// 重试配置 | Retry configuration
pub(all) struct RetryConfig {
  max_attempts : Int
  initial_delay_ms : Int
  backoff_multiplier : Int
  timeout_ms : Int
} derive(Debug, Eq)

pub extend RetryConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RetryConfig with Eq::{not_equal, equal}

///|
/// 重试结果 | Retry result
pub(all) struct RetryResult {
  success : Bool
  attempts : Int
  last_error : String?
  total_delay_ms : Int
} derive(Debug, Eq)

pub extend RetryResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RetryResult with Eq::{not_equal, equal}

///|
/// 默认重试配置 | Default retry configuration
pub fn default_retry_config() -> RetryConfig {
  { max_attempts: 3, initial_delay_ms: 100, backoff_multiplier: 2, timeout_ms: 30000 }
}

///|
/// 指数退避延迟计算 | Exponential backoff delay calculation
pub fn exponential_backoff(config : RetryConfig, attempt : Int) -> Int {
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
pub fn retry_success(attempts : Int, total_delay_ms : Int) -> RetryResult {
  { success: true, attempts, last_error: None, total_delay_ms }
}

///|
/// 创建失败重试结果 | Create failed retry result
pub fn retry_failure(attempts : Int, error : String, total_delay_ms : Int) -> RetryResult {
  { success: false, attempts, last_error: Some(error), total_delay_ms }
}

///|
/// 检查是否应继续重试 | Check if should continue retrying
pub fn should_retry(config : RetryConfig, current_attempt : Int) -> Bool {
  current_attempt < config.max_attempts
}

///|
/// 计算总超时时间 | Calculate total timeout
pub fn total_timeout(config : RetryConfig) -> Int {
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
  "moon-cross robust/retry v0.8.0"
}