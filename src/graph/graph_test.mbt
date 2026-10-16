test "make_edge" {
  let e = @graph.make_edge("a", "b")
  assert_eq(e.from, "a")
  assert_eq(e.to, "b")
  assert_eq(e.weight, 1)
}

test "make_weighted_edge" {
  let e = @graph.make_weighted_edge("a", "b", 5)
  assert_eq(e.weight, 5)
}

test "build_graph" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  assert_eq(@graph.node_count(g), 2)
  assert_eq(@graph.edge_count(g), 1)
}

test "neighbors_directed" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("a", "c")],
  )
  let nb = @graph.neighbors(g, "a")
  assert_eq(nb.length(), 2)
}

test "neighbors_undirected" {
  let g = @graph.build_graph(
    @graph.GraphType::Undirected,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  let nb_a = @graph.neighbors(g, "a")
  assert_eq(nb_a.length(), 1)
  let nb_b = @graph.neighbors(g, "b")
  assert_eq(nb_b.length(), 1)
}

test "bfs_simple" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("b", "c")],
  )
  let result = @graph.bfs(g, "a")
  assert_eq(result.length(), 3)
  assert_eq(result[0], "a")
}

test "bfs_disconnected" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b")],
  )
  let result = @graph.bfs(g, "a")
  assert_eq(result.length(), 2)
}

test "bfs_not_in_graph" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a"],
    [],
  )
  let result = @graph.bfs(g, "x")
  assert_eq(result.length(), 0)
}

test "dfs_simple" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("b", "c")],
  )
  let result = @graph.dfs(g, "a")
  assert_eq(result.length(), 3)
  assert_eq(result[0], "a")
}

test "has_path_true" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("b", "c")],
  )
  assert_true(@graph.has_path(g, "a", "c"))
}

test "has_path_false" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b")],
  )
  assert_true(!@graph.has_path(g, "a", "c"))
}

test "has_path_self" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a"],
    [],
  )
  assert_true(@graph.has_path(g, "a", "a"))
}

test "shortest_path_direct" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  match @graph.shortest_path(g, "a", "b") {
    Some(path) => {
      assert_eq(path.length(), 2)
      assert_eq(path[0], "a")
      assert_eq(path[1], "b")
    }
    None => assert_true(false)
  }
}

test "shortest_path_multi_hop" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("b", "c")],
  )
  match @graph.shortest_path(g, "a", "c") {
    Some(path) => assert_eq(path.length(), 3)
    None => assert_true(false)
  }
}

test "shortest_path_no_path" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [],
  )
  match @graph.shortest_path(g, "a", "b") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "shortest_path_self" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a"],
    [],
  )
  match @graph.shortest_path(g, "a", "a") {
    Some(path) => assert_eq(path.length(), 1)
    None => assert_true(false)
  }
}

test "connected_components_single" {
  let g = @graph.build_graph(
    @graph.GraphType::Undirected,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("b", "c")],
  )
  let components = @graph.connected_components(g)
  assert_eq(components.length(), 1)
}

test "connected_components_multiple" {
  let g = @graph.build_graph(
    @graph.GraphType::Undirected,
    ["a", "b", "c", "d"],
    [@graph.make_edge("a", "b")],
  )
  let components = @graph.connected_components(g)
  assert_eq(components.length(), 3)
}

test "is_connected_true" {
  let g = @graph.build_graph(
    @graph.GraphType::Undirected,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("b", "c")],
  )
  assert_true(@graph.is_connected(g))
}

test "is_connected_false" {
  let g = @graph.build_graph(
    @graph.GraphType::Undirected,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b")],
  )
  assert_true(!@graph.is_connected(g))
}

test "is_connected_empty" {
  let g = @graph.empty_graph(@graph.GraphType::Undirected)
  assert_true(@graph.is_connected(g))
}

test "node_count" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [],
  )
  assert_eq(@graph.node_count(g), 3)
}

test "edge_count" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  assert_eq(@graph.edge_count(g), 1)
}

test "add_node" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a"],
    [],
  )
  let g2 = @graph.add_node(g, "b")
  assert_eq(@graph.node_count(g2), 2)
}

test "add_node_existing" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a"],
    [],
  )
  let g2 = @graph.add_node(g, "a")
  assert_eq(@graph.node_count(g2), 1)
}

test "add_edge" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [],
  )
  let g2 = @graph.add_edge(g, @graph.make_edge("a", "b"))
  assert_eq(@graph.edge_count(g2), 1)
}

test "empty_graph" {
  let g = @graph.empty_graph(@graph.GraphType::Directed)
  assert_eq(@graph.node_count(g), 0)
  assert_eq(@graph.edge_count(g), 0)
}

test "graph_version" {
  let v = @graph.graph_version()
  assert_true(v.contains("graph"))
}

test "degree" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b", "c"],
    [@graph.make_edge("a", "b"), @graph.make_edge("a", "c")],
  )
  assert_eq(@graph.degree(g, "a"), 2)
  assert_eq(@graph.degree(g, "b"), 0)
}

test "is_isolated_true" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  assert_true(@graph.is_isolated(g, "b"))
}

test "is_isolated_false" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  assert_true(!@graph.is_isolated(g, "a"))
}

test "format_graph" {
  let g = @graph.build_graph(
    @graph.GraphType::Directed,
    ["a", "b"],
    [@graph.make_edge("a", "b")],
  )
  let formatted = @graph.format_graph(g)
  assert_true(formatted.contains("directed"))
  assert_true(formatted.contains("a -> b"))
}