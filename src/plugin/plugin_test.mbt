test "plugin: make plugin info" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "A test plugin")
  assert_eq(info.name, "my-plugin")
  assert_eq(info.version, "1.0.0")
  assert_true(info.enabled)
}

test "plugin: make plugin entry" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  assert_eq(entry.info.name, "my-plugin")
  assert_eq(entry.hooks.length(), 1)
  assert_eq(entry.priority, 1)
}

test "plugin: register plugin" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  let registry = @plugin.register_plugin([], entry)
  assert_eq(registry.length(), 1)
}

test "plugin: register duplicate plugin" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  let registry = @plugin.register_plugin([], entry)
  let registry2 = @plugin.register_plugin(registry, entry)
  assert_eq(registry2.length(), 1)
}

test "plugin: unregister plugin" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  let registry = @plugin.register_plugin([], entry)
  let registry2 = @plugin.unregister_plugin(registry, "my-plugin")
  assert_eq(registry2.length(), 0)
}

test "plugin: list plugins" {
  let info1 = @plugin.make_plugin_info("plugin1", "1.0.0", "author", "desc")
  let info2 = @plugin.make_plugin_info("plugin2", "1.0.0", "author", "desc")
  let registry = [
    @plugin.make_plugin_entry(info1, [], 1),
    @plugin.make_plugin_entry(info2, [], 2),
  ]
  let list = @plugin.list_plugins(registry)
  assert_eq(list.length(), 2)
}

test "plugin: find plugins for hook" {
  let info1 = @plugin.make_plugin_info("plugin1", "1.0.0", "author", "desc")
  let info2 = @plugin.make_plugin_info("plugin2", "1.0.0", "author", "desc")
  let registry = [
    @plugin.make_plugin_entry(info1, [@plugin.PluginHook::PreCompile], 1),
    @plugin.make_plugin_entry(info2, [@plugin.PluginHook::PostCompile], 2),
  ]
  let found = @plugin.find_plugins_for_hook(registry, @plugin.PluginHook::PreCompile)
  assert_eq(found.length(), 1)
  assert_eq(found[0].info.name, "plugin1")
}

test "plugin: execute hook" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  let registry = @plugin.register_plugin([], entry)
  let results = @plugin.execute_hook(registry, @plugin.PluginHook::PreCompile)
  assert_eq(results.length(), 1)
  assert_true(results[0].success)
}

test "plugin: disable plugin" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  let registry = @plugin.register_plugin([], entry)
  let disabled = @plugin.disable_plugin(registry, "my-plugin")
  assert_false(disabled[0].info.enabled)
}

test "plugin: enable plugin" {
  let info = @plugin.make_plugin_info("my-plugin", "1.0.0", "author", "desc")
  let entry = @plugin.make_plugin_entry(info, [@plugin.PluginHook::PreCompile], 1)
  let registry = @plugin.register_plugin([], entry)
  let disabled = @plugin.disable_plugin(registry, "my-plugin")
  let enabled = @plugin.enable_plugin(disabled, "my-plugin")
  assert_true(enabled[0].info.enabled)
}

test "plugin: hook to string" {
  assert_eq(@plugin.PluginHook::PreCompile.to_string(), "pre_compile")
  assert_eq(@plugin.PluginHook::PostCompile.to_string(), "post_compile")
  assert_eq(@plugin.PluginHook::PreCodegen.to_string(), "pre_codegen")
  assert_eq(@plugin.PluginHook::PostCodegen.to_string(), "post_codegen")
  assert_eq(@plugin.PluginHook::PreFfi.to_string(), "pre_ffi")
  assert_eq(@plugin.PluginHook::PostFfi.to_string(), "post_ffi")
}

test "plugin: version" {
  assert_true(@plugin.plugin_version().contains("v1.1.0"))
}

test "template: builtin templates" {
  let templates = @plugin.builtin_templates()
  assert_true(templates.length() >= 4)
}

test "template: find template" {
  let result = @plugin.find_template("basic-library")
  let found = match result {
    Some(_) => true
    None => false
  }
  assert_true(found)
}

test "template: find template not found" {
  assert_eq(@plugin.find_template("nonexistent"), None)
}

test "template: templates by category" {
  let library_templates = @plugin.templates_by_category("library")
  assert_true(library_templates.length() >= 1)
  let ffi_templates = @plugin.templates_by_category("ffi")
  assert_true(ffi_templates.length() >= 1)
}

test "template: make params" {
  let params = @plugin.make_template_params("mylib", ["windows", "ios"], true, "author")
  assert_eq(params.project_name, "mylib")
  assert_eq(params.target_platforms.length(), 2)
  assert_true(params.ffi_enabled)
}

test "template: generate basic library" {
  let params = @plugin.make_template_params("mylib", ["windows"], false, "author")
  let files = @plugin.generate_template_files("basic-library", params)
  assert_true(files.length() >= 5)
  let mut has_moon_mod = false
  for file in files {
    if file.path == "moon.mod" {
      has_moon_mod = true
    }
  }
  assert_true(has_moon_mod)
}

test "template: generate ffi wrapper" {
  let params = @plugin.make_template_params("mylib", ["windows"], true, "author")
  let files = @plugin.generate_template_files("ffi-wrapper", params)
  assert_true(files.length() >= 8)
}

test "template: version" {
  assert_true(@plugin.template_version().contains("v1.1.0"))
}