///|
/// 正则模式 | Regex pattern
pub(all) struct RegexPattern {
  pattern : String
  has_start_anchor : Bool
  has_end_anchor : Bool
  core : String
} derive(Debug, Eq)
pub extend RegexPattern with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RegexPattern with Eq::{not_equal, equal}

///|
/// 正则匹配结果 | Regex match result
pub(all) struct RegexMatch {
  matched : String
  start : Int
  end : Int
} derive(Debug, Eq)
pub extend RegexMatch with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RegexMatch with Eq::{not_equal, equal}

///|
/// 核心匹配（递归） | Core match (recursive)
/// 返回匹配结束位置，-1 表示不匹配 | Returns end position, -1 for no match
fn match_at(pattern : String, input : String, pi : Int, si : Int) -> Int {
  let plen = pattern.length()
  let slen = input.length()
  if pi >= plen {
    return si
  }
  let pc = pattern[pi].to_int()
  if pi + 1 < plen && pattern[pi + 1].to_int() == 42 {
    let mut k = si
    let rest_result = match_at(pattern, input, pi + 2, k)
    if rest_result >= 0 {
      return rest_result
    }
    while k < slen {
      let sc = input[k].to_int()
      if pc == 46 || pc == sc {
        k = k + 1
        let rest_result2 = match_at(pattern, input, pi + 2, k)
        if rest_result2 >= 0 {
          return rest_result2
        }
      } else {
        return -1
      }
    }
    return -1
  }
  if si >= slen {
    return -1
  }
  let sc = input[si].to_int()
  if pc == 46 || pc == sc {
    return match_at(pattern, input, pi + 1, si + 1)
  }
  -1
}

///|
/// 编译模式 | Compile pattern
pub fn compile_pattern(pattern : String) -> RegexPattern {
  let plen = pattern.length()
  let mut has_start = false
  let mut has_end = false
  let mut core_start = 0
  let mut core_end = plen
  if plen > 0 && pattern[0].to_int() == 94 {
    has_start = true
    core_start = 1
  }
  if core_end > core_start && pattern[core_end - 1].to_int() == 36 {
    has_end = true
    core_end = core_end - 1
  }
  let core = pattern[core_start:core_end].to_owned()
  { pattern, has_start_anchor: has_start, has_end_anchor: has_end, core }
}

///|
/// 正则匹配 | Regex match
pub fn regex_match(pattern : RegexPattern, input : String) -> RegexMatch? {
  let ilen = input.length()
  if pattern.has_start_anchor {
    let end_pos = match_at(pattern.core, input, 0, 0)
    if end_pos >= 0 {
      if pattern.has_end_anchor && end_pos != ilen {
        return None
      }
      let matched = input[0:end_pos].to_owned()
      return Some({ matched, start: 0, end: end_pos })
    }
    return None
  }
  let mut start = 0
  while start <= ilen {
    let end_pos = match_at(pattern.core, input, 0, start)
    if end_pos >= 0 {
      if pattern.has_end_anchor && end_pos != ilen {
        start = start + 1
      } else {
        let matched = input[start:end_pos].to_owned()
        return Some({ matched, start, end: end_pos })
      }
    } else {
      start = start + 1
    }
  }
  None
}

///|
/// 查找所有匹配 | Find all matches
pub fn regex_find_all(pattern : RegexPattern, input : String) -> Array[RegexMatch] {
  let result = []
  let ilen = input.length()
  let mut start = 0
  while start <= ilen {
    let end_pos = match_at(pattern.core, input, 0, start)
    if end_pos >= 0 {
      if pattern.has_end_anchor && end_pos != ilen {
        start = start + 1
      } else {
        let matched = input[start:end_pos].to_owned()
        result.push({ matched, start, end: end_pos })
        if end_pos == start {
          start = start + 1
        } else {
          start = end_pos
        }
      }
    } else {
      start = start + 1
    }
  }
  result
}

///|
/// 正则替换 | Regex replace
pub fn regex_replace(pattern : RegexPattern, input : String, replacement : String) -> String {
  let matches = regex_find_all(pattern, input)
  if matches.length() == 0 {
    return input
  }
  let mut result = ""
  let mut last_end = 0
  for m in matches {
    if m.start > last_end {
      result = result + input[last_end:m.start].to_owned()
    }
    result = result + replacement
    last_end = m.end
  }
  if last_end < input.length() {
    result = result + input[last_end:].to_owned()
  }
  result
}

///|
/// 正则分割 | Regex split
pub fn regex_split(pattern : RegexPattern, input : String) -> Array[String] {
  let result = []
  let matches = regex_find_all(pattern, input)
  if matches.length() == 0 {
    result.push(input)
    return result
  }
  let mut last_end = 0
  for m in matches {
    if m.start > last_end {
      result.push(input[last_end:m.start].to_owned())
    } else {
      result.push("")
    }
    last_end = m.end
  }
  if last_end < input.length() {
    result.push(input[last_end:].to_owned())
  } else {
    result.push("")
  }
  result
}

///|
/// 正则是否有效 | Regex is valid
pub fn regex_is_valid(pattern : String) -> Bool {
  pattern.length() > 0
}

///|
/// 简单匹配 | Simple match
pub fn simple_match(pattern : String, input : String) -> Bool {
  let compiled = compile_pattern(pattern)
  regex_match(compiled, input) is Some(_)
}

///|
/// 正则版本 | Regex version
pub fn regex_version() -> String {
  "moon-cross regex_enhanced v0.2.26"
}