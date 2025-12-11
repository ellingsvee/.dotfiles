local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local d = ls.dynamic_node
local r = ls.restore_node
local c = ls.choice_node
local rep = require("luasnip.extras").rep

-- Math zone detection using Treesitter
local function in_mathzone()
  local ok, parser = pcall(vim.treesitter.get_parser, 0, "typst")
  if not ok or not parser then
    return false
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local cursor_row = cursor[1] - 1
  local cursor_col = cursor[2]

  local tree = parser:parse()[1]
  if not tree then
    return false
  end

  local root = tree:root()
  local node = root:descendant_for_range(cursor_row, cursor_col, cursor_row, cursor_col)

  while node do
    local node_type = node:type()
    if node_type == "math" or node_type == "equation" then
      return true
    end
    node = node:parent()
  end

  return false
end

-- Visual placeholder
local get_visual = function(args, parent, default_text)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else
    return sn(nil, i(1, default_text))
  end
end

local function v(pos, default_text)
  return d(pos, function(args, parent)
    return get_visual(args, parent, default_text)
  end)
end

-- Generate matrix helper for Typst
local generate_typst_matrix = function(args, snip)
  local rows = tonumber(snip.captures[2])
  local cols = tonumber(snip.captures[3])
  local nodes = {}
  local ins_indx = 1

  for j = 1, rows do
    table.insert(nodes, r(ins_indx, tostring(j) .. "x1", i(1)))
    ins_indx = ins_indx + 1
    for k = 2, cols do
      table.insert(nodes, t(", "))
      table.insert(nodes, r(ins_indx, tostring(j) .. "x" .. tostring(k), i(1)))
      ins_indx = ins_indx + 1
    end
    if j < rows then
      table.insert(nodes, t({ ";", "" }))
      table.insert(nodes, t("  "))
    end
  end

  return sn(nil, nodes)
end

-- Snippets
M = {
  -- Inline and display math
  s({ trig = "mk", name = "Inline math", snippetType = "autosnippet", wordTrig = false }, {
    t("$"),
    i(1),
    t("$"),
  }),

  s({ trig = "dm", name = "Display math", snippetType = "autosnippet" }, {
    t({ "$ ", "  " }),
    i(1),
    t({ "", "$" }),
  }),

  -- Math font/style snippets
  s({ trig = "mc", name = "Calligraphic", snippetType = "autosnippet", wordTrig = false }, {
    t("cal("),
    d(1, get_visual),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "mr", name = "Roman/upright", snippetType = "autosnippet", wordTrig = false }, {
    t("upright("),
    d(1, get_visual),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "bf", name = "Bold", snippetType = "autosnippet", wordTrig = false }, {
    t("bold(upright("),
    d(1, get_visual),
    t("))"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "bs", name = "Bold symbol", snippetType = "autosnippet", wordTrig = false }, {
    t("bold("),
    d(1, get_visual),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "tt", name = "Monospace", snippetType = "autosnippet", wordTrig = false }, {
    t("mono("),
    d(1, get_visual),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Text in math mode
  s({ trig = "tx", name = "Text in math", snippetType = "autosnippet", wordTrig = false }, {
    t('"'),
    v(1, "text"),
    t('"'),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Cases environment
  s({ trig = "(%d?)cs", name = "Cases", snippetType = "autosnippet", regTrig = true }, {
    t({ "cases(", "  " }),
    i(1, "condition_1 &quad text_1,"),
    t({ "", "  " }),
    i(2, "condition_2 &quad text_2"),
    t({ "", ")" }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Matrices
  s({ trig = "(%d+)x(%d+)", name = "Matrix NxM", snippetType = "autosnippet", regTrig = true }, {
    t({ "mat(", "  " }),
    d(1, generate_typst_matrix),
    t({ "", ")" }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "pmat", name = "Paren matrix", snippetType = "autosnippet" }, {
    t({ 'mat(delim: "(",', "  " }),
    i(1, "a, b;"),
    t({ "", "  " }),
    i(2, "c, d"),
    t({ "", ")" }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "bmat", name = "Bracket matrix", snippetType = "autosnippet" }, {
    t({ 'mat(delim: "[",', "  " }),
    i(1, "a, b;"),
    t({ "", "  " }),
    i(2, "c, d"),
    t({ "", ")" }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "vmat", name = "Vertical bar matrix", snippetType = "autosnippet" }, {
    t({ 'mat(delim: "|",', "  " }),
    i(1, "a, b;"),
    t({ "", "  " }),
    i(2, "c, d"),
    t({ "", ")" }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Subscripts and superscripts
  s({ trig = "TT", name = "Transpose", snippetType = "autosnippet", wordTrig = false }, {
    t("^T"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "inv", name = "Inverse", snippetType = "autosnippet", wordTrig = false }, {
    t("^(-1)"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "_", name = "Subscript", snippetType = "autosnippet", wordTrig = false }, {
    t("_("),
    d(1, get_visual),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "po", name = "Superscript", snippetType = "autosnippet", wordTrig = false }, {
    t("^("),
    d(1, get_visual),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "sr", name = "Squared", snippetType = "autosnippet", wordTrig = false }, {
    t("^2"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "cb", name = "Cubed", snippetType = "autosnippet", wordTrig = false }, {
    t("^3"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Fractions
  s({ trig = "//", name = "Fraction", snippetType = "autosnippet", wordTrig = false }, {
    t("frac("),
    i(1, "num"),
    t(", "),
    i(2, "den"),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "fr", name = "Fraction (alternative)", snippetType = "autosnippet" }, {
    t("frac("),
    i(1),
    t(", "),
    i(2),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Square root
  s({ trig = "sq", name = "Square root", snippetType = "autosnippet" }, {
    t("sqrt("),
    i(1),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Operators and functions
  s({ trig = "sum", name = "Sum", snippetType = "autosnippet" }, {
    t("sum_("),
    i(1, "i=1"),
    t(")^("),
    i(2, "n"),
    t(") "),
    i(3),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "prod", name = "Product", snippetType = "autosnippet" }, {
    t("product_("),
    i(1, "i=1"),
    t(")^("),
    i(2, "n"),
    t(") "),
    i(3),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "lim", name = "Limit", snippetType = "autosnippet" }, {
    c(1, {
      {
        t("lim_("),
        i(1, "x -> oo"),
        t(") "),
        i(2),
      },
      {
        t("lim"),
      },
    }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "int", name = "Integral", snippetType = "autosnippet" }, {
    t("integral_("),
    i(1, "a"),
    t(")^("),
    i(2, "b"),
    t(") "),
    i(3),
    t(" dif "),
    i(4, "x"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "opr", name = "Operator name", snippetType = "autosnippet", wordTrig = false }, {
    t('op("'),
    d(1, get_visual),
    t('")'),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Ceiling and floor
  s({ trig = "ce", name = "Ceiling", snippetType = "autosnippet" }, {
    c(1, {
      {
        t("ceil("),
        d(1, get_visual),
        t(")"),
      },
      {
        t("lr(⌈"),
        d(1, get_visual),
        t("⌉)"),
      },
    }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "fl", name = "Floor", snippetType = "autosnippet" }, {
    c(1, {
      {
        t("floor("),
        d(1, get_visual),
        t(")"),
      },
      {
        t("lr(⌊"),
        d(1, get_visual),
        t("⌋)"),
      },
    }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Relations and symbols
  s({ trig = "app", name = "Approximately", snippetType = "autosnippet", wordTrig = false }, {
    t("approx"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "sim", name = "Similar", snippetType = "autosnippet", wordTrig = false }, {
    t("tilde.op"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "pm", name = "Plus minus", snippetType = "autosnippet", wordTrig = false }, {
    t("plus.minus"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "too", name = "To arrow", snippetType = "autosnippet", wordTrig = false }, {
    t("arrow.r"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "tm", name = "Times", snippetType = "autosnippet", wordTrig = false }, {
    t("times"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "cd", name = "Centered dot", snippetType = "autosnippet", wordTrig = false }, {
    t("dot.c"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "cir", name = "Circle", snippetType = "autosnippet", wordTrig = false }, {
    t("circle.stroked.small"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "!=", name = "Not equal", snippetType = "autosnippet", wordTrig = false }, {
    t("eq.not"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "<=", name = "Less equal", snippetType = "autosnippet", wordTrig = false }, {
    t("lt.eq"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ">=", name = "Greater equal", snippetType = "autosnippet", wordTrig = false }, {
    t("gt.eq"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ">>", name = "Much greater", snippetType = "autosnippet", wordTrig = false }, {
    t("gt.double"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "<<", name = "Much less", snippetType = "autosnippet", wordTrig = false }, {
    t("lt.double"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "->", name = "Right arrow", snippetType = "autosnippet", wordTrig = false }, {
    t("arrow.r"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "=>", name = "Double right arrow", snippetType = "autosnippet", wordTrig = false }, {
    t("arrow.r.double"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "~~", name = "Approximately", snippetType = "autosnippet", wordTrig = false }, {
    t("tilde.op"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Common functions
  s({ trig = "max", name = "Maximum", snippetType = "autosnippet" }, {
    c(1, {
      { t("max") },
      {
        t("max_("),
        i(1),
        t(")"),
      },
    }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "min", name = "Minimum", snippetType = "autosnippet" }, {
    c(1, {
      { t("min") },
      {
        t("min_("),
        i(1),
        t(")"),
      },
    }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "sup", name = "Supremum", snippetType = "autosnippet" }, {
    c(1, {
      { t("sup") },
      {
        t("sup_("),
        i(1),
        t(")"),
      },
    }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "arg", name = "Argument", snippetType = "autosnippet", wordTrig = false }, {
    t("arg"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "deg", name = "Degree", snippetType = "autosnippet", wordTrig = false }, {
    t("deg"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "det", name = "Determinant", snippetType = "autosnippet", wordTrig = false }, {
    t("det"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "dim", name = "Dimension", snippetType = "autosnippet", wordTrig = false }, {
    t("dim"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "lap", name = "Laplacian", snippetType = "autosnippet" }, {
    t("laplace"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Special number sets
  s({ trig = "RR", name = "Real numbers", snippetType = "autosnippet", wordTrig = false }, {
    t("RR"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "NN", name = "Natural numbers", snippetType = "autosnippet", wordTrig = false }, {
    t("NN"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "ZZ", name = "Integers", snippetType = "autosnippet", wordTrig = false }, {
    t("ZZ"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "QQ", name = "Rationals", snippetType = "autosnippet", wordTrig = false }, {
    t("QQ"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "CC", name = "Complex numbers", snippetType = "autosnippet", wordTrig = false }, {
    t("CC"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Trigonometric functions
  s({ trig = "sin", name = "sin", snippetType = "autosnippet", wordTrig = false }, {
    t("sin"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "cos", name = "cos", snippetType = "autosnippet", wordTrig = false }, {
    t("cos"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "tan", name = "tan", snippetType = "autosnippet", wordTrig = false }, {
    t("tan"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "cot", name = "cot", snippetType = "autosnippet", wordTrig = false }, {
    t("cot"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "sec", name = "sec", snippetType = "autosnippet", wordTrig = false }, {
    t("sec"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "asin", name = "arcsin", snippetType = "autosnippet", wordTrig = false }, {
    t("arcsin"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "acos", name = "arccos", snippetType = "autosnippet", wordTrig = false }, {
    t("arccos"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "atan", name = "arctan", snippetType = "autosnippet", wordTrig = false }, {
    t("arctan"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "acot", name = "arccot", snippetType = "autosnippet", wordTrig = false }, {
    t("arccot"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "asec", name = "arcsec", snippetType = "autosnippet", wordTrig = false }, {
    t("arcsec"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "sinh", name = "sinh", snippetType = "autosnippet", wordTrig = false }, {
    t("sinh"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "cosh", name = "cosh", snippetType = "autosnippet", wordTrig = false }, {
    t("cosh"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "tanh", name = "tanh", snippetType = "autosnippet", wordTrig = false }, {
    t("tanh"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "coth", name = "coth", snippetType = "autosnippet", wordTrig = false }, {
    t("coth"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "log", name = "log", snippetType = "autosnippet", wordTrig = false }, {
    t("log"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "ln", name = "ln", snippetType = "autosnippet", wordTrig = false }, {
    t("ln"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "exp", name = "exp", snippetType = "autosnippet", wordTrig = false }, {
    t("exp"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Greek letters (semicolon prefix)
  s({ trig = ";a", name = "alpha", snippetType = "autosnippet", wordTrig = false }, {
    t("alpha"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";b", name = "beta", snippetType = "autosnippet", wordTrig = false }, {
    t("beta"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";g", name = "gamma", snippetType = "autosnippet", wordTrig = false }, {
    t("gamma"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";G", name = "Gamma", snippetType = "autosnippet", wordTrig = false }, {
    t("Gamma"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";d", name = "delta", snippetType = "autosnippet", wordTrig = false }, {
    t("delta"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";D", name = "Delta", snippetType = "autosnippet", wordTrig = false }, {
    t("Delta"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";e", name = "epsilon", snippetType = "autosnippet", wordTrig = false }, {
    t("epsilon"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";z", name = "zeta", snippetType = "autosnippet", wordTrig = false }, {
    t("zeta"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";t", name = "theta", snippetType = "autosnippet", wordTrig = false }, {
    t("theta"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";T", name = "Theta", snippetType = "autosnippet", wordTrig = false }, {
    t("Theta"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";k", name = "kappa", snippetType = "autosnippet", wordTrig = false }, {
    t("kappa"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";l", name = "lambda", snippetType = "autosnippet", wordTrig = false }, {
    t("lambda"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";L", name = "Lambda", snippetType = "autosnippet", wordTrig = false }, {
    t("Lambda"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";m", name = "mu", snippetType = "autosnippet", wordTrig = false }, {
    t("mu"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";n", name = "nu", snippetType = "autosnippet", wordTrig = false }, {
    t("nu"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";x", name = "xi", snippetType = "autosnippet", wordTrig = false }, {
    t("xi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";X", name = "Xi", snippetType = "autosnippet", wordTrig = false }, {
    t("Xi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";p", name = "pi", snippetType = "autosnippet", wordTrig = false }, {
    t("pi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";P", name = "Pi", snippetType = "autosnippet", wordTrig = false }, {
    t("Pi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";r", name = "rho", snippetType = "autosnippet", wordTrig = false }, {
    t("rho"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";s", name = "sigma", snippetType = "autosnippet", wordTrig = false }, {
    t("sigma"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";S", name = "Sigma", snippetType = "autosnippet", wordTrig = false }, {
    t("Sigma"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";t", name = "tau", snippetType = "autosnippet", wordTrig = false }, {
    t("tau"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";f", name = "phi", snippetType = "autosnippet", wordTrig = false }, {
    t("phi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";F", name = "Phi", snippetType = "autosnippet", wordTrig = false }, {
    t("Phi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";c", name = "chi", snippetType = "autosnippet", wordTrig = false }, {
    t("chi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";y", name = "psi", snippetType = "autosnippet", wordTrig = false }, {
    t("psi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";Y", name = "Psi", snippetType = "autosnippet", wordTrig = false }, {
    t("Psi"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";o", name = "omega", snippetType = "autosnippet", wordTrig = false }, {
    t("omega"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = ";O", name = "Omega", snippetType = "autosnippet", wordTrig = false }, {
    t("Omega"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Delimiters
  s({ trig = "lr(", name = "Left-right parentheses", snippetType = "autosnippet", wordTrig = false }, {
    t("lr(("),
    i(1),
    t("))"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "lr[", name = "Left-right brackets", snippetType = "autosnippet", wordTrig = false }, {
    t("lr(["),
    i(1),
    t("])"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "lr{", name = "Left-right braces", snippetType = "autosnippet", wordTrig = false }, {
    t("lr({"),
    i(1),
    t("})"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "lr|", name = "Left-right bars", snippetType = "autosnippet", wordTrig = false }, {
    t("lr(|"),
    i(1),
    t("|)"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Vectors and matrices
  s({ trig = "vec", name = "Vector", snippetType = "autosnippet" }, {
    t("vec("),
    i(1),
    t(")"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "mat", name = "Matrix", snippetType = "autosnippet" }, {
    t({ "mat(", "  " }),
    i(1, "a, b;"),
    t({ "", "  " }),
    i(2, "c, d"),
    t({ "", ")" }),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  -- Infinity and special symbols
  s({ trig = "oo", name = "Infinity", snippetType = "autosnippet", wordTrig = false }, {
    t("oo"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),

  s({ trig = "...", name = "Ellipsis", snippetType = "autosnippet", wordTrig = false }, {
    t("dots"),
  }, { condition = in_mathzone, show_condition = in_mathzone }),
}

return M
