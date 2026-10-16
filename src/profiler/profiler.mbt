///|
/// 性能分析条目 | Profile entry
pub(all) struct ProfileEntry {
  name : String
  call_count : Int
  total_time_ns : Int
  min_time_ns : Int
  max_time_ns : Int
} derive(Debug, Eq)
pub extend ProfileEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProfileEntry with Eq::{not_equal, equal}

///|
/// 性能分析配置 | Profiler configuration
pub(all) struct ProfilerConfig {
  enabled : Bool
  sample_rate : Int
  max_entries : Int
  track_memory : Bool
} derive(Debug, Eq)
pub extend ProfilerConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProfilerConfig with Eq::{not_equal, equal}

///|
/// 性能分析统计 | Profile statistics
pub(all) struct ProfileStats {
  total_calls : Int
  total_time_ns : Int
  avg_time_ns : Double
  hottest_function : String
} derive(Debug, Eq)
pub extend ProfileStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProfileStats with Eq::{not_equal, equal}

///|
/// 性能分析报告 | Profile report
pub(all) struct ProfileReport {
  entries : Array[ProfileEntry]
  total_time_ns : Int
  total_calls : Int
} derive(Debug, Eq)
pub extend ProfileReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ProfileReport with Eq::{not_equal, equal}

///|
/// 默认性能分析配置 | Default profiler configuration
pub fn default_profiler_config() -> ProfilerConfig {
  { enabled: true, sample_rate: 1, max_entries: 10000, track_memory: false }
}

///|
/// 创建性能分析条目 | Create profile entry
pub fn make_entry(name : String, duration_ns : Int) -> ProfileEntry {
  { name, call_count: 1, total_time_ns: duration_ns, min_time_ns: duration_ns, max_time_ns: duration_ns }
}

///|
/// 记算平均时间 | Calculate average time
pub fn average_time(entry : ProfileEntry) -> Double {
  if entry.call_count == 0 {
    return 0.0
  }
  entry.total_time_ns.to_double() / entry.call_count.to_double()
}

///|
/// 记算平均时间（毫秒） | Average time in milliseconds
pub fn average_time_ms(entry : ProfileEntry) -> Double {
  average_time(entry) / 1000000.0
}

///|
/// 计算总时间（毫秒） | Total time in milliseconds
pub fn total_time_ms(entry : ProfileEntry) -> Double {
  entry.total_time_ns.to_double() / 1000000.0
}

///|
/// 记算总时间（秒） | Total time in seconds
pub fn total_time_sec(entry : ProfileEntry) -> Double {
  entry.total_time_ns.to_double() / 1000000000.0
}

///|
/// 记算总时间（毫秒） | Total time in milliseconds
pub fn report_total_time_ms(report : ProfileReport) -> Double {
  report.total_time_ns.to_double() / 1000000.0
}

///|
/// 计算总时间（秒） | Total time in seconds
pub fn report_total_time_sec(report : ProfileReport) -> Double {
  report.total_time_ns.to_double() / 1000000000.0
}

///|
/// 创建性能分析报告 | Create profile report
pub fn create_report(entries : Array[ProfileEntry]) -> ProfileReport {
  let mut total_time = 0
  let mut total_calls = 0
  for entry in entries {
    total_time = total_time + entry.total_time_ns
    total_calls = total_calls + entry.call_count
  }
  { entries, total_time_ns: total_time, total_calls }
}

///|
/// 查找热点函数 | Find hotspot function
pub fn find_hotspot(report : ProfileReport) -> ProfileEntry? {
  if report.entries.length() == 0 {
    return None
  }
  let mut hottest = report.entries[0]
  for entry in report.entries {
    if entry.total_time_ns > hottest.total_time_ns {
      hottest = entry
    }
  }
  Some(hottest)
}

///|
/// 按总时间排序（降序） | Sort by total time descending
pub fn sort_by_total_time(
  entries : Array[ProfileEntry],
) -> Array[ProfileEntry] {
  let arr = []
  for e in entries {
    arr.push(e)
  }
  let n = arr.length()
  for i in 0..<n {
    let bound = n - 1 - i
    for j in 0..<bound {
      if arr[j].total_time_ns < arr[j + 1].total_time_ns {
        let tmp = arr[j]
        arr[j] = arr[j + 1]
        arr[j + 1] = tmp
      }
    }
  }
  arr
}

///|
/// 按调用次数排序（降序） | Sort by call count descending
pub fn sort_by_call_count(
  entries : Array[ProfileEntry],
) -> Array[ProfileEntry] {
  let arr = []
  for e in entries {
    arr.push(e)
  }
  let n = arr.length()
  for i in 0..<n {
    let bound = n - 1 - i
    for j in 0..<bound {
      if arr[j].call_count < arr[j + 1].call_count {
        let tmp = arr[j]
        arr[j] = arr[j + 1]
        arr[j + 1] = tmp
      }
    }
  }
  arr
}

///|
/// 合并同名条目 | Merge entries with same name
pub fn merge_entries(
  entries : Array[ProfileEntry],
) -> Array[ProfileEntry] {
  let result : Array[ProfileEntry] = []
  for entry in entries {
    let mut found = false
    for i in 0..<result.length() {
      if result[i].name == entry.name {
        let merged = {
          name: entry.name,
          call_count: result[i].call_count + entry.call_count,
          total_time_ns: result[i].total_time_ns + entry.total_time_ns,
          min_time_ns: if result[i].min_time_ns < entry.min_time_ns {
            result[i].min_time_ns
          } else {
            entry.min_time_ns
          },
          max_time_ns: if result[i].max_time_ns > entry.max_time_ns {
            result[i].max_time_ns
          } else {
            entry.max_time_ns
          },
        }
        result[i] = merged
        found = true
        break
      }
    }
    if !found {
      result.push(entry)
    }
  }
  result
}

///|
/// 性能分析摘要统计 | Profile summary statistics
pub fn summary_stats(report : ProfileReport) -> ProfileStats {
  let hottest_name = match find_hotspot(report) {
    Some(e) => e.name
    None => ""
  }
  let avg = if report.total_calls == 0 {
    0.0
  } else {
    report.total_time_ns.to_double() / report.total_calls.to_double()
  }
  { total_calls: report.total_calls, total_time_ns: report.total_time_ns, avg_time_ns: avg, hottest_function: hottest_name }
}

///|
/// 格式化报告为文本 | Format report as text
pub fn format_report_text(report : ProfileReport) -> String {
  let mut result = "Profile Report\n"
  result = result + "==============\n"
  result = result + "Total time: " + report_total_time_ms(report).to_string() + " ms\n"
  result = result + "Total calls: " + report.total_calls.to_string() + "\n"
  result = result + "\nFunction details:\n"
  let sorted = sort_by_total_time(report.entries)
  for entry in sorted {
    result = result + "  " + entry.name + ": " + total_time_ms(entry).to_string() + " ms (" + entry.call_count.to_string() + " calls, avg: " + average_time_ms(entry).to_string() + " ms)\n"
  }
  result
}

///|
/// 格式化报告为 JSON | Format report as JSON
pub fn format_report_json(report : ProfileReport) -> String {
  let mut result = "{\"profile\": {"
  result = result + "\"total_time_ms\": " + report_total_time_ms(report).to_string() + ", "
  result = result + "\"total_calls\": " + report.total_calls.to_string() + ", "
  result = result + "\"functions\": " + report.entries.length().to_string()
  result = result + "}}"
  result
}

///|
/// 性能分析器版本 | Profiler version
pub fn profiler_version() -> String {
  "moon-cross profiler v0.2.6"
}

///|
/// 空报告 | Empty report
pub fn empty_report() -> ProfileReport {
  { entries: [], total_time_ns: 0, total_calls: 0 }
}

///|
/// 按名称查找条目 | Find entry by name
pub fn find_entry(
  report : ProfileReport,
  name : String,
) -> ProfileEntry? {
  for entry in report.entries {
    if entry.name == name {
      return Some(entry)
    }
  }
  None
}

///|
/// 过滤高耗时条目 | Filter entries above threshold
pub fn filter_above_threshold(
  report : ProfileReport,
  threshold_ns : Int,
) -> Array[ProfileEntry] {
  let result = []
  for entry in report.entries {
    if entry.total_time_ns >= threshold_ns {
      result.push(entry)
    }
  }
  result
}

///|
/// 条目数 | Entry count
pub fn entry_count(report : ProfileReport) -> Int {
  report.entries.length()
}