-- ── rainbow-delimiters ──────────────────────────────────────────────────
-- Colors each level of nested brackets/braces/parens with a distinct color.
-- Particularly useful in complex generic type expressions and nested lambdas.
local rainbow = require("rainbow-delimiters")
require("rainbow-delimiters.setup").setup({
    strategy = {
        [""] = rainbow.strategy["global"],
    },
    query = {
        [""] = "rainbow-delimiters",
        java = "rainbow-delimiters",
    },
    priority = {
        [""] = 110,
        lua  = 210,
    },
    highlight = {
        "RainbowDelimiterRed",
        "RainbowDelimiterYellow",
        "RainbowDelimiterBlue",
        "RainbowDelimiterOrange",
        "RainbowDelimiterGreen",
        "RainbowDelimiterViolet",
        "RainbowDelimiterCyan",
    },
})
