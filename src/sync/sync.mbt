///|
/// 增量同步结果
pub(all) struct SyncResult {
  platform : @core.Platform
  updated_files : Array[String]
  success : Bool
} derive(Debug, Eq)

///|
/// 同步版本
pub fn sync_version() -> String {
  "moon-cross sync v0.1.0"
}

///|
/// 创建成功同步结果
pub fn sync_success(
  platform : @core.Platform,
  files : Array[String],
) -> SyncResult {
  { platform, updated_files: files, success: true, }
}

///|
/// 创建失败同步结果
pub fn sync_failure(platform : @core.Platform) -> SyncResult {
  { platform, updated_files: [], success: false, }
}
