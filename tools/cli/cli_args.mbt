///|
/// CLI 参数解析与帮助信息 | CLI argument parsing and help text

///|
/// CLI 版本号 | CLI version
pub fn cli_version() -> String {
  "moon-cross v0.3.36"
}

///|
/// 格式化帮助文本 | Format help text
pub fn format_help() -> String {
  "Moon Cross v0.3.36 - MoonBit Cross-Platform Native Framework\n\n" +
  "Usage: moon-cross <command> [options]\n\n" +
  "Commands:\n" +
  "  build    - Generate cross-platform bindings and build scripts from moon-cross.json\n" +
  "  check    - Validate moon-cross.json configuration\n" +
  "  plan     - Show build plan (dry-run)\n" +
  "  init     - Initialize a cross-platform project skeleton\n" +
  "  sync     - Regenerate platform bindings from moon-cross.json\n" +
  "  doctor   - Diagnose environment and toolchain\n" +
  "  publish  - Pre-check moon.mod metadata before publishing to mooncakes\n" +
  "  wizard   - Show the plan that init would execute (non-interactive)\n" +
  "  version  - Show version information\n" +
  "  help     - Show this help message\n\n" +
  "Options:\n" +
  "  --config <path>    Path to moon-cross.json (default: moon-cross.json)\n" +
  "  --platform <p>     Target platform (ios|android|windows|ohos|linux|all)\n" +
  "  --output <dir>     Output directory (default: moon-cross-output)\n" +
  "  --name <name>      Project name\n" +
  "  --script           Also generate the executable build script\n"
}

///|
/// 格式化版本信息 | Format version info
pub fn format_version() -> String {
  let mut v = cli_version() + "\n\nVersion info:\n"
  v = v +
    "  core:      " +
    @core.all_platforms().length().to_string() +
    " platforms supported\n"
  v = v + "  codegen:   " + @codegen.codegen_version() + "\n"
  v = v + "  ffi:       " + @ffi.ffi_version() + "\n"
  v = v + "  jni:       " + @ffi_jni.jni_version() + "\n"
  v = v + "  swift:     " + @ffi_swift.swift_version() + "\n"
  v = v + "  napi:      " + @ffi_napi.napi_version() + "\n"
  v = v + "  android:   " + @platform_android.android_platform_id() + "\n"
  v = v + "  ios:       " + @platform_ios.ios_platform_id() + "\n"
  v = v + "  ohos:      " + @platform_ohos.ohos_platform_id() + "\n"
  v = v + "  scaffold:  " + @scaffold.scaffold_version() + "\n"
  v = v + "  sync:      " + @sync.sync_version() + "\n"
  let pub_cfg = @publish.default_publish_config()
  let pub_readiness = @publish.validate_publish_readiness(pub_cfg)
  v = v +
    "  publish:   " +
    pub_cfg.version +
    " (ready: " +
    pub_readiness.ready.to_string() +
    ")\n"
  v = v + "  discovery: " + @discovery.discovery_version() + "\n"
  v
}

///|
/// 解析命名参数（--flag value） | Parse named argument (--flag value)
pub fn parse_arg(
  args : Array[String],
  flag : String,
  default : String,
) -> String {
  let mut i = 0
  while i < args.length() - 1 {
    if args[i] == flag {
      return args[i + 1]
    }
    i = i + 1
  }
  default
}

///|
/// 检查布尔 flag 是否存在 | Check if boolean flag is present
pub fn has_flag(args : Array[String], flag : String) -> Bool {
  for arg in args {
    if arg == flag {
      return true
    }
  }
  false
}
