///|
/// Windows 编译配置
pub(all) struct WindowsCompileConfig {
  arch : @core.Arch
  output_dir : String
  output_name : String
} derive(Debug, Eq)

///|
/// Windows 编译命令生成
pub fn windows_compile_command(config : WindowsCompileConfig) -> String {
  let target = match config.arch {
    @core.Arm64 => "aarch64-pc-windows-msvc"
    @core.X86_64 => "x86_64-pc-windows-msvc"
  }
  "clang-cl --target=" +
  target +
  " -o " +
  config.output_dir +
  "/" +
  config.output_name +
  ".dll"
}

///|
/// Windows 平台标识
pub fn windows_platform_id() -> String {
  "windows"
}

///|
/// Windows 默认编译配置
pub fn default_windows_config(
  output_dir : String,
  output_name : String,
) -> WindowsCompileConfig {
  { arch: @core.X86_64, output_dir, output_name, }
}
