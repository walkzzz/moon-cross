///|
/// 模板上下文 | Template context
pub(all) struct TemplateContext {
  vars : Array[(String, String)]
} derive(Debug, Eq)
pub extend TemplateContext with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TemplateContext with Eq::{not_equal, equal}

///|
/// 模板 | Template
pub(all) struct Template {
  source : String
} derive(Debug, Eq)
pub extend Template with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Template with Eq::{not_equal, equal}

///|
/// 查找字符串位置 | Find string position
fn find_str(s : String, sub : String, start : Int) -> Int {
  let slen = s.length()
  let sublen = sub.length()
  if sublen == 0 || sublen > slen {
    return -1
  }
  let mut i = start
  let upper = slen - sublen
  while i <= upper {
    let mut is_match = true
    let mut j = 0
    while j < sublen {
      if s[i + j] != sub[j] {
        is_match = false
      }
      j = j + 1
    }
    if is_match {
      return i
    }
    i = i + 1
  }
  -1
}

///|
/// 去除首尾空格 | Trim whitespace
fn trim_str(s : String) -> String {
  let len = s.length()
  if len == 0 {
    return ""
  }
  let mut start = 0
  let mut end = len
  while start < end {
    let c = s[start].to_int()
    if c == 32 || c == 9 || c == 10 || c == 13 {
      start = start + 1
    } else {
      break
    }
  }
  while end > start {
    let c = s[end - 1].to_int()
    if c == 32 || c == 9 || c == 10 || c == 13 {
      end = end - 1
    } else {
      break
    }
  }
  if start >= end {
    ""
  } else {
    s[start:end].to_owned()
  }
}

///|
/// 创建空上下文 | Create empty context
pub fn empty_context() -> TemplateContext {
  { vars: [] }
}

///|
/// 设置上下文变量 | Set context variable
pub fn context_set(ctx : TemplateContext, key : String, value : String) -> TemplateContext {
  let mut found = false
  let new_vars = []
  for pair in ctx.vars {
    if pair.0 == key {
      new_vars.push((key, value))
      found = true
    } else {
      new_vars.push(pair)
    }
  }
  if !found {
    new_vars.push((key, value))
  }
  { vars: new_vars }
}

///|
/// 获取上下文变量 | Get context variable
pub fn context_get(ctx : TemplateContext, key : String) -> String? {
  for pair in ctx.vars {
    if pair.0 == key {
      return Some(pair.1)
    }
  }
  None
}

///|
/// 检查上下文变量是否存在 | Check if context variable exists
pub fn context_has(ctx : TemplateContext, key : String) -> Bool {
  for pair in ctx.vars {
    if pair.0 == key {
      return true
    }
  }
  false
}

///|
/// 删除上下文变量 | Remove context variable
pub fn context_remove(ctx : TemplateContext, key : String) -> TemplateContext {
  let new_vars = []
  for pair in ctx.vars {
    if pair.0 != key {
      new_vars.push(pair)
    }
  }
  { vars: new_vars }
}

///|
/// 上下文变量数量 | Context variable count
pub fn context_size(ctx : TemplateContext) -> Int {
  ctx.vars.length()
}

///|
/// 查找匹配的块结束标记 | Find matching block end
fn find_block_end(source : String, start : Int, open_tag : String, close_tag : String) -> Int {
  let open_marker = "{{" + open_tag
  let close_marker = "{{" + close_tag + "}}"
  let mut depth = 1
  let mut i = start
  let len = source.length()
  while i < len {
    let close_pos = find_str(source, close_marker, i)
    if close_pos < 0 {
      return -1
    }
    let open_pos = find_str(source, open_marker, i)
    if open_pos >= 0 && open_pos < close_pos {
      depth = depth + 1
      i = open_pos + open_marker.length()
    } else {
      depth = depth - 1
      if depth == 0 {
        return close_pos
      }
      i = close_pos + close_marker.length()
    }
  }
  -1
}

///|
/// 渲染内部 | Render internal
fn render_internal(source : String, ctx : TemplateContext) -> String {
  let mut result = ""
  let len = source.length()
  let mut i = 0
  while i < len {
    let open = find_str(source, "{{", i)
    if open < 0 {
      result = result + source[i:].to_owned()
      return result
    }
    if open > i {
      result = result + source[i:open].to_owned()
    }
    let close = find_str(source, "}}", open + 2)
    if close < 0 {
      result = result + source[open:].to_owned()
      return result
    }
    let raw_expr = source[open + 2:close].to_owned()
    let expr = trim_str(raw_expr)
    let expr_len = expr.length()
    if expr_len >= 4 && expr[0:4].to_owned() == "#if " {
      let condition = trim_str(expr[4:].to_owned())
      let block_start = close + 2
      let block_end = find_block_end(source, block_start, "#if ", "/if")
      if block_end >= 0 {
        let block_content = source[block_start:block_end].to_owned()
        let val = context_get(ctx, condition)
        let include_block = match val {
          Some(v) => v.length() > 0
          None => false
        }
        if include_block {
          result = result + render_internal(block_content, ctx)
        }
        i = block_end + 7
      } else {
        i = close + 2
      }
    } else if expr_len >= 8 && expr[0:8].to_owned() == "#unless " {
      let condition = trim_str(expr[8:].to_owned())
      let block_start = close + 2
      let block_end = find_block_end(source, block_start, "#unless ", "/unless")
      if block_end >= 0 {
        let block_content = source[block_start:block_end].to_owned()
        let val = context_get(ctx, condition)
        let exclude_block = match val {
          Some(v) => v.length() > 0
          None => false
        }
        if !exclude_block {
          result = result + render_internal(block_content, ctx)
        }
        i = block_end + 11
      } else {
        i = close + 2
      }
    } else if expr_len >= 6 && expr[0:6].to_owned() == "#each " {
      let var_name = trim_str(expr[6:].to_owned())
      let block_start = close + 2
      let block_end = find_block_end(source, block_start, "#each ", "/each")
      if block_end >= 0 {
        let block_content = source[block_start:block_end].to_owned()
        let val = context_get(ctx, var_name)
        match val {
          Some(v) => {
            if v.length() > 0 {

              let vlen = v.length()
              let mut k = 0
              while k <= vlen {
                let comma = find_str(v, ",", k)
                let item_end = if comma >= 0 { comma } else { vlen }
                let item = v[k:item_end].to_owned()
                let item_ctx = context_set(ctx, "this", item)
                result = result + render_internal(block_content, item_ctx)
                if comma < 0 {
                  break
                }
                k = comma + 1
              }
            }
          }
          None => ()
        }
        i = block_end + 9
      } else {
        i = close + 2
      }
    } else {
      let val = context_get(ctx, expr)
      match val {
        Some(v) => result = result + v
        None => ()
      }
      i = close + 2
    }
  }
  result
}

///|
/// 解析模板 | Parse template
pub fn parse_template(source : String) -> Template {
  { source, }
}

///|
/// 渲染模板 | Render template
pub fn render_template(template : Template, ctx : TemplateContext) -> String {
  render_internal(template.source, ctx)
}

///|
/// 一步渲染 | One-step render
pub fn template_render(source : String, ctx : TemplateContext) -> String {
  render_internal(source, ctx)
}

///|
/// 模板版本 | Template version
pub fn template_version() -> String {
  "moon-cross template v0.2.25"
}

///|
/// TemplateContext 实现 Countable trait | TemplateContext implements Countable
pub impl @trait.Countable for TemplateContext with count(self) {
  self.vars.length()
}
pub extend TemplateContext with @trait.Countable::{count}

///|
/// Template 实现 Named trait | Template implements Named
pub impl @trait.Named for Template with name(self) {
  self.source
}
pub extend Template with @trait.Named::{name}

///|
/// TemplateContext 实现 Iterable trait | TemplateContext implements Iterable
pub impl @trait.Iterable for TemplateContext with iter_count(self) {
  self.vars.length()
}
pub extend TemplateContext with @trait.Iterable::{iter_count}