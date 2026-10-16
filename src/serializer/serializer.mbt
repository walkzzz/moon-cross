///|
/// 序列化格式 | Serialization format
pub(all) enum SerializeFormat {
  Json
  Binary
  Text
} derive(Debug, Eq)
pub extend SerializeFormat with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SerializeFormat with Eq::{not_equal, equal}

///|
/// 字段类型 | Field type
pub(all) enum FieldType {
  IntType
  DoubleType
  StringType
  BoolType
  ArrayType
  ObjectType
} derive(Debug, Eq)
pub extend FieldType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FieldType with Eq::{not_equal, equal}

///|
/// 序列化字段 | Serialized field
pub(all) struct SerializedField {
  name : String
  typ : FieldType
  value : String
} derive(Debug, Eq)
pub extend SerializedField with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SerializedField with Eq::{not_equal, equal}

///|
/// 序列化配置 | Serialization configuration
pub(all) struct SerializeConfig {
  format : SerializeFormat
  indent : Int
  include_nulls : Bool
  max_depth : Int
} derive(Debug, Eq)
pub extend SerializeConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SerializeConfig with Eq::{not_equal, equal}

///|
/// 默认序列化配置 | Default serialization configuration
pub fn default_serialize_config() -> SerializeConfig {
  { format: Json, indent: 2, include_nulls: false, max_depth: 100 }
}

///|
/// 格式名称 | Format name
pub fn format_name(format : SerializeFormat) -> String {
  match format {
    Json => "json"
    Binary => "binary"
    Text => "text"
  }
}

///|
/// 字段类型名称 | Field type name
pub fn field_type_name(typ : FieldType) -> String {
  match typ {
    IntType => "int"
    DoubleType => "double"
    StringType => "string"
    BoolType => "bool"
    ArrayType => "array"
    ObjectType => "object"
  }
}

///|
/// 创建序列化字段 | Create serialized field
pub fn make_field(
  name : String,
  typ : FieldType,
  value : String,
) -> SerializedField {
  { name, typ, value }
}

///|
/// 序列化整数 | Serialize integer
pub fn serialize_int(i : Int) -> String {
  i.to_string()
}

///|
/// 序列化浮点数 | Serialize double
pub fn serialize_double(d : Double) -> String {
  d.to_string()
}

///|
/// 序列化布尔值 | Serialize boolean
pub fn serialize_bool(b : Bool) -> String {
  if b {
    "true"
  } else {
    "false"
  }
}

///|
/// 转义字符串 | Escape string
pub fn escape_string(s : String) -> String {
  let mut result = "\""
  let n = s.length()
  for i in 0..<n {
    let c = s[i].to_int()
    if c == 34 {
      result = result + "\\\""
    } else if c == 92 {
      result = result + "\\\\"
    } else if c == 10 {
      result = result + "\\n"
    } else if c == 13 {
      result = result + "\\r"
    } else if c == 9 {
      result = result + "\\t"
    } else {
      result = result + s[i:i + 1].to_owned()
    }
  }
  result + "\""
}

///|
/// 序列化字符串 | Serialize string
pub fn serialize_string(s : String) -> String {
  escape_string(s)
}

///|
/// 序列化数组 | Serialize array
pub fn serialize_array(items : Array[String]) -> String {
  let mut result = "["
  let mut first = true
  for item in items {
    if first {
      result = result + escape_string(item)
      first = false
    } else {
      result = result + ", " + escape_string(item)
    }
  }
  result + "]"
}

///|
/// 序列化整数数组 | Serialize integer array
pub fn serialize_int_array(items : Array[Int]) -> String {
  let mut result = "["
  let mut first = true
  for item in items {
    if first {
      result = result + item.to_string()
      first = false
    } else {
      result = result + ", " + item.to_string()
    }
  }
  result + "]"
}

///|
/// 序列化对象 | Serialize object
pub fn serialize_object(fields : Array[SerializedField]) -> String {
  let mut result = "{"
  let mut first = true
  for field in fields {
    if first {
      result = result + escape_string(field.name) + ": " + field.value
      first = false
    } else {
      result = result + ", " + escape_string(field.name) + ": " + field.value
    }
  }
  result + "}"
}

///|
/// 反序列化整数 | Deserialize integer
pub fn deserialize_int(s : String) -> Int {
  let mut result = 0
  let mut sign = 1
  let mut start = 0
  let n = s.length()
  if n == 0 {
    return 0
  }
  if s[0].to_int() == 45 {
    sign = -1
    start = 1
  }
  for i in start..<n {
    let c = s[i].to_int()
    if c >= 48 && c <= 57 {
      result = result * 10 + (c - 48)
    }
  }
  result * sign
}

///|
/// 反序列化布尔值 | Deserialize boolean
pub fn deserialize_bool(s : String) -> Bool {
  s == "true"
}

///|
/// 反序列化字符串（去除引号） | Deserialize string (strip quotes)
pub fn deserialize_string(s : String) -> String {
  let n = s.length()
  if n < 2 {
    return s
  }
  if s[0].to_int() == 34 && s[n - 1].to_int() == 34 {
    s[1:n - 1].to_owned()
  } else {
    s
  }
}

///|
/// 序列化器版本 | Serializer version
pub fn serializer_version() -> String {
  "moon-cross serializer v0.2.7"
}

///|
/// 空对象 | Empty object
pub fn empty_object() -> String {
  "{}"
}

///|
/// 空数组 | Empty array
pub fn empty_array() -> String {
  "[]"
}

///|
/// 合并对象 | Merge objects (concatenate fields)
pub fn merge_objects(
  fields1 : Array[SerializedField],
  fields2 : Array[SerializedField],
) -> Array[SerializedField] {
  let result = []
  for f in fields1 {
    result.push(f)
  }
  for f in fields2 {
    result.push(f)
  }
  result
}

///|
/// 按名称查找字段 | Find field by name
pub fn find_field(
  fields : Array[SerializedField],
  name : String,
) -> SerializedField? {
  for field in fields {
    if field.name == name {
      return Some(field)
    }
  }
  None
}

///|
/// 过滤字段 | Filter fields by type
pub fn filter_by_type(
  fields : Array[SerializedField],
  typ : FieldType,
) -> Array[SerializedField] {
  let result = []
  for field in fields {
    if field.typ == typ {
      result.push(field)
    }
  }
  result
}

///|
/// 字段数 | Field count
pub fn field_count(fields : Array[SerializedField]) -> Int {
  fields.length()
}

///|
/// 提取字段名列表 | Extract field names
pub fn field_names(fields : Array[SerializedField]) -> Array[String] {
  let result = []
  for field in fields {
    result.push(field.name)
  }
  result
}