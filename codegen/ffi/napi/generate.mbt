///|
/// NAPI 绑定生成配置 | NAPI binding generation config
#derive(Debug, Eq)
pub(all) struct NapiBindingConfig {
  module_name : String
  function_name : String
}

///|
pub extend NapiBindingConfig with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend NapiBindingConfig with Eq::{not_equal, equal}

///|
/// NAPI 版本 | NAPI version
pub fn napi_version() -> String {
  "moon-cross NAPI v0.3.33"
}

///|
/// 生成 NAPI napi_value 声明 | Generate NAPI napi_value declaration
pub fn napi_declaration(config : NapiBindingConfig) -> String {
  "napi_value " +
  config.function_name +
  "_napi(napi_env env, napi_callback_info info)"
}

///|
/// 生成 ArkTS import 声明 | Generate ArkTS import declaration
pub fn generate_arkts_import(module_name : String) -> String {
  "import native from 'lib" + module_name + ".so'"
}

///|
/// 生成 ArkTS 函数调用声明 | Generate ArkTS function call declaration
pub fn generate_arkts_function_call(config : NapiBindingConfig) -> String {
  "export function " +
  config.function_name +
  "(): Uint8Array {\n  return native." +
  config.function_name +
  "()\n}"
}

///|
/// 生成 napi_register_module_v1 函数 | Generate napi_register_module_v1 function
pub fn napi_register_module(config : NapiBindingConfig) -> String {
  "napi_value napi_register_module_v1(napi_env env, napi_value exports) {\n  napi_register_fn(env, exports, \"" +
  config.function_name +
  "\", " +
  config.function_name +
  "_napi);\n  return exports;\n}"
}

///|
/// 生成 oh-package.json5 配置 | Generate oh-package.json5 config
pub fn generate_oh_package_json(name : String) -> String {
  "{\n  \"name\": \"" +
  name +
  "\",\n  \"version\": \"0.1.0\",\n  \"main\": \"index.ets\"\n}\n"
}

///|
/// 生成 DevEco build-profile.json5 骨架 | Generate DevEco build-profile.json5 skeleton
pub fn generate_build_profile(_name : String) -> String {
  "{\n  \"app\": {\n    \"products\": [{\n      \"name\": \"default\",\n      \"signingConfig\": \"default\"\n    }]\n  },\n  \"modules\": [{\n    \"name\": \"entry\",\n    \"srcPath\": \"./entry\"\n  }]\n}\n"
}

///|
/// 生成 NAPI 头文件 includes | Generate NAPI header includes
pub fn napi_header_includes() -> String {
  "#include <napi/native_api.h>\n#include <stdint.h>\n#include \"moonbit.h\"\n"
}

///|
/// 生成 ArkTS 文件头部 | Generate ArkTS file header
pub fn arkts_file_header() -> String {
  "import native from 'libnative.so'\n\n"
}

///|
/// 生成完整 ArkTS wrapper 文件 | Generate complete ArkTS wrapper file
pub fn arkts_wrapper_file(config : NapiBindingConfig) -> String {
  generate_arkts_import(config.module_name) +
  "\n" +
  generate_arkts_function_call(config) +
  "\n"
}

///|
/// 生成 DevEco module.json5 骨架 | Generate DevEco module.json5 skeleton
pub fn generate_module_json(_name : String) -> String {
  "{\n  \"module\": {\n    \"name\": \"entry\",\n    \"type\": \"entry\",\n    \"deviceTypes\": [\"default\"]\n  }\n}\n"
}

///|
/// NAPI 完整绑定配置（含参数和返回类型） | NAPI full binding config
#derive(Debug, Eq)
pub(all) struct NapiFullBinding {
  module_name : String
  function_name : String
  params : Array[(String, String)]
  return_type : String
}

///|
pub extend NapiFullBinding with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend NapiFullBinding with Eq::{not_equal, equal}

///|
/// NAPI 类型映射（复用 typesys） | NAPI type mapping (reuses typesys)
pub fn napi_type_map(mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) => @typesys.moonbit_to_arkts_string(t)
    None => "Object"
  }
}

///|
/// 生成 NAPI 参数转换代码 | Generate NAPI param conversion code
pub fn napi_param_conversion(
  param_name : String,
  mbt_type : String,
  index : Int32,
) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) =>
      match t {
        IntT =>
          "  int32_t c_" +
          param_name +
          ";\n  napi_get_value_int32(env, args[" +
          index.to_string() +
          "], &c_" +
          param_name +
          ");\n"
        DoubleT =>
          "  double c_" +
          param_name +
          ";\n  napi_get_value_double(env, args[" +
          index.to_string() +
          "], &c_" +
          param_name +
          ");\n"
        BoolT =>
          "  bool c_" +
          param_name +
          ";\n  napi_get_value_bool(env, args[" +
          index.to_string() +
          "], &c_" +
          param_name +
          ");\n"
        StringT =>
          "  size_t c_" +
          param_name +
          "_len;\n  napi_get_value_string_utf8(env, args[" +
          index.to_string() +
          "], NULL, 0, &c_" +
          param_name +
          "_len);\n  char c_" +
          param_name +
          "[c_" +
          param_name +
          "_len + 1];\n  napi_get_value_string_utf8(env, args[" +
          index.to_string() +
          "], c_" +
          param_name +
          ", c_" +
          param_name +
          "_len + 1, &c_" +
          param_name +
          "_len);\n"
        _ => "  // Unsupported type: " + mbt_type + "\n"
      }
    None => "  // Unknown type: " + mbt_type + "\n"
  }
}

///|
/// 生成 NAPI 结果转换代码 | Generate NAPI result conversion code
pub fn napi_result_conversion(mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) =>
      match t {
        IntT =>
          "  napi_value result;\n  napi_create_int32(env, (int32_t)mb_result, &result);\n  return result;\n"
        DoubleT =>
          "  napi_value result;\n  napi_create_double(env, (double)mb_result, &result);\n  return result;\n"
        BoolT =>
          "  napi_value result;\n  napi_create_bool(env, (bool)mb_result, &result);\n  return result;\n"
        StringT =>
          "  napi_value result;\n  napi_create_string_utf8(env, moonbit_string_to_cstr(mb_result), NAPI_AUTO_LENGTH, &result);\n  return result;\n"
        _ => "  return NULL;\n"
      }
    None => "  return NULL;\n"
  }
}

///|
/// 生成 NAPI 函数体（含参数转换 + 调用 + 结果转换） | Generate NAPI function body
pub fn napi_function_body(config : NapiFullBinding) -> String {
  let mut body = "napi_value " +
    config.function_name +
    "_napi(napi_env env, napi_callback_info info) {\n"
  let argc = config.params.length()
  body = body + "  size_t argc = " + argc.to_string() + ";\n"
  let arr_size = if argc == 0 { 1 } else { argc }
  body = body + "  napi_value args[" + arr_size.to_string() + "];\n"
  body = body + "  napi_get_cb_info(env, info, &argc, args, NULL, NULL);\n\n"
  for i = 0; i < config.params.length(); i = i + 1 {
    let p = config.params[i]
    body = body + napi_param_conversion(p.0, p.1, i)
  }
  let call_parts = []
  for p in config.params {
    call_parts.push("c_" + p.0)
  }
  let call_str = join_str(call_parts, ", ")
  body = body + "  // Call MoonBit function\n"
  match @typesys.parse_moonbit_type(config.return_type) {
    Some(t) =>
      match t {
        UnitT =>
          body = body +
            "  moonbit_" +
            config.function_name +
            "(" +
            call_str +
            ");\n  return NULL;\n"
        _ =>
          body = body +
            "  moonbit_value_t mb_result = moonbit_" +
            config.function_name +
            "(" +
            call_str +
            ");\n" +
            napi_result_conversion(config.return_type)
      }
    None => body = body + "  return NULL;\n"
  }
  body = body + "}\n"
  body
}

///|
/// 生成完整 NAPI 绑定文件 | Generate complete NAPI binding file
pub fn napi_full_binding(config : NapiFullBinding) -> String {
  napi_header_includes() +
  "\n" +
  napi_function_body(config) +
  "\n" +
  napi_register_module({
    module_name: config.module_name,
    function_name: config.function_name,
  }) +
  "\n"
}

///|
/// 连接字符串数组 | Join string array
fn join_str(parts : Array[String], sep : String) -> String {
  let mut result = ""
  let mut first = true
  for p in parts {
    if !first {
      result = result + sep
    }
    result = result + p
    first = false
  }
  result
}

///|
/// NapiBindingConfig 实现 Named trait | NapiBindingConfig implements Named
pub impl @trait.Named for NapiBindingConfig with fn name(self) {
  self.module_name
}

///|
pub extend NapiBindingConfig with @trait.Named::{name}

///|
/// NapiBindingConfig 实现 Hashable trait | NapiBindingConfig implements Hashable
pub impl @trait.Hashable for NapiBindingConfig with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend NapiBindingConfig with @trait.Hashable::{hash}

///|
/// NapiFullBinding 实现 Named trait | NapiFullBinding implements Named
pub impl @trait.Named for NapiFullBinding with fn name(self) {
  self.function_name
}

///|
pub extend NapiFullBinding with @trait.Named::{name}

///|
/// NapiFullBinding 实现 Hashable trait | NapiFullBinding implements Hashable
pub impl @trait.Hashable for NapiFullBinding with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend NapiFullBinding with @trait.Hashable::{hash}
