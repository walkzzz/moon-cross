///|
fn main {
  println("Moon Cross v0.2.10 - MoonBit Cross-Platform Native Framework")
  println("")
  println("Usage: moon-cross <command> [options]")
  println("")
  println("Commands:")
  println("  build    - Build for target platforms")
  println("  check    - Validate configuration")
  println("  plan     - Show build plan (dry-run)")
  println("  init     - Initialize cross-platform project skeleton")
  println("  sync     - Sync platform bindings after MoonBit code update")
  println("  doctor   - Diagnose environment and toolchain")
  println("  publish  - Prepare and publish to mooncakes")
  println("  wizard   - Interactive init wizard")
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
  let pub_cfg = @publish.default_publish_config()
  let pub_readiness = @publish.validate_publish_readiness(pub_cfg)
  println("  publish:   " + pub_cfg.version + " (ready: " + pub_readiness.ready.to_string() + ")")
  let diag_checks = [
    @diagnostic.check_moonbit(Some("0.1.20260920")),
    @diagnostic.check_ndk(Some("/opt/android-ndk")),
    @diagnostic.check_xcode(Some("/sdk/iphoneos")),
    @diagnostic.check_ohos_sdk(Some("$OHOS_SDK/native")),
  ]
  let diag = @diagnostic.run_doctor(diag_checks)
  println("  doctor:    " + diag.total.to_string() + " checks (" + diag.passed.to_string() + " passed)")
  let wizard_steps = @interactive.wizard_steps()
  println("  wizard:    " + wizard_steps.length().to_string() + " steps")
  println("  discovery: " + @discovery.discovery_version())
}
