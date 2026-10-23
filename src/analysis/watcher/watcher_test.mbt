test "default_watch_config" {
  let cfg = @watcher.default_watch_config()
  assert_eq(cfg.poll_interval_ms, 1000)
  assert_true(cfg.recursive)
  assert_eq(cfg.paths.length(), 0)
}

test "make_event" {
  let event = @watcher.make_event("src/test.mbt", @watcher.EventType::Modified, 1000)
  assert_eq(event.path, "src/test.mbt")
  assert_eq(event.event_type, @watcher.EventType::Modified)
  assert_eq(event.timestamp, 1000)
}

test "make_file_change" {
  let change = @watcher.make_file_change("test.mbt", 1024, "abc123")
  assert_eq(change.path, "test.mbt")
  assert_eq(change.old_path, "")
  assert_eq(change.size, 1024)
  assert_eq(change.hash, "abc123")
}

test "make_rename_change" {
  let change = @watcher.make_rename_change("old.mbt", "new.mbt", 512, "def456")
  assert_eq(change.path, "new.mbt")
  assert_eq(change.old_path, "old.mbt")
  assert_eq(change.size, 512)
}

test "is_ignored_true" {
  let result = @watcher.is_ignored("src/.git/config", [".git"])
  assert_true(result)
}

test "is_ignored_false" {
  let result = @watcher.is_ignored("src/main.mbt", [".git", "target"])
  assert_true(!result)
}

test "is_ignored_empty_patterns" {
  let result = @watcher.is_ignored("src/main.mbt", [])
  assert_true(!result)
}

test "filter_events" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Created, 1)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Modified, 2)
  let e3 = @watcher.make_event("c.mbt", @watcher.EventType::Created, 3)
  let filtered = @watcher.filter_events([e1, e2, e3], @watcher.EventType::Created)
  assert_eq(filtered.length(), 2)
}

test "filter_by_path" {
  let e1 = @watcher.make_event("src/a.mbt", @watcher.EventType::Modified, 1)
  let e2 = @watcher.make_event("lib/b.mbt", @watcher.EventType::Modified, 2)
  let filtered = @watcher.filter_by_path([e1, e2], "src")
  assert_eq(filtered.length(), 1)
}

test "count_by_type" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Created, 1)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Modified, 2)
  let e3 = @watcher.make_event("c.mbt", @watcher.EventType::Created, 3)
  let events = [e1, e2, e3]
  assert_eq(@watcher.count_by_type(events, @watcher.EventType::Created), 2)
  assert_eq(@watcher.count_by_type(events, @watcher.EventType::Modified), 1)
  assert_eq(@watcher.count_by_type(events, @watcher.EventType::Deleted), 0)
}

test "has_changes_true" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 1)
  assert_true(@watcher.has_changes([e1]))
}

test "has_changes_false" {
  assert_true(!@watcher.has_changes([]))
}

test "make_watch_result" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 1)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Created, 2)
  let result = @watcher.make_watch_result([e1, e2])
  assert_eq(result.total_changes, 2)
  assert_true(!result.has_errors)
}

test "make_error_result" {
  let result = @watcher.make_error_result("permission denied")
  assert_true(result.has_errors)
  assert_eq(result.total_changes, 0)
}

test "event_summary" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Created, 1)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Modified, 2)
  let summary = @watcher.event_summary([e1, e2])
  assert_true(summary.contains("2 events"))
  assert_true(summary.contains("created: 1"))
  assert_true(summary.contains("modified: 1"))
}

test "event_type_to_string" {
  assert_eq(@watcher.event_type_to_string(@watcher.EventType::Created), "created")
  assert_eq(@watcher.event_type_to_string(@watcher.EventType::Modified), "modified")
  assert_eq(@watcher.event_type_to_string(@watcher.EventType::Deleted), "deleted")
  assert_eq(@watcher.event_type_to_string(@watcher.EventType::Renamed), "renamed")
}

test "format_event" {
  let event = @watcher.make_event("src/test.mbt", @watcher.EventType::Modified, 12345)
  let formatted = @watcher.format_event(event)
  assert_true(formatted.contains("12345"))
  assert_true(formatted.contains("modified"))
  assert_true(formatted.contains("src/test.mbt"))
}

test "deduplicate_events" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 1)
  let e2 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 2)
  let e3 = @watcher.make_event("b.mbt", @watcher.EventType::Created, 3)
  let deduped = @watcher.deduplicate_events([e1, e2, e3])
  assert_eq(deduped.length(), 2)
}

test "merge_results" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 1)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Created, 2)
  let r1 = @watcher.make_watch_result([e1])
  let r2 = @watcher.make_watch_result([e2])
  let merged = @watcher.merge_results(r1, r2)
  assert_eq(merged.total_changes, 2)
  assert_eq(merged.events.length(), 2)
}

test "watcher_version" {
  let v = @watcher.watcher_version()
  assert_true(v.contains("watcher"))
}

test "add_watch_path" {
  let cfg = @watcher.default_watch_config()
  let updated = @watcher.add_watch_path(cfg, "src/")
  assert_eq(updated.paths.length(), 1)
  assert_eq(updated.paths[0], "src/")
}

test "add_ignore_pattern" {
  let cfg = @watcher.default_watch_config()
  let updated = @watcher.add_ignore_pattern(cfg, "*.tmp")
  let last = updated.ignore_patterns.length() - 1
  assert_eq(updated.ignore_patterns[last], "*.tmp")
}

test "sort_by_timestamp" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 30)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Modified, 10)
  let e3 = @watcher.make_event("c.mbt", @watcher.EventType::Modified, 20)
  let sorted = @watcher.sort_by_timestamp([e1, e2, e3])
  assert_eq(sorted[0].timestamp, 10)
  assert_eq(sorted[1].timestamp, 20)
  assert_eq(sorted[2].timestamp, 30)
}

test "latest_events" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 10)
  let e2 = @watcher.make_event("b.mbt", @watcher.EventType::Modified, 20)
  let e3 = @watcher.make_event("c.mbt", @watcher.EventType::Modified, 30)
  let latest = @watcher.latest_events([e1, e2, e3], 2)
  assert_eq(latest.length(), 2)
  assert_eq(latest[0].timestamp, 30)
  assert_eq(latest[1].timestamp, 20)
}

test "latest_events_more_than_available" {
  let e1 = @watcher.make_event("a.mbt", @watcher.EventType::Modified, 10)
  let latest = @watcher.latest_events([e1], 5)
  assert_eq(latest.length(), 1)
}