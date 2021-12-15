  local present, luasnip = pcall(require, "luasnip")
  if present then
     luasnip.config.set_config {
        history = true,
        updateevents = "TextChanged,TextChangedI",
     }

     require("luasnip/loaders/from_vscode").load { paths = chadrc_config.plugins.options.luasnip.snippet_path }
     require("luasnip/loaders/from_vscode").load()
  end
