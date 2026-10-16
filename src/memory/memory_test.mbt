test "tracker_create" {
  let t = @memory.tracker_create()
  assert_eq(@memory.tracker_live_count(t), 0)
  assert_eq(@memory.tracker_live_bytes(t), 0)
  assert_false(@memory.tracker_has_leaks(t))
}

test "tracker_allocate" {
  let t = @memory.tracker_create()
  let (t1, block) = @memory.tracker_allocate(t, 100, "test")
  assert_eq(@memory.tracker_live_count(t1), 1)
  assert_eq(@memory.tracker_live_bytes(t1), 100)
  assert_eq(block.size, 100)
  assert_eq(block.tag, "test")
  assert_false(block.freed)
}

test "tracker_free" {
  let t = @memory.tracker_create()
  let (t1, block) = @memory.tracker_allocate(t, 50, "temp")
  let t2 = @memory.tracker_free(t1, block.id)
  assert_eq(@memory.tracker_live_count(t2), 0)
  assert_eq(@memory.tracker_live_bytes(t2), 0)
  assert_eq(t2.total_freed, 50)
}

test "tracker_multiple" {
  let t = @memory.tracker_create()
  let (t1, _) = @memory.tracker_allocate(t, 100, "a")
  let (t2, _) = @memory.tracker_allocate(t1, 200, "b")
  let (t3, _) = @memory.tracker_allocate(t2, 300, "c")
  assert_eq(@memory.tracker_live_count(t3), 3)
  assert_eq(@memory.tracker_live_bytes(t3), 600)
}

test "tracker_has_leaks" {
  let t = @memory.tracker_create()
  let (t1, _) = @memory.tracker_allocate(t, 100, "leak")
  assert_true(@memory.tracker_has_leaks(t1))
}

test "tracker_no_leaks" {
  let t = @memory.tracker_create()
  let (t1, block) = @memory.tracker_allocate(t, 100, "temp")
  let t2 = @memory.tracker_free(t1, block.id)
  assert_false(@memory.tracker_has_leaks(t2))
}

test "arena_create" {
  let a = @memory.arena_create("test_arena")
  assert_eq(a.name, "test_arena")
  assert_eq(@memory.arena_block_count(a), 0)
}

test "arena_alloc" {
  let a = @memory.arena_create("test")
  let (a1, block) = @memory.arena_alloc(a, 64, "data")
  assert_eq(@memory.arena_block_count(a1), 1)
  assert_eq(a1.total_size, 64)
  assert_eq(block.size, 64)
}

test "arena_multiple_alloc" {
  let a = @memory.arena_create("test")
  let (a1, _) = @memory.arena_alloc(a, 32, "x")
  let (a2, _) = @memory.arena_alloc(a1, 64, "y")
  assert_eq(@memory.arena_block_count(a2), 2)
  assert_eq(a2.total_size, 96)
}

test "arena_reset" {
  let a = @memory.arena_create("test")
  let (a1, _) = @memory.arena_alloc(a, 100, "temp")
  let a2 = @memory.arena_reset(a1)
  assert_eq(@memory.arena_block_count(a2), 0)
  assert_eq(a2.total_size, 0)
}

test "refcount_create" {
  let rc = @memory.refcount_create("value")
  assert_eq(rc.count, 1)
  assert_false(@memory.refcount_is_zero(rc))
}

test "refcount_increment" {
  let rc = @memory.refcount_create("value")
  let rc1 = @memory.refcount_increment(rc)
  assert_eq(rc1.count, 2)
}

test "refcount_decrement" {
  let rc = @memory.refcount_create("value")
  let rc1 = @memory.refcount_increment(rc)
  let rc2 = @memory.refcount_decrement(rc1)
  assert_eq(rc2.count, 1)
}

test "refcount_zero" {
  let rc = @memory.refcount_create("value")
  let rc1 = @memory.refcount_decrement(rc)
  assert_true(@memory.refcount_is_zero(rc1))
}

test "pool_create" {
  let p = @memory.pool_create(64, 10)
  assert_eq(p.block_size, 64)
  assert_eq(p.free_count, 10)
  assert_eq(p.allocated_count, 0)
}

test "pool_allocate" {
  let p = @memory.pool_create(64, 2)
  let allocated = @memory.pool_allocate(p)
  assert_true(allocated is Some(_))
  match allocated {
    Some(p1) => assert_eq(p1.allocated_count, 1)
    None => assert_true(false)
  }
}

test "pool_allocate_full" {
  let p = @memory.pool_create(64, 1)
  let a1 = @memory.pool_allocate(p)
  match a1 {
    Some(p1) => {
      let a2 = @memory.pool_allocate(p1)
      assert_true(a2 is None)
    }
    None => assert_true(false)
  }
}

test "pool_deallocate" {
  let p = @memory.pool_create(64, 2)
  let a = @memory.pool_allocate(p)
  match a {
    Some(p1) => {
      let p2 = @memory.pool_deallocate(p1)
      assert_eq(p2.free_count, 2)
    }
    None => assert_true(false)
  }
}

test "pool_usage" {
  let p = @memory.pool_create(64, 10)
  let a = @memory.pool_allocate(p)
  match a {
    Some(p1) => assert_eq(@memory.pool_usage(p1), 10)
    None => assert_true(false)
  }
}

test "gc_stats_create" {
  let s = @memory.gc_stats_create()
  assert_eq(s.collections, 0)
  assert_eq(s.live_objects, 0)
}

test "gc_record_alloc" {
  let s = @memory.gc_stats_create()
  let s1 = @memory.gc_record_alloc(s, 100)
  assert_eq(s1.live_objects, 1)
  assert_eq(s1.total_allocated, 100)
}

test "gc_record_collect" {
  let s = @memory.gc_stats_create()
  let s1 = @memory.gc_record_alloc(s, 100)
  let s2 = @memory.gc_record_collect(s1, 80, 1)
  assert_eq(s2.collections, 1)
  assert_eq(s2.reclaimed_bytes, 80)
  assert_eq(s2.live_objects, 0)
}

test "memory_version" {
  let v = @memory.memory_version()
  assert_true(v.contains("memory"))
}