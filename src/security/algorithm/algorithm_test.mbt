test "linear_search_found" {
  let arr = [3, 1, 4, 1, 5, 9, 2, 6]
  let r = @algorithm.linear_search(arr, 5)
  assert_true(r.found)
  assert_eq(r.index, 4)
}

test "linear_search_not_found" {
  let arr = [3, 1, 4, 1, 5]
  let r = @algorithm.linear_search(arr, 10)
  assert_false(r.found)
  assert_eq(r.index, -1)
}

test "linear_search_empty" {
  let arr : Array[Int] = []
  let r = @algorithm.linear_search(arr, 1)
  assert_false(r.found)
}

test "binary_search_found" {
  let arr = [1, 3, 5, 7, 9, 11, 13]
  let r = @algorithm.binary_search(arr, 7)
  assert_true(r.found)
  assert_eq(r.index, 3)
}

test "binary_search_not_found" {
  let arr = [1, 3, 5, 7, 9]
  let r = @algorithm.binary_search(arr, 6)
  assert_false(r.found)
}

test "binary_search_first" {
  let arr = [1, 3, 5, 7, 9]
  let r = @algorithm.binary_search(arr, 1)
  assert_true(r.found)
  assert_eq(r.index, 0)
}

test "binary_search_last" {
  let arr = [1, 3, 5, 7, 9]
  let r = @algorithm.binary_search(arr, 9)
  assert_true(r.found)
  assert_eq(r.index, 4)
}

test "bubble_sort" {
  let arr = [5, 3, 8, 1, 9, 2, 7]
  let sorted = @algorithm.bubble_sort(arr)
  assert_eq(sorted, [1, 2, 3, 5, 7, 8, 9])
}

test "bubble_sort_empty" {
  let arr : Array[Int] = []
  let sorted = @algorithm.bubble_sort(arr)
  assert_eq(sorted.length(), 0)
}

test "bubble_sort_sorted" {
  let arr = [1, 2, 3, 4, 5]
  let sorted = @algorithm.bubble_sort(arr)
  assert_eq(sorted, [1, 2, 3, 4, 5])
}

test "insertion_sort" {
  let arr = [5, 3, 8, 1, 9, 2, 7]
  let sorted = @algorithm.insertion_sort(arr)
  assert_eq(sorted, [1, 2, 3, 5, 7, 8, 9])
}

test "insertion_sort_empty" {
  let arr : Array[Int] = []
  let sorted = @algorithm.insertion_sort(arr)
  assert_eq(sorted.length(), 0)
}

test "selection_sort" {
  let arr = [5, 3, 8, 1, 9, 2, 7]
  let sorted = @algorithm.selection_sort(arr)
  assert_eq(sorted, [1, 2, 3, 5, 7, 8, 9])
}

test "quick_sort" {
  let arr = [5, 3, 8, 1, 9, 2, 7]
  let sorted = @algorithm.quick_sort(arr)
  assert_eq(sorted, [1, 2, 3, 5, 7, 8, 9])
}

test "quick_sort_empty" {
  let arr : Array[Int] = []
  let sorted = @algorithm.quick_sort(arr)
  assert_eq(sorted.length(), 0)
}

test "quick_sort_single" {
  let arr = [42]
  let sorted = @algorithm.quick_sort(arr)
  assert_eq(sorted, [42])
}

test "array_min" {
  let arr = [5, 3, 8, 1, 9]
  let m = @algorithm.array_min(arr)
  match m {
    Some(v) => assert_eq(v, 1)
    None => assert_true(false)
  }
}

test "array_min_empty" {
  let arr : Array[Int] = []
  assert_true(@algorithm.array_min(arr) is None)
}

test "array_max" {
  let arr = [5, 3, 8, 1, 9]
  let m = @algorithm.array_max(arr)
  match m {
    Some(v) => assert_eq(v, 9)
    None => assert_true(false)
  }
}

test "array_max_empty" {
  let arr : Array[Int] = []
  assert_true(@algorithm.array_max(arr) is None)
}

test "array_reverse" {
  let arr = [1, 2, 3, 4, 5]
  let rev = @algorithm.array_reverse(arr)
  assert_eq(rev, [5, 4, 3, 2, 1])
}

test "array_reverse_empty" {
  let arr : Array[Int] = []
  let rev = @algorithm.array_reverse(arr)
  assert_eq(rev.length(), 0)
}

test "array_dedup" {
  let arr = [1, 2, 2, 3, 3, 3, 4]
  let deduped = @algorithm.array_dedup(arr)
  assert_eq(deduped, [1, 2, 3, 4])
}

test "array_dedup_empty" {
  let arr : Array[Int] = []
  let deduped = @algorithm.array_dedup(arr)
  assert_eq(deduped.length(), 0)
}

test "algorithm_version" {
  let v = @algorithm.algorithm_version()
  assert_true(v.contains("algorithm"))
}