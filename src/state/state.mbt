///|
/// 状态 | State
pub(all) struct State {
  name : String
  is_initial : Bool
  is_final : Bool
} derive(Debug, Eq)
pub extend State with @moonbitlang/core/debug.Debug::{to_repr}
pub extend State with Eq::{not_equal, equal}

///|
/// 状态转换 | State transition
pub(all) struct Transition {
  from_state : String
  to_state : String
  event : String
} derive(Debug, Eq)
pub extend Transition with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Transition with Eq::{not_equal, equal}

///|
/// 状态机统计 | State machine statistics
pub(all) struct StateMachineStats {
  transitions_count : Int
  states_visited_count : Int
} derive(Debug, Eq)
pub extend StateMachineStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StateMachineStats with Eq::{not_equal, equal}

///|
/// 状态机 | State machine
pub(all) struct StateMachine {
  states : Array[State]
  transitions : Array[Transition]
  current_state : String
  history : Array[String]
  started : Bool
  stats : StateMachineStats
} derive(Debug, Eq)
pub extend StateMachine with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StateMachine with Eq::{not_equal, equal}

///|
/// 创建状态 | Create state
pub fn make_state(name : String) -> State {
  { name, is_initial: false, is_final: false }
}

///|
/// 创建初始状态 | Create initial state
pub fn make_initial_state(name : String) -> State {
  { name, is_initial: true, is_final: false }
}

///|
/// 创建终态 | Create final state
pub fn make_final_state(name : String) -> State {
  { name, is_initial: false, is_final: true }
}

///|
/// 创建转换 | Create transition
pub fn make_transition(
  from_state : String,
  to_state : String,
  event : String,
) -> Transition {
  { from_state, to_state, event }
}

///|
/// 创建状态机 | Create state machine
pub fn create_state_machine() -> StateMachine {
  {
    states: [],
    transitions: [],
    current_state: "",
    history: [],
    started: false,
    stats: { transitions_count: 0, states_visited_count: 0 },
  }
}

///|
/// 添加状态 | Add state
pub fn sm_add_state(sm : StateMachine, state : State) -> StateMachine {
  let new_states = []
  for s in sm.states {
    new_states.push(s)
  }
  new_states.push(state)
  { ..sm, states: new_states }
}

///|
/// 添加转换 | Add transition
pub fn sm_add_transition(sm : StateMachine, transition : Transition) -> StateMachine {
  let new_transitions = []
  for t in sm.transitions {
    new_transitions.push(t)
  }
  new_transitions.push(transition)
  { ..sm, transitions: new_transitions }
}

///|
/// 启动状态机 | Start state machine
pub fn sm_start(sm : StateMachine) -> StateMachine {
  let mut initial = ""
  for s in sm.states {
    if s.is_initial {
      initial = s.name
      break
    }
  }
  let new_history = []
  new_history.push(initial)
  {
    ..sm,
    current_state: initial,
    history: new_history,
    started: true,
    stats: { transitions_count: 0, states_visited_count: 1 },
  }
}

///|
/// 触发事件 | Trigger event
pub fn sm_trigger(sm : StateMachine, event : String) -> StateMachine {
  if !sm.started {
    return sm
  }
  let mut target = ""
  let mut found = false
  for t in sm.transitions {
    if t.from_state == sm.current_state && t.event == event {
      target = t.to_state
      found = true
      break
    }
  }
  if !found {
    return sm
  }
  let new_history = []
  for h in sm.history {
    new_history.push(h)
  }
  new_history.push(target)
  {
    ..sm,
    current_state: target,
    history: new_history,
    stats: {
      transitions_count: sm.stats.transitions_count + 1,
      states_visited_count: sm.stats.states_visited_count + 1,
    },
  }
}

///|
/// 当前状态 | Current state
pub fn sm_current_state(sm : StateMachine) -> String {
  sm.current_state
}

///|
/// 是否已启动 | Is started
pub fn sm_is_started(sm : StateMachine) -> Bool {
  sm.started
}

///|
/// 状态历史 | State history
pub fn sm_history(sm : StateMachine) -> Array[String] {
  sm.history
}

///|
/// 是否可转换 | Can transition
pub fn sm_can_transition(sm : StateMachine, event : String) -> Bool {
  for t in sm.transitions {
    if t.from_state == sm.current_state && t.event == event {
      return true
    }
  }
  false
}

///|
/// 是否处于终态 | Is in final state
pub fn sm_is_final(sm : StateMachine) -> Bool {
  for s in sm.states {
    if s.name == sm.current_state && s.is_final {
      return true
    }
  }
  false
}

///|
/// 重置状态机 | Reset state machine
pub fn sm_reset(sm : StateMachine) -> StateMachine {
  sm_start(sm)
}

///|
/// 状态是否存在 | State exists
pub fn sm_state_exists(sm : StateMachine, name : String) -> Bool {
  for s in sm.states {
    if s.name == name {
      return true
    }
  }
  false
}

///|
/// 获取状态 | Get state by name
pub fn sm_get_state(sm : StateMachine, name : String) -> State? {
  for s in sm.states {
    if s.name == name {
      return Some(s)
    }
  }
  None
}

///|
/// 有效事件列表 | Valid events from current state
pub fn sm_valid_events(sm : StateMachine) -> Array[String] {
  let result = []
  for t in sm.transitions {
    if t.from_state == sm.current_state {
      result.push(t.event)
    }
  }
  result
}

///|
/// 所有状态名 | All state names
pub fn sm_state_names(sm : StateMachine) -> Array[String] {
  let result = []
  for s in sm.states {
    result.push(s.name)
  }
  result
}

///|
/// 所有转换 | All transitions
pub fn sm_transitions(sm : StateMachine) -> Array[Transition] {
  sm.transitions
}

///|
/// 状态机统计 | State machine statistics
pub fn sm_stats(sm : StateMachine) -> StateMachineStats {
  sm.stats
}

///|
/// 历史长度 | History length
pub fn sm_history_length(sm : StateMachine) -> Int {
  sm.history.length()
}

///|
/// 合并状态机 | Merge state machines
pub fn merge_state_machines(sm1 : StateMachine, sm2 : StateMachine) -> StateMachine {
  let new_states = []
  for s in sm1.states {
    new_states.push(s)
  }
  for s in sm2.states {
    new_states.push(s)
  }
  let new_transitions = []
  for t in sm1.transitions {
    new_transitions.push(t)
  }
  for t in sm2.transitions {
    new_transitions.push(t)
  }
  {
    states: new_states,
    transitions: new_transitions,
    current_state: sm1.current_state,
    history: sm1.history,
    started: sm1.started,
    stats: sm1.stats,
  }
}

///|
/// 状态机版本 | State machine version
pub fn sm_version() -> String {
  "moon-cross state v0.2.14"
}

///|
/// State 实现 Named trait | State implements Named
pub impl @trait.Named for State with name(self) {
  self.name
}
pub extend State with @trait.Named::{name}

///|
/// StateMachine 实现 Resettable trait | StateMachine implements Resettable
pub impl @trait.Resettable for StateMachine with reset(self) {
  sm_reset(self)
}
pub extend StateMachine with @trait.Resettable::{reset}