test "moonbit_to_c_int" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::IntT), @typesys.CType::CInt32)
}

test "moonbit_to_c_double" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::DoubleT), @typesys.CType::CDouble)
}

test "moonbit_to_c_bool" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::BoolT), @typesys.CType::CBool)
}

test "moonbit_to_c_string" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::StringT), @typesys.CType::CMoonbitString)
}

test "moonbit_to_c_bytes" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::BytesT), @typesys.CType::CMoonbitBytes)
}

test "moonbit_to_c_array" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::ArrayT("Double")), @typesys.CType::COpaquePtr)
}

test "moonbit_to_c_struct" {
  assert_eq(@typesys.moonbit_to_c(@typesys.MoonBitType::StructT("Point2D")), @typesys.CType::COpaquePtr)
}

test "parse_moonbit_type_valid" {
  assert_eq(@typesys.parse_moonbit_type("Int"), Some(@typesys.MoonBitType::IntT))
  assert_eq(@typesys.parse_moonbit_type("Double"), Some(@typesys.MoonBitType::DoubleT))
  assert_eq(@typesys.parse_moonbit_type("String"), Some(@typesys.MoonBitType::StringT))
}

test "parse_moonbit_type_invalid" {
  assert_eq(@typesys.parse_moonbit_type("Unknown"), None)
}

test "ctype_to_string" {
  assert_eq(@typesys.CType::CInt32.to_string(), "int32_t")
  assert_eq(@typesys.CType::CDouble.to_string(), "double")
  assert_eq(@typesys.CType::CVoid.to_string(), "void")
  assert_eq(@typesys.CType::COpaquePtr.to_string(), "void*")
}