///|
/// 池配置 | Pool configuration
pub(all) struct PoolConfig {
  min_size : Int
  max_size : Int
  idle_timeout_ms : Int
  auto_shrink : Bool
} derive(Debug, Eq)
pub extend PoolConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PoolConfig with Eq::{not_equal, equal}

///|
/// 池条目 | Pool entry
pub(all) struct PoolEntry {
  value : String
  created_at : Int
  last_used : Int
  use_count : Int
} derive(Debug, Eq)
pub extend PoolEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PoolEntry with Eq::{not_equal, equal}

///|
/// 池统计 | Pool statistics
pub(all) struct PoolStats {
  active : Int
  idle : Int
  total_created : Int
  total_destroyed : Int
  acquisitions : Int
  releases : Int
} derive(Debug, Eq)
pub extend PoolStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PoolStats with Eq::{not_equal, equal}

///|
/// 对象池 | Object pool
pub(all) struct Pool {
  idle : Array[PoolEntry]
  active_count : Int
  config : PoolConfig
  stats : PoolStats
} derive(Debug, Eq)
pub extend Pool with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Pool with Eq::{not_equal, equal}

///|
/// 默认池配置 | Default pool configuration
pub fn default_pool_config() -> PoolConfig {
  { min_size: 0, max_size: 10, idle_timeout_ms: 60000, auto_shrink: true }
}

///|
/// 创建池条目 | Create pool entry
pub fn make_pool_entry(value : String, timestamp : Int) -> PoolEntry {
  { value, created_at: timestamp, last_used: timestamp, use_count: 0 }
}

///|
/// 创建对象池 | Create object pool
pub fn create_pool(config : PoolConfig) -> Pool {
  { idle: [], active_count: 0, config, stats: { active: 0, idle: 0, total_created: 0, total_destroyed: 0, acquisitions: 0, releases: 0 } }
}

///|
/// 池总大小 | Pool total size (idle + active)
pub fn pool_size(pool : Pool) -> Int {
  pool.idle.length() + pool.active_count
}

///|
/// 空闲数量 | Idle count
pub fn pool_idle_count(pool : Pool) -> Int {
  pool.idle.length()
}

///|
/// 活跃数量 | Active count
pub fn pool_active_count(pool : Pool) -> Int {
  pool.active_count
}

///|
/// 池是否已满 | Check if pool is full
pub fn pool_is_full(pool : Pool) -> Bool {
  pool_size(pool) >= pool.config.max_size
}

///|
/// 池是否为空 | Check if pool is empty
pub fn pool_is_empty(pool : Pool) -> Bool {
  pool_size(pool) == 0
}

///|
/// 从池中获取对象 | Acquire object from pool
pub fn pool_acquire(pool : Pool, timestamp : Int) -> (Pool, String?) {
  if pool.idle.length() > 0 {
    let entry = pool.idle[0]
    let remaining = []
    for i in 1..<pool.idle.length() {
      remaining.push(pool.idle[i])
    }
    let new_stats = {
      active: pool.stats.active + 1,
      idle: pool.stats.idle - 1,
      total_created: pool.stats.total_created,
      total_destroyed: pool.stats.total_destroyed,
      acquisitions: pool.stats.acquisitions + 1,
      releases: pool.stats.releases,
    }
    let new_pool = {
      idle: remaining,
      active_count: pool.active_count + 1,
      config: pool.config,
      stats: new_stats,
    }
    (new_pool, Some(entry.value))
  } else if pool_size(pool) < pool.config.max_size {
    let entry = make_pool_entry("obj_{timestamp}", timestamp)
    let new_stats = {
      active: pool.stats.active + 1,
      idle: pool.stats.idle,
      total_created: pool.stats.total_created + 1,
      total_destroyed: pool.stats.total_destroyed,
      acquisitions: pool.stats.acquisitions + 1,
      releases: pool.stats.releases,
    }
    let new_pool = {
      idle: pool.idle,
      active_count: pool.active_count + 1,
      config: pool.config,
      stats: new_stats,
    }
    (new_pool, Some(entry.value))
  } else {
    (pool, None)
  }
}

///|
/// 归还对象到池 | Release object back to pool
pub fn pool_release(pool : Pool, value : String, timestamp : Int) -> Pool {
  let entry = { value, created_at: timestamp, last_used: timestamp, use_count: 0 }
  let new_stats = {
    active: pool.stats.active - 1,
    idle: pool.stats.idle + 1,
    total_created: pool.stats.total_created,
    total_destroyed: pool.stats.total_destroyed,
    acquisitions: pool.stats.acquisitions,
    releases: pool.stats.releases + 1,
  }
  let new_idle = []
  for e in pool.idle {
    new_idle.push(e)
  }
  new_idle.push(entry)
  {
    idle: new_idle,
    active_count: pool.active_count - 1,
    config: pool.config,
    stats: new_stats,
  }
}

///|
/// 预分配对象 | Preallocate objects
pub fn pool_preallocate(pool : Pool, count : Int, timestamp : Int) -> Pool {
  let new_idle = []
  for e in pool.idle {
    new_idle.push(e)
  }
  let mut created = 0
  for i in 0..<count {
    if pool_size(pool) + i >= pool.config.max_size {
      break
    }
    let entry = make_pool_entry("prealloc_{timestamp}_{i}", timestamp)
    new_idle.push(entry)
    created = created + 1
  }
  {
    idle: new_idle,
    active_count: pool.active_count,
    config: pool.config,
    stats: {
      active: pool.stats.active,
      idle: pool.stats.idle + created,
      total_created: pool.stats.total_created + created,
      total_destroyed: pool.stats.total_destroyed,
      acquisitions: pool.stats.acquisitions,
      releases: pool.stats.releases,
    },
  }
}

///|
/// 清空空闲对象 | Clear all idle objects
pub fn pool_clear(pool : Pool) -> Pool {
  let destroyed = pool.idle.length()
  {
    idle: [],
    active_count: pool.active_count,
    config: pool.config,
    stats: {
      active: pool.stats.active,
      idle: 0,
      total_created: pool.stats.total_created,
      total_destroyed: pool.stats.total_destroyed + destroyed,
      acquisitions: pool.stats.acquisitions,
      releases: pool.stats.releases,
    },
  }
}

///|
/// 收缩池（移除多余空闲对象） | Shrink pool (remove excess idle objects)
pub fn pool_shrink(pool : Pool, target_idle : Int) -> Pool {
  if pool.idle.length() <= target_idle {
    return pool
  }
  let to_remove = pool.idle.length() - target_idle
  let remaining = []
  for i in 0..<target_idle {
    remaining.push(pool.idle[i])
  }
  {
    idle: remaining,
    active_count: pool.active_count,
    config: pool.config,
    stats: {
      active: pool.stats.active,
      idle: target_idle,
      total_created: pool.stats.total_created,
      total_destroyed: pool.stats.total_destroyed + to_remove,
      acquisitions: pool.stats.acquisitions,
      releases: pool.stats.releases,
    },
  }
}

///|
/// 检查空闲对象是否过期 | Check if idle entry is expired
pub fn is_idle_expired(entry : PoolEntry, current_time : Int, timeout_ms : Int) -> Bool {
  current_time - entry.last_used > timeout_ms
}

///|
/// 清理过期空闲对象 | Evict expired idle entries
pub fn pool_evict_expired(pool : Pool, current_time : Int) -> Pool {
  let remaining = []
  let mut evicted = 0
  for entry in pool.idle {
    if is_idle_expired(entry, current_time, pool.config.idle_timeout_ms) {
      evicted = evicted + 1
    } else {
      remaining.push(entry)
    }
  }
  {
    idle: remaining,
    active_count: pool.active_count,
    config: pool.config,
    stats: {
      active: pool.stats.active,
      idle: remaining.length(),
      total_created: pool.stats.total_created,
      total_destroyed: pool.stats.total_destroyed + evicted,
      acquisitions: pool.stats.acquisitions,
      releases: pool.stats.releases,
    },
  }
}

///|
/// 池统计 | Pool statistics
pub fn pool_stats(pool : Pool) -> PoolStats {
  pool.stats
}

///|
/// 池利用率 | Pool utilization (active / max_size)
pub fn pool_utilization(pool : Pool) -> Double {
  if pool.config.max_size == 0 {
    return 0.0
  }
  pool.active_count.to_double() / pool.config.max_size.to_double()
}

///|
/// 池是否包含值 | Check if pool contains value
pub fn pool_contains(pool : Pool, value : String) -> Bool {
  for entry in pool.idle {
    if entry.value == value {
      return true
    }
  }
  false
}

///|
/// 获取空闲对象值列表 | Get idle values
pub fn pool_idle_values(pool : Pool) -> Array[String] {
  let result = []
  for entry in pool.idle {
    result.push(entry.value)
  }
  result
}

///|
/// 合并两个池 | Merge two pools
pub fn merge_pools(p1 : Pool, p2 : Pool) -> Pool {
  let new_idle = []
  for e in p1.idle {
    new_idle.push(e)
  }
  for e in p2.idle {
    new_idle.push(e)
  }
  {
    idle: new_idle,
    active_count: p1.active_count + p2.active_count,
    config: p1.config,
    stats: {
      active: p1.stats.active + p2.stats.active,
      idle: p1.stats.idle + p2.stats.idle,
      total_created: p1.stats.total_created + p2.stats.total_created,
      total_destroyed: p1.stats.total_destroyed + p2.stats.total_destroyed,
      acquisitions: p1.stats.acquisitions + p2.stats.acquisitions,
      releases: p1.stats.releases + p2.stats.releases,
    },
  }
}

///|
/// 池版本 | Pool version
pub fn pool_version() -> String {
  "moon-cross pool v0.2.12"
}