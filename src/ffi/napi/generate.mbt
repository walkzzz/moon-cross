/// NAPI 绑定生成配置
pub(all) struct NapiBindingConfig {
  module_name : String
  function_name : String
} derive(Debug, Eq)

/// NAPI 版本
pub fn napi_version() -> String {
  "moon-cross NAPI v0.1.0"
}

/// 生成 NAPI napi_value 声明
pub fn napi_declaration(config : NapiBindingConfig) -> String {
  "napi_value " +
  config.function_name +
  "_napi(napi_env env, napi_callback_info info)"
}

/// 生成 ArkTS import 声明
pub fn generate_arkts_import(module_name : String) -> String {
  "import native from 'lib" + module_name + ".so'"
}

/// 生成 ArkTS 函数调用声明
pub fn generate_arkts_function_call(config : NapiBindingConfig) -> String {
  "export function " +
  config.function_name +
  "(): Uint8Array {\n  return native." +
  config.function_name +
  "()\n}"
}

/// 生成 napi_register_module_v1 函数
pub fn napi_register_module(config : NapiBindingConfig) -> String {
  "napi_value napi_register_module_v1(napi_env env, napi_value exports) {\n  napi_register_fn(env, exports, \"" +
  config.function_name +
  "\", " +
  config.function_name +
  "_napi);\n  return exports;\n}"
}

/// 生成 oh-package.json5 配置
pub fn generate_oh_package_json(name : String) -> String {
  "{\n  \"name\": \"" +
  name +
  "\",\n  \"version\": \"0.1.0\",\n  \"main\": \"index.ets\"\n}\n"
}

/// 生成 DevEco build-profile.json5 骨架
pub fn generate_build_profile(name : String) -> String {
  "{\n  \"app\": {\n    \"products\": [{\n      \"name\": \"default\",\n      \"signingConfig\": \"default\"\n    }]\n  },\n  \"modules\": [{\n    \"name\": \"entry\",\n    \"srcPath\": \"./entry\"\n  }]\n}\n"
}

/// 生成 NAPI 头文件 includes
pub fn napi_header_includes() -> String {
  "#include <napi/native_api.h>\n#include <stdint.h>\n#include \"moonbit.h\"\n"
}

/// 生成 ArkTS 文件头部
pub fn arkts_file_header() -> String {
  "import native from 'libnative.so'\n\n"
}

/// 生成完整 ArkTS wrapper 文件
pub fn arkts_wrapper_file(config : NapiBindingConfig) -> String {
  generate_arkts_import(config.module_name) +
  "\n" +
  generate_arkts_function_call(config) +
  "\n"
}

/// 生成 DevEco module.json5 骨架
pub fn generate_module_json(name : String) -> String {
  "{\n  \"module\": {\n    \"name\": \"entry\",\n    \"type\": \"entry\",\n    \"deviceTypes\": [\"default\"]\n  }\n}\n"
}