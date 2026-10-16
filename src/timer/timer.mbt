///|
/// 定时器类型 | Timer type
pub(all) enum TimerType {
  OneShot
  Periodic
} derive(Debug, Eq)
pub extend TimerType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TimerType with Eq::{not_equal, equal}

///|
/// 定时器配置 | Timer configuration
pub(all) struct TimerConfig {
  interval_ms : Int
  timer_type : TimerType
  auto_start : Bool
} derive(Debug, Eq)
pub extend TimerConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TimerConfig with Eq::{not_equal, equal}

///|
/// 定时器 | Timer
pub(all) struct Timer {
  id : Int
  name : String
  config : TimerConfig
  created_at : Int
  last_fired : Int
  fire_count : Int
  active : Bool
} derive(Debug, Eq)
pub extend Timer with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Timer with Eq::{not_equal, equal}

///|
/// 定时器统计 | Timer statistics
pub(all) struct TimerStats {
  total_created : Int
  total_fired : Int
  total_cancelled : Int
  active_count : Int
} derive(Debug, Eq)
pub extend TimerStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TimerStats with Eq::{not_equal, equal}

///|
/// 定时器管理器 | Timer manager
pub(all) struct TimerManager {
  timers : Array[Timer]
  stats : TimerStats
} derive(Debug, Eq)
pub extend TimerManager with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TimerManager with Eq::{not_equal, equal}

///|
/// 定时器类型名称 | Timer type name
pub fn timer_type_name(typ : TimerType) -> String {
  match typ {
    OneShot => "ONESHOT"
    Periodic => "PERIODIC"
  }
}

///|
/// 默认配置 | Default config
pub fn default_timer_config() -> TimerConfig {
  { interval_ms: 1000, timer_type: Periodic, auto_start: true }
}

///|
/// 创建定时器管理器 | Create timer manager
pub fn create_timer_manager() -> TimerManager {
  { timers: [], stats: { total_created: 0, total_fired: 0, total_cancelled: 0, active_count: 0 } }
}

///|
/// 添加定时器 | Add timer
pub fn timer_add(
  mgr : TimerManager,
  id : Int,
  name : String,
  config : TimerConfig,
  created_at : Int,
) -> TimerManager {
  let timer = { id, name, config, created_at, last_fired: 0, fire_count: 0, active: config.auto_start }
  let new_timers = []
  for t in mgr.timers {
    new_timers.push(t)
  }
  new_timers.push(timer)
  let active_inc = if config.auto_start { 1 } else { 0 }
  {
    timers: new_timers,
    stats: {
      total_created: mgr.stats.total_created + 1,
      total_fired: mgr.stats.total_fired,
      total_cancelled: mgr.stats.total_cancelled,
      active_count: mgr.stats.active_count + active_inc,
    },
  }
}

///|
/// 移除定时器 | Remove timer
pub fn timer_remove(mgr : TimerManager, id : Int) -> TimerManager {
  let remaining = []
  let mut removed_active = 0
  for t in mgr.timers {
    if t.id == id {
      if t.active {
        removed_active = removed_active + 1
      }
    } else {
      remaining.push(t)
    }
  }
  {
    timers: remaining,
    stats: {
      total_created: mgr.stats.total_created,
      total_fired: mgr.stats.total_fired,
      total_cancelled: mgr.stats.total_cancelled + 1,
      active_count: mgr.stats.active_count - removed_active,
    },
  }
}

///|
/// 启动定时器 | Start timer
pub fn timer_start(mgr : TimerManager, id : Int) -> TimerManager {
  let new_timers = []
  let mut activated = 0
  for t in mgr.timers {
    if t.id == id && !t.active {
      new_timers.push({ ..t, active: true })
      activated = activated + 1
    } else {
      new_timers.push(t)
    }
  }
  {
    timers: new_timers,
    stats: { ..mgr.stats, active_count: mgr.stats.active_count + activated },
  }
}

///|
/// 停止定时器 | Stop timer
pub fn timer_stop(mgr : TimerManager, id : Int) -> TimerManager {
  let new_timers = []
  let mut deactivated = 0
  for t in mgr.timers {
    if t.id == id && t.active {
      new_timers.push({ ..t, active: false })
      deactivated = deactivated + 1
    } else {
      new_timers.push(t)
    }
  }
  {
    timers: new_timers,
    stats: { ..mgr.stats, active_count: mgr.stats.active_count - deactivated },
  }
}

///|
/// 触发定时器 | Fire timer
pub fn timer_fire(mgr : TimerManager, id : Int, timestamp : Int) -> TimerManager {
  let new_timers = []
  let mut fired = 0
  for t in mgr.timers {
    if t.id == id && t.active {
      let new_t = { ..t, last_fired: timestamp, fire_count: t.fire_count + 1 }
      if t.config.timer_type is OneShot {
        new_timers.push({ ..new_t, active: false })
      } else {
        new_timers.push(new_t)
      }
      fired = fired + 1
    } else {
      new_timers.push(t)
    }
  }
  let active_dec = if fired > 0 {
    let mut is_oneshot = false
    for t in mgr.timers {
      if t.id == id && t.active && t.config.timer_type is OneShot {
        is_oneshot = true
      }
    }
    if is_oneshot { 1 } else { 0 }
  } else {
    0
  }
  {
    timers: new_timers,
    stats: {
      total_created: mgr.stats.total_created,
      total_fired: mgr.stats.total_fired + fired,
      total_cancelled: mgr.stats.total_cancelled,
      active_count: mgr.stats.active_count - active_dec,
    },
  }
}

///|
/// 重置定时器 | Reset timer
pub fn timer_reset(mgr : TimerManager, id : Int) -> TimerManager {
  let new_timers = []
  for t in mgr.timers {
    if t.id == id {
      new_timers.push({ ..t, fire_count: 0, last_fired: 0 })
    } else {
      new_timers.push(t)
    }
  }
  { ..mgr, timers: new_timers }
}

///|
/// 定时器数量 | Timer count
pub fn timer_count(mgr : TimerManager) -> Int {
  mgr.timers.length()
}

///|
/// 活跃定时器数量 | Active timer count
pub fn timer_active_count(mgr : TimerManager) -> Int {
  let mut count = 0
  for t in mgr.timers {
    if t.active {
      count = count + 1
    }
  }
  count
}

///|
/// 是否存在定时器 | Has timer
pub fn timer_has(mgr : TimerManager, id : Int) -> Bool {
  for t in mgr.timers {
    if t.id == id {
      return true
    }
  }
  false
}

///|
/// 获取定时器 | Get timer
pub fn timer_get(mgr : TimerManager, id : Int) -> Timer? {
  for t in mgr.timers {
    if t.id == id {
      return Some(t)
    }
  }
  None
}

///|
/// 获取触发次数 | Get fire count
pub fn timer_fire_count(mgr : TimerManager, id : Int) -> Int {
  for t in mgr.timers {
    if t.id == id {
      return t.fire_count
    }
  }
  0
}

///|
/// 是否应该触发 | Should fire
pub fn timer_should_fire(mgr : TimerManager, id : Int, current_time : Int) -> Bool {
  for t in mgr.timers {
    if t.id == id && t.active {
      if t.last_fired == 0 {
        return current_time - t.created_at >= t.config.interval_ms
      }
      return current_time - t.last_fired >= t.config.interval_ms
    }
  }
  false
}

///|
/// 定时器统计 | Timer statistics
pub fn timer_stats(mgr : TimerManager) -> TimerStats {
  mgr.stats
}

///|
/// 获取所有定时器名称 | Get all timer names
pub fn timer_names(mgr : TimerManager) -> Array[String] {
  let result = []
  for t in mgr.timers {
    result.push(t.name)
  }
  result
}

///|
/// 合并定时器管理器 | Merge timer managers
pub fn merge_timer_managers(m1 : TimerManager, m2 : TimerManager) -> TimerManager {
  let new_timers = []
  for t in m1.timers {
    new_timers.push(t)
  }
  for t in m2.timers {
    new_timers.push(t)
  }
  {
    timers: new_timers,
    stats: {
      total_created: m1.stats.total_created + m2.stats.total_created,
      total_fired: m1.stats.total_fired + m2.stats.total_fired,
      total_cancelled: m1.stats.total_cancelled + m2.stats.total_cancelled,
      active_count: m1.stats.active_count + m2.stats.active_count,
    },
  }
}

///|
/// 定时器版本 | Timer version
pub fn timer_version() -> String {
  "moon-cross timer v0.2.17"
}