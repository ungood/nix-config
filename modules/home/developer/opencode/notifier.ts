/**
 * OpenCode plugin: desktop notifications via node-notifier.
 *
 * Sends a native notification when:
 *   - A session finishes (idle)
 *   - A session errors
 *   - A permission is requested
 *   - The question tool asks for input
 *
 * Works on macOS (Notification Center) and Linux (notify-send).
 */

import { basename } from "node:path";
import type { Plugin } from "@opencode-ai/plugin";
import notifier from "node-notifier";

function notify(title: string, message: string): void {
  notifier.notify({
    title,
    message,
    timeout: 5,
  });
}

export const NotifierPlugin: Plugin = async ({ directory }) => {
  const project = basename(directory || process.cwd());
  const title = `OpenCode (${project})`;

  return {
    event: async ({ event }) => {
      switch (event.type) {
        case "session.idle":
          notify(title, "Session complete");
          break;
        case "session.error":
          notify(title, "Session error");
          break;
        case "permission.asked":
          notify(title, "Permission requested");
          break;
      }
    },
    "tool.execute.before": async (input) => {
      if (input.tool === "question") {
        notify(title, "Waiting for input");
      }
    },
  };
};

export default NotifierPlugin;
