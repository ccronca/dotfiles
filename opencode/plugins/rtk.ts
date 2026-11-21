import { Plugin } from "@opencode/plugin"
import { execFile } from "node:child_process"
import { promisify } from "node:util"

const run = promisify(execFile)

// RTK OpenCode plugin — rewrites shell commands to use rtk for token savings.
// Requires: rtk >= 0.23.0 in PATH.
//
// This is a thin delegating plugin: all rewrite logic lives in `rtk rewrite`,
// which is the single source of truth (src/discover/registry.rs).
// To add or change rewrite rules, edit the Rust registry — not this file.

export default Plugin.define({
  id: "rtk",
  async setup(ctx) {
    try {
      await run("rtk", ["--version"])
    } catch {
      console.warn("[rtk] rtk binary not found in PATH — plugin disabled")
      return
    }

    await ctx.shell.hook("create.before", async (event) => {
      try {
        const { stdout } = await run("rtk", ["rewrite", event.command], { timeout: 10_000 })
        const rewritten = stdout.trim()
        if (rewritten && rewritten !== event.command) event.command = rewritten
      } catch {
        // rtk rewrite failed — pass through unchanged
      }
    })
  },
})
