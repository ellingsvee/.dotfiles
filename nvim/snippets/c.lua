-- See https://github.com/honza/vim-snippets/blob/master/snippets/c.snippets

local ls = require("luasnip")
local f = ls.function_node
local d = ls.dynamic_node
local r = ls.restore_node

-- Visual placeholder
-- taken from https://ejmastnak.com/

local get_visual = function(args, parent, default_text)
  if #parent.snippet.env.LS_SELECT_RAW > 0 then
    return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
  else -- If LS_SELECT_RAW is empty, return a blank insert node
    return sn(nil, i(1, default_text))
  end
end

local function v(pos, default_text)
  return d(pos, function(args, parent)
    return get_visual(args, parent, default_text)
  end)
end

M = {
  s({ trig = "def", name = "Define", snippetType = "autosnippet", wordTrig = false }, {
    f(function(_, snip)
      return snip.captures[1]
    end),
    t("#define"),
  }),
  s({ trig = "inc", name = "Include", snippetType = "autosnippet", wordTrig = false }, {
    t("#include <"),
    d(1, get_visual),
    t(".h>"),
  }),
  s({ trig = "for", name = "For Loop", snippetType = "autosnippet", wordTrig = false }, {
    t("for (int "),
    i(1, "i"), -- loop variable
    t(" = 0; "),
    rep(1), -- reuse loop variable
    t(" < "),
    d(2, get_visual),
    t("; "),
    rep(1), -- reuse loop variable again
    i(3, "++"), -- increment
    t(") {"),
    t({ "", "\t" }),
    i(4),
    t({ "", "}" }),
  }),
  s({ trig = "fun", name = "Function Definition", snippetType = "autosnippet", wordTrig = false }, {
    i(1, "void"), -- return type
    t(" "),
    d(2, get_visual),
    t("("),
    i(3), -- parameters
    t(") {"),
    t({ "", "\t" }),
    i(4), -- function body
    t({ "", "}" }),
  }),
  s({ trig = "wh", name = "While Loop", snippetType = "autosnippet", wordTrig = false }, {
    t("while ("),
    d(1, get_visual),
    t(") {"),
    t({ "", "\t" }),
    d(2, get_visual), -- visual fallback or insert node
    t({ "", "}" }),
  }),
  -- s({ trig = "pr", name = "printf", snippetType = "autosnippet", wordTrig = false }, {
  --   t('printf("'),
  --   d(1, get_visual),
  --   t('\\n"'),
  --   i(2), -- arguments
  --   t(");"),
  -- }),
  s({ trig = "if", name = "If Statement", snippetType = "autosnippet", wordTrig = false }, {
    t("if ("),
    d(1, get_visual, {}, { user_args = { "condition" } }),
    t(") {"),
    t({ "", "\t" }),
    d(2, get_visual, {}, { user_args = { "body" } }),
    t({ "", "}" }),
  }),
}

return M
