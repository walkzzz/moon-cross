test "signal_type_name" {
  assert_eq(@signal.signal_type_name(@signal.SignalType::User), "USER")
  assert_eq(@signal.signal_type_name(@signal.SignalType::System), "SYSTEM")
  assert_eq(@signal.signal_type_name(@signal.SignalType::Interrupt), "INTERRUPT")
  assert_eq(@signal.signal_type_name(@signal.SignalType::Error), "ERROR")
  assert_eq(@signal.signal_type_name(@signal.SignalType::Custom), "CUSTOM")
}

test "make_signal" {
  let s = @signal.make_signal(1, "click", @signal.SignalType::User, "data", 1000)
  assert_eq(s.id, 1)
  assert_eq(s.name, "click")
  assert_eq(s.typ, @signal.SignalType::User)
  assert_eq(s.priority, 0)
}

test "make_signal_with_priority" {
  let s = @signal.make_signal_with_priority(1, "alert", @signal.SignalType::Error, "data", 1000, 5)
  assert_eq(s.priority, 5)
}

test "create_signal_manager" {
  let mgr = @signal.create_signal_manager()
  assert_eq(@signal.signal_handler_count(mgr), 0)
  assert_eq(@signal.signal_history_count(mgr), 0)
}

test "signal_register" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  assert_eq(@signal.signal_handler_count(mgr1), 1)
  assert_true(@signal.signal_has_handler(mgr1, "click"))
}

test "signal_register_multiple" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_register(mgr1, 2, "click", "h2", 1)
  let mgr3 = @signal.signal_register(mgr2, 3, "scroll", "h3", 0)
  assert_eq(@signal.signal_handler_count(mgr3), 3)
}

test "signal_unregister" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_register(mgr1, 2, "click", "h2", 1)
  let mgr3 = @signal.signal_unregister(mgr2, 1)
  assert_eq(@signal.signal_handler_count(mgr3), 1)
}

test "signal_unregister_nonexistent" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_unregister(mgr1, 999)
  assert_eq(@signal.signal_handler_count(mgr2), 1)
}

test "signal_send" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let s = @signal.make_signal(1, "click", @signal.SignalType::User, "data", 1000)
  let mgr2 = @signal.signal_send(mgr1, s)
  assert_eq(@signal.signal_history_count(mgr2), 1)
  let stats = @signal.signal_stats(mgr2)
  assert_eq(stats.total_sent, 1)
  assert_eq(stats.total_handled, 1)
}

test "signal_send_no_handlers" {
  let mgr = @signal.create_signal_manager()
  let s = @signal.make_signal(1, "click", @signal.SignalType::User, "data", 1000)
  let mgr1 = @signal.signal_send(mgr, s)
  let stats = @signal.signal_stats(mgr1)
  assert_eq(stats.total_handled, 0)
  assert_eq(stats.total_dropped, 1)
}

test "signal_send_multiple_handlers" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_register(mgr1, 2, "click", "h2", 1)
  let s = @signal.make_signal(1, "click", @signal.SignalType::User, "data", 1000)
  let mgr3 = @signal.signal_send(mgr2, s)
  let stats = @signal.signal_stats(mgr3)
  assert_eq(stats.total_handled, 2)
}

test "signal_batch_send" {
  let mgr = @signal.create_signal_manager()
  let signals = [
    @signal.make_signal(1, "a", @signal.SignalType::User, "1", 1000),
    @signal.make_signal(2, "b", @signal.SignalType::System, "2", 2000),
    @signal.make_signal(3, "c", @signal.SignalType::Custom, "3", 3000),
  ]
  let mgr1 = @signal.signal_batch_send(mgr, signals)
  assert_eq(@signal.signal_history_count(mgr1), 3)
}

test "signal_disable_enable_handler" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_disable_handler(mgr1, 1)
  assert_false(@signal.signal_has_handler(mgr2, "click"))
  let mgr3 = @signal.signal_enable_handler(mgr2, 1)
  assert_true(@signal.signal_has_handler(mgr3, "click"))
}

test "signal_active_handler_count" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "a", "h1", 0)
  let mgr2 = @signal.signal_register(mgr1, 2, "b", "h2", 0)
  let mgr3 = @signal.signal_disable_handler(mgr2, 1)
  assert_eq(@signal.signal_active_handler_count(mgr3), 1)
}

test "signal_filter_by_name" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_send(mgr, @signal.make_signal(1, "click", @signal.SignalType::User, "1", 1000))
  let mgr2 = @signal.signal_send(mgr1, @signal.make_signal(2, "scroll", @signal.SignalType::User, "2", 2000))
  let mgr3 = @signal.signal_send(mgr2, @signal.make_signal(3, "click", @signal.SignalType::User, "3", 3000))
  let filtered = @signal.signal_filter_by_name(mgr3, "click")
  assert_eq(filtered.length(), 2)
}

test "signal_filter_by_type" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_send(mgr, @signal.make_signal(1, "a", @signal.SignalType::User, "1", 1000))
  let mgr2 = @signal.signal_send(mgr1, @signal.make_signal(2, "b", @signal.SignalType::System, "2", 2000))
  let mgr3 = @signal.signal_send(mgr2, @signal.make_signal(3, "c", @signal.SignalType::User, "3", 3000))
  let filtered = @signal.signal_filter_by_type(mgr3, @signal.SignalType::User)
  assert_eq(filtered.length(), 2)
}

test "signal_clear_history" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_send(mgr, @signal.make_signal(1, "a", @signal.SignalType::User, "1", 1000))
  let mgr2 = @signal.signal_clear_history(mgr1)
  assert_eq(@signal.signal_history_count(mgr2), 0)
}

test "signal_stats" {
  let mgr = @signal.create_signal_manager()
  let s = @signal.signal_stats(mgr)
  assert_eq(s.total_sent, 0)
  assert_eq(s.total_handled, 0)
  assert_eq(s.total_dropped, 0)
  assert_eq(s.handler_count, 0)
}

test "signal_handler_call_count" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_send(mgr1, @signal.make_signal(1, "click", @signal.SignalType::User, "data", 1000))
  assert_eq(@signal.signal_handler_call_count(mgr2, 1), 1)
  let mgr3 = @signal.signal_send(mgr2, @signal.make_signal(2, "click", @signal.SignalType::User, "data", 2000))
  assert_eq(@signal.signal_handler_call_count(mgr3, 1), 2)
}

test "signal_handlers_for" {
  let mgr = @signal.create_signal_manager()
  let mgr1 = @signal.signal_register(mgr, 1, "click", "h1", 0)
  let mgr2 = @signal.signal_register(mgr1, 2, "scroll", "h2", 0)
  let mgr3 = @signal.signal_register(mgr2, 3, "click", "h3", 1)
  let handlers = @signal.signal_handlers_for(mgr3, "click")
  assert_eq(handlers.length(), 2)
}

test "merge_signal_managers" {
  let m1 = @signal.create_signal_manager()
  let m2 = @signal.create_signal_manager()
  let m1a = @signal.signal_register(m1, 1, "a", "h1", 0)
  let m2a = @signal.signal_register(m2, 2, "b", "h2", 0)
  let merged = @signal.merge_signal_managers(m1a, m2a)
  assert_eq(@signal.signal_handler_count(merged), 2)
}

test "signal_version" {
  let v = @signal.signal_version()
  assert_true(v.contains("signal"))
}
