test "napi_version" {
  assert_eq(napi_version(), "moon-cross NAPI v0.1.0")
}

test "napi_declaration" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "myFunc" }
  let decl = napi_declaration(cfg)
  assert_true(decl.contains("napi_value"))
  assert_true(decl.contains("myFunc_napi"))
}

test "napi_declaration_contains_env" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let decl = napi_declaration(cfg)
  assert_true(decl.contains("napi_env env"))
}

test "napi_declaration_contains_callback_info" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let decl = napi_declaration(cfg)
  assert_true(decl.contains("napi_callback_info info"))
}

test "generate_arkts_import" {
  assert_eq(generate_arkts_import("mylib"), "import native from 'libmylib.so'")
}

test "generate_arkts_import_empty" {
  assert_eq(generate_arkts_import(""), "import native from 'lib.so'")
}

test "generate_arkts_function_call_contains_export" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let call = generate_arkts_function_call(cfg)
  assert_true(call.contains("export function"))
}

test "generate_arkts_function_call_contains_name" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "myFunc" }
  let call = generate_arkts_function_call(cfg)
  assert_true(call.contains("myFunc"))
}

test "generate_arkts_function_call_returns_uint8array" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let call = generate_arkts_function_call(cfg)
  assert_true(call.contains("Uint8Array"))
}

test "generate_arkts_function_call_calls_native" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let call = generate_arkts_function_call(cfg)
  assert_true(call.contains("native.f"))
}

test "napi_register_module_contains_register" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let reg = napi_register_module(cfg)
  assert_true(reg.contains("napi_register_module_v1"))
}

test "napi_register_module_contains_exports" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let reg = napi_register_module(cfg)
  assert_true(reg.contains("napi_value exports"))
}

test "napi_register_module_contains_function_name" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "myFunc" }
  let reg = napi_register_module(cfg)
  assert_true(reg.contains("myFunc"))
}

test "napi_register_module_contains_register_fn" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let reg = napi_register_module(cfg)
  assert_true(reg.contains("napi_register_fn"))
}

test "generate_oh_package_json_contains_name" {
  let json = generate_oh_package_json("mylib")
  assert_true(json.contains("\"name\": \"mylib\""))
}

test "generate_oh_package_json_contains_version" {
  let json = generate_oh_package_json("mylib")
  assert_true(json.contains("\"version\": \"0.1.0\""))
}

test "generate_oh_package_json_contains_main" {
  let json = generate_oh_package_json("mylib")
  assert_true(json.contains("\"main\": \"index.ets\""))
}

test "generate_build_profile_contains_app" {
  let profile = generate_build_profile("myapp")
  assert_true(profile.contains("\"app\""))
}

test "generate_build_profile_contains_products" {
  let profile = generate_build_profile("myapp")
  assert_true(profile.contains("\"products\""))
}

test "generate_build_profile_contains_modules" {
  let profile = generate_build_profile("myapp")
  assert_true(profile.contains("\"modules\""))
}

test "generate_build_profile_contains_entry" {
  let profile = generate_build_profile("myapp")
  assert_true(profile.contains("\"entry\""))
}

test "napi_header_includes_contains_napi" {
  let includes = napi_header_includes()
  assert_true(includes.contains("napi/native_api.h"))
}

test "napi_header_includes_contains_stdint" {
  let includes = napi_header_includes()
  assert_true(includes.contains("stdint.h"))
}

test "napi_header_includes_contains_moonbit" {
  let includes = napi_header_includes()
  assert_true(includes.contains("moonbit.h"))
}

test "arkts_file_header" {
  assert_eq(arkts_file_header(), "import native from 'libnative.so'\n\n")
}

test "arkts_wrapper_file_contains_import" {
  let cfg : NapiBindingConfig = { module_name: "mylib", function_name: "f" }
  let wrapper = arkts_wrapper_file(cfg)
  assert_true(wrapper.contains("import native from 'libmylib.so'"))
}

test "arkts_wrapper_file_contains_export" {
  let cfg : NapiBindingConfig = { module_name: "m", function_name: "f" }
  let wrapper = arkts_wrapper_file(cfg)
  assert_true(wrapper.contains("export function"))
}

test "generate_module_json_contains_module" {
  let json = generate_module_json("myapp")
  assert_true(json.contains("\"module\""))
}

test "generate_module_json_contains_entry" {
  let json = generate_module_json("myapp")
  assert_true(json.contains("\"entry\""))
}

test "generate_module_json_contains_deviceTypes" {
  let json = generate_module_json("myapp")
  assert_true(json.contains("\"deviceTypes\""))
}

test "napi_binding_config_construction" {
  let cfg : NapiBindingConfig = { module_name: "mod", function_name: "fn" }
  assert_eq(cfg.module_name, "mod")
  assert_eq(cfg.function_name, "fn")
}