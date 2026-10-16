///|
/// 命令 | Command
pub(all) struct Command {
  id : Int
  name : String
  args : String
  executed : Bool
} derive(Debug, Eq)
pub extend Command with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Command with Eq::{not_equal, equal}

///|
/// 命令历史 | Command history
pub(all) struct CommandHistory {
  commands : Array[Command]
  undone : Array[Command]
  next_id : Int
} derive(Debug, Eq)
pub extend CommandHistory with @moonbitlang/core/debug.Debug::{to_repr}
pub extend CommandHistory with Eq::{not_equal, equal}

///|
/// 创建历史 | Create history
pub fn history_create() -> CommandHistory {
  { commands: [], undone: [], next_id: 0 }
}

///|
/// 创建命令 | Create command
pub fn command_create(name : String, args : String) -> Command {
  { id: 0, name, args, executed: false }
}

///|
/// 执行命令 | Execute command
pub fn history_execute(h : CommandHistory, name : String, args : String) -> (CommandHistory, Command) {
  let cmd = { id: h.next_id, name, args, executed: true }
  let new_commands = []
  for c in h.commands {
    new_commands.push(c)
  }
  new_commands.push(cmd)
  ({ commands: new_commands, undone: [], next_id: h.next_id + 1 }, cmd)
}

///|
/// 撤销命令 | Undo command
pub fn history_undo(h : CommandHistory) -> (CommandHistory, Command?) {
  let len = h.commands.length()
  if len == 0 {
    return (h, None)
  }
  let cmd = h.commands[len - 1]
  let new_commands = []
  let mut i = 0
  while i < len - 1 {
    new_commands.push(h.commands[i])
    i = i + 1
  }
  let new_undone = []
  for u in h.undone {
    new_undone.push(u)
  }
  new_undone.push(cmd)
  ({ commands: new_commands, undone: new_undone, next_id: h.next_id }, Some(cmd))
}

///|
/// 重做命令 | Redo command
pub fn history_redo(h : CommandHistory) -> (CommandHistory, Command?) {
  let len = h.undone.length()
  if len == 0 {
    return (h, None)
  }
  let cmd = h.undone[len - 1]
  let new_undone = []
  let mut i = 0
  while i < len - 1 {
    new_undone.push(h.undone[i])
    i = i + 1
  }
  let new_commands = []
  for c in h.commands {
    new_commands.push(c)
  }
  new_commands.push(cmd)
  ({ commands: new_commands, undone: new_undone, next_id: h.next_id }, Some(cmd))
}

///|
/// 历史大小 | History size
pub fn history_size(h : CommandHistory) -> Int {
  h.commands.length()
}

///|
/// 可撤销数量 | Undoable count
pub fn history_undoable_count(h : CommandHistory) -> Int {
  h.commands.length()
}

///|
/// 可重做数量 | Redoable count
pub fn history_redoable_count(h : CommandHistory) -> Int {
  h.undone.length()
}

///|
/// 清空历史 | Clear history
pub fn history_clear(_h : CommandHistory) -> CommandHistory {
  { commands: [], undone: [], next_id: _h.next_id }
}

///|
/// 命令版本 | Command version
pub fn command_version() -> String {
  "moon-cross command v0.3.7"
}