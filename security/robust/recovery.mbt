///|
/// 单平台编译结果 | Single platform compile result
pub(all) struct PlatformCompileResult {
  platform : @core.Platform
  success : Bool
  error_message : String?
  output_files : Array[String]
  duration_ms : Int
} derive(Debug, Eq)

pub extend PlatformCompileResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PlatformCompileResult with Eq::{not_equal, equal}

///|
/// 多平台编译汇总报告 | Multi-platform compile summary report
pub(all) struct CompileSummary {
  results : Array[PlatformCompileResult]
  total_platforms : Int
  successful_platforms : Int
  failed_platforms : Int
} derive(Debug, Eq)

pub extend CompileSummary with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CompileSummary with Eq::{not_equal, equal}

///|
/// FFI 回退模式 | FFI fallback mode
pub(all) enum FfiFallbackMode {
  FullFfi
  PureC
  ManualFfi
} derive(Debug, Eq)

pub extend FfiFallbackMode with @moonbitlang/core/debug.Debug::{to_repr}
pub extend FfiFallbackMode with Eq::{not_equal, equal}

///|
/// 创建单平台编译结果 | Create platform compile result
pub fn compile_result(
  platform : @core.Platform,
  success : Bool,
  error_message : String?,
  output_files : Array[String],
  duration_ms : Int,
) -> PlatformCompileResult {
  { platform, success, error_message, output_files, duration_ms }
}

///|
/// 汇总多平台编译结果 | Summarize multi-platform compile results
pub fn summarize_compile(results : Array[PlatformCompileResult]) -> CompileSummary {
  let total = results.length()
  let mut success_count = 0
  let mut fail_count = 0
  for result in results {
    if result.success {
      success_count = success_count + 1
    } else {
      fail_count = fail_count + 1
    }
  }
  { results, total_platforms: total, successful_platforms: success_count, failed_platforms: fail_count }
}

///|
/// 部分成功恢复：单平台失败不阻塞其他平台 | Partial success recovery: single platform failure does not block others
pub fn partial_success_recovery(results : Array[PlatformCompileResult]) -> Array[@core.Platform] {
  let successful = []
  for result in results {
    if result.success {
      successful.push(result.platform)
    }
  }
  successful
}

///|
/// FFI 绑定回退：FFI 生成失败时回退到纯 C 绑定 | FFI binding fallback: fall back to pure C binding when FFI generation fails
pub fn ffi_binding_fallback(ffi_error : String) -> FfiFallbackMode {
  if ffi_error.contains("unsupported") {
    ManualFfi
  } else {
    PureC
  }
}

///|
/// 配置降级：缺少可选配置时使用安全默认值 | Config degradation: use safe defaults when optional config is missing
pub fn config_degradation(missing_field : String) -> String {
  match missing_field {
    "optimization" => "O2"
    "debug" => "false"
    "strip" => "true"
    _ => "default"
  }
}

///|
/// 检查编译汇总是否有部分成功 | Check if compile summary has partial success
pub fn has_partial_success(summary : CompileSummary) -> Bool {
  summary.successful_platforms > 0 && summary.failed_platforms > 0
}

///|
/// 生成失败报告 | Generate failure report
pub fn generate_failure_report(summary : CompileSummary) -> String {
  let mut report = "Compile Summary:\n"
  report = report + "  Total: \{summary.total_platforms}\n"
  report = report + "  Success: \{summary.successful_platforms}\n"
  report = report + "  Failed: \{summary.failed_platforms}\n"
  for result in summary.results {
    if !result.success {
      let err = match result.error_message {
        Some(msg) => msg
        None => "unknown error"
      }
      report = report + "  \{result.platform.display_name()}: \{err}\n"
    }
  }
  report
}

///|
/// 错误恢复版本 | Error recovery version
pub fn recovery_version() -> String {
  "moon-cross robust/recovery v0.0.8"
}

///|
/// PlatformCompileResult 实现 Checkable trait | PlatformCompileResult implements Checkable
pub impl @trait.Checkable for PlatformCompileResult with check(self) {
  self.success
}
pub extend PlatformCompileResult with @trait.Checkable::{check}

///|
/// CompileSummary 实现 Countable trait | CompileSummary implements Countable
pub impl @trait.Countable for CompileSummary with count(self) {
  self.results.length()
}
pub extend CompileSummary with @trait.Countable::{count}