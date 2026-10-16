///|
/// 事件优先级 | Event priority
pub(all) enum EventPriority {
  Low
  Normal
  High
  Critical
} derive(Debug, Eq)
pub extend EventPriority with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EventPriority with Eq::{not_equal, equal}

///|
/// 事件 | Event
pub(all) struct Event {
  name : String
  data : String
  timestamp : Int
  source : String
  priority : EventPriority
} derive(Debug, Eq)
pub extend Event with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Event with Eq::{not_equal, equal}

///|
/// 事件处理器 | Event handler
pub(all) struct EventHandler {
  id : Int
  event_name : String
  handler_name : String
  priority : EventPriority
  active : Bool
} derive(Debug, Eq)
pub extend EventHandler with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EventHandler with Eq::{not_equal, equal}

///|
/// 事件总线统计 | Event bus statistics
pub(all) struct EventBusStats {
  total_published : Int
  total_handlers : Int
  total_dispatched : Int
} derive(Debug, Eq)
pub extend EventBusStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EventBusStats with Eq::{not_equal, equal}

///|
/// 事件总线 | Event bus
pub(all) struct EventBus {
  handlers : Array[EventHandler]
  history : Array[Event]
  stats : EventBusStats
} derive(Debug, Eq)
pub extend EventBus with @moonbitlang/core/debug.Debug::{to_repr}
pub extend EventBus with Eq::{not_equal, equal}

///|
/// 优先级数值 | Priority numeric value
pub fn priority_value(priority : EventPriority) -> Int {
  match priority {
    Low => 0
    Normal => 1
    High => 2
    Critical => 3
  }
}

///|
/// 优先级名称 | Priority name
pub fn priority_name(priority : EventPriority) -> String {
  match priority {
    Low => "LOW"
    Normal => "NORMAL"
    High => "HIGH"
    Critical => "CRITICAL"
  }
}

///|
/// 从数值创建优先级 | Create priority from value
pub fn priority_from_value(value : Int) -> EventPriority {
  if value >= 3 {
    Critical
  } else if value == 2 {
    High
  } else if value == 1 {
    Normal
  } else {
    Low
  }
}

///|
/// 创建事件 | Create event
pub fn make_event(name : String, data : String, timestamp : Int) -> Event {
  { name, data, timestamp, source: "", priority: Normal }
}

///|
/// 创建带源的事件 | Create event with source
pub fn make_event_with_source(
  name : String,
  data : String,
  timestamp : Int,
  source : String,
) -> Event {
  { name, data, timestamp, source, priority: Normal }
}

///|
/// 创建带优先级的事件 | Create event with priority
pub fn make_event_with_priority(
  name : String,
  data : String,
  timestamp : Int,
  priority : EventPriority,
) -> Event {
  { name, data, timestamp, source: "", priority }
}

///|
/// 创建事件总线 | Create event bus
pub fn create_event_bus() -> EventBus {
  { handlers: [], history: [], stats: { total_published: 0, total_handlers: 0, total_dispatched: 0 } }
}

///|
/// 订阅事件 | Subscribe to event
pub fn event_subscribe(
  bus : EventBus,
  id : Int,
  event_name : String,
  handler_name : String,
  priority : EventPriority,
) -> EventBus {
  let handler = { id, event_name, handler_name, priority, active: true }
  let new_handlers = []
  for h in bus.handlers {
    new_handlers.push(h)
  }
  new_handlers.push(handler)
  {
    handlers: new_handlers,
    history: bus.history,
    stats: {
      total_published: bus.stats.total_published,
      total_handlers: bus.stats.total_handlers + 1,
      total_dispatched: bus.stats.total_dispatched,
    },
  }
}

///|
/// 取消订阅 | Unsubscribe from event
pub fn event_unsubscribe(bus : EventBus, id : Int) -> EventBus {
  let remaining = []
  let mut removed = 0
  for h in bus.handlers {
    if h.id == id {
      removed = removed + 1
    } else {
      remaining.push(h)
    }
  }
  {
    handlers: remaining,
    history: bus.history,
    stats: {
      total_published: bus.stats.total_published,
      total_handlers: bus.stats.total_handlers - removed,
      total_dispatched: bus.stats.total_dispatched,
    },
  }
}

///|
/// 发布事件 | Publish event
pub fn event_publish(bus : EventBus, event : Event) -> EventBus {
  let mut dispatched = 0
  for h in bus.handlers {
    if h.active && h.event_name == event.name {
      dispatched = dispatched + 1
    }
  }
  let new_history = []
  for e in bus.history {
    new_history.push(e)
  }
  new_history.push(event)
  {
    handlers: bus.handlers,
    history: new_history,
    stats: {
      total_published: bus.stats.total_published + 1,
      total_handlers: bus.stats.total_handlers,
      total_dispatched: bus.stats.total_dispatched + dispatched,
    },
  }
}

///|
/// 批量发布事件 | Batch publish events
pub fn event_batch_publish(bus : EventBus, events : Array[Event]) -> EventBus {
  let mut current = bus
  for e in events {
    current = event_publish(current, e)
  }
  current
}

///|
/// 获取事件历史 | Get event history
pub fn event_history(bus : EventBus) -> Array[Event] {
  bus.history
}

///|
/// 按名称过滤历史 | Filter history by name
pub fn event_filter_by_name(bus : EventBus, name : String) -> Array[Event] {
  let result = []
  for e in bus.history {
    if e.name == name {
      result.push(e)
    }
  }
  result
}

///|
/// 按优先级过滤历史 | Filter history by priority
pub fn event_filter_by_priority(
  bus : EventBus,
  priority : EventPriority,
) -> Array[Event] {
  let result = []
  for e in bus.history {
    if e.priority == priority {
      result.push(e)
    }
  }
  result
}

///|
/// 按源过滤历史 | Filter history by source
pub fn event_filter_by_source(bus : EventBus, source : String) -> Array[Event] {
  let result = []
  for e in bus.history {
    if e.source == source {
      result.push(e)
    }
  }
  result
}

///|
/// 清空历史 | Clear history
pub fn event_clear_history(bus : EventBus) -> EventBus {
  {
    handlers: bus.handlers,
    history: [],
    stats: bus.stats,
  }
}

///|
/// 处理器数量 | Handler count
pub fn event_handler_count(bus : EventBus) -> Int {
  bus.handlers.length()
}

///|
/// 活跃处理器数量 | Active handler count
pub fn event_active_handler_count(bus : EventBus) -> Int {
  let mut count = 0
  for h in bus.handlers {
    if h.active {
      count = count + 1
    }
  }
  count
}

///|
/// 是否有处理器 | Has handler for event
pub fn event_has_handler(bus : EventBus, event_name : String) -> Bool {
  for h in bus.handlers {
    if h.event_name == event_name && h.active {
      return true
    }
  }
  false
}

///|
/// 禁用处理器 | Disable handler
pub fn event_disable_handler(bus : EventBus, id : Int) -> EventBus {
  let new_handlers = []
  for h in bus.handlers {
    if h.id == id {
      new_handlers.push({ ..h, active: false })
    } else {
      new_handlers.push(h)
    }
  }
  { ..bus, handlers: new_handlers }
}

///|
/// 启用处理器 | Enable handler
pub fn event_enable_handler(bus : EventBus, id : Int) -> EventBus {
  let new_handlers = []
  for h in bus.handlers {
    if h.id == id {
      new_handlers.push({ ..h, active: true })
    } else {
      new_handlers.push(h)
    }
  }
  { ..bus, handlers: new_handlers }
}

///|
/// 获取事件名称的处理器 | Get handlers for event name
pub fn event_handlers_for(bus : EventBus, event_name : String) -> Array[EventHandler] {
  let result = []
  for h in bus.handlers {
    if h.event_name == event_name {
      result.push(h)
    }
  }
  result
}

///|
/// 事件总线统计 | Event bus statistics
pub fn event_stats(bus : EventBus) -> EventBusStats {
  bus.stats
}

///|
/// 历史数量 | History count
pub fn event_history_count(bus : EventBus) -> Int {
  bus.history.length()
}

///|
/// 合并两个事件总线 | Merge two event buses
pub fn merge_event_buses(b1 : EventBus, b2 : EventBus) -> EventBus {
  let new_handlers = []
  for h in b1.handlers {
    new_handlers.push(h)
  }
  for h in b2.handlers {
    new_handlers.push(h)
  }
  let new_history = []
  for e in b1.history {
    new_history.push(e)
  }
  for e in b2.history {
    new_history.push(e)
  }
  {
    handlers: new_handlers,
    history: new_history,
    stats: {
      total_published: b1.stats.total_published + b2.stats.total_published,
      total_handlers: b1.stats.total_handlers + b2.stats.total_handlers,
      total_dispatched: b1.stats.total_dispatched + b2.stats.total_dispatched,
    },
  }
}

///|
/// 事件版本 | Event system version
pub fn event_version() -> String {
  "moon-cross event v0.2.13"
}