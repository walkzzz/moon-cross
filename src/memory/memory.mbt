///|
/// 内存块 | Memory block
pub(all) struct MemoryBlock {
  id : Int
  size : Int
  tag : String
  freed : Bool
} derive(Debug, Eq)
pub extend MemoryBlock with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MemoryBlock with Eq::{not_equal, equal}

///|
/// 内存追踪器 | Memory tracker
pub(all) struct MemoryTracker {
  blocks : Array[MemoryBlock]
  total_allocated : Int
  total_freed : Int
  next_id : Int
} derive(Debug, Eq)
pub extend MemoryTracker with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MemoryTracker with Eq::{not_equal, equal}

///|
/// 竞技场分配器 | Arena allocator
pub(all) struct Arena {
  name : String
  blocks : Array[MemoryBlock]
  total_size : Int
  next_id : Int
} derive(Debug, Eq)
pub extend Arena with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Arena with Eq::{not_equal, equal}

///|
/// 引用计数器 | Reference counter
pub(all) struct RefCounter {
  count : Int
  value : String
} derive(Debug, Eq)
pub extend RefCounter with @moonbitlang/core/debug.Debug::{to_repr}
pub extend RefCounter with Eq::{not_equal, equal}

///|
/// 内存池 | Memory pool
pub(all) struct MemoryPool {
  block_size : Int
  free_count : Int
  allocated_count : Int
  total_capacity : Int
} derive(Debug, Eq)
pub extend MemoryPool with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MemoryPool with Eq::{not_equal, equal}

///|
/// GC 统计 | GC statistics
pub(all) struct GcStats {
  collections : Int
  reclaimed_bytes : Int
  live_objects : Int
  total_allocated : Int
} derive(Debug, Eq)
pub extend GcStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend GcStats with Eq::{not_equal, equal}

///|
/// 创建内存追踪器 | Create memory tracker
pub fn tracker_create() -> MemoryTracker {
  { blocks: [], total_allocated: 0, total_freed: 0, next_id: 0 }
}

///|
/// 分配内存块 | Allocate memory block
pub fn tracker_allocate(tracker : MemoryTracker, size : Int, tag : String) -> (MemoryTracker, MemoryBlock) {
  let block = { id: tracker.next_id, size, tag, freed: false }
  let new_blocks = []
  for b in tracker.blocks {
    new_blocks.push(b)
  }
  new_blocks.push(block)
  let new_tracker = {
    blocks: new_blocks,
    total_allocated: tracker.total_allocated + size,
    total_freed: tracker.total_freed,
    next_id: tracker.next_id + 1,
  }
  (new_tracker, block)
}

///|
/// 释放内存块 | Free memory block
pub fn tracker_free(tracker : MemoryTracker, block_id : Int) -> MemoryTracker {
  let new_blocks = []
  let mut freed_size = 0
  for b in tracker.blocks {
    if b.id == block_id && !b.freed {
      new_blocks.push({ id: b.id, size: b.size, tag: b.tag, freed: true })
      freed_size = b.size
    } else {
      new_blocks.push(b)
    }
  }
  {
    blocks: new_blocks,
    total_allocated: tracker.total_allocated,
    total_freed: tracker.total_freed + freed_size,
    next_id: tracker.next_id,
  }
}

///|
/// 获取活跃块数 | Get live block count
pub fn tracker_live_count(tracker : MemoryTracker) -> Int {
  let mut count = 0
  for b in tracker.blocks {
    if !b.freed {
      count = count + 1
    }
  }
  count
}

///|
/// 获取活跃字节数 | Get live bytes
pub fn tracker_live_bytes(tracker : MemoryTracker) -> Int {
  let mut total = 0
  for b in tracker.blocks {
    if !b.freed {
      total = total + b.size
    }
  }
  total
}

///|
/// 检查泄漏 | Check for leaks
pub fn tracker_has_leaks(tracker : MemoryTracker) -> Bool {
  tracker_live_count(tracker) > 0
}

///|
/// 创建竞技场 | Create arena
pub fn arena_create(name : String) -> Arena {
  { name, blocks: [], total_size: 0, next_id: 0 }
}

///|
/// 竞技场分配 | Arena allocate
pub fn arena_alloc(arena : Arena, size : Int, tag : String) -> (Arena, MemoryBlock) {
  let block = { id: arena.next_id, size, tag, freed: false }
  let new_blocks = []
  for b in arena.blocks {
    new_blocks.push(b)
  }
  new_blocks.push(block)
  let new_arena = {
    name: arena.name,
    blocks: new_blocks,
    total_size: arena.total_size + size,
    next_id: arena.next_id + 1,
  }
  (new_arena, block)
}

///|
/// 竞技场重置 | Arena reset
pub fn arena_reset(_arena : Arena) -> Arena {
  { name: _arena.name, blocks: [], total_size: 0, next_id: _arena.next_id }
}

///|
/// 竞技场块数 | Arena block count
pub fn arena_block_count(arena : Arena) -> Int {
  arena.blocks.length()
}

///|
/// 创建引用计数器 | Create reference counter
pub fn refcount_create(value : String) -> RefCounter {
  { count: 1, value }
}

///|
/// 增加引用 | Increment reference
pub fn refcount_increment(rc : RefCounter) -> RefCounter {
  { count: rc.count + 1, value: rc.value }
}

///|
/// 减少引用 | Decrement reference
pub fn refcount_decrement(rc : RefCounter) -> RefCounter {
  { count: rc.count - 1, value: rc.value }
}

///|
/// 引用是否为零 | Reference is zero
pub fn refcount_is_zero(rc : RefCounter) -> Bool {
  rc.count <= 0
}

///|
/// 创建内存池 | Create memory pool
pub fn pool_create(block_size : Int, capacity : Int) -> MemoryPool {
  { block_size, free_count: capacity, allocated_count: 0, total_capacity: capacity }
}

///|
/// 池分配 | Pool allocate
pub fn pool_allocate(pool : MemoryPool) -> MemoryPool? {
  if pool.free_count > 0 {
    Some({
      block_size: pool.block_size,
      free_count: pool.free_count - 1,
      allocated_count: pool.allocated_count + 1,
      total_capacity: pool.total_capacity,
    })
  } else {
    None
  }
}

///|
/// 池释放 | Pool deallocate
pub fn pool_deallocate(pool : MemoryPool) -> MemoryPool {
  if pool.allocated_count > 0 {
    {
      block_size: pool.block_size,
      free_count: pool.free_count + 1,
      allocated_count: pool.allocated_count - 1,
      total_capacity: pool.total_capacity,
    }
  } else {
    pool
  }
}

///|
/// 池使用率 | Pool usage rate
pub fn pool_usage(pool : MemoryPool) -> Int {
  if pool.total_capacity == 0 {
    0
  } else {
    (pool.allocated_count * 100) / pool.total_capacity
  }
}

///|
/// 创建 GC 统计 | Create GC stats
pub fn gc_stats_create() -> GcStats {
  { collections: 0, reclaimed_bytes: 0, live_objects: 0, total_allocated: 0 }
}

///|
/// GC 记录分配 | GC record allocation
pub fn gc_record_alloc(stats : GcStats, size : Int) -> GcStats {
  {
    collections: stats.collections,
    reclaimed_bytes: stats.reclaimed_bytes,
    live_objects: stats.live_objects + 1,
    total_allocated: stats.total_allocated + size,
  }
}

///|
/// GC 记录回收 | GC record collection
pub fn gc_record_collect(stats : GcStats, reclaimed : Int, freed_objects : Int) -> GcStats {
  {
    collections: stats.collections + 1,
    reclaimed_bytes: stats.reclaimed_bytes + reclaimed,
    live_objects: stats.live_objects - freed_objects,
    total_allocated: stats.total_allocated,
  }
}

///|
/// 内存版本 | Memory version
pub fn memory_version() -> String {
  "moon-cross memory v0.2.29"
}