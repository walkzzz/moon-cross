///|
/// zlib-cross 包装层测试 | zlib-cross wrapper tests

///|
test "zlib_roundtrip" {
  let data = b"hello moon-cross"
  let compressed = zlib_compress_data(data)
  let restored = zlib_decompress_data(compressed)
  assert_true(restored == data)
}

///|
test "deflate_roundtrip" {
  let data = b"deflate payload"
  let compressed = deflate_compress_data(data)
  let restored = deflate_decompress_data(compressed)
  assert_true(restored == data)
}

///|
test "gzip_roundtrip" {
  let data = b"gzip payload"
  let compressed = gzip_compress_data(data)
  let restored = gzip_decompress_data(compressed)
  assert_true(restored == data)
}

///|
test "adler32_known_value" {
  assert_eq(adler32_sum(b"hello"), 103547413)
}

///|
test "crc32_known_value" {
  assert_eq(crc32_sum(b"hello"), 907060870)
}

///|
test "can_decompress_rejects_garbage" {
  assert_true(zlib_can_decompress(zlib_compress_data(b"abc")))
  assert_false(zlib_can_decompress(b"not a zlib stream"))
}
