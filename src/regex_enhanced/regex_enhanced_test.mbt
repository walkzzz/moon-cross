test "compile_pattern_simple" {
  let p = @regex_enhanced.compile_pattern("abc")
  assert_eq(p.pattern, "abc")
  assert_false(p.has_start_anchor)
  assert_false(p.has_end_anchor)
  assert_eq(p.core, "abc")
}

test "compile_pattern_start_anchor" {
  let p = @regex_enhanced.compile_pattern("^abc")
  assert_true(p.has_start_anchor)
  assert_eq(p.core, "abc")
}

test "compile_pattern_end_anchor" {
  let p = @regex_enhanced.compile_pattern("abc$")
  assert_true(p.has_end_anchor)
  assert_eq(p.core, "abc")
}

test "compile_pattern_both_anchors" {
  let p = @regex_enhanced.compile_pattern("^abc$")
  assert_true(p.has_start_anchor)
  assert_true(p.has_end_anchor)
  assert_eq(p.core, "abc")
}

test "regex_match_literal" {
  let p = @regex_enhanced.compile_pattern("abc")
  let m = @regex_enhanced.regex_match(p, "abc")
  assert_true(m is Some(_))
}

test "regex_match_literal_in_string" {
  let p = @regex_enhanced.compile_pattern("bc")
  let m = @regex_enhanced.regex_match(p, "abcd")
  assert_true(m is Some(_))
}

test "regex_match_no_match" {
  let p = @regex_enhanced.compile_pattern("xyz")
  let m = @regex_enhanced.regex_match(p, "abc")
  assert_true(m is None)
}

test "regex_match_dot" {
  let p = @regex_enhanced.compile_pattern("a.c")
  let m = @regex_enhanced.regex_match(p, "abc")
  assert_true(m is Some(_))
}

test "regex_match_dot_any" {
  let p = @regex_enhanced.compile_pattern("a.c")
  let m = @regex_enhanced.regex_match(p, "axc")
  assert_true(m is Some(_))
}

test "regex_match_star" {
  let p = @regex_enhanced.compile_pattern("a*")
  let m = @regex_enhanced.regex_match(p, "aaa")
  assert_true(m is Some(_))
}

test "regex_match_star_zero" {
  let p = @regex_enhanced.compile_pattern("a*b")
  let m = @regex_enhanced.regex_match(p, "b")
  assert_true(m is Some(_))
}

test "regex_match_start_anchor" {
  let p = @regex_enhanced.compile_pattern("^abc")
  let m1 = @regex_enhanced.regex_match(p, "abcdef")
  assert_true(m1 is Some(_))
  let m2 = @regex_enhanced.regex_match(p, "xabc")
  assert_true(m2 is None)
}

test "regex_match_end_anchor" {
  let p = @regex_enhanced.compile_pattern("abc$")
  let m1 = @regex_enhanced.regex_match(p, "xabc")
  assert_true(m1 is Some(_))
  let m2 = @regex_enhanced.regex_match(p, "abcd")
  assert_true(m2 is None)
}

test "regex_match_both_anchors" {
  let p = @regex_enhanced.compile_pattern("^abc$")
  let m1 = @regex_enhanced.regex_match(p, "abc")
  assert_true(m1 is Some(_))
  let m2 = @regex_enhanced.regex_match(p, "xabc")
  assert_true(m2 is None)
}

test "regex_find_all" {
  let p = @regex_enhanced.compile_pattern("a")
  let matches = @regex_enhanced.regex_find_all(p, "banana")
  assert_eq(matches.length(), 3)
}

test "regex_find_all_no_match" {
  let p = @regex_enhanced.compile_pattern("x")
  let matches = @regex_enhanced.regex_find_all(p, "abc")
  assert_eq(matches.length(), 0)
}

test "regex_replace" {
  let p = @regex_enhanced.compile_pattern("a")
  let result = @regex_enhanced.regex_replace(p, "banana", "X")
  assert_eq(result, "bXnXnX")
}

test "regex_replace_no_match" {
  let p = @regex_enhanced.compile_pattern("x")
  let result = @regex_enhanced.regex_replace(p, "abc", "Y")
  assert_eq(result, "abc")
}

test "regex_split" {
  let p = @regex_enhanced.compile_pattern(",")
  let parts = @regex_enhanced.regex_split(p, "a,b,c")
  assert_eq(parts.length(), 3)
  assert_eq(parts[0], "a")
  assert_eq(parts[1], "b")
  assert_eq(parts[2], "c")
}

test "regex_split_no_match" {
  let p = @regex_enhanced.compile_pattern(",")
  let parts = @regex_enhanced.regex_split(p, "abc")
  assert_eq(parts.length(), 1)
  assert_eq(parts[0], "abc")
}

test "regex_is_valid" {
  assert_true(@regex_enhanced.regex_is_valid("abc"))
  assert_false(@regex_enhanced.regex_is_valid(""))
}

test "simple_match" {
  assert_true(@regex_enhanced.simple_match("abc", "abc"))
  assert_true(@regex_enhanced.simple_match("a*c", "aaac"))
  assert_false(@regex_enhanced.simple_match("abc", "xyz"))
}

test "regex_match_result_fields" {
  let p = @regex_enhanced.compile_pattern("bc")
  let m = @regex_enhanced.regex_match(p, "abcd")
  match m {
    Some(r) => {
      assert_eq(r.matched, "bc")
      assert_eq(r.start, 1)
      assert_eq(r.end, 3)
    }
    None => assert_true(false)
  }
}

test "regex_version" {
  let v = @regex_enhanced.regex_version()
  assert_true(v.contains("regex"))
}