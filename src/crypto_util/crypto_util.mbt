///|
/// 哈希配置 | Hash configuration
pub(all) struct HashConfig {
  algorithm : String
  salt : String
} derive(Debug, Eq)
pub extend HashConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HashConfig with Eq::{not_equal, equal}

///|
/// 随机数状态 | Random state
pub(all) struct RngState {
  seed : Int
  current : Int
} derive(Debug, Eq)
pub extend RngState with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RngState with Eq::{not_equal, equal}

///|
/// DJB2 哈希 | DJB2 hash
pub fn hash_djb2(s : String) -> Int {
  let mut hash = 5381
  let len = s.length()
  let mut i = 0
  while i < len {
    hash = ((hash * 33) + s[i].to_int()) % 1000000007
    if hash < 0 {
      hash = -hash
    }
    i = i + 1
  }
  hash
}

///|
/// FNV-1 哈希 | FNV-1 hash
pub fn hash_fnv1(s : String) -> Int {
  let mut hash = 16777619
  let len = s.length()
  let mut i = 0
  while i < len {
    hash = (hash * 16777619) ^ s[i].to_int()
    if hash < 0 {
      hash = -hash
    }
    i = i + 1
  }
  hash
}

///|
/// SDBM 哈希 | SDBM hash
pub fn hash_sdbm(s : String) -> Int {
  let mut hash = 0
  let len = s.length()
  let mut i = 0
  while i < len {
    hash = s[i].to_int() + (hash * 65599)
    hash = hash % 1000000007
    if hash < 0 {
      hash = -hash
    }
    i = i + 1
  }
  hash
}

///|
/// 带盐哈希 | Hash with salt
pub fn hash_with_salt(s : String, config : HashConfig) -> Int {
  let combined = s + config.salt
  if config.algorithm == "djb2" {
    return hash_djb2(combined)
  }
  if config.algorithm == "fnv1" {
    return hash_fnv1(combined)
  }
  if config.algorithm == "sdbm" {
    return hash_sdbm(combined)
  }
  hash_djb2(combined)
}

///|
/// 十六进制编码 | Hex encode
pub fn hex_encode(data : String) -> String {
  let hex_chars = "0123456789abcdef"
  let mut result = ""
  let len = data.length()
  let mut i = 0
  while i < len {
    let c = data[i].to_int()
    let hi = c / 16
    let lo = c % 16
    result = result + hex_chars[hi:hi + 1].to_owned() + hex_chars[lo:lo + 1].to_owned()
    i = i + 1
  }
  result
}

///|
/// 十六进制解码 | Hex decode
pub fn hex_decode(hex : String) -> String {
  let mut result = ""
  let len = hex.length()
  if len < 2 {
    return ""
  }
  let mut i = 0
  while i + 1 < len {
    let h1 = hex[i].to_int()
    let h2 = hex[i + 1].to_int()
    let mut val = 0
    if h1 >= 48 && h1 <= 57 {
      val = (h1 - 48) * 16
    } else if h1 >= 97 && h1 <= 102 {
      val = (h1 - 97 + 10) * 16
    } else if h1 >= 65 && h1 <= 70 {
      val = (h1 - 65 + 10) * 16
    }
    if h2 >= 48 && h2 <= 57 {
      val = val + (h2 - 48)
    } else if h2 >= 97 && h2 <= 102 {
      val = val + (h2 - 97 + 10)
    } else if h2 >= 65 && h2 <= 70 {
      val = val + (h2 - 65 + 10)
    }
    result = result + val.unsafe_to_char().to_string()
    i = i + 2
  }
  result
}

///|
/// XOR 加密 | XOR encrypt
pub fn xor_encrypt(plaintext : String, key : String) -> String {
  let mut result = ""
  let plen = plaintext.length()
  let klen = key.length()
  if klen == 0 {
    return plaintext
  }
  let mut i = 0
  while i < plen {
    let c = plaintext[i].to_int()
    let k = key[i % klen].to_int()
    let enc = c ^ k
    result = result + enc.unsafe_to_char().to_string()
    i = i + 1
  }
  result
}

///|
/// XOR 解密 | XOR decrypt
pub fn xor_decrypt(ciphertext : String, key : String) -> String {
  xor_encrypt(ciphertext, key)
}

///|
/// 凯撒加密 | Caesar encrypt
pub fn caesar_encrypt(plaintext : String, shift : Int) -> String {
  let mut result = ""
  let len = plaintext.length()
  let effective_shift = shift % 26
  let mut i = 0
  while i < len {
    let c = plaintext[i].to_int()
    if c >= 97 && c <= 122 {
      let enc = 97 + (c - 97 + effective_shift + 26) % 26
      result = result + enc.unsafe_to_char().to_string()
    } else if c >= 65 && c <= 90 {
      let enc = 65 + (c - 65 + effective_shift + 26) % 26
      result = result + enc.unsafe_to_char().to_string()
    } else {
      result = result + plaintext[i:i + 1].to_owned()
    }
    i = i + 1
  }
  result
}

///|
/// 凯撒解密 | Caesar decrypt
pub fn caesar_decrypt(ciphertext : String, shift : Int) -> String {
  caesar_encrypt(ciphertext, -shift)
}

///|
/// 创建随机状态 | Create random state
pub fn rng_create(seed : Int) -> RngState {
  { seed, current: seed }
}

///|
/// 生成随机数 | Generate random number
pub fn rng_next(state : RngState) -> (RngState, Int) {
  let next = (state.current * 17 + 13) % 100000000
  if next < 0 {
    ({ seed: state.seed, current: -next }, -next)
  } else {
    ({ seed: state.seed, current: next }, next)
  }
}

///|
/// 生成范围随机数 | Generate random number in range
pub fn rng_range(state : RngState, min : Int, max : Int) -> (RngState, Int) {
  let (new_state, val) = rng_next(state)
  if max <= min {
    (new_state, min)
  } else {
    (new_state, min + val % (max - min))
  }
}

///|
/// 生成盐字符串 | Generate salt string
pub fn generate_salt(length : Int, seed : Int) -> String {
  let chars = "abcdefghijklmnopqrstuvwxyz0123456789"
  let mut result = ""
  let mut state = rng_create(seed)
  let mut i = 0
  while i < length {
    let (new_state, val) = rng_range(state, 0, 36)
    state = new_state
    result = result + chars[val:val + 1].to_owned()
    i = i + 1
  }
  result
}

///|
/// 加密版本 | Crypto version
pub fn crypto_version() -> String {
  "moon-cross crypto_util v0.2.27"
}

///|
/// HashConfig 实现 Named trait | HashConfig implements Named
pub impl @trait.Named for HashConfig with name(self) {
  self.algorithm
}
pub extend HashConfig with @trait.Named::{name}