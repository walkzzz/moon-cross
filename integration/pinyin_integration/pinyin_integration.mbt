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
/// 转换中文为拼音 | Convert Chinese to pinyin
pub fn convert_chinese(input : String) -> PinyinResult {
  let has_chinese = @pinyin.ChineseHelper::contains_chinese(input)
  let pinyin = try {
    @pinyin.PinyinHelper::convert_to_pinyin_string(input, " ", format=@pinyin.PinyinFormat::WithoutTone)
  } catch {
    _ => input
  }
  let short_pinyin = try {
    @pinyin.PinyinHelper::get_short_pinyin(input)
  } catch {
    _ => input
  }
  { input, pinyin, short_pinyin, has_chinese, }
}

///|
/// 检查是否为中文 | Check if string is Chinese
pub fn is_chinese(input : String) -> Bool {
  @pinyin.ChineseHelper::contains_chinese(input)
}

///|
/// 获取拼音首字母 | Get pinyin first letters
pub fn get_short_pinyin(input : String) -> String {
  try {
    @pinyin.PinyinHelper::get_short_pinyin(input)
  } catch {
    _ => input
  }
}

///|
/// 转换为带声调数字的拼音 | Convert to pinyin with tone number
pub fn convert_with_tone(input : String) -> Array[String] {
  @pinyin.convert_with_tone_number(input)
}

///|
/// 转换为不带声调的拼音 | Convert to pinyin without tone
pub fn convert_without_tone(input : String) -> Array[String] {
  @pinyin.convert_without_tone(input)
}

///|
/// 拼音集成测试版本 | Pinyin integration test version
pub fn pinyin_integration_version() -> String {
  "moon-cross pinyin_integration v0.3.22"
}