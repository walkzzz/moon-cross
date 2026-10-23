test "contains_chinese" {

  assert_true(@pinyin_integration.is_chinese("你好"))
  assert_true(@pinyin_integration.is_chinese("世界"))
  assert_false(@pinyin_integration.is_chinese("hello"))
  assert_false(@pinyin_integration.is_chinese("123"))
}

test "convert_chinese basic" {
  let result = @pinyin_integration.convert_chinese("你好")
  assert_true(result.has_chinese)
  assert_eq(result.input, "你好")
}

test "convert_chinese non-chinese" {
  let result = @pinyin_integration.convert_chinese("hello")
  assert_false(result.has_chinese)
}

test "get_short_pinyin" {
  let result = @pinyin_integration.get_short_pinyin("你好")
  assert_true(result.length() > 0)
}

test "convert_with_tone" {
  let result = @pinyin_integration.convert_with_tone("你好")
  assert_true(result.length() > 0)
}

test "convert_without_tone" {
  let result = @pinyin_integration.convert_without_tone("你好")
  assert_true(result.length() > 0)
}

test "convert_chinese mixed" {
  let result = @pinyin_integration.convert_chinese("你好world")
  assert_true(result.has_chinese)
}

test "pinyin_integration_version" {
  assert_eq(@pinyin_integration.pinyin_integration_version(), "moon-cross pinyin_integration v0.3.22")
}