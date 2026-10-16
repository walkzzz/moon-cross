///|
/// 信号类型 | Signal type
pub(all) enum SignalType {
  User
  System
  Interrupt
  Error
  Custom
} derive(Debug, Eq)
pub extend SignalType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SignalType with Eq::{not_equal, equal}

///|
/// 信号 | Signal
pub(all) struct Signal {
  id : Int
  name : String
  typ : SignalType
  data : String
  timestamp : Int
  priority : Int
} derive(Debug, Eq)
pub extend Signal with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Signal with Eq::{not_equal, equal}

///|
/// 信号处理器 | Signal handler
pub(all) struct SignalHandler {
  id : Int
  signal_name : String
  handler_name : String
  priority : Int
  active : Bool
  call_count : Int
} derive(Debug, Eq)
pub extend SignalHandler with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SignalHandler with Eq::{not_equal, equal}

///|
/// 信号统计 | Signal statistics
pub(all) struct SignalStats {
  total_sent : Int
  total_handled : Int
  total_dropped : Int
  handler_count : Int
} derive(Debug, Eq)
pub extend SignalStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SignalStats with Eq::{not_equal, equal}

///|
/// 信号管理器 | Signal manager
pub(all) struct SignalManager {
  handlers : Array[SignalHandler]
  history : Array[Signal]
  stats : SignalStats
} derive(Debug, Eq)
pub extend SignalManager with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SignalManager with Eq::{not_equal, equal}

///|
/// 信号类型名称 | Signal type name
pub fn signal_type_name(typ : SignalType) -> String {
  match typ {
    User => "USER"
    System => "SYSTEM"
    Interrupt => "INTERRUPT"
    Error => "ERROR"
    Custom => "CUSTOM"
  }
}

///|
/// 创建信号 | Create signal
pub fn make_signal(id : Int, name : String, typ : SignalType, data : String, timestamp : Int) -> Signal {
  { id, name, typ, data, timestamp, priority: 0 }
}

///|
/// 创建带优先级的信号 | Create signal with priority
pub fn make_signal_with_priority(
  id : Int,
  name : String,
  typ : SignalType,
  data : String,
  timestamp : Int,
  priority : Int,
) -> Signal {
  { id, name, typ, data, timestamp, priority }
}

///|
/// 创建信号管理器 | Create signal manager
pub fn create_signal_manager() -> SignalManager {
  { handlers: [], history: [], stats: { total_sent: 0, total_handled: 0, total_dropped: 0, handler_count: 0 } }
}

///|
/// 注册处理器 | Register handler
pub fn signal_register(
  mgr : SignalManager,
  id : Int,
  signal_name : String,
  handler_name : String,
  priority : Int,
) -> SignalManager {
  let handler = { id, signal_name, handler_name, priority, active: true, call_count: 0 }
  let new_handlers = []
  for h in mgr.handlers {
    new_handlers.push(h)
  }
  new_handlers.push(handler)
  {
    handlers: new_handlers,
    history: mgr.history,
    stats: {
      total_sent: mgr.stats.total_sent,
      total_handled: mgr.stats.total_handled,
      total_dropped: mgr.stats.total_dropped,
      handler_count: mgr.stats.handler_count + 1,
    },
  }
}

///|
/// 注销处理器 | Unregister handler
pub fn signal_unregister(mgr : SignalManager, id : Int) -> SignalManager {
  let remaining = []
  let mut removed = 0
  for h in mgr.handlers {
    if h.id == id {
      removed = removed + 1
    } else {
      remaining.push(h)
    }
  }
  {
    handlers: remaining,
    history: mgr.history,
    stats: {
      total_sent: mgr.stats.total_sent,
      total_handled: mgr.stats.total_handled,
      total_dropped: mgr.stats.total_dropped,
      handler_count: mgr.stats.handler_count - removed,
    },
  }
}

///|
/// 发送信号 | Send signal
pub fn signal_send(mgr : SignalManager, signal : Signal) -> SignalManager {
  let mut handled = 0
  let new_handlers = []
  for h in mgr.handlers {
    if h.active && h.signal_name == signal.name {
      handled = handled + 1
      new_handlers.push({ ..h, call_count: h.call_count + 1 })
    } else {
      new_handlers.push(h)
    }
  }
  let new_history = []
  for s in mgr.history {
    new_history.push(s)
  }
  new_history.push(signal)
  let dropped = if handled == 0 { 1 } else { 0 }
  {
    handlers: new_handlers,
    history: new_history,
    stats: {
      total_sent: mgr.stats.total_sent + 1,
      total_handled: mgr.stats.total_handled + handled,
      total_dropped: mgr.stats.total_dropped + dropped,
      handler_count: mgr.stats.handler_count,
    },
  }
}

///|
/// 批量发送信号 | Batch send signals
pub fn signal_batch_send(mgr : SignalManager, signals : Array[Signal]) -> SignalManager {
  let mut current = mgr
  for s in signals {
    current = signal_send(current, s)
  }
  current
}

///|
/// 禁用处理器 | Disable handler
pub fn signal_disable_handler(mgr : SignalManager, id : Int) -> SignalManager {
  let new_handlers = []
  for h in mgr.handlers {
    if h.id == id {
      new_handlers.push({ ..h, active: false })
    } else {
      new_handlers.push(h)
    }
  }
  { ..mgr, handlers: new_handlers }
}

///|
/// 启用处理器 | Enable handler
pub fn signal_enable_handler(mgr : SignalManager, id : Int) -> SignalManager {
  let new_handlers = []
  for h in mgr.handlers {
    if h.id == id {
      new_handlers.push({ ..h, active: true })
    } else {
      new_handlers.push(h)
    }
  }
  { ..mgr, handlers: new_handlers }
}

///|
/// 处理器数量 | Handler count
pub fn signal_handler_count(mgr : SignalManager) -> Int {
  mgr.handlers.length()
}

///|
/// 活跃处理器数量 | Active handler count
pub fn signal_active_handler_count(mgr : SignalManager) -> Int {
  let mut count = 0
  for h in mgr.handlers {
    if h.active {
      count = count + 1
    }
  }
  count
}

///|
/// 是否有处理器 | Has handler
pub fn signal_has_handler(mgr : SignalManager, signal_name : String) -> Bool {
  for h in mgr.handlers {
    if h.signal_name == signal_name && h.active {
      return true
    }
  }
  false
}

///|
/// 信号历史 | Signal history
pub fn signal_history(mgr : SignalManager) -> Array[Signal] {
  mgr.history
}

///|
/// 历史数量 | History count
pub fn signal_history_count(mgr : SignalManager) -> Int {
  mgr.history.length()
}

///|
/// 按名称过滤历史 | Filter history by name
pub fn signal_filter_by_name(mgr : SignalManager, name : String) -> Array[Signal] {
  let result = []
  for s in mgr.history {
    if s.name == name {
      result.push(s)
    }
  }
  result
}

///|
/// 按类型过滤历史 | Filter history by type
pub fn signal_filter_by_type(mgr : SignalManager, typ : SignalType) -> Array[Signal] {
  let result = []
  for s in mgr.history {
    if s.typ == typ {
      result.push(s)
    }
  }
  result
}

///|
/// 清空历史 | Clear history
pub fn signal_clear_history(mgr : SignalManager) -> SignalManager {
  { ..mgr, history: [] }
}

///|
/// 信号统计 | Signal statistics
pub fn signal_stats(mgr : SignalManager) -> SignalStats {
  mgr.stats
}

///|
/// 获取处理器的调用次数 | Get handler call count
pub fn signal_handler_call_count(mgr : SignalManager, id : Int) -> Int {
  for h in mgr.handlers {
    if h.id == id {
      return h.call_count
    }
  }
  0
}

///|
/// 获取信号名称的处理器 | Get handlers for signal name
pub fn signal_handlers_for(mgr : SignalManager, signal_name : String) -> Array[SignalHandler] {
  let result = []
  for h in mgr.handlers {
    if h.signal_name == signal_name {
      result.push(h)
    }
  }
  result
}

///|
/// 合并信号管理器 | Merge signal managers
pub fn merge_signal_managers(m1 : SignalManager, m2 : SignalManager) -> SignalManager {
  let new_handlers = []
  for h in m1.handlers {
    new_handlers.push(h)
  }
  for h in m2.handlers {
    new_handlers.push(h)
  }
  let new_history = []
  for s in m1.history {
    new_history.push(s)
  }
  for s in m2.history {
    new_history.push(s)
  }
  {
    handlers: new_handlers,
    history: new_history,
    stats: {
      total_sent: m1.stats.total_sent + m2.stats.total_sent,
      total_handled: m1.stats.total_handled + m2.stats.total_handled,
      total_dropped: m1.stats.total_dropped + m2.stats.total_dropped,
      handler_count: m1.stats.handler_count + m2.stats.handler_count,
    },
  }
}

///|
/// 信号版本 | Signal version
pub fn signal_version() -> String {
  "moon-cross signal v0.2.16"
}