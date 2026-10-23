test "command_create" {
  let cmd = @command.command_create("copy", "file.txt")
  assert_eq(cmd.name, "copy")
  assert_eq(cmd.args, "file.txt")
  assert_false(cmd.executed)
}

test "history_create" {
  let h = @command.history_create()
  assert_eq(@command.history_size(h), 0)
}

test "history_execute" {
  let h = @command.history_create()
  let (h1, cmd) = @command.history_execute(h, "copy", "data")
  assert_eq(@command.history_size(h1), 1)
  assert_true(cmd.executed)
}

test "history_execute_multiple" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "a", "1")
  let (h2, _) = @command.history_execute(h1, "b", "2")
  let (h3, _) = @command.history_execute(h2, "c", "3")
  assert_eq(@command.history_size(h3), 3)
}

test "history_undo" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "copy", "data")
  let (h2, undone) = @command.history_undo(h1)
  assert_eq(@command.history_size(h2), 0)
  assert_true(undone is Some(_))
}

test "history_undo_empty" {
  let h = @command.history_create()
  let (_, undone) = @command.history_undo(h)
  assert_true(undone is None)
}

test "history_redo" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "copy", "data")
  let (h2, _) = @command.history_undo(h1)
  let (h3, redone) = @command.history_redo(h2)
  assert_eq(@command.history_size(h3), 1)
  assert_true(redone is Some(_))
}

test "history_redo_empty" {
  let h = @command.history_create()
  let (_, redone) = @command.history_redo(h)
  assert_true(redone is None)
}

test "history_undo_redo_sequence" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "a", "1")
  let (h2, _) = @command.history_execute(h1, "b", "2")
  let (h3, _) = @command.history_undo(h2)
  assert_eq(@command.history_size(h3), 1)
  let (h4, _) = @command.history_undo(h3)
  assert_eq(@command.history_size(h4), 0)
  let (h5, _) = @command.history_redo(h4)
  assert_eq(@command.history_size(h5), 1)
}

test "history_undoable_count" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "a", "1")
  let (h2, _) = @command.history_execute(h1, "b", "2")
  assert_eq(@command.history_undoable_count(h2), 2)
}

test "history_redoable_count" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "a", "1")
  let (h2, _) = @command.history_undo(h1)
  assert_eq(@command.history_redoable_count(h2), 1)
}

test "history_clear" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "a", "1")
  let (h2, _) = @command.history_execute(h1, "b", "2")
  let h3 = @command.history_clear(h2)
  assert_eq(@command.history_size(h3), 0)
}

test "history_execute_after_undo" {
  let h = @command.history_create()
  let (h1, _) = @command.history_execute(h, "a", "1")
  let (h2, _) = @command.history_undo(h1)
  let (h3, _) = @command.history_execute(h2, "b", "2")
  assert_eq(@command.history_size(h3), 1)
  assert_eq(@command.history_redoable_count(h3), 0)
}

test "command_version" {
  let v = @command.command_version()
  assert_true(v.contains("command"))
}
