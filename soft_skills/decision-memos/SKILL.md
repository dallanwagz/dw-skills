---
name: decision-memos
description: "Use when asked to draft a structured decision memo or recommendation document. Produces one-page memos with: the call and rationale up front, real options with tradeoffs, key assumptions, risks with kill criteria, owners and dates, and cost of delay."
---

# Decision Memos and Recommendations

Purpose
Drive crisp, high-quality decisions fast. Your job is to widen options, surface tradeoffs, recommend a path, and make it easy to say yes.

Voice goal
Be decisive and evidence-backed. Lead with the call, show the why, state the risks and the next checkpoint.

Principles
Clarity over completeness. If it doesn’t change the decision, it’s appendix material.
Widen, then narrow. Generate real options before you choose.
Match rigor to reversibility. Two-way doors go fast; one-way doors raise the evidence bar.
Show your work. Assumptions, data sources, and how you’ll know if you’re wrong.
State the cost of delay. Time is a variable—price it.
Own the follow-through. Recommendation without owners, dates, and guardrails is theater.

One-page decision memo template
Title, owner, date, needed by
Put the decision in the title. Name the DRI. Include the decision deadline.

The recommendation in one paragraph
State the call and the why in plain language. Include the business outcome you expect and by when.

Context and objective
Two to three sentences on the customer or business problem and the goal. Keep history minimal and relevant.

Options and tradeoffs
List 2–4 real alternatives, each with 1–2 lines on impact, cost, risk, and time. Include a “do nothing” baseline.

Key assumptions and data
Name the few assumptions that drive the choice, where the data comes from, and confidence level. Link to details.

Risks, guardrails, and kill criteria
Top risks with mitigations, the guardrails you won’t cross, and clear stop/adjust triggers.

Execution plan and checkpoints
Who does what by when, first milestone, measurement plan, and the date for the first review.

Cost of delay
What waiting a week or a quarter costs in dollars, customer impact, or strategic position.

Ask
Exact decision you need, by when, and what happens by default if no decision is made.

Reversible vs. irreversible addendum
If two-way door: show the pilot scope, time-box, and rollback.
If one-way door: show deeper analysis, alternatives explored, and validation steps taken.

Example skeleton with dummy data
Title, owner, date, needed by
“Set free shipping threshold at $50 for Q2 pilot” — DRI: J. Lee — Date: Jun 3 — Decision needed by: Jun 10

The recommendation in one paragraph
Recommend a 90-day pilot at $50 to accelerate order growth while protecting margin; modeled to lift AOV by 7–9% and orders by 3–4%, with GM% flat to +20 bps at current mix.

Context and objective
Cart abandonment rises 12% at checkout friction points; free shipping is the top stated driver to complete purchase. Objective: raise conversion and AOV without eroding gross margin.

Options and tradeoffs
A) $25 threshold: highest conversion lift; margin risk requires vendor funding to break even in low-AOV cohorts.
B) $50 threshold (recommended): balanced lift with contained subsidy; fastest to pilot with existing promo engine.
C) $75 threshold: safest margin; minimal conversion impact; weak competitive stance.
D) Do nothing: preserve margin; lose share to competitors with lower thresholds.

Key assumptions and data
Assume 18% attach of add-on items when threshold is within 20% of current AOV; elasticity based on last year’s holiday promo cohort and current mix; confidence medium. Data from BI dashboards and A/B tests; details linked.

Risks, guardrails, and kill criteria
Risk: subsidy overruns in low-AOV categories. Guardrail: max $0.42 per order average subsidy; if exceeded for 7 days, roll APAC back to $75. Kill criteria: GM% down >40 bps for 14 days across two regions.

Execution plan and checkpoints
Pilot to NA/EU on Jun 24; metrics review Jun 28 and Jul 12; owner: Pricing Ops (rollout), Finance (margin tracking), PMM (messaging test). Dashboard live daily.

Cost of delay
Estimated $180k/week forgone gross profit during Q2 given current traffic.

Ask
Approve Option B by Jun 10 to hit the Jun 24 pilot; default if no decision by Jun 10 is Option C at $75.

Reversible vs. irreversible addendum
Two-way door: 90-day pilot, 10% traffic holdout, instant rollback via config flag.

Writing rules
Lead with the call and the why in the first five lines.
Force real alternatives; don’t straw-man.
Quantify impact and risk ranges; note confidence.
Name owners and dates; ambiguity kills action.
Price time; show the cost of delay.
If it’s a two-way door, propose a pilot; if one-way, raise the evidence bar.

Quality bar checklist
The decision is obvious from page one without reading links.
Options are real, with tradeoffs and a do-nothing baseline.
Assumptions are explicit and testable.
Risks have guardrails and clear kill/adjust triggers.
Owners, dates, metrics, and the first checkpoint are named.
