# Documentation v1b

<!--
---
title: "RCAS Booking Manager"
subtitle: "Documentation Pack"
author: "Prepared for Redland Coast Art Society"
date: "11 April 2026"
toc: true
toc-depth: 2
geometry: margin=1in
fontsize: 11pt
mainfont: Lato
linestretch: 1.15
header-includes:
  - |
    \usepackage{fancyhdr}
  - |
    \pagestyle{fancy}
  - |
    \fancyhf{}
  - |
    \lhead{RCAS Booking Manager}
  - |
    \rhead{Documentation Pack}
  - |
    \cfoot{\thepage}
---
/-->

<img src="/assets/images/rcas/Logo-RCASsm.jpg" style="float: right; width: 130px; margin-left: 20px" />

**Version:** 0.1b (current codebase review)  
**Purpose:** operational, admin, and technical reference  
**Primary audience:** bookings manager, office holders, and support/admin users



## 1. User Manual

### Purpose of the tool
The RCAS Booking Manager is used to receive booking requests for the Studio and Gallery, review them in the bookings sheet, and create approved bookings in Google Calendar.

The current codebase is designed to:

- collect booking requests through an Apps Script web form
- validate required fields before the request is accepted
- store each request in the `WebForm_Submissions` sheet
- mark each new request as **Pending**
- allow a booking manager to approve, reject, cancel, or re-route a booking
- automatically create a calendar event for approved bookings
- prevent room clashes when overlapping bookings target the same room

### Overview of the workflow
1. A tutor submits a booking request through the web form.
2. The request is written into the `WebForm_Submissions` sheet.
3. The booking is recorded with **Pending** status.
4. The booking manager reviews the request and checks availability.
5. If the booking is acceptable, the booking manager changes **Status** to **Approved**.
6. The script validates the row and attempts to create a calendar event.
7. If the room is already booked at that time, or the data is invalid, the booking is marked **Conflict** and the **Processing Note** explains why.

### The working sheet
**WebForm_Submissions**  
This is the main operational sheet used by the current code.

It contains:

- the booking details submitted through the web form
- the editable **Status** field
- the editable **Assigned Room** field
- a **Calendar Event ID** field used for tracking
- a **Processing Note** field used to explain outcomes, failures, and admin actions

### Meaning of each status

#### Pending
The booking has been received but not yet approved.

#### Approved
The booking has been approved by the booking manager. When a booking is changed to **Approved**, the script attempts to create the calendar event.

#### Rejected
The booking has been declined and will not be added to the calendar.

#### Conflict
The system has detected a problem that prevents approval. This may be a room clash, missing or invalid date/time information, an unrecognised room, or another validation failure. The booking manager should read the **Processing Note**.

#### Cancelled
The booking has been cancelled. If a live calendar event exists, the system attempts to remove it and then clears the linked event ID.

### How to process a booking
1. Open the `WebForm_Submissions` sheet.
2. Find new entries marked **Pending**.
3. Check the Google Calendar to confirm room availability.
4. If needed, enter a value in **Assigned Room**.
5. Change **Status** from **Pending** to **Approved**.
6. Wait a moment for the system to process the request.

Finally, confirm that:  
   - **Status** remains **Approved**  
   - **Calendar Event ID** has been filled in  
   - **Processing Note** confirms success

### If a different room is more suitable
If the requested room should be changed, use **Assigned Room**. Do not edit the original **Room** value unless you are deliberately correcting source data.

The system uses **Assigned Room** when it has a valid value. Otherwise, it uses the originally requested **Room**.

### What not to do
Do not:

- rename column headers
- delete operational columns
- overwrite **Calendar Event ID** casually
- assume a booking is complete without checking **Processing Note**
- use unsupported room names in **Assigned Room**

### What to do if something goes wrong
If a booking does not process correctly:

1. Read the **Processing Note**.
2. Check whether **Status** has changed to **Conflict**.
3. Confirm the booking details are complete and correct.
4. Check the Google Calendar.
5. If needed, retry only after the underlying issue has been corrected.

---

## 2. Admin Operations Guide

### Daily operating procedure
At the start of each booking session:

1. Open the `WebForm_Submissions` sheet.
2. Open the linked Google Calendar.
3. Review all new **Pending** requests.
4. Process each request one at a time.

### Standard approval procedure
For each **Pending** booking:

1. Read the request details.
2. Confirm the room and times requested.
3. Check the calendar manually.
4. If needed, assign a different room using **Assigned Room**.
5. Change **Status** to **Approved**.
6. Confirm that the script has completed successfully.

### When to leave a booking Pending
Leave a booking as **Pending** if:

- you need clarification from the requester
- the times are uncertain
- the room allocation is not yet decided
- you are waiting to confirm availability
- you are not ready to commit the booking to calendar

### When to mark a booking Rejected
Mark a booking **Rejected** if:

- the request cannot be accommodated
- the session should not proceed
- the requester has provided unsuitable or incomplete information and the booking will not be pursued
- management has decided not to accept the request

### When Conflict appears
**Conflict** means the system has prevented approval.

This can happen because:

- the room is already booked for the same time period
- the room value is not recognised
- the date or time values are invalid
- the booking start time is already in the past
- the end time is not later than the start time
- recurring fields are incomplete or inconsistent

When **Conflict** appears:

1. Read **Processing Note**.
2. Review the room, date, and time.
3. Check the calendar manually.
4. Correct any admin-controlled values if appropriate.
5. Try approval again only after the issue has been resolved.

### How to use Assigned Room
**Assigned Room** is used when the originally requested room should be changed for operational reasons.

Examples:

- a quieter session may be better placed in Gallery
- a practical or messy session may be better suited to Studio
- one room may already be occupied while the other is free

Procedure:

1. Leave the original **Room** value alone unless you are correcting source data.
2. Enter `Studio` or `Gallery` in **Assigned Room**.
3. Approve the booking.

### Important behaviour when Assigned Room is changed
The current logic makes **Assigned Room** a meaningful operational control:

- if the booking is already **Approved**, changing **Assigned Room** invalidates that approval, removes the live event if one exists, and returns the booking to **Pending**
- if the booking is already **Conflict**, changing **Assigned Room** keeps the booking in **Conflict** but updates the note so the manager knows to re-approve and re-test availability
- if the booking is **Pending**, **Rejected**, or **Cancelled**, the note is updated but no calendar action is taken

### Cancelling a booking
To cancel a booking:

1. Change **Status** to **Cancelled**.
2. The system will attempt to remove the linked calendar event.
3. The **Calendar Event ID** will be cleared.
4. The **Processing Note** will record what happened.

### Manual fallback procedure
If automation fails but the booking must still go ahead:

1. Check the calendar manually.
2. Create the calendar event manually.
3. Record the action in **Processing Note**.
4. Leave a clear note for follow-up.
5. Notify the developer if the automation failure needs investigation.

### Good operating discipline
- Work left to right across the row.
- Use **Processing Note** as the first source of truth for failures.
- Treat **Calendar Event ID** as a system field, not a note field.
- Raise unusual behaviour early rather than working around it silently.
- Change one thing at a time and then re-check the row.

---

## 3. Quick Reference

### Normal booking
Pending -> check calendar -> adjust Assigned Room if needed -> Approved

### If the booking succeeds
Look for:

- **Status** = Approved
- **Calendar Event ID** present
- **Processing Note** confirms success

### If the booking fails
Look for:

- **Status** = Conflict
- **Processing Note** explains why

### If a booking is cancelled
Look for:

- **Status** = Cancelled
- **Calendar Event ID** cleared
- **Processing Note** states whether the live event was removed, not found, or absent

### Never do this
- rename headers
- delete helper columns
- overwrite **Calendar Event ID**
- assume success without checking **Processing Note**
- enter unsupported room names

### First places to look when something seems wrong
1. **Status**
2. **Processing Note**
3. **Calendar Event ID**
4. Google Calendar
5. `System_Log`

---

## 4. Troubleshooting Guide

### Problem: the form refuses to submit
Likely causes:

- a required field is blank
- start or end time is not in 30-minute increments
- end time is earlier than or equal to start time
- recurring fields are incomplete
- the selected date is in the past

Checks:

- confirm all required fields are completed
- confirm times are in half-hour increments
- confirm end time is later than start time
- if recurring is set to **Yes**, confirm **Frequency** and **Repeat Until** are completed
- confirm **Repeat Until** is on or after **Event Date**

### Problem: a new booking does not appear in the sheet
Likely causes:

- the Apps Script web app is not deployed correctly
- script authorisation is incomplete
- the target sheet name does not match `CONFIG.SHEET_NAME`

Checks:

- confirm the web app opens and submits
- check Apps Script Executions
- confirm the sheet is named exactly `WebForm_Submissions`
- confirm the script has permission to access the spreadsheet

### Problem: approving a booking did not create a calendar event
Likely causes:

- required header mismatch
- invalid date/time parsing
- calendar permissions or authorisation issue
- the calendar ID is incorrect
- the booking hit a conflict or validation guard

Checks:

- inspect **Processing Note**
- inspect **Calendar Event ID**
- verify `CALENDAR_MODE` and `CALENDAR_ID`
- check Apps Script Executions
- confirm the calendar is accessible to the script account

### Problem: the booking became Conflict unexpectedly
Likely causes:

- another event already overlaps in the same room
- the room value is invalid or blank
- one or more date/time fields are missing
- the start time is in the past
- the end time is not later than the start time
- recurring information is incomplete or inconsistent

Checks:

- read **Processing Note**
- compare room/date/time to Google Calendar
- confirm **Assigned Room** if used
- confirm header names still match script expectations

### Problem: changing Assigned Room causes the booking to move out of Approved
Explanation:
This is intentional behaviour. If an already approved booking is moved to a different effective room, the current code treats that as a meaningful change that must be re-approved.

Expected result:

- the live event is removed if present
- status returns to **Pending**
- **Processing Note** explains what happened

### Problem: Calendar Event ID is blank after approval
Likely causes:

- event was not created
- script stopped before completion
- conflict prevented creation
- calendar lookup failed

Checks:

- inspect **Processing Note**
- inspect Apps Script Executions
- confirm whether the event exists in Google Calendar

### Problem: recurring booking says success but only one event appears
Explanation:
This matches the current code. The form and approval logic validate recurring fields, but the event-creation step still creates only a single event and records that recurring logic is not yet implemented.

### Problem: System_Log is missing
Explanation:
The log sheet is created on demand. It will be created the first time `logAction_()` runs if it does not already exist.

---

## 5. Test / UAT Checklist

### Form submission tests
- [ ] Web form opens correctly
- [ ] Required fields are enforced
- [ ] Past dates are rejected
- [ ] Start and end times must use 30-minute increments
- [ ] End time must be later than start time
- [ ] New submission appears in `WebForm_Submissions`
- [ ] New submission carries **Pending** status

### Approval tests
- [ ] Valid booking can be approved
- [ ] Calendar event is created in the configured calendar
- [ ] Calendar Event ID is written back to the sheet
- [ ] Processing Note confirms success

### Conflict tests
- [ ] Same room + overlapping time becomes **Conflict**
- [ ] Different room + overlapping time is allowed
- [ ] Invalid room value becomes **Conflict**
- [ ] Missing date/time becomes **Conflict**
- [ ] Start time in the past becomes **Conflict**
- [ ] End time earlier than start time becomes **Conflict**

### Assigned Room tests
- [ ] Blank **Assigned Room** uses the requested room
- [ ] Valid **Assigned Room** override creates event in the assigned room
- [ ] Changing **Assigned Room** on an approved booking removes the event and resets to **Pending**
- [ ] Changing **Assigned Room** on a conflict row updates **Processing Note**
- [ ] Original **Room** remains unchanged unless deliberately edited

### Status transition tests
- [ ] Changing **Approved** to **Rejected** removes the event
- [ ] Changing **Approved** to **Conflict** removes the event
- [ ] Changing **Approved** to **Cancelled** removes the event
- [ ] Cancelling a non-approved row leaves a clear Processing Note
- [ ] Re-approving an already linked row does not create a duplicate event

### Recurring tests
- [ ] Setting recurring to **Yes** requires **Frequency**
- [ ] Setting recurring to **Yes** requires **Repeat Until**
- [ ] **Repeat Until** cannot be earlier than **Event Date**
- [ ] Processing Note states that recurring logic is not yet implemented

### Stability tests
- [ ] Trigger continues to operate over multiple rows
- [ ] Calendar entries appear with correct title, location, and description
- [ ] System_Log records key actions

---

## 6. Technical / Developer Documentation

### System architecture
The current codebase consists of:

- an Apps Script HTML front end (`Index.html`)
- a server-side submission handler (`submitBooking`)
- a working spreadsheet tab called `WebForm_Submissions`
- Apps Script edit logic for approvals and room changes
- a Google Calendar used as the booking destination
- a `System_Log` sheet used for lightweight logging

### Data flow
1. The user opens the web app served by `doGet()`.
2. The form is rendered from `Index.html`.
3. On submit, the browser sends booking data to `submitBooking(formData)`.
4. `submitBooking()` validates the payload and appends a row to `WebForm_Submissions`.
5. The row is stored with **Pending** status and blank event-tracking fields.
6. A booking manager edits **Status** or **Assigned Room** in the sheet.
7. `onApprovalEdit(e)` routes the change to the appropriate handler.
8. If approved, `processApprovalRow_()` validates the row, checks same-room conflicts, and creates the calendar event.
9. The script writes back **Calendar Event ID** and **Processing Note**.

### Important assumptions
- The working sheet name must match `CONFIG.SHEET_NAME`.
- Header names used in code must match row 1 exactly after trimming.
- Supported rooms are currently only `Studio` and `Gallery`.
- Conflict checking relies on event overlap plus matching normalized room/location.
- The configured calendar must be accessible to the script.
- The spreadsheet is the operational source of truth.

### Key functions

#### doGet()
Serves the HTML booking form.

#### submitBooking(formData)
Validates required fields, recurring-field completeness, half-hour increments, and start/end order. Appends the booking to the sheet and logs the submission.

#### parseTimeToMinutes(timeStr)
Validates and converts `HH:MM` values into minutes since midnight.

#### onApprovalEdit(e)
Entry point for admin edits in the working sheet. Logs the edit, determines which column changed, and routes to either status handling or room-assignment handling.

#### handleStatusEdit_(sheet, row, headers, e)
Handles admin changes to **Status**. Routes approvals and cancellations, records simple notes for direct rejection/conflict actions, and includes a safety net that removes live events whenever a booking moves away from **Approved**.

#### handleAssignedRoomEdit_(e, sheet, row, headers)
Handles changes to **Assigned Room**. Compares the old and new effective room values and decides whether to do nothing, update the note, or invalidate an approved live booking.

#### processApprovalRow_(sheet, row, headers)
Reads the row, resolves the effective room, validates the booking, checks for same-room overlap, creates the calendar event, writes the event ID, and records the outcome in **Processing Note**.

#### processCancellationRow_(sheet, row, headers, oldStatus)
Builds a cancellation note and delegates event removal to `removeLiveCalendarEvent_()`.

#### hasRoomConflict_(calendar, start, end, room)
Looks for overlapping calendar events and returns `true` only when the overlapping event is in the same normalized room.

#### normalizeRoom_(value)
Normalises room text to the currently supported values: `Studio` or `Gallery`.

#### removeLiveCalendarEvent_(sheet, row, headers, baseNote, newStatus)
Clears the stored event ID, removes the linked event if possible, updates status if required, and writes a detailed note about the outcome.

#### getHeaders_(sheet)
Builds a header-name-to-column-number lookup from row 1.

#### valueByHeader_(rowValues, headers, headerName)
Returns a cell value using the header map.

#### trim_(value)
Normalises nullish values to empty string and trims text values.

#### getTargetCalendar_()
Returns either the default calendar or a calendar found by ID, depending on `CONFIG.CALENDAR_MODE`.

#### setPendingOnFormSubmit(e)
Optional support for spreadsheet form-submit workflows. In the current codebase, web-app submissions already append rows with **Pending**, so this function is only relevant if spreadsheet form submission is also used.

#### logAction_(level, message, details)
Writes structured entries to the `System_Log` sheet and creates that sheet if it does not already exist.

#### combineDateAndTime_(dateValue, timeValue)
Combines a date value and a time value into a JavaScript `Date` object suitable for calendar operations.

### Current validation rules in the code
A booking will not be approved if:

- the room is unrecognised
- date/time fields are missing
- date/time values are invalid
- the start time is in the past
- the end time is not later than the start time
- recurring is `Yes` but required recurring fields are missing
- `Repeat Until` is earlier than `Event Date`
- another event already overlaps in the same room

### Calendar event structure
The current script creates a calendar event with:

- a title in the form `Full Name (Room)`
- `location` set to the effective room
- a description containing:
  - Full Name
  - Email
  - Room
  - Course Name
  - Recurring
  - Frequency
  - Repeat Until

### Current implementation notes
- `CALENDAR_MODE` is currently set to `id`.
- The code snapshot points to a test calendar ID and includes a note to change it at go-live.
- Recurring bookings are validated, but recurring series creation is not yet implemented.
- The provided code snapshot references `findHeaderColumn_()` inside `handleAssignedRoomEdit_()`. That helper is not present in the supplied extract, so the live project should be checked to confirm the helper exists or that line has been updated.

---

## 7. Setup and Deployment Notes

### Initial setup
1. Create or open the spreadsheet.
2. Ensure the working tab is named `WebForm_Submissions`.
3. Ensure row 1 headers match the expected configuration exactly.
4. Paste the Apps Script code into the project.
5. Save the project.
6. Authorise required permissions.
7. Confirm the target calendar can be reached.
8. Deploy the web app.

### Calendar setup
Before go-live:

- confirm whether the project should keep using a dedicated calendar by ID
- replace the test calendar ID with the production calendar ID if required
- confirm the script has permission to create and delete events in that calendar

### Deployment notes
Because the booking UI is served by `doGet()` from `Index.html`:

- testers using the deployed `/exec` URL will not see HTML changes until the web app is redeployed
- code changes on the development/head deployment are not automatically reflected in an existing production deployment
- server-side code changes should be followed by testing in the environment actually being used

### Optional triggers
The current code includes logic suitable for:

- direct web-app submissions through `submitBooking()`
- sheet edit handling through `onApprovalEdit(e)`
- optional spreadsheet form-submit support through `setPendingOnFormSubmit(e)`

If spreadsheet-based triggers are used, confirm they are installed and authorised.

### Time zone
The spreadsheet, script project, and calendar should all be checked for consistent time zone settings.

Recommended setting: `Australia/Brisbane`.

### Testing order
1. Submit a web-form entry.
2. Confirm the row appears in `WebForm_Submissions`.
3. Confirm **Pending** appears.
4. Approve a valid booking.
5. Confirm the event is created.
6. Test a deliberate conflict.
7. Test an Assigned Room change on an approved row.
8. Test cancellation.

---

## 8. Data Dictionary

| Field | Source | Editable | Purpose |
|---|---|---:|---|
| Timestamp | script submission | no | submission audit trail |
| Full Name | web form | no | identifies requester |
| Email | web form | no | contact email for requester |
| Course Name | web form | no | identifies class or booking purpose |
| Room | web form | usually no | requested room |
| Event Date | web form | usually no | requested booking date |
| Start Time | web form | usually no | requested start time |
| End Time | web form | usually no | requested end time |
| Recurring | web form | usually no | indicates whether recurring details were requested |
| Frequency | web form | usually no | recurring interval supplied by requester |
| Repeat Until | web form | usually no | final requested date for recurrence |
| Status | script/admin | yes | workflow state of the booking |
| Calendar Event ID | script | normally no | stores created calendar event identifier |
| Processing Note | script/admin follow-up | normally no | operational note describing result or error |
| Assigned Room | admin | yes | operational override of requested room |

---

## 9. Known Limitations

- The current implementation validates recurring fields but does not create recurring series in Google Calendar.
- The system currently supports only two normalised room values: `Studio` and `Gallery`.
- Header renaming will break lookup logic.
- The configured calendar must be accessible or approval will fail.
- The supplied code snapshot appears to reference one helper function that is not included in the extract; this should be checked before go-live.
- The current code is strong on create / cancel / invalidate flows, but not a full rescheduling engine for post-approval edits to date and time.
- The user-facing form title still reads **Booking Request - Testing** in the HTML snapshot.

---

## 10. Change Log

### Version 0.1b - Current reviewed codebase
- Apps Script web form submits directly to `WebForm_Submissions`
- New bookings are appended with **Pending** status
- Approval creates a calendar booking in the configured calendar
- Conflict detection checks overlapping time plus same normalised room
- **Assigned Room** override is supported
- Changing **Assigned Room** on an approved booking invalidates the live booking and returns it to **Pending**
- Moving away from **Approved** removes the linked event as a safety net
- Cancellation clears the event link and records the outcome
- Recurring fields are validated but recurring event creation is not yet implemented
- Lightweight logging is written to `System_Log`

---

## 11. Backup and Recovery Notes

- Duplicate the spreadsheet before major structural changes.
- Keep a copy of the Apps Script code outside the spreadsheet project.
- Record version changes in the change log.
- If automation fails during live use, fall back to manual calendar booking and note the intervention clearly.
- Do not rename headers casually.
- Do not delete triggers without documenting why.
- Before go-live, test against the production calendar rather than only the test calendar.
- Keep one short "known good" test case available for regression testing after any deployment.

---

## 12. Suggested Next Review Pass

Before trial deployment, review:

- whether the working sheet name and any user-facing labels should be softened from `WebForm_Submissions` to something more admin-friendly
- whether the HTML title should be changed from **Booking Request - Testing** to **RCAS Booking Manager**
- whether recurring bookings should remain visible in the form before recurring automation exists
- whether screenshots should be added to the User Manual
- whether a one-page quick-reference sheet should be produced for the booking manager
- whether the missing helper reference in the supplied code extract has already been resolved in the live project
