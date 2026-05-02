---
name: launch-readiness
description: "Use when asked to assess launch readiness, build a go/no-go checklist, or define post-launch guardrails. Produces readiness templates with definition-of-ready criteria, rollout plans, tripwires, rollback steps, and learning loops."
---

# Launch Readiness and Post‑Launch Guardrails

Purpose
Ship confidently, avoid self‑inflicted wounds, and learn fast once customers touch the product. Readiness is proof you’re prepared; guardrails are how you move fast without breaking trust.

Voice goal
Be precise and practical. State what’s ready, what isn’t, the risks you accept, and the tripwires that force action.

Principles
Start from the customer promise. Readiness is measured against the experience you’ve told customers to expect.
Freeze the target. Define “go/no‑go” in writing before emotions run hot.
Fewer, better signals. Track the minimum inputs that predict outcomes; dashboards don’t save bad choices.
Two clocks. One for launch date, one for time‑to‑detect and time‑to‑recover.
Own the rollback. Fast forward requires fast reverse.
Document once, communicate predictably. One source of truth; consistent updates lower anxiety.

Launch readiness template
Goal and date
One sentence that states what you’re launching, for whom, and by when.

Definition of ready
The short list that must be true to launch:
• Customer experience: critical paths tested across devices/regions; help and docs live.
• Engineering: error budgets in range; feature flags and config tested; rollback verified.
• Data/analytics: events validated end‑to‑end; dashboards live; alert thresholds set.
• Support/ops: paging on; runbooks current; on‑call schedule staffed; comms templates ready.
• Legal/compliance: approvals signed; data handling and retention reviewed.
• Sales/marketing: messaging final; enablement complete; status page plan defined.

Go/no‑go criteria
Explicit gates with owners and evidence. Green ships; Yellow requires named exception owner and mitigation; Red holds.

Cut scope to make date
Pre‑approved trims you’ll take before moving the date. Each has a customer impact line and a re‑add plan.

Dependencies and contracts
Named external and internal dependencies with SLAs, test artifacts, and fallbacks if they miss.

Rollout plan
Phased exposure with levers:
• Cohort or percentage ramp
• Region or platform order
• Dark launch and shadow traffic details
• Manual hold points and who can lift them

Incident play
Single channel, commander on duty, update cadence, and the “visible fixes” you’ll deploy while deeper work proceeds.

Post‑launch guardrails template
Success metrics
The few numbers that prove the bet: adoption, conversion, engagement, revenue per user, or ticket deflection. Include targets and evaluation windows.

Input signals you control
Leading indicators like activation rate, setup completion, latency, and error classes. Tie each to an owner and review cadence.

Customer health
CSAT/NPS deltas for affected cohorts, top contact drivers, and churn or downgrade rates. Include qualitative sampling plan.

Operational guardrails
Lines you won’t cross: error rate ceilings, latency bands, crash rates, fraud/abuse thresholds, cost per transaction, and page load budgets.

Tripwires and dates
Pre‑set thresholds and calendar checkpoints that force a review or action. Each has an automatic response: pause, roll back, or continue with a mitigation.

Rollback plan
Exact steps, owner, timing, and data loss/customer messaging implications. Practice it before launch; don’t write it during an outage.

Learning loop
Initial readout date, what questions you’ll answer, what would cause scale‑up, and what would cause redesign. Publish the template so the team knows how judgment will be applied.

Example skeleton (dummy data)
Goal and date
“Launch Express Checkout on mobile web for US credit‑card customers by July 9.”

Definition of ready
Customer: Pay in ≤2 taps; success screen with receipt; help article live.
Engineering: P95 ≤ 400 ms end‑to‑end on staging; 1‑click rollback tested; flags per region.
Data: Checkout\_started, Checkout\_success, Error\_code events validated; dashboard live.
Support: On‑call staffed 24/7 for 7 days; macro replies in CRM; status page draft.
Legal: PCI review signed; terms updated.
Marketing: In‑app banner copy approved; hold external PR until 100% rollout.

Go/no‑go criteria
Green: P95 ≤ 420 ms in 3 regions; error rate ≤ 0.1%; payments auth ≥ 98.4%.
Yellow: One metric out of range but mitigated with owner/ETA.
Red: Payments auth < 97.5% or Sev‑1 in pilot cohort.

Cut scope to make date
Defer card‑scanner to v1.1; impact: +1.5 seconds average entry time; re‑add in two sprints.

Dependencies and contracts
Payments gateway SLA 99.95%; signed capacity test at 8k RPS; fallback to Gateway B with +$0.04/txn.

Rollout plan
5% US traffic Monday 10 a.m. PT, hold 4 hours; 25% Tuesday; 50% Wednesday; 100% Friday if guardrails hold. Commander: Rivera.

Incident play
Single Slack channel #express‑war‑room; 30‑minute updates until green; status page if >30 minutes user impact.

Post‑launch guardrails
Success: +3–4% conversion vs control by week 2; refund rate unchanged.
Inputs: Activation ≥ 82%; form‑fill abandon ≤ 9%; owner: Patel; daily reviews 9 a.m.
Customer health: CSAT delta ≥ -1; top contact driver trend shared daily; sample 20 tickets/day.
Operational: Error ≤ 0.1%; P95 ≤ 420 ms; auth ≥ 98.4%; infra cost ≤ +$8k/week.
Tripwires: If P95 > 450 ms for 60 minutes, pause ramp; if auth < 98% for 30 minutes, roll back last cohort.
Rollback plan
Config flag revert in 5 minutes; sessions recover without data loss; banner pulled; post in‑app message to affected users.

Learning loop
Jul 12 first readout: activation funnel, conversion lift, contact drivers, latency by device. Scale trigger: lift ≥ 2.5% with guardrails green. Redesign trigger: lift < 1% by week 3 or persistent auth variance by device.

Writing rules
State the promise and prove readiness against it.
Name owners and timers for every guardrail and tripwire.
Prefer input signals to lagging outcomes.
Pre‑decide scope cuts and defaults.
Practice the rollback before you need it.
Set the first readout date before you launch.
