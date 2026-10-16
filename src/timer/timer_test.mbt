test "timer_type_name" {
  assert_eq(@timer.timer_type_name(@timer.TimerType::OneShot), "ONESHOT")
  assert_eq(@timer.timer_type_name(@timer.TimerType::Periodic), "PERIODIC")
}

test "default_timer_config" {
  let cfg = @timer.default_timer_config()
  assert_eq(cfg.interval_ms, 1000)
  assert_eq(cfg.timer_type, @timer.TimerType::Periodic)
  assert_true(cfg.auto_start)
}

test "create_timer_manager" {
  let mgr = @timer.create_timer_manager()
  assert_eq(@timer.timer_count(mgr), 0)
  assert_eq(@timer.timer_active_count(mgr), 0)
}

test "timer_add" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  assert_eq(@timer.timer_count(mgr1), 1)
  assert_true(@timer.timer_has(mgr1, 1))
}

test "timer_add_auto_start" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: true }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  assert_eq(@timer.timer_active_count(mgr1), 1)
}

test "timer_add_no_auto_start" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: false }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  assert_eq(@timer.timer_active_count(mgr1), 0)
}

test "timer_remove" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_remove(mgr1, 1)
  assert_eq(@timer.timer_count(mgr2), 0)
  assert_false(@timer.timer_has(mgr2, 1))
}

test "timer_start" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: false }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_start(mgr1, 1)
  assert_eq(@timer.timer_active_count(mgr2), 1)
}

test "timer_stop" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_stop(mgr1, 1)
  assert_eq(@timer.timer_active_count(mgr2), 0)
}

test "timer_fire_periodic" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_fire(mgr1, 1, 2000)
  assert_eq(@timer.timer_fire_count(mgr2, 1), 1)
  assert_eq(@timer.timer_active_count(mgr2), 1)
}

test "timer_fire_oneshot" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::OneShot, auto_start: true }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_fire(mgr1, 1, 2000)
  assert_eq(@timer.timer_fire_count(mgr2, 1), 1)
  assert_eq(@timer.timer_active_count(mgr2), 0)
}

test "timer_fire_multiple" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_fire(mgr1, 1, 2000)
  let mgr3 = @timer.timer_fire(mgr2, 1, 3000)
  assert_eq(@timer.timer_fire_count(mgr3, 1), 2)
}

test "timer_fire_inactive" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: false }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_fire(mgr1, 1, 2000)
  assert_eq(@timer.timer_fire_count(mgr2, 1), 0)
}

test "timer_reset" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_fire(mgr1, 1, 2000)
  let mgr3 = @timer.timer_reset(mgr2, 1)
  assert_eq(@timer.timer_fire_count(mgr3, 1), 0)
}

test "timer_get" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let result = @timer.timer_get(mgr1, 1)
  assert_true(result is Some(_))
}

test "timer_get_not_found" {
  let mgr = @timer.create_timer_manager()
  let result = @timer.timer_get(mgr, 999)
  assert_true(result is None)
}

test "timer_should_fire_initial" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: true }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  assert_true(@timer.timer_should_fire(mgr1, 1, 1101))
  assert_false(@timer.timer_should_fire(mgr1, 1, 1050))
}

test "timer_should_fire_after_fire" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: true }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  let mgr2 = @timer.timer_fire(mgr1, 1, 1100)
  assert_false(@timer.timer_should_fire(mgr2, 1, 1150))
  assert_true(@timer.timer_should_fire(mgr2, 1, 1201))
}

test "timer_should_fire_inactive" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.TimerConfig::{ interval_ms: 100, timer_type: @timer.TimerType::Periodic, auto_start: false }
  let mgr1 = @timer.timer_add(mgr, 1, "t1", cfg, 1000)
  assert_false(@timer.timer_should_fire(mgr1, 1, 2000))
}

test "timer_stats" {
  let mgr = @timer.create_timer_manager()
  let s = @timer.timer_stats(mgr)
  assert_eq(s.total_created, 0)
  assert_eq(s.total_fired, 0)
}

test "timer_names" {
  let mgr = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let mgr1 = @timer.timer_add(mgr, 1, "a", cfg, 1000)
  let mgr2 = @timer.timer_add(mgr1, 2, "b", cfg, 1000)
  let names = @timer.timer_names(mgr2)
  assert_eq(names.length(), 2)
}

test "merge_timer_managers" {
  let m1 = @timer.create_timer_manager()
  let m2 = @timer.create_timer_manager()
  let cfg = @timer.default_timer_config()
  let m1a = @timer.timer_add(m1, 1, "a", cfg, 1000)
  let m2a = @timer.timer_add(m2, 2, "b", cfg, 1000)
  let merged = @timer.merge_timer_managers(m1a, m2a)
  assert_eq(@timer.timer_count(merged), 2)
}

test "timer_version" {
  let v = @timer.timer_version()
  assert_true(v.contains("timer"))
}