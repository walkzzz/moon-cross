test "rle_encode_simple" {
  assert_eq(@compress.rle_encode("aaabbbccc"), "3a3b3c")
}

test "rle_encode_single" {
  assert_eq(@compress.rle_encode("a"), "1a")
}

test "rle_encode_empty" {
  assert_eq(@compress.rle_encode(""), "")
}

test "rle_encode_mixed" {
  assert_eq(@compress.rle_encode("aabbbcccc"), "2a3b4c")
}

test "rle_decode_simple" {
  assert_eq(@compress.rle_decode("3a3b3c"), "aaabbbccc")
}

test "rle_decode_single" {
  assert_eq(@compress.rle_decode("1a"), "a")
}

test "rle_decode_empty" {
  assert_eq(@compress.rle_decode(""), "")
}

test "rle_decode_mixed" {
  assert_eq(@compress.rle_decode("2a3b4c"), "aabbbcccc")
}

test "rle_encode_decode_roundtrip" {
  let original = "aaabbbcccdddeee"
  let encoded = @compress.rle_encode(original)
  let decoded = @compress.rle_decode(encoded)
  assert_eq(decoded, original)
}

test "rle_encode_large_count" {
  let original = "aaaaaaaaaa"
  let encoded = @compress.rle_encode(original)
  assert_eq(encoded, "10a")
  let decoded = @compress.rle_decode(encoded)
  assert_eq(decoded, original)
}

test "compress_stats" {
  let stats = @compress.compress_stats("aaabbbccc", "3a3b3c")
  assert_eq(stats.original_size, 9)
  assert_eq(stats.compressed_size, 6)
  assert_eq(stats.ratio, 66)
}

test "compress_stats_empty" {
  let stats = @compress.compress_stats("", "")
  assert_eq(stats.original_size, 0)
  assert_eq(stats.ratio, 0)
}

test "dict_encode_lowercase" {
  let encoded = @compress.dict_encode("abc")
  assert_true(encoded.contains("1"))
  assert_true(encoded.contains("2"))
  assert_true(encoded.contains("3"))
}

test "dict_encode_uppercase" {
  let encoded = @compress.dict_encode("ABC")
  assert_true(encoded.contains("27"))
  assert_true(encoded.contains("28"))
  assert_true(encoded.contains("29"))
}

test "dict_encode_non_alpha" {
  let encoded = @compress.dict_encode("a1b")
  assert_true(encoded.contains("1"))
  assert_true(encoded.contains("1"))
  assert_true(encoded.contains("2"))
}

test "compress_version" {
  let v = @compress.compress_version()
  assert_true(v.contains("compress"))
}