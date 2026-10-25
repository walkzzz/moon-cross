test "contains_chinese" {

  assert_true(@pinyin_integration.is_chinese("你好"))
  assert_true(@pinyin_integration.is_chinese("世界"))
  assert_false(@pinyin_integration.is_chinese("hello"))
  assert_false(@pinyin_integration.is_chinese("123"))
}

test "convert_chinese basic" {
  let result = @pinyin_integration.convert_chinese("你好")
  assert_true(result.has_chinese)
  assert_eq(result.input, "你好")
}

test "convert_chinese non-chinese" {
  let result = @pinyin_integration.convert_chinese("hello")
  assert_false(result.has_chinese)
}

test "get_short_pinyin" {
  let result = @pinyin_integration.get_short_pinyin("你好")
  assert_true(result.length() > 0)
}

test "convert_with_tone" {
  let result = @pinyin_integration.convert_with_tone("你好")
  assert_true(result.length() > 0)
}

test "convert_without_tone" {
  let result = @pinyin_integration.convert_without_tone("你好")
  assert_true(result.length() > 0)
}

test "convert_chinese mixed" {
  let result = @pinyin_integration.convert_chinese("你好world")
  assert_true(result.has_chinese)
}

test "pinyin_integration_version" {
  assert_eq(@pinyin_integration.pinyin_integration_version(), "moon-cross pinyin_integration v0.3.26")
}
test "codegen: generate C adapter for pinyin" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_contains", params: [("input", "String")], return_type: "Bool" },
  ]
  let result = @codegen.generate_c_adapter(funcs, "pinyin")
  assert_eq(result.filename, "pinyin_adapter.c")
  assert_true(result.content.contains("MOONBIT_EXPORT"))
  assert_true(result.content.contains("pinyin_convert"))
  assert_true(result.content.contains("pinyin_short"))
  assert_true(result.content.contains("pinyin_contains"))
}

test "codegen: generate iOS Swift interop" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
  ]
  let result = @codegen.generate_swift_interop(funcs, "pinyin")
  assert_eq(result.platform, "ios")
  assert_eq(result.filename, "pinyin.swift")
  assert_true(result.content.contains("import Foundation"))
  assert_true(result.content.contains("func pinyin_convert"))
  assert_true(result.content.contains("func pinyin_short"))
}

test "codegen: generate Android JNI binding" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
  ]
  let result = @codegen.generate_jni_binding(funcs, "pinyin")
  assert_eq(result.platform, "android")
  assert_eq(result.filename, "Pinyin.kt")
  assert_true(result.content.contains("System.loadLibrary"))
  assert_true(result.content.contains("native"))
  assert_true(result.content.contains("pinyin_convert"))
}

test "codegen: generate Windows DllImport" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_contains", params: [("input", "String")], return_type: "Bool" },
  ]
  let result = @codegen.generate_dllimport(funcs, "pinyin")
  assert_eq(result.platform, "windows")
  assert_eq(result.filename, "Pinyin.cs")
  assert_true(result.content.contains("DllImport"))
  assert_true(result.content.contains("pinyin.dll"))
  assert_true(result.content.contains("pinyin_convert"))
}

test "codegen: generate HarmonyOS NAPI binding" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
  ]
  let result = @codegen.generate_napi_binding(funcs, "pinyin")
  assert_eq(result.platform, "ohos")
  assert_eq(result.filename, "pinyin.ts")
  assert_true(result.content.contains("import native"))
  assert_true(result.content.contains("pinyin_convert"))
}

test "codegen: generate Linux C header" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
  ]
  let result = @codegen.generate_linux_header(funcs, "pinyin")
  assert_eq(result.platform, "linux")
  assert_eq(result.filename, "pinyin.h")
  assert_true(result.content.contains("#ifndef PINYIN_H"))
  assert_true(result.content.contains("#define PINYIN_H"))
  assert_true(result.content.contains("pinyin_convert"))
}

test "codegen: generate all 5 platforms at once" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_contains", params: [("input", "String")], return_type: "Bool" },
  ]
  let results = @codegen.generate_all_platforms(funcs, "pinyin")
  assert_eq(results.length(), 5)
  assert_eq(results[0].platform, "ios")
  assert_eq(results[1].platform, "android")
  assert_eq(results[2].platform, "windows")
  assert_eq(results[3].platform, "ohos")
  assert_eq(results[4].platform, "linux")
  for r in results {
    assert_true(r.content.length() > 0)
    assert_true(r.filename.length() > 0)
  }
}

test "codegen: pinyin 1-to-5 platform code generation" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_contains", params: [("input", "String")], return_type: "Bool" },
  ]
  let c_adapter = @codegen.generate_c_adapter(funcs, "pinyin")
  let all_platforms = @codegen.generate_all_platforms(funcs, "pinyin")
  assert_true(c_adapter.content.contains("pinyin_convert"))
  assert_eq(all_platforms.length(), 5)
  let platforms = []
  for r in all_platforms {
    platforms.push(r.platform)
  }
  assert_eq(platforms.length(), 5)
  assert_true(platforms[0] == "ios")
  assert_true(platforms[1] == "android")
  assert_true(platforms[2] == "windows")
  assert_true(platforms[3] == "ohos")
  assert_true(platforms[4] == "linux")
}

test "codegen: generate Makefile" {
  let result = @codegen.generate_makefile("pinyin")
  assert_eq(result.filename, "Makefile")
  assert_true(result.content.contains("ios:"))
  assert_true(result.content.contains("android:"))
  assert_true(result.content.contains("windows:"))
  assert_true(result.content.contains("ohos:"))
  assert_true(result.content.contains("linux:"))
  assert_true(result.content.contains("clean:"))
}

test "codegen: generate GitHub Actions" {
  let result = @codegen.generate_github_actions("pinyin")
  assert_eq(result.filename, "build.yml")
  assert_true(result.content.contains("build-ios"))
  assert_true(result.content.contains("build-android"))
  assert_true(result.content.contains("build-windows"))
  assert_true(result.content.contains("build-ohos"))
  assert_true(result.content.contains("build-linux"))
}

test "codegen: generate Swift Package" {
  let result = @codegen.generate_swift_package("pinyin")
  assert_eq(result.filename, "Package.swift")
  assert_true(result.content.contains("PackageDescription"))
  assert_true(result.content.contains("Pinyin"))
}

test "codegen: generate Gradle config" {
  let result = @codegen.generate_gradle_config("pinyin")
  assert_eq(result.filename, "build.gradle.kts")
  assert_true(result.content.contains("com.android.library"))
  assert_true(result.content.contains("com.walkzzz.pinyin"))
}

test "codegen: generate OHOS build profile" {
  let result = @codegen.generate_ohos_build_profile("pinyin")
  assert_eq(result.filename, "build-profile.json5")
  assert_true(result.content.contains("pinyin"))
}

test "codegen: generate complete project" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_contains", params: [("input", "String")], return_type: "Bool" },
  ]
  let project = @codegen.generate_project(funcs, "pinyin")
  assert_true(project.length() >= 11)
  let filenames = []
  for f in project {
    filenames.push(f.filename)
  }
  assert_true(filenames.length() >= 11)
}

test "codegen: generate README" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
  ]
  let result = @codegen.generate_readme(funcs, "pinyin")
  assert_eq(result.filename, "README.md")
  assert_true(result.content.contains("Pinyin"))
  assert_true(result.content.contains("pinyin_convert"))
  assert_true(result.content.contains("pinyin_short"))
  assert_true(result.content.contains("iOS"))
  assert_true(result.content.contains("Android"))
  assert_true(result.content.contains("Windows"))
  assert_true(result.content.contains("HarmonyOS"))
  assert_true(result.content.contains("Linux"))
}

test "validate_input empty" {
  let r = @pinyin_integration.validate_input("")
  assert_false(r.valid)
  assert_eq(r.error_message, "input is empty")
}

test "validate_input too_long" {
  let mut long_str = "a"
  for _ in 0..<1001 {
    long_str = long_str + "a"
  }
  let r = @pinyin_integration.validate_input(long_str)
  assert_false(r.valid)
  assert_true(r.error_message.contains("too long"))
}

test "validate_input valid" {
  let r = @pinyin_integration.validate_input("hello")
  assert_true(r.valid)
}

test "convert_chinese empty_input" {
  let r = @pinyin_integration.convert_chinese("")
  assert_false(r.has_chinese)
  assert_eq(r.pinyin, "")
}

test "is_chinese empty" {
  assert_false(@pinyin_integration.is_chinese(""))
}

test "get_short_pinyin empty" {
  assert_eq(@pinyin_integration.get_short_pinyin(""), "")
}

test "convert_with_tone empty" {
  assert_eq(@pinyin_integration.convert_with_tone(""), [])
}

test "convert_without_tone empty" {
  assert_eq(@pinyin_integration.convert_without_tone(""), [])
}

test "pinyin_export_functions" {
  let funcs = @pinyin_integration.pinyin_export_functions()
  assert_eq(funcs.length(), 3)
  assert_eq(funcs[0].name, "pinyin_convert")
  assert_eq(funcs[1].name, "pinyin_short")
  assert_eq(funcs[2].name, "pinyin_contains")
}

test "codegen: generate CMake config" {
  let result = @codegen.generate_cmake("pinyin")
  assert_eq(result.filename, "CMakeLists.txt")
  assert_true(result.content.contains("cmake_minimum_required"))
  assert_true(result.content.contains("add_library"))
  assert_true(result.content.contains("pinyin"))
  assert_true(result.content.contains("ANDROID"))
}

test "codegen: check type dependencies" {
  let funcs = [
    @codegen.ExportFunction::{ name: "f1", params: [("x", "Int"), ("y", "String")], return_type: "Bool" },
  ]
  assert_true(@codegen.check_type_dependencies(funcs))
}

test "codegen: check type dependencies unsupported" {
  let funcs = [
    @codegen.ExportFunction::{ name: "f1", params: [("x", "MyCustomType")], return_type: "Int" },
  ]
  assert_false(@codegen.check_type_dependencies(funcs))
}

test "codegen: generate build plan" {
  let funcs = [
    @codegen.ExportFunction::{ name: "pinyin_convert", params: [("input", "String")], return_type: "String" },
    @codegen.ExportFunction::{ name: "pinyin_short", params: [("input", "String")], return_type: "String" },
  ]
  let result = @codegen.generate_build_plan(funcs, "pinyin")
  assert_eq(result.filename, "build_plan.md")
  assert_true(result.content.contains("pinyin_convert"))
  assert_true(result.content.contains("pinyin_short"))
  assert_true(result.content.contains("Build Steps"))
  assert_true(result.content.contains("iOS"))
  assert_true(result.content.contains("Android"))
}
