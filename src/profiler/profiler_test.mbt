test "default_profiler_config" {
  let cfg = @profiler.default_profiler_config()
  assert_true(cfg.enabled)
  assert_eq(cfg.sample_rate, 1)
  assert_true(!cfg.track_memory)
}

test "make_entry" {
  let entry = @profiler.make_entry("test_fn", 1000)
  assert_eq(entry.name, "test_fn")
  assert_eq(entry.call_count, 1)
  assert_eq(entry.total_time_ns, 1000)
  assert_eq(entry.min_time_ns, 1000)
  assert_eq(entry.max_time_ns, 1000)
}

test "average_time" {
  let entry = @profiler.make_entry("test_fn", 3000)
  let avg = @profiler.average_time(entry)
  assert_eq(avg, 3000.0)
}

test "average_time_ms" {
  let entry = @profiler.make_entry("test_fn", 3000000)
  let avg_ms = @profiler.average_time_ms(entry)
  assert_eq(avg_ms, 3.0)
}

test "total_time_ms" {
  let entry = @profiler.make_entry("test_fn", 5000000)
  let ms = @profiler.total_time_ms(entry)
  assert_eq(ms, 5.0)
}

test "total_time_sec" {
  let entry = @profiler.make_entry("test_fn", 2000000000)
  let sec = @profiler.total_time_sec(entry)
  assert_eq(sec, 2.0)
}

test "create_report" {
  let e1 = @profiler.make_entry("fn_a", 1000)
  let e2 = @profiler.make_entry("fn_b", 2000)
  let report = @profiler.create_report([e1, e2])
  assert_eq(report.total_time_ns, 3000)
  assert_eq(report.total_calls, 2)
}

test "create_report_empty" {
  let report = @profiler.create_report([])
  assert_eq(report.total_time_ns, 0)
  assert_eq(report.total_calls, 0)
}

test "find_hotspot" {
  let e1 = @profiler.make_entry("fn_a", 1000)
  let e2 = @profiler.make_entry("fn_b", 5000)
  let e3 = @profiler.make_entry("fn_c", 3000)
  let report = @profiler.create_report([e1, e2, e3])
  match @profiler.find_hotspot(report) {
    Some(h) => assert_eq(h.name, "fn_b")
    None => assert_true(false)
  }
}

test "find_hotspot_empty" {
  let report = @profiler.empty_report()
  match @profiler.find_hotspot(report) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "sort_by_total_time" {
  let e1 = @profiler.make_entry("a", 100)
  let e2 = @profiler.make_entry("b", 500)
  let e3 = @profiler.make_entry("c", 300)
  let sorted = @profiler.sort_by_total_time([e1, e2, e3])
  assert_eq(sorted[0].name, "b")
  assert_eq(sorted[1].name, "c")
  assert_eq(sorted[2].name, "a")
}

test "sort_by_call_count" {
  let e1 = @profiler.make_entry("a", 100)
  let e2 = @profiler.make_entry("b", 200)
  let sorted = @profiler.sort_by_call_count([e1, e2])
  assert_eq(sorted[0].name, "a")
  assert_eq(sorted[1].name, "b")
}

test "merge_entries" {
  let e1 = @profiler.make_entry("fn_a", 1000)
  let e2 = @profiler.make_entry("fn_a", 2000)
  let e3 = @profiler.make_entry("fn_b", 500)
  let merged = @profiler.merge_entries([e1, e2, e3])
  assert_eq(merged.length(), 2)
}

test "summary_stats" {
  let e1 = @profiler.make_entry("fn_a", 1000)
  let e2 = @profiler.make_entry("fn_b", 3000)
  let report = @profiler.create_report([e1, e2])
  let stats = @profiler.summary_stats(report)
  assert_eq(stats.total_calls, 2)
  assert_eq(stats.total_time_ns, 4000)
  assert_eq(stats.hottest_function, "fn_b")
}

test "summary_stats_empty" {
  let report = @profiler.empty_report()
  let stats = @profiler.summary_stats(report)
  assert_eq(stats.total_calls, 0)
  assert_eq(stats.hottest_function, "")
}

test "format_report_text" {
  let e1 = @profiler.make_entry("fn_a", 1000000)
  let report = @profiler.create_report([e1])
  let text = @profiler.format_report_text(report)
  assert_true(text.contains("Profile Report"))
  assert_true(text.contains("fn_a"))
}

test "format_report_json" {
  let e1 = @profiler.make_entry("fn_a", 1000000)
  let report = @profiler.create_report([e1])
  let json = @profiler.format_report_json(report)
  assert_true(json.contains("profile"))
  assert_true(json.contains("total_calls"))
}

test "profiler_version" {
  let v = @profiler.profiler_version()
  assert_true(v.contains("profiler"))
}

test "empty_report" {
  let report = @profiler.empty_report()
  assert_eq(report.total_time_ns, 0)
  assert_eq(report.total_calls, 0)
  assert_eq(report.entries.length(), 0)
}

test "find_entry" {
  let e1 = @profiler.make_entry("fn_a", 1000)
  let e2 = @profiler.make_entry("fn_b", 2000)
  let report = @profiler.create_report([e1, e2])
  match @profiler.find_entry(report, "fn_a") {
    Some(e) => assert_eq(e.name, "fn_a")
    None => assert_true(false)
  }
}

test "find_entry_not_found" {
  let report = @profiler.empty_report()
  match @profiler.find_entry(report, "fn_x") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "filter_above_threshold" {
  let e1 = @profiler.make_entry("a", 100)
  let e2 = @profiler.make_entry("b", 500)
  let e3 = @profiler.make_entry("c", 300)
  let report = @profiler.create_report([e1, e2, e3])
  let filtered = @profiler.filter_above_threshold(report, 300)
  assert_eq(filtered.length(), 2)
}

test "entry_count" {
  let e1 = @profiler.make_entry("a", 100)
  let e2 = @profiler.make_entry("b", 200)
  let report = @profiler.create_report([e1, e2])
  assert_eq(@profiler.entry_count(report), 2)
}

test "report_total_time_ms" {
  let e1 = @profiler.make_entry("a", 3000000)
  let report = @profiler.create_report([e1])
  assert_eq(@profiler.report_total_time_ms(report), 3.0)
}

test "report_total_time_sec" {
  let e1 = @profiler.make_entry("a", 2000000000)
  let report = @profiler.create_report([e1])
  assert_eq(@profiler.report_total_time_sec(report), 2.0)
}