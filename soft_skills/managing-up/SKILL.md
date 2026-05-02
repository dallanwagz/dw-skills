---
name: managing-up
description: "Use when asked to draft a weekly executive update, prepare a monthly readout, or structure a manager 1:1. Produces outcome-led updates with status, risks, decisions, and metrics formatted for executive consumption."
---

# Managing Up and Executive Updates

Purpose
Make it easy for your manager and skip‑level to back you, allocate resources, and protect priorities. Your updates should reduce anxiety, surface decisions early, and attach your name to outcomes.

Voice goal
Be bright, be quick, be gone. Lead with outcomes, offer options, recommend a path, and state the next checkpoint.

Principles
Clarity over completeness. You’re judged on judgment, not word count.
No surprises. Bad news early with a concrete plan.
Own the frame. Translate activity into business impact.
Bring options with a recommendation. Make yes the easiest path.
Right altitude. Context for executives, details in links.

Weekly executive update template
Subject: Week of  –  –

TL;DR
One or two sentences on outcomes and meaning. Example: “Shipped phased rollout to 25% with zero Sev‑1s; on track for 100% Tuesday barring partner delay.”

Status and what changed
Color plus one sentence why. Then three short deltas since last update focused on decisions, milestones, or risks retired.

Risks and mitigations
Top one to three, each with impact, likelihood, trigger, mitigation, owner, and an explicit ask if needed. Keep to a few crisp lines per risk.

Decisions needed
Decision, options with one‑liners on tradeoffs, your recommendation with rationale, deadline, and the cost of delay.

Next milestones
Date, milestone, confidence. Limit to three. State what will be true when done.

Metrics snapshot
Targets vs actuals that prove health and trajectory, with one‑line interpretation per metric. Link to dashboard for detail.

Links
PRD, roadmap, metrics, prior updates. Links support the story; they are not the story.

One‑pager monthly readout template
Title and date
The point in one paragraph: what you want the leader to know, decide, or do.
Context in two sentences: why now, customer or business signal.
Results to date: three quantified outcomes tied to goals.
Plan and milestones: next steps with dates and confidence.
Top risks: two biggest with mitigations in flight.
Decision/ask: options, your recommendation, rationale, cost of delay.

Executive 1:1 agenda template
Open with outcomes in one minute.
Cover one decision with options and your recommendation.
Raise one risk early with your plan and any ask.
Close with alignment on next checkpoint and what you will deliver by then.

Crisis update template
Subject: Incident  –  – Next update
What happened, customer impact, current state, next ETA, working theory of root cause, mitigations and owners, risks/blocks, asks. Timebox to what an exec needs to know now.

Operating contract with your manager
Cadence: weekly written update by end of day Thursday; monthly one‑pager first Monday; incident updates every X hours until stable, then daily until closed.
Format: use the weekly template above; no attachments for core update, links for detail.
Escalation: if Red, page immediately, don’t wait for cadence. If Yellow two weeks running, propose a plan to return to Green with tradeoffs.
Decisions: defaults after deadline if no response, with stated rationale and rollback plan.

Quality bar checklist
Lead with outcomes, not activity.
Every risk has an owner, mitigation, and trigger.
Every decision includes a recommendation and the cost of delay.
Dates are exact. “June 9, 3 pm PT” beats “next week.”
If it’s Red or bad news, it arrives early with a plan.

Example weekly update (dummy data)
Subject: Week of Jun 3 – Checkout Latency – Green

TL;DR
P95 checkout latency down 18% week over week after cache‑warm fix; conversion recovered to 3.1% vs 3.0% target. On track to hit 3.2% by Friday pending Partner A rollout.

Status and what changed
Green because we hit latency target bands in 3 of 4 regions and error rates are stable.
Changes:
• Rolled cache‑warm fix to NA/EU; APAC staged to 50%.
• Approved Partner A throttle; rollout scheduled Thu 2 pm PT.
• Finalized rollback plan for edge cases; tested in staging.

Risks and mitigations
Partner A rollout could slip 48 hours due to their freeze, delaying APAC conversion recovery by ~0.1 pts. Trigger: no deploy by Thu 5 pm PT. Mitigation: temporary rate‑limit relaxation capped at +$6k infra for 72 hours. Ask: approve spend cap.
Hidden N+1 in legacy service may reappear under >5k RPS. Trigger: P95 > 420 ms for 30 min. Mitigation: auto‑scale rule + pre‑warmed pool; owner: Priya; fallback: revert to prior build within 20 min.

Decisions needed
Approve temporary infra spend up to $6k for 72 hours to cover Partner A delay. Options: A) approve now, B) wait for Thu confirmation, C) do not approve. I recommend A to avoid conversion dip; cost of delay is ~$14k/day gross margin if APAC slips.

Next milestones
Thu Jun 6: Partner A rollout complete – 80% confidence.
Fri Jun 7: P95 ≤ 400 ms in all regions – 70% confidence.
Tue Jun 11: Post‑fix retro complete with action items – 100% confidence.

Metrics snapshot
Conversion: 3.1% vs 3.0% target, trending up with APAC pending.
P95 latency: 405 ms NA/EU, 428 ms APAC staged; target ≤ 400 ms.
Error rate: 0.07% vs ≤ 0.10% target, stable week over week.

Links
Dashboard, rollout plan, rollback plan, prior update.

Promotion signal
Consistent, crisp executive updates build trust, which buys you decision speed, resource cover, and ultimately scope. Managing up well is the control system for your career.
