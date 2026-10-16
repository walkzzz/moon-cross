test "subject_create" {
  let s = @observer.subject_create()
  assert_eq(@observer.subject_observer_count(s), 0)
  assert_eq(s.state, "")
}

test "subject_attach" {
  let s = @observer.subject_create()
  let (s1, obs) = @observer.subject_attach(s, "observer1")
  assert_eq(@observer.subject_observer_count(s1), 1)
  assert_eq(obs.name, "observer1")
  assert_true(obs.active)
}

test "subject_attach_multiple" {
  let s = @observer.subject_create()
  let (s1, _) = @observer.subject_attach(s, "a")
  let (s2, _) = @observer.subject_attach(s1, "b")
  let (s3, _) = @observer.subject_attach(s2, "c")
  assert_eq(@observer.subject_observer_count(s3), 3)
}

test "subject_detach" {
  let s = @observer.subject_create()
  let (s1, obs) = @observer.subject_attach(s, "test")
  let s2 = @observer.subject_detach(s1, obs.id)
  assert_eq(@observer.subject_observer_count(s2), 0)
}

test "subject_detach_not_found" {
  let s = @observer.subject_create()
  let (s1, _) = @observer.subject_attach(s, "a")
  let s2 = @observer.subject_detach(s1, 999)
  assert_eq(@observer.subject_observer_count(s2), 1)
}

test "subject_set_active" {
  let s = @observer.subject_create()
  let (s1, obs) = @observer.subject_attach(s, "test")
  let s2 = @observer.subject_set_active(s1, obs.id, false)
  assert_eq(@observer.subject_active_count(s2), 0)
  let s3 = @observer.subject_set_active(s2, obs.id, true)
  assert_eq(@observer.subject_active_count(s3), 1)
}

test "subject_set_state" {
  let s = @observer.subject_create()
  let s1 = @observer.subject_set_state(s, "new_state")
  assert_eq(s1.state, "new_state")
}

test "subject_notify" {
  let s = @observer.subject_create()
  let (s1, _) = @observer.subject_attach(s, "a")
  let (s2, _) = @observer.subject_attach(s1, "b")
  let event = @observer.event_create("update", "data", 100)
  let notifications = @observer.subject_notify(s2, event)
  assert_eq(notifications.length(), 2)
}

test "subject_notify_inactive" {
  let s = @observer.subject_create()
  let (s1, obs) = @observer.subject_attach(s, "a")
  let s2 = @observer.subject_set_active(s1, obs.id, false)
  let event = @observer.event_create("update", "data", 100)
  let notifications = @observer.subject_notify(s2, event)
  assert_eq(notifications.length(), 0)
}

test "subject_notify_mixed" {
  let s = @observer.subject_create()
  let (s1, obs1) = @observer.subject_attach(s, "a")
  let (s2, _) = @observer.subject_attach(s1, "b")
  let s3 = @observer.subject_set_active(s2, obs1.id, false)
  let event = @observer.event_create("update", "data", 100)
  let notifications = @observer.subject_notify(s3, event)
  assert_eq(notifications.length(), 1)
}

test "subject_active_count" {
  let s = @observer.subject_create()
  let (s1, _) = @observer.subject_attach(s, "a")
  let (s2, _) = @observer.subject_attach(s1, "b")
  assert_eq(@observer.subject_active_count(s2), 2)
}

test "event_create" {
  let e = @observer.event_create("click", "button1", 12345)
  assert_eq(e.name, "click")
  assert_eq(e.data, "button1")
  assert_eq(e.timestamp, 12345)
}

test "observer_id_increment" {
  let s = @observer.subject_create()
  let (s1, obs1) = @observer.subject_attach(s, "a")
  let (_s2, obs2) = @observer.subject_attach(s1, "b")
  assert_true(obs2.id > obs1.id)
}

test "observer_version" {
  let v = @observer.observer_version()
  assert_true(v.contains("observer"))
}