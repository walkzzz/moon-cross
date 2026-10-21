///|
/// 交通灯状态 | Traffic light state
pub(all) enum TrafficLight {
  Red
  Yellow
  Green
} derive(Debug, Eq)
pub extend TrafficLight with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TrafficLight with Eq::{not_equal, equal}

///|
/// 状态上下文 | State context
pub(all) struct StateContext {
  light : TrafficLight
  transitions : Int
} derive(Debug, Eq)
pub extend StateContext with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StateContext with Eq::{not_equal, equal}

///|
/// 创建状态上下文 | Create state context
pub fn state_create() -> StateContext {
  { light: Red, transitions: 0, }
}

///|
/// 处理状态转换 | Handle state transition
pub fn state_handle(ctx : StateContext) -> StateContext {
  let next = match ctx.light {
    Red => Green
    Green => Yellow
    Yellow => Red
  }
  { light: next, transitions: ctx.transitions + 1, }
}

///|
/// 获取状态名称 | Get state name
pub fn state_name(light : TrafficLight) -> String {
  match light {
    Red => "red"
    Green => "green"
    Yellow => "yellow"
  }
}

///|
/// 是否可以转换 | Can transition
pub fn state_can_transition(from : TrafficLight, to : TrafficLight) -> Bool {
  match (from, to) {
    (Red, Green) => true
    (Green, Yellow) => true
    (Yellow, Red) => true
    _ => false
  }
}

///|
/// 重置状态 | Reset state
pub fn state_reset(_ctx : StateContext) -> StateContext {
  { light: Red, transitions: 0, }
}

///|
/// 转换次数 | Transition count
pub fn state_transitions_count(ctx : StateContext) -> Int {
  ctx.transitions
}

///|
/// 状态是否有效 | Is valid state
pub fn state_is_valid(light : TrafficLight) -> Bool {
  match light {
    Red => true
    Green => true
    Yellow => true
  }
}

///|
/// 状态模式版本 | State pattern version
pub fn state_pattern_version() -> String {
  "moon-cross state_pattern v0.3.8"
}

///|
/// StateContext 实现 Resettable trait | StateContext implements Resettable
pub impl @trait.Resettable for StateContext with reset(self) {
  state_reset(self)
}
pub extend StateContext with @trait.Resettable::{reset}