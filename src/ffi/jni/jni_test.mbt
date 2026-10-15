test "jni_version" {
  assert_eq(jni_version(), "moon-cross JNI v0.1.0")
}

test "jni_function_name" {
  let cfg : JniBindingConfig = {
    java_package: "com_example",
    class_name: "MyClass",
    function_name: "decode",
  }
  assert_eq(jni_function_name(cfg), "Java_com_example_MyClass_decode")
}

test "jni_function_name_simple" {
  let cfg : JniBindingConfig = {
    java_package: "pkg",
    class_name: "Cls",
    function_name: "fn",
  }
  assert_eq(jni_function_name(cfg), "Java_pkg_Cls_fn")
}

test "jni_c_declaration" {
  let cfg : JniBindingConfig = {
    java_package: "com_example",
    class_name: "MyClass",
    function_name: "decode",
  }
  let decl = jni_c_declaration(cfg)
  assert_true(decl.contains("JNIEXPORT"))
}

test "jni_c_declaration_contains_function_name" {
  let cfg : JniBindingConfig = {
    java_package: "com_example",
    class_name: "MyClass",
    function_name: "decode",
  }
  let decl = jni_c_declaration(cfg)
  assert_true(decl.contains("Java_com_example_MyClass_decode"))
}

test "jni_c_declaration_contains_env" {
  let cfg : JniBindingConfig = {
    java_package: "pkg",
    class_name: "Cls",
    function_name: "fn",
  }
  let decl = jni_c_declaration(cfg)
  assert_true(decl.contains("JNIEnv"))
}

test "kotlin_external_fun" {
  let cfg : JniBindingConfig = {
    java_package: "com_example",
    class_name: "MyClass",
    function_name: "decode",
  }
  assert_eq(kotlin_external_fun(cfg), "external fun decode(): ByteArray")
}

test "kotlin_external_fun_different_name" {
  let cfg : JniBindingConfig = {
    java_package: "pkg",
    class_name: "Cls",
    function_name: "encode",
  }
  assert_eq(kotlin_external_fun(cfg), "external fun encode(): ByteArray")
}

test "kotlin_library_load" {
  assert_eq(
    kotlin_library_load("mylib"),
    "companion object { init { System.loadLibrary(\"mylib\") } }",
  )
}

test "kotlin_library_load_different" {
  assert_eq(
    kotlin_library_load("otherlib"),
    "companion object { init { System.loadLibrary(\"otherlib\") } }",
  )
}

test "system_load_library" {
  assert_eq(system_load_library("mylib"), "System.loadLibrary(\"mylib\")")
}

test "system_load_library_different" {
  assert_eq(
    system_load_library("otherlib"),
    "System.loadLibrary(\"otherlib\")",
  )
}

test "gradle_android_block" {
  let block = gradle_android_block()
  assert_true(block.contains("android"))
  assert_true(block.contains("jniLibs"))
}

test "gradle_android_block_contains_source" {
  let block = gradle_android_block()
  assert_true(block.contains("sourceSets"))
}

test "cmake_skeleton" {
  let cmake = cmake_skeleton("mylib")
  assert_true(cmake.contains("cmake_minimum_required"))
  assert_true(cmake.contains("add_library"))
}

test "cmake_skeleton_contains_project" {
  let cmake = cmake_skeleton("mylib")
  assert_true(cmake.contains("project(mylib)"))
}

test "cmake_skeleton_different_lib" {
  let cmake = cmake_skeleton("otherlib")
  assert_true(cmake.contains("project(otherlib)"))
}

test "kotlin_class_skeleton" {
  let cls = kotlin_class_skeleton("MyClass", "mylib")
  assert_true(cls.contains("class MyClass"))
  assert_true(cls.contains("System.loadLibrary"))
}

test "jni_method_registration" {
  let cfg : JniBindingConfig = {
    java_package: "com_example",
    class_name: "MyClass",
    function_name: "decode",
  }
  let reg = jni_method_registration(cfg)
  assert_true(reg.contains("decode"))
  assert_true(reg.contains("Java_com_example_MyClass_decode"))
}

test "gradle_dependencies" {
  let deps = gradle_dependencies()
  assert_true(deps.contains("dependencies"))
}

test "cmake_add_library" {
  assert_eq(cmake_add_library("mylib"), "add_library(mylib SHARED src/main.c)")
}

test "cmake_add_library_different" {
  assert_eq(
    cmake_add_library("otherlib"),
    "add_library(otherlib SHARED src/main.c)",
  )
}

test "cmake_link_libraries" {
  assert_eq(cmake_link_libraries("mylib"), "target_link_libraries(mylib log)")
}

test "cmake_link_libraries_different" {
  assert_eq(
    cmake_link_libraries("otherlib"),
    "target_link_libraries(otherlib log)",
  )
}

test "cmake_full" {
  let cmake = cmake_full("mylib")
  assert_true(cmake.contains("cmake_minimum_required"))
  assert_true(cmake.contains("target_link_libraries"))
}

test "jni_header_includes" {
  let headers = jni_header_includes()
  assert_true(headers.contains("#include <jni.h>"))
  assert_true(headers.contains("moonbit.h"))
}

test "jni_header_includes_contains_stdint" {
  let headers = jni_header_includes()
  assert_true(headers.contains("#include <stdint.h>"))
}

test "kotlin_file_header" {
  assert_eq(kotlin_file_header("com.example"), "package com.example\n\n")
}

test "kotlin_wrapper_file" {
  let file = kotlin_wrapper_file("com.example", "MyClass", "mylib")
  assert_true(file.contains("package com.example"))
  assert_true(file.contains("class MyClass"))
}

test "kotlin_wrapper_file_contains_load" {
  let file = kotlin_wrapper_file("com.example", "MyClass", "mylib")
  assert_true(file.contains("System.loadLibrary"))
}

test "jni_binding_config_construction" {
  let cfg : JniBindingConfig = {
    java_package: "test",
    class_name: "Test",
    function_name: "fn",
  }
  assert_eq(cfg.java_package, "test")
  assert_eq(cfg.class_name, "Test")
  assert_eq(cfg.function_name, "fn")
}