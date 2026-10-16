///|
/// 差异行类型 | Diff line type
pub(all) enum DiffLineType {
  Added
  Removed
  Unchanged
  Context
} derive(Debug, Eq)
pub extend DiffLineType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiffLineType with Eq::{not_equal, equal}

///|
/// 差异行 | Diff line
pub(all) struct DiffLine {
  content : String
  line_type : DiffLineType
  old_line_num : Int
  new_line_num : Int
} derive(Debug, Eq)
pub extend DiffLine with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiffLine with Eq::{not_equal, equal}

///|
/// 差异结果 | Diff result
pub(all) struct DiffResult {
  lines : Array[DiffLine]
  added_count : Int
  removed_count : Int
  unchanged_count : Int
} derive(Debug, Eq)
pub extend DiffResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiffResult with Eq::{not_equal, equal}

///|
/// 差异配置 | Diff configuration
pub(all) struct DiffConfig {
  context_lines : Int
  ignore_whitespace : Bool
  max_diff_lines : Int
} derive(Debug, Eq)
pub extend DiffConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiffConfig with Eq::{not_equal, equal}

///|
/// 差异统计 | Diff statistics
pub(all) struct DiffStats {
  total_lines : Int
  change_ratio : Double
  added : Int
  removed : Int
  unchanged : Int
} derive(Debug, Eq)
pub extend DiffStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiffStats with Eq::{not_equal, equal}

///|
/// 默认差异配置 | Default diff configuration
pub fn default_diff_config() -> DiffConfig {
  { context_lines: 3, ignore_whitespace: false, max_diff_lines: 1000 }
}

///|
/// 行类型转字符串 | Line type to string
pub fn line_type_to_string(t : DiffLineType) -> String {
  match t {
    Added => "+"
    Removed => "-"
    Unchanged => " "
    Context => " "
  }
}

///|
/// 行类型全名 | Line type full name
pub fn line_type_name(t : DiffLineType) -> String {
  match t {
    Added => "added"
    Removed => "removed"
    Unchanged => "unchanged"
    Context => "context"
  }
}

///|
/// 创建差异行 | Create diff line
pub fn make_diff_line(
  content : String,
  line_type : DiffLineType,
  old_num : Int,
  new_num : Int,
) -> DiffLine {
  { content, line_type, old_line_num: old_num, new_line_num: new_num }
}

///|
/// 按行分割文本 | Split text into lines
fn split_lines(text : String) -> Array[String] {
  let result : Array[String] = []
  let mut start = 0
  let n = text.length()
  for i in 0..<n {
    if text[i].to_int() == 10 {
      result.push(text[start:i].to_owned())
      start = i + 1
    }
  }
  if start < n {
    result.push(text[start:n].to_owned())
  }
  if n == 0 {
    return result
  }
  result
}

///|

/// 计算行差异 | Diff line arrays
pub fn diff_lines(
  old : Array[String],
  new : Array[String],
) -> DiffResult {
  let lines : Array[DiffLine] = []
  let mut added = 0
  let mut removed = 0
  let mut unchanged = 0
  let old_len = old.length()
  let new_len = new.length()
  let min_len = if old_len < new_len { old_len } else { new_len }
  for i in 0..<min_len {
    if old[i] == new[i] {
      lines.push({ content: old[i], line_type: Unchanged, old_line_num: i + 1, new_line_num: i + 1 })
      unchanged = unchanged + 1
    } else {
      lines.push({ content: old[i], line_type: Removed, old_line_num: i + 1, new_line_num: 0 })
      removed = removed + 1
      lines.push({ content: new[i], line_type: Added, old_line_num: 0, new_line_num: i + 1 })
      added = added + 1
    }
  }
  for i in min_len..<old_len {
    lines.push({ content: old[i], line_type: Removed, old_line_num: i + 1, new_line_num: 0 })
    removed = removed + 1
  }
  for i in min_len..<new_len {
    lines.push({ content: new[i], line_type: Added, old_line_num: 0, new_line_num: i + 1 })
    added = added + 1
  }
  { lines, added_count: added, removed_count: removed, unchanged_count: unchanged }
}

///|
/// 计算文本差异 | Diff text
pub fn diff_text(
  old : String,
  new : String,
) -> DiffResult {
  diff_lines(split_lines(old), split_lines(new))
}

///|
/// 带配置的文本差异 | Diff text with config
pub fn diff_text_with_config(
  config : DiffConfig,
  old : String,
  new : String,
) -> DiffResult {
  let _ = config
  diff_text(old, new)
}

///|
/// 是否有变更 | Check if has changes
pub fn has_changes(result : DiffResult) -> Bool {
  result.added_count > 0 || result.removed_count > 0
}

///|
/// 差异摘要 | Diff summary
pub fn diff_summary(result : DiffResult) -> String {
  "Diff: +" + result.added_count.to_string() + " -" + result.removed_count.to_string() + " " + result.unchanged_count.to_string() + " unchanged"
}

///|
/// 格式化差异 | Format diff
pub fn format_diff(result : DiffResult) -> String {
  let mut output = ""
  for line in result.lines {
    output = output + line_type_to_string(line.line_type) + " " + line.content + "\n"
  }
  output
}

///|
/// 过滤新增行 | Filter added lines
pub fn filter_added(result : DiffResult) -> Array[DiffLine] {
  let result_arr = []
  for line in result.lines {
    if line.line_type == Added {
      result_arr.push(line)
    }
  }
  result_arr
}

///|
/// 过滤删除行 | Filter removed lines
pub fn filter_removed(result : DiffResult) -> Array[DiffLine] {
  let result_arr = []
  for line in result.lines {
    if line.line_type == Removed {
      result_arr.push(line)
    }
  }
  result_arr
}

///|
/// 过滤未变更行 | Filter unchanged lines
pub fn filter_unchanged(result : DiffResult) -> Array[DiffLine] {
  let result_arr = []
  for line in result.lines {
    if line.line_type == Unchanged {
      result_arr.push(line)
    }
  }
  result_arr
}

///|
/// 合并差异 | Merge diffs
pub fn merge_diffs(
  d1 : DiffResult,
  d2 : DiffResult,
) -> DiffResult {
  let lines = []
  for l in d1.lines {
    lines.push(l)
  }
  for l in d2.lines {
    lines.push(l)
  }
  {
    lines,
    added_count: d1.added_count + d2.added_count,
    removed_count: d1.removed_count + d2.removed_count,
    unchanged_count: d1.unchanged_count + d2.unchanged_count,
  }
}

///|
/// 差异统计 | Diff statistics
pub fn diff_stats(result : DiffResult) -> DiffStats {
  let total = result.lines.length()
  let ratio = if total == 0 {
    0.0
  } else {
    (result.added_count + result.removed_count).to_double() / total.to_double()
  }
  { total_lines: total, change_ratio: ratio, added: result.added_count, removed: result.removed_count, unchanged: result.unchanged_count }
}

///|
/// 空差异 | Empty diff
pub fn empty_diff() -> DiffResult {
  { lines: [], added_count: 0, removed_count: 0, unchanged_count: 0 }
}

///|
/// 差异版本 | Diff version
pub fn diff_version() -> String {
  "moon-cross diff v0.2.4"
}

///|
/// 统计差异行总数 | Count total diff lines
pub fn total_lines(result : DiffResult) -> Int {
  result.lines.length()
}

///|
/// 反转差异 | Reverse diff (swap added/removed)
pub fn reverse_diff(result : DiffResult) -> DiffResult {
  let lines = []
  for line in result.lines {
    let new_type = match line.line_type {
      Added => Removed
      Removed => Added
      Unchanged => Unchanged
      Context => Context
    }
    lines.push({ content: line.content, line_type: new_type, old_line_num: line.new_line_num, new_line_num: line.old_line_num })
  }
  { lines, added_count: result.removed_count, removed_count: result.added_count, unchanged_count: result.unchanged_count }
}