///|
/// 优化级别 | Optimization level
pub(all) enum OptLevel {
  O0
  O1
  O2
  O3
  Os
} derive(Debug, Eq)

pub extend OptLevel with @moonbitlang/core/debug.Debug::{to_repr}
pub extend OptLevel with Eq::{not_equal, equal}

///|
/// 优化配置 | Optimization configuration
pub(all) struct OptConfig {
  level : OptLevel
  inline_small_functions : Bool
  dead_code_elimination : Bool
  template_specialization : Bool
  lto : Bool
} derive(Debug, Eq)

pub extend OptConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend OptConfig with Eq::{not_equal, equal}

///|
/// 优化结果 | Optimization result
pub(all) struct OptResult {
  original_size_bytes : Int
  optimized_size_bytes : Int
  inlined_functions : Int
  eliminated_functions : Int
  specialized_templates : Int
} derive(Debug, Eq)

pub extend OptResult with @moonbitlang/core/debug.Debug::{to_repr}
pub extend OptResult with Eq::{not_equal, equal}

///|
/// 默认优化配置 | Default optimization configuration
pub fn default_opt_config() -> OptConfig {
  { level: O2, inline_small_functions: true, dead_code_elimination: true, template_specialization: true, lto: false }
}

///|
/// 发布优化配置 | Release optimization configuration
pub fn release_opt_config() -> OptConfig {
  { level: O3, inline_small_functions: true, dead_code_elimination: true, template_specialization: true, lto: true }
}

///|
/// 调试优化配置 | Debug optimization configuration
pub fn debug_opt_config() -> OptConfig {
  { level: O0, inline_small_functions: false, dead_code_elimination: false, template_specialization: false, lto: false }
}

///|
/// 优化级别转字符串 | Optimization level to string
pub fn OptLevel::to_string(self : OptLevel) -> String {
  match self {
    O0 => "-O0"
    O1 => "-O1"
    O2 => "-O2"
    O3 => "-O3"
    Os => "-Os"
  }
}

///|
/// 生成优化标志 | Generate optimization flags
pub fn opt_flags(config : OptConfig) -> Array[String] {
  let flags = [config.level.to_string()]
  if config.lto {
    flags.push("-flto")
  }
  if !config.inline_small_functions {
    flags.push("-fno-inline")
  }
  flags
}

///|
/// 判断函数是否应内联 | Determine if function should be inlined
pub fn should_inline(function_body_size : Int, call_count : Int) -> Bool {
  function_body_size <= 50 && call_count >= 3
}

///|
/// 模板特化：根据参数类型生成特化代码 | Template specialization
pub fn template_specialize(function_name : String, param_types : Array[String]) -> String {
  let mut name = function_name + "_specialized"
  for ptype in param_types {
    name = name + "_" + ptype
  }
  name
}

///|
/// 死代码消除：检测未使用的导出函数 | Dead code elimination
pub fn dead_code_eliminate(exported_functions : Array[String], used_functions : Array[String]) -> Array[String] {
  let unused = []
  for func in exported_functions {
    let mut is_used = false
    for used in used_functions {
      if func == used {
        is_used = true
      }
    }
    if !is_used {
      unused.push(func)
    }
  }
  unused
}

///|
/// 计算优化后的大小 | Calculate optimized size
pub fn estimate_optimized_size(original_size : Int, config : OptConfig) -> Int {
  let mut size = original_size
  if config.dead_code_elimination {
    size = size * 85 / 100
  }
  if config.template_specialization {
    size = size * 90 / 100
  }
  if config.lto {
    size = size * 80 / 100
  }
  match config.level {
    O0 => size
    O1 => size * 95 / 100
    O2 => size * 90 / 100
    O3 => size * 85 / 100
    Os => size * 80 / 100
  }
}

///|
/// 创建优化结果 | Create optimization result
pub fn make_opt_result(
  original_size : Int,
  optimized_size : Int,
  inlined : Int,
  eliminated : Int,
  specialized : Int,
) -> OptResult {
  { original_size_bytes: original_size, optimized_size_bytes: optimized_size, inlined_functions: inlined, eliminated_functions: eliminated, specialized_templates: specialized }
}

///|
/// 计算压缩率 | Calculate compression ratio
pub fn compression_ratio(result : OptResult) -> Double {
  if result.original_size_bytes == 0 {
    0.0
  } else {
    1.0 - result.optimized_size_bytes.to_double() / result.original_size_bytes.to_double()
  }
}

///|
/// 代码优化版本 | Code optimization version
pub fn optimize_version() -> String {
  "moon-cross perf/optimize v0.1.0"
}