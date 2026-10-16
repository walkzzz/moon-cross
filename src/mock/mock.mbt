///|
/// 调用记录 | Call record
pub(all) struct MockCall {
  method_name : String
  args : String
} derive(Debug, Eq)
pub extend MockCall with @moonbitlang/core/debug.Debug::{to_repr}
pub extend MockCall with Eq::{not_equal, equal}

///|
/// Mock 对象 | Mock object
pub(all) struct Mock {
  calls : Array[MockCall]
  expectations : Array[MockCall]
} derive(Debug, Eq)
pub extend Mock with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Mock with Eq::{not_equal, equal}

///|
/// Stub 对象 | Stub object
pub(all) struct Stub {
  method_name : String
  return_value : String
  call_count : Int
} derive(Debug, Eq)
pub extend Stub with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Stub with Eq::{not_equal, equal}

///|
/// Spy 对象 | Spy object
pub(all) struct Spy {
  calls : Array[MockCall]
  wrapped : String
} derive(Debug, Eq)
pub extend Spy with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Spy with Eq::{not_equal, equal}

///|
/// Fake 对象 | Fake object
pub(all) struct Fake {
  name : String
  behavior : String
  call_count : Int
} derive(Debug, Eq)
pub extend Fake with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Fake with Eq::{not_equal, equal}

///|
/// 创建 Mock | Create mock
pub fn mock_create() -> Mock {
  { calls: [], expectations: [], }
}

///|
/// 记录调用 | Record call
pub fn mock_record(mock : Mock, method_name : String, args : String) -> Mock {
  let calls = []
  for c in mock.calls {
    calls.push(c)
  }
  calls.push({ method_name, args, })
  { calls, expectations: mock.expectations, }
}

///|
/// 设置期望 | Set expectation
pub fn mock_expect(mock : Mock, method_name : String, args : String) -> Mock {
  let expectations = []
  for e in mock.expectations {
    expectations.push(e)
  }
  expectations.push({ method_name, args, })
  { calls: mock.calls, expectations, }
}

///|
/// 验证 Mock：所有期望都被调用 | Verify mock: all expectations called
pub fn mock_verify(mock : Mock) -> Bool {
  for exp in mock.expectations {
    let mut found = false
    for call in mock.calls {
      if call.method_name == exp.method_name && call.args == exp.args {
        found = true
      }
    }
    if !found {
      return false
    }
  }
  true
}

///|
/// 获取调用次数 | Get call count for method
pub fn mock_call_count(mock : Mock, method_name : String) -> Int {
  let mut count = 0
  for c in mock.calls {
    if c.method_name == method_name {
      count = count + 1
    }
  }
  count
}

///|
/// 是否被调用 | Was method called
pub fn mock_was_called(mock : Mock, method_name : String) -> Bool {
  mock_call_count(mock, method_name) > 0
}

///|
/// 清空调用记录 | Clear calls
pub fn mock_reset(mock : Mock) -> Mock {
  { calls: [], expectations: mock.expectations, }
}

///|
/// 创建 Stub | Create stub
pub fn stub_create(method_name : String, return_value : String) -> Stub {
  { method_name, return_value, call_count: 0, }
}

///|
/// 调用 Stub | Call stub
pub fn stub_call(stub : Stub, _args : String) -> (Stub, String) {
  ({ method_name: stub.method_name, return_value: stub.return_value, call_count: stub.call_count + 1, }, stub.return_value)
}

///|
/// 创建 Spy | Create spy
pub fn spy_create(wrapped : String) -> Spy {
  { calls: [], wrapped, }
}

///|
/// Spy 记录调用 | Spy record call
pub fn spy_record(spy : Spy, method_name : String, args : String) -> Spy {
  let calls = []
  for c in spy.calls {
    calls.push(c)
  }
  calls.push({ method_name, args, })
  { calls, wrapped: spy.wrapped, }
}

///|
/// Spy 调用次数 | Spy call count
pub fn spy_call_count(spy : Spy, method_name : String) -> Int {
  let mut count = 0
  for c in spy.calls {
    if c.method_name == method_name {
      count = count + 1
    }
  }
  count
}

///|
/// Spy 是否被调用 | Spy was called
pub fn spy_was_called(spy : Spy, method_name : String) -> Bool {
  spy_call_count(spy, method_name) > 0
}

///|
/// 创建 Fake | Create fake
pub fn fake_create(name : String, behavior : String) -> Fake {
  { name, behavior, call_count: 0, }
}

///|
/// 调用 Fake | Invoke fake
pub fn fake_invoke(fake : Fake) -> (Fake, String) {
  ({ name: fake.name, behavior: fake.behavior, call_count: fake.call_count + 1, }, fake.behavior)
}

///|
/// Fake 调用次数 | Fake call count
pub fn fake_call_count(fake : Fake) -> Int {
  fake.call_count
}

///|
/// Mock 包版本 | Mock package version
pub fn mock_version() -> String {
  "moon-cross mock v0.3.2"
}