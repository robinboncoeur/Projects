# Testing v0.1a


## Checklist


<img src="/assets/images/rcas/Logo-RCASsm.jpg" style="float: right; width: 420px; margin-left: 20px" />


---

### ✅ Clean Testing Sequence

Here’s a practical, no-nonsense checklist you can work through. Think of it as: `Will this App survive real humans?` 😄 

---

### 🔹 Phase 1 — Basic Form Behaviour

* 🔲 Open `/exec` link (not `/dev`)
* 🔲 Logo displays correctly
* 🔲 Layout looks clean on desktop
* 🔲 Try mobile (optional but nice)

#### Field validation

* 🔲 Leave required fields blank → error shown
* 🔲 Enter past date → blocked by picker / browser
* 🔲 Enter end time earlier than start → error shown
* 🔲 Enter non-30-min time → error shown

---

### 🔹 Phase 2 — Submission Flow

#### Normal booking

* 🔲 Submit valid booking
* 🔲 Success message appears
* 🔲 Form resets
* 🔲 Row appears in sheet
* 🔲 Status = `Pending`

---

### 🔹 Phase 3 — Approval Workflow

In the sheet:

* 🔲 Change `Status` from `Pending` → `Approved`
* 🔲 Calendar event is created
* 🔲 `Processing Note` updated
* 🔲 Event ID written

---

### 🔹 Phase 4 — Conflict Detection

#### Create a clash

* 🔲 Create booking A (Approved)
* 🔲 Create booking B (same room + overlapping time)
* 🔲 Try to approve booking B

Expected:

* 🔲 Status becomes `Conflict`
* 🔲 Processing Note explains conflict
* 🔲 No calendar event created

---

### 🔹 Phase 5 — Assigned Room Logic

#### Resolve conflict

* 🔲 Change `Assigned Room` on conflicted booking
* 🔲 Confirm:

  * note updates correctly
  * status behaves as expected (your current design: stays `Conflict`)

#### Approved booking change

* 🔲 Take an approved booking
* 🔲 Change `Assigned Room`

Expected:

* 🔲 Calendar event deleted
* 🔲 Status → `Pending`
* 🔲 Note updated

---

### 🔹 Phase 6 — Cancellation Flow

* 🔲 Change `Status` → `Cancelled` on approved booking

Expected:

* 🔲 Calendar event removed
* 🔲 Event ID cleared
* 🔲 Note updated

---

### 🔹 Phase 7 — Recurring Bookings

#### Validation

* 🔲 Select “Recurring = Yes” without fields → error
* 🔲 Enter invalid repeatUntil < eventDate → error

#### Valid recurring

* 🔲 Submit valid recurring booking
* 🔲 Approve it
* 🔲 Confirm expected behaviour (depending on your implementation)

---

### 🔹 Phase 8 — Multi-User Reality Check

With your partner:

* 🔲 She submits a booking via form
* 🔲 You see it in sheet
* 🔲 You approve it
* 🔲 Calendar updates correctly

---

### 🔹 Phase 9 — Edge Cases (Quick Sweep)

* 🔲 Blank Assigned Room → still uses requested Room
* 🔲 Change time after Pending → still valid
* 🔲 Change time after Approved → triggers reset (if implemented)
* 🔲 Very short booking (30 mins) → works
* 🔲 Long booking → works

---

### 🔹 Phase 10 — Final Deployment Sanity

Before going live:

* 🔲 Confirm web app setting:

  👉 **Execute as: Me**
  👉 **Who has access: Anyone with the link**

* 🔲 Test form from:

  * different browser
  * incognito window


<hr style="height:24px;border-width:0;color:black;background-color:black">
