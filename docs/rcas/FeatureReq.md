# Feature Request Procedure

**for RCAS Booking App**

<hr class="section-break strong" />





## Purpose

This procedure provides a simple and consistent method for proposing, assessing, approving and implementing changes to the RCAS Booking App.

A feature request is a **proposal for consideration**. Submission of a request does not mean that the feature will necessarily be implemented.

<hr class="section-break strong" />





## 1. Feature Request

A feature request should identify:

* **Requested by:** Name of person making the request
* **Date requested:** Date the request was received
* **Feature requested:** A short description of the proposed change
* **Problem or need:** What problem would this feature solve?
* **Who would use it:** Tutors, Booking Manager, administrators, or others
* **Importance:** Essential / Useful / Nice to have
* **Additional information:** Examples or circumstances that help explain the request

The emphasis should initially be on the **problem to be solved**, rather than prescribing a particular technical solution.

<hr class="section-break strong" />






## 2. Initial Review

The request will be reviewed to determine:

* whether the requested capability already exists;
* whether the problem can be solved without changing the application;
* whether the request is consistent with the purpose of the Booking App;
* which users and existing functions could be affected;
* whether changes to the Booking Form, Bookings Sheet, Calendar integration or administrative processes would be required;
* whether the change could affect existing bookings or data;
* the approximate complexity and risk of implementing it.

The request may then be classified as:

**Accept** — suitable for implementation.

**Investigate** — potentially useful, but further analysis or discussion is required.

**Defer** — worthwhile, but not currently a priority.

**Decline** — not appropriate for the Booking App, or the cost/complexity outweighs the benefit.

<hr class="section-break strong" />





## 3. Specification

Before development begins, an accepted feature should have a brief written specification describing:

* what the feature must do;
* what it must **not** do;
* who can use it;
* expected behaviour under normal circumstances;
* important exceptions and error conditions;
* any changes to existing procedures.

Where appropriate, acceptance tests should be identified before coding begins.

<hr class="section-break strong" />





## 4. Development

Changes should be made in a controlled development or test environment wherever practicable.

Existing working production code should not be altered merely to experiment with a possible solution.

Any assumptions discovered during development should be recorded and, where they materially change the requested feature, referred back for clarification.

<hr class="section-break strong" />





## 5. Testing

The new feature should be tested for:

* its intended behaviour;
* invalid or unexpected input;
* interaction with existing Booking App functions;
* Booking Sheet data integrity;
* Calendar behaviour where applicable;
* permissions and administrative functions where applicable;
* regression — ensuring that previously working functions still work.

Existing tests should continue to pass.

<hr class="section-break strong" />





## 6. Approval for Release

A successfully developed feature should not automatically become a production feature simply because it works.

Before release, confirm that:

* the implementation satisfies the agreed request;
* testing has been completed;
* any procedural consequences are understood;
* relevant RCAS users have been informed or documentation updated where necessary.

<hr class="section-break strong" />





## 7. Release

Once approved:

1. Back up or otherwise preserve the known-good production version.
2. Deploy the tested change.
3. Perform a basic production check.
4. Record the release and the feature implemented.
5. Update user or administrator documentation where required.

<hr class="section-break strong" />





## 8. Feature Request Record

Each request should retain a simple history:

| Item              | Record                                 |
| ----------------- | -------------------------------------- |
| Request ID        | FR-YYYY-NNN                            |
| Requested by      |                                        |
| Date              |                                        |
| Feature           |                                        |
| Problem/need      |                                        |
| Priority          | Essential / Useful / Nice to have      |
| Decision          | Accept / Investigate / Defer / Decline |
| Decision notes    |                                        |
| Specification     |                                        |
| Testing completed |                                        |
| Released          |                                        |
| Release/version   |                                        |

<hr class="section-break strong" />





## Guiding Principle

**Describe the problem first. Decide on the solution second.**

A feature request establishes a need for consideration; it does not prescribe the implementation.
