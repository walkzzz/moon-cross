test "empty_context" {
  let ctx = @template.empty_context()
  assert_eq(@template.context_size(ctx), 0)
}

test "context_set_and_get" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "name", "world")
  let val = @template.context_get(ctx1, "name")
  let v = match val {
    Some(s) => s
    None => ""
  }
  assert_eq(v, "world")
}

test "context_set_overwrite" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "key", "val1")
  let ctx2 = @template.context_set(ctx1, "key", "val2")
  let val = @template.context_get(ctx2, "key")
  let v = match val {
    Some(s) => s
    None => ""
  }
  assert_eq(v, "val2")
}

test "context_has" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "name", "value")
  assert_true(@template.context_has(ctx1, "name"))
  assert_false(@template.context_has(ctx1, "missing"))
}

test "context_get_not_found" {
  let ctx = @template.empty_context()
  assert_true(@template.context_get(ctx, "missing") is None)
}

test "context_remove" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "a", "1")
  let ctx2 = @template.context_set(ctx1, "b", "2")
  let ctx3 = @template.context_remove(ctx2, "a")
  assert_false(@template.context_has(ctx3, "a"))
  assert_true(@template.context_has(ctx3, "b"))
}

test "context_size" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "a", "1")
  let ctx2 = @template.context_set(ctx1, "b", "2")
  assert_eq(@template.context_size(ctx2), 2)
}

test "parse_template" {
  let t = @template.parse_template("Hello {{name}}!")
  assert_eq(t.source, "Hello {{name}}!")
}

test "render_simple_variable" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "name", "world")
  let result = @template.template_render("Hello {{name}}!", ctx1)
  assert_eq(result, "Hello world!")
}

test "render_multiple_variables" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "first", "John")
  let ctx2 = @template.context_set(ctx1, "last", "Doe")
  let result = @template.template_render("{{first}} {{last}}", ctx2)
  assert_eq(result, "John Doe")
}

test "render_no_variables" {
  let ctx = @template.empty_context()
  let result = @template.template_render("plain text", ctx)
  assert_eq(result, "plain text")
}

test "render_missing_variable" {
  let ctx = @template.empty_context()
  let result = @template.template_render("Hello {{name}}!", ctx)
  assert_eq(result, "Hello !")
}

test "render_if_block_true" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "show", "yes")
  let result = @template.template_render("{{#if show}}visible{{/if}}", ctx1)
  assert_eq(result, "visible")
}

test "render_if_block_false" {
  let ctx = @template.empty_context()
  let result = @template.template_render("{{#if show}}visible{{/if}}", ctx)
  assert_eq(result, "")
}

test "render_if_block_empty" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "show", "")
  let result = @template.template_render("{{#if show}}visible{{/if}}", ctx1)
  assert_eq(result, "")
}

test "render_if_with_text" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "name", "world")
  let result = @template.template_render("Hello {{#if name}}{{name}}{{/if}}!", ctx1)
  assert_eq(result, "Hello world!")
}

test "render_unless_block_true" {
  let ctx = @template.empty_context()
  let result = @template.template_render("{{#unless show}}hidden{{/unless}}", ctx)
  assert_eq(result, "hidden")
}

test "render_unless_block_false" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "show", "yes")
  let result = @template.template_render("{{#unless show}}hidden{{/unless}}", ctx1)
  assert_eq(result, "")
}

test "render_each_block" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "items", "a,b,c")
  let result = @template.template_render("{{#each items}}[{{this}}]{{/each}}", ctx1)
  assert_eq(result, "[a][b][c]")
}

test "render_each_single" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "items", "only")
  let result = @template.template_render("{{#each items}}{{this}}{{/each}}", ctx1)
  assert_eq(result, "only")
}

test "render_each_empty" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "items", "")
  let result = @template.template_render("{{#each items}}{{this}}{{/each}}", ctx1)
  assert_eq(result, "")
}

test "render_each_missing" {
  let ctx = @template.empty_context()
  let result = @template.template_render("{{#each items}}{{this}}{{/each}}", ctx)
  assert_eq(result, "")
}

test "render_template_object" {
  let t = @template.parse_template("Hello {{name}}!")
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "name", "world")
  let result = @template.render_template(t, ctx1)
  assert_eq(result, "Hello world!")
}

test "render_complex" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "title", "Welcome")
  let ctx2 = @template.context_set(ctx1, "user", "John")
  let ctx3 = @template.context_set(ctx2, "items", "x,y")
  let result = @template.template_render("{{title}} {{user}}! Items: {{#each items}}{{this}} {{/each}}", ctx3)
  assert_true(result.contains("Welcome John!"))
  assert_true(result.contains("x"))
  assert_true(result.contains("y"))
}

test "render_nested_if" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "a", "1")
  let ctx2 = @template.context_set(ctx1, "b", "2")
  let result = @template.template_render("{{#if a}}A{{#if b}}B{{/if}}{{/if}}", ctx2)
  assert_eq(result, "AB")
}

test "render_with_spaces" {
  let ctx = @template.empty_context()
  let ctx1 = @template.context_set(ctx, "name", "world")
  let result = @template.template_render("Hello {{ name }}!", ctx1)
  assert_eq(result, "Hello world!")
}

test "template_version" {
  let v = @template.template_version()
  assert_true(v.contains("template"))
}