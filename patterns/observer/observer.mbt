///|
/// 观察者 | Observer
pub(all) struct Observer {
  id : Int
  name : String
  active : Bool
} derive(Debug, Eq)
pub extend Observer with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Observer with Eq::{not_equal, equal}

///|
/// 主题 | Subject
pub(all) struct Subject {
  observers : Array[Observer]
  state : String
  next_id : Int
} derive(Debug, Eq)
pub extend Subject with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Subject with Eq::{not_equal, equal}

///|
/// 事件 | Event
pub(all) struct Event {
  name : String
  data : String
  timestamp : Int
} derive(Debug, Eq)
pub extend Event with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Event with Eq::{not_equal, equal}

///|
/// 创建主题 | Create subject
pub fn subject_create() -> Subject {
  { observers: [], state: "", next_id: 0 }
}

///|
/// 注册观察者 | Attach observer
pub fn subject_attach(sub : Subject, name : String) -> (Subject, Observer) {
  let observer = { id: sub.next_id, name, active: true }
  let new_observers = []
  for o in sub.observers {
    new_observers.push(o)
  }
  new_observers.push(observer)
  ({ observers: new_observers, state: sub.state, next_id: sub.next_id + 1 }, observer)
}

///|
/// 注销观察者 | Detach observer
pub fn subject_detach(sub : Subject, observer_id : Int) -> Subject {
  let new_observers = []
  for o in sub.observers {
    if o.id != observer_id {
      new_observers.push(o)
    }
  }
  { observers: new_observers, state: sub.state, next_id: sub.next_id }
}

///|
/// 激活/停用观察者 | Toggle observer
pub fn subject_set_active(sub : Subject, observer_id : Int, active : Bool) -> Subject {
  let new_observers = []
  for o in sub.observers {
    if o.id == observer_id {
      new_observers.push({ id: o.id, name: o.name, active })
    } else {
      new_observers.push(o)
    }
  }
  { observers: new_observers, state: sub.state, next_id: sub.next_id }
}

///|
/// 设置状态 | Set state
pub fn subject_set_state(sub : Subject, state : String) -> Subject {
  { observers: sub.observers, state, next_id: sub.next_id }
}

///|
/// 通知活跃观察者 | Notify active observers
pub fn subject_notify(sub : Subject, event : Event) -> Array[(Observer, Event)] {
  let result = []
  for o in sub.observers {
    if o.active {
      result.push((o, event))
    }
  }
  result
}

///|
/// 观察者数量 | Observer count
pub fn subject_observer_count(sub : Subject) -> Int {
  sub.observers.length()
}

///|
/// 活跃观察者数量 | Active observer count
pub fn subject_active_count(sub : Subject) -> Int {
  let mut count = 0
  for o in sub.observers {
    if o.active {
      count = count + 1
    }
  }
  count
}

///|
/// 创建事件 | Create event
pub fn event_create(name : String, data : String, timestamp : Int) -> Event {
  { name, data, timestamp }
}

///|
/// 观察者版本 | Observer version
pub fn observer_version() -> String {
  "moon-cross observer v0.3.1"
}

///|
/// Observer 实现 Named trait | Observer implements Named
pub impl @trait.Named for Observer with name(self) {
  self.name
}
pub extend Observer with @trait.Named::{name}

///|
/// Event 实现 Named trait | Event implements Named
pub impl @trait.Named for Event with name(self) {
  self.name
}
pub extend Event with @trait.Named::{name}

///|
/// Observer 实现 Hashable trait | Observer implements Hashable
pub impl @trait.Hashable for Observer with hash(self) {
  @trait.Named::name(self).length()
}
pub extend Observer with @trait.Hashable::{hash}

///|
/// Event 实现 Hashable trait | Event implements Hashable
pub impl @trait.Hashable for Event with hash(self) {
  @trait.Named::name(self).length()
}
pub extend Event with @trait.Hashable::{hash}