-- Insert/remove debug log statements. JS/TS/React are built in; PHP is added below.
-- Every statement contains the marker so <leader>vr can find and remove it again.
return {
  {
    "chrisgrieser/nvim-chainsaw",
    event = "VeryLazy",
    opts = {
      logStatements = {
        variableLog = { php = "dump('{{marker}} {{var}}', {{var}});" },
        objectLog = { php = "error_log('{{marker}} {{var}}: ' . print_r({{var}}, true));" },
        typeLog = { php = "dump('{{marker}} {{var}}: ' . get_debug_type({{var}}));" },
        assertLog = { php = "assert({{var}}, '{{marker}} {{var}} {{insert}}');" },
        emojiLog = { php = "dump('{{marker}} {{emoji}}');" },
        messageLog = { php = "dump('{{marker}} {{insert}}');" },
        stacktraceLog = { php = "dump('{{marker}}', debug_backtrace(DEBUG_BACKTRACE_IGNORE_ARGS));" },
        debugLog = { php = "xdebug_break(); // {{marker}}" },
      },
    },
    keys = {
      { "<leader>v", "", desc = "+log", mode = { "n", "x" } },
      { "<leader>vv", function() require("chainsaw").variableLog() end, desc = "Log Variable", mode = { "n", "x" } },
      { "<leader>vo", function() require("chainsaw").objectLog() end, desc = "Log Object", mode = { "n", "x" } },
      { "<leader>vt", function() require("chainsaw").typeLog() end, desc = "Log Type", mode = { "n", "x" } },
      { "<leader>va", function() require("chainsaw").assertLog() end, desc = "Log Assert", mode = { "n", "x" } },
      { "<leader>ve", function() require("chainsaw").emojiLog() end, desc = "Log Emoji" },
      { "<leader>vm", function() require("chainsaw").messageLog() end, desc = "Log Message" },
      { "<leader>vs", function() require("chainsaw").stacktraceLog() end, desc = "Log Stacktrace" },
      { "<leader>vd", function() require("chainsaw").debugLog() end, desc = "Debugger Statement" },
      { "<leader>vr", function() require("chainsaw").removeLogs() end, desc = "Remove Logs", mode = { "n", "x" } },
    },
  },
}
