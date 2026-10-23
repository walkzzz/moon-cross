test "default_benchmark_config" {
  let cfg = @benchmark.default_benchmark_config("test")
  assert_eq(cfg.name, "test")
  assert_eq(cfg.iterations, 1000)
  assert_eq(cfg.warmup_runs, 10)
  assert_eq(cfg.timeout_ms, 30000)
}

test "quick_benchmark_config" {
  let cfg = @benchmark.quick_benchmark_config("quick")
  assert_eq(cfg.name, "quick")
  assert_eq(cfg.iterations, 100)
  assert_eq(cfg.warmup_runs, 5)
  assert_eq(cfg.timeout_ms, 5000)
}

test "precise_benchmark_config" {
  let cfg = @benchmark.precise_benchmark_config("precise")
  assert_eq(cfg.name, "precise")
  assert_eq(cfg.iterations, 10000)
  assert_eq(cfg.warmup_runs, 100)
  assert_eq(cfg.timeout_ms, 120000)
}

test "calculate_mean_basic" {
  let values = [10, 20, 30, 40, 50]
  let mean = @benchmark.calculate_mean(values)
  assert_true(mean > 29.9 && mean < 30.1)
}

test "calculate_mean_empty" {
  let values : Array[Int] = []
  let mean = @benchmark.calculate_mean(values)
  assert_true(mean == 0.0)
}

test "calculate_mean_single" {
  let values = [42]
  let mean = @benchmark.calculate_mean(values)
  assert_true(mean > 41.9 && mean < 42.1)
}

test "calculate_median_odd" {
  let values = [5, 1, 3, 2, 4]
  let median = @benchmark.calculate_median(values)
  assert_true(median > 2.9 && median < 3.1)
}

test "calculate_median_even" {
  let values = [1, 2, 3, 4]
  let median = @benchmark.calculate_median(values)
  assert_true(median > 2.4 && median < 2.6)
}

test "calculate_median_empty" {
  let values : Array[Int] = []
  let median = @benchmark.calculate_median(values)
  assert_true(median == 0.0)
}

test "calculate_min_basic" {
  let values = [5, 1, 3, 2, 4]
  let min_val = @benchmark.calculate_min(values)
  assert_true(min_val > 0.9 && min_val < 1.1)
}

test "calculate_max_basic" {
  let values = [5, 1, 3, 2, 4]
  let max_val = @benchmark.calculate_max(values)
  assert_true(max_val > 4.9 && max_val < 5.1)
}

test "calculate_variance_basic" {
  let values = [2, 4, 4, 4, 5, 5, 7, 9]
  let variance = @benchmark.calculate_variance(values)
  assert_true(variance > 3.9 && variance < 4.1)
}

test "calculate_variance_empty" {
  let values : Array[Int] = []
  let variance = @benchmark.calculate_variance(values)
  assert_true(variance == 0.0)
}

test "calculate_std_dev_basic" {
  let values = [2, 4, 4, 4, 5, 5, 7, 9]
  let std_dev = @benchmark.calculate_std_dev(values)
  assert_true(std_dev > 1.9 && std_dev < 2.1)
}

test "calculate_percentile_p95" {
  let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let p95 = @benchmark.calculate_percentile(values, 95.0)
  assert_true(p95 > 8.9)
}

test "calculate_percentile_p99" {
  let values = [1, 2, 3, 4, 5, 6, 7, 8, 9, 10]
  let p99 = @benchmark.calculate_percentile(values, 99.0)
  assert_true(p99 > 8.9)
}

test "calculate_percentile_empty" {
  let values : Array[Int] = []
  let p95 = @benchmark.calculate_percentile(values, 95.0)
  assert_true(p95 == 0.0)
}

test "generate_stats_basic" {
  let values = [10, 20, 30, 40, 50]
  let stats = @benchmark.generate_stats(values)
  assert_true(stats.mean > 29.9 && stats.mean < 30.1)
  assert_true(stats.min_val > 9.9 && stats.min_val < 10.1)
  assert_true(stats.max_val > 49.9 && stats.max_val < 50.1)
}

test "simulate_benchmark_basic" {
  let cfg = @benchmark.default_benchmark_config("test")
  let timings = [100, 200, 150, 120, 180]
  let result = @benchmark.simulate_benchmark(cfg, timings)
  assert_eq(result.name, "test")
  assert_eq(result.iterations, 1000)
  assert_eq(result.total_time_ms, 750)
}

test "simulate_benchmark_ops_per_second" {
  let cfg = @benchmark.default_benchmark_config("test")
  let timings = [10, 10, 10, 10, 10]
  let result = @benchmark.simulate_benchmark(cfg, timings)
  assert_true(result.ops_per_second > 0)
}

test "create_suite_basic" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  assert_eq(suite.name, "my_suite")
  assert_eq(suite.configs.length(), 1)
  assert_eq(suite.results.length(), 0)
}

test "add_result_to_suite" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  let timings = [100, 200, 150]
  let result = @benchmark.simulate_benchmark(cfg, timings)
  let updated = @benchmark.add_result(suite, result)
  assert_eq(updated.results.length(), 1)
}

test "add_multiple_results" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  let r1 = @benchmark.simulate_benchmark(cfg, [100, 200])
  let r2 = @benchmark.simulate_benchmark(cfg, [150, 250])
  let s1 = @benchmark.add_result(suite, r1)
  let s2 = @benchmark.add_result(s1, r2)
  assert_eq(s2.results.length(), 2)
}

test "compare_results_faster" {
  let cfg = @benchmark.default_benchmark_config("test")
  let baseline = @benchmark.simulate_benchmark(cfg, [200, 200, 200])
  let candidate = @benchmark.simulate_benchmark(cfg, [100, 100, 100])
  let comp = @benchmark.compare_results(baseline, candidate)
  assert_true(comp.speedup > 1.0)
  assert_true(comp.improvement_pct > 0.0)
  assert_true(comp.significant)
}

test "compare_results_slower" {
  let cfg = @benchmark.default_benchmark_config("test")
  let baseline = @benchmark.simulate_benchmark(cfg, [100, 100, 100])
  let candidate = @benchmark.simulate_benchmark(cfg, [200, 200, 200])
  let comp = @benchmark.compare_results(baseline, candidate)
  assert_true(comp.speedup < 1.0)
  assert_true(comp.improvement_pct < 0.0)
  assert_true(comp.significant)
}

test "compare_results_same" {
  let cfg = @benchmark.default_benchmark_config("test")
  let baseline = @benchmark.simulate_benchmark(cfg, [100, 100, 100])
  let candidate = @benchmark.simulate_benchmark(cfg, [100, 100, 100])
  let comp = @benchmark.compare_results(baseline, candidate)
  assert_true(comp.speedup > 0.9 && comp.speedup < 1.1)
  assert_true(!comp.significant)
}

test "format_result_not_empty" {
  let cfg = @benchmark.default_benchmark_config("test")
  let result = @benchmark.simulate_benchmark(cfg, [100, 200, 150])
  let formatted = @benchmark.format_result(result)
  assert_true(formatted.length() > 0)
}

test "format_result_contains_name" {
  let cfg = @benchmark.default_benchmark_config("my_bench")
  let result = @benchmark.simulate_benchmark(cfg, [100, 200, 150])
  let formatted = @benchmark.format_result(result)
  assert_true(formatted.contains("my_bench"))
}

test "format_result_contains_iterations" {
  let cfg = @benchmark.default_benchmark_config("test")
  let result = @benchmark.simulate_benchmark(cfg, [100, 200, 150])
  let formatted = @benchmark.format_result(result)
  assert_true(formatted.contains("Iterations"))
}

test "format_result_contains_ops" {
  let cfg = @benchmark.default_benchmark_config("test")
  let result = @benchmark.simulate_benchmark(cfg, [100, 200, 150])
  let formatted = @benchmark.format_result(result)
  assert_true(formatted.contains("Ops/sec"))
}

test "format_stats_not_empty" {
  let values = [10, 20, 30, 40, 50]
  let stats = @benchmark.generate_stats(values)
  let formatted = @benchmark.format_stats(stats)
  assert_true(formatted.length() > 0)
}

test "format_stats_contains_mean" {
  let values = [10, 20, 30, 40, 50]
  let stats = @benchmark.generate_stats(values)
  let formatted = @benchmark.format_stats(stats)
  assert_true(formatted.contains("Mean"))
}

test "format_comparison_not_empty" {
  let cfg = @benchmark.default_benchmark_config("test")
  let baseline = @benchmark.simulate_benchmark(cfg, [200, 200])
  let candidate = @benchmark.simulate_benchmark(cfg, [100, 100])
  let comp = @benchmark.compare_results(baseline, candidate)
  let formatted = @benchmark.format_comparison(comp)
  assert_true(formatted.length() > 0)
}

test "format_comparison_contains_speedup" {
  let cfg = @benchmark.default_benchmark_config("test")
  let baseline = @benchmark.simulate_benchmark(cfg, [200, 200])
  let candidate = @benchmark.simulate_benchmark(cfg, [100, 100])
  let comp = @benchmark.compare_results(baseline, candidate)
  let formatted = @benchmark.format_comparison(comp)
  assert_true(formatted.contains("Speedup"))
}

test "benchmark_version" {
  let v = @benchmark.benchmark_version()
  assert_true(v.contains("benchmark"))
}

test "is_empty_suite_empty" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  assert_true(@benchmark.is_empty_suite(suite))
}

test "is_empty_suite_not_empty" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  let result = @benchmark.simulate_benchmark(cfg, [100, 200])
  let updated = @benchmark.add_result(suite, result)
  assert_true(!@benchmark.is_empty_suite(updated))
}

test "suite_result_count" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  assert_eq(@benchmark.suite_result_count(suite), 0)
  let r1 = @benchmark.simulate_benchmark(cfg, [100, 200])
  let s1 = @benchmark.add_result(suite, r1)
  assert_eq(@benchmark.suite_result_count(s1), 1)
}

test "find_fastest_basic" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  let r1 = @benchmark.simulate_benchmark(cfg, [200, 200])
  let r2 = @benchmark.simulate_benchmark(cfg, [100, 100])
  let s1 = @benchmark.add_result(suite, r1)
  let s2 = @benchmark.add_result(s1, r2)
  match @benchmark.find_fastest(s2) {
    Some(fastest) => assert_true(fastest.avg_time_ns <= 100)
    None => assert_true(false)
  }
}

test "find_slowest_basic" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  let r1 = @benchmark.simulate_benchmark(cfg, [200, 200])
  let r2 = @benchmark.simulate_benchmark(cfg, [100, 100])
  let s1 = @benchmark.add_result(suite, r1)
  let s2 = @benchmark.add_result(s1, r2)
  match @benchmark.find_slowest(s2) {
    Some(slowest) => assert_true(slowest.avg_time_ns >= 200)
    None => assert_true(false)
  }
}

test "find_fastest_empty" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  match @benchmark.find_fastest(suite) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "find_slowest_empty" {
  let cfg = @benchmark.default_benchmark_config("test")
  let suite = @benchmark.create_suite("my_suite", [cfg])
  match @benchmark.find_slowest(suite) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}