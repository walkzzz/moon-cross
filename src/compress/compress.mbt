///|
/// 压缩结果 | Compression result
pub(all) struct CompressionResult {
  data : String
  original_size : Int
  compressed_size : Int
  ratio : Int
} derive(Debug, Eq)
pub extend CompressionResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CompressionResult with Eq::{not_equal, equal}

///|
/// RLE 编码 | RLE encode
pub fn rle_encode(s : String) -> String {
  let mut result = ""
  let len = s.length()
  if len == 0 {
    return ""
  }
  let mut count = 1
  let mut i = 1
  while i < len {
    if s[i] == s[i - 1] {
      count = count + 1
    } else {
      result = result + count.to_string() + s[i - 1:i].to_owned()
      count = 1
    }
    i = i + 1
  }
  result = result + count.to_string() + s[len - 1:len].to_owned()
  result
}

///|
/// RLE 解码 | RLE decode
pub fn rle_decode(s : String) -> String {
  let mut result = ""
  let len = s.length()
  let mut i = 0
  while i < len {
    let mut num = 0
    while i < len {
      let c = s[i].to_int()
      if c >= 48 && c <= 57 {
        num = num * 10 + (c - 48)
        i = i + 1
      } else {
        break
      }
    }
    if i < len && num > 0 {
      let mut j = 0
      while j < num {
        result = result + s[i:i + 1].to_owned()
        j = j + 1
      }
      i = i + 1
    } else {
      i = i + 1
    }
  }
  result
}

///|
/// 压缩统计 | Compression stats
pub fn compress_stats(original : String, compressed : String) -> CompressionResult {
  let orig_size = original.length()
  let comp_size = compressed.length()
  let ratio = if orig_size == 0 { 0 } else { (comp_size * 100) / orig_size }
  { data: compressed, original_size: orig_size, compressed_size: comp_size, ratio }
}

///|
/// 简单字典编码 | Simple dictionary encode
pub fn dict_encode(s : String) -> String {
  let mut result = ""
  let len = s.length()
  let mut i = 0
  while i < len {
    let c = s[i].to_int()
    if c >= 97 && c <= 122 {
      let code = c - 96
      result = result + code.to_string() + " "
    } else if c >= 65 && c <= 90 {
      let code = c - 64 + 26
      result = result + code.to_string() + " "
    } else {
      result = result + s[i:i + 1].to_owned()
    }
    i = i + 1
  }
  result
}

///|
/// 压缩版本 | Compress version
pub fn compress_version() -> String {
  "moon-cross compress v0.3.0"
}