///|
test "moonbit_to_c_int" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::IntT),
    @typesys.CType::CInt32,
  )
}

///|
test "moonbit_to_c_double" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::DoubleT),
    @typesys.CType::CDouble,
  )
}

///|
test "moonbit_to_c_bool" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::BoolT),
    @typesys.CType::CBool,
  )
}

///|
test "moonbit_to_c_string" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::StringT),
    @typesys.CType::CMoonbitString,
  )
}

///|
test "moonbit_to_c_bytes" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::BytesT),
    @typesys.CType::CMoonbitBytes,
  )
}

///|
test "moonbit_to_c_array" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::ArrayT("Double")),
    @typesys.CType::COpaquePtr,
  )
}

///|
test "moonbit_to_c_struct" {
  assert_eq(
    @typesys.moonbit_to_c(@typesys.MoonBitType::StructT("Point2D")),
    @typesys.CType::COpaquePtr,
  )
}

///|
test "parse_moonbit_type_valid" {
  assert_eq(
    @typesys.parse_moonbit_type("Int"),
    Some(@typesys.MoonBitType::IntT),
  )
  assert_eq(
    @typesys.parse_moonbit_type("Double"),
    Some(@typesys.MoonBitType::DoubleT),
  )
  assert_eq(
    @typesys.parse_moonbit_type("String"),
    Some(@typesys.MoonBitType::StringT),
  )
}

///|
test "parse_moonbit_type_invalid" {
  assert_eq(@typesys.parse_moonbit_type("Unknown"), None)
}

///|
test "parse_moonbit_type_array" {
  assert_eq(
    @typesys.parse_moonbit_type("Array[Int]"),
    Some(@typesys.MoonBitType::ArrayT("Array[Int]")),
  )
}

///|
test "parse_moonbit_type_struct" {
  assert_eq(
    @typesys.parse_moonbit_type("Struct Point2D"),
    Some(@typesys.MoonBitType::StructT("Struct Point2D")),
  )
}

///|
test "ctype_to_string" {
  assert_eq(@typesys.CType::CInt32.to_string(), "int32_t")
  assert_eq(@typesys.CType::CDouble.to_string(), "double")
  assert_eq(@typesys.CType::CVoid.to_string(), "void")
  assert_eq(@typesys.CType::COpaquePtr.to_string(), "void*")
}

///|
test "c_to_moonbit" {
  assert_eq(
    @typesys.c_to_moonbit(@typesys.CType::CInt32),
    @typesys.MoonBitType::IntT,
  )
  assert_eq(
    @typesys.c_to_moonbit(@typesys.CType::CDouble),
    @typesys.MoonBitType::DoubleT,
  )
  assert_eq(
    @typesys.c_to_moonbit(@typesys.CType::CVoid),
    @typesys.MoonBitType::UnitT,
  )
  assert_eq(
    @typesys.c_to_moonbit(@typesys.CType::CMoonbitString),
    @typesys.MoonBitType::StringT,
  )
}

///|
test "moonbit_to_c_string_fn" {
  assert_eq(@typesys.moonbit_to_c_string(@typesys.MoonBitType::IntT), "int32_t")
  assert_eq(
    @typesys.moonbit_to_c_string(@typesys.MoonBitType::StringT),
    "moonbit_string_t",
  )
}

///|
test "moonbit_to_swift_string" {
  assert_eq(
    @typesys.moonbit_to_swift_string(@typesys.MoonBitType::IntT),
    "Int32",
  )
  assert_eq(
    @typesys.moonbit_to_swift_string(@typesys.MoonBitType::DoubleT),
    "Double",
  )
  assert_eq(
    @typesys.moonbit_to_swift_string(@typesys.MoonBitType::StringT),
    "String",
  )
}

///|
test "moonbit_to_kotlin_string" {
  assert_eq(
    @typesys.moonbit_to_kotlin_string(@typesys.MoonBitType::IntT),
    "Int",
  )
  assert_eq(
    @typesys.moonbit_to_kotlin_string(@typesys.MoonBitType::BoolT),
    "Boolean",
  )
  assert_eq(
    @typesys.moonbit_to_kotlin_string(@typesys.MoonBitType::BytesT),
    "ByteArray",
  )
}

///|
test "moonbit_to_csharp_string" {
  assert_eq(
    @typesys.moonbit_to_csharp_string(@typesys.MoonBitType::IntT),
    "int",
  )
  assert_eq(
    @typesys.moonbit_to_csharp_string(@typesys.MoonBitType::StringT),
    "string",
  )
}

///|
test "moonbit_to_arkts_string" {
  assert_eq(
    @typesys.moonbit_to_arkts_string(@typesys.MoonBitType::IntT),
    "number",
  )
  assert_eq(
    @typesys.moonbit_to_arkts_string(@typesys.MoonBitType::BoolT),
    "boolean",
  )
}

///|
test "c_marshalling_in" {
  assert_eq(@typesys.c_marshalling_in(@typesys.MoonBitType::IntT, "x"), "x")
  assert_eq(
    @typesys.c_marshalling_in(@typesys.MoonBitType::StringT, "str"),
    "moonbit_string_from_cstr(str)",
  )
}

///|
test "c_marshalling_out" {
  assert_eq(@typesys.c_marshalling_out(@typesys.MoonBitType::IntT, "x"), "x")
  assert_eq(
    @typesys.c_marshalling_out(@typesys.MoonBitType::StringT, "str"),
    "moonbit_string_to_cstr(str)",
  )
}

///|
test "needs_gc_management" {
  assert_eq(@typesys.needs_gc_management(@typesys.MoonBitType::IntT), false)
  assert_eq(@typesys.needs_gc_management(@typesys.MoonBitType::StringT), true)
  assert_eq(@typesys.needs_gc_management(@typesys.MoonBitType::BytesT), true)
}

///|
test "typesys_version" {
  assert_eq(@typesys.typesys_version(), "moon-cross typesys v0.3.33")
}
