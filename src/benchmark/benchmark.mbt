///|
/// 基准测试配置 | Benchmark configuration
pub(all) struct BenchmarkConfig {
  name : String
  iterations : Int
  warmup_runs : Int
  timeout_ms : Int
} derive(Debug, Eq)
pub extend BenchmarkConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BenchmarkConfig with Eq::{not_equal, equal}

///|
/// 单次基准测试结果 | Single benchmark result
pub(all) struct BenchmarkResult {
  name : String
  iterations : Int
  total_time_ms : Int
  avg_time_ns : Int
  min_time_ns : Int
  max_time_ns : Int
  median_time_ns : Int
  ops_per_second : Int
} derive(Debug, Eq)
pub extend BenchmarkResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BenchmarkResult with Eq::{not_equal, equal}

///|
/// 基准测试套件 | Benchmark suite
pub(all) struct BenchmarkSuite {
  name : String
  configs : Array[BenchmarkConfig]
  results : Array[BenchmarkResult]
} derive(Debug, Eq)
pub extend BenchmarkSuite with @moonbitlang/core/debug.Debug::{to_repr}
pub extend BenchmarkSuite with Eq::{not_equal, equal}

///|
/// 统计摘要 | Statistics summary
pub(all) struct StatsSummary {
  mean : Double
  median : Double
  min_val : Double
  max_val : Double
  variance : Double
  std_dev : Double
  p95 : Double
  p99 : Double
} derive(Debug, Eq)
pub extend StatsSummary with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StatsSummary with Eq::{not_equal, equal}

///|
/// 性能比较结果 | Performance comparison result
pub(all) struct ComparisonResult {
  baseline_name : String
  candidate_name : String
  speedup : Double
  improvement_pct : Double
  significant : Bool
} derive(Debug, Eq)
pub extend ComparisonResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ComparisonResult with Eq::{not_equal, equal}

///|
/// 默认基准测试配置 | Default benchmark configuration
pub fn default_benchmark_config(name : String) -> BenchmarkConfig {
  { name, iterations: 1000, warmup_runs: 10, timeout_ms: 30000 }
}

///|
/// 快速基准测试配置 | Quick benchmark configuration
pub fn quick_benchmark_config(name : String) -> BenchmarkConfig {
  { name, iterations: 100, warmup_runs: 5, timeout_ms: 5000 }
}

///|
/// 精确基准测试配置 | Precise benchmark configuration
pub fn precise_benchmark_config(name : String) -> BenchmarkConfig {
  { name, iterations: 10000, warmup_runs: 100, timeout_ms: 120000 }
}

///|
/// 计算平均值 | Calculate mean
pub fn calculate_mean(values : Array[Int]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mut sum = 0
  for v in values {
    sum = sum + v
  }
  sum.to_double() / values.length().to_double()
}

///|
/// 计算中位数 | Calculate median
pub fn calculate_median(values : Array[Int]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let sorted = sort_ints(values)
  let n = sorted.length()
  if n % 2 == 1 {
    sorted[n / 2].to_double()
  } else {
    (sorted[n / 2 - 1] + sorted[n / 2]).to_double() / 2.0
  }
}

///|
/// 简单排序（冒泡排序） | Simple sort (bubble sort)
fn sort_ints(values : Array[Int]) -> Array[Int] {
  let result = []
  for v in values {
    result.push(v)
  }
  let n = result.length()
  for i in 0..<n {
    for j in 0..<(n - i - 1) {
      if result[j] > result[j + 1] {
        let tmp = result[j]
        result[j] = result[j + 1]
        result[j + 1] = tmp
      }
    }
  }
  result
}

///|
/// 计算最小值 | Calculate minimum
pub fn calculate_min(values : Array[Int]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mut min_val = values[0]
  for v in values {
    if v < min_val {
      min_val = v
    }
  }
  min_val.to_double()
}

///|
/// 计算最大值 | Calculate maximum
pub fn calculate_max(values : Array[Int]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mut max_val = values[0]
  for v in values {
    if v > max_val {
      max_val = v
    }
  }
  max_val.to_double()
}

///|
/// 计算方差 | Calculate variance
pub fn calculate_variance(values : Array[Int]) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let mean = calculate_mean(values)
  let mut sum_sq = 0.0
  for v in values {
    let diff = v.to_double() - mean
    sum_sq = sum_sq + diff * diff
  }
  sum_sq / values.length().to_double()
}

///|
/// 计算标准差 | Calculate standard deviation
pub fn calculate_std_dev(values : Array[Int]) -> Double {
  let variance = calculate_variance(values)
  sqrt(variance)
}

///|
/// 简化平方根（牛顿法） | Simplified square root (Newton's method)
fn sqrt(x : Double) -> Double {
  if x <= 0.0 {
    return 0.0
  }
  let mut guess = x / 2.0
  for _ in 0..<20 {
    guess = (guess + x / guess) / 2.0
  }
  guess
}

///|
/// 计算百分位数 | Calculate percentile
pub fn calculate_percentile(
  values : Array[Int],
  percentile : Double,
) -> Double {
  if values.length() == 0 {
    return 0.0
  }
  let sorted = sort_ints(values)
  let idx = (percentile / 100.0 * sorted.length().to_double())
  let i = idx.to_int()
  if i >= sorted.length() {
    sorted[sorted.length() - 1].to_double()
  } else {
    sorted[i].to_double()
  }
}

///|
/// 生成统计摘要 | Generate statistics summary
pub fn generate_stats(values : Array[Int]) -> StatsSummary {
  let mean = calculate_mean(values)
  let median = calculate_median(values)
  let min_val = calculate_min(values)
  let max_val = calculate_max(values)
  let variance = calculate_variance(values)
  let std_dev = sqrt(variance)
  let p95 = calculate_percentile(values, 95.0)
  let p99 = calculate_percentile(values, 99.0)
  { mean, median, min_val, max_val, variance, std_dev, p95, p99 }
}

///|
/// 模拟运行基准测试 | Simulate running benchmark
pub fn simulate_benchmark(
  config : BenchmarkConfig,
  timings : Array[Int],
) -> BenchmarkResult {
  let stats = generate_stats(timings)
  let total = {
    let mut s = 0
    for t in timings {
      s = s + t
    }
    s
  }
  let avg = if timings.length() > 0 {
    total / timings.length()
  } else {
    0
  }
  let ops = if total > 0 {
    timings.length() * 1000 / total
  } else {
    0
  }
  {
    name: config.name,
    iterations: config.iterations,
    total_time_ms: total,
    avg_time_ns: avg,
    min_time_ns: stats.min_val.to_int(),
    max_time_ns: stats.max_val.to_int(),
    median_time_ns: stats.median.to_int(),
    ops_per_second: ops,
  }
}

///|
/// 创建基准测试套件 | Create benchmark suite
pub fn create_suite(
  name : String,
  configs : Array[BenchmarkConfig],
) -> BenchmarkSuite {
  { name, configs, results: [] }
}

///|
/// 添加结果到套件 | Add result to suite
pub fn add_result(
  suite : BenchmarkSuite,
  result : BenchmarkResult,
) -> BenchmarkSuite {
  let new_results = []
  for r in suite.results {
    new_results.push(r)
  }
  new_results.push(result)
  { ..suite, results: new_results }
}

///|
/// 比较两次基准测试结果 | Compare two benchmark results
pub fn compare_results(
  baseline : BenchmarkResult,
  candidate : BenchmarkResult,
) -> ComparisonResult {
  let baseline_avg = baseline.avg_time_ns.to_double()
  let candidate_avg = candidate.avg_time_ns.to_double()
  let speedup = if candidate_avg > 0.0 {
    baseline_avg / candidate_avg
  } else {
    0.0
  }
  let improvement = if baseline_avg > 0.0 {
    (baseline_avg - candidate_avg) / baseline_avg * 100.0
  } else {
    0.0
  }
  let significant = improvement > 5.0 || improvement < -5.0
  {
    baseline_name: baseline.name,
    candidate_name: candidate.name,
    speedup,
    improvement_pct: improvement,
    significant,
  }
}

///|
/// 格式化基准测试结果 | Format benchmark result
pub fn format_result(result : BenchmarkResult) -> String {
  let mut output = "Benchmark: " + result.name + "\n"
  output = output + "  Iterations:     " + result.iterations.to_string() + "\n"
  output = output + "  Total time:     " + result.total_time_ms.to_string() + " ms\n"
  output = output + "  Avg time:       " + result.avg_time_ns.to_string() + " ns\n"
  output = output + "  Min time:       " + result.min_time_ns.to_string() + " ns\n"
  output = output + "  Max time:       " + result.max_time_ns.to_string() + " ns\n"
  output = output + "  Median time:    " + result.median_time_ns.to_string() + " ns\n"
  output = output + "  Ops/sec:        " + result.ops_per_second.to_string() + "\n"
  output
}

///|
/// 格式化统计摘要 | Format statistics summary
pub fn format_stats(stats : StatsSummary) -> String {
  let mut output = "Statistics:\n"
  output = output + "  Mean:     " + stats.mean.to_string() + "\n"
  output = output + "  Median:   " + stats.median.to_string() + "\n"
  output = output + "  Min:      " + stats.min_val.to_string() + "\n"
  output = output + "  Max:      " + stats.max_val.to_string() + "\n"
  output = output + "  Std Dev:  " + stats.std_dev.to_string() + "\n"
  output = output + "  P95:      " + stats.p95.to_string() + "\n"
  output = output + "  P99:      " + stats.p99.to_string() + "\n"
  output
}

///|
/// 格式化比较结果 | Format comparison result
pub fn format_comparison(comp : ComparisonResult) -> String {
  let mut output = "Comparison: " + comp.baseline_name + " vs " + comp.candidate_name + "\n"
  output = output + "  Speedup:       " + comp.speedup.to_string() + "x\n"
  output = output + "  Improvement:   " + comp.improvement_pct.to_string() + "%\n"
  let sig = if comp.significant {
    "yes"
  } else {
    "no"
  }
  output = output + "  Significant:   " + sig + "\n"
  output
}

///|
/// 基准测试版本 | Benchmark version
pub fn benchmark_version() -> String {
  "moon-cross benchmark v0.1.6"
}

///|
/// 空结果检查 | Check if results are empty
pub fn is_empty_suite(suite : BenchmarkSuite) -> Bool {
  suite.results.length() == 0
}

///|
/// 套件结果计数 | Count suite results
pub fn suite_result_count(suite : BenchmarkSuite) -> Int {
  suite.results.length()
}

///|
/// 查找最快结果 | Find fastest result
pub fn find_fastest(suite : BenchmarkSuite) -> BenchmarkResult? {
  if suite.results.length() == 0 {
    return None
  }
  let mut fastest = suite.results[0]
  for r in suite.results {
    if r.avg_time_ns < fastest.avg_time_ns {
      fastest = r
    }
  }
  Some(fastest)
}

///|
/// 查找最慢结果 | Find slowest result
pub fn find_slowest(suite : BenchmarkSuite) -> BenchmarkResult? {
  if suite.results.length() == 0 {
    return None
  }
  let mut slowest = suite.results[0]
  for r in suite.results {
    if r.avg_time_ns > slowest.avg_time_ns {
      slowest = r
    }
  }
  Some(slowest)
}