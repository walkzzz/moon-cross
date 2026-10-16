test "memento_create" {
  let m = @memento.memento_create("state1", 42)
  assert_eq(m.state, "state1")
  assert_eq(m.value, 42)
}

test "originator_create" {
  let o = @memento.originator_create("init", 0)
  assert_eq(o.state, "init")
  assert_eq(o.value, 0)
}

test "originator_save" {
  let o = @memento.originator_create("running", 100)
  let m = @memento.originator_save(o)
  assert_eq(m.state, "running")
  assert_eq(m.value, 100)
}

test "originator_restore" {
  let o = @memento.originator_create("old", 0)
  let m = @memento.memento_create("new", 99)
  let o2 = @memento.originator_restore(o, m)
  assert_eq(o2.state, "new")
  assert_eq(o2.value, 99)
}

test "caretaker_create" {
  let ck = @memento.caretaker_create()
  assert_eq(@memento.caretaker_size(ck), 0)
  assert_eq(@memento.caretaker_position(ck), -1)
}

test "caretaker_save" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  assert_eq(@memento.caretaker_size(ck1), 1)
  assert_eq(@memento.caretaker_position(ck1), 0)
}

test "caretaker_undo" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  let ck2 = @memento.caretaker_save(ck1, @memento.memento_create("s2", 2))
  let ck3 = @memento.caretaker_undo(ck2)
  assert_true(ck3 is Some(_))
  match ck3 {
    Some(c) => assert_eq(@memento.caretaker_position(c), 0)
    None => assert_true(false)
  }
}

test "caretaker_redo" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  let ck2 = @memento.caretaker_save(ck1, @memento.memento_create("s2", 2))
  let ck3 = @memento.caretaker_undo(ck2)
  match ck3 {
    Some(c3) => {
      let ck4 = @memento.caretaker_redo(c3)
      match ck4 {
        Some(c4) => assert_eq(@memento.caretaker_position(c4), 1)
        None => assert_true(false)
      }
    }
    None => assert_true(false)
  }
}

test "caretaker_undo_at_start" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  let result = @memento.caretaker_undo(ck1)
  assert_true(result is None)
}

test "caretaker_redo_at_end" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  let result = @memento.caretaker_redo(ck1)
  assert_true(result is None)
}

test "caretaker_current" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  let m = @memento.caretaker_current(ck1)
  match m {
    Some(memento) => assert_eq(memento.value, 1)
    None => assert_true(false)
  }
}

test "caretaker_save_truncates_redo" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("s1", 1))
  let ck2 = @memento.caretaker_save(ck1, @memento.memento_create("s2", 2))
  let ck3 = @memento.caretaker_undo(ck2)
  match ck3 {
    Some(c3) => {
      let ck4 = @memento.caretaker_save(c3, @memento.memento_create("s3", 3))
      assert_eq(@memento.caretaker_size(ck4), 2)
      assert_eq(@memento.caretaker_position(ck4), 1)
    }
    None => assert_true(false)
  }
}

test "caretaker_size_and_position" {
  let ck = @memento.caretaker_create()
  let ck1 = @memento.caretaker_save(ck, @memento.memento_create("a", 1))
  let ck2 = @memento.caretaker_save(ck1, @memento.memento_create("b", 2))
  let ck3 = @memento.caretaker_save(ck2, @memento.memento_create("c", 3))
  assert_eq(@memento.caretaker_size(ck3), 3)
  assert_eq(@memento.caretaker_position(ck3), 2)
}

test "memento_version" {
  let v = @memento.memento_version()
  assert_true(v.contains("memento"))
}