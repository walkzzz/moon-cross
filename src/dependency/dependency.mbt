///|
/// 依赖边 | Dependency edge
pub(all) struct DependencyEdge {
  from : String
  to : String
} derive(Debug, Eq)
pub extend DependencyEdge with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DependencyEdge with Eq::{not_equal, equal}

///|
/// 依赖节点 | Dependency node
pub(all) struct DependencyNode {
  name : String
  dependencies : Array[String]
  dependents : Array[String]
} derive(Debug, Eq)
pub extend DependencyNode with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DependencyNode with Eq::{not_equal, equal}

///|
/// 依赖图 | Dependency graph
pub(all) struct DependencyGraph {
  nodes : Array[DependencyNode]
  edges : Array[DependencyEdge]
} derive(Debug, Eq)
pub extend DependencyGraph with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DependencyGraph with Eq::{not_equal, equal}

///|
/// 依赖配置 | Dependency configuration
pub(all) struct DependencyConfig {
  include_dev : Bool
  include_transitive : Bool
  max_depth : Int
} derive(Debug, Eq)
pub extend DependencyConfig with @moonbitlang/core/debug.Debug::{to_repr}
pub extend DependencyConfig with Eq::{not_equal, equal}

///|
/// 默认依赖配置 | Default dependency configuration
pub fn default_dependency_config() -> DependencyConfig {
  { include_dev: false, include_transitive: true, max_depth: 100 }
}

///|
/// 创建依赖边 | Create dependency edge
pub fn make_edge(from : String, to : String) -> DependencyEdge {
  { from, to }
}

///|
/// 构建依赖图 | Build dependency graph
pub fn build_graph(
  packages : Array[String],
  edges : Array[DependencyEdge],
) -> DependencyGraph {
  let nodes : Array[DependencyNode] = []
  for pkg in packages {
    let deps = []
    let dependents = []
    for edge in edges {
      if edge.from == pkg {
        deps.push(edge.to)
      }
      if edge.to == pkg {
        dependents.push(edge.from)
      }
    }
    nodes.push({ name: pkg, dependencies: deps, dependents })
  }
  { nodes, edges }
}

///|
/// 查找节点 | Find node by name
pub fn find_node(
  graph : DependencyGraph,
  name : String,
) -> DependencyNode? {
  for node in graph.nodes {
    if node.name == name {
      return Some(node)
    }
  }
  None
}

///|
/// 获取直接依赖 | Get direct dependencies
pub fn direct_deps(
  graph : DependencyGraph,
  pkg : String,
) -> Array[String] {
  match find_node(graph, pkg) {
    Some(node) => node.dependencies
    None => []
  }
}

///|
/// 获取直接依赖者 | Get direct dependents
pub fn direct_dependents(
  graph : DependencyGraph,
  pkg : String,
) -> Array[String] {
  match find_node(graph, pkg) {
    Some(node) => node.dependents
    None => []
  }
}

///|
/// 传递依赖 | Transitive dependencies
pub fn transitive_deps(
  graph : DependencyGraph,
  pkg : String,
) -> Array[String] {
  let result : Array[String] = []
  let visited : Array[String] = []
  collect_transitive_deps(graph, pkg, result, visited)
  result
}

///|
/// 递归收集传递依赖 | Recursively collect transitive deps
fn collect_transitive_deps(
  graph : DependencyGraph,
  pkg : String,
  result : Array[String],
  visited : Array[String],
) -> Unit {
  if array_contains(visited, pkg) {
    return
  }
  visited.push(pkg)
  match find_node(graph, pkg) {
    Some(node) => {
      for dep in node.dependencies {
        if !array_contains(result, dep) {
          result.push(dep)
        }
        collect_transitive_deps(graph, dep, result, visited)
      }
    }
    None => return
  }
}

///|
/// 传递依赖者 | Transitive dependents
pub fn transitive_dependents(
  graph : DependencyGraph,
  pkg : String,
) -> Array[String] {
  let result : Array[String] = []
  let visited : Array[String] = []
  collect_transitive_dependents(graph, pkg, result, visited)
  result
}

///|
/// 递归收集传递依赖者 | Recursively collect transitive dependents
fn collect_transitive_dependents(
  graph : DependencyGraph,
  pkg : String,
  result : Array[String],
  visited : Array[String],
) -> Unit {
  if array_contains(visited, pkg) {
    return
  }
  visited.push(pkg)
  match find_node(graph, pkg) {
    Some(node) => {
      for dep in node.dependents {
        if !array_contains(result, dep) {
          result.push(dep)
        }
        collect_transitive_dependents(graph, dep, result, visited)
      }
    }
    None => return
  }
}

///|
/// 是否为叶子节点 | Check if leaf node
pub fn is_leaf(
  graph : DependencyGraph,
  pkg : String,
) -> Bool {
  match find_node(graph, pkg) {
    Some(node) => node.dependencies.length() == 0
    None => false
  }
}

///|
/// 是否为根节点 | Check if root node
pub fn is_root(
  graph : DependencyGraph,
  pkg : String,
) -> Bool {
  match find_node(graph, pkg) {
    Some(node) => node.dependents.length() == 0
    None => false
  }
}

///|
/// 依赖深度 | Dependency depth
pub fn dependency_depth(
  graph : DependencyGraph,
  pkg : String,
) -> Int {
  let node = find_node(graph, pkg)
  match node {
    Some(n) => {
      if n.dependencies.length() == 0 {
        return 0
      }
      let mut max_depth = 0
      for dep in n.dependencies {
        let d = dependency_depth(graph, dep)
        if d > max_depth {
          max_depth = d
        }
      }
      max_depth + 1
    }
    None => 0
  }
}

///|
/// 检测是否有环 | Check if has cycle
pub fn has_cycle(graph : DependencyGraph) -> Bool {
  for node in graph.nodes {
    let visited : Array[String] = []
    let stack : Array[String] = []
    if detect_cycle_dfs(graph, node.name, visited, stack) {
      return true
    }
  }
  false
}

///|
/// DFS 环检测 | DFS cycle detection
fn detect_cycle_dfs(
  graph : DependencyGraph,
  pkg : String,
  visited : Array[String],
  stack : Array[String],
) -> Bool {
  if array_contains(stack, pkg) {
    return true
  }
  if array_contains(visited, pkg) {
    return false
  }
  visited.push(pkg)
  stack.push(pkg)
  match find_node(graph, pkg) {
    Some(node) => {
      for dep in node.dependencies {
        if detect_cycle_dfs(graph, dep, visited, stack) {
          return true
        }
      }
    }
    None => return false
  }
  let stack_len = stack.length()
  let _ = stack.remove(stack_len - 1)
  false
}

///|
/// 拓扑排序 | Topological sort
pub fn topological_sort(
  graph : DependencyGraph,
) -> Array[String]? {
  if has_cycle(graph) {
    return None
  }
  let result : Array[String] = []
  let visited : Array[String] = []
  for node in graph.nodes {
    topo_dfs(graph, node.name, visited, result)
  }
  Some(result)
}

///|
/// 拓扑排序 DFS | Topological sort DFS
fn topo_dfs(
  graph : DependencyGraph,
  pkg : String,
  visited : Array[String],
  result : Array[String],
) -> Unit {
  if array_contains(visited, pkg) {
    return
  }
  visited.push(pkg)
  match find_node(graph, pkg) {
    Some(node) => {
      for dep in node.dependencies {
        topo_dfs(graph, dep, visited, result)
      }
    }
    None => return
  }
  result.push(pkg)
}

///|
/// 格式化依赖图 | Format dependency graph
pub fn format_graph(graph : DependencyGraph) -> String {
  let mut output = "Dependency Graph\n"
  output = output + "================\n"
  for node in graph.nodes {
    output = output + node.name + " -> "
    let mut first = true
    for dep in node.dependencies {
      if first {
        output = output + dep
        first = false
      } else {
        output = output + ", " + dep
      }
    }
    if first {
      output = output + "(no deps)"
    }
    output = output + "\n"
  }
  output
}

///|
/// 依赖图版本 | Dependency graph version
pub fn dependency_version() -> String {
  "moon-cross dependency v0.2.5"
}

///|
/// 空依赖图 | Empty dependency graph
pub fn empty_graph() -> DependencyGraph {
  { nodes: [], edges: [] }
}

///|
/// 节点数 | Node count
pub fn node_count(graph : DependencyGraph) -> Int {
  graph.nodes.length()
}

///|
/// 边数 | Edge count
pub fn edge_count(graph : DependencyGraph) -> Int {
  graph.edges.length()
}

///|
/// 数组包含 | Array contains
fn array_contains(arr : Array[String], item : String) -> Bool {
  for x in arr {
    if x == item {
      return true
    }
  }
  false
}

///|
/// 孤立节点 | Orphan nodes (no deps and no dependents)
pub fn orphan_nodes(graph : DependencyGraph) -> Array[String] {
  let result = []
  for node in graph.nodes {
    if node.dependencies.length() == 0 && node.dependents.length() == 0 {
      result.push(node.name)
    }
  }
  result
}

///|
/// 合并依赖图 | Merge dependency graphs
pub fn merge_graphs(
  g1 : DependencyGraph,
  g2 : DependencyGraph,
) -> DependencyGraph {
  let nodes = []
  for n in g1.nodes {
    nodes.push(n)
  }
  for n in g2.nodes {
    nodes.push(n)
  }
  let edges = []
  for e in g1.edges {
    edges.push(e)
  }
  for e in g2.edges {
    edges.push(e)
  }
  { nodes, edges }
}

///|
/// DependencyNode 实现 Named trait | DependencyNode implements Named
pub impl @trait.Named for DependencyNode with name(self) {
  self.name
}
pub extend DependencyNode with @trait.Named::{name}