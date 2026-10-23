test "log_level_to_string" {
  assert_eq(@trace.LogLevel::Trace.to_string(), "TRACE")
  assert_eq(@trace.LogLevel::Debug.to_string(), "DEBUG")
  assert_eq(@trace.LogLevel::Info.to_string(), "INFO")
  assert_eq(@trace.LogLevel::Warn.to_string(), "WARN")
  assert_eq(@trace.LogLevel::Error.to_string(), "ERROR")
  assert_eq(@trace.LogLevel::Fatal.to_string(), "FATAL")
}

test "log_level_to_int" {
  assert_eq(@trace.LogLevel::Trace.to_int(), 0)
  assert_eq(@trace.LogLevel::Debug.to_int(), 1)
  assert_eq(@trace.LogLevel::Info.to_int(), 2)
  assert_eq(@trace.LogLevel::Warn.to_int(), 3)
  assert_eq(@trace.LogLevel::Error.to_int(), 4)
  assert_eq(@trace.LogLevel::Fatal.to_int(), 5)
}

test "log_level_from_int" {
  assert_eq(@trace.log_level_from_int(0), @trace.LogLevel::Trace)
  assert_eq(@trace.log_level_from_int(1), @trace.LogLevel::Debug)
  assert_eq(@trace.log_level_from_int(2), @trace.LogLevel::Info)
  assert_eq(@trace.log_level_from_int(3), @trace.LogLevel::Warn)
  assert_eq(@trace.log_level_from_int(4), @trace.LogLevel::Error)
  assert_eq(@trace.log_level_from_int(5), @trace.LogLevel::Fatal)
  assert_eq(@trace.log_level_from_int(99), @trace.LogLevel::Fatal)
}

test "default_trace_config" {
  let cfg = @trace.default_trace_config()
  assert_true(cfg.enabled)
  assert_eq(cfg.min_level, @trace.LogLevel::Info)
  assert_eq(cfg.max_events, 1000)
  assert_eq(cfg.output_format, "text")
}

test "debug_trace_config" {
  let cfg = @trace.debug_trace_config()
  assert_true(cfg.enabled)
  assert_eq(cfg.min_level, @trace.LogLevel::Debug)
  assert_eq(cfg.max_events, 5000)
  assert_eq(cfg.output_format, "json")
}

test "production_trace_config" {
  let cfg = @trace.production_trace_config()
  assert_true(cfg.enabled)
  assert_eq(cfg.min_level, @trace.LogLevel::Warn)
  assert_eq(cfg.max_events, 500)
}

test "make_event_basic" {
  let event = @trace.make_event(100, @trace.LogLevel::Info, "codegen", "Generating C code")
  assert_eq(event.timestamp_ms, 100)
  assert_eq(event.level, @trace.LogLevel::Info)
  assert_eq(event.source, "codegen")
  assert_eq(event.message, "Generating C code")
}

test "make_span_basic" {
  let span = @trace.make_span("compile", 0, 100, None)
  assert_eq(span.name, "compile")
  assert_eq(span.start_ms, 0)
  assert_eq(span.end_ms, 100)
  assert_eq(span.events.length(), 0)
}

test "make_span_with_parent" {
  let span = @trace.make_span("compile_c", 10, 50, Some("compile"))
  assert_eq(span.parent, Some("compile"))
}

test "create_collector_basic" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  assert_eq(collector.events.length(), 0)
  assert_eq(collector.spans.length(), 0)
  assert_eq(collector.current_ms, 0)
}

test "is_level_enabled_default" {
  let cfg = @trace.default_trace_config()
  assert_true(!@trace.is_level_enabled(cfg, @trace.LogLevel::Trace))
  assert_true(!@trace.is_level_enabled(cfg, @trace.LogLevel::Debug))
  assert_true(@trace.is_level_enabled(cfg, @trace.LogLevel::Info))
  assert_true(@trace.is_level_enabled(cfg, @trace.LogLevel::Warn))
  assert_true(@trace.is_level_enabled(cfg, @trace.LogLevel::Error))
}

test "is_level_enabled_disabled" {
  let cfg : @trace.TraceConfig = {
    enabled: false,
    min_level: @trace.LogLevel::Trace,
    max_events: 100,
    output_format: "text",
  }
  assert_true(!@trace.is_level_enabled(cfg, @trace.LogLevel::Info))
}

test "span_duration_basic" {
  let span = @trace.make_span("test", 100, 250, None)
  assert_eq(@trace.span_duration(span), 150)
}

test "add_event_to_span" {
  let span = @trace.make_span("test", 0, 100, None)
  let event = @trace.make_event(50, @trace.LogLevel::Info, "test", "midpoint")
  let updated = @trace.add_event_to_span(span, event)
  assert_eq(updated.events.length(), 1)
}

test "emit_event_basic" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let event = @trace.make_event(0, @trace.LogLevel::Info, "test", "hello")
  let updated = @trace.emit_event(collector, event)
  assert_eq(updated.events.length(), 1)
}

test "emit_event_filtered_by_level" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let event = @trace.make_event(0, @trace.LogLevel::Debug, "test", "debug msg")
  let updated = @trace.emit_event(collector, event)
  assert_eq(updated.events.length(), 0)
}

test "emit_event_max_events" {
  let cfg : @trace.TraceConfig = {
    enabled: true,
    min_level: @trace.LogLevel::Trace,
    max_events: 2,
    output_format: "text",
  }
  let collector = @trace.create_collector(cfg)
  let e1 = @trace.make_event(0, @trace.LogLevel::Info, "t", "1")
  let e2 = @trace.make_event(1, @trace.LogLevel::Info, "t", "2")
  let e3 = @trace.make_event(2, @trace.LogLevel::Info, "t", "3")
  let c1 = @trace.emit_event(collector, e1)
  let c2 = @trace.emit_event(c1, e2)
  let c3 = @trace.emit_event(c2, e3)
  assert_eq(c3.events.length(), 2)
}

test "emit_span_basic" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let span = @trace.make_span("test", 0, 100, None)
  let updated = @trace.emit_span(collector, span)
  assert_eq(updated.spans.length(), 1)
}

test "advance_time" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let c1 = @trace.advance_time(collector, 100)
  assert_eq(c1.current_ms, 100)
  let c2 = @trace.advance_time(c1, 50)
  assert_eq(c2.current_ms, 150)
}

test "log_quick" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let c1 = @trace.log(collector, @trace.LogLevel::Info, "codegen", "started")
  assert_eq(c1.events.length(), 1)
  assert_eq(c1.events[0].source, "codegen")
}

test "log_filtered" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let c1 = @trace.log(collector, @trace.LogLevel::Trace, "test", "trace msg")
  assert_eq(c1.events.length(), 0)
}

test "filter_by_level" {
  let events = [
    @trace.make_event(0, @trace.LogLevel::Debug, "t", "d"),
    @trace.make_event(1, @trace.LogLevel::Info, "t", "i"),
    @trace.make_event(2, @trace.LogLevel::Error, "t", "e"),
  ]
  let filtered = @trace.filter_by_level(events, @trace.LogLevel::Info)
  assert_eq(filtered.length(), 2)
}

test "filter_by_source" {
  let events = [
    @trace.make_event(0, @trace.LogLevel::Info, "codegen", "1"),
    @trace.make_event(1, @trace.LogLevel::Info, "ffi", "2"),
    @trace.make_event(2, @trace.LogLevel::Info, "codegen", "3"),
  ]
  let filtered = @trace.filter_by_source(events, "codegen")
  assert_eq(filtered.length(), 2)
}

test "format_event_basic" {
  let event = @trace.make_event(100, @trace.LogLevel::Info, "codegen", "Generating")
  let formatted = @trace.format_event(event)
  assert_true(formatted.contains("100"))
  assert_true(formatted.contains("INFO"))
  assert_true(formatted.contains("codegen"))
  assert_true(formatted.contains("Generating"))
}

test "format_span_basic" {
  let span = @trace.make_span("compile", 0, 100, None)
  let formatted = @trace.format_span(span)
  assert_true(formatted.contains("compile"))
  assert_true(formatted.contains("100"))
}

test "format_summary_basic" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let c1 = @trace.log(collector, @trace.LogLevel::Info, "t", "info")
  let c2 = @trace.log(c1, @trace.LogLevel::Warn, "t", "warn")
  let c3 = @trace.log(c2, @trace.LogLevel::Error, "t", "error")
  assert_eq(c3.events.length(), 3)
  let summary = @trace.format_summary(c3)
  assert_true(summary.contains("Total events:"))
  assert_true(summary.contains("Warnings:"))
  assert_true(summary.contains("Errors:"))
}

test "event_to_json" {
  let event = @trace.make_event(100, @trace.LogLevel::Info, "codegen", "test")
  let json = @trace.event_to_json(event)
  assert_true(json.contains("100"))
  assert_true(json.contains("INFO"))
  assert_true(json.contains("codegen"))
  assert_true(json.contains("test"))
}

test "trace_version" {
  let v = @trace.trace_version()
  assert_true(v.contains("trace"))
}

test "count_errors" {
  let events = [
    @trace.make_event(0, @trace.LogLevel::Info, "t", "i"),
    @trace.make_event(1, @trace.LogLevel::Error, "t", "e"),
    @trace.make_event(2, @trace.LogLevel::Fatal, "t", "f"),
    @trace.make_event(3, @trace.LogLevel::Warn, "t", "w"),
  ]
  assert_eq(@trace.count_errors(events), 2)
}

test "count_warnings" {
  let events = [
    @trace.make_event(0, @trace.LogLevel::Info, "t", "i"),
    @trace.make_event(1, @trace.LogLevel::Warn, "t", "w1"),
    @trace.make_event(2, @trace.LogLevel::Warn, "t", "w2"),
    @trace.make_event(3, @trace.LogLevel::Error, "t", "e"),
  ]
  assert_eq(@trace.count_warnings(events), 2)
}

test "find_slowest_span" {
  let spans = [
    @trace.make_span("fast", 0, 10, None),
    @trace.make_span("slow", 0, 100, None),
    @trace.make_span("medium", 0, 50, None),
  ]
  match @trace.find_slowest_span(spans) {
    Some(s) => assert_eq(s.name, "slow")
    None => assert_true(false)
  }
}

test "find_fastest_span" {
  let spans = [
    @trace.make_span("fast", 0, 10, None),
    @trace.make_span("slow", 0, 100, None),
    @trace.make_span("medium", 0, 50, None),
  ]
  match @trace.find_fastest_span(spans) {
    Some(s) => assert_eq(s.name, "fast")
    None => assert_true(false)
  }
}

test "find_slowest_span_empty" {
  let spans : Array[@trace.TraceSpan] = []
  match @trace.find_slowest_span(spans) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "find_fastest_span_empty" {
  let spans : Array[@trace.TraceSpan] = []
  match @trace.find_fastest_span(spans) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "total_duration" {
  let spans = [
    @trace.make_span("a", 0, 10, None),
    @trace.make_span("b", 0, 20, None),
    @trace.make_span("c", 0, 30, None),
  ]
  assert_eq(@trace.total_duration(spans), 60)
}

test "has_errors_true" {
  let events = [
    @trace.make_event(0, @trace.LogLevel::Info, "t", "i"),
    @trace.make_event(1, @trace.LogLevel::Error, "t", "e"),
  ]
  assert_true(@trace.has_errors(events))
}

test "has_errors_false" {
  let events = [
    @trace.make_event(0, @trace.LogLevel::Info, "t", "i"),
    @trace.make_event(1, @trace.LogLevel::Warn, "t", "w"),
  ]
  assert_true(!@trace.has_errors(events))
}

test "full_workflow" {
  let cfg = @trace.default_trace_config()
  let collector = @trace.create_collector(cfg)
  let c1 = @trace.log(collector, @trace.LogLevel::Info, "init", "Starting build")
  let c2 = @trace.advance_time(c1, 50)
  let c3 = @trace.log(c2, @trace.LogLevel::Info, "codegen", "C code generated")
  let c4 = @trace.advance_time(c3, 100)
  let c5 = @trace.log(c4, @trace.LogLevel::Warn, "ffi", "JNI binding fallback")
  let c6 = @trace.advance_time(c5, 30)
  let c7 = @trace.log(c6, @trace.LogLevel::Info, "package", "Build complete")
  assert_eq(c7.events.length(), 4)
  assert_eq(c7.current_ms, 180)
  assert_true(@trace.count_warnings(c7.events) == 1)
  assert_true(!@trace.has_errors(c7.events))
}
