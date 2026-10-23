test "log_level_value" {
  assert_eq(@logging.log_level_value(@logging.LogLevel::Debug), 0)
  assert_eq(@logging.log_level_value(@logging.LogLevel::Info), 1)
  assert_eq(@logging.log_level_value(@logging.LogLevel::Warn), 2)
  assert_eq(@logging.log_level_value(@logging.LogLevel::Error), 3)
  assert_eq(@logging.log_level_value(@logging.LogLevel::Fatal), 4)
}

test "log_level_name" {
  assert_eq(@logging.log_level_name(@logging.LogLevel::Debug), "DEBUG")
  assert_eq(@logging.log_level_name(@logging.LogLevel::Info), "INFO")
  assert_eq(@logging.log_level_name(@logging.LogLevel::Warn), "WARN")
  assert_eq(@logging.log_level_name(@logging.LogLevel::Error), "ERROR")
  assert_eq(@logging.log_level_name(@logging.LogLevel::Fatal), "FATAL")
}

test "log_level_from_value" {
  assert_eq(@logging.log_level_from_value(0), @logging.LogLevel::Debug)
  assert_eq(@logging.log_level_from_value(1), @logging.LogLevel::Info)
  assert_eq(@logging.log_level_from_value(2), @logging.LogLevel::Warn)
  assert_eq(@logging.log_level_from_value(3), @logging.LogLevel::Error)
  assert_eq(@logging.log_level_from_value(4), @logging.LogLevel::Fatal)
  assert_eq(@logging.log_level_from_value(5), @logging.LogLevel::Fatal)
}

test "default_log_config" {
  let cfg = @logging.default_log_config()
  assert_eq(cfg.min_level, @logging.LogLevel::Info)
  assert_true(cfg.include_timestamp)
  assert_true(cfg.include_source)
}

test "create_logger" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  assert_eq(@logging.log_count(logger), 0)
}

test "log_is_enabled" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  assert_false(@logging.log_is_enabled(logger, @logging.LogLevel::Debug))
  assert_true(@logging.log_is_enabled(logger, @logging.LogLevel::Info))
  assert_true(@logging.log_is_enabled(logger, @logging.LogLevel::Warn))
  assert_true(@logging.log_is_enabled(logger, @logging.LogLevel::Error))
  assert_true(@logging.log_is_enabled(logger, @logging.LogLevel::Fatal))
}

test "log_info" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "test message", 1000, "test_source")
  assert_eq(@logging.log_count(logger1), 1)
}

test "log_debug_filtered" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_debug(logger, "debug message", 1000, "test_source")
  assert_eq(@logging.log_count(logger1), 0)
  let s = @logging.log_stats(logger1)
  assert_eq(s.dropped_count, 1)
}

test "log_warn" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_warn(logger, "warning", 1000, "src")
  assert_eq(@logging.log_count(logger1), 1)
}

test "log_error" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_error(logger, "error msg", 1000, "src")
  assert_eq(@logging.log_count(logger1), 1)
}

test "log_fatal" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_fatal(logger, "fatal msg", 1000, "src")
  assert_eq(@logging.log_count(logger1), 1)
}

test "log_at_with_context" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_at(logger, @logging.LogLevel::Info, "msg", 1000, "src", "ctx")
  assert_eq(@logging.log_count(logger1), 1)
}

test "log_multiple" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "msg1", 1000, "src")
  let logger2 = @logging.log_info(logger1, "msg2", 2000, "src")
  let logger3 = @logging.log_warn(logger2, "msg3", 3000, "src")
  assert_eq(@logging.log_count(logger3), 3)
}

test "log_filter_by_level" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "info", 1000, "src")
  let logger2 = @logging.log_warn(logger1, "warn", 2000, "src")
  let logger3 = @logging.log_error(logger2, "error", 3000, "src")
  let warnings = @logging.log_filter_by_level(logger3, @logging.LogLevel::Warn)
  assert_eq(warnings.length(), 1)
}

test "log_filter_by_source" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "msg1", 1000, "src1")
  let logger2 = @logging.log_info(logger1, "msg2", 2000, "src2")
  let logger3 = @logging.log_info(logger2, "msg3", 3000, "src1")
  let filtered = @logging.log_filter_by_source(logger3, "src1")
  assert_eq(filtered.length(), 2)
}

test "log_filter_by_message" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "error occurred", 1000, "src")
  let logger2 = @logging.log_info(logger1, "all good", 2000, "src")
  let logger3 = @logging.log_info(logger2, "another error", 3000, "src")
  let filtered = @logging.log_filter_by_message(logger3, "error")
  assert_eq(filtered.length(), 2)
}

test "log_clear" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "msg", 1000, "src")
  let logger2 = @logging.log_clear(logger1)
  assert_eq(@logging.log_count(logger2), 0)
}

test "log_stats" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "info", 1000, "src")
  let logger2 = @logging.log_warn(logger1, "warn", 2000, "src")
  let logger3 = @logging.log_error(logger2, "error", 3000, "src")
  let s = @logging.log_stats(logger3)
  assert_eq(s.total_entries, 3)
  assert_eq(s.info_count, 1)
  assert_eq(s.warn_count, 1)
  assert_eq(s.error_count, 1)
}

test "log_format_entry" {
  let cfg = @logging.default_log_config()
  let entry = @logging.LogEntry::{ level: @logging.LogLevel::Info, message: "test", timestamp: 1000, source: "src", context: "" }
  let formatted = @logging.log_format_entry(entry, cfg)
  assert_true(formatted.contains("INFO"))
  assert_true(formatted.contains("test"))
  assert_true(formatted.contains("src"))
}

test "log_format_entry_with_context" {
  let cfg = @logging.default_log_config()
  let entry = @logging.LogEntry::{ level: @logging.LogLevel::Error, message: "fail", timestamp: 2000, source: "db", context: "query=SELECT" }
  let formatted = @logging.log_format_entry(entry, cfg)
  assert_true(formatted.contains("ERROR"))
  assert_true(formatted.contains("query=SELECT"))
}

test "log_last_n" {
  let cfg = @logging.default_log_config()
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "msg1", 1000, "src")
  let logger2 = @logging.log_info(logger1, "msg2", 2000, "src")
  let logger3 = @logging.log_info(logger2, "msg3", 3000, "src")
  let last = @logging.log_last_n(logger3, 2)
  assert_eq(last.length(), 2)
  assert_eq(last[0].message, "msg2")
  assert_eq(last[1].message, "msg3")
}

test "log_max_entries_eviction" {
  let cfg = @logging.LogConfig::{ min_level: @logging.LogLevel::Debug, include_timestamp: true, include_source: true, max_entries: 3 }
  let logger = @logging.create_logger(cfg)
  let logger1 = @logging.log_info(logger, "msg1", 1000, "src")
  let logger2 = @logging.log_info(logger1, "msg2", 2000, "src")
  let logger3 = @logging.log_info(logger2, "msg3", 3000, "src")
  let logger4 = @logging.log_info(logger3, "msg4", 4000, "src")
  assert_eq(@logging.log_count(logger4), 3)
}

test "merge_loggers" {
  let cfg = @logging.default_log_config()
  let l1 = @logging.create_logger(cfg)
  let l2 = @logging.create_logger(cfg)
  let l1a = @logging.log_info(l1, "msg1", 1000, "src")
  let l2a = @logging.log_info(l2, "msg2", 2000, "src")
  let merged = @logging.merge_loggers(l1a, l2a)
  assert_eq(@logging.log_count(merged), 2)
}

test "log_version" {
  let v = @logging.log_version()
  assert_true(v.contains("logging"))
}