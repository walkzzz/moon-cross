///|
/// 资源类型 | Resource type
pub(all) enum ResourceType {
  File
  Memory
  Network
  Handle
  Custom
} derive(Debug, Eq)
pub extend ResourceType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ResourceType with Eq::{not_equal, equal}

///|
/// 资源 | Resource
pub(all) struct Resource {
  id : Int
  name : String
  typ : ResourceType
  size : Int
  acquired_at : Int
  released_at : Int
  active : Bool
} derive(Debug, Eq)
pub extend Resource with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Resource with Eq::{not_equal, equal}

///|
/// 资源配置 | Resource configuration
pub(all) struct ResourceConfig {
  max_resources : Int
  track_size : Bool
  leak_detection : Bool
} derive(Debug, Eq)
pub extend ResourceConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ResourceConfig with Eq::{not_equal, equal}

///|
/// 资源统计 | Resource statistics
pub(all) struct ResourceStats {
  total_acquired : Int
  total_released : Int
  total_leaked : Int
  active_count : Int
  total_size : Int
} derive(Debug, Eq)
pub extend ResourceStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ResourceStats with Eq::{not_equal, equal}

///|
/// 资源管理器 | Resource manager
pub(all) struct ResourceManager {
  resources : Array[Resource]
  config : ResourceConfig
  stats : ResourceStats
} derive(Debug, Eq)
pub extend ResourceManager with @moonbitlang/core/debug.Debug::{to_repr}
pub extend ResourceManager with Eq::{not_equal, equal}

///|
/// 资源类型名称 | Resource type name
pub fn resource_type_name(typ : ResourceType) -> String {
  match typ {
    File => "FILE"
    Memory => "MEMORY"
    Network => "NETWORK"
    Handle => "HANDLE"
    Custom => "CUSTOM"
  }
}

///|
/// 默认配置 | Default config
pub fn default_resource_config() -> ResourceConfig {
  { max_resources: 100, track_size: true, leak_detection: true }
}

///|
/// 创建资源管理器 | Create resource manager
pub fn create_resource_manager(config : ResourceConfig) -> ResourceManager {
  {
    resources: [],
    config,
    stats: { total_acquired: 0, total_released: 0, total_leaked: 0, active_count: 0, total_size: 0 },
  }
}

///|
/// 获取资源 | Acquire resource
pub fn resource_acquire(
  mgr : ResourceManager,
  id : Int,
  name : String,
  typ : ResourceType,
  size : Int,
  timestamp : Int,
) -> ResourceManager {
  if mgr.resources.length() >= mgr.config.max_resources {
    return mgr
  }
  let resource = { id, name, typ, size, acquired_at: timestamp, released_at: 0, active: true }
  let new_resources = []
  for r in mgr.resources {
    new_resources.push(r)
  }
  new_resources.push(resource)
  {
    resources: new_resources,
    config: mgr.config,
    stats: {
      total_acquired: mgr.stats.total_acquired + 1,
      total_released: mgr.stats.total_released,
      total_leaked: mgr.stats.total_leaked,
      active_count: mgr.stats.active_count + 1,
      total_size: mgr.stats.total_size + size,
    },
  }
}

///|
/// 释放资源 | Release resource
pub fn resource_release(mgr : ResourceManager, id : Int, timestamp : Int) -> ResourceManager {
  let new_resources = []
  let mut released_size = 0
  let mut released = 0
  for r in mgr.resources {
    if r.id == id && r.active {
      new_resources.push({ ..r, active: false, released_at: timestamp })
      released_size = r.size
      released = released + 1
    } else {
      new_resources.push(r)
    }
  }
  {
    resources: new_resources,
    config: mgr.config,
    stats: {
      total_acquired: mgr.stats.total_acquired,
      total_released: mgr.stats.total_released + released,
      total_leaked: mgr.stats.total_leaked,
      active_count: mgr.stats.active_count - released,
      total_size: mgr.stats.total_size - released_size,
    },
  }
}

///|
/// 获取资源 | Get resource
pub fn resource_get(mgr : ResourceManager, id : Int) -> Resource? {
  for r in mgr.resources {
    if r.id == id {
      return Some(r)
    }
  }
  None
}

///|
/// 活跃资源数量 | Active resource count
pub fn resource_active_count(mgr : ResourceManager) -> Int {
  let mut count = 0
  for r in mgr.resources {
    if r.active {
      count = count + 1
    }
  }
  count
}

///|
/// 资源总数 | Total resource count
pub fn resource_total_count(mgr : ResourceManager) -> Int {
  mgr.resources.length()
}

///|
/// 活跃资源总大小 | Total active size
pub fn resource_total_size(mgr : ResourceManager) -> Int {
  let mut total = 0
  for r in mgr.resources {
    if r.active {
      total = total + r.size
    }
  }
  total
}

///|
/// 检查泄漏 | Check for leaks
pub fn resource_check_leaks(mgr : ResourceManager) -> Array[Resource] {
  let result = []
  for r in mgr.resources {
    if r.active {
      result.push(r)
    }
  }
  result
}

///|
/// 泄漏数量 | Leak count
pub fn resource_leak_count(mgr : ResourceManager) -> Int {
  let mut count = 0
  for r in mgr.resources {
    if r.active {
      count = count + 1
    }
  }
  count
}

///|
/// 按类型过滤 | Filter by type
pub fn resource_filter_by_type(mgr : ResourceManager, typ : ResourceType) -> Array[Resource] {
  let result = []
  for r in mgr.resources {
    if r.typ == typ {
      result.push(r)
    }
  }
  result
}

///|
/// 按活跃状态过滤 | Filter by active status
pub fn resource_filter_active(mgr : ResourceManager) -> Array[Resource] {
  let result = []
  for r in mgr.resources {
    if r.active {
      result.push(r)
    }
  }
  result
}

///|
/// 按已释放状态过滤 | Filter by released status
pub fn resource_filter_released(mgr : ResourceManager) -> Array[Resource] {
  let result = []
  for r in mgr.resources {
    if !r.active {
      result.push(r)
    }
  }
  result
}

///|
/// 是否存在资源 | Has resource
pub fn resource_has(mgr : ResourceManager, id : Int) -> Bool {
  for r in mgr.resources {
    if r.id == id {
      return true
    }
  }
  false
}

///|
/// 资源是否活跃 | Is resource active
pub fn resource_is_active(mgr : ResourceManager, id : Int) -> Bool {
  for r in mgr.resources {
    if r.id == id && r.active {
      return true
    }
  }
  false
}

///|
/// 资源统计 | Resource statistics
pub fn resource_stats(mgr : ResourceManager) -> ResourceStats {
  mgr.stats
}

///|
/// 强制释放所有活跃资源 | Force release all active resources
pub fn resource_release_all(mgr : ResourceManager, timestamp : Int) -> ResourceManager {
  let new_resources = []
  let mut released = 0
  let mut released_size = 0
  for r in mgr.resources {
    if r.active {
      new_resources.push({ ..r, active: false, released_at: timestamp })
      released = released + 1
      released_size = released_size + r.size
    } else {
      new_resources.push(r)
    }
  }
  {
    resources: new_resources,
    config: mgr.config,
    stats: {
      total_acquired: mgr.stats.total_acquired,
      total_released: mgr.stats.total_released + released,
      total_leaked: mgr.stats.total_leaked,
      active_count: 0,
      total_size: mgr.stats.total_size - released_size,
    },
  }
}

///|
/// 合并资源管理器 | Merge resource managers
pub fn merge_resource_managers(m1 : ResourceManager, m2 : ResourceManager) -> ResourceManager {
  let new_resources = []
  for r in m1.resources {
    new_resources.push(r)
  }
  for r in m2.resources {
    new_resources.push(r)
  }
  {
    resources: new_resources,
    config: m1.config,
    stats: {
      total_acquired: m1.stats.total_acquired + m2.stats.total_acquired,
      total_released: m1.stats.total_released + m2.stats.total_released,
      total_leaked: m1.stats.total_leaked + m2.stats.total_leaked,
      active_count: m1.stats.active_count + m2.stats.active_count,
      total_size: m1.stats.total_size + m2.stats.total_size,
    },
  }
}

///|
/// 资源版本 | Resource version
pub fn resource_version() -> String {
  "moon-cross resource v0.2.19"
}

///|
/// Resource 实现 Named trait | Resource implements Named
pub impl @trait.Named for Resource with name(self) {
  self.name
}
pub extend Resource with @trait.Named::{name}