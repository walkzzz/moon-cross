test "swift_version" {
  assert_eq(@swift.swift_version(), "moon-cross Swift interop v0.1.0")
}

test "swift_c_interop_declaration" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "MyModule", function_name: "myFunc" }
  let decl = @swift.swift_c_interop_declaration(cfg)
  assert_true(decl.contains("import MyModule"))
  assert_true(decl.contains("func myFunc"))
}

test "swift_c_interop_declaration_returns_data" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "M", function_name: "f" }
  let decl = @swift.swift_c_interop_declaration(cfg)
  assert_true(decl.contains("-> Data"))
}

test "generate_package_swift_contains_tools_version" {
  let pkg = @swift.generate_package_swift("MyLib")
  assert_true(pkg.contains("swift-tools-version:5.9"))
}

test "generate_package_swift_contains_name" {
  let pkg = @swift.generate_package_swift("MyLib")
  assert_true(pkg.contains("name: \"MyLib\""))
}

test "generate_package_swift_contains_package" {
  let pkg = @swift.generate_package_swift("MyLib")
  assert_true(pkg.contains("Package("))
}

test "generate_package_swift_contains_library" {
  let pkg = @swift.generate_package_swift("MyLib")
  assert_true(pkg.contains(".library"))
}

test "generate_package_swift_contains_target" {
  let pkg = @swift.generate_package_swift("MyLib")
  assert_true(pkg.contains(".target"))
}

test "generate_xcframework_info_contains_plist" {
  let info = @swift.generate_xcframework_info()
  assert_true(info.contains("<plist"))
}

test "generate_xcframework_info_contains_dict" {
  let info = @swift.generate_xcframework_info()
  assert_true(info.contains("<dict>"))
}

test "generate_xcframework_info_contains_available_libraries" {
  let info = @swift.generate_xcframework_info()
  assert_true(info.contains("AvailableLibraries"))
}

test "swift_import_declaration" {
  assert_eq(@swift.swift_import_declaration("MyModule"), "import MyModule")
}

test "swift_import_declaration_empty" {
  assert_eq(@swift.swift_import_declaration(""), "import ")
}

test "swift_wrapper_function_contains_public" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "M", function_name: "f" }
  let wrapper = @swift.swift_wrapper_function(cfg)
  assert_true(wrapper.contains("public func"))
}

test "swift_wrapper_function_contains_function_name" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "M", function_name: "myFunc" }
  let wrapper = @swift.swift_wrapper_function(cfg)
  assert_true(wrapper.contains("myFunc"))
}

test "swift_wrapper_function_returns_data" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "M", function_name: "f" }
  let wrapper = @swift.swift_wrapper_function(cfg)
  assert_true(wrapper.contains("-> Data"))
}

test "swift_wrapper_function_calls_module" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "MyMod", function_name: "f" }
  let wrapper = @swift.swift_wrapper_function(cfg)
  assert_true(wrapper.contains("MyMod.f"))
}

test "generate_modulemap_contains_module" {
  let mmap = @swift.generate_modulemap("MyModule")
  assert_true(mmap.contains("module MyModule"))
}

test "generate_modulemap_contains_header" {
  let mmap = @swift.generate_modulemap("MyModule")
  assert_true(mmap.contains("header \"MyModule.h\""))
}

test "generate_modulemap_contains_export" {
  let mmap = @swift.generate_modulemap("MyModule")
  assert_true(mmap.contains("export *"))
}

test "xcframework_create_command_contains_xcodebuild" {
  let cmd = @swift.xcframework_create_command("fw.framework", "out.xcframework")
  assert_true(cmd.contains("xcodebuild"))
}

test "xcframework_create_command_contains_create" {
  let cmd = @swift.xcframework_create_command("fw.framework", "out.xcframework")
  assert_true(cmd.contains("-create-xcframework"))
}

test "xcframework_create_command_contains_framework" {
  let cmd = @swift.xcframework_create_command("fw.framework", "out.xcframework")
  assert_true(cmd.contains("-framework"))
}

test "xcframework_create_command_contains_output" {
  let cmd = @swift.xcframework_create_command("fw.framework", "out.xcframework")
  assert_true(cmd.contains("-output"))
}

test "swift_bridging_header" {
  assert_eq(@swift.swift_bridging_header("MyModule"), "#import \"MyModule.h\"\n")
}

test "swift_bridging_header_empty" {
  assert_eq(@swift.swift_bridging_header(""), "#import \".h\"\n")
}

test "swift_binding_config_construction" {
  let cfg : @swift.SwiftBindingConfig = { module_name: "Mod", function_name: "fn" }
  assert_eq(cfg.module_name, "Mod")
  assert_eq(cfg.function_name, "fn")
}