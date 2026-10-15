fn has_function(
  fns : Array[@config.ExportFunction],
  name : String,
) -> Bool {
  let mut found = false
  for i in 0..<fns.length() {
    if fns[i].name == name {
      found = true
    }
  }
  found
}

fn find_function(
  fns : Array[@config.ExportFunction],
  name : String,
) -> @config.ExportFunction? {
  for i in 0..<fns.length() {
    if fns[i].name == name {
      return Some(fns[i])
    }
  }
  None
}

fn has_type(
  types : Array[@config.ExportType],
  name : String,
) -> Bool {
  let mut found = false
  for i in 0..<types.length() {
    if types[i].name == name {
      found = true
    }
  }
  found
}

fn has_platform_spec(
  specs : Array[@platform.PlatformSpec],
  platform : @core.Platform,
) -> Bool {
  let mut found = false
  for i in 0..<specs.length() {
    if specs[i].platform == platform {
      found = true
    }
  }
  found
}

fn find_platform_spec(
  specs : Array[@platform.PlatformSpec],
  platform : @core.Platform,
) -> @platform.PlatformSpec? {
  for i in 0..<specs.length() {
    if specs[i].platform == platform {
      return Some(specs[i])
    }
  }
  None
}

fn has_ffi_binding(
  bindings : Array[@ffi.FfiBindingType],
  binding : @ffi.FfiBindingType,
) -> Bool {
  let mut found = false
  for i in 0..<bindings.length() {
    if bindings[i] == binding {
      found = true
    }
  }
  found
}

test "zlib_module_name" {
  assert_eq(zlib_module_name(), "mizchi_zlib")
}

test "zlib_version" {
  assert_eq(zlib_version(), "0.4.10")
}

test "zlib_export_functions_count" {
  assert_eq(zlib_function_count(), 10)
}

test "zlib_export_types_count" {
  assert_eq(zlib_type_count(), 1)
}

test "zlib_target_count" {
  assert_eq(zlib_target_count(), 4)
}

test "zlib_export_functions_has_compress" {
  assert_true(has_function(zlib_export_functions(), "zlib_compress"))
}

test "zlib_export_functions_has_decompress" {
  assert_true(has_function(zlib_export_functions(), "zlib_decompress"))
}

test "zlib_export_functions_has_deflate" {
  assert_true(has_function(zlib_export_functions(), "deflate_compress"))
}

test "zlib_export_functions_has_gzip" {
  assert_true(has_function(zlib_export_functions(), "gzip_compress"))
}

test "zlib_export_functions_has_adler32" {
  assert_true(has_function(zlib_export_functions(), "adler32"))
}

test "zlib_export_functions_has_crc32" {
  assert_true(has_function(zlib_export_functions(), "crc32"))
}

test "zlib_compress_return_type" {
  match find_function(zlib_export_functions(), "zlib_compress") {
    Some(f) => assert_eq(f.return_type, "Bytes")
    None => assert_true(false)
  }
}

test "zlib_decompress_return_type" {
  match find_function(zlib_export_functions(), "zlib_decompress") {
    Some(f) => assert_eq(f.return_type, "Bytes")
    None => assert_true(false)
  }
}

test "zlib_adler32_return_type" {
  match find_function(zlib_export_functions(), "adler32") {
    Some(f) => assert_eq(f.return_type, "Int")
    None => assert_true(false)
  }
}

test "zlib_crc32_return_type" {
  match find_function(zlib_export_functions(), "crc32") {
    Some(f) => assert_eq(f.return_type, "UInt")
    None => assert_true(false)
  }
}

test "zlib_compress_param_type" {
  match find_function(zlib_export_functions(), "zlib_compress") {
    Some(f) => {
      assert_eq(f.params.length(), 1)
      assert_eq(f.params[0].name, "data")
      assert_eq(f.params[0].typ, "Bytes")
    }
    None => assert_true(false)
  }
}

test "zlib_cross_config_version" {
  let cfg = zlib_cross_config()
  assert_eq(cfg.version, 1)
}

test "zlib_cross_config_module_path" {
  let cfg = zlib_cross_config()
  assert_eq(cfg.module_path, "mizchi/zlib")
}

test "zlib_cross_config_package_name" {
  let cfg = zlib_cross_config()
  assert_eq(cfg.package_name, "mizchi/zlib")
}

test "zlib_cross_config_targets" {
  let cfg = zlib_cross_config()
  assert_eq(cfg.targets.length(), 4)
}

test "zlib_cross_config_functions" {
  let cfg = zlib_cross_config()
  assert_eq(cfg.functions.length(), 10)
}

test "zlib_cross_config_types" {
  let cfg = zlib_cross_config()
  assert_eq(cfg.types.length(), 1)
}

test "zlib_cross_config_has_zlib_error_type" {
  let cfg = zlib_cross_config()
  assert_true(has_type(cfg.types, "ZlibError"))
}

test "zlib_c_header_not_empty" {
  let header = zlib_c_header()
  assert_true(header.length() > 0)
}

test "zlib_c_header_contains_include_guard" {
  let header = zlib_c_header()
  assert_true(header.contains("#ifndef"))
}

test "zlib_c_header_contains_module_name" {
  let header = zlib_c_header()
  assert_true(header.contains("mizchi_zlib"))
}

test "zlib_c_header_contains_moonbit" {
  let header = zlib_c_header()
  assert_true(header.contains("moonbit.h"))
}

test "zlib_c_header_contains_stdint" {
  let header = zlib_c_header()
  assert_true(header.contains("stdint.h"))
}

test "zlib_c_export_macro_not_empty" {
  let macro = zlib_c_export_macro()
  assert_true(macro.length() > 0)
}

test "zlib_c_export_macro_contains_win32" {
  let macro = zlib_c_export_macro()
  assert_true(macro.contains("_WIN32"))
}

test "zlib_c_export_macro_contains_dllexport" {
  let macro = zlib_c_export_macro()
  assert_true(macro.contains("dllexport"))
}

test "zlib_c_export_macro_contains_visibility" {
  let macro = zlib_c_export_macro()
  assert_true(macro.contains("visibility"))
}

test "zlib_platform_specs_count" {
  let specs = zlib_platform_specs()
  assert_eq(specs.length(), 4)
}

test "zlib_platform_specs_has_ios" {
  assert_true(has_platform_spec(zlib_platform_specs(), @core.Platform::Ios))
}

test "zlib_platform_specs_has_android" {
  assert_true(
    has_platform_spec(zlib_platform_specs(), @core.Platform::Android),
  )
}

test "zlib_platform_specs_has_windows" {
  assert_true(
    has_platform_spec(zlib_platform_specs(), @core.Platform::Windows),
  )
}

test "zlib_platform_specs_has_ohos" {
  assert_true(has_platform_spec(zlib_platform_specs(), @core.Platform::Ohos))
}

test "zlib_platform_specs_ios_ffi" {
  match find_platform_spec(zlib_platform_specs(), @core.Platform::Ios) {
    Some(s) => assert_eq(s.ffi_mechanism, "swift-interop")
    None => assert_true(false)
  }
}

test "zlib_platform_specs_android_ffi" {
  match find_platform_spec(zlib_platform_specs(), @core.Platform::Android) {
    Some(s) => assert_eq(s.ffi_mechanism, "jni")
    None => assert_true(false)
  }
}

test "zlib_platform_specs_windows_ffi" {
  match find_platform_spec(zlib_platform_specs(), @core.Platform::Windows) {
    Some(s) => assert_eq(s.ffi_mechanism, "dllimport")
    None => assert_true(false)
  }
}

test "zlib_platform_specs_ohos_ffi" {
  match find_platform_spec(zlib_platform_specs(), @core.Platform::Ohos) {
    Some(s) => assert_eq(s.ffi_mechanism, "napi")
    None => assert_true(false)
  }
}

test "zlib_ffi_bindings_count" {
  let bindings = zlib_ffi_bindings()
  assert_eq(bindings.length(), 4)
}

test "zlib_ffi_bindings_has_jni" {
  assert_true(
    has_ffi_binding(zlib_ffi_bindings(), @ffi.FfiBindingType::JniBinding),
  )
}

test "zlib_ffi_bindings_has_napi" {
  assert_true(
    has_ffi_binding(zlib_ffi_bindings(), @ffi.FfiBindingType::NapiBinding),
  )
}

test "zlib_ffi_bindings_has_swift" {
  assert_true(
    has_ffi_binding(
      zlib_ffi_bindings(),
      @ffi.FfiBindingType::SwiftInteropBinding,
    ),
  )
}

test "zlib_ffi_bindings_has_dllimport" {
  assert_true(
    has_ffi_binding(
      zlib_ffi_bindings(),
      @ffi.FfiBindingType::DllImportBinding,
    ),
  )
}

test "zlib_windows_compile_command_not_empty" {
  let cmd = zlib_windows_compile_command()
  assert_true(cmd.length() > 0)
}

test "zlib_windows_compile_command_contains_dll" {
  let cmd = zlib_windows_compile_command()
  assert_true(cmd.contains(".dll"))
}

test "zlib_windows_compile_command_contains_module" {
  let cmd = zlib_windows_compile_command()
  assert_true(cmd.contains("mizchi_zlib"))
}

test "zlib_android_compile_command_not_empty" {
  let cmd = zlib_android_compile_command()
  assert_true(cmd.length() > 0)
}

test "zlib_android_compile_command_contains_so" {
  let cmd = zlib_android_compile_command()
  assert_true(cmd.contains(".so"))
}

test "zlib_android_compile_command_contains_module" {
  let cmd = zlib_android_compile_command()
  assert_true(cmd.contains("mizchi_zlib"))
}

test "zlib_android_compile_command_contains_android_target" {
  let cmd = zlib_android_compile_command()
  assert_true(cmd.contains("aarch64-linux-android"))
}

test "zlib_ios_compile_command_not_empty" {
  let cmd = zlib_ios_compile_command()
  assert_true(cmd.length() > 0)
}

test "zlib_ios_compile_command_contains_dylib" {
  let cmd = zlib_ios_compile_command()
  assert_true(cmd.contains(".dylib"))
}

test "zlib_ios_compile_command_contains_module" {
  let cmd = zlib_ios_compile_command()
  assert_true(cmd.contains("mizchi_zlib"))
}

test "zlib_ios_compile_command_contains_ios_target" {
  let cmd = zlib_ios_compile_command()
  assert_true(cmd.contains("apple-ios"))
}

test "zlib_ios_compile_command_contains_xcrun" {
  let cmd = zlib_ios_compile_command()
  assert_true(cmd.contains("xcrun"))
}

test "zlib_ohos_compile_command_not_empty" {
  let cmd = zlib_ohos_compile_command()
  assert_true(cmd.length() > 0)
}

test "zlib_ohos_compile_command_contains_so" {
  let cmd = zlib_ohos_compile_command()
  assert_true(cmd.contains(".so"))
}

test "zlib_ohos_compile_command_contains_module" {
  let cmd = zlib_ohos_compile_command()
  assert_true(cmd.contains("mizchi_zlib"))
}

test "zlib_ohos_compile_command_contains_ohos_target" {
  let cmd = zlib_ohos_compile_command()
  assert_true(cmd.contains("linux-ohos"))
}

test "pipeline_version" {
  assert_eq(pipeline_version(), "moon-cross integration v0.4.0")
}

test "run_zlib_pipeline_config" {
  let result = run_zlib_pipeline()
  assert_eq(result.config.functions.length(), 10)
}

test "run_zlib_pipeline_c_header" {
  let result = run_zlib_pipeline()
  assert_true(result.c_header.contains("mizchi_zlib"))
}

test "run_zlib_pipeline_c_export_macro" {
  let result = run_zlib_pipeline()
  assert_true(result.c_export_macro.contains("_WIN32"))
}

test "run_zlib_pipeline_platform_specs" {
  let result = run_zlib_pipeline()
  assert_eq(result.platform_specs.length(), 4)
}

test "run_zlib_pipeline_ffi_bindings" {
  let result = run_zlib_pipeline()
  assert_eq(result.ffi_bindings.length(), 4)
}

test "run_zlib_pipeline_windows_command" {
  let result = run_zlib_pipeline()
  assert_true(result.windows_command.contains(".dll"))
}

test "run_zlib_pipeline_android_command" {
  let result = run_zlib_pipeline()
  assert_true(result.android_command.contains(".so"))
}

test "run_zlib_pipeline_ios_command" {
  let result = run_zlib_pipeline()
  assert_true(result.ios_command.contains(".dylib"))
}

test "run_zlib_pipeline_ohos_command" {
  let result = run_zlib_pipeline()
  assert_true(result.ohos_command.contains(".so"))
}

test "validate_pipeline_success" {
  let result = run_zlib_pipeline()
  assert_true(validate_pipeline(result))
}

test "zlib_pipeline_result_construction" {
  let result = run_zlib_pipeline()
  assert_eq(result.config.module_path, "mizchi/zlib")
}

test "zlib_pipeline_all_commands_non_empty" {
  let result = run_zlib_pipeline()
  assert_true(result.windows_command.length() > 0)
  assert_true(result.android_command.length() > 0)
  assert_true(result.ios_command.length() > 0)
  assert_true(result.ohos_command.length() > 0)
}

test "zlib_pipeline_config_targets_all_platforms" {
  let result = run_zlib_pipeline()
  let targets = result.config.targets
  assert_eq(targets.length(), 4)
}

test "zlib_pipeline_ffi_bindings_all_types" {
  let result = run_zlib_pipeline()
  let bindings = result.ffi_bindings
  assert_true(
    has_ffi_binding(bindings, @ffi.FfiBindingType::JniBinding),
  )
  assert_true(
    has_ffi_binding(bindings, @ffi.FfiBindingType::NapiBinding),
  )
  assert_true(
    has_ffi_binding(bindings, @ffi.FfiBindingType::SwiftInteropBinding),
  )
  assert_true(
    has_ffi_binding(bindings, @ffi.FfiBindingType::DllImportBinding),
  )
}