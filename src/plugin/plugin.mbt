///|
/// 插件信息 | Plugin information
pub(all) struct PluginInfo {
  name : String
  version : String
  author : String
  description : String
  enabled : Bool
} derive(Debug, Eq)

pub extend PluginInfo with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PluginInfo with Eq::{not_equal, equal}

///|
/// 插件钩子类型 | Plugin hook type
pub(all) enum PluginHook {
  PreCompile
  PostCompile
  PreCodegen
  PostCodegen
  PreFfi
  PostFfi
} derive(Debug, Eq)

pub extend PluginHook with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PluginHook with Eq::{not_equal, equal}

///|
/// 插件注册条目 | Plugin registry entry
pub(all) struct PluginEntry {
  info : PluginInfo
  hooks : Array[PluginHook]
  priority : Int
} derive(Debug, Eq)

pub extend PluginEntry with @moonbitlang/core/debug.Debug::{to_repr}
pub extend PluginEntry with Eq::{not_equal, equal}

///|
/// 钩子执行结果 | Hook execution result
pub(all) struct HookResult {
  hook : PluginHook
  plugin_name : String
  success : Bool
  message : String
} derive(Debug, Eq)

pub extend HookResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend HookResult with Eq::{not_equal, equal}

///|
/// 创建插件信息 | Create plugin information
pub fn make_plugin_info(name : String, version : String, author : String, description : String) -> PluginInfo {
  { name, version, author, description, enabled: true }
}

///|
/// 创建插件注册条目 | Create plugin registry entry
pub fn make_plugin_entry(info : PluginInfo, hooks : Array[PluginHook], priority : Int) -> PluginEntry {
  { info, hooks, priority }
}

///|
/// 注册插件 | Register plugin
pub fn register_plugin(registry : Array[PluginEntry], entry : PluginEntry) -> Array[PluginEntry] {
  let mut already_exists = false
  for existing in registry {
    if existing.info.name == entry.info.name {
      already_exists = true
    }
  }
  if !already_exists {
    registry.push(entry)
  }
  registry
}

///|
/// 注销插件 | Unregister plugin
pub fn unregister_plugin(registry : Array[PluginEntry], name : String) -> Array[PluginEntry] {
  let result = []
  for entry in registry {
    if entry.info.name != name {
      result.push(entry)
    }
  }
  result
}

///|
/// 列出所有插件 | List all plugins
pub fn list_plugins(registry : Array[PluginEntry]) -> Array[PluginInfo] {
  let infos = []
  for entry in registry {
    infos.push(entry.info)
  }
  infos
}

///|
/// 查找支持指定钩子的插件 | Find plugins supporting a specific hook
pub fn find_plugins_for_hook(registry : Array[PluginEntry], hook : PluginHook) -> Array[PluginEntry] {
  let result = []
  for entry in registry {
    if entry.info.enabled {
      for h in entry.hooks {
        if h == hook {
          result.push(entry)
        }
      }
    }
  }
  result
}

///|
/// 执行钩子 | Execute hook
pub fn execute_hook(registry : Array[PluginEntry], hook : PluginHook) -> Array[HookResult] {
  let results = []
  let plugins = find_plugins_for_hook(registry, hook)
  for plugin in plugins {
    results.push({ hook, plugin_name: plugin.info.name, success: true, message: "hook executed" })
  }
  results
}

///|
/// 启用插件 | Enable plugin
pub fn enable_plugin(registry : Array[PluginEntry], name : String) -> Array[PluginEntry] {
  let result = []
  for entry in registry {
    if entry.info.name == name {
      result.push({ info: { ..entry.info, enabled: true }, hooks: entry.hooks, priority: entry.priority })
    } else {
      result.push(entry)
    }
  }
  result
}

///|
/// 禁用插件 | Disable plugin
pub fn disable_plugin(registry : Array[PluginEntry], name : String) -> Array[PluginEntry] {
  let result = []
  for entry in registry {
    if entry.info.name == name {
      result.push({ info: { ..entry.info, enabled: false }, hooks: entry.hooks, priority: entry.priority })
    } else {
      result.push(entry)
    }
  }
  result
}

///|
/// PluginHook 转字符串 | PluginHook to string
pub fn PluginHook::to_string(self : PluginHook) -> String {
  match self {
    PreCompile => "pre_compile"
    PostCompile => "post_compile"
    PreCodegen => "pre_codegen"
    PostCodegen => "post_codegen"
    PreFfi => "pre_ffi"
    PostFfi => "post_ffi"
  }
}

///|
/// 插件机制版本 | Plugin system version
pub fn plugin_version() -> String {
  "moon-cross plugin v0.1.1"
}

///|
/// PluginInfo 实现 Named trait | PluginInfo implements Named
pub impl @trait.Named for PluginInfo with name(self) {
  self.name
}
pub extend PluginInfo with @trait.Named::{name}
