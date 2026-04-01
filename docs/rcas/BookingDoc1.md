# Booking Tool Documentation Draft Pack

## 1. User Manual

### Purpose of the tool
This booking tool is used to receive room booking requests, review them in the Admin sheet, and create approved bookings in Google Calendar.

The system is designed to:
- collect booking requests through a Google Form
- display those requests in the Admin sheet
- allow an administrator to review and approve or reject requests
- automatically create calendar events for approved bookings
- prevent room clashes when bookings overlap in the same room

### Overview of the workflow
1. A user submits a booking request through the form.
2. The request appears in the Admin sheet.
3. The Status field is automatically set to Pending.
4. The administrator reviews the request and checks calendar availability.
5. If the request is acceptable, the administrator changes Status to Approved.
6. The system creates the calendar event automatically.
7. If the room is already booked at that time, the request is marked Conflict.

### Sheets in the system
#### Admin
This is the only sheet the administrator needs to work in.

It contains:
- the original booking details submitted by the user
- the editable status field
- operational notes from the system
- calendar tracking fields
- selected admin override fields, where applicable

### Colour coding
Columns A through H are beige.
These are read-only mirror fields copied from the original booking submission.
They are for viewing only and should not be edited manually.

Operational columns to the right of the beige area may be used by the administrator where appropriate.

### Meaning of each status
#### Pending
The booking has been received but not yet approved.

#### Approved
The booking has been approved by the administrator.
When a booking is changed to Approved, the script attempts to create the calendar event.

#### Rejected
The booking is not accepted and will not be added to the calendar.

#### Conflict
The system has detected a problem preventing approval, such as a room clash or missing/invalid details.
The administrator should read the Processing Note for details.

### How to process a booking
1. Open the Admin sheet.
2. Find new entries marked Pending.
3. Check the Google Calendar to confirm room availability.
4. If needed, adjust the Assigned Room field.
5. Change Status from Pending to Approved.
6. Wait a moment for the system to process the request.
7. Confirm that:
   - Status remains Approved
   - Calendar Event ID has been filled in
   - Processing Note confirms success

### If a different room is more suitable
If the requested room should be changed, use the Assigned Room field.
Do not edit the original Room field in the mirrored booking columns.

The system uses Assigned Room when it has a value. Otherwise, it uses the originally requested Room.

### What not to do
Do not:
- edit the beige columns
- sort the Admin sheet unless the system has specifically been designed to support it
- rename column headers
- delete helper columns
- manually overwrite Calendar Event ID or Processing Note unless instructed

### What to do if something goes wrong
If a booking does not process correctly:
1. Read the Processing Note.
2. Check whether Status has changed to Conflict.
3. Confirm the booking details are complete and correct.
4. If necessary, contact the developer/support person.

---

## 2. Admin Operations Guide

### Daily operating procedure
At the start of each booking session:
1. Open the Admin sheet.
2. Open the linked Google Calendar.
3. Review all new Pending requests.
4. Process each request one at a time.

### Standard approval procedure
For each Pending booking:
1. Read the request details.
2. Confirm the room and times requested.
3. Check the calendar manually.
4. If needed, assign a different room using Assigned Room.
5. Change Status to Approved.
6. Confirm the script has completed successfully.

### When to leave a booking Pending
Leave a booking as Pending if:
- you need clarification from the requester
- the requested room is uncertain
- the times are questionable
- you are waiting to confirm availability
- you are not ready to commit the booking to calendar

### When to mark a booking Rejected
Mark a booking Rejected if:
- the request cannot be accommodated
- the requester has provided unsuitable information
- the session should not proceed
- you have decided not to accept the booking

### When Conflict appears
Conflict means the system has prevented approval.
This may happen because:
- the room is already booked for the same time period
- the date or time values are invalid
- required booking information is missing
- the room value is not recognised

When Conflict appears:
1. Read Processing Note.
2. Review the date, time, and room.
3. Check the calendar manually.
4. Correct any admin-controlled values if appropriate.
5. Try approval again only after the issue is resolved.

### How to use Assigned Room
Assigned Room is used when the originally requested room should be changed for operational reasons.

Examples:
- a quiet or low-impact class may be more suitable in Gallery
- a more practical class may need Studio
- one room may already be occupied while the other is free

Procedure:
1. Leave the original Room field untouched.
2. Enter Studio or Gallery in Assigned Room.
3. Approve the booking.

### Manual fallback procedure
If automation fails but the booking must still go ahead:
1. Check the calendar manually.
2. Create the calendar event manually.
3. Record the action in Processing Note.
4. Leave a clear note for follow-up.
5. Notify the developer if the automation failure needs investigation.

### Good operating discipline
- Work from left to right across the row.
- Treat beige columns as read-only.
- Use Processing Note as the first source of truth for failures.
- Do not attempt to tidy the sheet structure.
- Raise unusual behaviour early.

---

## 3. Quick Reference

### Normal booking
Pending -> check calendar -> adjust Assigned Room if needed -> Approved

### If the booking succeeds
Look for:
- Status = Approved
- Calendar Event ID present
- Processing Note confirms success

### If the booking fails
Look for:
- Status = Conflict
- Processing Note explains why

### Never do this
- edit beige columns
- rename headers
- delete helper columns
- assume a booking is complete without checking Processing Note

### First places to look when something seems wrong
1. Status
2. Processing Note
3. Calendar Event ID
4. Google Calendar

---

## 4. Troubleshooting Guide

### Problem: Status did not change to Pending after form submission
Likely causes:
- form-submit trigger missing or disabled
- script authorization issue
- row not syncing properly to Admin

Checks:
- verify trigger exists
- check Apps Script Executions
- confirm form response appeared in the response sheet
- confirm the Admin row was created

### Problem: Approving a booking did not create a calendar event
Likely causes:
- approval trigger missing or disabled
- required header mismatch
- invalid date/time parsing
- calendar permissions or authorization issue

Checks:
- verify onApprovalEdit trigger exists
- check Executions for errors
- inspect Processing Note
- inspect Calendar Event ID

### Problem: Booking became Conflict unexpectedly
Likely causes:
- overlapping booking already exists in the same room
- invalid room name
- missing date or time value
- end time earlier than or equal to start time

Checks:
- read Processing Note
- compare room/date/time to calendar
- confirm Assigned Room if used
- confirm header names still match script expectations

### Problem: Dropdown colours disappeared
Likely causes:
- validation rule was rebuilt by script
- formatting was reset manually

Action:
- reapply conditional formatting or dropdown colours in Sheets UI
- avoid rerunning setup functions unless required

### Problem: Booking details look wrong in the calendar
Likely causes:
- wrong header mapping in the script
- override fields not used as expected
- date/time parsing issue

Checks:
- review field mappings in code
- check raw values in Admin row
- compare calendar event description to booking details

### Problem: Calendar Event ID is blank after approval
Likely causes:
- event was not created
- script stopped before completion
- conflict prevented creation

Checks:
- inspect Processing Note
- inspect Executions log
- confirm event is absent/present in calendar

---

## 5. Test / UAT Checklist

### Form submission tests
- [ ] New form submission appears in Admin
- [ ] Status auto-populates as Pending
- [ ] Beige mirror fields display correctly

### Approval tests
- [ ] Valid booking can be approved
- [ ] Calendar event is created in default calendar
- [ ] Calendar Event ID is written back to sheet
- [ ] Processing Note confirms success

### Conflict tests
- [ ] Same room + overlapping time becomes Conflict
- [ ] Different room + overlapping time is allowed
- [ ] Invalid room value becomes Conflict
- [ ] Missing date/time becomes Conflict
- [ ] End time earlier than start time becomes Conflict

### Override tests
- [ ] Assigned Room blank uses requested Room
- [ ] Assigned Room override creates event in assigned room
- [ ] Original Room remains unchanged

### Duplicate / stability tests
- [ ] Re-approving already processed row does not create duplicate event
- [ ] Trigger continues to operate over multiple test rows
- [ ] Calendar entries appear with correct title, location, and description

---

## 6. Technical / Developer Documentation

### System architecture
The system consists of:
- a Google Form for booking intake
- a linked form-response sheet
- an Admin sheet for operational review and approval
- Apps Script automation
- a Google Calendar used as the booking destination

### Data flow
1. User submits form.
2. Response is written to form-response sheet.
3. Admin sheet mirrors core fields from the submission.
4. setPendingOnFormSubmit sets Status to Pending in Admin.
5. Admin changes Status to Approved.
6. onApprovalEdit runs.
7. processApprovalRow_ validates the booking.
8. If no same-room overlap exists, event is created in Google Calendar.
9. Calendar Event ID and Processing Note are written back to Admin.

### Important assumptions
- Sheet names must match script configuration exactly.
- Header names used in code must match row 1 values exactly.
- Beige mirror columns are read-only operationally.
- Admin sheet row order must remain aligned with response rows for current logic.
- Current calendar target is the default calendar unless configured otherwise.

### Key functions
#### setPendingOnFormSubmit(e)
Triggered on spreadsheet form submission.
Sets Status to Pending for the corresponding Admin row.

#### onApprovalEdit(e)
Triggered when a cell is edited in the Admin sheet.
If the edited cell is the Status column and the new value is Approved, processing begins.

#### processApprovalRow_(sheet, row, headers)
Reads the row values, validates room/date/time, checks for same-room overlap, and creates the calendar event if valid.
Writes Calendar Event ID and Processing Note back to the sheet.

#### ensureColumnsExist()
Setup/helper function.
Ensures required helper columns exist and applies data validation rules.
Should not be run routinely once the sheet has been configured.

#### createInstallableTriggers()
Creates the required installable triggers for form submit and on edit.
Should be run once during setup.

#### combineDateAndTime_(datePart, timePart)
Combines date and time values into JavaScript Date objects suitable for CalendarApp.
Must handle date objects and time strings safely.

#### normalizeRoom_(value)
Normalises room text to supported values.
Currently supports Studio and Gallery.

#### getHeaders_(sheet)
Builds a header-name-to-column-number map from row 1.
Header matching is exact after trimming.

#### valueByHeader_(rowValues, headers, headerName)
Returns a cell value from the row by header lookup.

#### effectiveValue_(rowValues, headers, overrideHeader, originalHeader)
Returns the override value when present; otherwise falls back to the original value.
Useful for Assigned Room and future override fields.

### Current header mappings in Admin
- Timestamp
- Email address
- Course Name
- Full Name
- Room
- Event Date
- Start time
- End time
- Assigned Room or operational column as configured
- Status
- Notes
- Calendar ID
- Calendar Event ID
- Processing Note

### Conflict rule
A booking conflicts only when:
- another event overlaps in time, and
- the room/location is the same after room normalisation

### Calendar event structure
The script creates a calendar event with:
- title containing the person name and room
- location set to the approved room
- description containing name, email, room, course, and notes

### Known fragilities
- Header renaming will break lookup logic.
- Row-order-dependent logic may break if the Admin sheet is sorted or structurally altered.
- Hidden sheets are not secure sheets.
- Current code focuses on booking creation, not full rescheduling/update/delete workflow after approval.

---

## 7. Setup and Deployment Notes

### Initial setup
1. Create and link the Google Form to the spreadsheet.
2. Confirm the response sheet tab name.
3. Confirm the Admin sheet tab name.
4. Ensure row 1 headers match expected values exactly.
5. Paste the Apps Script code into the project.
6. Save the project.
7. Authorize required permissions.
8. Run setup helpers as needed.
9. Create installable triggers.

### Required triggers
- setPendingOnFormSubmit -> From spreadsheet -> On form submit
- onApprovalEdit -> From spreadsheet -> On edit

### Time zone
The spreadsheet, script project, and calendar should all be checked for consistent time zone settings.
Recommended setting: Australia/Brisbane.

### Testing order
1. Submit a form entry.
2. Confirm Pending appears.
3. Approve a valid booking.
4. Confirm the event is created.
5. Test a deliberate conflict.

---

## 8. Data Dictionary

### Timestamp
Source: form submission
Editable: no
Purpose: submission audit trail

### Email address
Source: form submission
Editable: no
Purpose: contact email for requester

### Course Name
Source: form submission
Editable: no
Purpose: identifies booking purpose/course

### Full Name
Source: form submission
Editable: no
Purpose: identifies requester

### Room
Source: form submission
Editable: no
Purpose: requested room

### Event Date
Source: form submission
Editable: no
Purpose: requested booking date

### Start time
Source: form submission
Editable: no
Purpose: requested start time

### End time
Source: form submission
Editable: no
Purpose: requested end time

### Assigned Room
Source: admin
Editable: yes
Purpose: operational override of requested room

### Status
Source: script/admin
Editable: yes
Purpose: workflow state of booking

### Notes
Source: form submission
Editable: no
Purpose: additional requester details

### Calendar ID
Source: reserved / future use
Editable: depends on design
Purpose: optional future calendar targeting

### Calendar Event ID
Source: script
Editable: no
Purpose: stores created calendar event identifier

### Processing Note
Source: script/admin follow-up
Editable: normally no
Purpose: operational note describing result or error

---

## 9. Known Limitations

- Beige mirror columns are read-only by convention and should not be edited.
- Current logic assumes Admin rows remain aligned with form-response rows.
- Current release is focused on approving and creating bookings.
- Full post-approval update logic for date/time changes is not yet implemented.
- Hidden sheets reduce clutter but do not provide security.
- Header names are case-sensitive for operational purposes because script lookups depend on exact text.

---

## 10. Change Log

### Version 0.1
- Form submissions mirrored into Admin
- Status auto-set to Pending
- Approval creates calendar booking in default calendar
- Conflict detection by overlapping time and matching room
- Calendar Event ID and Processing Note written back
- Assigned Room override introduced

---

## 11. Backup and Recovery Notes

- Duplicate the spreadsheet before major structural changes.
- Keep a copy of the Apps Script code outside the spreadsheet project.
- Record version changes in the change log.
- If automation fails during live use, fall back to manual calendar booking and note the intervention.
- Do not rename headers casually.
- Do not delete triggers without documenting why.

---

## 12. Suggested Next Review Pass

Before trial deployment, review:
- exact wording of admin-facing instructions
- whether Assigned Room is finalised in both sheet layout and code
- whether screenshots should be added to the User Manual
- whether a one-page PDF quick reference should be produced for the admin user

