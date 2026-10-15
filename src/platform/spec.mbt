///|
/// 平台编译规格
pub(all) struct PlatformSpec {
  platform : @core.Platform
  compiler : String
  target_triple : String
  sysroot : String
  output_format : String
  ffi_mechanism : String
} derive(Debug, Eq)

///|
/// 获取平台编译规格
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
  }
}

///|
/// 平台规格版本
pub fn platform_spec_version() -> String {
  "moon-cross platform v0.1.0"
}
