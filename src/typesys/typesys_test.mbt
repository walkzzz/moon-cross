test "moonbit_to_c_int" {
  assert_eq(moonbit_to_c(MoonBitType::IntT), CType::CInt32)
}

test "moonbit_to_c_double" {
  assert_eq(moonbit_to_c(MoonBitType::DoubleT), CType::CDouble)
}

test "moonbit_to_c_bool" {
  assert_eq(moonbit_to_c(MoonBitType::BoolT), CType::CBool)
}

test "moonbit_to_c_string" {
  assert_eq(moonbit_to_c(MoonBitType::StringT), CType::CMoonbitString)
}

test "moonbit_to_c_bytes" {
  assert_eq(moonbit_to_c(MoonBitType::BytesT), CType::CMoonbitBytes)
}

test "moonbit_to_c_array" {
  assert_eq(moonbit_to_c(MoonBitType::ArrayT("Double")), CType::COpaquePtr)
}

test "moonbit_to_c_struct" {
  assert_eq(moonbit_to_c(MoonBitType::StructT("Point2D")), CType::COpaquePtr)
}

test "parse_moonbit_type_valid" {
  assert_eq(parse_moonbit_type("Int"), Some(MoonBitType::IntT))
  assert_eq(parse_moonbit_type("Double"), Some(MoonBitType::DoubleT))
  assert_eq(parse_moonbit_type("String"), Some(MoonBitType::StringT))
}

test "parse_moonbit_type_invalid" {
  assert_eq(parse_moonbit_type("Unknown"), None)
}

test "ctype_to_string" {
  assert_eq(CType::CInt32.to_string(), "int32_t")
  assert_eq(CType::CDouble.to_string(), "double")
  assert_eq(CType::CVoid.to_string(), "void")
  assert_eq(CType::COpaquePtr.to_string(), "void*")
}