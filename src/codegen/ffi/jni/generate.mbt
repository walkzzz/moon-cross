/// JNI 绑定生成配置 | JNI binding generation config
pub(all) struct JniBindingConfig {
  java_package : String
  class_name : String
  function_name : String
} derive(Debug, Eq)
pub extend JniBindingConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend JniBindingConfig with Eq::{not_equal, equal}

/// JNI 版本 | JNI version
pub fn jni_version() -> String {
  "moon-cross JNI v0.1.0"
}

/// 生成 JNI 函数名（Java_pkg_Class_function） | Generate JNI function name (Java_pkg_Class_function)
pub fn jni_function_name(config : JniBindingConfig) -> String {
  "Java_" + config.java_package + "_" + config.class_name + "_" + config.function_name
}

/// 生成 JNI C 函数声明 | Generate JNI C function declaration
pub fn jni_c_declaration(config : JniBindingConfig) -> String {
  "JNIEXPORT jobjectArray JNICALL " + jni_function_name(config) + "(JNIEnv *env, jobject thiz)"
}

/// 生成 Kotlin external fun 声明 | Generate Kotlin external fun declaration
pub fn kotlin_external_fun(config : JniBindingConfig) -> String {
  "external fun " + config.function_name + "(): ByteArray"
}

/// 生成 Kotlin companion init 加载库 | Generate Kotlin companion init library load
pub fn kotlin_library_load(lib_name : String) -> String {
  "companion object { init { System.loadLibrary(\"" + lib_name + "\") } }"
}

/// 生成 System.loadLibrary 声明 | Generate System.loadLibrary declaration
pub fn system_load_library(lib_name : String) -> String {
  "System.loadLibrary(\"" + lib_name + "\")"
}

/// 生成 Gradle android 配置块 | Generate Gradle android config block
pub fn gradle_android_block() -> String {
  "android {\n  sourceSets {\n    main {\n      jniLibs.srcDirs = [\"src/main/jniLibs\"]\n    }\n  }\n}"
}

/// 生成 CMakeLists.txt 骨架 | Generate CMakeLists.txt skeleton
pub fn cmake_skeleton(lib_name : String) -> String {
  "cmake_minimum_required(VERSION 3.10)\nproject(" + lib_name + ")\nadd_library(" + lib_name + " SHARED src/main.c)\n"
}

/// 生成 Kotlin class 骨架 | Generate Kotlin class skeleton
pub fn kotlin_class_skeleton(class_name : String, lib_name : String) -> String {
  "class " + class_name + " {\n  " + kotlin_library_load(lib_name) + "\n  external fun nativeOp(): ByteArray\n}"
}

/// 生成 JNI 方法注册表条目 | Generate JNI method registration table entry
pub fn jni_method_registration(config : JniBindingConfig) -> String {
  "{ \"" + config.function_name + "\", \"" + config.java_package + "/" + config.class_name + "\", " + jni_function_name(config) + " }"
}

/// 生成 Android Gradle dependencies 块 | Generate Android Gradle dependencies block
pub fn gradle_dependencies() -> String {
  "dependencies {\n  implementation fileTree(dir: \"libs\", include: [\"*.jar\"])\n}"
}

/// 生成 CMake add_library 指令 | Generate CMake add_library directive
pub fn cmake_add_library(lib_name : String) -> String {
  "add_library(" + lib_name + " SHARED src/main.c)"
}

/// 生成 CMake target_link_libraries 指令 | Generate CMake target_link_libraries directive
pub fn cmake_link_libraries(lib_name : String) -> String {
  "target_link_libraries(" + lib_name + " log)"
}

/// 生成完整 CMakeLists.txt | Generate complete CMakeLists.txt
pub fn cmake_full(lib_name : String) -> String {
  cmake_skeleton(lib_name) + cmake_link_libraries(lib_name) + "\n"
}

/// 生成 JNI 头文件 include 块 | Generate JNI header include block
pub fn jni_header_includes() -> String {
  "#include <jni.h>\n#include <stdint.h>\n#include \"moonbit.h\"\n"
}

/// 生成 Kotlin file 头部 | Generate Kotlin file header
pub fn kotlin_file_header(package_name : String) -> String {
  "package " + package_name + "\n\n"
}

/// 生成完整 Kotlin wrapper 文件 | Generate complete Kotlin wrapper file
pub fn kotlin_wrapper_file(package_name : String, class_name : String, lib_name : String) -> String {
  kotlin_file_header(package_name) + kotlin_class_skeleton(class_name, lib_name) + "\n"
}


///|
/// JniBindingConfig 实现 Named trait | JniBindingConfig implements Named
pub impl @trait.Named for JniBindingConfig with name(self) {
  self.class_name
}
pub extend JniBindingConfig with @trait.Named::{name}