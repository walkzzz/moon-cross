///|
/// 搜索结果 | Search result
pub(all) struct SearchResult {
  found : Bool
  index : Int
  comparisons : Int
} derive(Debug, Eq)
pub extend SearchResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend SearchResult with Eq::{not_equal, equal}

///|
/// 线性搜索 | Linear search
pub fn linear_search(arr : Array[Int], target : Int) -> SearchResult {
  let len = arr.length()
  let mut i = 0
  while i < len {
    if arr[i] == target {
      return { found: true, index: i, comparisons: i + 1 }
    }
    i = i + 1
  }
  { found: false, index: -1, comparisons: len }
}

///|
/// 二分搜索 | Binary search
pub fn binary_search(arr : Array[Int], target : Int) -> SearchResult {
  let mut lo = 0
  let mut hi = arr.length() - 1
  let mut comparisons = 0
  while lo <= hi {
    comparisons = comparisons + 1
    let mid = lo + (hi - lo) / 2
    if arr[mid] == target {
      return { found: true, index: mid, comparisons }
    }
    if arr[mid] < target {
      lo = mid + 1
    } else {
      hi = mid - 1
    }
  }
  { found: false, index: -1, comparisons }
}

///|
/// 冒泡排序 | Bubble sort
pub fn bubble_sort(arr : Array[Int]) -> Array[Int] {
  let result = []
  for item in arr {
    result.push(item)
  }
  let n = result.length()
  let mut i = 0
  while i < n {
    let mut j = 0
    while j < n - 1 - i {
      if result[j] > result[j + 1] {
        let temp = result[j]
        result[j] = result[j + 1]
        result[j + 1] = temp
      }
      j = j + 1
    }
    i = i + 1
  }
  result
}

///|
/// 插入排序 | Insertion sort
pub fn insertion_sort(arr : Array[Int]) -> Array[Int] {
  let result = []
  for item in arr {
    result.push(item)
  }
  let n = result.length()
  let mut i = 1
  while i < n {
    let key = result[i]
    let mut j = i - 1
    while j >= 0 && result[j] > key {
      result[j + 1] = result[j]
      j = j - 1
    }
    result[j + 1] = key
    i = i + 1
  }
  result
}

///|
/// 选择排序 | Selection sort
pub fn selection_sort(arr : Array[Int]) -> Array[Int] {
  let result = []
  for item in arr {
    result.push(item)
  }
  let n = result.length()
  let mut i = 0
  while i < n {
    let mut min_idx = i
    let mut j = i + 1
    while j < n {
      if result[j] < result[min_idx] {
        min_idx = j
      }
      j = j + 1
    }
    if min_idx != i {
      let temp = result[i]
      result[i] = result[min_idx]
      result[min_idx] = temp
    }
    i = i + 1
  }
  result
}

///|
/// 快速排序 | Quick sort
pub fn quick_sort(arr : Array[Int]) -> Array[Int] {
  if arr.length() <= 1 {
    let result = []
    for item in arr {
      result.push(item)
    }
    return result
  }
  let pivot = arr[0]
  let less = []
  let greater = []
  let mut i = 1
  while i < arr.length() {
    if arr[i] < pivot {
      less.push(arr[i])
    } else {
      greater.push(arr[i])
    }
    i = i + 1
  }
  let sorted_less = quick_sort(less)
  let sorted_greater = quick_sort(greater)
  let result = []
  for item in sorted_less {
    result.push(item)
  }
  result.push(pivot)
  for item in sorted_greater {
    result.push(item)
  }
  result
}

///|
/// 数组最小值 | Array minimum
pub fn array_min(arr : Array[Int]) -> Int? {
  if arr.length() == 0 {
    return None
  }
  let mut min_val = arr[0]
  let mut i = 1
  while i < arr.length() {
    if arr[i] < min_val {
      min_val = arr[i]
    }
    i = i + 1
  }
  Some(min_val)
}

///|
/// 数组最大值 | Array maximum
pub fn array_max(arr : Array[Int]) -> Int? {
  if arr.length() == 0 {
    return None
  }
  let mut max_val = arr[0]
  let mut i = 1
  while i < arr.length() {
    if arr[i] > max_val {
      max_val = arr[i]
    }
    i = i + 1
  }
  Some(max_val)
}

///|
/// 数组反转 | Array reverse
pub fn array_reverse(arr : Array[Int]) -> Array[Int] {
  let result = []
  let n = arr.length()
  let mut i = n - 1
  while i >= 0 {
    result.push(arr[i])
    i = i - 1
  }
  result
}

///|
/// 数组去重 | Array deduplicate
pub fn array_dedup(arr : Array[Int]) -> Array[Int] {
  let result = []
  for item in arr {
    let mut found = false
    for existing in result {
      if existing == item {
        found = true
      }
    }
    if !found {
      result.push(item)
    }
  }
  result
}

///|
/// 算法版本 | Algorithm version
pub fn algorithm_version() -> String {
  "moon-cross algorithm v0.3.0"
}