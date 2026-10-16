///|
/// 并行编译配置 | Parallel compilation configuration
pub(all) struct ParallelConfig {
  max_parallelism : Int
  enabled : Bool
  multi_arch : Bool
} derive(Debug, Eq)

pub extend ParallelConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ParallelConfig with Eq::{not_equal, equal}

///|
/// 并行任务 | Parallel task
pub(all) struct ParallelTask {
  platform : @core.Platform
  arch : @core.Arch
  command : String
  priority : Int
} derive(Debug, Eq)

pub extend ParallelTask with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ParallelTask with Eq::{not_equal, equal}

///|
/// 任务调度结果 | Task schedule result
pub(all) struct TaskSchedule {
  tasks : Array[ParallelTask]
  batches : Int
  estimated_speedup : Double
} derive(Debug, Eq)

pub extend TaskSchedule with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TaskSchedule with Eq::{not_equal, equal}

///|
/// 默认并行配置 | Default parallel configuration
pub fn default_parallel_config() -> ParallelConfig {
  { max_parallelism: 4, enabled: true, multi_arch: true }
}

///|
/// 禁用并行配置 | Disabled parallel configuration
pub fn disabled_parallel_config() -> ParallelConfig {
  { max_parallelism: 1, enabled: false, multi_arch: false }
}

///|
/// 创建并行任务 | Create parallel task
pub fn make_task(platform : @core.Platform, arch : @core.Arch, command : String, priority : Int) -> ParallelTask {
  { platform, arch, command, priority }
}

///|
/// 根据平台生成并行任务 | Generate parallel tasks for all platforms
pub fn generate_all_tasks(config : ParallelConfig) -> Array[ParallelTask] {
  let tasks = []
  for platform in @core.all_platforms() {
    let arch = platform.default_arch()
    let cmd = "compile-" + platform.to_id()
    tasks.push(make_task(platform, arch, cmd, 1))
    if config.multi_arch {
      let other_arch = match arch {
        @core.Arch::Arm64 => @core.Arch::X86_64
        @core.Arch::X86_64 => @core.Arch::Arm64
      }
      tasks.push(make_task(platform, other_arch, "compile-" + platform.to_id() + "-" + other_arch.to_id(), 2))
    }
  }
  tasks
}

///|
/// 计算并行批次 | Calculate parallel batches
pub fn calculate_batches(task_count : Int, max_parallelism : Int) -> Int {
  if max_parallelism <= 0 {
    return task_count
  }
  (task_count + max_parallelism - 1) / max_parallelism
}

///|
/// 调度任务 | Schedule tasks
pub fn schedule_tasks(config : ParallelConfig) -> TaskSchedule {
  let tasks = generate_all_tasks(config)
  let batch_count = calculate_batches(tasks.length(), config.max_parallelism)
  let speedup = if config.enabled && tasks.length() > 0 {
    tasks.length().to_double() / batch_count.to_double()
  } else {
    1.0
  }
  { tasks, batches: batch_count, estimated_speedup: speedup }
}

///|
/// 计算最优并行度 | Calculate optimal parallelism based on CPU cores
pub fn optimal_parallelism(cpu_cores : Int) -> Int {
  if cpu_cores <= 0 {
    1
  } else if cpu_cores > 8 {
    8
  } else {
    cpu_cores
  }
}

///|
/// 并行编译版本 | Parallel compilation version
pub fn parallel_version() -> String {
  "moon-cross perf/parallel v0.1.0"
}