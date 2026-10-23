test "state_create" {
  let ctx = @state_pattern.state_create()
  assert_eq(@state_pattern.state_name(ctx.light), "red")
  assert_eq(@state_pattern.state_transitions_count(ctx), 0)
}

test "state_handle_red_to_green" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  assert_eq(@state_pattern.state_name(ctx2.light), "green")
}

test "state_handle_green_to_yellow" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  let ctx3 = @state_pattern.state_handle(ctx2)
  assert_eq(@state_pattern.state_name(ctx3.light), "yellow")
}

test "state_handle_yellow_to_red" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  let ctx3 = @state_pattern.state_handle(ctx2)
  let ctx4 = @state_pattern.state_handle(ctx3)
  assert_eq(@state_pattern.state_name(ctx4.light), "red")
}

test "state_name" {
  assert_eq(@state_pattern.state_name(@state_pattern.TrafficLight::Red), "red")
  assert_eq(@state_pattern.state_name(@state_pattern.TrafficLight::Green), "green")
  assert_eq(@state_pattern.state_name(@state_pattern.TrafficLight::Yellow), "yellow")
}

test "state_can_transition_valid" {
  assert_true(@state_pattern.state_can_transition(@state_pattern.TrafficLight::Red, @state_pattern.TrafficLight::Green))
  assert_true(@state_pattern.state_can_transition(@state_pattern.TrafficLight::Green, @state_pattern.TrafficLight::Yellow))
  assert_true(@state_pattern.state_can_transition(@state_pattern.TrafficLight::Yellow, @state_pattern.TrafficLight::Red))
}

test "state_can_transition_invalid" {
  assert_false(@state_pattern.state_can_transition(@state_pattern.TrafficLight::Red, @state_pattern.TrafficLight::Yellow))
  assert_false(@state_pattern.state_can_transition(@state_pattern.TrafficLight::Green, @state_pattern.TrafficLight::Red))
  assert_false(@state_pattern.state_can_transition(@state_pattern.TrafficLight::Yellow, @state_pattern.TrafficLight::Green))
}

test "state_reset" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  let ctx3 = @state_pattern.state_reset(ctx2)
  assert_eq(@state_pattern.state_name(ctx3.light), "red")
  assert_eq(@state_pattern.state_transitions_count(ctx3), 0)
}

test "state_transitions_count" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  let ctx3 = @state_pattern.state_handle(ctx2)
  assert_eq(@state_pattern.state_transitions_count(ctx3), 2)
}

test "state_is_valid" {
  assert_true(@state_pattern.state_is_valid(@state_pattern.TrafficLight::Red))
  assert_true(@state_pattern.state_is_valid(@state_pattern.TrafficLight::Green))
  assert_true(@state_pattern.state_is_valid(@state_pattern.TrafficLight::Yellow))
}

test "state_multiple_cycles" {
  let ctx = @state_pattern.state_create()
  let mut current = ctx
  for _ in 0..<6 {
    current = @state_pattern.state_handle(current)
  }
  assert_eq(@state_pattern.state_name(current.light), "red")
  assert_eq(@state_pattern.state_transitions_count(current), 6)
}

test "state_handle_increments_transitions" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  assert_eq(@state_pattern.state_transitions_count(ctx2), 1)
}

test "state_reset_clears_transitions" {
  let ctx = @state_pattern.state_create()
  let ctx2 = @state_pattern.state_handle(ctx)
  let ctx3 = @state_pattern.state_handle(ctx2)
  let ctx4 = @state_pattern.state_reset(ctx3)
  assert_eq(@state_pattern.state_transitions_count(ctx4), 0)
}

test "state_pattern_version" {
  let v = @state_pattern.state_pattern_version()
  assert_true(v.contains("state_pattern"))
}