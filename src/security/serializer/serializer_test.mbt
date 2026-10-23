test "default_serialize_config" {
  let cfg = @serializer.default_serialize_config()
  assert_eq(cfg.format, @serializer.SerializeFormat::Json)
  assert_eq(cfg.indent, 2)
  assert_true(!cfg.include_nulls)
}

test "format_name" {
  assert_eq(@serializer.format_name(@serializer.SerializeFormat::Json), "json")
  assert_eq(@serializer.format_name(@serializer.SerializeFormat::Binary), "binary")
  assert_eq(@serializer.format_name(@serializer.SerializeFormat::Text), "text")
}

test "field_type_name" {
  assert_eq(@serializer.field_type_name(@serializer.FieldType::IntType), "int")
  assert_eq(@serializer.field_type_name(@serializer.FieldType::StringType), "string")
  assert_eq(@serializer.field_type_name(@serializer.FieldType::BoolType), "bool")
}

test "make_field" {
  let f = @serializer.make_field("name", @serializer.FieldType::StringType, "\"test\"")
  assert_eq(f.name, "name")
  assert_eq(f.typ, @serializer.FieldType::StringType)
  assert_eq(f.value, "\"test\"")
}

test "serialize_int" {
  assert_eq(@serializer.serialize_int(42), "42")
  assert_eq(@serializer.serialize_int(0), "0")
  assert_eq(@serializer.serialize_int(-1), "-1")
}

test "serialize_double" {
  assert_eq(@serializer.serialize_double(3.14), "3.14")
}

test "serialize_bool" {
  assert_eq(@serializer.serialize_bool(true), "true")
  assert_eq(@serializer.serialize_bool(false), "false")
}

test "escape_string" {
  let result = @serializer.escape_string("hello")
  assert_eq(result, "\"hello\"")
}

test "escape_string_with_quotes" {
  let result = @serializer.escape_string("say \"hi\"")
  assert_true(result.contains("\\\""))
}

test "escape_string_with_newline" {
  let result = @serializer.escape_string("a\nb")
  assert_true(result.contains("\\n"))
}

test "serialize_string" {
  let result = @serializer.serialize_string("test")
  assert_eq(result, "\"test\"")
}

test "serialize_array" {
  let result = @serializer.serialize_array(["a", "b", "c"])
  assert_true(result.contains("\"a\""))
  assert_true(result.contains("\"b\""))
  assert_true(result.contains("\"c\""))
}

test "serialize_array_empty" {
  let result = @serializer.serialize_array([])
  assert_eq(result, "[]")
}

test "serialize_int_array" {
  let result = @serializer.serialize_int_array([1, 2, 3])
  assert_true(result.contains("1"))
  assert_true(result.contains("2"))
  assert_true(result.contains("3"))
}

test "serialize_object" {
  let f1 = @serializer.make_field("name", @serializer.FieldType::StringType, "\"test\"")
  let f2 = @serializer.make_field("age", @serializer.FieldType::IntType, "25")
  let result = @serializer.serialize_object([f1, f2])
  assert_true(result.contains("name"))
  assert_true(result.contains("age"))
}

test "serialize_object_empty" {
  let result = @serializer.serialize_object([])
  assert_eq(result, "{}")
}

test "deserialize_int" {
  assert_eq(@serializer.deserialize_int("42"), 42)
  assert_eq(@serializer.deserialize_int("0"), 0)
}

test "deserialize_bool" {
  assert_true(@serializer.deserialize_bool("true"))
  assert_true(!@serializer.deserialize_bool("false"))
}

test "deserialize_string" {
  assert_eq(@serializer.deserialize_string("\"hello\""), "hello")
}

test "deserialize_string_no_quotes" {
  assert_eq(@serializer.deserialize_string("hello"), "hello")
}

test "serializer_version" {
  let v = @serializer.serializer_version()
  assert_true(v.contains("serializer"))
}

test "empty_object" {
  assert_eq(@serializer.empty_object(), "{}")
}

test "empty_array" {
  assert_eq(@serializer.empty_array(), "[]")
}

test "merge_objects" {
  let f1 = @serializer.make_field("a", @serializer.FieldType::IntType, "1")
  let f2 = @serializer.make_field("b", @serializer.FieldType::IntType, "2")
  let merged = @serializer.merge_objects([f1], [f2])
  assert_eq(merged.length(), 2)
}

test "find_field" {
  let f1 = @serializer.make_field("a", @serializer.FieldType::IntType, "1")
  let f2 = @serializer.make_field("b", @serializer.FieldType::IntType, "2")
  match @serializer.find_field([f1, f2], "b") {
    Some(f) => assert_eq(f.name, "b")
    None => assert_true(false)
  }
}

test "find_field_not_found" {
  match @serializer.find_field([], "x") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "filter_by_type" {
  let f1 = @serializer.make_field("a", @serializer.FieldType::IntType, "1")
  let f2 = @serializer.make_field("b", @serializer.FieldType::StringType, "\"x\"")
  let f3 = @serializer.make_field("c", @serializer.FieldType::IntType, "3")
  let filtered = @serializer.filter_by_type([f1, f2, f3], @serializer.FieldType::IntType)
  assert_eq(filtered.length(), 2)
}

test "field_count" {
  let f1 = @serializer.make_field("a", @serializer.FieldType::IntType, "1")
  let f2 = @serializer.make_field("b", @serializer.FieldType::IntType, "2")
  assert_eq(@serializer.field_count([f1, f2]), 2)
}

test "field_names" {
  let f1 = @serializer.make_field("a", @serializer.FieldType::IntType, "1")
  let f2 = @serializer.make_field("b", @serializer.FieldType::IntType, "2")
  let names = @serializer.field_names([f1, f2])
  assert_eq(names.length(), 2)
  assert_eq(names[0], "a")
  assert_eq(names[1], "b")
}