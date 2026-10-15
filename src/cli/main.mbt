///|
fn main {
  println("Moon Cross v1.0.0 - MoonBit Cross-Platform Native Framework")
  println("")
  println("Usage: moon-cross <command> [options]")
  println("")
  println("Commands:")
  println("  build   - Build for target platforms")
  println("  check   - Validate configuration")
  println("  plan    - Show build plan (dry-run)")
  println("  init    - Initialize cross-platform project skeleton")
  println("  sync    - Sync platform bindings after MoonBit code update")
  println("")
  println("Version info:")
  println(
    "  core:      " +
    @core.all_platforms().length().to_string() +
    " platforms supported",
  )
  println("  codegen:   " + @codegen.codegen_version())
  println("  ffi:       " + @ffi.ffi_version())
  println("  jni:       " + @ffi_jni.jni_version())
  println("  swift:     " + @ffi_swift.swift_version())
  println("  napi:      " + @ffi_napi.napi_version())
  println("  android:   " + @platform_android.android_platform_id())
  println("  ios:       " + @platform_ios.ios_platform_id())
  println("  ohos:      " + @platform_ohos.ohos_platform_id())
  println("  scaffold:  " + @scaffold.scaffold_version())
  println("  sync:      " + @sync.sync_version())
}
