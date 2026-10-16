test "parallel: default config" {
  let config = @perf.default_parallel_config()
  assert_true(config.enabled)
  assert_eq(config.max_parallelism, 4)
  assert_true(config.multi_arch)
}

test "parallel: disabled config" {
  let config = @perf.disabled_parallel_config()
  assert_false(config.enabled)
  assert_eq(config.max_parallelism, 1)
}

test "parallel: generate tasks without multi arch" {
  let config = { ..@perf.default_parallel_config(), multi_arch: false }
  let tasks = @perf.generate_all_tasks(config)
  assert_eq(tasks.length(), 4)
}

test "parallel: generate tasks with multi arch" {
  let config = @perf.default_parallel_config()
  let tasks = @perf.generate_all_tasks(config)
  assert_eq(tasks.length(), 8)
}

test "parallel: calculate batches" {
  assert_eq(@perf.calculate_batches(8, 4), 2)
  assert_eq(@perf.calculate_batches(7, 4), 2)
  assert_eq(@perf.calculate_batches(4, 4), 1)
  assert_eq(@perf.calculate_batches(1, 4), 1)
}

test "parallel: schedule tasks" {
  let config = @perf.default_parallel_config()
  let schedule = @perf.schedule_tasks(config)
  assert_eq(schedule.tasks.length(), 8)
  assert_eq(schedule.batches, 2)
}

test "parallel: optimal parallelism" {
  assert_eq(@perf.optimal_parallelism(0), 1)
  assert_eq(@perf.optimal_parallelism(2), 2)
  assert_eq(@perf.optimal_parallelism(4), 4)
  assert_eq(@perf.optimal_parallelism(16), 8)
}

test "parallel: version" {
  assert_true(@perf.parallel_version().contains("v0.1.0"))
}

test "cache: default config" {
  let config = @perf.default_cache_config()
  assert_true(config.enabled)
  assert_eq(config.max_size_mb, 256)
  assert_eq(config.ttl_seconds, 86400)
}

test "cache: disabled config" {
  let config = @perf.disabled_cache_config()
  assert_false(config.enabled)
}

test "cache: cache key" {
  let key = @perf.cache_key(@core.Platform::Windows, "abc123")
  assert_true(key.contains("windows"))
  assert_true(key.contains("abc123"))
}

test "cache: check cache hit" {
  let config = @perf.default_cache_config()
  let entry = @perf.make_cache_entry("key1", "hash1", 1000, 1024)
  assert_true(@perf.check_cache(config, Some(entry), 1000))
  assert_true(@perf.check_cache(config, Some(entry), 5000))
}

test "cache: check cache miss expired" {
  let config = @perf.default_cache_config()
  let entry = @perf.make_cache_entry("key1", "hash1", 1000, 1024)
  assert_false(@perf.check_cache(config, Some(entry), 100000))
}

test "cache: check cache miss disabled" {
  let config = @perf.disabled_cache_config()
  let entry = @perf.make_cache_entry("key1", "hash1", 1000, 1024)
  assert_false(@perf.check_cache(config, Some(entry), 1000))
}

test "cache: check cache miss none" {
  let config = @perf.default_cache_config()
  assert_false(@perf.check_cache(config, None, 1000))
}

test "cache: empty stats" {
  let stats = @perf.empty_cache_stats()
  assert_eq(stats.hits, 0)
  assert_eq(stats.misses, 0)
}

test "cache: exceeds size" {
  let config = @perf.default_cache_config()
  let large_size = 300 * 1024 * 1024
  assert_true(@perf.cache_exceeds_size(config, large_size))
}

test "cache: not exceeds size" {
  let config = @perf.default_cache_config()
  let small_size = 100 * 1024 * 1024
  assert_false(@perf.cache_exceeds_size(config, small_size))
}

test "cache: space to reclaim" {
  let config = @perf.default_cache_config()
  let large_size = 300 * 1024 * 1024
  let reclaim = @perf.space_to_reclaim(config, large_size)
  assert_true(reclaim > 0)
}

test "cache: no space to reclaim" {
  let config = @perf.default_cache_config()
  let small_size = 100 * 1024 * 1024
  assert_eq(@perf.space_to_reclaim(config, small_size), 0)
}

test "cache: version" {
  assert_true(@perf.cache_version().contains("v0.1.0"))
}

test "incremental: empty change set" {
  let cs = @perf.empty_change_set()
  assert_eq(cs.total_files, 0)
  assert_false(@perf.needs_rebuild(cs))
}

test "incremental: detect changes added" {
  let old_hashes : Array[(String, String)] = []
  let new_hashes : Array[(String, String)] = [("file1.mbt", "hash1")]
  let cs = @perf.detect_changes(old_hashes, new_hashes)
  assert_eq(cs.total_files, 1)
  assert_true(@perf.needs_rebuild(cs))
}

test "incremental: detect changes modified" {
  let old_hashes : Array[(String, String)] = [("file1.mbt", "old_hash")]
  let new_hashes : Array[(String, String)] = [("file1.mbt", "new_hash")]
  let cs = @perf.detect_changes(old_hashes, new_hashes)
  assert_eq(cs.total_files, 1)
}

test "incremental: detect changes removed" {
  let old_hashes : Array[(String, String)] = [("file1.mbt", "hash1")]
  let new_hashes : Array[(String, String)] = []
  let cs = @perf.detect_changes(old_hashes, new_hashes)
  assert_eq(cs.total_files, 1)
}

test "incremental: detect no changes" {
  let old_hashes : Array[(String, String)] = [("file1.mbt", "hash1")]
  let new_hashes : Array[(String, String)] = [("file1.mbt", "hash1")]
  let cs = @perf.detect_changes(old_hashes, new_hashes)
  assert_eq(cs.total_files, 0)
  assert_false(@perf.needs_rebuild(cs))
}

test "incremental: affected platforms windows" {
  let changes = [@perf.make_file_change("platform/windows/compile.mbt", @perf.ChangeType::Modified, Some("old"), Some("new"))]
  let cs = @perf.make_change_set(changes, 1)
  let platforms = @perf.affected_platforms(cs)
  assert_true(platforms.length() >= 1)
}

test "incremental: affected platforms all" {
  let changes = [@perf.make_file_change("core/types.mbt", @perf.ChangeType::Modified, Some("old"), Some("new"))]
  let cs = @perf.make_change_set(changes, 1)
  let platforms = @perf.affected_platforms(cs)
  assert_eq(platforms.length(), 4)
}

test "incremental: incremental build no changes" {
  let cs = @perf.empty_change_set()
  let result = @perf.incremental_build(cs)
  assert_false(result.needs_rebuild)
}

test "incremental: incremental build with changes" {
  let changes = [@perf.make_file_change("file.mbt", @perf.ChangeType::Added, None, Some("hash"))]
  let cs = @perf.make_change_set(changes, 1)
  let result = @perf.incremental_build(cs)
  assert_true(result.needs_rebuild)
  assert_eq(result.rebuilt_files, 1)
}

test "incremental: warmup" {
  let cs = @perf.warmup_config()
  assert_eq(cs.total_files, 4)
}

test "incremental: version" {
  assert_true(@perf.incremental_version().contains("v0.1.0"))
}

test "optimize: default config" {
  let config = @perf.default_opt_config()
  assert_eq(config.level, @perf.OptLevel::O2)
  assert_true(config.inline_small_functions)
  assert_true(config.dead_code_elimination)
}

test "optimize: release config" {
  let config = @perf.release_opt_config()
  assert_eq(config.level, @perf.OptLevel::O3)
  assert_true(config.lto)
}

test "optimize: debug config" {
  let config = @perf.debug_opt_config()
  assert_eq(config.level, @perf.OptLevel::O0)
  assert_false(config.lto)
}

test "optimize: opt level to string" {
  assert_eq(@perf.OptLevel::O0.to_string(), "-O0")
  assert_eq(@perf.OptLevel::O1.to_string(), "-O1")
  assert_eq(@perf.OptLevel::O2.to_string(), "-O2")
  assert_eq(@perf.OptLevel::O3.to_string(), "-O3")
  assert_eq(@perf.OptLevel::Os.to_string(), "-Os")
}

test "optimize: opt flags" {
  let config = @perf.default_opt_config()
  let flags = @perf.opt_flags(config)
  assert_true(flags.length() >= 1)
  assert_true(flags[0].contains("-O2"))
}

test "optimize: opt flags with lto" {
  let config = @perf.release_opt_config()
  let flags = @perf.opt_flags(config)
  let mut has_lto = false
  for flag in flags {
    if flag == "-flto" {
      has_lto = true
    }
  }
  assert_true(has_lto)
}

test "optimize: should inline small hot" {
  assert_true(@perf.should_inline(30, 5))
}

test "optimize: should not inline large" {
  assert_false(@perf.should_inline(100, 5))
}

test "optimize: should not inline cold" {
  assert_false(@perf.should_inline(30, 1))
}

test "optimize: template specialize" {
  let name = @perf.template_specialize("my_func", ["int", "string"])
  assert_true(name.contains("my_func_specialized"))
  assert_true(name.contains("int"))
  assert_true(name.contains("string"))
}

test "optimize: dead code eliminate" {
  let exported = ["func_a", "func_b", "func_c"]
  let used = ["func_a", "func_c"]
  let unused = @perf.dead_code_eliminate(exported, used)
  assert_eq(unused.length(), 1)
  assert_eq(unused[0], "func_b")
}

test "optimize: dead code eliminate all used" {
  let exported = ["func_a", "func_b"]
  let used = ["func_a", "func_b"]
  let unused = @perf.dead_code_eliminate(exported, used)
  assert_eq(unused.length(), 0)
}

test "optimize: estimate optimized size" {
  let config = @perf.default_opt_config()
  let original = 10000
  let optimized = @perf.estimate_optimized_size(original, config)
  assert_true(optimized < original)
  assert_true(optimized > 0)
}

test "optimize: make result" {
  let result = @perf.make_opt_result(10000, 7000, 5, 3, 2)
  assert_eq(result.original_size_bytes, 10000)
  assert_eq(result.optimized_size_bytes, 7000)
  assert_eq(result.inlined_functions, 5)
  assert_eq(result.eliminated_functions, 3)
  assert_eq(result.specialized_templates, 2)
}

test "optimize: version" {
  assert_true(@perf.optimize_version().contains("v0.1.0"))
}