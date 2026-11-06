///|
/// JNI 绑定生成配置 | JNI binding generation config
pub(all) struct JniBindingConfig {
  java_package : String
  class_name : String
  function_name : String
} derive(Debug, Eq)

///|
pub extend JniBindingConfig with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend JniBindingConfig with Eq::{not_equal, equal}

///|
/// JNI 完整绑定配置（含参数和返回类型） | JNI full binding config with params and return type
pub(all) struct JniFullBinding {
  java_package : String
  class_name : String
  function_name : String
  params : Array[(String, String)]
  return_type : String
} derive(Debug, Eq)

///|
pub extend JniFullBinding with @moonbitlang/core/debug.Debug::{to_repr}

///|
pub extend JniFullBinding with Eq::{not_equal, equal}

///|
/// JNI 版本 | JNI version
pub fn jni_version() -> String {
  "moon-cross JNI v0.3.33"
}

///|
/// 生成 JNI 函数名（Java_pkg_Class_function） | Generate JNI function name (Java_pkg_Class_function)
pub fn jni_function_name(config : JniBindingConfig) -> String {
  "Java_" +
  config.java_package +
  "_" +
  config.class_name +
  "_" +
  config.function_name
}

///|
/// 生成 JNI C 函数声明 | Generate JNI C function declaration
pub fn jni_c_declaration(config : JniBindingConfig) -> String {
  "JNIEXPORT jobjectArray JNICALL " +
  jni_function_name(config) +
  "(JNIEnv *env, jobject thiz)"
}

///|
/// 生成 Kotlin external fun 声明 | Generate Kotlin external fun declaration
pub fn kotlin_external_fun(config : JniBindingConfig) -> String {
  "external fun " + config.function_name + "(): ByteArray"
}

///|
/// 生成 Kotlin companion init 加载库 | Generate Kotlin companion init library load
pub fn kotlin_library_load(lib_name : String) -> String {
  "companion object { init { System.loadLibrary(\"" + lib_name + "\") } }"
}

///|
/// 生成 System.loadLibrary 声明 | Generate System.loadLibrary declaration
pub fn system_load_library(lib_name : String) -> String {
  "System.loadLibrary(\"" + lib_name + "\")"
}

///|
/// 生成 Gradle android 配置块 | Generate Gradle android config block
pub fn gradle_android_block() -> String {
  "android {\n  sourceSets {\n    main {\n      jniLibs.srcDirs = [\"src/main/jniLibs\"]\n    }\n  }\n}"
}

///|
/// 生成 CMakeLists.txt 骨架 | Generate CMakeLists.txt skeleton
pub fn cmake_skeleton(lib_name : String) -> String {
  "cmake_minimum_required(VERSION 3.10)\nproject(" +
  lib_name +
  ")\nadd_library(" +
  lib_name +
  " SHARED src/main.c)\n"
}

///|
/// 生成 Kotlin class 骨架 | Generate Kotlin class skeleton
pub fn kotlin_class_skeleton(class_name : String, lib_name : String) -> String {
  "class " +
  class_name +
  " {\n  " +
  kotlin_library_load(lib_name) +
  "\n  external fun nativeOp(): ByteArray\n}"
}

///|
/// 生成 JNI 方法注册表条目 | Generate JNI method registration table entry
pub fn jni_method_registration(config : JniBindingConfig) -> String {
  "{ \"" +
  config.function_name +
  "\", \"" +
  config.java_package +
  "/" +
  config.class_name +
  "\", " +
  jni_function_name(config) +
  " }"
}

///|
/// 生成 Android Gradle dependencies 块 | Generate Android Gradle dependencies block
pub fn gradle_dependencies() -> String {
  "dependencies {\n  implementation fileTree(dir: \"libs\", include: [\"*.jar\"])\n}"
}

///|
/// 生成 CMake add_library 指令 | Generate CMake add_library directive
pub fn cmake_add_library(lib_name : String) -> String {
  "add_library(" + lib_name + " SHARED src/main.c)"
}

///|
/// 生成 CMake target_link_libraries 指令 | Generate CMake target_link_libraries directive
pub fn cmake_link_libraries(lib_name : String) -> String {
  "target_link_libraries(" + lib_name + " log)"
}

///|
/// 生成完整 CMakeLists.txt | Generate complete CMakeLists.txt
pub fn cmake_full(lib_name : String) -> String {
  cmake_skeleton(lib_name) + cmake_link_libraries(lib_name) + "\n"
}

///|
/// 生成 JNI 头文件 include 块 | Generate JNI header include block
pub fn jni_header_includes() -> String {
  "#include <jni.h>\n#include <stdint.h>\n#include \"moonbit.h\"\n"
}

///|
/// 生成 Kotlin file 头部 | Generate Kotlin file header
pub fn kotlin_file_header(package_name : String) -> String {
  "package " + package_name + "\n\n"
}

///|
/// 生成完整 Kotlin wrapper 文件 | Generate complete Kotlin wrapper file
pub fn kotlin_wrapper_file(
  package_name : String,
  class_name : String,
  lib_name : String,
) -> String {
  kotlin_file_header(package_name) +
  kotlin_class_skeleton(class_name, lib_name) +
  "\n"
}

///|
/// JNI 返回类型映射（MoonBit→JNI） | JNI return type mapping (MoonBit to JNI)
pub fn jni_return_type(mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) =>
      match t {
        IntT => "jint"
        DoubleT => "jdouble"
        BoolT => "jboolean"
        UnitT => "void"
        StringT => "jstring"
        BytesT => "jbyteArray"
        _ => "jobject"
      }
    None => "jobject"
  }
}

///|
/// JNI 参数类型映射 | JNI parameter type mapping
pub fn jni_param_type(mbt_type : String) -> String {
  jni_return_type(mbt_type)
}

///|
/// 生成 JNI 参数转换代码（含 GetByteArrayElements 等调用序列） | Generate JNI param conversion code
pub fn jni_param_conversion(param_name : String, mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) =>
      match t {
        StringT =>
          "  const char* c_" +
          param_name +
          " = (*env)->GetStringUTFChars(env, " +
          param_name +
          ", NULL);\n"
        BytesT =>
          "  jbyte* c_" +
          param_name +
          " = (*env)->GetByteArrayElements(env, " +
          param_name +
          ", NULL);\n  jsize c_" +
          param_name +
          "_len = (*env)->GetArrayLength(env, " +
          param_name +
          ");\n"
        _ => ""
      }
    None => ""
  }
}

///|
/// 格式化 JNI 调用参数（使用转换后的 C 变量） | Format JNI call params with converted C vars
pub fn jni_call_params(params : Array[(String, String)]) -> String {
  let parts = []
  for p in params {
    match @typesys.parse_moonbit_type(p.1) {
      Some(t) =>
        match t {
          StringT => parts.push("c_" + p.0)
          BytesT => parts.push("c_" + p.0)
          _ => parts.push(p.0)
        }
      None => parts.push(p.0)
    }
  }
  join_strings(parts, ", ")
}

///|
/// 生成 JNI 结果转换代码（MoonBit→JNI） | Generate JNI result conversion code
pub fn jni_result_conversion(mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) =>
      match t {
        StringT =>
          "  jstring result = (*env)->NewStringUTF(env, moonbit_string_to_cstr(mb_result));\n  return result;\n"
        BytesT =>
          "  jsize result_len = moonbit_bytes_length(mb_result);\n  jbyteArray result = (*env)->NewByteArray(env, result_len);\n  (*env)->SetByteArrayRegion(env, result, 0, result_len, (jbyte*)moonbit_bytes_to_c(mb_result));\n  return result;\n"
        IntT => "  return (jint)mb_result;\n"
        DoubleT => "  return (jdouble)mb_result;\n"
        BoolT => "  return (jboolean)mb_result;\n"
        _ => "  return NULL; // unsupported type\n"
      }
    None => "  return NULL;\n"
  }
}

///|
/// 生成 JNI 参数释放代码（含 ReleaseByteArrayElements） | Generate JNI param release code
pub fn jni_param_release(param_name : String, mbt_type : String) -> String {
  match @typesys.parse_moonbit_type(mbt_type) {
    Some(t) =>
      match t {
        StringT =>
          "  (*env)->ReleaseStringUTFChars(env, " +
          param_name +
          ", c_" +
          param_name +
          ");\n"
        BytesT =>
          "  (*env)->ReleaseByteArrayElements(env, " +
          param_name +
          ", c_" +
          param_name +
          ", JNI_ABORT);\n"
        _ => ""
      }
    None => ""
  }
}

///|
/// 生成完整 JNI 函数体（含类型转换 + 调用序列 + 释放） | Generate full JNI function body
pub fn jni_function_body(config : JniFullBinding) -> String {
  let fn_name = "Java_" +
    config.java_package +
    "_" +
    config.class_name +
    "_" +
    config.function_name
  let mut body = ""
  body = body +
    "JNIEXPORT " +
    jni_return_type(config.return_type) +
    " JNICALL " +
    fn_name +
    "(JNIEnv *env, jobject thiz"
  for p in config.params {
    body = body + ", " + jni_param_type(p.1) + " " + p.0
  }
  body = body + ") {\n"
  for p in config.params {
    body = body + jni_param_conversion(p.0, p.1)
  }
  let call_params = jni_call_params(config.params)
  body = body + "  // Call MoonBit native function\n"
  match @typesys.parse_moonbit_type(config.return_type) {
    Some(t) =>
      match t {
        UnitT =>
          body = body +
            "  moonbit_" +
            config.function_name +
            "(" +
            call_params +
            ");\n"
        _ =>
          body = body +
            "  moonbit_value_t mb_result = moonbit_" +
            config.function_name +
            "(" +
            call_params +
            ");\n"
      }
    None =>
      body = body +
        "  // Warning: unknown return type " +
        config.return_type +
        "\n"
  }
  for p in config.params {
    body = body + jni_param_release(p.0, p.1)
  }
  match @typesys.parse_moonbit_type(config.return_type) {
    Some(t) =>
      match t {
        UnitT => body = body + "}\n"
        _ => body = body + jni_result_conversion(config.return_type) + "}\n"
      }
    None => body = body + "  return NULL;\n}\n"
  }
  body
}

///|
/// 生成完整 JNI 绑定文件（头文件 + 函数体） | Generate complete JNI binding file
pub fn jni_full_binding(config : JniFullBinding) -> String {
  jni_header_includes() + "\n" + jni_function_body(config) + "\n"
}

///|
/// 连接字符串数组 | Join string array
fn join_strings(parts : Array[String], sep : String) -> String {
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
/// JniBindingConfig 实现 Named trait | JniBindingConfig implements Named
pub impl @trait.Named for JniBindingConfig with fn name(self) {
  self.class_name
}

///|
pub extend JniBindingConfig with @trait.Named::{name}

///|
/// JniBindingConfig 实现 Hashable trait | JniBindingConfig implements Hashable
pub impl @trait.Hashable for JniBindingConfig with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend JniBindingConfig with @trait.Hashable::{hash}

///|
/// JniFullBinding 实现 Named trait | JniFullBinding implements Named
pub impl @trait.Named for JniFullBinding with fn name(self) {
  self.function_name
}

///|
pub extend JniFullBinding with @trait.Named::{name}

///|
/// JniFullBinding 实现 Hashable trait | JniFullBinding implements Hashable
pub impl @trait.Hashable for JniFullBinding with fn hash(self) {
  @trait.Named::name(self).length()
}

///|
pub extend JniFullBinding with @trait.Hashable::{hash}
