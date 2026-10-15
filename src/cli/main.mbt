///|
fn main {
  println("Moon Cross v0.1.0 - MoonBit Cross-Platform Native Framework")
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
  println("  android:   " + @platform_android.android_platform_id())
  println("  scaffold:  " + @scaffold.scaffold_version())
  println("  sync:      " + @sync.sync_version())
}
