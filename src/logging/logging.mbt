///|
/// 日志级别 | Log level
pub(all) enum LogLevel {
  Debug
  Info
  Warn
  Error
  Fatal
} derive(Debug, Eq)
pub extend LogLevel with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LogLevel with Eq::{not_equal, equal}

///|
/// 日志条目 | Log entry
pub(all) struct LogEntry {
  level : LogLevel
  message : String
  timestamp : Int
  source : String
  context : String
} derive(Debug, Eq)
pub extend LogEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LogEntry with Eq::{not_equal, equal}

///|
/// 日志配置 | Log configuration
pub(all) struct LogConfig {
  min_level : LogLevel
  include_timestamp : Bool
  include_source : Bool
  max_entries : Int
} derive(Debug, Eq)
pub extend LogConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LogConfig with Eq::{not_equal, equal}

///|
/// 日志统计 | Log statistics
pub(all) struct LogStats {
  total_entries : Int
  debug_count : Int
  info_count : Int
  warn_count : Int
  error_count : Int
  fatal_count : Int
  dropped_count : Int
} derive(Debug, Eq)
pub extend LogStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LogStats with Eq::{not_equal, equal}

///|
/// 日志器 | Logger
pub(all) struct Logger {
  config : LogConfig
  entries : Array[LogEntry]
  stats : LogStats
} derive(Debug, Eq)
pub extend Logger with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Logger with Eq::{not_equal, equal}

///|
/// 日志级别数值 | Log level numeric value
pub fn log_level_value(level : LogLevel) -> Int {
  match level {
    Debug => 0
    Info => 1
    Warn => 2
    Error => 3
    Fatal => 4
  }
}

///|
/// 日志级别名称 | Log level name
pub fn log_level_name(level : LogLevel) -> String {
  match level {
    Debug => "DEBUG"
    Info => "INFO"
    Warn => "WARN"
    Error => "ERROR"
    Fatal => "FATAL"
  }
}

///|
/// 从数值创建日志级别 | Create log level from value
pub fn log_level_from_value(value : Int) -> LogLevel {
  if value >= 4 {
    Fatal
  } else if value == 3 {
    Error
  } else if value == 2 {
    Warn
  } else if value == 1 {
    Info
  } else {
    Debug
  }
}

///|
/// 默认日志配置 | Default log config
pub fn default_log_config() -> LogConfig {
  { min_level: Info, include_timestamp: true, include_source: true, max_entries: 1000 }
}

///|
/// 创建日志器 | Create logger
pub fn create_logger(config : LogConfig) -> Logger {
  {
    config,
    entries: [],
    stats: { total_entries: 0, debug_count: 0, info_count: 0, warn_count: 0, error_count: 0, fatal_count: 0, dropped_count: 0 },
  }
}

///|
/// 日志级别是否启用 | Is log level enabled
pub fn log_is_enabled(logger : Logger, level : LogLevel) -> Bool {
  log_level_value(level) >= log_level_value(logger.config.min_level)
}

///|
/// 记数器增量 | Increment count for level
fn inc_count(stats : LogStats, level : LogLevel) -> LogStats {
  match level {
    Debug => { ..stats, debug_count: stats.debug_count + 1 }
    Info => { ..stats, info_count: stats.info_count + 1 }
    Warn => { ..stats, warn_count: stats.warn_count + 1 }
    Error => { ..stats, error_count: stats.error_count + 1 }
    Fatal => { ..stats, fatal_count: stats.fatal_count + 1 }
  }
}

///|
/// 写日志 | Write log
pub fn log_at(
  logger : Logger,
  level : LogLevel,
  message : String,
  timestamp : Int,
  source : String,
  context : String,
) -> Logger {
  if !log_is_enabled(logger, level) {
    return { ..logger, stats: { ..logger.stats, dropped_count: logger.stats.dropped_count + 1 } }
  }
  let entry = { level, message, timestamp, source, context }
  let new_entries = []
  for e in logger.entries {
    new_entries.push(e)
  }
  new_entries.push(entry)
  let mut dropped = 0
  let final_entries = new_entries
  while final_entries.length() > logger.config.max_entries {
    let _ = final_entries.remove(0)
    dropped = dropped + 1
  }
  {
    config: logger.config,
    entries: final_entries,
    stats: {
      total_entries: logger.stats.total_entries + 1,
      debug_count: inc_count(logger.stats, level).debug_count,
      info_count: inc_count(logger.stats, level).info_count,
      warn_count: inc_count(logger.stats, level).warn_count,
      error_count: inc_count(logger.stats, level).error_count,
      fatal_count: inc_count(logger.stats, level).fatal_count,
      dropped_count: logger.stats.dropped_count + dropped,
    },
  }
}

///|
/// Debug 日志 | Debug log
pub fn log_debug(logger : Logger, message : String, timestamp : Int, source : String) -> Logger {
  log_at(logger, Debug, message, timestamp, source, "")
}

///|
/// Info 日志 | Info log
pub fn log_info(logger : Logger, message : String, timestamp : Int, source : String) -> Logger {
  log_at(logger, Info, message, timestamp, source, "")
}

///|
/// Warn 日志 | Warn log
pub fn log_warn(logger : Logger, message : String, timestamp : Int, source : String) -> Logger {
  log_at(logger, Warn, message, timestamp, source, "")
}

///|
/// Error 日志 | Error log
pub fn log_error(logger : Logger, message : String, timestamp : Int, source : String) -> Logger {
  log_at(logger, Error, message, timestamp, source, "")
}

///|
/// Fatal 日志 | Fatal log
pub fn log_fatal(logger : Logger, message : String, timestamp : Int, source : String) -> Logger {
  log_at(logger, Fatal, message, timestamp, source, "")
}

///|
/// 日志条目数 | Log entry count
pub fn log_count(logger : Logger) -> Int {
  logger.entries.length()
}

///|
/// 按级别过滤 | Filter by level
pub fn log_filter_by_level(logger : Logger, level : LogLevel) -> Array[LogEntry] {
  let result = []
  for e in logger.entries {
    if e.level == level {
      result.push(e)
    }
  }
  result
}

///|
/// 按来源过滤 | Filter by source
pub fn log_filter_by_source(logger : Logger, source : String) -> Array[LogEntry] {
  let result = []
  for e in logger.entries {
    if e.source == source {
      result.push(e)
    }
  }
  result
}

///|
/// 按消息包含过滤 | Filter by message contains
pub fn log_filter_by_message(logger : Logger, keyword : String) -> Array[LogEntry] {
  let result = []
  for e in logger.entries {
    if e.message.contains(keyword) {
      result.push(e)
    }
  }
  result
}

///|
/// 清空日志 | Clear logs
pub fn log_clear(logger : Logger) -> Logger {
  { ..logger, entries: [] }
}

///|
/// 日志统计 | Log statistics
pub fn log_stats(logger : Logger) -> LogStats {
  logger.stats
}

///|
/// 格式化日志条目 | Format log entry
pub fn log_format_entry(entry : LogEntry, config : LogConfig) -> String {
  let level_str = log_level_name(entry.level)
  let mut result = "[" + level_str + "] " + entry.message
  if config.include_timestamp {
    let ts_str = entry.timestamp.to_string()
    result = "[" + ts_str + "] " + result
  }
  if config.include_source && entry.source.length() > 0 {
    result = result + " (" + entry.source + ")"
  }
  if entry.context.length() > 0 {
    result = result + " {" + entry.context + "}"
  }
  result
}

///|
/// 获取最后 N 条日志 | Get last N entries
pub fn log_last_n(logger : Logger, n : Int) -> Array[LogEntry] {
  let total = logger.entries.length()
  let start = if total > n { total - n } else { 0 }
  let result = []
  for i in start..<total {
    result.push(logger.entries[i])
  }
  result
}

///|
/// 合并日志器 | Merge loggers
pub fn merge_loggers(l1 : Logger, l2 : Logger) -> Logger {
  let new_entries = []
  for e in l1.entries {
    new_entries.push(e)
  }
  for e in l2.entries {
    new_entries.push(e)
  }
  {
    config: l1.config,
    entries: new_entries,
    stats: {
      total_entries: l1.stats.total_entries + l2.stats.total_entries,
      debug_count: l1.stats.debug_count + l2.stats.debug_count,
      info_count: l1.stats.info_count + l2.stats.info_count,
      warn_count: l1.stats.warn_count + l2.stats.warn_count,
      error_count: l1.stats.error_count + l2.stats.error_count,
      fatal_count: l1.stats.fatal_count + l2.stats.fatal_count,
      dropped_count: l1.stats.dropped_count + l2.stats.dropped_count,
    },
  }
}

///|
/// 日志版本 | Logger version
pub fn log_version() -> String {
  "moon-cross logging v0.2.18"
}