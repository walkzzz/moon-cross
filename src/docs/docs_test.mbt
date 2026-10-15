test "docs: default config" {
  let config = @docs.default_doc_config()
  assert_eq(config.format, @docs.DocFormat::Markdown)
  assert_eq(config.output_dir, "docs/api")
  assert_false(config.include_private)
  assert_true(config.include_examples)
}

test "docs: make doc entry" {
  let entry = @docs.make_doc_entry(
    "my_func",
    "fn my_func(int) -> int",
    "A test function",
    ["my_func(42)"],
    [@core.Platform::Windows],
  )
  assert_eq(entry.name, "my_func")
  assert_eq(entry.examples.length(), 1)
  assert_eq(entry.platform_support.length(), 1)
}

test "docs: make doc section" {
  let entry = @docs.make_doc_entry("func1", "fn func1() -> int", "desc", [], [])
  let section = @docs.make_doc_section("Core API", "Core functions", [entry])
  assert_eq(section.title, "Core API")
  assert_eq(section.entries.length(), 1)
}

test "docs: generate markdown" {
  let entry = @docs.make_doc_entry(
    "my_func",
    "fn my_func() -> int",
    "A function",
    [],
    [@core.Platform::Windows, @core.Platform::Ios],
  )
  let section = @docs.make_doc_section("API", "Functions", [entry])
  let markdown = @docs.generate_markdown([section])
  assert_true(markdown.contains("Moon Cross API"))
  assert_true(markdown.contains("my_func"))
  assert_true(markdown.contains("Windows"))
  assert_true(markdown.contains("iOS"))
}

test "docs: generate markdown with examples" {
  let entry = @docs.make_doc_entry(
    "my_func",
    "fn my_func() -> int",
    "A function",
    ["my_func()"],
    [],
  )
  let section = @docs.make_doc_section("API", "", [entry])
  let markdown = @docs.generate_markdown([section])
  assert_true(markdown.contains("Examples"))
  assert_true(markdown.contains("my_func()"))
}

test "docs: generate json" {
  let entry = @docs.make_doc_entry("func1", "fn func1() -> int", "", [], [])
  let section = @docs.make_doc_section("API", "", [entry])
  let json = @docs.generate_json([section])
  assert_true(json.contains("sections"))
  assert_true(json.contains("func1"))
}

test "docs: doc format to string" {
  assert_eq(@docs.DocFormat::Markdown.to_string(), "markdown")
  assert_eq(@docs.DocFormat::Json.to_string(), "json")
  assert_eq(@docs.DocFormat::Html.to_string(), "html")
}

test "docs: version" {
  assert_true(@docs.docs_version().contains("v1.1.0"))
}