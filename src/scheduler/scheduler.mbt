///|
/// 调度任务 | Scheduled task
pub(all) struct ScheduledTask {
  id : Int
  name : String
  delay : Int
  priority : Int
  executed : Bool
} derive(Debug, Eq)
pub extend ScheduledTask with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ScheduledTask with Eq::{not_equal, equal}

///|
/// 调度器 | Scheduler
pub(all) struct Scheduler {
  tasks : Array[ScheduledTask]
  current_time : Int
  next_id : Int
  executed_count : Int
} derive(Debug, Eq)
pub extend Scheduler with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Scheduler with Eq::{not_equal, equal}

///|
/// 创建调度器 | Create scheduler
pub fn scheduler_create() -> Scheduler {
  { tasks: [], current_time: 0, next_id: 0, executed_count: 0 }
}

///|
/// 调度任务 | Schedule task
pub fn scheduler_schedule(s : Scheduler, name : String, delay : Int, priority : Int) -> (Scheduler, ScheduledTask) {
  let task = { id: s.next_id, name, delay, priority, executed: false }
  let new_tasks = []
  for t in s.tasks {
    new_tasks.push(t)
  }
  new_tasks.push(task)
  ({ tasks: new_tasks, current_time: s.current_time, next_id: s.next_id + 1, executed_count: s.executed_count }, task)
}

///|
/// 推进时间 | Advance time
pub fn scheduler_advance(s : Scheduler, time : Int) -> Scheduler {
  let new_time = s.current_time + time
  let new_tasks = []
  let mut new_executed = s.executed_count
  for t in s.tasks {
    if !t.executed && t.delay <= new_time {
      new_tasks.push({ id: t.id, name: t.name, delay: t.delay, priority: t.priority, executed: true })
      new_executed = new_executed + 1
    } else {
      new_tasks.push(t)
    }
  }
  { tasks: new_tasks, current_time: new_time, next_id: s.next_id, executed_count: new_executed }
}

///|
/// 待执行任务数 | Pending task count
pub fn scheduler_pending_count(s : Scheduler) -> Int {
  let mut count = 0
  for t in s.tasks {
    if !t.executed {
      count = count + 1
    }
  }
  count
}

///|
/// 已执行任务数 | Executed task count
pub fn scheduler_executed_count(s : Scheduler) -> Int {
  s.executed_count
}

///|
/// 总任务数 | Total task count
pub fn scheduler_total_count(s : Scheduler) -> Int {
  s.tasks.length()
}

///|
/// 获取当前时间 | Get current time
pub fn scheduler_current_time(s : Scheduler) -> Int {
  s.current_time
}

///|
/// 取消任务 | Cancel task
pub fn scheduler_cancel(s : Scheduler, task_id : Int) -> Scheduler {
  let new_tasks = []
  for t in s.tasks {
    if t.id != task_id {
      new_tasks.push(t)
    }
  }
  { tasks: new_tasks, current_time: s.current_time, next_id: s.next_id, executed_count: s.executed_count }
}

///|
/// 调度器版本 | Scheduler version
pub fn scheduler_version() -> String {
  "moon-cross scheduler v0.3.5"
}

///|
/// ScheduledTask 实现 Named trait | ScheduledTask implements Named
pub impl @trait.Named for ScheduledTask with name(self) {
  self.name
}
pub extend ScheduledTask with @trait.Named::{name}