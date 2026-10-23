///|
/// 变更类型 | Change type
pub(all) enum ChangeType {
  Added
  Modified
  Removed
} derive(Debug, Eq)

pub extend ChangeType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ChangeType with Eq::{not_equal, equal}

///|
/// 文件变更 | File change
pub(all) struct FileChange {
  path : String
  change_type : ChangeType
  old_hash : String?
  new_hash : String?
} derive(Debug, Eq)

pub extend FileChange with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FileChange with Eq::{not_equal, equal}

///|
/// 变更集 | Change set
pub(all) struct ChangeSet {
  changes : Array[FileChange]
  total_files : Int
} derive(Debug, Eq)

pub extend ChangeSet with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ChangeSet with Eq::{not_equal, equal}

///|
/// 增量构建结果 | Incremental build result
pub(all) struct IncrementalResult {
  needs_rebuild : Bool
  affected_platforms : Array[@core.Platform]
  skipped_files : Int
  rebuilt_files : Int
} derive(Debug, Eq)

pub extend IncrementalResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend IncrementalResult with Eq::{not_equal, equal}

///|
/// 创建文件变更 | Create file change
pub fn make_file_change(path : String, change_type : ChangeType, old_hash : String?, new_hash : String?) -> FileChange {
  { path, change_type, old_hash, new_hash }
}

///|
/// 创建空变更集 | Create empty change set
pub fn empty_change_set() -> ChangeSet {
  { changes: [], total_files: 0 }
}

///|
/// 创建变更集 | Create change set
pub fn make_change_set(changes : Array[FileChange], total_files : Int) -> ChangeSet {
  { changes, total_files }
}

///|
/// 检测变更 | Detect changes between old and new hashes
pub fn detect_changes(old_hashes : Array[(String, String)], new_hashes : Array[(String, String)]) -> ChangeSet {
  let changes = []
  for entry in new_hashes {
    let path = entry.0
    let new_hash = entry.1
    let mut found_old = false
    for old_entry in old_hashes {
      if old_entry.0 == path {
        found_old = true
        if old_entry.1 != new_hash {
          changes.push(make_file_change(path, Modified, Some(old_entry.1), Some(new_hash)))
        }
      }
    }
    if !found_old {
      changes.push(make_file_change(path, Added, None, Some(new_hash)))
    }
  }
  for old_entry in old_hashes {
    let mut still_exists = false
    for entry in new_hashes {
      if entry.0 == old_entry.0 {
        still_exists = true
      }
    }
    if !still_exists {
      changes.push(make_file_change(old_entry.0, Removed, Some(old_entry.1), None))
    }
  }
  { changes, total_files: changes.length() }
}

///|
/// 判断是否需要重建 | Determine if rebuild is needed
pub fn needs_rebuild(change_set : ChangeSet) -> Bool {
  change_set.total_files > 0
}

///|
/// 检查平台是否已在列表中 | Check if platform already exists
fn platform_exists(platforms : Array[@core.Platform], target : @core.Platform) -> Bool {
  let target_id = target.to_id()
  let mut found = false
  for p in platforms {
    if p.to_id() == target_id {
      found = true
    }
  }
  found
}

///|
/// 添加平台（如不存在）| Add platform if not exists
fn add_platform_if_new(platforms : Array[@core.Platform], platform : @core.Platform) -> Unit {
  if !platform_exists(platforms, platform) {
    platforms.push(platform)
  }
}

///|
/// 计算受影响的平台 | Calculate affected platforms
pub fn affected_platforms(change_set : ChangeSet) -> Array[@core.Platform] {
  let platforms = []
  for change in change_set.changes {
    if change.path.contains("windows") {
      add_platform_if_new(platforms, @core.Platform::Windows)
    }
    if change.path.contains("android") {
      add_platform_if_new(platforms, @core.Platform::Android)
    }
    if change.path.contains("ios") {
      add_platform_if_new(platforms, @core.Platform::Ios)
    }
    if change.path.contains("ohos") {
      add_platform_if_new(platforms, @core.Platform::Ohos)
    }
  }
  if platforms.length() == 0 && change_set.total_files > 0 {
    for p in @core.all_platforms() {
      platforms.push(p)
    }
  }
  platforms
}

///|
/// 执行增量构建 | Execute incremental build
pub fn incremental_build(change_set : ChangeSet) -> IncrementalResult {
  if !needs_rebuild(change_set) {
    return { needs_rebuild: false, affected_platforms: [], skipped_files: 0, rebuilt_files: 0 }
  }
  let affected = affected_platforms(change_set)
  { needs_rebuild: true, affected_platforms: affected, skipped_files: 0, rebuilt_files: change_set.total_files }
}

///|
/// 预热配置 | Warmup configuration
pub fn warmup_config() -> ChangeSet {
  let changes = []
  for platform in @core.all_platforms() {
    changes.push(make_file_change("warmup-" + platform.to_id(), Added, None, Some("warmup")))
  }
  { changes, total_files: changes.length() }
}

///|
/// 增量构建版本 | Incremental build version
pub fn incremental_version() -> String {
  "moon-cross perf/incremental v0.1.0"
}