test "default_dependency_config" {
  let cfg = @dependency.default_dependency_config()
  assert_true(!cfg.include_dev)
  assert_true(cfg.include_transitive)
  assert_eq(cfg.max_depth, 100)
}

test "make_edge" {
  let edge = @dependency.make_edge("a", "b")
  assert_eq(edge.from, "a")
  assert_eq(edge.to, "b")
}

test "build_graph_basic" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "c")],
  )
  assert_eq(@dependency.node_count(graph), 3)
  assert_eq(@dependency.edge_count(graph), 2)
}

test "find_node_exists" {
  let graph = @dependency.build_graph(["a", "b"], [@dependency.make_edge("a", "b")])
  match @dependency.find_node(graph, "a") {
    Some(node) => assert_eq(node.name, "a")
    None => assert_true(false)
  }
}

test "find_node_not_exists" {
  let graph = @dependency.build_graph(["a"], [])
  match @dependency.find_node(graph, "x") {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "direct_deps" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("a", "c")],
  )
  let deps = @dependency.direct_deps(graph, "a")
  assert_eq(deps.length(), 2)
}

test "direct_deps_empty" {
  let graph = @dependency.build_graph(["a"], [])
  let deps = @dependency.direct_deps(graph, "a")
  assert_eq(deps.length(), 0)
}

test "direct_dependents" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "c"), @dependency.make_edge("b", "c")],
  )
  let dependents = @dependency.direct_dependents(graph, "c")
  assert_eq(dependents.length(), 2)
}

test "transitive_deps" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "c")],
  )
  let deps = @dependency.transitive_deps(graph, "a")
  assert_eq(deps.length(), 2)
}

test "transitive_deps_self" {
  let graph = @dependency.build_graph(["a"], [])
  let deps = @dependency.transitive_deps(graph, "a")
  assert_eq(deps.length(), 0)
}

test "transitive_dependents" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "c"), @dependency.make_edge("b", "c")],
  )
  let dependents = @dependency.transitive_dependents(graph, "c")
  assert_eq(dependents.length(), 2)
}

test "is_leaf_true" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  assert_true(@dependency.is_leaf(graph, "b"))
}

test "is_leaf_false" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  assert_true(!@dependency.is_leaf(graph, "a"))
}

test "is_root_true" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  assert_true(@dependency.is_root(graph, "a"))
}

test "is_root_false" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  assert_true(!@dependency.is_root(graph, "b"))
}

test "dependency_depth_zero" {
  let graph = @dependency.build_graph(["a"], [])
  assert_eq(@dependency.dependency_depth(graph, "a"), 0)
}

test "dependency_depth_one" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  assert_eq(@dependency.dependency_depth(graph, "a"), 1)
}

test "dependency_depth_two" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "c")],
  )
  assert_eq(@dependency.dependency_depth(graph, "a"), 2)
}

test "has_cycle_false" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "c")],
  )
  assert_true(!@dependency.has_cycle(graph))
}

test "has_cycle_true" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "a")],
  )
  assert_true(@dependency.has_cycle(graph))
}

test "has_cycle_self" {
  let graph = @dependency.build_graph(
    ["a"],
    [@dependency.make_edge("a", "a")],
  )
  assert_true(@dependency.has_cycle(graph))
}

test "topological_sort_no_cycle" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "c")],
  )
  match @dependency.topological_sort(graph) {
    Some(sorted) => assert_eq(sorted.length(), 3)
    None => assert_true(false)
  }
}

test "topological_sort_with_cycle" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b"), @dependency.make_edge("b", "a")],
  )
  match @dependency.topological_sort(graph) {
    Some(_) => assert_true(false)
    None => assert_true(true)
  }
}

test "format_graph" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  let formatted = @dependency.format_graph(graph)
  assert_true(formatted.contains("Dependency Graph"))
  assert_true(formatted.contains("a -> b"))
}

test "dependency_version" {
  let v = @dependency.dependency_version()
  assert_true(v.contains("dependency"))
}

test "empty_graph" {
  let graph = @dependency.empty_graph()
  assert_eq(@dependency.node_count(graph), 0)
  assert_eq(@dependency.edge_count(graph), 0)
}

test "node_count" {
  let graph = @dependency.build_graph(["a", "b", "c"], [])
  assert_eq(@dependency.node_count(graph), 3)
}

test "edge_count" {
  let graph = @dependency.build_graph(
    ["a", "b"],
    [@dependency.make_edge("a", "b")],
  )
  assert_eq(@dependency.edge_count(graph), 1)
}

test "orphan_nodes" {
  let graph = @dependency.build_graph(
    ["a", "b", "c"],
    [@dependency.make_edge("a", "b")],
  )
  let orphans = @dependency.orphan_nodes(graph)
  assert_eq(orphans.length(), 1)
  assert_eq(orphans[0], "c")
}

test "merge_graphs" {
  let g1 = @dependency.build_graph(["a"], [])
  let g2 = @dependency.build_graph(["b"], [])
  let merged = @dependency.merge_graphs(g1, g2)
  assert_eq(@dependency.node_count(merged), 2)
}