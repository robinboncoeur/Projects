# RCAS Booking App v1.5 

**Technical Reference and Handover**

**Redland Coast Art Society Inc**  
**Document version:** Draft 1.0 · 3 November 2026  
**Production baseline:** `Bookingv1.5 Live` / `RCAS Bookings-LIVE-v1.5`  
**Status:** Documentation draft for administrative and technical review; not a certification of defect-free operation.

> **Reading this document.** **Confirmed** means evidenced by supplied screenshots, workbook inventory, or operational description. **Source-derived** means evidenced by the supplied `Codev01ef.md` source snapshot. **Verify** identifies a detail not established by those materials. **Recommendation** is advice, not a change made to the live application. The supplied source document bears a `[TEST]` heading and 27 October 2026 update note, whereas the production project screenshot shows creation on 2 November 2026. Therefore, its correspondence to the exact numbered production deployment has **not** been independently established. Treat this as a detailed description of the supplied v1.5 source, with production configuration separately verified.

## 1. Executive overview

The RCAS Booking App provides a web-based booking form for tutors and event planners. It is embedded in an RCAS SquareSpace page, served by Google Apps Script, and backed by a Google Sheets workbook and a dedicated Google Calendar. It records booking requests, checks internal room availability, creates calendar events for approved bookings, and supports administrative cancellations. The workbook provides tutor and billing-related reporting.

**System of record:** Google Sheets (`WebForm_Submissions`). **Scheduling representation:** Google Calendar (`Tutors Bookings - LIVE`). Synchronisation is **operation-specific and one-way**, not continuous or bidirectional. Administrators must not directly edit or delete calendar events, and changes to dates, times or venues in the sheet do not automatically update calendar events.

**Operational responsibilities (confirmed):** Julia is presently the sheet administrator and processes cancellation requests; Sue currently prepares tutor billing, reportedly using Xero. The Booking App does **not** integrate with Xero or determine tutor pay rates. The intended scope is to provide accurate approved-session and hour information, not to operate an accounting system.

### 1.1 Scope and exclusions

| Included in v1.5 | Not provided by v1.5 |
|---|---|
| Tutor selection from an active-tutor directory | Tutor self-service review or cancellation of bookings |
| Booking form with review/confirmation stage | Direct tutor authentication or a tutor account portal |
| Paid/free classification and skill-level validation | Automatic invoicing or Xero integration |
| Conflict checks for Studio and Gallery | Automatic room conflict checking for arbitrary off-site venues |
| Recording of approved/rejected requests | Automatic correction of existing calendar events after spreadsheet edits |
| Calendar event creation for approved requests | Guaranteed automatic notification of cancellation to the tutor |
| Administrator-triggered cancellation | Guaranteed automatic reconciliation of partial failures |
| Monthly tutor summary and billing-detail reports | Fixed or administered tutor hourly rates |

### 1.2 Architecture

```text
Tutor / event planner
        |
        v
RCAS Squarespace booking page
  HTML iframe, public Apps Script /exec URL
        |
        v
Google Apps Script web deployment (runs as RCAS account)
  doGet -> Index.html -> google.script.run
        |
        +-- getTutors() -> Tutors worksheet
        |
        +-- submitBooking() -> validation + lock + evaluation
               |
               +-- WebForm_Submissions worksheet
               +-- Google Calendar: conflict check / event creation
               +-- System_Log worksheet

Administrative spreadsheet edit (Status: Approved -> Cancelled)
        |
        v
Installed on-edit trigger: onApprovalEdit (Head)
        |
        v
Google Calendar: delete linked event, clear event ID, write note

WebForm_Submissions -> Tutor_Summary / Tutor_Billing_Detail
                         |
                         v
                    Sue's billing workflow (outside application)
```

## 2. Asset and deployment register

| Asset | Verified details | Maintenance significance |
|---|---|---|
| Organisational Google identity | Redland Coast Art Society Inc account | Owns script, workbook and calendar |
| Apps Script project | `Bookingv1.5 Live` | Spreadsheet-bound script |
| Container workbook | `RCAS Bookings-LIVE-v1.5` | Authoritative booking data |
| Live deployment description | `Version 1.5 - Fix Not Applicable skill level validation` | Matches the iframe deployment URL |
| Web app execution identity | **Me** (RCAS organisational account) | Tutors do not need direct spreadsheet access |
| Web app access | **Anyone** | Permits non-Google-account tutors to use form |
| Embedded URL | `https://script.google.com/macros/s/AKfycbz5i1x5IzCrMFRpVZ1XJlEeeRtiuXln1qUiueB4KaRnvblXBIhY5TBA9wwHu2V1izw9Uw/exec` | Must match production deployment |
| Iframe | width `100%`, height `1000`, border `0`, lazy loading; title `RCAS Tutor Booking Portal` | Website integration |
| Calendar | `Tutors Bookings - LIVE` | Calendar ID recorded in `CONFIG.CALENDAR_ID` |
| Calendar ID | `fb9defee74020745b9fe88a22a9f95429d6499037d116a29f151616c912a6683@group.calendar.google.com` | Must be accessible to RCAS execution identity |
| Timezone | Australia/Brisbane / UTC+10 | Date/time handling and reports |
| Spreadsheet edit trigger | `onApprovalEdit`; from spreadsheet; on edit; deployment `Head`; failure notifications daily | Cancellation workflow; separate from versioned web deployment |
| Numeric source version | **Verify** | Not shown in screenshots |
| SquareSpace page URL | **Verify** | Iframe source is confirmed, page URL not supplied |

**Important deployment distinction.** The web app executes a selected, immutable numbered source version; the installed spreadsheet edit trigger executes `Head` (the current editor source). Saving code without updating the web deployment can therefore change cancellation behaviour without changing the booking form, or vice versa. Maintain and test both paths when making changes.

**Do not archive other active deployments** until all consumers and links have been identified. Four active deployment descriptions were visible in the supplied screenshot. The production deployment is the one whose `/exec` URL matches SquareSpace.

## 3. Source file register

The following describes the supplied source snapshot, not a fresh export of the numbered production version.

| File | Responsibility | Principal functions |
|---|---|---|
| `Code.gs` | Web entry point; booking submission; validation; persistence; calendar creation; billing formulas | `doGet`, `submitBooking`, `parseTimeToMinutes` |
| `Index.html` | HTML/CSS/JavaScript interface; client validation; review/confirm; calls to server | `showMessage`, `clearMessage`, `timeToMinutes`, `setMinimumEventDate`, `populateReviewPanel`, `showReviewPanel`, `updatePriceFields`, `updateOtherLocationField`, `populateTutorDropdown`, `updateTutorWebsite`; DOM handlers |
| `SheetFunct.gs` | Configuration; installed edit trigger; cancellation; calendar access; logging; sheet helpers | `onApprovalEdit`, `handleStatusEdit_`, `processCancellationRow_`, `normalizeRoom_`, `removeLiveCalendarEvent_`, `getHeaders_`, `valueByHeader_`, `trim_`, `getTargetCalendar_`, `logAction_`, `combineDateAndTime_`, `testDuplicateApproval` |
| `BookingLogic.gs` | Booking evaluation, room-conflict checks, event creation | `evaluateBooking_`, `findRoomConflict_`, `createCalendarEvent_`, `buildConflictNote_` |
| `Tutors.gs` | Tutor directory and lookup | `getTutors`, `findTutorById_` |

### 3.1 Function-by-function reference

**`Code.gs`**

- `doGet()` returns the `Index` HTML file, labels the browser page `Booking Request - ver1.5 - Live`, and permits iframe embedding with `ALLOWALL`.
- `submitBooking(formData)` is the main server entry point. It checks required fields, pricing, skill level, active tutor, 30-minute time increments, and start-before-end. It obtains a script lock (10-second wait), evaluates availability, writes a new booking row by header name, and conditionally creates a calendar event. Approval is written **only after** the event ID has been stored. It then installs billable-hours and total-fee formulas and logs the submission. Returns `{success, status, message}` for processed requests; throws on validation or processing failures.
- `parseTimeToMinutes(timeStr)` converts a `HH:MM`-style string to minutes after range checking. It rejects invalid hours/minutes; its split/Number approach is not a strict regular-expression parser.

**`Index.html`**

- `showMessage` / `clearMessage`: client feedback.
- `timeToMinutes`: browser-side time conversion for validation.
- `setMinimumEventDate`: restricts selection of earlier dates in the browser.
- `populateReviewPanel` / `showReviewPanel`: shows the booking details before final confirmation.
- `updatePriceFields`: responds to paid/free selection.
- `updateOtherLocationField`: responds to Studio/Gallery/Other location selection.
- `populateTutorDropdown`: calls server `getTutors()` and fills the tutor selector.
- `updateTutorWebsite`: updates the associated tutor web link when available.
- DOM form submission handler: validates mandatory inputs, past dates and half-hour increments; switches to review stage rather than immediately writing a booking.
- Confirm handler: calls `google.script.run.submitBooking(currentBooking)`, resets the form on success, and shows errors on failure. **Source-derived concern:** the success handler always displays `response.message` with a success style, even when `response.status` is `Rejected` due to a room conflict.

**`SheetFunct.gs`**

- `CONFIG`: calendar mode/ID, workbook sheet names, room names, status values, and expected booking headers.
- `onApprovalEdit(e)`: installed edit trigger; logs the edit, ignores other sheets and the header row, then processes edits to the Status column.
- `handleStatusEdit_(sheet,row,headers,e)`: accepts only configured statuses; performs calendar cancellation **only** for a single-cell transition from `Approved` to `Cancelled`. Other status changes do not create or modify calendar events.
- `processCancellationRow_`: prepares the cancellation note and calls calendar removal.
- `normalizeRoom_`: maps Studio/Gallery case-insensitively to canonical names; returns blank for other values.
- `removeLiveCalendarEvent_`: finds the stored event ID, attempts to find/delete that event, clears the ID, and writes a processing note. If no event ID is present, records that no linked event was found. If the event cannot be found, the ID is still cleared.
- `getHeaders_`: trims row-1 headings, maps them to 1-based column positions, and rejects duplicate non-blank headings. This is the basis of header-name-dependent writes.
- `valueByHeader_`: retrieves a row value by mapped header.
- `trim_`: converts null values to blank, otherwise trims their string representation.
- `getTargetCalendar_`: returns the default calendar or configured calendar ID according to `CALENDAR_MODE`.
- `logAction_`: appends timestamp/level/message/JSON details to `System_Log`, creating it and its headers only if it does not exist.
- `combineDateAndTime_`: combines a date value with a time value into a JavaScript `Date`, accepting Date-type or `HH:MM` time values.
- `testDuplicateApproval`: **obsolete/unsafe test helper** in the supplied source: calls `approveBooking_`, which is not defined in the supplied files. Do not run on production; remove or replace only through controlled change management.

**`BookingLogic.gs`**

- `evaluateBooking_`: resolves the configured calendar; determines location; builds start/end datetimes; rejects past starts or invalid ranges; checks conflicts only for Studio/Gallery; returns Approved or Rejected plus message and processing note; logs evaluation.
- `findRoomConflict_`: fetches calendar events overlapping the proposed interval and returns the first whose event location normalises to the same internal room.
- `createCalendarEvent_`: creates an event titled `Course Name (Location)` and includes tutor name, email, location and course in the description.
- `buildConflictNote_`: formats the rejected-booking conflict note, including the conflicting event title.

**`Tutors.gs`**

- `getTutors()`: reads the Tutors worksheet; requires `TutorID`, `Full Name`, `Email`, `Phone`, and `Active` headers; `Website` is optional. Returns only rows with ID/name and an active value of Boolean `true` or case-insensitive string `TRUE`.
- `findTutorById_`: resolves the submitted tutor ID against the active tutor list; returns the matching tutor or `null`.

## 4. Booking lifecycle

### 4.1 Normal approved booking

1. Tutor opens SquareSpace booking page; iframe loads the Apps Script web app.
2. Browser requests active tutor list using `getTutors()`.
3. Tutor completes the form and reviews the details before confirming.
4. Server validates required fields, price type and amounts, skill level, active tutor and time increments.
5. `submitBooking` acquires a script lock and calls `evaluateBooking_`.
6. For Studio or Gallery, the calendar is checked for overlapping events in the **same** room; other venues are not checked for conflicts.
7. A new row is written to `WebForm_Submissions`; for a potentially approved booking its Status is initially **blank**.
8. Google Calendar event is created; the event ID is stored in the row; **then** Status becomes `Approved`.
9. Processing note and billing formulas are written, an audit entry is appended, and the browser displays the response.

**Approval invariant (design intention):** Do not mark a booking Approved until the linked Calendar Event ID is successfully written. This protects against ordinary calendar-creation failure but does not constitute a transactional guarantee across Google Sheets and Calendar.

### 4.2 Conflicting booking

A Studio/Gallery overlap with a calendar event whose `Location` normalises to the same room produces `Rejected`. The rejected request is recorded in the workbook; no new calendar event is created. The browser displays the returned conflict message, although the supplied client code styles all processed responses as success (review item).

### 4.3 Failed submission and partial states

- Required-field/validation failure generally throws before row creation.
- Calendar creation failure after row creation writes a processing note and throws; the row may remain with blank Status and no event ID.
- A failure after calendar event creation but before event ID/status persistence can leave a calendar event not properly linked to a row. There is no demonstrated automatic rollback or reconciliation.
- Lock acquisition failure or script timeout requires investigation through execution logs and worksheet/calendar comparison.
- The lock reduces overlapping submissions but does not make the two external systems atomic.

**Administrative rule:** Never assume that an error displayed to the tutor means no row or calendar event exists. Inspect the workbook and calendar before resubmitting.

## 5. Validation and business rules

| Rule | Implemented behaviour |
|---|---|
| Required booking inputs | Tutor ID, course name, room selection, event date, start and end times |
| Tutor | Must resolve to an active entry in `Tutors` |
| Price type | Exactly `paid` or `free` after lowercase normalisation |
| Free event | Members and non-members price values cleared |
| Paid event | Both prices required, finite numbers, zero or greater |
| Skill level | `Beginner`, `Intermediate`, `Advanced`, `All Levels`, `Not Applicable` |
| Time increments | Start and end on 30-minute boundaries |
| Time order | End must be after start; no overnight single-event booking supported |
| Past bookings | Start datetime must not be in the past |
| Location | `Studio`, `Gallery`, or a nonempty supplied Other location |
| Conflict check | Studio/Gallery only, against overlapping calendar events with matching normalised room location |
| Rejected requests | Recorded as `Rejected`, no new calendar event |
| Approved requests | Calendar event ID saved before Status set to `Approved` |

**Known limitation:** The calendar is the source for room-conflict detection, so a missing or manually altered calendar event can invalidate the apparent availability check. Off-site locations do not participate in this conflict check.

## 6. Spreadsheet data model

Workbook inventory supplied as `Workbook_Structure_v1.5.txt`, extracted 3 November 2026. The `rows`/`columns` values below describe the inventory snapshot, not fixed capacity limits.

| Worksheet | Snapshot size | Purpose |
|---|---|---|
| `System_Log` | 68 rows × 4 columns | Diagnostics and audit events; hidden |
| `WebForm_Submissions` | 38 × 19 | Booking records and calculation columns |
| `Tutors` | 15 × 6 | Tutor directory |
| `Tutor_Summary` | 19 × 5 | Monthly counts per tutor |
| `Tutor_Billing_Detail` | 40 × 15 | Formula-generated monthly approved-session details; extra worksheet columns available |

No named ranges or sheet protections were reported by the inventory. The inventory samples up to three formulas per column; it is not an exhaustive cell-by-cell audit.

### 6.1 `WebForm_Submissions` — canonical headers

**Do not rename or remove these headings without reviewing `CONFIG.HEADERS` and the reporting formulas.** The script trims heading whitespace when matching names, so the observed surrounding spaces in ` Hourly Rate ` and ` Total Fee ` do not prevent lookup.

| Col | Header | Source / purpose |
|---|---|---|
| A | Timestamp | Submission timestamp |
| B | Full Name | Selected tutor name |
| C | Email | Selected tutor email |
| D | Course Name | Event/course title |
| E | Location | Studio, Gallery or other location |
| F | Event Date | Date of session |
| G | Start Time | Session start |
| H | End Time | Session end |
| I | Price Type | paid/free |
| J | Members Price | Event price, not tutor remuneration |
| K | Non-Members Price | Event price, not tutor remuneration |
| L | Skill Level | Validated category |
| M | Other Details | Notes, including optional cancellation reason |
| N | Status | Approved / Rejected / Cancelled; sometimes blank after partial failure |
| O | Calendar Event ID | Link to Google Calendar event |
| P | Processing Note | System outcome / cancellation notes |
| Q | Billable Hours | Formula, blank unless Approved |
| R | Hourly Rate | Administrative input, not populated by booking form |
| S | Total Fee | Formula using Q × R when both present |

**Representative formulas** (row 2):

```excel
Q2: =IF(OR($N2<>"Approved",$G2="",$H2=""),"",($H2-$G2)*24)
S2: =IF(OR($Q2="",$R2=""),"",$Q2*$R2)
```

The application installs analogous formulas in newly submitted rows. Billing hours are tied to the status `Approved`. Entering an hourly rate is an administrative decision and is outside the web form.

### 6.2 `Tutors`

| Col | Header | Meaning |
|---|---|---|
| A | TutorID | Stable lookup key submitted by form |
| B | Full Name | Display name / reporting match |
| C | Email | Tutor contact address |
| D | Phone | Tutor contact information |
| E | Active | Must evaluate as `TRUE` for inclusion in form |
| F | Website | Optional tutor webpage link |

**Adding a tutor:** Use a unique `TutorID`, populate required fields, and mark Active TRUE. Verify that the tutor appears in a freshly loaded booking form. **Disabling:** Change Active to FALSE; historical bookings remain in the submission sheet. Avoid changing a historical tutor's name without considering reporting formulas that match by name.

### 6.3 `Tutor_Summary`

The inventory shows a reporting month formula in `B1` (`=DATE(2026,11,1)`), date boundaries in the top rows, tutor-name references to `Tutors`, and monthly `COUNTIFS` calculations. Column C counts approved bookings; column D is intended to count cancellations; column E combines counts.

**Post-inventory correction (confirmed by administrator, not recaptured in a new inventory):** The cancellation formula was corrected and copied down. Representative formula for `D6`:

```excel
=COUNTIFS(WebForm_Submissions!$B:$B, B6,
          WebForm_Submissions!F:F, ">="&$C$1,
          WebForm_Submissions!F:F, "<"&($C$2)+1,
          WebForm_Submissions!N:N, "Cancelled")
```

The user confirmed there were no actual cancellations to test at the time. A synthetic or future real cancellation test remains pending. **Verify:** The date bounds in `C1`/`C2` represent the intended period and the approved and cancelled counts use the same period conventions. The snapshot showed the original (pre-correction) formula, so do not treat it as the current cancellation formula.

### 6.4 `Tutor_Billing_Detail`

`A1` references `Tutor_Summary!B1` to select the reporting month. The principal `QUERY` formula is in **A3**, generating columns Tutor, Session Name, Session Date, Hours from approved bookings in `WebForm_Submissions` and ordering by tutor and date.

```excel
=QUERY(
  WebForm_Submissions!A:Q,
  "SELECT B, D, F, Q
   WHERE F >= date '"&TEXT($A$1,"yyyy-mm-dd")&"'
   AND F < date '"&TEXT(EDATE($A$1,1),"yyyy-mm-dd")&"'
   AND N = 'Approved'
   ORDER BY B, F
   LABEL B 'Tutor',
         D 'Session Name',
         F 'Session Date',
         Q 'Hours'",
  1
)
```

A conspicuous warning was added to the worksheet advising administrators not to delete A3. **A3 is not currently protected**; protecting it is an optional future safeguard, not an agreed change. Do not edit the formula's spill/output cells. If calculations are entered in columns beside the dynamic output, they may become misaligned when the query result grows, shrinks or reorders. Verify such calculations before using them for financial decisions.

**Billing scope:** The workbook provides session details and hours for Sue's billing workflow. Rates, accounting decisions, invoices and Xero use remain RCAS administrative responsibilities. A copy of v1.4 was made by Sue for earlier manual sorting/filtering; leave it intact as historical work.

### 6.5 `System_Log`

`logAction_` appends `[Timestamp, Level, Message, Details]` and creates those headers **only when the sheet is absent**. The supplied inventory shows that row 1 currently contains a log event, not those headings; this is a **confirmed structural discrepancy**. The sheet was hidden. Do not insert a header row casually in production without assessing other references; document the actual structure and correct it only as a controlled change. The log may contain tutor IDs and operational details; restrict access appropriately.

## 7. Google Calendar integration

### 7.1 Verified settings

| Setting | Value |
|---|---|
| Name | `Tutors Bookings - LIVE` |
| Owner | Redland Coast Art Society Inc |
| Timezone | Australian Eastern Standard Time, UTC+10 |
| Public sharing | Enabled, **free/busy only**, event details hidden |
| Julia | Make changes and manage sharing |
| Sue | Make changes and manage sharing |
| New/changed/cancelled event notifications | None shown in calendar settings |
| Calendar ID | Matches `CONFIG.CALENDAR_ID` in supplied source |

Calendar description explicitly directs staff **not** to add, edit, move or delete events directly: all bookings should be managed through the Booking App so the spreadsheet and calendar remain consistent.

The source includes tutor name and email in calendar event descriptions. These details are hidden from general public free/busy viewers but remain visible to authorised calendar users with sufficient access. Do not publish the **secret iCal address**; it is not needed in this document.

### 7.2 Event creation

For approved requests, `createCalendarEvent_` writes title `Course Name (Location)`, start/end times, location, and description lines containing Full Name, Email, Location, Course Name. The resulting event ID is stored in `WebForm_Submissions!O`.

### 7.3 Cancellation workflow — confirmed procedure

1. Tutor/event planner notifies the sheet administrator (currently Julia).
2. Julia locates the correct row and changes **Status (N)** from `Approved` to `Cancelled`.
3. The installed `onApprovalEdit` trigger attempts to delete the linked Google Calendar event, clears the stored event ID and updates Processing Note (P).
4. Julia may record the reason in **Other Details (M)**. Reasons may include an incorrect entry, illness, weather or another inability to hold the event.
5. Administrator verifies the Processing Note and checks the event has been removed. The tutor/planner must be informed as appropriate; do not assume automatic cancellation emails are sent.

**Order of entry:** The user described recording the optional reason after changing status. This is supported: M is informational and does not trigger calendar cancellation. However, if an event is being cancelled because of an erroneous booking, consider recording the reason before changing Status so the note is preserved even if later work is interrupted.

**Trigger limitation:** The code specifically requires `oldValue === 'Approved'` and new value `Cancelled`. Bulk paste, multi-cell edits, programmatic changes, or changes from other statuses may not provide the same event data or invoke this path. Do not rely on those methods for cancellation.

### 7.4 Mistaken booking correction

Recommended operational procedure for current v1.5: cancel the incorrect approved booking, verify its calendar event was removed, then submit a new correct booking through the form. Do **not** simply edit the date, time, room or tutor in the spreadsheet and assume Google Calendar will update. Do not edit calendar events directly.

### 7.5 Potential future enhancement (not committed)

Tutor self-service booking review and cancellation would require authenticated identity, authorisation to view/cancel only the tutor's bookings, confirmation and audit trails, and reliable event synchronisation. This is a future possibility, **not** a v1.5 requirement or delivery commitment.

## 8. Ownership, access and security

### 8.1 Confirmed ownership and roles

- **RCAS organisational Google account:** Owner of script project, workbook and calendar; execution identity for web app.
- **Sue:** Workbook editor; calendar sharing/management; currently handles billing. Also created the `online.` RCAS account, whose exact operational purpose is not documented.
- **Julia:** Workbook editor; calendar sharing/management; currently processes booking cancellations and other sheet administration.
- **`online.` RCAS account:** Retained editor; purpose to be confirmed with Sue.
- **`t.` RCAS account:** User reports it was removed from sharing.
- **Technical administrator after handover:** **To be nominated by RCAS**.

### 8.2 Confirmed sharing configuration

- `BookingApp` folder: General access **Restricted**.
- `RCAS Bookings-LIVE-v1.5` workbook: General access **Restricted** (verified by later screenshot).
- Web application: **Anyone**, executes as RCAS owner. This is distinct from direct workbook sharing.
- Calendar: public **free/busy** only. Calendar event details are not publicly exposed by that permission.
- Workbook editors can modify and execute attached Apps Script. Editor access should therefore be treated as technical trust, not merely permission to type booking data.

**Verify:** Separate v1.4 and copied workbook sharing settings if they contain sensitive data; folder restriction does not conclusively establish every child file's direct permissions.

### 8.3 Security practices

Keep organisational account recovery and multi-factor authentication under RCAS control. Avoid personal-account dependencies. Limit spreadsheet editors to necessary personnel. Review access periodically, particularly when committee roles change. Never put passwords, recovery codes, or the secret calendar iCal URL into documentation. Before enabling public calendar event details, assess exposure of tutor names and email addresses. Treat execution logs and the Tutors sheet as personal information.

## 9. Administration RunBook

### 9.1 New booking

Open the published booking portal; select the tutor; enter course/session details, date, time, location, price type, skill level and optional details; review; confirm. Check that a successful booking appears as Approved in `WebForm_Submissions` and on the calendar. If the browser reports a failure, **check for a partial row/event before resubmitting**.

### 9.2 Cancel an event

Find the correct booking by tutor/date/course; confirm it is Approved; change N to Cancelled; optionally record the reason in M; check P and that O is cleared; verify calendar event removal; notify relevant people as needed. Do not use bulk paste or manually delete the calendar event. If P shows an error or event remains, escalate before further edits.

### 9.3 Add or deactivate tutor

Edit `Tutors` with a unique ID, full name, email, phone, Active flag and optional Website. Test a fresh form load. For deactivation, set Active FALSE rather than deleting historical tutor records. Review reports if changing tutor names.

### 9.4 Prepare monthly billing information

Confirm the reporting month in `Tutor_Summary` and `Tutor_Billing_Detail`; check approved booking counts and detail rows; compare known sessions with calendar and submissions; use the approved-session Hours field as input to RCAS's separate billing process. Do not overwrite `Tutor_Billing_Detail!A3`. Do not assume user-entered formulas beside a `QUERY` spill remain aligned when results reorder. Payment rates and Xero processing remain Sue's responsibility.

### 9.5 Periodic health check

Review Apps Script execution failures, hidden `System_Log`, blank-Status submission rows, missing event IDs on Approved rows, unexpected calendar events, and calendar event IDs that cannot be found. Verify the published iframe still loads without a Google login. Keep an administrator-accessible copy of the exact source version and a protected backup of the workbook.

## 10. Deployment and change management

### 10.1 Baseline before changing anything

Record the active deployment description, **numeric source version**, deployment ID/URL, execution identity, access policy, spreadsheet ID, calendar ID, installed triggers and authorisations. Export/copy source and workbook to a controlled RCAS archive. Do not put a secret calendar feed URL in this archive. Confirm whether test and production assets are isolated.

### 10.2 Controlled change sequence

1. Describe the proposed change, risk and acceptance test.
2. Back up the workbook and preserve the exact live source/deployment version.
3. Make and test one change in a **separate test environment**, especially if it creates/deletes events.
4. Verify booking submission, conflict rejection, cancellation and reporting as applicable.
5. Deploy a **new numbered version** to the existing production web deployment if a web change is intended; retain the `/exec` URL.
6. Remember that the installed edit trigger runs `Head`, not the numbered web version; test it separately and avoid leaving Head ahead of the published application unintentionally.
7. Record version, date, change, tester, results and rollback procedure.
8. Check the SquareSpace iframe and a real-world browser without Google sign-in.

**Do not** use a live booking or live calendar as an unplanned test bed. Test cancellations against dedicated test events and test rows where possible.

### 10.3 Recovery principles

If the form fails, inspect the Apps Script execution record, workbook, calendar permissions and current deployment before changing code. If an approved row has no event ID, or an event exists without a corresponding row, do not simply repeat the submission: reconcile deliberately. If a release introduces regression, restore the previously verified numbered deployment version and separately assess the current `Head` trigger source. A spreadsheet backup alone is insufficient to restore calendar events automatically.

## 11. Troubleshooting guide

| Symptom | First checks | Caution |
|---|---|---|
| Form not loading in SquareSpace | Iframe URL; deployed `/exec`; access Anyone; Apps Script execution failures | Do not replace URL without checking which deployment is live |
| Tutor absent from dropdown | Tutors headers, ID/name, Active TRUE, browser refresh | Changing a tutor's name can affect name-based reports |
| Submission rejected for conflict | Calendar event overlapping same Studio/Gallery; event Location | Conflict note may contain existing event title |
| Approved row missing calendar ID | Processing Note, Apps Script execution, calendar | Investigate partial failure; do not blindly resubmit |
| Calendar event missing for Approved row | Calendar ID, event ID, manual edits/deletions | Calendar and sheet can drift out of sync |
| Cancellation did not delete event | Was N edited from Approved to Cancelled in one cell? Trigger active? Event ID present? Execution error? | Changing status programmatically may not run edit trigger |
| Billable Hours blank | Status Approved? Start/end times valid? Formula present? | Cancelled/rejected bookings intentionally show blank |
| Billing detail incomplete | Reporting month; Approved status; Event Date type; A3 formula | Do not edit query spill |
| Cancellation count zero | Corrected D-column formula, month bounds, actual Cancelled rows | No real cancellation test yet performed |
| Unexpected log headers | `System_Log` row 1 currently contains log data | Do not assume headers exist |
| Multiple active deployments | Compare iframe URL to each deployment URL | Do not archive without dependency check |

## 12. Technical audit: findings and limitations

This is a **documentation audit**, not a claim that these issues have been reproduced in production. Priorities are advisory.

| ID | Priority | Finding | Evidence / impact | Proposed disposition |
|---|---|---|---|---|
| A01 | Medium | `System_Log` first row contains data rather than headings | Workbook inventory; logger creates headers only if sheet absent | Document; repair in controlled change if desired |
| A02 | Medium | Rejected conflict can appear with success styling | Client success handler does not branch on response status | Verify user-facing behaviour; consider later UI correction |
| A03 | Medium | Partial failure can leave blank Status row or orphaned event | Non-atomic Sheets/Calendar operations | RunBook reconciliation; consider future repair utility |
| A04 | Medium | Status edit trigger processes only Approved→Cancelled | Source logic depends on oldValue and single Status edit | Train administrators; test installed trigger |
| A05 | Low | `testDuplicateApproval` refers to undefined `approveBooking_` | Supplied source snapshot | Do not run; retire in controlled maintenance |
| A06 | Medium | No automatic update on booking-field edits | Source handles Status changes only | Cancel and rebook; no direct calendar edits |
| A07 | Medium | Monthly summary matches tutor by full name | COUNTIFS uses booking name and Tutors name | Avoid casual renames; review stable-ID reporting in future |
| A08 | Low | `Tutor_Billing_Detail!A3` unprotected | Inventory shows no protections; visual warning added | Optional protection on request |
| A09 | Medium | Manual calculations adjacent to dynamic QUERY may misalign | Rows may reorder or expand | Warn users; validate billing exports |
| A10 | Medium | Corrected cancellation formula lacks nonzero real-world verification | User corrected and copied down; no cancellations yet | Controlled test or first real cancellation review |
| A11 | Medium | Production numeric version not captured; supplied source marked TEST | Screenshots + source heading | Export exact deployed version before declaring documentation final |
| A12 | Low | Four active deployment descriptions observed | Deployment screenshot | Identify consumers before archiving |
| A13 | Medium | No notification guarantees for cancellations | Calendar notification settings None; code removes event only | Administrator must communicate cancellation |
| A14 | Medium | Event description stores tutor name/email | `createCalendarEvent_`; calendar public free/busy only | Maintain privacy settings and editor discipline |
| A15 | Medium | `getHeaders_` trims headers, but formulas use fixed letters | Source + inventory | Review both code and formulas when changing schema |

### 12.1 Additional review points requiring testing

- Check whether Google Sheets Event Date cells are stored as true dates for all new form submissions; `QUERY` date predicates rely on date-compatible values.
- Confirm whether a conflict response is visually marked success and whether its wording is sufficiently clear.
- Verify that cancellations remove the correct event, clear ID O, write Processing Note P, and make Q blank.
- Confirm `Tutor_Summary` report month boundaries and the corrected cancellation formula against a known nonzero case.
- Confirm the exact source code of the **numbered production version** matches the supplied snapshot; if not, reconcile differences before sign-off.
- Confirm the RCAS website calendar's final placement and embed permissions after Sue's decision.

## 13. Acceptance test matrix

Use a **test workbook and test calendar** whenever an action creates or deletes records. Record date, tester, result and supporting screenshot/log for each case.

| Test | Expected outcome | Evidence status at draft |
|---|---|---|
| Public portal opens in non-Google browser | Form loads without spreadsheet permission | Access configuration verified; re-test after permission changes recommended |
| Active tutor appears; inactive tutor absent | Dropdown follows Tutors Active field | Source-derived; formal test not supplied |
| Valid future Studio/Gallery booking | Row Approved, event created, event ID stored | User reports live use; no complete test record supplied |
| Same-room overlapping booking | Rejected, no new event | Source-derived; test evidence not supplied |
| Different-room overlapping booking | Allowed if no same-room conflict | Source-derived; test evidence not supplied |
| Paid/free validation | Correct mandatory prices / cleared free prices | Source-derived; test evidence not supplied |
| Not Applicable skill level | Accepted | Deployment description identifies fix; direct test evidence not supplied |
| Past date or non-half-hour time | Rejected | Source-derived; test evidence not supplied |
| Approved→Cancelled manual edit | Event removed, event ID cleared, note updated | Workflow confirmed; live cancellation not yet observed |
| Billing detail monthly filter | Approved bookings within month, correct hours | Screenshot shows November report; full reconciliation pending |
| Summary cancellation count | Counts known Cancelled rows correctly | Corrected formula, no nonzero cancellation available |
| Partial calendar failure | Not Approved without event ID | Intended source behaviour; fault injection not supplied |

## 14. Handover checklist

- [x] RCAS account confirmed as script/workbook/calendar owner.
- [x] Live web deployment URL matched to SquareSpace iframe.
- [x] Web deployment execution identity `Me` and access `Anyone` recorded.
- [x] Installed `onApprovalEdit` trigger configuration recorded.
- [x] Workbook structure and key formulas captured.
- [x] Workbook and containing folder General access Restricted confirmed.
- [x] Calendar owner and public free/busy visibility confirmed.
- [x] Julia's administrative cancellation procedure documented.
- [x] Sue's billing responsibility and absence of Xero integration documented.
- [x] `Tutor_Billing_Detail!A3` warning added (cell protection not requested).
- [ ] Capture the numeric Apps Script version and export the exact production source.
- [ ] Nominate RCAS technical administrator and account recovery custodian.
- [ ] Confirm purpose of the `online.` RCAS editor account with Sue.
- [ ] Verify individual sharing of older v1.4/copy workbooks as appropriate.
- [ ] Perform a controlled cancellation test and verify calendar deletion.
- [ ] Verify corrected summary cancellation count against nonzero test data.
- [ ] Record an agreed process for monitoring failed executions and responding to incidents.
- [ ] Confirm final SquareSpace calendar display arrangement.
- [ ] Obtain administrative acceptance of handover and record any unresolved limitations.

## 15. Future enhancements — explicitly outside v1.5

These are ideas, **not commitments**: tutor self-service booking history and cancellation; protected report-formula cells; status-sensitive client messaging; robust partial-failure reconciliation; stable tutor-ID-based billing summaries; safer billing exports; stronger change audit and notification workflow. Each would require separate requirements, approval, development and testing.

## Appendix A. Configuration values and invariants

```javascript
CONFIG.CALENDAR_MODE = 'id'
CONFIG.CALENDAR_ID = 'fb9defee74020745b9fe88a22a9f95429d6499037d116a29f151616c912a6683@group.calendar.google.com'
CONFIG.SHEET_NAME = 'WebForm_Submissions'
CONFIG.TUTORS_SHEET_NAME = 'Tutors'
CONFIG.ROOM_VALUES = ['Studio', 'Gallery']
CONFIG.STATUS_VALUES = { APPROVED: 'Approved', REJECTED: 'Rejected', CANCELLED: 'Cancelled' }
```

**Operational invariants:** Only the approved workflow creates calendar events; Calendar Event ID must be recorded before Approved status; only manual Approved→Cancelled Status changes trigger the current cancellation path; do not directly edit calendar events; do not delete `Tutor_Billing_Detail!A3`; preserve source headers and report formulas.

## Appendix B. Source and evidence register

1. `Codev01ef.md`: supplied five-file Apps Script source snapshot, headed `Booking App v1.5 [TEST]`, update 27 October 2026. This is the basis for function-level descriptions; correspondence to the numbered production version remains unverified.
2. `Workbook_Structure_v1.5.txt`: full JSON-formatted inventory of workbook, sheets, columns, sample formulas, validations and protections. Captured before the subsequent correction to the cancellation formula.
3. Screenshots provided 3 November 2026: production deployment and matching SquareSpace iframe; Apps Script project owner; Drive folder and workbook sharing; monthly billing detail and A3 warning; Google Calendar settings, sharing and public free/busy permissions.
4. Administrator's statements: Julia's form usability feedback; cancellation workflow; Sue's billing responsibility and Xero use; corrected cancellation formula; removal of `t.` editor; retention of `online.`; future enhancements not committed.

**Document maintenance rule:** When the production code or workbook changes, update this reference with the date, exact deployment version, test result and affected sections. Keep the source export and the technical reference together in RCAS-controlled storage.

---

*Prepared as a technical handover draft for Redland Coast Art Society Inc. No production code, spreadsheet data or Google Calendar events were modified in preparing this document.*
