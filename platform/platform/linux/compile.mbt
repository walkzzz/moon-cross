/// Linux 编译配置 | Linux compile configuration
pub(all) struct LinuxCompileConfig {
  arch : @core.Arch
  output_dir : String
  output_name : String
  use_static : Bool
} derive(Debug, Eq)
pub extend LinuxCompileConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend LinuxCompileConfig with Eq::{not_equal, equal}

/// Linux 编译命令生成（gcc 共享库） | Linux compile command generation (gcc shared library)
pub fn linux_compile_command(config : LinuxCompileConfig) -> String {
  let compiler = linux_cross_compiler(config.arch)
  let static_flag = if config.use_static { " -static" } else { "" }
  compiler +
  " -shared -fPIC" +
  static_flag +
  " -o " +
  config.output_dir +
  "/" +
  linux_so_name(config.output_name)
}

/// Linux 平台标识 | Linux platform identifier
pub fn linux_platform_id() -> String {
  "linux"
}

/// 默认 Linux 编译配置（x86_64） | Default Linux compile config (x86_64)
pub fn default_linux_config(
  output_dir : String,
  output_name : String,
) -> LinuxCompileConfig {
  { arch: @core.Arch::X86_64, output_dir, output_name, use_static: false }
}

/// Linux .so 输出文件名 | Linux .so output filename
pub fn linux_so_name(output_name : String) -> String {
  "lib" + output_name + ".so"
}

/// Linux 支持的架构 | Linux supported architectures
pub fn linux_supported_archs() -> Array[@core.Arch] {
  [@core.Arch::Arm64, @core.Arch::X86_64]
}

/// Linux 交叉编译器名称 | Linux cross-compiler name
pub fn linux_cross_compiler(arch : @core.Arch) -> String {
  match arch {
    @core.Arch::Arm64 => "aarch64-linux-gnu-gcc"
    @core.Arch::X86_64 => "gcc"
  }
}

/// Linux 动态链接器路径 | Linux dynamic linker path
pub fn linux_dynamic_linker(arch : @core.Arch) -> String {
  match arch {
    @core.Arch::Arm64 => "/lib/ld-linux-aarch64.so.1"
    @core.Arch::X86_64 => "/lib64/ld-linux-x86-64.so.2"
  }
}

/// Linux pkg-config 命令 | Linux pkg-config command
pub fn linux_pkg_config_command(library : String) -> String {
  "pkg-config --cflags --libs " + library
}

/// Linux 最低 glibc 版本 | Linux minimum glibc version
pub fn linux_min_glibc_version() -> String {
  "2.17"
}

/// Linux 版本 | Linux version
pub fn linux_version() -> String {
  "moon-cross linux v0.3.1"
}


///|
/// LinuxCompileConfig 实现 Named trait | LinuxCompileConfig implements Named
pub impl @trait.Named for LinuxCompileConfig with name(self) {
  self.output_name
}
pub extend LinuxCompileConfig with @trait.Named::{name}

///|
/// LinuxCompileConfig 实现 Hashable trait | LinuxCompileConfig implements Hashable
pub impl @trait.Hashable for LinuxCompileConfig with hash(self) {
  @trait.Named::name(self).length()
}
pub extend LinuxCompileConfig with @trait.Hashable::{hash}