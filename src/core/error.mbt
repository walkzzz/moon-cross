///|
/// Moon Cross 错误类型 | Moon Cross error type
pub(all) enum MoonCrossError {
  ConfigError(String)
  ParseError(String)
  CodegenError(String)
  CompileError(String)
  PlatformError(String)
  FfiError(String)
  ValidationError(String)
  IoError(String)
} derive(Debug)

///|
/// 错误转可读消息 | Error to readable message
pub fn MoonCrossError::to_message(self : MoonCrossError) -> String {
  match self {
    ConfigError(msg) => "Config error: \{msg}"
    ParseError(msg) => "Parse error: \{msg}"
    CodegenError(msg) => "Codegen error: \{msg}"
    CompileError(msg) => "Compile error: \{msg}"
    PlatformError(msg) => "Platform error: \{msg}"
    FfiError(msg) => "FFI error: \{msg}"
    ValidationError(msg) => "Validation error: \{msg}"
    IoError(msg) => "IO error: \{msg}"
  }
}

///|
/// 错误简短标签 | Error short label
pub fn MoonCrossError::label(self : MoonCrossError) -> String {
  match self {
    ConfigError(_) => "config"
    ParseError(_) => "parse"
    CodegenError(_) => "codegen"
    CompileError(_) => "compile"
    PlatformError(_) => "platform"
    FfiError(_) => "ffi"
    ValidationError(_) => "validation"
    IoError(_) => "io"
  }
}
