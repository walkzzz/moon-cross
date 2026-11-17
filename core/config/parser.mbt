///|
/// 配置解析器 — 从 JSON 文本解析 moon-cross.json | Config parser — parse moon-cross.json from JSON text
/// 语法错误或字段缺失时抛出 MoonCrossError::ConfigError | Raises MoonCrossError::ConfigError on malformed JSON or missing fields

///|
/// 从 JSON 对象按键取值 | Get a value from a JSON object by key
fn json_get(json : @json.Json, key : String) -> @json.Json? {
  if json is Object(obj) {
    obj.get(key)
  } else {
    None
  }
}

///|
/// 将 JSON 值解释为字符串 | Interpret a JSON value as string
fn json_as_string(json : @json.Json) -> String? {
  if json is String(s) {
    Some(s)
  } else {
    None
  }
}

///|
/// 将 JSON 值解释为数字 | Interpret a JSON value as number
fn json_as_number(json : @json.Json) -> Double? {
  if json is Number(n, ..) {
    Some(n)
  } else {
    None
  }
}

///|
/// 将 JSON 值解释为数组 | Interpret a JSON value as array
fn json_as_array(json : @json.Json) -> Array[@json.Json]? {
  if json is Array(arr) {
    Some(arr)
  } else {
    None
  }
}

///|
/// 从 JSON 文本解析完整跨平台配置 | Parse full cross-platform config from JSON text
pub fn parse_config(text : String) -> CrossConfig raise @core.MoonCrossError {
  let json = @json.parse(text) catch {
    _ => raise @core.ConfigError("invalid JSON syntax | JSON 语法错误")
  }
  let version = match json_get(json, "version") {
    Some(v) =>
      match json_as_number(v) {
        Some(n) => n.to_int()
        None => 1
      }
    None => 1
  }
  let module_path = require_string(json, "module_path")
  let package_name = require_string(json, "package_name")
  let targets = parse_targets(json)
  let functions = parse_functions(json)
  let types = parse_types(json)
  { version, module_path, package_name, targets, functions, types, }
}

///|
/// 提取必填字符串字段 | Extract a required string field
fn require_string(
  json : @json.Json,
  key : String,
) -> String raise @core.MoonCrossError {
  match json_get(json, key) {
    Some(v) =>
      match json_as_string(v) {
        Some(s) => s
        None =>
          raise @core.ConfigError(
            "invalid string field: \{key} | 非法字符串字段: \{key}",
          )
      }
    None =>
      raise @core.ConfigError("missing field: \{key} | 缺失字段: \{key}")
  }
}

///|
/// 平台字符串转 Platform 枚举 | Convert platform string to Platform enum
fn platform_from_string(s : String) -> @core.Platform? {
  match s {
    "ios" => Some(Ios)
    "android" => Some(Android)
    "windows" => Some(Windows)
    "ohos" => Some(Ohos)
    "linux" => Some(Linux)
    _ => None
  }
}

///|
/// 解析目标平台列表（缺省为全平台） | Parse target platform list (defaults to all platforms)
fn parse_targets(json : @json.Json) -> Array[@core.Platform] {
  let targets : Array[@core.Platform] = []
  match json_get(json, "targets") {
    Some(v) =>
      match json_as_array(v) {
        Some(arr) =>
          for item in arr {
            match json_as_string(item) {
              Some(s) =>
                match platform_from_string(s) {
                  Some(p) => targets.push(p)
                  None => ()
                }
              None => ()
            }
          }
        None => return @core.all_platforms()
      }
    None => return @core.all_platforms()
  }
  if targets.is_empty() {
    @core.all_platforms()
  } else {
    targets
  }
}

///|
/// 解析导出函数列表 | Parse export function list
fn parse_functions(
  json : @json.Json,
) -> Array[ExportFunction] raise @core.MoonCrossError {
  let functions : Array[ExportFunction] = []
  match json_get(json, "functions") {
    Some(v) =>
      match json_as_array(v) {
        Some(arr) =>
          for item in arr {
            let name = require_string(item, "name")
            let return_type = require_string(item, "return_type")
            let params : Array[ExportParam] = []
            match json_get(item, "params") {
              Some(pv) =>
                match json_as_array(pv) {
                  Some(parr) =>
                    for p in parr {
                      params.push({
                        name: require_string(p, "name"),
                        typ: require_string(p, "typ"),
                      })
                    }
                  None => ()
                }
              None => ()
            }
            functions.push({ name, params, return_type, })
          }
        None => ()
      }
    None => ()
  }
  functions
}

///|
/// 解析导出类型列表 | Parse export type list
fn parse_types(
  json : @json.Json,
) -> Array[ExportType] raise @core.MoonCrossError {
  let types : Array[ExportType] = []
  match json_get(json, "types") {
    Some(v) =>
      match json_as_array(v) {
        Some(arr) =>
          for item in arr {
            let name = require_string(item, "name")
            let fields : Array[ExportField] = []
            match json_get(item, "fields") {
              Some(fv) =>
                match json_as_array(fv) {
                  Some(farr) =>
                    for f in farr {
                      fields.push({
                        name: require_string(f, "name"),
                        typ: require_string(f, "typ"),
                      })
                    }
                  None => ()
                }
              None => ()
            }
            types.push({ name, fields, })
          }
        None => ()
      }
    None => ()
  }
  types
}
