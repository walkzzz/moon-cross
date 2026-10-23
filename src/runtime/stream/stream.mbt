///|
/// 流操作统计 | Stream operation stats
pub(all) struct StreamStats {
  input_count : Int
  output_count : Int
  operations : Int
} derive(Debug, Eq)
pub extend StreamStats with @moonbitlang/core/debug.Debug::{to_repr}
pub extend StreamStats with Eq::{not_equal, equal}

///|
/// 映射操作 | Map operation
pub fn stream_map(arr : Array[Int], f : (Int) -> Int) -> Array[Int] {
  let result = []
  for item in arr {
    result.push(f(item))
  }
  result
}

///|
/// 过滤操作 | Filter operation
pub fn stream_filter(arr : Array[Int], pred : (Int) -> Bool) -> Array[Int] {
  let result = []
  for item in arr {
    if pred(item) {
      result.push(item)
    }
  }
  result
}

///|
/// 归约操作 | Reduce operation
pub fn stream_reduce(arr : Array[Int], initial : Int, f : (Int, Int) -> Int) -> Int {
  let mut acc = initial
  for item in arr {
    acc = f(acc, item)
  }
  acc
}

///|
/// 取前n个 | Take first n
pub fn stream_take(arr : Array[Int], n : Int) -> Array[Int] {
  let result = []
  let limit = if n < arr.length() { n } else { arr.length() }
  let mut i = 0
  while i < limit {
    result.push(arr[i])
    i = i + 1
  }
  result
}

///|
/// 跳过前n个 | Drop first n
pub fn stream_drop(arr : Array[Int], n : Int) -> Array[Int] {
  let result = []
  let start = if n < 0 { 0 } else { n }
  let mut i = start
  while i < arr.length() {
    result.push(arr[i])
    i = i + 1
  }
  result
}

///|
/// 链式操作 | Chain operations
pub fn stream_chain(arr : Array[Int], f : (Int) -> Int, pred : (Int) -> Bool) -> Array[Int] {
  let result = []
  for item in arr {
    let mapped = f(item)
    if pred(mapped) {
      result.push(mapped)
    }
  }
  result
}

///|
/// 拉链操作 | Zip operation
pub fn stream_zip(arr1 : Array[Int], arr2 : Array[Int]) -> Array[(Int, Int)] {
  let result = []
  let min_len = if arr1.length() < arr2.length() { arr1.length() } else { arr2.length() }
  let mut i = 0
  while i < min_len {
    result.push((arr1[i], arr2[i]))
    i = i + 1
  }
  result
}

///|
/// 展平操作 | Flatten operation
pub fn stream_flatten(arr : Array[Array[Int]]) -> Array[Int] {
  let result = []
  for sub in arr {
    for item in sub {
      result.push(item)
    }
  }
  result
}

///|
/// 枚举操作 | Enumerate operation
pub fn stream_enumerate(arr : Array[Int]) -> Array[(Int, Int)] {
  let result = []
  let mut i = 0
  while i < arr.length() {
    result.push((i, arr[i]))
    i = i + 1
  }
  result
}

///|
/// 流统计 | Stream stats
pub fn stream_stats(input : Array[Int], output : Array[Int], ops : Int) -> StreamStats {
  { input_count: input.length(), output_count: output.length(), operations: ops }
}

///|
/// 流版本 | Stream version
pub fn stream_version() -> String {
  "moon-cross stream v0.3.0"
}

///|
/// StreamStats 实现 Countable trait | StreamStats implements Countable
pub impl @trait.Countable for StreamStats with count(self) {
  self.input_count
}
pub extend StreamStats with @trait.Countable::{count}