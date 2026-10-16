test "context_create" {
  let ctx = @strategy.context_create("reverse")
  assert_eq(ctx.strategy_name, "reverse")
  assert_eq(ctx.config, "")
}

test "context_set_config" {
  let ctx = @strategy.context_create("prefix")
  let ctx1 = @strategy.context_set_config(ctx, "pre_")
  assert_eq(ctx1.config, "pre_")
}

test "strategy_reverse" {
  let ctx = @strategy.context_create("reverse")
  let result = @strategy.context_execute(ctx, "hello")
  assert_true(result.success)
  assert_eq(result.output, "olleh")
}

test "strategy_upper" {
  let ctx = @strategy.context_create("upper")
  let result = @strategy.context_execute(ctx, "hello")
  assert_true(result.success)
  assert_eq(result.output, "HELLO")
}

test "strategy_trim" {
  let ctx = @strategy.context_create("trim")
  let result = @strategy.context_execute(ctx, "  hello  ")
  assert_true(result.success)
  assert_eq(result.output, "hello")
}

test "strategy_prefix" {
  let ctx = @strategy.context_create("prefix")
  let ctx1 = @strategy.context_set_config(ctx, "pre_")
  let result = @strategy.context_execute(ctx1, "data")
  assert_true(result.success)
  assert_eq(result.output, "pre_data")
}

test "strategy_unknown" {
  let ctx = @strategy.context_create("unknown")
  let result = @strategy.context_execute(ctx, "test")
  assert_false(result.success)
  assert_eq(result.output, "")
}

test "strategy_result_fields" {
  let ctx = @strategy.context_create("upper")
  let result = @strategy.context_execute(ctx, "abc")
  assert_eq(result.strategy_used, "upper")
  assert_eq(result.output, "ABC")
}

test "context_switch" {
  let ctx = @strategy.context_create("reverse")
  let ctx1 = @strategy.context_switch(ctx, "upper")
  assert_eq(ctx1.strategy_name, "upper")
  assert_eq(ctx1.config, "")
}

test "strategy_reverse_empty" {
  let ctx = @strategy.context_create("reverse")
  let result = @strategy.context_execute(ctx, "")
  assert_true(result.success)
  assert_eq(result.output, "")
}

test "strategy_upper_mixed" {
  let ctx = @strategy.context_create("upper")
  let result = @strategy.context_execute(ctx, "Hello123")
  assert_eq(result.output, "HELLO123")
}

test "strategy_trim_no_spaces" {
  let ctx = @strategy.context_create("trim")
  let result = @strategy.context_execute(ctx, "hello")
  assert_eq(result.output, "hello")
}

test "strategy_trim_all_spaces" {
  let ctx = @strategy.context_create("trim")
  let result = @strategy.context_execute(ctx, "   ")
  assert_eq(result.output, "")
}

test "strategy_version" {
  let v = @strategy.strategy_version()
  assert_true(v.contains("strategy"))
}