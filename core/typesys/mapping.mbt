///|
/// MoonBit 源类型 | MoonBit source type
#derive(Debug, Eq)
pub(all) enum MoonBitType {
  IntT
  DoubleT
  BoolT
  UnitT
  StringT
  BytesT
  ArrayT(String)
  StructT(String)
}

///|
pub extend MoonBitType with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend MoonBitType with Eq::{not_equal, equal}

///|
/// C 适配层类型 | C adapter type
#derive(Debug, Eq)
pub(all) enum CType {
  CInt32
  CDouble
  CBool
  CVoid
  CMoonbitString
  CMoonbitBytes
  COpaquePtr
}

///|
pub extend CType with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend CType with Eq::{not_equal, equal}

///|
/// C 类型转字符串 | C type to string
pub fn CType::to_string(self : CType) -> String {
  match self {
    CInt32 => "int32_t"
    CDouble => "double"
    CBool => "int32_t"
    CVoid => "void"
    CMoonbitString => "moonbit_string_t"
    CMoonbitBytes => "moonbit_bytes_t"
    COpaquePtr => "void*"
  }
}

///|
/// MoonBit 类型转 C 类型 | MoonBit type to C type
pub fn moonbit_to_c(t : MoonBitType) -> CType {
  match t {
    IntT => CInt32
    DoubleT => CDouble
    BoolT => CBool
    UnitT => CVoid
    StringT => CMoonbitString
    BytesT => CMoonbitBytes
    ArrayT(_) => COpaquePtr
    StructT(_) => COpaquePtr
  }
}

///|
/// C 类型转 MoonBit 类型（反向映射） | C type to MoonBit type (reverse mapping)
pub fn c_to_moonbit(t : CType) -> MoonBitType {
  match t {
    CInt32 => IntT
    CDouble => DoubleT
    CBool => BoolT
    CVoid => UnitT
    CMoonbitString => StringT
    CMoonbitBytes => BytesT
    COpaquePtr => StructT("Opaque")
  }
}

///|
/// 从字符串解析 MoonBit 类型（支持复合类型） | Parse MoonBit type from string (supports composite types)
pub fn parse_moonbit_type(s : String) -> MoonBitType? {
  match s {
    "Int" => Some(IntT)
    "Double" => Some(DoubleT)
    "Bool" => Some(BoolT)
    "Unit" => Some(UnitT)
    "String" => Some(StringT)
    "Bytes" => Some(BytesT)
    _ =>
      if s.contains("Array[") {
        Some(ArrayT(s))
      } else if s.contains("Struct ") {
        Some(StructT(s))
      } else {
        None
      }
  }
}

///|
/// MoonBit 类型转字符串 | MoonBit type to string
pub fn MoonBitType::to_string(self : MoonBitType) -> String {
  match self {
    IntT => "Int"
    DoubleT => "Double"
    BoolT => "Bool"
    UnitT => "Unit"
    StringT => "String"
    BytesT => "Bytes"
    ArrayT(inner) => "Array[" + inner + "]"
    StructT(name) => name
  }
}

///|
/// MoonBit 类型转 C 类型字符串 | MoonBit type to C type string
pub fn moonbit_to_c_string(t : MoonBitType) -> String {
  moonbit_to_c(t).to_string()
}

///|
/// Swift 类型映射 | Swift type mapping
pub fn moonbit_to_swift_string(t : MoonBitType) -> String {
  match t {
    IntT => "Int32"
    DoubleT => "Double"
    BoolT => "Bool"
    UnitT => "Void"
    StringT => "String"
    BytesT => "Data"
    ArrayT(_) => "UnsafePointer<OpaquePointer>"
    StructT(_) => "UnsafePointer<OpaquePointer>"
  }
}

///|
/// Kotlin 类型映射 | Kotlin type mapping
pub fn moonbit_to_kotlin_string(t : MoonBitType) -> String {
  match t {
    IntT => "Int"
    DoubleT => "Double"
    BoolT => "Boolean"
    UnitT => "Unit"
    StringT => "String"
    BytesT => "ByteArray"
    ArrayT(_) => "Long"
    StructT(_) => "Long"
  }
}

///|
/// C# 类型映射 | C# type mapping
pub fn moonbit_to_csharp_string(t : MoonBitType) -> String {
  match t {
    IntT => "int"
    DoubleT => "double"
    BoolT => "bool"
    UnitT => "void"
    StringT => "string"
    BytesT => "byte[]"
    ArrayT(_) => "IntPtr"
    StructT(_) => "IntPtr"
  }
}

///|
/// ArkTS 类型映射 | ArkTS type mapping
pub fn moonbit_to_arkts_string(t : MoonBitType) -> String {
  match t {
    IntT => "number"
    DoubleT => "number"
    BoolT => "boolean"
    UnitT => "void"
    StringT => "string"
    BytesT => "Uint8Array"
    ArrayT(_) => "Object"
    StructT(_) => "Object"
  }
}

///|
/// 生成 C→MoonBit marshalling 代码片段 | Generate C→MoonBit marshalling code snippet
pub fn c_marshalling_in(mbt_type : MoonBitType, c_var : String) -> String {
  match mbt_type {
    IntT => c_var
    DoubleT => c_var
    BoolT => c_var
    UnitT => "()"
    StringT => "moonbit_string_from_cstr(" + c_var + ")"
    BytesT => "moonbit_bytes_from_c(" + c_var + ", " + c_var + "_len)"
    ArrayT(_) => "moonbit_array_from_c(" + c_var + ")"
    StructT(_) => "moonbit_struct_from_c(" + c_var + ")"
  }
}

///|
/// 生成 MoonBit→C marshalling 代码片段 | Generate MoonBit→C marshalling code snippet
pub fn c_marshalling_out(mbt_type : MoonBitType, mbt_var : String) -> String {
  match mbt_type {
    IntT => mbt_var
    DoubleT => mbt_var
    BoolT => mbt_var
    UnitT => ""
    StringT => "moonbit_string_to_cstr(" + mbt_var + ")"
    BytesT => "moonbit_bytes_to_c(" + mbt_var + ")"
    ArrayT(_) => "moonbit_array_to_c(" + mbt_var + ")"
    StructT(_) => "moonbit_struct_to_c(" + mbt_var + ")"
  }
}

///|
/// 判断类型是否需要 GC 管理 | Check if type needs GC management
pub fn needs_gc_management(t : MoonBitType) -> Bool {
  match t {
    IntT => false
    DoubleT => false
    BoolT => false
    UnitT => false
    StringT => true
    BytesT => true
    ArrayT(_) => true
    StructT(_) => true
  }
}

///|
/// typesys 版本 | typesys version
pub fn typesys_version() -> String {
  "moon-cross typesys v0.3.33"
}
