test "make_state" {
  let s = @state.make_state("idle")
  assert_eq(s.name, "idle")
  assert_false(s.is_initial)
  assert_false(s.is_final)
}

test "make_initial_state" {
  let s = @state.make_initial_state("start")
  assert_true(s.is_initial)
  assert_false(s.is_final)
}

test "make_final_state" {
  let s = @state.make_final_state("end")
  assert_false(s.is_initial)
  assert_true(s.is_final)
}

test "make_transition" {
  let t = @state.make_transition("a", "b", "go")
  assert_eq(t.from_state, "a")
  assert_eq(t.to_state, "b")
  assert_eq(t.event, "go")
}

test "create_state_machine" {
  let sm = @state.create_state_machine()
  assert_false(@state.sm_is_started(sm))
  assert_eq(@state.sm_current_state(sm), "")
}

test "sm_add_state" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_state("idle"))
  assert_true(@state.sm_state_exists(sm1, "idle"))
}

test "sm_add_transition" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_transition(sm, @state.make_transition("a", "b", "go"))
  let ts = @state.sm_transitions(sm1)
  assert_eq(ts.length(), 1)
}

test "sm_start" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("start"))
  let sm2 = @state.sm_add_state(sm1, @state.make_state("running"))
  let sm3 = @state.sm_start(sm2)
  assert_true(@state.sm_is_started(sm3))
  assert_eq(@state.sm_current_state(sm3), "start")
}

test "sm_trigger" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_state(sm1, @state.make_state("running"))
  let sm3 = @state.sm_add_transition(sm2, @state.make_transition("idle", "running", "start"))
  let sm4 = @state.sm_start(sm3)
  let sm5 = @state.sm_trigger(sm4, "start")
  assert_eq(@state.sm_current_state(sm5), "running")
}

test "sm_trigger_invalid_event" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_start(sm1)
  let sm3 = @state.sm_trigger(sm2, "nonexistent")
  assert_eq(@state.sm_current_state(sm3), "idle")
}

test "sm_trigger_not_started" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_state(sm1, @state.make_state("running"))
  let sm3 = @state.sm_add_transition(sm2, @state.make_transition("idle", "running", "start"))
  let sm4 = @state.sm_trigger(sm3, "start")
  assert_eq(@state.sm_current_state(sm4), "")
}

test "sm_can_transition" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_transition(sm1, @state.make_transition("idle", "running", "start"))
  let sm3 = @state.sm_start(sm2)
  assert_true(@state.sm_can_transition(sm3, "start"))
  assert_false(@state.sm_can_transition(sm3, "stop"))
}

test "sm_is_final" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_state(sm1, @state.make_final_state("done"))
  let sm3 = @state.sm_add_transition(sm2, @state.make_transition("idle", "done", "finish"))
  let sm4 = @state.sm_start(sm3)
  let sm5 = @state.sm_trigger(sm4, "finish")
  assert_true(@state.sm_is_final(sm5))
}

test "sm_is_final_false" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_start(sm1)
  assert_false(@state.sm_is_final(sm2))
}

test "sm_reset" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_state(sm1, @state.make_state("running"))
  let sm3 = @state.sm_add_transition(sm2, @state.make_transition("idle", "running", "start"))
  let sm4 = @state.sm_start(sm3)
  let sm5 = @state.sm_trigger(sm4, "start")
  let sm6 = @state.sm_reset(sm5)
  assert_eq(@state.sm_current_state(sm6), "idle")
}

test "sm_state_exists" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_state("idle"))
  assert_true(@state.sm_state_exists(sm1, "idle"))
  assert_false(@state.sm_state_exists(sm1, "running"))
}

test "sm_get_state" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_final_state("done"))
  let result = @state.sm_get_state(sm1, "done")
  assert_true(result is Some(_))
  let s = match result {
    Some(x) => x
    None => @state.make_state("")
  }
  assert_true(s.is_final)
}

test "sm_get_state_not_found" {
  let sm = @state.create_state_machine()
  let result = @state.sm_get_state(sm, "nonexistent")
  assert_true(result is None)
}

test "sm_valid_events" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_transition(sm1, @state.make_transition("idle", "running", "start"))
  let sm3 = @state.sm_add_transition(sm2, @state.make_transition("idle", "stopped", "stop"))
  let sm4 = @state.sm_start(sm3)
  let events = @state.sm_valid_events(sm4)
  assert_eq(events.length(), 2)
}

test "sm_state_names" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_state("a"))
  let sm2 = @state.sm_add_state(sm1, @state.make_state("b"))
  let sm3 = @state.sm_add_state(sm2, @state.make_state("c"))
  let names = @state.sm_state_names(sm3)
  assert_eq(names.length(), 3)
}

test "sm_history" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_state(sm1, @state.make_state("running"))
  let sm3 = @state.sm_add_state(sm2, @state.make_final_state("done"))
  let sm4 = @state.sm_add_transition(sm3, @state.make_transition("idle", "running", "start"))
  let sm5 = @state.sm_add_transition(sm4, @state.make_transition("running", "done", "finish"))
  let sm6 = @state.sm_start(sm5)
  let sm7 = @state.sm_trigger(sm6, "start")
  let sm8 = @state.sm_trigger(sm7, "finish")
  let hist = @state.sm_history(sm8)
  assert_eq(hist.length(), 3)
  assert_eq(hist[0], "idle")
  assert_eq(hist[1], "running")
  assert_eq(hist[2], "done")
}

test "sm_stats" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_add_transition(sm1, @state.make_transition("idle", "running", "start"))
  let sm3 = @state.sm_start(sm2)
  let sm4 = @state.sm_trigger(sm3, "start")
  let s = @state.sm_stats(sm4)
  assert_eq(s.transitions_count, 1)
  assert_eq(s.states_visited_count, 2)
}

test "sm_history_length" {
  let sm = @state.create_state_machine()
  let sm1 = @state.sm_add_state(sm, @state.make_initial_state("idle"))
  let sm2 = @state.sm_start(sm1)
  assert_eq(@state.sm_history_length(sm2), 1)
}

test "merge_state_machines" {
  let sm1 = @state.create_state_machine()
  let sm1a = @state.sm_add_state(sm1, @state.make_state("a"))
  let sm2 = @state.create_state_machine()
  let sm2a = @state.sm_add_state(sm2, @state.make_state("b"))
  let merged = @state.merge_state_machines(sm1a, sm2a)
  let names = @state.sm_state_names(merged)
  assert_eq(names.length(), 2)
}

test "sm_version" {
  let v = @state.sm_version()
  assert_true(v.contains("state"))
}