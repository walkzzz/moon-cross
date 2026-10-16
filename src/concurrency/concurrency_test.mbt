test "mutex_create" {
  let m = @concurrency.mutex_create()
  assert_false(m.locked)
}

test "mutex_lock_unlock" {
  let m = @concurrency.mutex_create()
  let locked = @concurrency.mutex_lock(m, "thread1")
  assert_true(locked is Some(_))
  match locked {
    Some(l) => {
      let unlocked = @concurrency.mutex_unlock(l)
      assert_false(unlocked.locked)
    }
    None => assert_true(false)
  }
}

test "mutex_double_lock" {
  let m = @concurrency.mutex_create()
  let locked1 = @concurrency.mutex_lock(m, "thread1")
  match locked1 {
    Some(l) => {
      let locked2 = @concurrency.mutex_lock(l, "thread2")
      assert_true(locked2 is None)
    }
    None => assert_true(false)
  }
}

test "mutex_try_lock" {
  let m = @concurrency.mutex_create()
  let locked = @concurrency.mutex_try_lock(m, "owner")
  assert_true(locked.locked)
  let locked2 = @concurrency.mutex_try_lock(locked, "other")
  assert_eq(locked2.owner, "owner")
}

test "semaphore_create" {
  let sem = @concurrency.semaphore_create(3)
  assert_eq(sem.count, 3)
  assert_eq(sem.max, 3)
}

test "semaphore_acquire" {
  let sem = @concurrency.semaphore_create(2)
  let acquired = @concurrency.semaphore_acquire(sem)
  assert_true(acquired is Some(_))
  match acquired {
    Some(s) => assert_eq(s.count, 1)
    None => assert_true(false)
  }
}

test "semaphore_acquire_exhausted" {
  let sem = @concurrency.semaphore_create(1)
  let a1 = @concurrency.semaphore_acquire(sem)
  match a1 {
    Some(s) => {
      let a2 = @concurrency.semaphore_acquire(s)
      assert_true(a2 is None)
    }
    None => assert_true(false)
  }
}

test "semaphore_release" {
  let sem = @concurrency.semaphore_create(2)
  let a = @concurrency.semaphore_acquire(sem)
  match a {
    Some(s) => {
      let released = @concurrency.semaphore_release(s)
      assert_eq(released.count, 2)
    }
    None => assert_true(false)
  }
}

test "channel_create" {
  let ch = @concurrency.channel_create(3)
  assert_eq(ch.capacity, 3)
  assert_false(ch.closed)
}

test "channel_send_receive" {
  let ch = @concurrency.channel_create(3)
  let sent = @concurrency.channel_send(ch, "hello")
  assert_true(sent is Some(_))
  match sent {
    Some(s) => {
      let (_, val) = @concurrency.channel_receive(s)
      match val {
        Some(v) => assert_eq(v, "hello")
        None => assert_true(false)
      }
    }
    None => assert_true(false)
  }
}

test "channel_full" {
  let ch = @concurrency.channel_create(1)
  let sent1 = @concurrency.channel_send(ch, "a")
  match sent1 {
    Some(s) => {
      let sent2 = @concurrency.channel_send(s, "b")
      assert_true(sent2 is None)
    }
    None => assert_true(false)
  }
}

test "channel_close" {
  let ch = @concurrency.channel_create(3)
  let closed = @concurrency.channel_close(ch)
  assert_true(closed.closed)
  let sent = @concurrency.channel_send(closed, "x")
  assert_true(sent is None)
}

test "channel_receive_empty" {
  let ch = @concurrency.channel_create(3)
  let (_, val) = @concurrency.channel_receive(ch)
  assert_true(val is None)
}

test "future_create" {
  let f = @concurrency.future_create()
  assert_false(@concurrency.future_is_complete(f))
}

test "future_complete" {
  let f = @concurrency.future_create()
  let completed = @concurrency.future_complete(f, "result")
  assert_true(@concurrency.future_is_complete(completed))
  let val = @concurrency.future_get(completed)
  match val {
    Some(v) => assert_eq(v, "result")
    None => assert_true(false)
  }
}

test "future_get_incomplete" {
  let f = @concurrency.future_create()
  let val = @concurrency.future_get(f)
  assert_true(val is None)
}

test "atomic_create" {
  let ac = @concurrency.atomic_create()
  assert_eq(@concurrency.atomic_get(ac), 0)
}

test "atomic_increment" {
  let ac = @concurrency.atomic_create()
  let ac1 = @concurrency.atomic_increment(ac)
  assert_eq(@concurrency.atomic_get(ac1), 1)
  let ac2 = @concurrency.atomic_increment(ac1)
  assert_eq(@concurrency.atomic_get(ac2), 2)
}

test "atomic_decrement" {
  let ac = @concurrency.atomic_create()
  let ac1 = @concurrency.atomic_decrement(ac)
  assert_eq(@concurrency.atomic_get(ac1), -1)
}

test "atomic_add" {
  let ac = @concurrency.atomic_create()
  let ac1 = @concurrency.atomic_add(ac, 10)
  assert_eq(@concurrency.atomic_get(ac1), 10)
}

test "atomic_set" {
  let ac = @concurrency.atomic_create()
  let ac1 = @concurrency.atomic_set(ac, 42)
  assert_eq(@concurrency.atomic_get(ac1), 42)
}

test "task_queue_create" {
  let tq = @concurrency.task_queue_create()
  assert_true(@concurrency.task_queue_is_empty(tq))
}

test "task_enqueue_dequeue" {
  let tq = @concurrency.task_queue_create()
  let tq1 = @concurrency.task_enqueue(tq, "task1", 1)
  assert_eq(@concurrency.task_queue_size(tq1), 1)
  let (tq2, task) = @concurrency.task_dequeue(tq1)
  match task {
    Some(t) => assert_eq(t.name, "task1")
    None => assert_true(false)
  }
  assert_true(@concurrency.task_queue_is_empty(tq2))
}

test "task_priority_order" {
  let tq = @concurrency.task_queue_create()
  let tq1 = @concurrency.task_enqueue(tq, "low", 1)
  let tq2 = @concurrency.task_enqueue(tq1, "high", 10)
  let tq3 = @concurrency.task_enqueue(tq2, "medium", 5)
  let (_, task) = @concurrency.task_dequeue(tq3)
  match task {
    Some(t) => assert_eq(t.name, "high")
    None => assert_true(false)
  }
}

test "task_dequeue_empty" {
  let tq = @concurrency.task_queue_create()
  let (_, task) = @concurrency.task_dequeue(tq)
  assert_true(task is None)
}

test "concurrency_version" {
  let v = @concurrency.concurrency_version()
  assert_true(v.contains("concurrency"))
}