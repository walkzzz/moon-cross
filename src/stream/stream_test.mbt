test "stream_map" {
  let arr = [1, 2, 3, 4, 5]
  let result = @stream.stream_map(arr, fn(x) { x * 2 })
  assert_eq(result, [2, 4, 6, 8, 10])
}

test "stream_map_empty" {
  let arr : Array[Int] = []
  let result = @stream.stream_map(arr, fn(x) { x * 2 })
  assert_eq(result.length(), 0)
}

test "stream_filter" {
  let arr = [1, 2, 3, 4, 5, 6]
  let result = @stream.stream_filter(arr, fn(x) { x % 2 == 0 })
  assert_eq(result, [2, 4, 6])
}

test "stream_filter_empty" {
  let arr : Array[Int] = []
  let result = @stream.stream_filter(arr, fn(x) { x > 0 })
  assert_eq(result.length(), 0)
}

test "stream_filter_all" {
  let arr = [1, 2, 3]
  let result = @stream.stream_filter(arr, fn(_x) { true })
  assert_eq(result, [1, 2, 3])
}

test "stream_filter_none" {
  let arr = [1, 2, 3]
  let result = @stream.stream_filter(arr, fn(_x) { false })
  assert_eq(result.length(), 0)
}

test "stream_reduce_sum" {
  let arr = [1, 2, 3, 4, 5]
  let sum = @stream.stream_reduce(arr, 0, fn(a, b) { a + b })
  assert_eq(sum, 15)
}

test "stream_reduce_product" {
  let arr = [1, 2, 3, 4]
  let product = @stream.stream_reduce(arr, 1, fn(a, b) { a * b })
  assert_eq(product, 24)
}

test "stream_reduce_empty" {
  let arr : Array[Int] = []
  let result = @stream.stream_reduce(arr, 42, fn(a, b) { a + b })
  assert_eq(result, 42)
}

test "stream_take" {
  let arr = [1, 2, 3, 4, 5]
  let result = @stream.stream_take(arr, 3)
  assert_eq(result, [1, 2, 3])
}

test "stream_take_more" {
  let arr = [1, 2, 3]
  let result = @stream.stream_take(arr, 10)
  assert_eq(result, [1, 2, 3])
}

test "stream_drop" {
  let arr = [1, 2, 3, 4, 5]
  let result = @stream.stream_drop(arr, 2)
  assert_eq(result, [3, 4, 5])
}

test "stream_drop_all" {
  let arr = [1, 2, 3]
  let result = @stream.stream_drop(arr, 5)
  assert_eq(result.length(), 0)
}

test "stream_chain" {
  let arr = [1, 2, 3, 4, 5]
  let result = @stream.stream_chain(arr, fn(x) { x * 3 }, fn(x) { x > 5 })
  assert_eq(result, [6, 9, 12, 15])
}

test "stream_zip" {
  let arr1 = [1, 2, 3]
  let arr2 = [10, 20, 30]
  let result = @stream.stream_zip(arr1, arr2)
  assert_eq(result.length(), 3)
  assert_eq(result[0], (1, 10))
  assert_eq(result[1], (2, 20))
}

test "stream_zip_different_lengths" {
  let arr1 = [1, 2, 3, 4]
  let arr2 = [10, 20]
  let result = @stream.stream_zip(arr1, arr2)
  assert_eq(result.length(), 2)
}

test "stream_flatten" {
  let arr = [[1, 2], [3, 4], [5, 6]]
  let result = @stream.stream_flatten(arr)
  assert_eq(result, [1, 2, 3, 4, 5, 6])
}

test "stream_flatten_empty" {
  let arr : Array[Array[Int]] = []
  let result = @stream.stream_flatten(arr)
  assert_eq(result.length(), 0)
}

test "stream_enumerate" {
  let arr = [10, 20, 30]
  let result = @stream.stream_enumerate(arr)
  assert_eq(result.length(), 3)
  assert_eq(result[0], (0, 10))
  assert_eq(result[1], (1, 20))
  assert_eq(result[2], (2, 30))
}

test "stream_stats" {
  let input = [1, 2, 3, 4, 5]
  let output = [2, 4]
  let stats = @stream.stream_stats(input, output, 2)
  assert_eq(stats.input_count, 5)
  assert_eq(stats.output_count, 2)
  assert_eq(stats.operations, 2)
}

test "stream_version" {
  let v = @stream.stream_version()
  assert_true(v.contains("stream"))
}