///|
/// 日志级别 | Log level
pub(all) enum LogLevel {
  Trace
  Debug
  Info
  Warn
  Error
  Fatal
} derive(Debug, Eq)
pub extend LogLevel with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LogLevel with Eq::{not_equal, equal}

///|
/// 日志级别转字符串 | Convert log level to string
pub fn LogLevel::to_string(self : LogLevel) -> String {
  match self {
    Trace => "TRACE"
    Debug => "DEBUG"
    Info => "INFO"
    Warn => "WARN"
    Error => "ERROR"
    Fatal => "FATAL"
  }
}

///|
/// 日志级别转数值 | Convert log level to numeric value
pub fn LogLevel::to_int(self : LogLevel) -> Int {
  match self {
    Trace => 0
    Debug => 1
    Info => 2
    Warn => 3
    Error => 4
    Fatal => 5
  }
}

///|
/// 从数值创建日志级别 | Create log level from numeric value
pub fn log_level_from_int(value : Int) -> LogLevel {
  match value {
    0 => Trace
    1 => Debug
    2 => Info
    3 => Warn
    4 => Error
    _ => Fatal
  }
}

///|
/// 追踪事件 | Trace event
pub(all) struct TraceEvent {
  timestamp_ms : Int
  level : LogLevel
  source : String
  message : String
} derive(Debug, Eq)
pub extend TraceEvent with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TraceEvent with Eq::{not_equal, equal}

///|
/// 追踪区间 | Trace span
pub(all) struct TraceSpan {
  name : String
  start_ms : Int
  end_ms : Int
  events : Array[TraceEvent]
  parent : String?
} derive(Debug, Eq)
pub extend TraceSpan with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TraceSpan with Eq::{not_equal, equal}

///|
/// 追踪配置 | Trace configuration
pub(all) struct TraceConfig {
  enabled : Bool
  min_level : LogLevel
  max_events : Int
  output_format : String
} derive(Debug, Eq)
pub extend TraceConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TraceConfig with Eq::{not_equal, equal}

///|
/// 追踪收集器 | Trace collector
pub(all) struct TraceCollector {
  config : TraceConfig
  events : Array[TraceEvent]
  spans : Array[TraceSpan]
  current_ms : Int
} derive(Debug, Eq)
pub extend TraceCollector with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TraceCollector with Eq::{not_equal, equal}

///|
/// 默认追踪配置 | Default trace configuration
pub fn default_trace_config() -> TraceConfig {
  { enabled: true, min_level: Info, max_events: 1000, output_format: "text" }
}

///|
/// 调试追踪配置 | Debug trace configuration
pub fn debug_trace_config() -> TraceConfig {
  { enabled: true, min_level: Debug, max_events: 5000, output_format: "json" }
}

///|
/// 生产追踪配置 | Production trace configuration
pub fn production_trace_config() -> TraceConfig {
  { enabled: true, min_level: Warn, max_events: 500, output_format: "json" }
}

///|
/// 创建追踪事件 | Create trace event
pub fn make_event(
  timestamp_ms : Int,
  level : LogLevel,
  source : String,
  message : String,
) -> TraceEvent {
  { timestamp_ms, level, source, message }
}

///|
/// 创建追踪区间 | Create trace span
pub fn make_span(
  name : String,
  start_ms : Int,
  end_ms : Int,
  parent : String?,
) -> TraceSpan {
  { name, start_ms, end_ms, events: [], parent }
}

///|
/// 创建追踪收集器 | Create trace collector
pub fn create_collector(config : TraceConfig) -> TraceCollector {
  { config, events: [], spans: [], current_ms: 0 }
}

///|
/// 检查日志级别是否启用 | Check if log level is enabled
pub fn is_level_enabled(
  config : TraceConfig,
  level : LogLevel,
) -> Bool {
  config.enabled && level.to_int() >= config.min_level.to_int()
}

///|
/// 记算区间持续时间 | Calculate span duration
pub fn span_duration(span : TraceSpan) -> Int {
  span.end_ms - span.start_ms
}

///|
/// 向区间添加事件 | Add event to span
pub fn add_event_to_span(
  span : TraceSpan,
  event : TraceEvent,
) -> TraceSpan {
  let new_events = []
  for e in span.events {
    new_events.push(e)
  }
  new_events.push(event)
  { ..span, events: new_events }
}

///|
/// 向收集器添加事件 | Add event to collector
pub fn emit_event(
  collector : TraceCollector,
  event : TraceEvent,
) -> TraceCollector {
  if !is_level_enabled(collector.config, event.level) {
    return collector
  }
  if collector.events.length() >= collector.config.max_events {
    return collector
  }
  let new_events = []
  for e in collector.events {
    new_events.push(e)
  }
  new_events.push(event)
  { ..collector, events: new_events }
}

///|
/// 向收集器添加区间 | Add span to collector
pub fn emit_span(
  collector : TraceCollector,
  span : TraceSpan,
) -> TraceCollector {
  let new_spans = []
  for s in collector.spans {
    new_spans.push(s)
  }
  new_spans.push(span)
  { ..collector, spans: new_spans }
}

///|
/// 推进时间 | Advance time
pub fn advance_time(
  collector : TraceCollector,
  delta_ms : Int,
) -> TraceCollector {
  { ..collector, current_ms: collector.current_ms + delta_ms }
}

///|
/// 快速发送日志 | Quick emit log
pub fn log(
  collector : TraceCollector,
  level : LogLevel,
  source : String,
  message : String,
) -> TraceCollector {
  let event = make_event(collector.current_ms, level, source, message)
  emit_event(collector, event)
}

///|
/// 按级别过滤事件 | Filter events by level
pub fn filter_by_level(
  events : Array[TraceEvent],
  min_level : LogLevel,
) -> Array[TraceEvent] {
  let result = []
  for e in events {
    if e.level.to_int() >= min_level.to_int() {
      result.push(e)
    }
  }
  result
}

///|
/// 按来源过滤事件 | Filter events by source
pub fn filter_by_source(
  events : Array[TraceEvent],
  source : String,
) -> Array[TraceEvent] {
  let result = []
  for e in events {
    if e.source == source {
      result.push(e)
    }
  }
  result
}

///|
/// 格式化追踪事件 | Format trace event
pub fn format_event(event : TraceEvent) -> String {
  "[" +
  event.timestamp_ms.to_string() +
  "] [" +
  event.level.to_string() +
  "] [" +
  event.source +
  "] " +
  event.message
}

///|
/// 格式化追踪区间 | Format trace span
pub fn format_span(span : TraceSpan) -> String {
  let mut output = "Span: " + span.name + " (" + span.start_ms.to_string() + "ms - " + span.end_ms.to_string() + "ms, " + span_duration(span).to_string() + "ms)"
  if span.events.length() > 0 {
    output = output + "\n"
    for e in span.events {
      output = output + "  " + format_event(e) + "\n"
    }
  }
  output
}

///|
/// 格式化收集器摘要 | Format collector summary
pub fn format_summary(collector : TraceCollector) -> String {
  let mut output = "Trace Summary:\n"
  output = output + "  Total events: " + collector.events.length().to_string() + "\n"
  output = output + "  Total spans:  " + collector.spans.length().to_string() + "\n"
  let mut error_count = 0
  let mut warn_count = 0
  for e in collector.events {
    match e.level {
      Error => error_count = error_count + 1
      Fatal => error_count = error_count + 1
      Warn => warn_count = warn_count + 1
      _ => ()
    }
  }
  output = output + "  Warnings:      " + warn_count.to_string() + "\n"
  output = output + "  Errors:        " + error_count.to_string() + "\n"
  output
}

///|
/// 生成 JSON 格式事件 | Generate JSON format event
pub fn event_to_json(event : TraceEvent) -> String {
  "{\"ts\":" +
  event.timestamp_ms.to_string() +
  ",\"level\":\"" +
  event.level.to_string() +
  "\",\"source\":\"" +
  event.source +
  "\",\"message\":\"" +
  event.message +
  "\"}"
}

///|
/// 追踪版本 | Trace version
pub fn trace_version() -> String {
  "moon-cross trace v0.1.7"
}

///|
/// 统计错误数 | Count errors
pub fn count_errors(events : Array[TraceEvent]) -> Int {
  let mut count = 0
  for e in events {
    match e.level {
      Error => count = count + 1
      Fatal => count = count + 1
      _ => ()
    }
  }
  count
}

///|
/// 统计警告数 | Count warnings
pub fn count_warnings(events : Array[TraceEvent]) -> Int {
  let mut count = 0
  for e in events {
    match e.level {
      Warn => count = count + 1
      _ => ()
    }
  }
  count
}

///|
/// 查找最慢区间 | Find slowest span
pub fn find_slowest_span(spans : Array[TraceSpan]) -> TraceSpan? {
  if spans.length() == 0 {
    return None
  }
  let mut slowest = spans[0]
  for s in spans {
    if span_duration(s) > span_duration(slowest) {
      slowest = s
    }
  }
  Some(slowest)
}

///|
/// 查找最快区间 | Find fastest span
pub fn find_fastest_span(spans : Array[TraceSpan]) -> TraceSpan? {
  if spans.length() == 0 {
    return None
  }
  let mut fastest = spans[0]
  for s in spans {
    if span_duration(s) < span_duration(fastest) {
      fastest = s
    }
  }
  Some(fastest)
}

///|
/// 计算总持续时间 | Calculate total duration
pub fn total_duration(spans : Array[TraceSpan]) -> Int {
  let mut total = 0
  for s in spans {
    total = total + span_duration(s)
  }
  total
}

///|
/// 检查是否有错误 | Check if has errors
pub fn has_errors(events : Array[TraceEvent]) -> Bool {
  count_errors(events) > 0
}