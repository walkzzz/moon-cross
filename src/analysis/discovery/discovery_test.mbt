test "discovery: analyze source with pub fn" {
  let analysis = @discovery.analyze_source("pub fn hello() -> String { \"world\" }")
  assert_true(analysis.has_pub_fn)
  assert_false(analysis.has_pub_struct)
}

test "discovery: analyze source with struct" {
  let analysis = @discovery.analyze_source("pub(all) struct MyType { x : Int }")
  assert_true(analysis.has_pub_struct)
  assert_false(analysis.has_pub_fn)
}

test "discovery: analyze source with enum" {
  let analysis = @discovery.analyze_source("pub(all) enum Color { Red }")
  assert_true(analysis.has_pub_enum)
}

test "discovery: analyze source with extern" {
  let analysis = @discovery.analyze_source("extern \"c\" fn native_call() -> Int")
  assert_true(analysis.has_extern)
}

test "discovery: analyze source with derive" {
  let analysis = @discovery.analyze_source("struct Foo { } derive(Debug, Eq)")
  assert_true(analysis.has_derive)
}

test "discovery: discover from names" {
  let result = @discovery.discover_from_names(["func_a", "func_b"], ["TypeA"])
  assert_eq(result.found_functions.length(), 2)
  assert_eq(result.found_types.length(), 1)
  assert_true(result.config_generated)
}

test "discovery: detect platforms all available" {
  let detections = [
    @discovery.make_detection(@core.Platform::Windows, true, Some("C:/"), None),
    @discovery.make_detection(@core.Platform::Ios, true, Some("/xcode"), None),
  ]
  let available = @discovery.detect_platforms(detections)
  assert_eq(available.length(), 2)
}

test "discovery: detect platforms none available" {
  let detections = [
    @discovery.make_detection(@core.Platform::Windows, false, None, None),
  ]
  let available = @discovery.detect_platforms(detections)
  assert_eq(available.length(), 5)
}

test "discovery: smart defaults empty" {
  let defaults = @discovery.smart_defaults([])
  assert_eq(defaults.length(), 5)
}

test "discovery: smart defaults non-empty" {
  let defaults = @discovery.smart_defaults([@core.Platform::Windows])
  assert_eq(defaults.length(), 1)
}

test "discovery: auto generate config" {
  let result = @discovery.auto_generate_config(["func_a"], ["TypeA"], @core.all_platforms())
  assert_true(result.config_generated)
  assert_eq(result.detected_platforms.length(), 5)
}

test "discovery: count export functions" {
  let sources = [
    "pub fn func_a() -> Int { 0 }",
    "pub fn func_b() -> Int { 0 }",
    "let x = 0",
  ]
  assert_eq(@discovery.count_export_functions(sources), 2)
}

test "discovery: count export types" {
  let sources = [
    "pub(all) struct TypeA { }",
    "pub(all) enum TypeB { A }",
    "let x = 0",
  ]
  assert_eq(@discovery.count_export_types(sources), 2)
}

test "discovery: needs ffi" {
  let sources = ["extern \"c\" fn native() -> Int"]
  assert_true(@discovery.needs_ffi(sources))
}

test "discovery: no ffi needed" {
  let sources = ["pub fn pure_func() -> Int { 0 }"]
  assert_false(@discovery.needs_ffi(sources))
}

test "discovery: empty discovery" {
  let result = @discovery.empty_discovery()
  assert_eq(result.found_functions.length(), 0)
  assert_false(result.config_generated)
}

test "discovery: merge results" {
  let r1 = @discovery.discover_from_names(["func_a"], [])
  let r2 = @discovery.discover_from_names(["func_b"], ["TypeB"])
  let merged = @discovery.merge_discovery([r1, r2])
  assert_eq(merged.found_functions.length(), 2)
  assert_eq(merged.found_types.length(), 1)
}

test "discovery: version" {
  assert_true(@discovery.discovery_version().contains("v0.1.2"))
}