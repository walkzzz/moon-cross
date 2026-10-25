///|
/// 平台编译规格 | Platform compilation specification
pub(all) struct PlatformSpec {
  platform : @core.Platform
  compiler : String
  target_triple : String
  sysroot : String
  output_format : String
  ffi_mechanism : String
} derive(Debug, Eq)
pub extend PlatformSpec with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PlatformSpec with Eq::{not_equal, equal}

///|
/// 获取平台编译规格 | Get platform compilation specification
pub fn platform_spec(platform : @core.Platform) -> PlatformSpec {
  match platform {
    @core.Ios =>
      {
        platform,
        compiler: "xcrun clang",
        target_triple: "arm64-apple-ios",
        sysroot: "iphoneos.sdk",
        output_format: ".dylib",
        ffi_mechanism: "swift-interop",
      }
    @core.Android =>
      {
        platform,
        compiler: "$NDK/clang",
        target_triple: "aarch64-linux-android24",
        sysroot: "NDK sysroot",
        output_format: ".so",
        ffi_mechanism: "jni",
      }
    @core.Windows =>
      {
        platform,
        compiler: "clang-cl",
        target_triple: "x86_64-pc-windows-msvc",
        sysroot: "MSVC CRT",
        output_format: ".dll",
        ffi_mechanism: "dllimport",
      }
    @core.Ohos =>
      {
        platform,
        compiler: "$OHOS/clang",
        target_triple: "aarch64-linux-ohos",
        sysroot: "OHOS SDK",
        output_format: ".so",
        ffi_mechanism: "napi",
      }
    @core.Linux =>
      {
        platform,
        compiler: "gcc",
        target_triple: "x86_64-unknown-linux-gnu",
        sysroot: "/",
        output_format: ".so",
        ffi_mechanism: "cffi",
      }
  }
}

///|
/// 平台规格版本 | Platform specification version
pub fn platform_spec_version() -> String {
  "moon-cross platform v0.1.0"
}


///|
/// PlatformSpec 实现 Named trait | PlatformSpec implements Named
pub impl @trait.Named for PlatformSpec with name(self) {
  self.target_triple
}
pub extend PlatformSpec with @trait.Named::{name}

///|
/// PlatformSpec 实现 Hashable trait | PlatformSpec implements Hashable
pub impl @trait.Hashable for PlatformSpec with hash(self) {
  @trait.Named::name(self).length()
}
pub extend PlatformSpec with @trait.Hashable::{hash}