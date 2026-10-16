///|
/// 诊断状态 | Diagnostic status
pub(all) enum DiagStatus {
  Ok
  Warning
  Error
  NotFound
} derive(Debug, Eq)

pub extend DiagStatus with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiagStatus with Eq::{not_equal, equal}

///|
/// 诊断检查项 | Diagnostic check item
pub(all) struct DiagCheck {
  name : String
  status : DiagStatus
  message : String
  fix_hint : String?
} derive(Debug, Eq)

pub extend DiagCheck with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiagCheck with Eq::{not_equal, equal}

///|
/// 诊断结果 | Diagnostic result
pub(all) struct DiagResult {
  checks : Array[DiagCheck]
  total : Int
  passed : Int
  warnings : Int
  errors : Int
} derive(Debug, Eq)

pub extend DiagResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DiagResult with Eq::{not_equal, equal}

///|
/// 创建诊断检查项 | Create diagnostic check item
pub fn make_check(name : String, status : DiagStatus, message : String, fix_hint : String?) -> DiagCheck {
  { name, status, message, fix_hint }
}

///|
/// 运行完整诊断（doctor 命令） | Run full diagnostics (doctor command)
pub fn run_doctor(checks : Array[DiagCheck]) -> DiagResult {
  let total = checks.length()
  let mut passed = 0
  let mut warnings = 0
  let mut errors = 0
  for check in checks {
    match check.status {
      Ok => passed = passed + 1
      Warning => warnings = warnings + 1
      Error => errors = errors + 1
      NotFound => errors = errors + 1
    }
  }
  { checks, total, passed, warnings, errors }
}

///|
/// 检查 MoonBit 工具链 | Check MoonBit toolchain
pub fn check_moonbit(version : String?) -> DiagCheck {
  match version {
    Some(v) => {
      if v.length() > 0 {
        make_check("moonbit", Ok, "MoonBit \{v} found", None)
      } else {
        make_check("moonbit", Error, "MoonBit version is empty", Some("install MoonBit: curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash"))
      }
    }
    None => make_check("moonbit", NotFound, "MoonBit not found", Some("install MoonBit: curl -fsSL https://cli.moonbitlang.com/install/unix.sh | bash"))
  }
}

///|
/// 检查 Android NDK | Check Android NDK
pub fn check_ndk(ndk_path : String?) -> DiagCheck {
  match ndk_path {
    Some(path) => {
      if path.length() > 0 {
        make_check("android-ndk", Ok, "NDK found at \{path}", None)
      } else {
        make_check("android-ndk", Warning, "NDK path is empty", Some("set ANDROID_NDK_HOME environment variable"))
      }
    }
    None => make_check("android-ndk", Warning, "ANDROID_NDK_HOME not set", Some("install Android NDK and set ANDROID_NDK_HOME"))
  }
}

///|
/// 检查 Xcode | Check Xcode
pub fn check_xcode(xcode_path : String?) -> DiagCheck {
  match xcode_path {
    Some(path) => make_check("xcode", Ok, "Xcode found at \{path}", None)
    None => make_check("xcode", Warning, "Xcode not found", Some("install Xcode from App Store"))
  }
}

///|
/// 检查鸿蒙 SDK | Check HarmonyOS SDK
pub fn check_ohos_sdk(sdk_path : String?) -> DiagCheck {
  match sdk_path {
    Some(path) => make_check("ohos-sdk", Ok, "OHOS SDK found at \{path}", None)
    None => make_check("ohos-sdk", Warning, "OHOS SDK not found", Some("install DevEco Studio"))
  }
}

///|
/// 生成诊断报告 | Generate diagnostic report
pub fn generate_report(result : DiagResult) -> String {
  let mut report = "Moon Cross Doctor Report\n"
  report = report + "========================\n\n"
  for check in result.checks {
    let status_str = match check.status {
      Ok => "✅"
      Warning => "⚠️"
      Error => "❌"
      NotFound => "❌"
    }
    report = report + "\{status_str} \{check.name}: \{check.message}\n"
    match check.fix_hint {
      Some(hint) => report = report + "   Fix: \{hint}\n"
      None => ()
    }
  }
  report = report + "\nSummary: \{result.passed} passed, \{result.warnings} warnings, \{result.errors} errors\n"
  report
}

///|
/// 判断环境是否健康 | Check if environment is healthy
pub fn is_healthy(result : DiagResult) -> Bool {
  result.errors == 0
}

///|
/// DiagStatus 转字符串 | DiagStatus to string
pub fn DiagStatus::to_string(self : DiagStatus) -> String {
  match self {
    Ok => "ok"
    Warning => "warning"
    Error => "error"
    NotFound => "not_found"
  }
}

///|
/// 诊断版本 | Diagnostic version
pub fn diagnostic_version() -> String {
  "moon-cross diagnostic v0.1.2"
}