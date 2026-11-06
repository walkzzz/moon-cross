///|
/// CLI 版本 | CLI version
pub fn cli_version() -> String {
  "moon-cross v0.3.33"
}

///|
/// 格式化帮助文本 | Format help text
pub fn format_help() -> String {
  "Moon Cross v0.3.33 - MoonBit Cross-Platform Native Framework\n\n" +
  "Usage: moon-cross <command> [options]\n\n" +
  "Commands:\n" +
  "  build    - Build for target platforms\n" +
  "  check    - Validate configuration\n" +
  "  plan     - Show build plan (dry-run)\n" +
  "  init     - Initialize cross-platform project skeleton\n" +
  "  sync     - Sync platform bindings after MoonBit code update\n" +
  "  doctor   - Diagnose environment and toolchain\n" +
  "  publish  - Prepare and publish to mooncakes\n" +
  "  wizard   - Interactive init wizard\n" +
  "  version  - Show version information\n" +
  "  help     - Show this help message\n\n" +
  "Options:\n" +
  "  --platform <p>   Target platform (ios|android|windows|ohos|linux|all)\n" +
  "  --output <dir>   Output directory\n" +
  "  --name <name>    Project name\n" +
  "  --script         Generate executable build script\n" +
  "  --example        Generate complete example project\n"
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
/// init 命令 - 生成脚手架 | init command - generate scaffold
pub fn cmd_init(args : Array[String]) -> String {
  let name = parse_arg(args, "--name", "mylib")
  let opts = @scaffold.default_scaffold_options(name)
  let files = @scaffold.scaffold_file_list(opts)
  let mut result = "Initializing project: " + name + "\n"
  result = result + "Output directory: " + opts.output_dir + "\n"
  result = result + "Platforms: " + opts.platforms.length().to_string() + "\n"
  result = result + "Files to generate:\n"
  for f in files {
    result = result + "  " + f + "\n"
  }
  result = result + "\nScaffold created successfully.\n"
  result
}

///|
/// build 命令 - 调用 codegen + executor 生成跨平台代码和构建脚本 | build command
pub fn cmd_build(args : Array[String]) -> String {
  let name = parse_arg(args, "--name", "mylib")
  let platform = parse_arg(args, "--platform", "all")
  let want_script = has_flag(args, "--script")
  let want_example = has_flag(args, "--example")
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let mut result = "Building for platform: " + platform + "\n"
  result = result + "Module: " + name + "\n\n"
  let c_adapter = @codegen.generate_c_adapter(funcs, name)
  result = result +
    "Generated: " +
    c_adapter.filename +
    " (" +
    c_adapter.content.length().to_string() +
    " bytes)\n"
  let cross_code = @codegen.generate_all_platforms(funcs, name)
  for code in cross_code {
    result = result +
      "Generated: " +
      code.platform +
      "/" +
      code.filename +
      " (" +
      code.content.length().to_string() +
      " bytes)\n"
  }
  if want_script {
    let build_cfg = @platform.default_build_config(name)
    let script = @platform.generate_build_script(build_cfg)
    result = result + "\n--- build.sh ---\n" + script
    let plan = @platform.generate_compile_plan(build_cfg)
    result = result +
      "\nCompile plan: " +
      plan.length().to_string() +
      " steps\n"
  }
  if want_example {
    let example = @codegen.generate_example_project(funcs, name)
    result = result +
      "\n--- Example Project (" +
      example.length().to_string() +
      " files) ---\n"
    for file in example {
      result = result +
        "  " +
        file.platform +
        "/" +
        file.filename +
        " (" +
        file.content.length().to_string() +
        " bytes)\n"
    }
  }
  result = result + "\nBuild completed.\n"
  result
}

///|
/// plan 命令 - 显示构建计划 | plan command - show build plan
pub fn cmd_plan(args : Array[String]) -> String {
  let name = parse_arg(args, "--name", "mylib")
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let plan = @codegen.generate_build_plan(funcs, name)
  plan.content
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

///|
/// CLI 命令分发（核心入口，可测试） | CLI command dispatch (core entry, testable)
pub fn run_cli(args : Array[String]) -> String {
  if args.length() <= 1 {
    return format_help()
  }
  let command = args[1]
  match command {
    "help" | "--help" | "-h" => format_help()
    "version" | "--version" | "-v" => format_version()
    "init" => cmd_init(args)
    "build" => cmd_build(args)
    "plan" => cmd_plan(args)
    _ => "Unknown command: " + command + "\n\n" + format_help()
  }
}

///|
fn main {
  println(run_cli(["moon-cross"]))
}
