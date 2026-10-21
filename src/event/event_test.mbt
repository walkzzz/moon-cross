test "priority_value" {
  assert_eq(@event.priority_value(@event.EventPriority::Low), 0)
  assert_eq(@event.priority_value(@event.EventPriority::Normal), 1)
  assert_eq(@event.priority_value(@event.EventPriority::High), 2)
  assert_eq(@event.priority_value(@event.EventPriority::Critical), 3)
}

test "priority_name" {
  assert_eq(@event.priority_name(@event.EventPriority::Low), "LOW")
  assert_eq(@event.priority_name(@event.EventPriority::Normal), "NORMAL")
  assert_eq(@event.priority_name(@event.EventPriority::High), "HIGH")
  assert_eq(@event.priority_name(@event.EventPriority::Critical), "CRITICAL")
}

test "priority_from_value" {
  assert_eq(@event.priority_from_value(0), @event.EventPriority::Low)
  assert_eq(@event.priority_from_value(1), @event.EventPriority::Normal)
  assert_eq(@event.priority_from_value(2), @event.EventPriority::High)
  assert_eq(@event.priority_from_value(3), @event.EventPriority::Critical)
  assert_eq(@event.priority_from_value(5), @event.EventPriority::Critical)
}

test "make_event" {
  let e = @event.make_event("click", "data", 1000)
  assert_eq(e.name, "click")
  assert_eq(e.data, "data")
  assert_eq(e.timestamp, 1000)
  assert_eq(e.priority, @event.EventPriority::Normal)
}

test "make_event_with_source" {
  let e = @event.make_event_with_source("click", "data", 1000, "button1")
  assert_eq(e.source, "button1")
}

test "make_event_with_priority" {
  let e = @event.make_event_with_priority("alert", "data", 1000, @event.EventPriority::Critical)
  assert_eq(e.priority, @event.EventPriority::Critical)
}

test "create_event_bus" {
  let bus = @event.create_event_bus()
  assert_eq(@event.event_handler_count(bus), 0)
  assert_eq(@event.event_history_count(bus), 0)
}

test "event_subscribe" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "handler1", @event.EventPriority::Normal)
  assert_eq(@event.event_handler_count(bus1), 1)
  assert_true(@event.event_has_handler(bus1, "click"))
}

test "event_subscribe_multiple" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let bus2 = @event.event_subscribe(bus1, 2, "click", "h2", @event.EventPriority::High)
  let bus3 = @event.event_subscribe(bus2, 3, "scroll", "h3", @event.EventPriority::Low)
  assert_eq(@event.event_handler_count(bus3), 3)
}

test "event_unsubscribe" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let bus2 = @event.event_subscribe(bus1, 2, "click", "h2", @event.EventPriority::High)
  let bus3 = @event.event_unsubscribe(bus2, 1)
  assert_eq(@event.event_handler_count(bus3), 1)
  assert_true(@event.event_has_handler(bus3, "click"))
}

test "event_unsubscribe_nonexistent" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let bus2 = @event.event_unsubscribe(bus1, 999)
  assert_eq(@event.event_handler_count(bus2), 1)
}

test "event_publish" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let e = @event.make_event("click", "data", 1000)
  let bus2 = @event.event_publish(bus1, e)
  assert_eq(@event.event_history_count(bus2), 1)
  let s = @event.event_stats(bus2)
  assert_eq(s.total_published, 1)
  assert_eq(s.total_dispatched, 1)
}

test "event_publish_no_handlers" {
  let bus = @event.create_event_bus()
  let e = @event.make_event("click", "data", 1000)
  let bus1 = @event.event_publish(bus, e)
  let s = @event.event_stats(bus1)
  assert_eq(s.total_dispatched, 0)
}

test "event_batch_publish" {
  let bus = @event.create_event_bus()
  let events = [
    @event.make_event("a", "1", 1000),
    @event.make_event("b", "2", 2000),
    @event.make_event("c", "3", 3000),
  ]
  let bus1 = @event.event_batch_publish(bus, events)
  assert_eq(@event.event_history_count(bus1), 3)
}

test "event_filter_by_name" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_publish(bus, @event.make_event("click", "1", 1000))
  let bus2 = @event.event_publish(bus1, @event.make_event("scroll", "2", 2000))
  let bus3 = @event.event_publish(bus2, @event.make_event("click", "3", 3000))
  let filtered = @event.event_filter_by_name(bus3, "click")
  assert_eq(filtered.length(), 2)
}

test "event_filter_by_priority" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_publish(bus, @event.make_event_with_priority("a", "1", 1000, @event.EventPriority::High))
  let bus2 = @event.event_publish(bus1, @event.make_event_with_priority("b", "2", 2000, @event.EventPriority::Low))
  let bus3 = @event.event_publish(bus2, @event.make_event_with_priority("c", "3", 3000, @event.EventPriority::High))
  let filtered = @event.event_filter_by_priority(bus3, @event.EventPriority::High)
  assert_eq(filtered.length(), 2)
}

test "event_filter_by_source" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_publish(bus, @event.make_event_with_source("a", "1", 1000, "src1"))
  let bus2 = @event.event_publish(bus1, @event.make_event_with_source("b", "2", 2000, "src2"))
  let bus3 = @event.event_publish(bus2, @event.make_event_with_source("c", "3", 3000, "src1"))
  let filtered = @event.event_filter_by_source(bus3, "src1")
  assert_eq(filtered.length(), 2)
}

test "event_clear_history" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_publish(bus, @event.make_event("a", "1", 1000))
  let bus2 = @event.event_clear_history(bus1)
  assert_eq(@event.event_history_count(bus2), 0)
}

test "event_active_handler_count" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let bus2 = @event.event_subscribe(bus1, 2, "click", "h2", @event.EventPriority::Normal)
  let bus3 = @event.event_disable_handler(bus2, 1)
  assert_eq(@event.event_active_handler_count(bus3), 1)
}

test "event_disable_enable_handler" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let bus2 = @event.event_disable_handler(bus1, 1)
  assert_false(@event.event_has_handler(bus2, "click"))
  let bus3 = @event.event_enable_handler(bus2, 1)
  assert_true(@event.event_has_handler(bus3, "click"))
}

test "event_handlers_for" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_subscribe(bus, 1, "click", "h1", @event.EventPriority::Normal)
  let bus2 = @event.event_subscribe(bus1, 2, "scroll", "h2", @event.EventPriority::Normal)
  let bus3 = @event.event_subscribe(bus2, 3, "click", "h3", @event.EventPriority::High)
  let handlers = @event.event_handlers_for(bus3, "click")
  assert_eq(handlers.length(), 2)
}

test "event_stats" {
  let bus = @event.create_event_bus()
  let s = @event.event_stats(bus)
  assert_eq(s.total_published, 0)
  assert_eq(s.total_handlers, 0)
  assert_eq(s.total_dispatched, 0)
}

test "event_history" {
  let bus = @event.create_event_bus()
  let bus1 = @event.event_publish(bus, @event.make_event("a", "1", 1000))
  let bus2 = @event.event_publish(bus1, @event.make_event("b", "2", 2000))
  let hist = @event.event_history(bus2)
  assert_eq(hist.length(), 2)
  assert_eq(hist[0].name, "a")
  assert_eq(hist[1].name, "b")
}

test "merge_event_buses" {
  let b1 = @event.create_event_bus()
  let b2 = @event.create_event_bus()
  let b1a = @event.event_subscribe(b1, 1, "click", "h1", @event.EventPriority::Normal)
  let b2a = @event.event_subscribe(b2, 2, "scroll", "h2", @event.EventPriority::Normal)
  let merged = @event.merge_event_buses(b1a, b2a)
  assert_eq(@event.event_handler_count(merged), 2)
}

test "event_version" {
  let v = @event.event_version()
  assert_true(v.contains("event"))
}

