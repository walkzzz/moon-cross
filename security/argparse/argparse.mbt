///|
/// 参数类型 | Argument type
pub(all) enum ArgType {
  String
  Int
  Bool
  Flag
} derive(Debug, Eq)
pub extend ArgType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ArgType with Eq::{not_equal, equal}

///|
/// 参数定义 | Argument definition
pub(all) struct ArgDef {
  name : String
  short : String
  long : String
  typ : ArgType
  required : Bool
  default_value : String
  description : String
} derive(Debug, Eq)
pub extend ArgDef with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ArgDef with Eq::{not_equal, equal}

///|
/// 解析结果 | Parse result
pub(all) struct ParseResult {
  values : Array[(String, String)]
  positional : Array[String]
  errors : Array[String]
} derive(Debug, Eq)
pub extend ParseResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ParseResult with Eq::{not_equal, equal}

///|
/// 参数解析器 | Argument parser
pub(all) struct ArgParser {
  name : String
  description : String
  args : Array[ArgDef]
  subcommands : Array[String]
} derive(Debug, Eq)
pub extend ArgParser with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ArgParser with Eq::{not_equal, equal}

///|
/// 参数类型名称 | Argument type name
pub fn arg_type_name(typ : ArgType) -> String {
  match typ {
    String => "STRING"
    Int => "INT"
    Bool => "BOOL"
    Flag => "FLAG"
  }
}

///|
/// 创建参数解析器 | Create argument parser
pub fn create_parser(name : String, description : String) -> ArgParser {
  { name, description, args: [], subcommands: [] }
}

///|
/// 添加参数定义 | Add argument definition
pub fn add_arg(parser : ArgParser, def : ArgDef) -> ArgParser {
  let new_args = []
  for a in parser.args {
    new_args.push(a)
  }
  new_args.push(def)
  { ..parser, args: new_args }
}

///|
/// 添加子命令 | Add subcommand
pub fn add_subcommand(parser : ArgParser, name : String) -> ArgParser {
  let new_subs = []
  for s in parser.subcommands {
    new_subs.push(s)
  }
  new_subs.push(name)
  { ..parser, subcommands: new_subs }
}

///|
/// 创建参数定义 | Create argument definition
pub fn make_arg(
  name : String,
  short : String,
  long : String,
  typ : ArgType,
  required : Bool,
  default_value : String,
  description : String,
) -> ArgDef {
  { name, short, long, typ, required, default_value, description }
}

///|
/// 创建标志参数 | Create flag argument
pub fn make_flag(name : String, short : String, long : String, description : String) -> ArgDef {
  { name, short, long, typ: Flag, required: false, default_value: "false", description }
}

///|
/// 创建字符串参数 | Create string argument
pub fn make_string_arg(name : String, short : String, long : String, required : Bool, description : String) -> ArgDef {
  { name, short, long, typ: String, required, default_value: "", description }
}

///|
/// 创建整数参数 | Create int argument
pub fn make_int_arg(name : String, short : String, long : String, required : Bool, description : String) -> ArgDef {
  { name, short, long, typ: Int, required, default_value: "0", description }
}

///|
/// 解析参数 | Parse arguments
pub fn parse_args(parser : ArgParser, args : Array[String]) -> ParseResult {
  let values = []
  let positional = []
  let errors = []
  let mut i = 0
  while i < args.length() {
    let arg = args[i]
    if arg.length() >= 2 && arg[0] == '-' && arg[1] == '-' {
      let long_name = arg[2:].to_owned()
      let mut found = false
      for def in parser.args {
        if def.long == long_name {
          found = true
          if def.typ is Flag {
            values.push((def.name, "true"))
          } else {
            if i + 1 < args.length() {
              values.push((def.name, args[i + 1]))
              i = i + 1
            } else {
              errors.push("Missing value for --" + long_name)
            }
          }
        }
      }
      if !found {
        errors.push("Unknown option: --" + long_name)
      }
    } else if arg.length() >= 1 && arg[0] == '-' {
      let short_name = arg[1:].to_owned()
      let mut found = false
      for def in parser.args {
        if def.short == short_name {
          found = true
          if def.typ is Flag {
            values.push((def.name, "true"))
          } else {
            if i + 1 < args.length() {
              values.push((def.name, args[i + 1]))
              i = i + 1
            } else {
              errors.push("Missing value for -" + short_name)
            }
          }
        }
      }
      if !found {
        errors.push("Unknown option: -" + short_name)
      }
    } else {
      positional.push(arg)
    }
    i = i + 1
  }
  for def in parser.args {
    if def.required {
      let mut found = false
      for v in values {
        if v.0 == def.name {
          found = true
        }
      }
      if !found {
        errors.push("Missing required argument: " + def.name)
      }
    }
  }
  { values, positional, errors }
}

///|
/// 获取解析值 | Get parsed value
pub fn get_value(result : ParseResult, name : String) -> String? {
  for v in result.values {
    if v.0 == name {
      return Some(v.1)
    }
  }
  None
}

///|
/// 获取默认值 | Get value or default
pub fn get_value_or(result : ParseResult, name : String, default : String) -> String {
  for v in result.values {
    if v.0 == name {
      return v.1
    }
  }
  default
}

///|
/// 检查标志是否设置 | Check if flag is set
pub fn has_flag(result : ParseResult, name : String) -> Bool {
  for v in result.values {
    if v.0 == name && v.1 == "true" {
      return true
    }
  }
  false
}

///|
/// 解析是否成功 | Parse succeeded
pub fn parse_success(result : ParseResult) -> Bool {
  result.errors.length() == 0
}

///|
/// 错误数量 | Error count
pub fn error_count(result : ParseResult) -> Int {
  result.errors.length()
}

///|
/// 位置参数数量 | Positional count
pub fn positional_count(result : ParseResult) -> Int {
  result.positional.length()
}

///|
/// 生成帮助文本 | Generate help text
pub fn generate_help(parser : ArgParser) -> String {
  let mut help = "Usage: " + parser.name + " [OPTIONS]"
  if parser.subcommands.length() > 0 {
    help = help + " <SUBCOMMAND>"
  }
  help = help + "\n\n" + parser.description + "\n\nOptions:\n"
  for def in parser.args {
    let short_part = if def.short.length() > 0 { "-" + def.short + ", " } else { "    " }
    let long_part = "--" + def.long
    let type_part = if def.typ is Flag { "" } else { " <" + arg_type_name(def.typ) + ">" }
    help = help + "  " + short_part + long_part + type_part + "  " + def.description + "\n"
  }
  if parser.subcommands.length() > 0 {
    help = help + "\nSubcommands:\n"
    for s in parser.subcommands {
      help = help + "  " + s + "\n"
    }
  }
  help
}

///|
/// 参数数量 | Argument count
pub fn arg_count(parser : ArgParser) -> Int {
  parser.args.length()
}

///|
/// 子命令数量 | Subcommand count
pub fn subcommand_count(parser : ArgParser) -> Int {
  parser.subcommands.length()
}

///|
/// 是否有参数 | Has argument
pub fn has_arg(parser : ArgParser, name : String) -> Bool {
  for def in parser.args {
    if def.name == name {
      return true
    }
  }
  false
}

///|
/// 合并解析器 | Merge parsers
pub fn merge_parsers(p1 : ArgParser, p2 : ArgParser) -> ArgParser {
  let new_args = []
  for a in p1.args {
    new_args.push(a)
  }
  for a in p2.args {
    new_args.push(a)
  }
  let new_subs = []
  for s in p1.subcommands {
    new_subs.push(s)
  }
  for s in p2.subcommands {
    new_subs.push(s)
  }
  { name: p1.name, description: p1.description, args: new_args, subcommands: new_subs }
}

///|
/// 解析器版本 | Parser version
pub fn argparse_version() -> String {
  "moon-cross argparse v0.2.21"
}

///|
/// ArgDef 实现 Named trait | ArgDef implements Named
pub impl @trait.Named for ArgDef with name(self) {
  self.name
}
pub extend ArgDef with @trait.Named::{name}

///|
/// ArgParser 实现 Named trait | ArgParser implements Named
pub impl @trait.Named for ArgParser with name(self) {
  self.name
}
pub extend ArgParser with @trait.Named::{name}

///|
/// ArgDef 实现 Describable trait | ArgDef implements Describable
pub impl @trait.Describable for ArgDef with describe(self) {
  self.description
}
pub extend ArgDef with @trait.Describable::{describe}

///|
/// ArgParser 实现 Describable trait | ArgParser implements Describable
pub impl @trait.Describable for ArgParser with describe(self) {
  self.description
}
pub extend ArgParser with @trait.Describable::{describe}