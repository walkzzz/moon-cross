test "resource_type_name" {
  assert_eq(@resource.resource_type_name(@resource.ResourceType::File), "FILE")
  assert_eq(@resource.resource_type_name(@resource.ResourceType::Memory), "MEMORY")
  assert_eq(@resource.resource_type_name(@resource.ResourceType::Network), "NETWORK")
  assert_eq(@resource.resource_type_name(@resource.ResourceType::Handle), "HANDLE")
  assert_eq(@resource.resource_type_name(@resource.ResourceType::Custom), "CUSTOM")
}

test "default_resource_config" {
  let cfg = @resource.default_resource_config()
  assert_eq(cfg.max_resources, 100)
  assert_true(cfg.track_size)
  assert_true(cfg.leak_detection)
}

test "create_resource_manager" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  assert_eq(@resource.resource_total_count(mgr), 0)
  assert_eq(@resource.resource_active_count(mgr), 0)
}

test "resource_acquire" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "file1", @resource.ResourceType::File, 1024, 1000)
  assert_eq(@resource.resource_total_count(mgr1), 1)
  assert_eq(@resource.resource_active_count(mgr1), 1)
  assert_true(@resource.resource_has(mgr1, 1))
}

test "resource_acquire_multiple" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  assert_eq(@resource.resource_active_count(mgr2), 2)
}

test "resource_acquire_max_limit" {
  let cfg = @resource.ResourceConfig::{ max_resources: 2, track_size: true, leak_detection: true }
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::File, 100, 2000)
  let mgr3 = @resource.resource_acquire(mgr2, 3, "c", @resource.ResourceType::File, 100, 3000)
  assert_eq(@resource.resource_total_count(mgr3), 2)
}

test "resource_release" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "file1", @resource.ResourceType::File, 1024, 1000)
  let mgr2 = @resource.resource_release(mgr1, 1, 2000)
  assert_eq(@resource.resource_active_count(mgr2), 0)
  assert_false(@resource.resource_is_active(mgr2, 1))
}

test "resource_release_nonexistent" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_release(mgr, 999, 1000)
  assert_eq(@resource.resource_active_count(mgr1), 0)
}

test "resource_release_already_released" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_release(mgr1, 1, 2000)
  let mgr3 = @resource.resource_release(mgr2, 1, 3000)
  assert_eq(@resource.resource_active_count(mgr3), 0)
}

test "resource_get" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "file1", @resource.ResourceType::File, 1024, 1000)
  let result = @resource.resource_get(mgr1, 1)
  assert_true(result is Some(_))
}

test "resource_get_not_found" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let result = @resource.resource_get(mgr, 999)
  assert_true(result is None)
}

test "resource_total_size" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  assert_eq(@resource.resource_total_size(mgr2), 300)
}

test "resource_total_size_after_release" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let mgr3 = @resource.resource_release(mgr2, 1, 3000)
  assert_eq(@resource.resource_total_size(mgr3), 200)
}

test "resource_check_leaks" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let leaks = @resource.resource_check_leaks(mgr2)
  assert_eq(leaks.length(), 2)
}

test "resource_check_leaks_none" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_release(mgr1, 1, 2000)
  let leaks = @resource.resource_check_leaks(mgr2)
  assert_eq(leaks.length(), 0)
}

test "resource_leak_count" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  assert_eq(@resource.resource_leak_count(mgr2), 2)
  let mgr3 = @resource.resource_release(mgr2, 1, 3000)
  assert_eq(@resource.resource_leak_count(mgr3), 1)
}

test "resource_filter_by_type" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let mgr3 = @resource.resource_acquire(mgr2, 3, "c", @resource.ResourceType::File, 300, 3000)
  let files = @resource.resource_filter_by_type(mgr3, @resource.ResourceType::File)
  assert_eq(files.length(), 2)
}

test "resource_filter_active" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let mgr3 = @resource.resource_release(mgr2, 1, 3000)
  let active = @resource.resource_filter_active(mgr3)
  assert_eq(active.length(), 1)
}

test "resource_filter_released" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let mgr3 = @resource.resource_release(mgr2, 1, 3000)
  let released = @resource.resource_filter_released(mgr3)
  assert_eq(released.length(), 1)
}

test "resource_is_active" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  assert_true(@resource.resource_is_active(mgr1, 1))
  let mgr2 = @resource.resource_release(mgr1, 1, 2000)
  assert_false(@resource.resource_is_active(mgr2, 1))
}

test "resource_stats" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let s = @resource.resource_stats(mgr1)
  assert_eq(s.total_acquired, 1)
  assert_eq(s.active_count, 1)
  assert_eq(s.total_size, 100)
}

test "resource_release_all" {
  let cfg = @resource.default_resource_config()
  let mgr = @resource.create_resource_manager(cfg)
  let mgr1 = @resource.resource_acquire(mgr, 1, "a", @resource.ResourceType::File, 100, 1000)
  let mgr2 = @resource.resource_acquire(mgr1, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let mgr3 = @resource.resource_release_all(mgr2, 3000)
  assert_eq(@resource.resource_active_count(mgr3), 0)
  assert_eq(@resource.resource_leak_count(mgr3), 0)
}

test "merge_resource_managers" {
  let cfg = @resource.default_resource_config()
  let m1 = @resource.create_resource_manager(cfg)
  let m2 = @resource.create_resource_manager(cfg)
  let m1a = @resource.resource_acquire(m1, 1, "a", @resource.ResourceType::File, 100, 1000)
  let m2a = @resource.resource_acquire(m2, 2, "b", @resource.ResourceType::Memory, 200, 2000)
  let merged = @resource.merge_resource_managers(m1a, m2a)
  assert_eq(@resource.resource_total_count(merged), 2)
}

test "resource_version" {
  let v = @resource.resource_version()
  assert_true(v.contains("resource"))
}
