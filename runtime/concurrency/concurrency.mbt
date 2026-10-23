///|
/// 互斥锁 | Mutex
pub(all) struct Mutex {
  locked : Bool
  owner : String
} derive(Debug, Eq)
pub extend Mutex with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Mutex with Eq::{not_equal, equal}

///|
/// 信号量 | Semaphore
pub(all) struct Semaphore {
  count : Int
  max : Int
} derive(Debug, Eq)
pub extend Semaphore with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Semaphore with Eq::{not_equal, equal}

///|
/// 缓冲通道 | Buffered channel
pub(all) struct Channel {
  buffer : Array[String]
  capacity : Int
  closed : Bool
} derive(Debug, Eq)
pub extend Channel with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Channel with Eq::{not_equal, equal}

///|
/// 未来值 | Future value
pub(all) struct Future {
  value : String
  completed : Bool
} derive(Debug, Eq)
pub extend Future with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Future with Eq::{not_equal, equal}

///|
/// 原子计数器 | Atomic counter
pub(all) struct AtomicCounter {
  value : Int
} derive(Debug, Eq)
pub extend AtomicCounter with @moonbitlang/core/debug.Debug::{to_repr}
pub extend AtomicCounter with Eq::{not_equal, equal}

///|
/// 任务项 | Task item
pub(all) struct Task {
  id : Int
  name : String
  priority : Int
} derive(Debug, Eq)
pub extend Task with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Task with Eq::{not_equal, equal}

///|
/// 任务队列 | Task queue
pub(all) struct TaskQueue {
  tasks : Array[Task]
  next_id : Int
} derive(Debug, Eq)
pub extend TaskQueue with @moonbitlang/core/debug.Debug::{to_repr}
pub extend TaskQueue with Eq::{not_equal, equal}

///|
/// 创建互斥锁 | Create mutex
pub fn mutex_create() -> Mutex {
  { locked: false, owner: "" }
}

///|
/// 加锁 | Lock mutex
pub fn mutex_lock(m : Mutex, owner : String) -> Mutex? {
  if m.locked {
    None
  } else {
    Some({ locked: true, owner })
  }
}

///|
/// 解锁 | Unlock mutex
pub fn mutex_unlock(_m : Mutex) -> Mutex {
  { locked: false, owner: "" }
}

///|
/// 尝试加锁 | Try lock mutex
pub fn mutex_try_lock(m : Mutex, owner : String) -> Mutex {
  if m.locked {
    m
  } else {
    { locked: true, owner }
  }
}

///|
/// 创建信号量 | Create semaphore
pub fn semaphore_create(max : Int) -> Semaphore {
  { count: max, max }
}

///|
/// 获取信号量 | Acquire semaphore
pub fn semaphore_acquire(sem : Semaphore) -> Semaphore? {
  if sem.count > 0 {
    Some({ count: sem.count - 1, max: sem.max })
  } else {
    None
  }
}

///|
/// 释放信号量 | Release semaphore
pub fn semaphore_release(sem : Semaphore) -> Semaphore {
  if sem.count < sem.max {
    { count: sem.count + 1, max: sem.max }
  } else {
    sem
  }
}

///|
/// 创建通道 | Create channel
pub fn channel_create(capacity : Int) -> Channel {
  { buffer: [], capacity, closed: false }
}

///|
/// 发送到通道 | Send to channel
pub fn channel_send(ch : Channel, value : String) -> Channel? {
  if ch.closed || ch.buffer.length() >= ch.capacity {
    None
  } else {
    let new_buffer = []
    for item in ch.buffer {
      new_buffer.push(item)
    }
    new_buffer.push(value)
    Some({ buffer: new_buffer, capacity: ch.capacity, closed: ch.closed })
  }
}

///|
/// 从通道接收 | Receive from channel
pub fn channel_receive(ch : Channel) -> (Channel, String?) {
  if ch.buffer.length() == 0 || ch.closed {
    (ch, None)
  } else {
    let value = ch.buffer[0]
    let new_buffer = []
    let len = ch.buffer.length()
    let mut i = 1
    while i < len {
      new_buffer.push(ch.buffer[i])
      i = i + 1
    }
    ({ buffer: new_buffer, capacity: ch.capacity, closed: ch.closed }, Some(value))
  }
}

///|
/// 关闭通道 | Close channel
pub fn channel_close(ch : Channel) -> Channel {
  { buffer: ch.buffer, capacity: ch.capacity, closed: true }
}

///|
/// 创建未来值 | Create future
pub fn future_create() -> Future {
  { value: "", completed: false }
}

///|
/// 完成未来值 | Complete future
pub fn future_complete(_f : Future, value : String) -> Future {
  { value, completed: true }
}

///|
/// 未来值是否完成 | Future is completed
pub fn future_is_complete(f : Future) -> Bool {
  f.completed
}

///|
/// 获取未来值 | Get future value
pub fn future_get(f : Future) -> String? {
  if f.completed {
    Some(f.value)
  } else {
    None
  }
}

///|
/// 创建原子计数器 | Create atomic counter
pub fn atomic_create() -> AtomicCounter {
  { value: 0 }
}

///|
/// 原子递增 | Atomic increment
pub fn atomic_increment(ac : AtomicCounter) -> AtomicCounter {
  { value: ac.value + 1 }
}

///|
/// 原子递减 | Atomic decrement
pub fn atomic_decrement(ac : AtomicCounter) -> AtomicCounter {
  { value: ac.value - 1 }
}

///|
/// 原子获取 | Atomic get
pub fn atomic_get(ac : AtomicCounter) -> Int {
  ac.value
}

///|
/// 原子设置 | Atomic set
pub fn atomic_set(_ac : AtomicCounter, value : Int) -> AtomicCounter {
  { value, }
}

///|
/// 原子加法 | Atomic add
pub fn atomic_add(ac : AtomicCounter, delta : Int) -> AtomicCounter {
  { value: ac.value + delta }
}

///|
/// 创建任务队列 | Create task queue
pub fn task_queue_create() -> TaskQueue {
  { tasks: [], next_id: 0 }
}

///|
/// 入队任务 | Enqueue task
pub fn task_enqueue(tq : TaskQueue, name : String, priority : Int) -> TaskQueue {
  let task = { id: tq.next_id, name, priority }
  let new_tasks = []
  let inserted = []
  let mut found = false
  for t in tq.tasks {
    if !found && t.priority < priority {
      inserted.push(task)
      found = true
    }
    inserted.push(t)
  }
  if !found {
    inserted.push(task)
  }
  for t in inserted {
    new_tasks.push(t)
  }
  { tasks: new_tasks, next_id: tq.next_id + 1 }
}

///|
/// 出队任务 | Dequeue task
pub fn task_dequeue(tq : TaskQueue) -> (TaskQueue, Task?) {
  if tq.tasks.length() == 0 {
    (tq, None)
  } else {
    let task = tq.tasks[0]
    let new_tasks = []
    let len = tq.tasks.length()
    let mut i = 1
    while i < len {
      new_tasks.push(tq.tasks[i])
      i = i + 1
    }
    ({ tasks: new_tasks, next_id: tq.next_id }, Some(task))
  }
}

///|
/// 任务队列大小 | Task queue size
pub fn task_queue_size(tq : TaskQueue) -> Int {
  tq.tasks.length()
}

///|
/// 任务队列是否为空 | Task queue is empty
pub fn task_queue_is_empty(tq : TaskQueue) -> Bool {
  tq.tasks.length() == 0
}

///|
/// 并发版本 | Concurrency version
pub fn concurrency_version() -> String {
  "moon-cross concurrency v0.2.28"
}

///|
/// Task 实现 Named trait | Task implements Named
pub impl @trait.Named for Task with name(self) {
  self.name
}
pub extend Task with @trait.Named::{name}