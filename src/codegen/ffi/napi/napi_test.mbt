test "napi_version" {
  assert_eq(@napi.napi_version(), "moon-cross NAPI v0.1.0")
}

test "napi_declaration" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "myFunc" }
  let decl = @napi.napi_declaration(cfg)
  assert_true(decl.contains("napi_value"))
  assert_true(decl.contains("myFunc_napi"))
}

test "napi_declaration_contains_env" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let decl = @napi.napi_declaration(cfg)
  assert_true(decl.contains("napi_env env"))
}

test "napi_declaration_contains_callback_info" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let decl = @napi.napi_declaration(cfg)
  assert_true(decl.contains("napi_callback_info info"))
}

test "generate_arkts_import" {
  assert_eq(@napi.generate_arkts_import("mylib"), "import native from 'libmylib.so'")
}

test "generate_arkts_import_empty" {
  assert_eq(@napi.generate_arkts_import(""), "import native from 'lib.so'")
}

test "generate_arkts_function_call_contains_export" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let call = @napi.generate_arkts_function_call(cfg)
  assert_true(call.contains("export function"))
}

test "generate_arkts_function_call_contains_name" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "myFunc" }
  let call = @napi.generate_arkts_function_call(cfg)
  assert_true(call.contains("myFunc"))
}

test "generate_arkts_function_call_returns_uint8array" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let call = @napi.generate_arkts_function_call(cfg)
  assert_true(call.contains("Uint8Array"))
}

test "generate_arkts_function_call_calls_native" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let call = @napi.generate_arkts_function_call(cfg)
  assert_true(call.contains("native.f"))
}

test "napi_register_module_contains_register" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let reg = @napi.napi_register_module(cfg)
  assert_true(reg.contains("napi_register_module_v1"))
}

test "napi_register_module_contains_exports" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let reg = @napi.napi_register_module(cfg)
  assert_true(reg.contains("napi_value exports"))
}

test "napi_register_module_contains_function_name" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "myFunc" }
  let reg = @napi.napi_register_module(cfg)
  assert_true(reg.contains("myFunc"))
}

test "napi_register_module_contains_register_fn" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let reg = @napi.napi_register_module(cfg)
  assert_true(reg.contains("napi_register_fn"))
}

test "generate_oh_package_json_contains_name" {
  let json = @napi.generate_oh_package_json("mylib")
  assert_true(json.contains("\"name\": \"mylib\""))
}

test "generate_oh_package_json_contains_version" {
  let json = @napi.generate_oh_package_json("mylib")
  assert_true(json.contains("\"version\": \"0.1.0\""))
}

test "generate_oh_package_json_contains_main" {
  let json = @napi.generate_oh_package_json("mylib")
  assert_true(json.contains("\"main\": \"index.ets\""))
}

test "generate_build_profile_contains_app" {
  let profile = @napi.generate_build_profile("myapp")
  assert_true(profile.contains("\"app\""))
}

test "generate_build_profile_contains_products" {
  let profile = @napi.generate_build_profile("myapp")
  assert_true(profile.contains("\"products\""))
}

test "generate_build_profile_contains_modules" {
  let profile = @napi.generate_build_profile("myapp")
  assert_true(profile.contains("\"modules\""))
}

test "generate_build_profile_contains_entry" {
  let profile = @napi.generate_build_profile("myapp")
  assert_true(profile.contains("\"entry\""))
}

test "napi_header_includes_contains_napi" {
  let includes = @napi.napi_header_includes()
  assert_true(includes.contains("napi/native_api.h"))
}

test "napi_header_includes_contains_stdint" {
  let includes = @napi.napi_header_includes()
  assert_true(includes.contains("stdint.h"))
}

test "napi_header_includes_contains_moonbit" {
  let includes = @napi.napi_header_includes()
  assert_true(includes.contains("moonbit.h"))
}

test "arkts_file_header" {
  assert_eq(@napi.arkts_file_header(), "import native from 'libnative.so'\n\n")
}

test "arkts_wrapper_file_contains_import" {
  let cfg : @napi.NapiBindingConfig = { module_name: "mylib", function_name: "f" }
  let wrapper = @napi.arkts_wrapper_file(cfg)
  assert_true(wrapper.contains("import native from 'libmylib.so'"))
}

test "arkts_wrapper_file_contains_export" {
  let cfg : @napi.NapiBindingConfig = { module_name: "m", function_name: "f" }
  let wrapper = @napi.arkts_wrapper_file(cfg)
  assert_true(wrapper.contains("export function"))
}

test "generate_module_json_contains_module" {
  let json = @napi.generate_module_json("myapp")
  assert_true(json.contains("\"module\""))
}

test "generate_module_json_contains_entry" {
  let json = @napi.generate_module_json("myapp")
  assert_true(json.contains("\"entry\""))
}

test "generate_module_json_contains_deviceTypes" {
  let json = @napi.generate_module_json("myapp")
  assert_true(json.contains("\"deviceTypes\""))
}

test "napi_binding_config_construction" {
  let cfg : @napi.NapiBindingConfig = { module_name: "mod", function_name: "fn" }
  assert_eq(cfg.module_name, "mod")
  assert_eq(cfg.function_name, "fn")
}