///|
/// 处理器 | Handler
pub(all) struct Handler {
  id : Int
  name : String
  can_handle : Bool
} derive(Debug, Eq)
pub extend Handler with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Handler with Eq::{not_equal, equal}

///|
/// 处理结果 | Handle result
pub(all) struct HandleResult {
  handled : Bool
  handler_name : String
  message : String
} derive(Debug, Eq)
pub extend HandleResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HandleResult with Eq::{not_equal, equal}

///|
/// 处理链 | Handler chain
pub(all) struct HandlerChain {
  handlers : Array[Handler]
  next_id : Int
} derive(Debug, Eq)
pub extend HandlerChain with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HandlerChain with Eq::{not_equal, equal}

///|
/// 创建链 | Create chain
pub fn chain_create() -> HandlerChain {
  { handlers: [], next_id: 0 }
}

///|
/// 添加处理器 | Add handler
pub fn chain_add(chain : HandlerChain, name : String, can_handle : Bool) -> (HandlerChain, Handler) {
  let handler = { id: chain.next_id, name, can_handle }
  let new_handlers = []
  for h in chain.handlers {
    new_handlers.push(h)
  }
  new_handlers.push(handler)
  ({ handlers: new_handlers, next_id: chain.next_id + 1 }, handler)
}

///|
/// 处理请求 | Handle request
pub fn chain_handle(chain : HandlerChain, request : String) -> HandleResult {
  for h in chain.handlers {
    if h.can_handle {
      return { handled: true, handler_name: h.name, message: h.name + " handled: " + request }
    }
  }
  { handled: false, handler_name: "", message: "no handler available" }
}

///|
/// 处理器数量 | Handler count
pub fn chain_size(chain : HandlerChain) -> Int {
  chain.handlers.length()
}

///|
/// 移除处理器 | Remove handler
pub fn chain_remove(chain : HandlerChain, handler_id : Int) -> HandlerChain {
  let new_handlers = []
  for h in chain.handlers {
    if h.id != handler_id {
      new_handlers.push(h)
    }
  }
  { handlers: new_handlers, next_id: chain.next_id }
}

///|
/// 链版本 | Chain version
pub fn chain_version() -> String {
  "moon-cross chain v0.3.8"
}

///|
/// Handler 实现 Named trait | Handler implements Named
pub impl @trait.Named for Handler with name(self) {
  self.name
}
pub extend Handler with @trait.Named::{name}

///|
/// Handler 实现 Hashable trait | Handler implements Hashable
pub impl @trait.Hashable for Handler with hash(self) {
  @trait.Named::name(self).length()
}
pub extend Handler with @trait.Hashable::{hash}