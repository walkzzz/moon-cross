///|
/// MoonBit 源类型 | MoonBit source type
pub(all) enum MoonBitType {
  IntT
  DoubleT
  BoolT
  UnitT
  StringT
  BytesT
  ArrayT(String)
  StructT(String)
} derive(Debug, Eq)

///|
/// C 适配层类型 | C adapter type
pub(all) enum CType {
  CInt32
  CDouble
  CBool
  CVoid
  CMoonbitString
  CMoonbitBytes
  COpaquePtr
} derive(Debug, Eq)

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
/// 从字符串解析 MoonBit 类型 | Parse MoonBit type from string
pub fn parse_moonbit_type(s : String) -> MoonBitType? {
  match s {
    "Int" => Some(IntT)
    "Double" => Some(DoubleT)
    "Bool" => Some(BoolT)
    "Unit" => Some(UnitT)
    "String" => Some(StringT)
    "Bytes" => Some(BytesT)
    _ => None
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
