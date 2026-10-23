///|
/// 增量同步结果 | Incremental sync result
pub(all) struct SyncResult {
  platform : @core.Platform
  updated_files : Array[String]
  success : Bool
} derive(Debug, Eq)
pub extend SyncResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SyncResult with Eq::{not_equal, equal}

///|
/// 同步版本 | Sync version
pub fn sync_version() -> String {
  "moon-cross sync v0.1.0"
}

///|
/// 创建成功同步结果 | Create successful sync result
pub fn sync_success(
  platform : @core.Platform,
  files : Array[String],
) -> SyncResult {
  { platform, updated_files: files, success: true, }
}

///|
/// 创建失败同步结果 | Create failed sync result
pub fn sync_failure(platform : @core.Platform) -> SyncResult {
  { platform, updated_files: [], success: false, }
}


///|
/// SyncResult 实现 Checkable trait | SyncResult implements Checkable
pub impl @trait.Checkable for SyncResult with check(self) {
  self.success
}
pub extend SyncResult with @trait.Checkable::{check}