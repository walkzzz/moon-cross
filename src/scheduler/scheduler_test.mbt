test "scheduler_create" {
  let s = @scheduler.scheduler_create()
  assert_eq(@scheduler.scheduler_total_count(s), 0)
  assert_eq(@scheduler.scheduler_current_time(s), 0)
}

test "scheduler_schedule" {
  let s = @scheduler.scheduler_create()
  let (s1, task) = @scheduler.scheduler_schedule(s, "task1", 5, 1)
  assert_eq(@scheduler.scheduler_total_count(s1), 1)
  assert_eq(task.name, "task1")
  assert_eq(task.delay, 5)
  assert_false(task.executed)
}

test "scheduler_schedule_multiple" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 1, 1)
  let (s2, _) = @scheduler.scheduler_schedule(s1, "b", 2, 2)
  let (s3, _) = @scheduler.scheduler_schedule(s2, "c", 3, 3)
  assert_eq(@scheduler.scheduler_total_count(s3), 3)
}

test "scheduler_advance" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "task", 5, 1)
  let s2 = @scheduler.scheduler_advance(s1, 3)
  assert_eq(@scheduler.scheduler_current_time(s2), 3)
  assert_eq(@scheduler.scheduler_pending_count(s2), 1)
}

test "scheduler_advance_execute" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "task", 5, 1)
  let s2 = @scheduler.scheduler_advance(s1, 5)
  assert_eq(@scheduler.scheduler_executed_count(s2), 1)
  assert_eq(@scheduler.scheduler_pending_count(s2), 0)
}

test "scheduler_advance_partial" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 3, 1)
  let (s2, _) = @scheduler.scheduler_schedule(s1, "b", 7, 1)
  let s3 = @scheduler.scheduler_advance(s2, 5)
  assert_eq(@scheduler.scheduler_executed_count(s3), 1)
  assert_eq(@scheduler.scheduler_pending_count(s3), 1)
}

test "scheduler_advance_all" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 3, 1)
  let (s2, _) = @scheduler.scheduler_schedule(s1, "b", 7, 1)
  let (s3, _) = @scheduler.scheduler_schedule(s2, "c", 10, 1)
  let s4 = @scheduler.scheduler_advance(s3, 15)
  assert_eq(@scheduler.scheduler_executed_count(s4), 3)
  assert_eq(@scheduler.scheduler_pending_count(s4), 0)
}

test "scheduler_pending_count" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 5, 1)
  let (s2, _) = @scheduler.scheduler_schedule(s1, "b", 10, 1)
  assert_eq(@scheduler.scheduler_pending_count(s2), 2)
}

test "scheduler_cancel" {
  let s = @scheduler.scheduler_create()
  let (s1, task) = @scheduler.scheduler_schedule(s, "task", 5, 1)
  let s2 = @scheduler.scheduler_cancel(s1, task.id)
  assert_eq(@scheduler.scheduler_total_count(s2), 0)
}

test "scheduler_cancel_not_found" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 5, 1)
  let s2 = @scheduler.scheduler_cancel(s1, 999)
  assert_eq(@scheduler.scheduler_total_count(s2), 1)
}

test "scheduler_executed_count" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 2, 1)
  let (s2, _) = @scheduler.scheduler_schedule(s1, "b", 5, 1)
  let s3 = @scheduler.scheduler_advance(s2, 3)
  assert_eq(@scheduler.scheduler_executed_count(s3), 1)
}

test "scheduler_advance_zero" {
  let s = @scheduler.scheduler_create()
  let (s1, _) = @scheduler.scheduler_schedule(s, "a", 5, 1)
  let s2 = @scheduler.scheduler_advance(s1, 0)
  assert_eq(@scheduler.scheduler_pending_count(s2), 1)
  assert_eq(@scheduler.scheduler_executed_count(s2), 0)
}

test "scheduler_version" {
  let v = @scheduler.scheduler_version()
  assert_true(v.contains("scheduler"))
}