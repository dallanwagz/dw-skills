---
name: escalation-playbook
description: "Use when asked to draft an escalation, manage a blocked dependency, or structure a war-room response. Produces tiered escalation templates with options, owners, timers, and next checkpoints."
---

# Escalation Playbook

Purpose
Turn “we’re blocked” into a predictable path to green. Escalation isn’t tattling; it’s a mechanism to protect customers, dates, and people by surfacing constraints with options and owners.

Voice goal
Be calm, specific, and solution‑oriented. Name the problem, the impact, the options, and the next checkpoint.

Principles
Escalate issues, not people. Describe the constraint and facts; leave blame out.
Bad news early, with a plan. Leaders forgive problems; they don’t forgive surprises.
Bring options and tradeoffs. Make it easy to choose a path.
Single owner, single timer. Every escalation has one DRI and a clock.
Document once, broadcast appropriately. One source of truth; share it to the right audience.

When to escalate
Trigger any time one of these is true:
A critical date, customer commitment, or SLA is at risk.
Cross‑team dependency won’t meet its commitment.
Risk likelihood > medium with high impact.
You lack authority or resources to unblock within 24–48 hours.

Levels and cadence
Level 0: Self‑help. Direct conversation with the owner team. Give clear asks, a deadline, and offer help. Timebox: 24 hours.
Level 1: Manager‑to‑manager. Share the written summary and options to both managers. Ask for a decision or resource. Timebox: 24–48 hours.
Level 2: Director/GM alignment. Frame business impact, tradeoffs, and your recommendation. Request a call if needed. Timebox: 48 hours.
Level 3: Executive/Steering. One‑pager decision with cost of delay and rollback plan. Timebox: set by business urgency; default 72 hours.
Incident hot path: If customers are actively impacted, skip levels and engage the incident channel immediately.

Escalation template
Subject: Escalation —  — Impact by  — Decision needed by

What
One sentence that names the issue in observable terms.

So what
Concrete impact on customers, dates, SLAs, or costs. Quantify ranges if exacts aren’t known.

Why now
Trigger that moved this from risk to escalation. Include what changed since last update.

Current state
What’s been done, what’s blocked, owners, and timers in flight.

Options
Two to four real paths with one‑line tradeoffs on impact, cost, and risk. Include a “do nothing” baseline.

Recommendation
Your call with rationale tied to business goals and constraints.

Asks
Exact decisions, resources, or approvals needed, by when, and default if no decision is made.

Next checkpoint
Date and time for the next update, plus what will be true then.

Example (dummy data)
Subject: Escalation — Partner API quota cap — Risks June 14 launch — Decision by Jun 6 EOD

What
Partner API quota is capped at 5k RPS; our modeled peak is 7.2k. Attempts to secure a temporary raise are pending beyond the partner’s stated SLA.

So what
At 5k RPS, checkout latency in APAC will exceed 450 ms P95 during peak, reducing conversion by an estimated 0.12–0.18 pts and risking ~$140k/day gross margin in week one.

Why now
Partner missed their 48‑hour quota review SLA; our internal load‑test shows sustained breach above 6k RPS.

Current state
We’ve optimized our batch size and implemented client‑side backoff; owner: Priya. Partner ticket escalated to Tier 2; owner: Alex. Internal infra can absorb +10% cost for throttling; owner: Ming.

Options
A) Secure partner quota raise to 8k RPS. Best CX, external dependency risk, no internal cost.
B) Throttle APAC at peak for 7 days. Preserves stability, costs ~$9.5k infra, minor CX degradation.
C) Stagger APAC launch by 2 weeks. Eliminates risk now, slips June revenue, reputational hit.
D) Do nothing. Launch on time, accept higher latency and conversion loss.

Recommendation
Approve Option B now and continue pressing Option A. This protects launch date and revenue while we work the partner path. Roll off throttling once quota is raised.

Asks
Approve up to $12k infra spend for 7 days to support throttling by today 5 pm PT. Escalate partner ticket to exec sponsor if no response by tomorrow 10 am local.

Next checkpoint
Jun 6, 3 pm PT: confirm partner response and APAC throttling performance with updated conversion deltas.

War room guidance
For incidents or time‑critical risks, stand up a short‑term war room with a single comms channel, 30–60 minute sprints, named owners, and a predictable update cadence. Use “visible fixes” to slow anxiety while permanent work proceeds.

Comms rules that lower anxiety
Name owners and ETAs; close every open loop.
Prefer specifics over adjectives; numbers over feelings.
Keep blame out; stick to facts and choices.
State the default if no decision is made and the rollback plan.

Documentation and learning
Maintain a single escalation doc per issue with timestamps, decisions, and outcomes. After resolution, do a short post‑mortem that captures root cause, what worked, what failed, and the mechanisms you’ll install to prevent recurrence. Convert lessons into checklists, SLAs, or design changes so the system learns.
