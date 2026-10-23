///|
/// 备忘录 | Memento
pub(all) struct Memento {
  state : String
  value : Int
} derive(Debug, Eq)
pub extend Memento with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Memento with Eq::{not_equal, equal}

///|
/// 原发器 | Originator
pub(all) struct Originator {
  state : String
  value : Int
} derive(Debug, Eq)
pub extend Originator with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Originator with Eq::{not_equal, equal}

///|
/// 管理者 | Caretaker
pub(all) struct Caretaker {
  mementos : Array[Memento]
  current : Int
} derive(Debug, Eq)
pub extend Caretaker with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Caretaker with Eq::{not_equal, equal}

///|
/// 创建备忘录 | Create memento
pub fn memento_create(state : String, value : Int) -> Memento {
  { state, value, }
}

///|
/// 创建原发器 | Create originator
pub fn originator_create(state : String, value : Int) -> Originator {
  { state, value, }
}

///|
/// 保存状态到备忘录 | Save state to memento
pub fn originator_save(o : Originator) -> Memento {
  { state: o.state, value: o.value, }
}

///|
/// 从备忘录恢复 | Restore from memento
pub fn originator_restore(_o : Originator, m : Memento) -> Originator {
  { state: m.state, value: m.value, }
}

///|
/// 创建管理者 | Create caretaker
pub fn caretaker_create() -> Caretaker {
  { mementos: [], current: -1, }
}

///|
/// 保存备忘录 | Save memento
pub fn caretaker_save(ck : Caretaker, m : Memento) -> Caretaker {
  let mementos = []
  for i in 0..=ck.current {
    mementos.push(ck.mementos[i])
  }
  mementos.push(m)
  { mementos, current: ck.current + 1, }
}

///|
/// 撤销 | Undo
pub fn caretaker_undo(ck : Caretaker) -> Caretaker? {
  if ck.current <= 0 {
    return None
  }
  Some({ mementos: ck.mementos, current: ck.current - 1, })
}

///|
/// 重做 | Redo
pub fn caretaker_redo(ck : Caretaker) -> Caretaker? {
  if ck.current >= ck.mementos.length() - 1 {
    return None
  }
  Some({ mementos: ck.mementos, current: ck.current + 1, })
}

///|
/// 获取当前备忘录 | Get current memento
pub fn caretaker_current(ck : Caretaker) -> Memento? {
  if ck.current < 0 || ck.current >= ck.mementos.length() {
    return None
  }
  Some(ck.mementos[ck.current])
}

///|
/// 备忘录数量 | Memento count
pub fn caretaker_size(ck : Caretaker) -> Int {
  ck.mementos.length()
}

///|
/// 当前位置 | Current position
pub fn caretaker_position(ck : Caretaker) -> Int {
  ck.current
}

///|
/// 备忘录版本 | Memento version
pub fn memento_version() -> String {
  "moon-cross memento v0.3.8"
}

///|
/// Caretaker 实现 Countable trait | Caretaker implements Countable
pub impl @trait.Countable for Caretaker with count(self) {
  self.mementos.length()
}
pub extend Caretaker with @trait.Countable::{count}

///|
/// Caretaker 实现 Iterable trait | Caretaker implements Iterable
pub impl @trait.Iterable for Caretaker with iter_count(self) {
  self.mementos.length()
}
pub extend Caretaker with @trait.Iterable::{iter_count}