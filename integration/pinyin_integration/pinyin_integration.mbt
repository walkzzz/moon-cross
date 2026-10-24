///|
/// 拼音转换结果 | Pinyin conversion result
pub(all) struct PinyinResult {
  input : String
  pinyin : String
  short_pinyin : String
  has_chinese : Bool
} derive(Debug, Eq)
pub extend PinyinResult with Debug::{to_repr}
pub extend PinyinResult with Eq::{not_equal, equal}

///|
/// 输入验证结果 | Input validation result
pub(all) struct ValidationResult {
  valid : Bool
  error_message : String
} derive(Debug, Eq)
pub extend ValidationResult with Debug::{to_repr}
pub extend ValidationResult with Eq::{not_equal, equal}

///|
/// 验证输入字符串 | Validate input string
pub fn validate_input(input : String) -> ValidationResult {
  if input.length() == 0 {
    { valid: false, error_message: "input is empty", }
  } else if input.length() > 1000 {
   { valid: false, error_message: "input too long (max 1000)", }
  } else {
    { valid: true, error_message: "", }
  }
}

///|
/// 转换中文为拼音（鲁棒版）| Convert Chinese to pinyin (robust)
pub fn convert_chinese(input : String) -> PinyinResult {
  let validation = validate_input(input)
  if !validation.valid {
    return { input, pinyin: "", short_pinyin: "", has_chinese: false, }
  }
  let has_chinese = @pinyin.ChineseHelper::contains_chinese(input)
  let pinyin = try {
    @pinyin.PinyinHelper::convert_to_pinyin_string(input, " ", format=@pinyin.PinyinFormat::WithoutTone)
  } catch {
    _ => ""
  }
  let short_pinyin = try {
    @pinyin.PinyinHelper::get_short_pinyin(input)
  } catch {
    _ => ""
  }
  { input, pinyin, short_pinyin, has_chinese, }
}

///|
/// 检查是否为中文 | Check if string is Chinese
pub fn is_chinese(input : String) -> Bool {
  if input.length() == 0 {
    false
  } else {
    @pinyin.ChineseHelper::contains_chinese(input)
  }
}

///|
/// 获取拼音首字母 | Get pinyin first letters
pub fn get_short_pinyin(input : String) -> String {
  if input.length() == 0 {
    ""
  } else {
    try {
     @pinyin.PinyinHelper::get_short_pinyin(input)
    } catch {
      _ => ""
    }
  }
}

///|
/// 转换为带声调数字的拼音 | Convert to pinyin with tone number
pub fn convert_with_tone(input : String) -> Array[String] {
  if input.length() == 0 {
    []
  } else {
    @pinyin.convert_with_tone_number(input)
  }
}

///|
/// 转换为不带声调的拼音 | Convert to pinyin without tone
pub fn convert_without_tone(input : String) -> Array[String] {
  if input.length() == 0 {
    []
  } else {
    @pinyin.convert_without_tone(input)
  }
}

///|
/// 生成跨平台导出函数声明 | Generate cross-platform export functions
pub fn pinyin_export_functions() -> Array[@codegen.ExportFunction] {
  [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_contains", params: [("input", "String")], return_type: "Bool" },
  ]
}

///|
/// 拼音集成测试版本 | Pinyin integration test version
pub fn pinyin_integration_version() -> String {
  "moon-cross pinyin_integration v0.3.26"
}