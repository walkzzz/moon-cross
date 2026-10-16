///|
/// 图类型 | Graph type
pub(all) enum GraphType {
  Directed
  Undirected
} derive(Debug, Eq)
pub extend GraphType with @moonbitlang/core/debug.Debug::{to_repr}
pub extend GraphType with Eq::{not_equal, equal}

///|
/// 图边 | Graph edge
pub(all) struct GraphEdge {
  from : String
  to : String
  weight : Int
} derive(Debug, Eq)
pub extend GraphEdge with @moonbitlang/core/debug.Debug::{to_repr}
pub extend GraphEdge with Eq::{not_equal, equal}

///|
/// 图 | Graph
pub(all) struct Graph {
  nodes : Array[String]
  edges : Array[GraphEdge]
  graph_type : GraphType
} derive(Debug, Eq)
pub extend Graph with @moonbitlang/core/debug.Debug::{to_repr}
pub extend Graph with Eq::{not_equal, equal}

///|
/// 创建边 | Create edge
pub fn make_edge(from : String, to : String) -> GraphEdge {
  { from, to, weight: 1 }
}

///|
/// 创建带权边 | Create weighted edge
pub fn make_weighted_edge(
  from : String,
  to : String,
  weight : Int,
) -> GraphEdge {
  { from, to, weight }
}

///|
/// 构建图 | Build graph
pub fn build_graph(
  graph_type : GraphType,
  nodes : Array[String],
  edges : Array[GraphEdge],
) -> Graph {
  { nodes, edges, graph_type }
}

///|
/// 获取邻居 | Get neighbors
pub fn neighbors(
  graph : Graph,
  node : String,
) -> Array[String] {
  let result = []
  for edge in graph.edges {
    if edge.from == node {
      result.push(edge.to)
    }
    if graph.graph_type == Undirected && edge.to == node {
      if !array_contains(result, edge.from) {
        result.push(edge.from)
      }
    }
  }
  result
}

///|
/// BFS 遍历 | BFS traversal
pub fn bfs(graph : Graph, start : String) -> Array[String] {
  let visited : Array[String] = []
  let queue : Array[String] = []
  if !array_contains(graph.nodes, start) {
    return visited
  }
  queue.push(start)
  visited.push(start)
  while queue.length() > 0 {
    let current = queue[0]
    let _ = queue.remove(0)
    for nb in neighbors(graph, current) {
      if !array_contains(visited, nb) {
        visited.push(nb)
        queue.push(nb)
      }
    }
  }
  visited
}

///|
/// DFS 遍历 | DFS traversal
pub fn dfs(graph : Graph, start : String) -> Array[String] {
  let visited : Array[String] = []
  if array_contains(graph.nodes, start) {
    dfs_helper(graph, start, visited)
  }
  visited
}

///|
/// DFS 辅助函数 | DFS helper
fn dfs_helper(
  graph : Graph,
  node : String,
  visited : Array[String],
) -> Unit {
  visited.push(node)
  for nb in neighbors(graph, node) {
    if !array_contains(visited, nb) {
      dfs_helper(graph, nb, visited)
    }
  }
}

///|
/// 是否有路径 | Check if path exists
pub fn has_path(
  graph : Graph,
  from : String,
  to : String,
) -> Bool {
  if from == to {
    return true
  }
  let reachable = bfs(graph, from)
  array_contains(reachable, to)
}

///|
/// 最短路径（BFS） | Shortest path (BFS-based)
pub fn shortest_path(
  graph : Graph,
  from : String,
  to : String,
) -> Array[String]? {
  if from == to {
    return Some([from])
  }
  if !array_contains(graph.nodes, from) || !array_contains(graph.nodes, to) {
    return None
  }
  let visited : Array[String] = []
  let queue : Array[String] = []

  let parent_map : Array[(String, String)] = []
  queue.push(from)
  visited.push(from)
  let mut found = false
  while queue.length() > 0 {
    let current = queue[0]
    let _ = queue.remove(0)
    if current == to {
      found = true
      break
    }
    for nb in neighbors(graph, current) {
      if !array_contains(visited, nb) {
        visited.push(nb)
        queue.push(nb)
        parent_map.push((nb, current))
      }
    }
  }
  if !found {
    return None
  }
  let path : Array[String] = []
  path.push(to)
  let mut current = to
  while current != from {
    for pair in parent_map {
      if pair.0 == current {
        current = pair.1
        path.insert(0, current)
        break
      }
    }
  }
  Some(path)
}

///|
/// 连通分量 | Connected components
pub fn connected_components(graph : Graph) -> Array[Array[String]] {
  let components : Array[Array[String]] = []
  let visited : Array[String] = []
  for node in graph.nodes {
    if !array_contains(visited, node) {
      let component = bfs(graph, node)
      for n in component {
        if !array_contains(visited, n) {
          visited.push(n)
        }
      }
      components.push(component)
    }
  }
  components
}

///|
/// 是否连通 | Check if connected
pub fn is_connected(graph : Graph) -> Bool {
  if graph.nodes.length() == 0 {
    return true
  }
  let reachable = bfs(graph, graph.nodes[0])
  reachable.length() == graph.nodes.length()
}

///|
/// 节点数 | Node count
pub fn node_count(graph : Graph) -> Int {
  graph.nodes.length()
}

///|
/// 边数 | Edge count
pub fn edge_count(graph : Graph) -> Int {
  graph.edges.length()
}

///|
/// 添加节点 | Add node
pub fn add_node(graph : Graph, node : String) -> Graph {
  if array_contains(graph.nodes, node) {
    return graph
  }
  let nodes = []
  for n in graph.nodes {
    nodes.push(n)
  }
  nodes.push(node)
  { ..graph, nodes }
}

///|
/// 添加边 | Add edge
pub fn add_edge(graph : Graph, edge : GraphEdge) -> Graph {
  let edges = []
  for e in graph.edges {
    edges.push(e)
  }
  edges.push(edge)
  { ..graph, edges }
}

///|
/// 空图 | Empty graph
pub fn empty_graph(graph_type : GraphType) -> Graph {
  { nodes: [], edges: [], graph_type }
}

///|
/// 图版本 | Graph version
pub fn graph_version() -> String {
  "moon-cross graph v0.2.8"
}

///|
/// 度数 | Degree of node
pub fn degree(graph : Graph, node : String) -> Int {
  neighbors(graph, node).length()
}

///|
/// 是否为孤立节点 | Check if isolated node
pub fn is_isolated(graph : Graph, node : String) -> Bool {
  degree(graph, node) == 0
}

///|
/// 格式化图 | Format graph
pub fn format_graph(graph : Graph) -> String {
  let type_str = match graph.graph_type {
    Directed => "directed"
    Undirected => "undirected"
  }
  let mut result = "Graph (" + type_str + ")\n"
  result = result + "Nodes: " + graph.nodes.length().to_string() + "\n"
  result = result + "Edges: " + graph.edges.length().to_string() + "\n"
  for edge in graph.edges {
    result = result + "  " + edge.from + " -> " + edge.to + " (w: " + edge.weight.to_string() + ")\n"
  }
  result
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