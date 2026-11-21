Rewrite and improve the user's prompt using the local ai-rewriter service.

**About the ai-rewriter service:**

This command requires the ai-rewriter service to be running locally.
Repository: https://github.com/ccronca/ai-rewriter

The ai-rewriter is a local service that uses AI to improve text quality, grammar, and clarity.
It should be running on `http://127.0.0.1:8787` before using this command.

**How this command works:**

1. Extract the text provided after `/rw`
2. Call the ai-rewriter service at `http://127.0.0.1:8787/rewrite` with:
   - text: the user's prompt
   - mode: "claude-prompt"
3. Display both the original and improved versions to the user
4. Highlight key improvements (grammar, clarity, structure)
5. Proceed with answering the improved version

**API call format:**

```bash
curl -s -X POST http://127.0.0.1:8787/rewrite \
  -H "Content-Type: application/json" \
  -d '{"text":"USER_TEXT_HERE", "mode":"claude-prompt"}'
```

The service returns JSON: `{"result": "improved text here"}`

**Response format to user:**

```
📝 Your original prompt:
"[original text]"

✨ Improved version:
"[improved text]"

Key improvements:
- [improvement 1: e.g., Changed "how I can" to "how can I" - correct word order]
- [improvement 2: e.g., Added context for clarity]
- [improvement 3: e.g., Made the question more specific]

[Then proceed with answering the improved prompt]
```

**Error handling:**

- If the ai-rewriter service is unavailable (connection error), inform the user and proceed with the original text
- If the service returns the same text, it means no improvements were needed - inform the user

**Purpose:**

This command helps the user learn English by showing concrete examples of grammatical corrections and clarity improvements before answering their question.
