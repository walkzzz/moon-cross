///|
/// 自动发现结果 | Auto-discovery result
pub(all) struct DiscoveryResult {
  found_functions : Array[String]
  found_types : Array[String]
  detected_platforms : Array[@core.Platform]
  config_generated : Bool
} derive(Debug, Eq)

pub extend DiscoveryResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiscoveryResult with Eq::{not_equal, equal}

///|
/// 平台 SDK 检测结果 | Platform SDK detection result
pub(all) struct PlatformDetection {
  platform : @core.Platform
  available : Bool
  sdk_path : String?
  version : String?
} derive(Debug, Eq)

pub extend PlatformDetection with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PlatformDetection with Eq::{not_equal, equal}

///|
/// 源码分析结果 | Source analysis result
pub(all) struct SourceAnalysis {
  has_pub_fn : Bool
  has_pub_struct : Bool
  has_pub_enum : Bool
  has_extern : Bool
  has_derive : Bool
} derive(Debug, Eq)

pub extend SourceAnalysis with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SourceAnalysis with Eq::{not_equal, equal}

///|
/// 分析源码内容 | Analyze source code content
pub fn analyze_source(source : String) -> SourceAnalysis {
  {
    has_pub_fn: source.contains("pub fn "),
    has_pub_struct: source.contains("pub(all) struct ") || source.contains("pub struct "),
    has_pub_enum: source.contains("pub(all) enum ") || source.contains("pub enum "),
    has_extern: source.contains("extern "),
    has_derive: source.contains("derive("),
  }
}

///|
/// 从函数名列表创建发现结果 | Create discovery result from function name list
pub fn discover_from_names(function_names : Array[String], type_names : Array[String]) -> DiscoveryResult {
  { found_functions: function_names, found_types: type_names, detected_platforms: @core.all_platforms(), config_generated: function_names.length() > 0 }
}

///|
/// 检测可用平台 | Detect available platforms
pub fn detect_platforms(detections : Array[PlatformDetection]) -> Array[@core.Platform] {
  let available = []
  for detection in detections {
    if detection.available {
      available.push(detection.platform)
    }
  }
  if available.length() == 0 {
    for p in @core.all_platforms() {
      available.push(p)
    }
  }
  available
}

///|
/// 创建平台检测结果 | Create platform detection result
pub fn make_detection(platform : @core.Platform, available : Bool, sdk_path : String?, version : String?) -> PlatformDetection {
  { platform, available, sdk_path, version }
}

///|
/// 智能默认配置 | Smart default configuration
pub fn smart_defaults(detected_platforms : Array[@core.Platform]) -> Array[@core.Platform] {
  if detected_platforms.length() == 0 {
    @core.all_platforms()
  } else {
    detected_platforms
  }
}

///|
/// 自动生成配置 | Auto-generate configuration
pub fn auto_generate_config(functions : Array[String], types : Array[String], platforms : Array[@core.Platform]) -> DiscoveryResult {
  let has_content = functions.length() > 0 || types.length() > 0
  { found_functions: functions, found_types: types, detected_platforms: platforms, config_generated: has_content }
}

///|
/// 统计源码中的导出函数数量 | Count export functions in source
pub fn count_export_functions(sources : Array[String]) -> Int {
  let mut count = 0
  for source in sources {
    if source.contains("pub fn ") {
      count = count + 1
    }
  }
  count
}

///|
/// 统计源码中的导出类型数量 | Count export types in source
pub fn count_export_types(sources : Array[String]) -> Int {
  let mut count = 0
  for source in sources {
    if source.contains("pub(all) struct ") || source.contains("pub(all) enum ") {
      count = count + 1
    }
  }
  count
}

///|
/// 检查是否需要 FFI | Check if FFI is needed
pub fn needs_ffi(sources : Array[String]) -> Bool {
  let mut found = false
  for source in sources {
    if source.contains("extern ") {
      found = true
    }
  }
  found
}

///|
/// 创建空发现结果 | Create empty discovery result
pub fn empty_discovery() -> DiscoveryResult {
  { found_functions: [], found_types: [], detected_platforms: [], config_generated: false }
}

///|
/// 合并发现结果 | Merge discovery results
pub fn merge_discovery(results : Array[DiscoveryResult]) -> DiscoveryResult {
  let all_functions = []
  let all_types = []
  let all_platforms = []
  let mut generated = false
  for result in results {
    for func in result.found_functions {
      all_functions.push(func)
    }
    for typ in result.found_types {
      all_types.push(typ)
    }
    for p in result.detected_platforms {
      all_platforms.push(p)
    }
    if result.config_generated {
      generated = true
    }
  }
  { found_functions: all_functions, found_types: all_types, detected_platforms: all_platforms, config_generated: generated }
}

///|
/// 自动发现版本 | Auto-discovery version
pub fn discovery_version() -> String {
  "moon-cross discovery v0.1.2"
}

///|
/// PlatformDetection 实现 Checkable trait | PlatformDetection implements Checkable
pub impl @trait.Checkable for PlatformDetection with check(self) {
  self.available
}
pub extend PlatformDetection with @trait.Checkable::{check}

///|
/// SourceAnalysis 实现 Checkable trait | SourceAnalysis implements Checkable
pub impl @trait.Checkable for SourceAnalysis with check(self) {
  self.has_pub_fn
}
pub extend SourceAnalysis with @trait.Checkable::{check}