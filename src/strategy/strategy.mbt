///|
/// 策略上下文 | Strategy context
pub(all) struct StrategyContext {
  strategy_name : String
  config : String
} derive(Debug, Eq)
pub extend StrategyContext with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StrategyContext with Eq::{not_equal, equal}

///|
/// 策略结果 | Strategy result
pub(all) struct StrategyResult {
  success : Bool
  output : String
  strategy_used : String
} derive(Debug, Eq)
pub extend StrategyResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StrategyResult with Eq::{not_equal, equal}

///|
/// 创建上下文 | Create context
pub fn context_create(strategy_name : String) -> StrategyContext {
  { strategy_name, config: "" }
}

///|
/// 设置配置 | Set config
pub fn context_set_config(ctx : StrategyContext, config : String) -> StrategyContext {
  { strategy_name: ctx.strategy_name, config }
}

///|
/// 执行策略 | Execute strategy
pub fn context_execute(ctx : StrategyContext, input : String) -> StrategyResult {
  if ctx.strategy_name == "reverse" {
    let reversed = reverse_string(input)
    { success: true, output: reversed, strategy_used: ctx.strategy_name }
  } else if ctx.strategy_name == "upper" {
    let upper = to_upper_string(input)
    { success: true, output: upper, strategy_used: ctx.strategy_name }
  } else if ctx.strategy_name == "trim" {
    let trimmed = trim_string(input)
    { success: true, output: trimmed, strategy_used: ctx.strategy_name }
  } else if ctx.strategy_name == "prefix" {
    { success: true, output: ctx.config + input, strategy_used: ctx.strategy_name }
  } else {
    { success: false, output: "", strategy_used: ctx.strategy_name }
  }
}

///|
/// 反转字符串 | Reverse string
fn reverse_string(s : String) -> String {
  let mut result = ""
  let len = s.length()
  let mut i = len - 1
  while i >= 0 {
    result = result + s[i:i + 1].to_owned()
    i = i - 1
  }
  result
}

///|
/// 转大写 | To upper case
fn to_upper_string(s : String) -> String {
  let mut result = ""
  let len = s.length()
  let mut i = 0
  while i < len {
    let c = s[i].to_int()
    if c >= 97 && c <= 122 {
      let upper_c = c - 32
      result = result + upper_c.unsafe_to_char().to_string()
    } else {
      result = result + s[i:i + 1].to_owned()
    }
    i = i + 1
  }
  result
}

///|
/// 去空格 | Trim string
fn trim_string(s : String) -> String {
  let len = s.length()
  if len == 0 {
    return ""
  }
  let mut start = 0
  let mut end = len
  while start < end {
    let c = s[start].to_int()
    if c == 32 {
      start = start + 1
    } else {
      break
    }
  }
  while end > start {
    let c = s[end - 1].to_int()
    if c == 32 {
      end = end - 1
    } else {
      break
    }
  }
  if start >= end { "" } else { s[start:end].to_owned() }
}

///|
/// 切换策略 | Switch strategy
pub fn context_switch(_ctx : StrategyContext, new_strategy : String) -> StrategyContext {
  { strategy_name: new_strategy, config: "" }
}

///|
/// 策略版本 | Strategy version
pub fn strategy_version() -> String {
  "moon-cross strategy v0.3.2"
}