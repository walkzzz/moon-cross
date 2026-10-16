///|
/// 行覆盖状态 | Line coverage status
pub(all) enum LineStatus {
  Covered
  Uncovered
  Partial
} derive(Debug, Eq)
pub extend LineStatus with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LineStatus with Eq::{not_equal, equal}

///|
/// 覆盖率条目 | Coverage entry
pub(all) struct CoverageEntry {
  file : String
  total_lines : Int
  covered_lines : Int
  missed_lines : Array[Int]
} derive(Debug, Eq)
pub extend CoverageEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CoverageEntry with Eq::{not_equal, equal}

///|
/// 覆盖率报告 | Coverage report
pub(all) struct CoverageReport {
  entries : Array[CoverageEntry]
  total_lines : Int
  covered_lines : Int
  missed_lines : Int
} derive(Debug, Eq)
pub extend CoverageReport with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CoverageReport with Eq::{not_equal, equal}

///|
/// 覆盖率配置 | Coverage configuration
pub(all) struct CoverageConfig {
  min_threshold : Double
  fail_below : Bool
  show_missing : Bool
  sort_descending : Bool
} derive(Debug, Eq)
pub extend CoverageConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CoverageConfig with Eq::{not_equal, equal}

///|
/// 默认覆盖率配置 | Default coverage configuration
pub fn default_coverage_config() -> CoverageConfig {
  { min_threshold: 80.0, fail_below: true, show_missing: true, sort_descending: true }
}

///|
/// 创建覆盖率条目 | Create coverage entry
pub fn make_entry(
  file : String,
  total_lines : Int,
  covered_lines : Int,
) -> CoverageEntry {
  let missed : Array[Int] = []
  let upper = total_lines + 1
  for i in 1..<upper {
    if i > covered_lines {
      missed.push(i)
    }
  }
  { file, total_lines, covered_lines, missed_lines: missed }
}

///|
/// 创建带缺失行的覆盖率条目 | Create coverage entry with missed lines
pub fn make_entry_with_missed(
  file : String,
  total_lines : Int,
  covered_lines : Int,
  missed_lines : Array[Int],
) -> CoverageEntry {
  { file, total_lines, covered_lines, missed_lines }
}

///|
/// 条目覆盖率百分比 | Entry coverage percentage
pub fn entry_percentage(entry : CoverageEntry) -> Double {
  if entry.total_lines == 0 {
    return 0.0
  }
  entry.covered_lines.to_double() * 100.0 / entry.total_lines.to_double()
}

///|
/// 条目缺失行数 | Entry missed line count
pub fn missed_lines_count(entry : CoverageEntry) -> Int {
  entry.total_lines - entry.covered_lines
}

///|
/// 合并条目为报告 | Merge entries into a report
pub fn merge_entries(entries : Array[CoverageEntry]) -> CoverageReport {
  let mut total = 0
  let mut covered = 0
  for entry in entries {
    total = total + entry.total_lines
    covered = covered + entry.covered_lines
  }
  { entries, total_lines: total, covered_lines: covered, missed_lines: total - covered }
}

///|
/// 报告覆盖率百分比 | Report coverage percentage
pub fn coverage_percentage(report : CoverageReport) -> Double {
  if report.total_lines == 0 {
    return 0.0
  }
  report.covered_lines.to_double() * 100.0 / report.total_lines.to_double()
}

///|
/// 报告文件数 | Report file count
pub fn count_files(report : CoverageReport) -> Int {
  report.entries.length()
}

///|
/// 是否通过阈值 | Check if passing threshold
pub fn is_passing(
  report : CoverageReport,
  threshold : Double,
) -> Bool {
  coverage_percentage(report) >= threshold
}

///|
/// 覆盖率等级 | Coverage grade
pub fn coverage_grade(percentage : Double) -> String {
  if percentage >= 90.0 {
    "A"
  } else if percentage >= 80.0 {
    "B"
  } else if percentage >= 70.0 {
    "C"
  } else if percentage >= 60.0 {
    "D"
  } else {
    "F"
  }
}

///|
/// 过滤低于阈值的条目 | Filter entries below threshold
pub fn filter_below_threshold(
  report : CoverageReport,
  threshold : Double,
) -> Array[CoverageEntry] {
  let result = []
  for entry in report.entries {
    if entry_percentage(entry) < threshold {
      result.push(entry)
    }
  }
  result
}

///|
/// 按覆盖率升序排序 | Sort entries by coverage ascending
pub fn sort_by_coverage_ascending(
  entries : Array[CoverageEntry],
) -> Array[CoverageEntry] {
  let arr = []
  for e in entries {
    arr.push(e)
  }
  let n = arr.length()
  for i in 0..<n {
    let bound = n - 1 - i
    for j in 0..<bound {
      if entry_percentage(arr[j]) > entry_percentage(arr[j + 1]) {
        let tmp = arr[j]
        arr[j] = arr[j + 1]
        arr[j + 1] = tmp
      }
    }
  }
  arr
}

///|
/// 按覆盖率降序排序 | Sort entries by coverage descending
pub fn sort_by_coverage_descending(
  entries : Array[CoverageEntry],
) -> Array[CoverageEntry] {
  let arr = []
  for e in entries {
    arr.push(e)
  }
  let n = arr.length()
  for i in 0..<n {
    let bound = n - 1 - i
    for j in 0..<bound {
      if entry_percentage(arr[j]) < entry_percentage(arr[j + 1]) {
        let tmp = arr[j]
        arr[j] = arr[j + 1]
        arr[j + 1] = tmp
      }
    }
  }
  arr
}

///|
/// 覆盖率摘要统计 | Coverage summary statistics
pub(all) struct CoverageStats {
  min : Double
  max : Double
  mean : Double
  files : Int
} derive(Debug, Eq)
pub extend CoverageStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CoverageStats with Eq::{not_equal, equal}

///|
/// 计算覆盖率统计 | Compute coverage statistics
pub fn coverage_summary_stats(
  report : CoverageReport,
) -> CoverageStats {
  let n = report.entries.length()
  if n == 0 {
    return { min: 0.0, max: 0.0, mean: 0.0, files: 0 }
  }
  let mut min_val = entry_percentage(report.entries[0])
  let mut max_val = min_val
  let mut sum = 0.0
  for entry in report.entries {
    let p = entry_percentage(entry)
    if p < min_val {
      min_val = p
    }
    if p > max_val {
      max_val = p
    }
    sum = sum + p
  }
  { min: min_val, max: max_val, mean: sum / n.to_double(), files: n }
}

///|
/// 格式化报告为文本 | Format report as text
pub fn format_report_text(report : CoverageReport) -> String {
  let mut result = "Coverage Report\n"
  result = result + "===============\n"
  result = result + "Files: " + count_files(report).to_string() + "\n"
  result = result + "Total lines: " + report.total_lines.to_string() + "\n"
  result = result + "Covered lines: " + report.covered_lines.to_string() + "\n"
  result = result + "Missed lines: " + report.missed_lines.to_string() + "\n"
  let pct = coverage_percentage(report)
  result = result + "Coverage: " + pct.to_string() + "%\n"
  result = result + "Grade: " + coverage_grade(pct) + "\n"
  result = result + "\nPer-file:\n"
  for entry in report.entries {
    let ep = entry_percentage(entry)
    result = result + "  " + entry.file + ": " + ep.to_string() + "% (" + entry.covered_lines.to_string() + "/" + entry.total_lines.to_string() + ")\n"
  }
  result
}

///|
/// 格式化报告为 JSON | Format report as JSON
pub fn format_report_json(report : CoverageReport) -> String {
  let mut result = "{\"coverage\": {"
  result = result + "\"files\": " + count_files(report).to_string() + ", "
  result = result + "\"total_lines\": " + report.total_lines.to_string() + ", "
  result = result + "\"covered_lines\": " + report.covered_lines.to_string() + ", "
  result = result + "\"missed_lines\": " + report.missed_lines.to_string() + ", "
  result = result + "\"percentage\": " + coverage_percentage(report).to_string()
  result = result + "}}"
  result
}

///|
/// 覆盖率版本 | Coverage version
pub fn coverage_version() -> String {
  "moon-cross coverage v0.2.1"
}

///|
/// 空报告 | Empty report
pub fn empty_report() -> CoverageReport {
  { entries: [], total_lines: 0, covered_lines: 0, missed_lines: 0 }
}

///|
/// 合并两个报告 | Merge two reports
pub fn merge_reports(
  r1 : CoverageReport,
  r2 : CoverageReport,
) -> CoverageReport {
  let entries = []
  for e in r1.entries {
    entries.push(e)
  }
  for e in r2.entries {
    entries.push(e)
  }
  {
    entries,
    total_lines: r1.total_lines + r2.total_lines,
    covered_lines: r1.covered_lines + r2.covered_lines,
    missed_lines: r1.missed_lines + r2.missed_lines,
  }
}

///|
/// 行状态判断 | Determine line status
pub fn line_status(
  entry : CoverageEntry,
  line : Int,
) -> LineStatus {
  if line > entry.total_lines {
    return Uncovered
  }
  for missed in entry.missed_lines {
    if missed == line {
      return Uncovered
    }
  }
  Covered
}

///|
/// 生成缺失行摘要 | Generate missing lines summary
pub fn missing_lines_summary(entry : CoverageEntry) -> String {
  if entry.missed_lines.length() == 0 {
    return entry.file + ": no missing lines"
  }
  let mut result = entry.file + ": missing lines "
  let mut first = true
  for line in entry.missed_lines {
    if first {
      result = result + line.to_string()
      first = false
    } else {
      result = result + ", " + line.to_string()
    }
  }
  result
}