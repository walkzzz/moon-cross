///|
/// 集成测试：codegen 生成 → compilation_verify 验证 | Integration: codegen → compilation_verify
test "codegen_to_verify_full_pipeline" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let project = @codegen.generate_example_project(funcs, "mylib")
  assert_true(project.length() >= 10)
  let plan = @e2e.default_verification_plan("mylib")
  let script = @e2e.generate_verification_script(plan)
  assert_true(script.contains("mylib"))
  assert_true(script.contains("Generate"))
  assert_true(script.contains("Compile"))
  assert_true(script.contains("Load"))
  assert_true(script.contains("Call"))
  assert_true(script.contains("Verify"))
  let results : Array[@e2e.VerificationResult] = [
    @e2e.verify_passed(
      "Generate",
      "Generated " + project.length().to_string() + " files",
    ),
    @e2e.verify_passed("Compile", "C adapter compiled successfully"),
    @e2e.verify_passed("Load", "Shared library loaded"),
    @e2e.verify_passed("Call", "add(1, 2) = 3"),
    @e2e.verify_passed("Verify", "Result verified"),
  ]
  assert_true(@e2e.all_passed(results))
}

///|
/// 集成测试：验证生成的 C adapter 包含真实 marshalling | Verify generated C adapter has real marshalling
test "codegen_c_adapter_has_real_marshalling" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let c_adapter = @codegen.generate_c_adapter(funcs, "mylib")
  assert_true(c_adapter.content.contains("ensure_moonbit_init"))
  assert_true(c_adapter.content.contains("moonbit_init"))
  assert_true(c_adapter.content.contains("moonbit_string_from_cstr"))
  assert_true(c_adapter.content.contains("moonbit_string_to_cstr"))
  assert_true(c_adapter.content.contains("moonbit_gc_release"))
  assert_false(c_adapter.content.contains("placeholder"))
  assert_false(c_adapter.content.contains("TODO"))
}

///|
/// 集成测试：验证生成的 MoonBit 源代码可编译 | Verify generated MoonBit source is compilable
test "codegen_moonbit_source_is_valid" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
    { name: "greet", params: [("name", "String")], return_type: "String", },
  ]
  let source = @codegen.generate_moonbit_source(funcs, "mylib")
  assert_true(source.content.contains("pub fn add"))
  assert_true(source.content.contains("pub fn greet"))
  assert_true(source.content.contains("a + b"))
  assert_true(source.content.contains("Hello"))
  assert_true(source.content.contains("-> Int"))
  assert_true(source.content.contains("-> String"))
}

///|
/// 集成测试：验证构建脚本生成 | Verify build script generation
test "codegen_build_script_integration" {
  let cfg = @platform.default_build_config("mylib")
  let script = @platform.generate_build_script(cfg)
  assert_true(script.contains("#!/bin/bash"))
  assert_true(script.contains("mylib"))
  assert_true(script.contains("linux"))
  assert_true(script.contains("android"))
  assert_true(script.contains("ios"))
  assert_true(script.contains("windows"))
  assert_true(script.contains("ohos"))
  let plan = @platform.generate_compile_plan(cfg)
  assert_true(plan.length() > 0)
  let bat_script = @platform.generate_bat_script(cfg)
  assert_true(bat_script.contains("@echo off"))
  assert_true(bat_script.contains("mylib"))
}

///|
/// 集成测试：验证报告生成 | Verify verification report generation
test "verification_report_generation" {
  let results : Array[@e2e.VerificationResult] = [
    @e2e.verify_passed("Generate", "OK"),
    @e2e.verify_passed("Compile", "OK"),
    @e2e.verify_failed("Load", "Library not found"),
    @e2e.verify_passed("Call", "OK"),
  ]
  let report = @e2e.generate_verification_report(results)
  assert_true(report.contains("Total steps: 4"))
  assert_true(report.contains("Passed: 3"))
  assert_true(report.contains("Failed: 1"))
  assert_false(@e2e.all_passed(results))
}

///|
/// 集成测试：完整项目结构验证 | Complete project structure verification
test "example_project_structure_complete" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let project = @codegen.generate_example_project(funcs, "testlib")
  let filenames = []
  for file in project {
    filenames.push(file.filename)
  }
  let required_files = [
    "moon.mod.json", "moon.pkg.json", "lib.mbt", "testlib_adapter.c", "Makefile",
    "README.md", "CMakeLists.txt",
  ]
  for required in required_files {
    let mut found = false
    for f in filenames {
      if f == required {
        found = true
      }
    }
    assert_true(found)
  }
}

///|
/// 集成测试：codegen 到 verification plan 桥接 | codegen to verification plan bridge
test "codegen_to_verification_plan_bridge" {
  let funcs : Array[@codegen.ExportFunction] = [
    { name: "add", params: [("a", "Int"), ("b", "Int")], return_type: "Int", },
  ]
  let project = @codegen.generate_example_project(funcs, "bridgelib")
  let plan = @e2e.plan_from_codegen("bridgelib", project)
  assert_eq(plan.module_name, "bridgelib")
  assert_true(plan.steps.length() == 5)
  assert_true(plan.artifacts.length() == project.length())
}

///|
/// 集成测试：build config 到 verification plan 桥接 | build config to verification plan bridge
test "build_config_to_verification_plan_bridge" {
  let cfg = @platform.default_build_config("cfglib")
  let plan = @e2e.plan_from_build_config(cfg)
  assert_eq(plan.module_name, "cfglib")
  assert_true(plan.steps.length() > 5)
}
