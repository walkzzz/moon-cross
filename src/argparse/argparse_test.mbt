test "arg_type_name" {
  assert_eq(@argparse.arg_type_name(@argparse.ArgType::String), "STRING")
  assert_eq(@argparse.arg_type_name(@argparse.ArgType::Int), "INT")
  assert_eq(@argparse.arg_type_name(@argparse.ArgType::Bool), "BOOL")
  assert_eq(@argparse.arg_type_name(@argparse.ArgType::Flag), "FLAG")
}

test "create_parser" {
  let p = @argparse.create_parser("myapp", "A test app")
  assert_eq(@argparse.arg_count(p), 0)
  assert_eq(@argparse.subcommand_count(p), 0)
}

test "add_arg" {
  let p = @argparse.create_parser("myapp", "test")
  let arg = @argparse.make_string_arg("input", "i", "input", true, "Input file")
  let p1 = @argparse.add_arg(p, arg)
  assert_eq(@argparse.arg_count(p1), 1)
  assert_true(@argparse.has_arg(p1, "input"))
}

test "add_subcommand" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_subcommand(p, "build")
  let p2 = @argparse.add_subcommand(p1, "run")
  assert_eq(@argparse.subcommand_count(p2), 2)
}

test "make_flag" {
  let f = @argparse.make_flag("verbose", "v", "verbose", "Verbose output")
  assert_eq(f.typ, @argparse.ArgType::Flag)
  assert_false(f.required)
  assert_eq(f.default_value, "false")
}

test "make_string_arg" {
  let a = @argparse.make_string_arg("name", "n", "name", true, "Name")
  assert_eq(a.typ, @argparse.ArgType::String)
  assert_true(a.required)
}

test "make_int_arg" {
  let a = @argparse.make_int_arg("count", "c", "count", false, "Count")
  assert_eq(a.typ, @argparse.ArgType::Int)
  assert_false(a.required)
  assert_eq(a.default_value, "0")
}

test "parse_long_option" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_string_arg("input", "i", "input", false, "Input"))
  let result = @argparse.parse_args(p1, ["--input", "file.txt"])
  assert_true(@argparse.parse_success(result))
  assert_eq(@argparse.get_value_or(result, "input", ""), "file.txt")
}

test "parse_short_option" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_string_arg("input", "i", "input", false, "Input"))
  let result = @argparse.parse_args(p1, ["-i", "file.txt"])
  assert_true(@argparse.parse_success(result))
  assert_eq(@argparse.get_value_or(result, "input", ""), "file.txt")
}

test "parse_flag" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_flag("verbose", "v", "verbose", "Verbose"))
  let result = @argparse.parse_args(p1, ["--verbose"])
  assert_true(@argparse.parse_success(result))
  assert_true(@argparse.has_flag(result, "verbose"))
}

test "parse_flag_not_set" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_flag("verbose", "v", "verbose", "Verbose"))
  let result = @argparse.parse_args(p1, [])
  assert_true(@argparse.parse_success(result))
  assert_false(@argparse.has_flag(result, "verbose"))
}

test "parse_positional" {
  let p = @argparse.create_parser("myapp", "test")
  let result = @argparse.parse_args(p, ["file1.txt", "file2.txt"])
  assert_eq(@argparse.positional_count(result), 2)
}

test "parse_mixed" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_flag("verbose", "v", "verbose", "Verbose"))
  let p2 = @argparse.add_arg(p1, @argparse.make_string_arg("output", "o", "output", false, "Output"))
  let result = @argparse.parse_args(p2, ["--verbose", "-o", "out.txt", "input.txt"])
  assert_true(@argparse.parse_success(result))
  assert_true(@argparse.has_flag(result, "verbose"))
  assert_eq(@argparse.get_value_or(result, "output", ""), "out.txt")
  assert_eq(@argparse.positional_count(result), 1)
}

test "parse_missing_required" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_string_arg("input", "i", "input", true, "Input"))
  let result = @argparse.parse_args(p1, [])
  assert_false(@argparse.parse_success(result))
  assert_eq(@argparse.error_count(result), 1)
}

test "parse_unknown_option" {
  let p = @argparse.create_parser("myapp", "test")
  let result = @argparse.parse_args(p, ["--unknown"])
  assert_false(@argparse.parse_success(result))
}

test "parse_missing_value" {
  let p = @argparse.create_parser("myapp", "test")
  let p1 = @argparse.add_arg(p, @argparse.make_string_arg("input", "i", "input", false, "Input"))
  let result = @argparse.parse_args(p1, ["--input"])
  assert_false(@argparse.parse_success(result))
}

test "get_value_not_found" {
  let p = @argparse.create_parser("myapp", "test")
  let result = @argparse.parse_args(p, [])
  assert_true(@argparse.get_value(result, "nonexistent") is None)
}

test "get_value_or_default" {
  let p = @argparse.create_parser("myapp", "test")
  let result = @argparse.parse_args(p, [])
  assert_eq(@argparse.get_value_or(result, "nonexistent", "default"), "default")
}

test "generate_help" {
  let p = @argparse.create_parser("myapp", "A test application")
  let p1 = @argparse.add_arg(p, @argparse.make_flag("verbose", "v", "verbose", "Verbose output"))
  let p2 = @argparse.add_arg(p1, @argparse.make_string_arg("input", "i", "input", true, "Input file"))
  let help = @argparse.generate_help(p2)
  assert_true(help.contains("Usage: myapp"))
  assert_true(help.contains("--verbose"))
  assert_true(help.contains("--input"))
}

test "generate_help_with_subcommands" {
  let p = @argparse.create_parser("myapp", "A test app")
  let p1 = @argparse.add_subcommand(p, "build")
  let p2 = @argparse.add_subcommand(p1, "run")
  let help = @argparse.generate_help(p2)
  assert_true(help.contains("SUBCOMMAND"))
  assert_true(help.contains("build"))
  assert_true(help.contains("run"))
}

test "merge_parsers" {
  let p1 = @argparse.create_parser("app", "test")
  let p1a = @argparse.add_arg(p1, @argparse.make_flag("verbose", "v", "verbose", "Verbose"))
  let p2 = @argparse.create_parser("app", "test")
  let p2a = @argparse.add_arg(p2, @argparse.make_string_arg("input", "i", "input", true, "Input"))
  let merged = @argparse.merge_parsers(p1a, p2a)
  assert_eq(@argparse.arg_count(merged), 2)
}

test "argparse_version" {
  let v = @argparse.argparse_version()
  assert_true(v.contains("argparse"))
}