test "builder_create" {
  let b = @builder.builder_create("product1")
  assert_eq(b.name, "product1")
  assert_eq(@builder.builder_part_count(b), 0)
}

test "builder_add_part" {
  let b = @builder.builder_create("test")
  let b1 = @builder.builder_add_part(b, "part1")
  assert_eq(@builder.builder_part_count(b1), 1)
}

test "builder_add_multiple_parts" {
  let b = @builder.builder_create("test")
  let b1 = @builder.builder_add_part(b, "a")
  let b2 = @builder.builder_add_part(b1, "b")
  let b3 = @builder.builder_add_part(b2, "c")
  assert_eq(@builder.builder_part_count(b3), 3)
}

test "builder_add_tag" {
  let b = @builder.builder_create("test")
  let b1 = @builder.builder_add_tag(b, "important")
  assert_eq(@builder.builder_tag_count(b1), 1)
}

test "builder_add_multiple_tags" {
  let b = @builder.builder_create("test")
  let b1 = @builder.builder_add_tag(b, "a")
  let b2 = @builder.builder_add_tag(b1, "b")
  assert_eq(@builder.builder_tag_count(b2), 2)
}

test "builder_add_meta" {
  let b = @builder.builder_create("test")
  let b1 = @builder.builder_add_meta(b, "version", "1.0")
  let val = @builder.builder_get_meta(b1, "version")
  match val {
    Some(v) => assert_eq(v, "1.0")
    None => assert_true(false)
  }
}

test "builder_get_meta_not_found" {
  let b = @builder.builder_create("test")
  assert_true(@builder.builder_get_meta(b, "missing") is None)
}

test "builder_build" {
  let b = @builder.builder_create("product")
  let b1 = @builder.builder_add_part(b, "engine")
  let b2 = @builder.builder_add_part(b1, "wheels")
  let b3 = @builder.builder_add_tag(b2, "vehicle")
  let product = @builder.builder_build(b3)
  assert_eq(product.name, "product")
  assert_eq(@builder.product_part_count(product), 2)
  assert_eq(@builder.product_tag_count(product), 1)
}

test "builder_reset" {
  let b = @builder.builder_create("test")
  let b1 = @builder.builder_add_part(b, "part")
  let b2 = @builder.builder_add_tag(b1, "tag")
  let b3 = @builder.builder_reset(b2)
  assert_eq(@builder.builder_part_count(b3), 0)
  assert_eq(@builder.builder_tag_count(b3), 0)
}

test "builder_complex" {
  let b = @builder.builder_create("car")
  let b1 = @builder.builder_add_part(b, "engine")
  let b2 = @builder.builder_add_part(b1, "wheels")
  let b3 = @builder.builder_add_part(b2, "body")
  let b4 = @builder.builder_add_tag(b3, "vehicle")
  let b5 = @builder.builder_add_tag(b4, "fast")
  let b6 = @builder.builder_add_meta(b5, "color", "red")
  let b7 = @builder.builder_add_meta(b6, "speed", "200")
  let product = @builder.builder_build(b7)
  assert_eq(@builder.product_part_count(product), 3)
  assert_eq(@builder.product_tag_count(product), 2)
}

test "builder_preserves_name" {
  let b = @builder.builder_create("my_product")
  let b1 = @builder.builder_add_part(b, "part")
  let product = @builder.builder_build(b1)
  assert_eq(product.name, "my_product")
}

test "builder_reset_preserves_name" {
  let b = @builder.builder_create("keep_name")
  let b1 = @builder.builder_add_part(b, "part")
  let b2 = @builder.builder_reset(b1)
  assert_eq(b2.name, "keep_name")
}

test "builder_version" {
  let v = @builder.builder_version()
  assert_true(v.contains("builder"))
}