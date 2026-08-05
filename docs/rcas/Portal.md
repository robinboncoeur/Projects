# Member Portal


## Al's Suggestion

Hi Robin,

That's a good question, and I think this is where Squarespace's terminology causes confusion.

A **Squarespace Member Site** is **not** simply "a page with a login."

It's really designed for people selling courses, premium content, videos, downloads, etc. Visitors create an account (or buy a membership), log in, and can then access protected content. You can also make a Member Site free—users still create an account, but don't pay. ([Squarespace Support][1])

For RCAS, that means you'd be using perhaps **5%** of what it's designed for.

---

### Option 1 – Shared page password

**(my preference)**

```
Tutor Portal
   │
Shared password
   │
Booking Form
```

Pros

* Free
* Very simple
* Almost zero administration
* No tutor accounts to maintain
* Perfectly adequate if the only thing behind the page is:

  * booking form
  * tutor handbook
  * calendar
  * contacts

Cons

* Everyone knows the same password.

Personally, I don't see that as a problem for RCAS.

---

### Option 2 – Squarespace Member Site

```
Tutor Portal
      │
Individual account
(email/password)
      │
Booking Form
```

Pros

* Every tutor has their own login.
* You can disable one tutor without affecting anyone else.
* Password resets are handled by Squarespace.
* No password storage in Apps Script. ([Squarespace Support][1])

Cons

* More administration.
* Designed for memberships rather than a handful of volunteer tutors.
* Depending on your legacy Squarespace subscription, it may require an additional subscription if Member Sites aren't already included. ([Squarespace Support][2])

---

### Option 3 – Apps Script login

```
Tutor Portal
      │
Apps Script login
      │
Booking Form
```

This is the one I'd avoid.

Not because it can't be done.

Because suddenly you're responsible for:

* password storage
* password resets
* account lockouts
* session management
* security updates

That's a lot of engineering for very little benefit.

---

**If it were my project...**

I'd ask one question:

> **What problem are we trying to solve?**

If the answer is:

> "We don't want the general public booking RCAS rooms."

Then a **shared page password** solves it beautifully.

If the answer is:

> "We need to know that only Julie can submit bookings as Julie."

Then you start looking at individual accounts.

---

**One thing I wondered...**

Do you actually need a login at all?

Your current workflow is:

* Tutor submits request.
* Committee approves or rejects.
* Calendar updates only after approval.

There's no financial transaction, no access to personal data, and no ability for tutors to modify existing bookings.

So the risk is already quite low.

I'd be tempted to keep it very simple:

```
Tutor Portal
    │
Shared password
    │
Booking form
    │
Tutor dropdown
    │
Submit
```

The committee remains the gatekeeper.

---

### One idea that might appeal to the engineer in you...

Rather than authenticating *people*, authenticate *permissions*.

The booking app doesn't need to know who is logged in.

It only needs to know:

* "Can this person access the Tutor Portal?" → Squarespace answers that (or the shared password does).
* "Which tutor is this booking for?" → The dropdown answers that.
* "Should this booking become live?" → The committee answers that.

Each layer has one job.

That separation keeps the whole system much simpler and much easier to maintain over the next five years. And, from what I've seen of your code, it fits very naturally with the architecture you've already built.

[1]: https://support.squarespace.com/hc/en-us/articles/360050832631-Member-Sites?utm_source=chatgpt.com "Member Sites – Squarespace Help Center"
[2]: https://support.squarespace.com/hc/en-us/articles/14721894632589-Squarespace-website-platform-plans?utm_source=chatgpt.com "Squarespace website platform plans – Squarespace Help Center"
