test "hash_djb2" {
  let h1 = @crypto_util.hash_djb2("hello")
  let h2 = @crypto_util.hash_djb2("hello")
  assert_eq(h1, h2)
  let h3 = @crypto_util.hash_djb2("world")
  assert_true(h1 != h3)
}

test "hash_djb2_empty" {
  let h = @crypto_util.hash_djb2("")
  assert_eq(h, 5381)
}

test "hash_fnv1" {
  let h1 = @crypto_util.hash_fnv1("test")
  let h2 = @crypto_util.hash_fnv1("test")
  assert_eq(h1, h2)
}

test "hash_sdbm" {
  let h1 = @crypto_util.hash_sdbm("abc")
  let h2 = @crypto_util.hash_sdbm("abc")
  assert_eq(h1, h2)
}

test "hash_with_salt" {
  let cfg = @crypto_util.HashConfig::{ algorithm: "djb2", salt: "mysalt" }
  let h1 = @crypto_util.hash_with_salt("password", cfg)
  let h2 = @crypto_util.hash_with_salt("password", cfg)
  assert_eq(h1, h2)
  let h3 = @crypto_util.hash_with_salt("different", cfg)
  assert_true(h1 != h3)
}

test "hash_with_salt_algorithm" {
  let cfg_djb2 = @crypto_util.HashConfig::{ algorithm: "djb2", salt: "" }
  let cfg_fnv1 = @crypto_util.HashConfig::{ algorithm: "fnv1", salt: "" }
  let h1 = @crypto_util.hash_with_salt("test", cfg_djb2)
  let h2 = @crypto_util.hash_with_salt("test", cfg_fnv1)
  assert_true(h1 != h2)
}

test "hex_encode" {
  assert_eq(@crypto_util.hex_encode("A"), "41")
  assert_eq(@crypto_util.hex_encode("AB"), "4142")
}

test "hex_decode" {
  assert_eq(@crypto_util.hex_decode("41"), "A")
  assert_eq(@crypto_util.hex_decode("4142"), "AB")
}

test "hex_encode_decode_roundtrip" {
  let original = "Hello"
  let encoded = @crypto_util.hex_encode(original)
  let decoded = @crypto_util.hex_decode(encoded)
  assert_eq(decoded, original)
}

test "xor_encrypt_decrypt" {
  let plaintext = "secret"
  let key = "key"
  let encrypted = @crypto_util.xor_encrypt(plaintext, key)
  let decrypted = @crypto_util.xor_decrypt(encrypted, key)
  assert_eq(decrypted, plaintext)
}

test "xor_empty_key" {
  let result = @crypto_util.xor_encrypt("test", "")
  assert_eq(result, "test")
}

test "caesar_encrypt" {
  let enc = @crypto_util.caesar_encrypt("abc", 3)
  assert_eq(enc, "def")
}

test "caesar_decrypt" {
  let dec = @crypto_util.caesar_decrypt("def", 3)
  assert_eq(dec, "abc")
}

test "caesar_roundtrip" {
  let original = "HelloWorld"
  let enc = @crypto_util.caesar_encrypt(original, 7)
  let dec = @crypto_util.caesar_decrypt(enc, 7)
  assert_eq(dec, original)
}

test "caesar_wrap" {
  let enc = @crypto_util.caesar_encrypt("xyz", 3)
  assert_eq(enc, "abc")
}

test "caesar_uppercase" {
  let enc = @crypto_util.caesar_encrypt("XYZ", 3)
  assert_eq(enc, "ABC")
}

test "caesar_non_alpha" {
  let enc = @crypto_util.caesar_encrypt("a1b", 1)
  assert_eq(enc, "b1c")
}

test "rng_create" {
  let state = @crypto_util.rng_create(42)
  assert_eq(state.seed, 42)
  assert_eq(state.current, 42)
}

test "rng_next" {
  let state = @crypto_util.rng_create(42)
  let (new_state, val) = @crypto_util.rng_next(state)
  assert_true(val >= 0)
  assert_true(new_state.current >= 0)
}

test "rng_next_deterministic" {
  let state = @crypto_util.rng_create(123)
  let (_, val1) = @crypto_util.rng_next(state)
  let (_, val2) = @crypto_util.rng_next(state)
  assert_eq(val1, val2)
}

test "rng_range" {
  let state = @crypto_util.rng_create(42)
  let (_, val) = @crypto_util.rng_range(state, 10, 20)
  assert_true(val >= 10)
  assert_true(val < 20)
}

test "generate_salt" {
  let salt = @crypto_util.generate_salt(16, 42)
  assert_eq(salt.length(), 16)
}

test "generate_salt_deterministic" {
  let salt1 = @crypto_util.generate_salt(8, 100)
  let salt2 = @crypto_util.generate_salt(8, 100)
  assert_eq(salt1, salt2)
}

test "crypto_version" {
  let v = @crypto_util.crypto_version()
  assert_true(v.contains("crypto"))
}