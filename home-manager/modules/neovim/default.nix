{ config, pkgs, ... }:

{
  programs.neovim = {
    viAlias = true;
    vimAlias = true;
    enable = true;
    extraLuaConfig = ''
    	${builtins.readFile ./nvim/remap.lua}
    	${builtins.readFile ./nvim/luasnip.lua}
    	${builtins.readFile ./nvim/set.lua}
    	${builtins.readFile ./nvim/plugin/lsp.lua}
    	${builtins.readFile ./nvim/plugin/colors.lua}
    	${builtins.readFile ./nvim/plugin/fugitive.lua}
    	${builtins.readFile ./nvim/plugin/telescope.lua}
    	${builtins.readFile ./nvim/plugin/flutter-tools.lua}
    	${builtins.readFile ./nvim/plugin/treesitter.lua}
    	${builtins.readFile ./nvim/plugin/nvim-tree.lua}
    	${builtins.readFile ./nvim/plugin/nvim-ts-autotag.lua}
    '';
    extraPackages = with pkgs; [
      mesonlsp
      pls
      pyright
      luajitPackages.lua-lsp
      lua-language-server
      markdown-oxide
      dockerfile-language-server-nodejs
      typescript-language-server
      vscode-langservers-extracted
      kotlin-language-server
      haskell-language-server
      ccls
      nixd
      nodePackages.prettier
    ];
    plugins = with pkgs.vimPlugins; [
      nvim-tree-lua
      nvim-ts-autotag
      rose-pine
      neoformat
      plenary-nvim
      null-ls-nvim
      dressing-nvim
      omnisharp-extended-lsp-nvim
      vim-prettier
      haskell-vim
	  nvim-colorizer-lua
	  lsp-format-nvim
      formatter-nvim
      flutter-tools-nvim
	  (nvim-treesitter.withPlugins (p: [
	  	p.tree-sitter-bash
	  	p.tree-sitter-haskell
	  	p.tree-sitter-java
	  	p.tree-sitter-javascript
	  	p.tree-sitter-json
	  	p.tree-sitter-lua
	  	p.tree-sitter-python
        p.tree-sitter-bibtex
        p.tree-sitter-css
        p.tree-sitter-dart
        p.tree-sitter-dockerfile
        p.tree-sitter-graphql
        p.tree-sitter-html
        p.tree-sitter-json5
        p.tree-sitter-kotlin
        p.tree-sitter-markdown
        p.tree-sitter-nix
        p.tree-sitter-scss
        p.tree-sitter-sql
        p.tree-sitter-tsq
        p.tree-sitter-typescript
        p.tree-sitter-vim
        p.tree-sitter-vue
      ]))
      nvim-treesitter.withAllGrammars
	  playground
	  vim-nix
	  lsp-zero-nvim
	  nvim-lspconfig
	  nvim-cmp
	  cmp-nvim-lsp
	  undotree
      vim-fugitive
      telescope-nvim
	  {
		plugin = pkgs.vimPlugins.vim-startify;
		config = "let g:startify_change_to_vcs_root = 0";
      }
	];
  };
}
