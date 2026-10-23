///|
/// 文件事件类型 | File event type
pub(all) enum EventType {
  Created
  Modified
  Deleted
  Renamed
} derive(Debug, Eq)
pub extend EventType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EventType with Eq::{not_equal, equal}

///|
/// 文件监视事件 | File watch event
pub(all) struct WatchEvent {
  path : String
  event_type : EventType
  timestamp : Int
} derive(Debug, Eq)
pub extend WatchEvent with @moonbitlang/core/debug.Debug::{to_repr}
pub extend WatchEvent with Eq::{not_equal, equal}

///|
/// 文件监视配置 | File watch configuration
pub(all) struct WatchConfig {
  paths : Array[String]
  ignore_patterns : Array[String]
  poll_interval_ms : Int
  recursive : Bool
} derive(Debug, Eq)
pub extend WatchConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend WatchConfig with Eq::{not_equal, equal}

///|
/// 文件变更记录 | File change record
pub(all) struct FileChange {
  path : String
  old_path : String
  size : Int
  hash : String
} derive(Debug, Eq)
pub extend FileChange with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FileChange with Eq::{not_equal, equal}

///|
/// 监视结果 | Watch result
pub(all) struct WatchResult {
  events : Array[WatchEvent]
  total_changes : Int
  has_errors : Bool
} derive(Debug, Eq)
pub extend WatchResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend WatchResult with Eq::{not_equal, equal}

///|
/// 默认监视配置 | Default watch configuration
pub fn default_watch_config() -> WatchConfig {
  { paths: [], ignore_patterns: [".git", "target", "node_modules"], poll_interval_ms: 1000, recursive: true }
}

///|
/// 创建监视事件 | Create watch event
pub fn make_event(
  path : String,
  event_type : EventType,
  timestamp : Int,
) -> WatchEvent {
  { path, event_type, timestamp }
}

///|
/// 创建文件变更 | Create file change
pub fn make_file_change(
  path : String,
  size : Int,
  hash : String,
) -> FileChange {
  { path, old_path: "", size, hash }
}

///|
/// 创建重命名变更 | Create rename change
pub fn make_rename_change(
  old_path : String,
  new_path : String,
  size : Int,
  hash : String,
) -> FileChange {
  { path: new_path, old_path, size, hash }
}

///|
/// 检查路径是否被忽略 | Check if path is ignored
pub fn is_ignored(
  path : String,
  patterns : Array[String],
) -> Bool {
  for pattern in patterns {
    if path_contains(path, pattern) {
      return true
    }
  }
  false
}

///|
/// 路径包含子串 | Path contains substring
fn path_contains(path : String, sub : String) -> Bool {
  let n = path.length()
  let m = sub.length()
  if m == 0 {
    return true
  }
  if m > n {
    return false
  }
  for i in 0..<(n - m + 1) {
    let mut matched = true
    for j in 0..<m {
      if path[i + j] != sub[j] {
        matched = false
        break
      }
    }
    if matched {
      return true
    }
  }
  false
}

///|
/// 按事件类型过滤 | Filter events by type
pub fn filter_events(
  events : Array[WatchEvent],
  event_type : EventType,
) -> Array[WatchEvent] {
  let result = []
  for event in events {
    if event.event_type == event_type {
      result.push(event)
    }
  }
  result
}

///|
/// 按路径过滤 | Filter events by path prefix
pub fn filter_by_path(
  events : Array[WatchEvent],
  prefix : String,
) -> Array[WatchEvent] {
  let result = []
  for event in events {
    if path_starts_with(event.path, prefix) {
      result.push(event)
    }
  }
  result
}

///|
/// 路径前缀匹配 | Path starts with prefix
fn path_starts_with(path : String, prefix : String) -> Bool {
  let n = path.length()
  let m = prefix.length()
  if m > n {
    return false
  }
  for i in 0..<m {
    if path[i] != prefix[i] {
      return false
    }
  }
  true
}

///|
/// 统计事件数 | Count events by type
pub fn count_by_type(
  events : Array[WatchEvent],
  event_type : EventType,
) -> Int {
  let mut count = 0
  for event in events {
    if event.event_type == event_type {
      count = count + 1
    }
  }
  count
}

///|
/// 是否有变更 | Check if has changes
pub fn has_changes(events : Array[WatchEvent]) -> Bool {
  events.length() > 0
}

///|
/// 创建监视结果 | Create watch result
pub fn make_watch_result(events : Array[WatchEvent]) -> WatchResult {
  { events, total_changes: events.length(), has_errors: false }
}

///|
/// 创建带错误的监视结果 | Create watch result with errors
pub fn make_error_result(error_msg : String) -> WatchResult {
  let _ = error_msg
  { events: [], total_changes: 0, has_errors: true }
}

///|
/// 事件摘要 | Event summary
pub fn event_summary(events : Array[WatchEvent]) -> String {
  let created = count_by_type(events, Created)
  let modified = count_by_type(events, Modified)
  let deleted = count_by_type(events, Deleted)
  let renamed = count_by_type(events, Renamed)
  let total = events.length()
  "Watch summary: " + total.to_string() + " events (created: " + created.to_string() + ", modified: " + modified.to_string() + ", deleted: " + deleted.to_string() + ", renamed: " + renamed.to_string() + ")"
}

///|
/// 事件类型转字符串 | Event type to string
pub fn event_type_to_string(event_type : EventType) -> String {
  match event_type {
    Created => "created"
    Modified => "modified"
    Deleted => "deleted"
    Renamed => "renamed"
  }
}

///|
/// 格式化事件 | Format event
pub fn format_event(event : WatchEvent) -> String {
  "[" + event.timestamp.to_string() + "] " + event_type_to_string(event.event_type) + ": " + event.path
}

///|
/// 去重事件 | Deduplicate events
pub fn deduplicate_events(
  events : Array[WatchEvent],
) -> Array[WatchEvent] {
  let result : Array[WatchEvent] = []
  for event in events {
    let mut found = false
    for existing in result {
      if existing.path == event.path && existing.event_type == event.event_type {
        found = true
        break
      }
    }
    if !found {
      result.push(event)
    }
  }
  result
}

///|
/// 合并监视结果 | Merge watch results
pub fn merge_results(
  r1 : WatchResult,
  r2 : WatchResult,
) -> WatchResult {
  let events = []
  for e in r1.events {
    events.push(e)
  }
  for e in r2.events {
    events.push(e)
  }
  { events, total_changes: r1.total_changes + r2.total_changes, has_errors: r1.has_errors || r2.has_errors }
}

///|
/// 监视器版本 | Watcher version
pub fn watcher_version() -> String {
  "moon-cross watcher v0.2.2"
}

///|
/// 添加监视路径 | Add watch path
pub fn add_watch_path(
  config : WatchConfig,
  path : String,
) -> WatchConfig {
  let paths = []
  for p in config.paths {
    paths.push(p)
  }
  paths.push(path)
  { ..config, paths }
}

///|
/// 添加忽略模式 | Add ignore pattern
pub fn add_ignore_pattern(
  config : WatchConfig,
  pattern : String,
) -> WatchConfig {
  let patterns = []
  for p in config.ignore_patterns {
    patterns.push(p)
  }
  patterns.push(pattern)
  { ..config, ignore_patterns: patterns }
}

///|
/// 按时间排序事件 | Sort events by timestamp
pub fn sort_by_timestamp(events : Array[WatchEvent]) -> Array[WatchEvent] {
  let arr = []
  for e in events {
    arr.push(e)
  }
  let n = arr.length()
  for i in 0..<n {
    let bound = n - 1 - i
    for j in 0..<bound {
      if arr[j].timestamp > arr[j + 1].timestamp {
        let tmp = arr[j]
        arr[j] = arr[j + 1]
        arr[j + 1] = tmp
      }
    }
  }
  arr
}

///|
/// 获取最新事件 | Get latest events
pub fn latest_events(
  events : Array[WatchEvent],
  count : Int,
) -> Array[WatchEvent] {
  let sorted = sort_by_timestamp(events)
  let result = []
  let n = sorted.length()
  let take = if count < n { count } else { n }
  for i in 0..<take {
    result.push(sorted[n - 1 - i])
  }
  result
}

///|
/// FileChange 实现 Countable trait | FileChange implements Countable
pub impl @trait.Countable for FileChange with count(self) {
  self.size
}
pub extend FileChange with @trait.Countable::{count}

///|
/// WatchResult 实现 Countable trait | WatchResult implements Countable
pub impl @trait.Countable for WatchResult with count(self) {
  self.events.length()
}
pub extend WatchResult with @trait.Countable::{count}