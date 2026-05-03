---
name: dei-review
description: Package the current conversation's original prompt and your proposed solution as a peer-review request the user can paste into a *different* LLM (Gemini, ChatGPT, Grok, Llama — anything that isn't the same model that wrote the proposal). After the user pastes the external review back, integrate it critically — adopt what fits, push back on what doesn't. Use when the user says "/dei-review", "peer review this", "second opinion from another model", "have another LLM look at this", or pastes back a block of review feedback from a different model.
---

# dei-review — diverse-model peer review

The point: a single LLM has one set of training-data biases, one set of failure modes, one default style. A different model — Gemini, GPT, Grok, whoever — was trained on different data with different objectives and notices different things. Routing the same problem through two of them and bringing the disagreement back doubles the search space for free.

The "DEI" here is **diversity of models** — different training, different priors, different blind spots. Not the political/HR sense of the term. Don't bring that framing into the output.

Play chess, not checkers.

---

## How this skill works

You will run **one of two phases** depending on what the user just said:

- **Phase 1 — package the request.** The user invoked `/dei-review` (or equivalent) right after you produced a proposal. Build a peer-review prompt and print it for them to copy-paste into another model.
- **Phase 2 — integrate the review.** The user pasted a review back from the other model. Read it critically, sort the feedback, and propose specific revisions to your original solution.

Pick the phase from context. If the most recent user turn is a short invocation following your proposal → Phase 1. If it contains a block of review-flavored text from another assistant → Phase 2.

If you genuinely can't tell, ask one short question and stop.

---

## Phase 1 — Package the request

### What to capture

Walk back through the conversation and gather:

1. **The original user prompt.** The request that started this work. If follow-ups materially shaped the scope, fold them in. Quote it verbatim — don't paraphrase the user's words.
2. **Your proposed solution.** Include:
   - A 2–4 sentence summary of the approach.
   - The actual artifact (code, config, schema, plan, diagram description). The reviewer needs the real thing to critique it. Do not summarize it away.
   - Any tradeoffs or assumptions you made.
   - Open questions you flagged but didn't resolve.
3. **Codebase / environment context the reviewer doesn't have.** Language, framework, deployment target, scale, constraints, conventions. Be specific but tight — the reviewer is *outside* the codebase and will drown if you dump too much. Aim for a bullet list, not a tour.

### Reviewer framing

Cast the recipient model as a **senior peer engineer with deep experience in the relevant stack**. Pick credentials that match the actual work — don't claim "10 years of Databricks" if the work is a Rust CLI. Examples:

- Gradio + Databricks app → "10+ years Python, ~5 years each Databricks and Gradio"
- React component refactor → "Senior frontend engineer, 8+ years React, strong on accessibility and rendering performance"
- Postgres schema change → "Staff DBA, 12+ years Postgres, focused on operational correctness and migrations at scale"
- Terraform + AWS networking → "Principal infra engineer, deep AWS networking and IaC at scale"

Frame the review as **informed input, not a directive**. The original assistant (you) knows the codebase. The reviewer does not. This wording matters — it tells the reviewer to weigh in on design and surface alternatives, not to LARP as the team lead.

### Output template

Print the review request as a single fenced ` ```markdown ` block so the user can triple-click, select-all, copy, and paste it elsewhere without manual cleanup. Fill every `{{placeholder}}`.

````markdown
You are a {{role and credentials matching the stack — e.g. "senior Python engineer with 10+ years experience, ~5 years each on Databricks and Gradio"}}. I'm forwarding work that was produced by a different LLM and I want a second opinion from a different model with a different training set and different priors. Treat this as informed architectural input — your job is to assess fit, surface blind spots, and propose materially different alternatives. The original assistant knows the codebase; you do not. Do not be a yes-man. Strong takes welcome.

## Original request

{{verbatim original user prompt — exactly what the user typed, in a quote block}}

## Codebase / environment context

- {{language and version}}
- {{framework / runtime / deployment target}}
- {{relevant constraints — scale, latency, regulatory, team conventions}}
- {{anything else a reviewer needs to evaluate fit}}

## Proposed solution

{{2–4 sentence plain-language summary of the approach and why}}

### Artifact

{{the actual code / config / schema / plan in appropriate language fences. Include the real thing — do not summarize it away}}

### Tradeoffs and assumptions made

- {{...}}
- {{...}}

### Open questions the original assistant flagged

- {{...}}

## What I want back

1. **Critique** — what's weak, wrong, or risky? Be specific and concrete. Cite line/section if it helps.
2. **Alternatives** — at least one materially different approach and what it would buy.
3. **Blind spots** — assumptions worth challenging, edge cases I should worry about, failure modes I'm probably missing.
4. **Verdict** — would you ship this as-is, ship with changes, or rethink the approach? One sentence.

Don't hedge. If you'd do it differently, say so and why.
````

### After printing

End with a one-line nudge to the user: tell them to paste the review back into the chat when they have it, and you'll integrate it (Phase 2). Do not do any further work in this turn.

---

## Phase 2 — Integrate the returned review

When the user pastes a review back:

### Read for substance, not tone

Different models have different defaults — some sycophantic, some hyperbolic, some hedge everything, some over-confident. Cut through that. Pull out the actual technical claims and rank them on merit.

A confident reviewer is not a correct reviewer. The whole point of getting a different perspective is that *your* model's confidence is also not correctness — but the reviewer's confidence isn't either. Both are inputs.

### Sort feedback into four buckets

- **Adopt** — correct, applicable, improves the solution. Apply it.
- **Adapt** — there's a real concern underneath, but the proposed fix doesn't fit this codebase. Capture the concern and propose a better-fitting change.
- **Reject (with reason)** — wrong, doesn't apply, or trades off worse than current. Say *why* in one sentence. The user needs to evaluate your judgment, not just trust it.
- **Investigate** — can't evaluate without checking something (a file, a benchmark, a doc, a runtime behavior). Name what you'll check, then actually check it before concluding.

### Output

Present the buckets to the user explicitly, in that order. For each item:

- **Adopt / Adapt** → show the concrete change as a diff, revised snippet, or updated plan bullet.
- **Reject** → one-sentence reason.
- **Investigate** → name the check, run it, report back.

Reference review points by short paraphrase — do not dump the full review text back at the user, they already have it.

### Then ask

End with: *"Want me to apply the Adopt + Adapt changes now, or revise the plan first?"*

---

## Things to avoid

- **Don't capitulate.** Don't rewrite everything just because another model criticized it. Models are confident; that doesn't make them right. Push back when warranted.
- **Don't ask the reviewer to co-author.** The review prompt asks for critique and alternatives, not "which is better, A or B?" That's your call to make with the user.
- **Don't strip the artifact.** A review of a summary is a review of a summary. The reviewer needs the real code/config/plan.
- **Don't smuggle in the wrong "DEI".** This skill is about diverse *models*. Don't editorialize the term in the output.
- **Don't run both phases in one turn.** Phase 1 ends when you print the request. Phase 2 starts when the user pastes the response. Mixing them defeats the round-trip.
