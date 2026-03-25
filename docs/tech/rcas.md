# RCAS

## Intro


---

[Main Page](../index.md)

<hr style="height:8px;border-width:0;color:black;background-color:black">







## Initial Calendar script
### 24-Mar-2026

<img src="/assets/images/misc/260219aa.jpg" style="float: right; width: 200px; margin-left: 20px" />

Use: CalendarApp.getDefaultCalendar() to get default calendarID


### Main Script

``` javascript

/**
 * Room booking approval workflow
 * Bound to the Google Sheet that receives Google Form responses.
 *
 * When the coordinator changes Status to "Approved",
 * this script:
 *   1. Re-checks the calendar for conflicts
 *   2. Creates the event if the slot is still free
 *   3. Writes the Calendar Event ID back to the sheet
 *   4. Writes notes for coordinator visibility
 */

const CONFIG = {
  CALENDAR_ID: 'YOUR_CALENDAR_ID_HERE',
  SHEET_NAME: 'Form Responses 1', // change if needed
  STATUS_VALUES: {
    PENDING: 'Pending',
    APPROVED: 'Approved',
    REJECTED: 'Rejected',
    CONFLICT: 'Conflict'
  }
};

/**
 * Installable trigger: runs when the sheet is edited.
 * Set this up via Triggers in Apps Script, not as a simple onEdit trigger.
 */
function onApprovalEdit(e) {
  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  const col = e.range.getColumn();

  if (row < 2) return; // skip header row

  const headers = getHeaders_(sheet);
  const statusCol = headers['Status'];

  if (!statusCol || col !== statusCol) return;

  const newStatus = String(e.range.getValue()).trim();
  if (newStatus !== CONFIG.STATUS_VALUES.APPROVED) return;

  processApprovalRow_(sheet, row, headers);
}

/**
 * Main logic for creating the calendar event after approval.
 */
function processApprovalRow_(sheet, row, headers) {
  const calendar = CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_ID and sharing permissions.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const tutorName = valueByHeader_(rowValues, headers, 'Tutor Name');
  const tutorEmail = valueByHeader_(rowValues, headers, 'Tutor Email');
  const bookingDate = valueByHeader_(rowValues, headers, 'Booking Date');
  const startTime = valueByHeader_(rowValues, headers, 'Start Time');
  const endTime = valueByHeader_(rowValues, headers, 'End Time');
  const purpose = valueByHeader_(rowValues, headers, 'Purpose');
  const notes = valueByHeader_(rowValues, headers, 'Notes');
  const existingEventId = valueByHeader_(rowValues, headers, 'Calendar Event ID');

  const statusCol = headers['Status'];
  const noteCol = headers['Processing Note'];
  const eventIdCol = headers['Calendar Event ID'];

  // Prevent duplicate creation if already processed
  if (existingEventId) {
    sheet.getRange(row, noteCol).setValue('Already created; skipped duplicate approval.');
    return;
  }

  // Validate required fields
  if (!bookingDate || !startTime || !endTime) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Missing date/time fields.');
    return;
  }

  const start = combineDateAndTime_(bookingDate, startTime);
  const end = combineDateAndTime_(bookingDate, endTime);

  if (!(start instanceof Date) || isNaN(start.getTime()) ||
      !(end instanceof Date) || isNaN(end.getTime())) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Invalid date/time values.');
    return;
  }

  if (end <= start) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('End time must be after start time.');
    return;
  }

  // Re-check calendar for overlaps right before creating event
  const overlapping = calendar.getEvents(start, end);
  if (overlapping.length > 0) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(
      'Conflict detected at approval time. Event not created.'
    );
    return;
  }

  const title = `Art Society Room Booking - ${tutorName || 'Tutor'}`;

  const descriptionLines = [
    `Tutor: ${tutorName || ''}`,
    `Email: ${tutorEmail || ''}`,
    `Purpose: ${purpose || ''}`,
    '',
    'Notes:',
    notes || ''
  ];

  const event = calendar.createEvent(title, start, end, {
    description: descriptionLines.join('\n')
    // You could add location here if useful
    // location: 'Art Society Room'
  });

  sheet.getRange(row, eventIdCol).setValue(event.getId());
  sheet.getRange(row, noteCol).setValue('Calendar event created successfully.');
}

/**
 * Optional helper to backfill missing dropdowns / notes headers if you need them.
 * Run manually once if useful.
 */
function ensureColumnsExist() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(CONFIG.SHEET_NAME);
  if (!sheet) throw new Error('Sheet not found.');

  const headers = getHeaders_(sheet);
  const required = ['Status', 'Calendar Event ID', 'Processing Note'];
  let lastCol = sheet.getLastColumn();

  required.forEach(name => {
    if (!headers[name]) {
      lastCol += 1;
      sheet.getRange(1, lastCol).setValue(name);
    }
  });

  // Refresh headers after adding
  const refreshed = getHeaders_(sheet);
  const statusCol = refreshed['Status'];

  // Add dropdown validation to Status column
  const rule = SpreadsheetApp.newDataValidation()
    .requireValueInList([
      CONFIG.STATUS_VALUES.PENDING,
      CONFIG.STATUS_VALUES.APPROVED,
      CONFIG.STATUS_VALUES.REJECTED,
      CONFIG.STATUS_VALUES.CONFLICT
    ], true)
    .setAllowInvalid(false)
    .build();

  sheet.getRange(2, statusCol, Math.max(sheet.getMaxRows() - 1, 1), 1).setDataValidation(rule);
}

/**
 * Manual setup helper to create the installable edit trigger.
 * Run this once from the Apps Script editor.
 */
function createInstallableTrigger() {
  const ss = SpreadsheetApp.getActive();
  ScriptApp.newTrigger('onApprovalEdit')
    .forSpreadsheet(ss)
    .onEdit()
    .create();
}

/**
 * Combine a date-only value and a time-only value into one Date.
 */
function combineDateAndTime_(datePart, timePart) {
  const d = new Date(datePart);
  const t = new Date(timePart);

  return new Date(
    d.getFullYear(),
    d.getMonth(),
    d.getDate(),
    t.getHours(),
    t.getMinutes(),
    0,
    0
  );
}

/**
 * Build a map of header name -> column number (1-based).
 */
function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (key) headers[key] = i + 1;
  });

  return headers;
}

/**
 * Safe row lookup by header.
 */
function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return rowValues[col - 1];
}

```


### Get Calendar Script

// Easiest if you're using that account's main calendar
const calendar = CalendarApp.getDefaultCalendar();

// Or, if you want to be explicit
const calendar = CalendarApp.getCalendarById('yourthrowaway@gmail.com');


<hr style="height:4px;border-width:0;color:black;background-color:black">
















## Two Room Script

<img src="/assets/images/misc/260219ab.jpg" style="float: right; width: 200px; margin-left: 20px" />

```javascript
/**
 * One-calendar, two-room booking workflow
 *
 * Form writes to Sheet.
 * Coordinator changes Status to "Approved".
 * Script re-checks the single calendar.
 * A conflict only exists if:
 *   - times overlap, AND
 *   - room/location matches ("Studio" vs "Gallery")
 */

const CONFIG = {
  // For testing, you can use:
  // CALENDAR_MODE: 'default'
  // or use a specific calendar ID with CALENDAR_MODE: 'id'
  CALENDAR_MODE: 'default', // 'default' or 'id'
  CALENDAR_ID: 'YOUR_CALENDAR_ID_HERE', // used only if CALENDAR_MODE = 'id'

  SHEET_NAME: 'Form Responses 1',

  ROOM_VALUES: ['Studio', 'Gallery'],

  STATUS_VALUES: {
    PENDING: 'Pending',
    APPROVED: 'Approved',
    REJECTED: 'Rejected',
    CONFLICT: 'Conflict'
  }
};

function onApprovalEdit(e) {
  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  const col = e.range.getColumn();
  if (row < 2) return;

  const headers = getHeaders_(sheet);
  const statusCol = headers['Status'];
  if (!statusCol || col !== statusCol) return;

  const newStatus = String(e.range.getValue()).trim();
  if (newStatus !== CONFIG.STATUS_VALUES.APPROVED) return;

  processApprovalRow_(sheet, row, headers);
}

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const tutorName = valueByHeader_(rowValues, headers, 'Tutor Name');
  const tutorEmail = valueByHeader_(rowValues, headers, 'Tutor Email');
  const roomRaw = valueByHeader_(rowValues, headers, 'Room');
  const bookingDate = valueByHeader_(rowValues, headers, 'Booking Date');
  const startTime = valueByHeader_(rowValues, headers, 'Start Time');
  const endTime = valueByHeader_(rowValues, headers, 'End Time');
  const purpose = valueByHeader_(rowValues, headers, 'Purpose');
  const notes = valueByHeader_(rowValues, headers, 'Notes');
  const existingEventId = valueByHeader_(rowValues, headers, 'Calendar Event ID');

  const statusCol = headers['Status'];
  const noteCol = headers['Processing Note'];
  const eventIdCol = headers['Calendar Event ID'];

  const room = normalizeRoom_(roomRaw);

  if (existingEventId) {
    sheet.getRange(row, noteCol).setValue('Already created; skipped duplicate approval.');
    return;
  }

  if (!room) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(`Unknown room: ${roomRaw}`);
    return;
  }

  if (!bookingDate || !startTime || !endTime) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Missing date/time fields.');
    return;
  }

  const start = combineDateAndTime_(bookingDate, startTime);
  const end = combineDateAndTime_(bookingDate, endTime);

  if (!(start instanceof Date) || isNaN(start.getTime()) ||
      !(end instanceof Date) || isNaN(end.getTime())) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Invalid date/time values.');
    return;
  }

  if (end <= start) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('End time must be after start time.');
    return;
  }

  // Re-check overlapping events in the ONE shared calendar
  const overlapping = calendar.getEvents(start, end);

  // Conflict only if the overlapping event is for the SAME room
  const sameRoomConflict = overlapping.some(event => {
    const eventRoom = normalizeRoom_(event.getLocation());
    return eventRoom === room;
  });

  if (sameRoomConflict) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(
      `Conflict detected at approval time: ${room} is already booked.`
    );
    return;
  }

  const title = `Art Society Booking - ${tutorName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Tutor: ${tutorName || ''}`,
    `Email: ${tutorEmail || ''}`,
    `Room: ${room}`,
    `Purpose: ${purpose || ''}`,
    '',
    'Notes:',
    notes || ''
  ];

  const event = calendar.createEvent(title, start, end, {
    location: room,
    description: descriptionLines.join('\n')
  });

  sheet.getRange(row, eventIdCol).setValue(event.getId());
  sheet.getRange(row, noteCol).setValue(`Calendar event created successfully in ${room}.`);
}

function getTargetCalendar_() {
  if (CONFIG.CALENDAR_MODE === 'default') {
    return CalendarApp.getDefaultCalendar();
  }
  return CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
}

function normalizeRoom_(value) {
  const v = String(value || '').trim().toLowerCase();

  if (v === 'studio') return 'Studio';
  if (v === 'gallery') return 'Gallery';

  return '';
}

function ensureColumnsExist() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(CONFIG.SHEET_NAME);
  if (!sheet) throw new Error('Sheet not found.');

  const headers = getHeaders_(sheet);
  const required = ['Status', 'Calendar Event ID', 'Processing Note'];
  let lastCol = sheet.getLastColumn();

  required.forEach(name => {
    if (!headers[name]) {
      lastCol += 1;
      sheet.getRange(1, lastCol).setValue(name);
    }
  });

  const refreshed = getHeaders_(sheet);
  const statusCol = refreshed['Status'];

  const rule = SpreadsheetApp.newDataValidation()
    .requireValueInList([
      CONFIG.STATUS_VALUES.PENDING,
      CONFIG.STATUS_VALUES.APPROVED,
      CONFIG.STATUS_VALUES.REJECTED,
      CONFIG.STATUS_VALUES.CONFLICT
    ], true)
    .setAllowInvalid(false)
    .build();

  sheet.getRange(2, statusCol, Math.max(sheet.getMaxRows() - 1, 1), 1).setDataValidation(rule);
}

function createInstallableTrigger() {
  const ss = SpreadsheetApp.getActive();
  ScriptApp.newTrigger('onApprovalEdit')
    .forSpreadsheet(ss)
    .onEdit()
    .create();
}

function combineDateAndTime_(datePart, timePart) {
  const d = new Date(datePart);
  const t = new Date(timePart);

  return new Date(
    d.getFullYear(),
    d.getMonth(),
    d.getDate(),
    t.getHours(),
    t.getMinutes(),
    0,
    0
  );
}

function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (key) headers[key] = i + 1;
  });

  return headers;
}

function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return rowValues[col - 1];
}
```

<hr style="height:4px;border-width:0;color:black;background-color:black">












## Script Update
### 25-Mar-2026

<img src="/assets/images/misc/260219ac.jpg" style="float: right; width: 200px; margin-left: 20px" />


```javascript
/**
 * One-calendar, two-room booking workflow
 */

const CONFIG = {
  CALENDAR_MODE: 'default', // 'default' or 'id'
  CALENDAR_ID: '', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'Admin',
  RESPONSE_SHEET_NAME: 'Form responses 3',

  ROOM_VALUES: ['Studio', 'Gallery'],

  STATUS_VALUES: {
    PENDING: 'Pending',
    APPROVED: 'Approved',
    REJECTED: 'Rejected',
    CONFLICT: 'Conflict'
  }
};

function onApprovalEdit(e) {
  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  const col = e.range.getColumn();
  if (row < 2) return;

  const headers = getHeaders_(sheet);
  const statusCol = headers['Status'];
  if (!statusCol || col !== statusCol) return;

  const newStatus = String(e.range.getValue()).trim();
  if (newStatus !== CONFIG.STATUS_VALUES.APPROVED) return;

  processApprovalRow_(sheet, row, headers);
}

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const tutorName = valueByHeader_(rowValues, headers, 'Full Name');
  const tutorEmail = valueByHeader_(rowValues, headers, 'Email address');
  
  // Allows for room change as needed by Admin
  const roomRaw = effectiveValue_(rowValues, headers, 'Assigned Room', 'Room');  

  const bookingDate = valueByHeader_(rowValues, headers, 'Event Date');
  const startTime = valueByHeader_(rowValues, headers, 'Start time');
  const endTime = valueByHeader_(rowValues, headers, 'End time');
  const purpose = valueByHeader_(rowValues, headers, 'Course Name');
  const notes = valueByHeader_(rowValues, headers, 'Notes');
  const existingEventId = valueByHeader_(rowValues, headers, 'Calendar Event ID');

  const statusCol = headers['Status'];
  const noteCol = headers['Processing Note'];
  const eventIdCol = headers['Calendar Event ID'];

  const room = normalizeRoom_(roomRaw);

  if (existingEventId) {
    sheet.getRange(row, noteCol).setValue('Already created; skipped duplicate approval.');
    return;
  }

  if (!room) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(`Unknown room: ${roomRaw}`);
    return;
  }

  if (!bookingDate || !startTime || !endTime) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Missing date/time fields.');
    return;
  }

  const start = combineDateAndTime_(bookingDate, startTime);
  const end = combineDateAndTime_(bookingDate, endTime);

  if (!(start instanceof Date) || isNaN(start.getTime()) ||
      !(end instanceof Date) || isNaN(end.getTime())) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Invalid date/time values.');
    return;
  }

  if (end <= start) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('End time must be after start time.');
    return;
  }

  const overlapping = calendar.getEvents(start, end);

  const sameRoomConflict = overlapping.some(event => {
    const eventRoom = normalizeRoom_(event.getLocation());
    return eventRoom === room;
  });

  if (sameRoomConflict) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(
      `Conflict detected at approval time: ${room} is already booked.`
    );
    return;
  }

function effectiveValue_(rowValues, headers, overrideHeader, originalHeader) {
  const overrideValue = valueByHeader_(rowValues, headers, overrideHeader);
  const originalValue = valueByHeader_(rowValues, headers, originalHeader);
  return String(overrideValue || '').trim() ? overrideValue : originalValue;
}

  const title = `Art Society Booking - ${tutorName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Tutor: ${tutorName || ''}`,
    `Email: ${tutorEmail || ''}`,
    `Room: ${room}`,
    `Purpose: ${purpose || ''}`,
    '',
    'Notes:',
    notes || ''
  ];

  const event = calendar.createEvent(title, start, end, {
    location: room,
    description: descriptionLines.join('\n')
  });

  sheet.getRange(row, eventIdCol).setValue(event.getId());
  sheet.getRange(row, noteCol).setValue(`Calendar event created successfully in ${room}.`);

  // debug output
  console.log(`bookingDate raw: ${bookingDate} | type: ${typeof bookingDate}`);
  console.log(`startTime raw: ${startTime} | type: ${typeof startTime}`);
  console.log(`endTime raw: ${endTime} | type: ${typeof endTime}`);
}

function getTargetCalendar_() {
  if (CONFIG.CALENDAR_MODE === 'default') {
    return CalendarApp.getDefaultCalendar();
  }
  return CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
}

function normalizeRoom_(value) {
  const v = String(value || '').trim().toLowerCase();

  if (v === 'studio') return 'Studio';
  if (v === 'gallery') return 'Gallery';

  return '';
}

function ensureColumnsExist() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(CONFIG.SHEET_NAME);
  if (!sheet) throw new Error('Sheet not found.');

  const headers = getHeaders_(sheet);
  const required = ['Status', 'Calendar Event ID', 'Processing Note'];
  let lastCol = sheet.getLastColumn();

  required.forEach(name => {
    if (!headers[name]) {
      lastCol += 1;
      sheet.getRange(1, lastCol).setValue(name);
    }
  });

  const refreshed = getHeaders_(sheet);
  const statusCol = refreshed['Status'];

  const rule = SpreadsheetApp.newDataValidation()
    .requireValueInList([
      CONFIG.STATUS_VALUES.PENDING,
      CONFIG.STATUS_VALUES.APPROVED,
      CONFIG.STATUS_VALUES.REJECTED,
      CONFIG.STATUS_VALUES.CONFLICT
    ], true)
    .setAllowInvalid(false)
    .build();

  sheet.getRange(2, statusCol, Math.max(sheet.getMaxRows() - 1, 1), 1).setDataValidation(rule);
}

function createInstallableTriggers() {
  const ss = SpreadsheetApp.getActive();

  ScriptApp.newTrigger('onApprovalEdit')
    .forSpreadsheet(ss)
    .onEdit()
    .create();

  ScriptApp.newTrigger('setPendingOnFormSubmit')
    .forSpreadsheet(ss)
    .onFormSubmit()
    .create();
}

function combineDateAndTime_(datePart, timePart) {
  const dateObj = parseDatePart_(datePart);
  const timeObj = parseTimePart_(timePart);

  if (!dateObj || !timeObj) {
    return new Date('invalid');
  }

  return new Date(
    dateObj.year,
    dateObj.month,
    dateObj.day,
    timeObj.hours,
    timeObj.minutes,
    0,
    0
  );
}

function parseDatePart_(value) {
  if (value instanceof Date && !isNaN(value.getTime())) {
    return {
      year: value.getFullYear(),
      month: value.getMonth(),
      day: value.getDate()
    };
  }

  const d = new Date(value);
  if (d instanceof Date && !isNaN(d.getTime())) {
    return {
      year: d.getFullYear(),
      month: d.getMonth(),
      day: d.getDate()
    };
  }

  return null;
}

function parseTimePart_(value) {
  // Case 1: already a Date object
  if (value instanceof Date && !isNaN(value.getTime())) {
    return {
      hours: value.getHours(),
      minutes: value.getMinutes()
    };
  }

  // Case 2: text like "08:00" or "8:30"
  if (typeof value === 'string') {
    const m = value.trim().match(/^(\d{1,2}):(\d{2})$/);
    if (!m) return null;

    const hours = Number(m[1]);
    const minutes = Number(m[2]);

    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) return null;

    return { hours, minutes };
  }

  // Case 3: numeric spreadsheet fraction of a day
  if (typeof value === 'number' && !isNaN(value)) {
    const totalMinutes = Math.round(value * 24 * 60);
    const hours = Math.floor(totalMinutes / 60) % 24;
    const minutes = totalMinutes % 60;
    return { hours, minutes };
  }

  return null;
}

function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (key) headers[key] = i + 1;
  });

  return headers;
}

function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return rowValues[col - 1];
}

function setPendingOnFormSubmit(e) {
  const responseSheet = e.range.getSheet();
  if (responseSheet.getName() !== CONFIG.RESPONSE_SHEET_NAME) return;

  const row = e.range.getRow();
  if (row < 2) return;

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const adminSheet = ss.getSheetByName(CONFIG.SHEET_NAME);
  if (!adminSheet) {
    throw new Error(`Sheet '${CONFIG.SHEET_NAME}' not found.`);
  }

  SpreadsheetApp.flush();

  const headers = getHeaders_(adminSheet);
  const statusCol = headers['Status'];
  if (!statusCol) {
    throw new Error("Header 'Status' not found on Admin sheet.");
  }

  const statusCell = adminSheet.getRange(row, statusCol);
  if (statusCell.isBlank()) {
    statusCell.setValue(CONFIG.STATUS_VALUES.PENDING);
  }
}


function setPendingOnFormSubmit(e) {
  const RESPONSE_SHEET_NAME = 'Form responses 3';
  const ADMIN_SHEET_NAME = 'Admin';
  const STATUS_COL = 10; // J

  const responseSheet = e.range.getSheet();
  if (responseSheet.getName() !== RESPONSE_SHEET_NAME) return;

  const row = e.range.getRow();
  if (row < 2) return;

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const adminSheet = ss.getSheetByName(ADMIN_SHEET_NAME);
  if (!adminSheet) {
    throw new Error("Sheet 'Admin' not found.");
  }

  SpreadsheetApp.flush();

  const statusCell = adminSheet.getRange(row, STATUS_COL);
  if (statusCell.isBlank()) {
    statusCell.setValue('Pending');
  }
}
```
<hr style="height:4px;border-width:0;color:black;background-color:black">














## 2nd Update
### 25-Mar-2026

<img src="/assets/images/misc/260219ad.jpg" style="float: right; width: 200px; margin-left: 20px" />


```javascript

//  One-calendar, two-room booking workflow

const CONFIG = {
  CALENDAR_MODE: 'default', // 'default' or 'id'
  CALENDAR_ID: '', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'Admin',
  RESPONSE_SHEET_NAME: 'Form responses 3',

  ROOM_VALUES: ['Studio', 'Gallery'],

  STATUS_VALUES: {
    PENDING: 'Pending',
    APPROVED: 'Approved',
    REJECTED: 'Rejected',
    CANCELLED: 'Cancelled',
    CONFLICT: 'Conflict'
  },

  HEADERS: {
    ROOM: 'Room',
    ASSIGNED_ROOM: 'Assigned Room',
    EVENT_DATE: 'Event Date',
    START_TIME: 'Start time',
    END_TIME: 'End time',
    COURSE_NAME: 'Course Name',
    FULL_NAME: 'Full Name',
    EMAIL: 'Email address',
    NOTES: 'Notes',
    STATUS: 'Status',
    EVENT_ID: 'Calendar Event ID',
    NOTE: 'Processing Note'
  }
};

/**
 * Installable onEdit trigger.
 * Name preserved so your existing trigger can keep pointing at it.
 */
function onApprovalEdit(e) {
  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  const col = e.range.getColumn();
  if (row < 2) return;

  const headers = getHeaders_(sheet);
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const assignedRoomCol = headers[CONFIG.HEADERS.ASSIGNED_ROOM];

  if (col === statusCol) {
    handleStatusEdit_(sheet, row, headers, e);
    return;
  }

  if (assignedRoomCol && col === assignedRoomCol) {
    handleAssignedRoomEdit_(sheet, row, headers, e);
  }
}

function handleStatusEdit_(sheet, row, headers, e) {
  const newStatus = trim_(e.range.getValue());
  const oldStatus = trim_(e.oldValue);

  if (!newStatus) return;

  if (newStatus === CONFIG.STATUS_VALUES.APPROVED) {
    processApprovalRow_(sheet, row, headers);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.CANCELLED) {
    processCancellationRow_(sheet, row, headers, oldStatus);
    return;
  }

  // Safety net: any move away from Approved should remove the live event.
  if (oldStatus === CONFIG.STATUS_VALUES.APPROVED && newStatus !== CONFIG.STATUS_VALUES.APPROVED) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Status changed from Approved to ${newStatus}.`,
      newStatus
    );
  }
}

function handleAssignedRoomEdit_(sheet, row, headers, e) {
  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const currentStatus = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.STATUS));

  if (currentStatus !== CONFIG.STATUS_VALUES.APPROVED) return;

  const assignedRoomCol = headers[CONFIG.HEADERS.ASSIGNED_ROOM];
  if (!assignedRoomCol) return;

  const previousRowValues = rowValues.slice();
  previousRowValues[assignedRoomCol - 1] =
    typeof e.oldValue === 'undefined' ? '' : e.oldValue;

  const previousEffectiveRoomRaw = effectiveValue_(
    previousRowValues,
    headers,
    CONFIG.HEADERS.ASSIGNED_ROOM,
    CONFIG.HEADERS.ROOM
  );
  const currentEffectiveRoomRaw = effectiveValue_(
    rowValues,
    headers,
    CONFIG.HEADERS.ASSIGNED_ROOM,
    CONFIG.HEADERS.ROOM
  );

  const previousEffectiveRoom = normalizeRoom_(previousEffectiveRoomRaw);
  const currentEffectiveRoom = normalizeRoom_(currentEffectiveRoomRaw);

  if (previousEffectiveRoom === currentEffectiveRoom) return;

  removeLiveCalendarEvent_(
    sheet,
    row,
    headers,
    `Assigned Room changed from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}; approval invalidated and returned to Pending.`,
    CONFIG.STATUS_VALUES.PENDING
  );
}

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const tutorName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.FULL_NAME);
  const tutorEmail = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EMAIL);
  const roomRaw = effectiveValue_(
    rowValues,
    headers,
    CONFIG.HEADERS.ASSIGNED_ROOM,
    CONFIG.HEADERS.ROOM
  );
  const bookingDate = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EVENT_DATE);
  const startTime = valueByHeader_(rowValues, headers, CONFIG.HEADERS.START_TIME);
  const endTime = valueByHeader_(rowValues, headers, CONFIG.HEADERS.END_TIME);
  const purpose = valueByHeader_(rowValues, headers, CONFIG.HEADERS.COURSE_NAME);
  const notes = valueByHeader_(rowValues, headers, CONFIG.HEADERS.NOTES);
  const existingEventId = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.EVENT_ID));

  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const noteCol = headers[CONFIG.HEADERS.NOTE];
  const eventIdCol = headers[CONFIG.HEADERS.EVENT_ID];

  const room = normalizeRoom_(roomRaw);

  if (existingEventId) {
    sheet.getRange(row, noteCol).setValue('Already created; skipped duplicate approval.');
    return;
  }

  if (!room) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(`Unknown room: ${roomRaw}`);
    return;
  }

  if (!bookingDate || !startTime || !endTime) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Missing date/time fields.');
    return;
  }

  const start = combineDateAndTime_(bookingDate, startTime);
  const end = combineDateAndTime_(bookingDate, endTime);

  if (
    !(start instanceof Date) || isNaN(start.getTime()) ||
    !(end instanceof Date) || isNaN(end.getTime())
  ) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('Invalid date/time values.');
    return;
  }

  if (end <= start) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue('End time must be after start time.');
    return;
  }

  const overlapping = calendar.getEvents(start, end);

  const sameRoomConflict = overlapping.some(event => {
    const eventRoom = normalizeRoom_(event.getLocation());
    return eventRoom === room;
  });

  if (sameRoomConflict) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, noteCol).setValue(
      `Conflict detected at approval time: ${room} is already booked.`
    );
    return;
  }

  const title = `Art Society Booking - ${tutorName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Tutor: ${tutorName || ''}`,
    `Email: ${tutorEmail || ''}`,
    `Room: ${room}`,
    `Purpose: ${purpose || ''}`,
    '',
    'Notes:',
    notes || ''
  ];

  const event = calendar.createEvent(title, start, end, {
    location: room,
    description: descriptionLines.join('\n')
  });

  sheet.getRange(row, eventIdCol).setValue(event.getId());
  sheet.getRange(row, noteCol).setValue(`Calendar event created successfully in ${room}.`);
}

function processCancellationRow_(sheet, row, headers, oldStatus) {
  const prefix =
    oldStatus === CONFIG.STATUS_VALUES.APPROVED
      ? 'Booking cancelled.'
      : 'Booking marked as cancelled.';

  removeLiveCalendarEvent_(
    sheet,
    row,
    headers,
    prefix,
    CONFIG.STATUS_VALUES.CANCELLED
  );
}

function removeLiveCalendarEvent_(sheet, row, headers, baseNote, newStatus) {
  const eventIdCol = headers[CONFIG.HEADERS.EVENT_ID];
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const noteCol = headers[CONFIG.HEADERS.NOTE];

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const existingEventId = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.EVENT_ID));

  let outcome = 'No linked calendar event to remove.';

  if (existingEventId) {
    const calendar = getTargetCalendar_();
    if (!calendar) {
      throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
    }

    const event = calendar.getEventById(existingEventId);

    if (event) {
      event.deleteEvent();
      outcome = 'Linked calendar event removed.';
    } else {
      outcome = 'Linked calendar event not found; ID cleared anyway.';
    }

    sheet.getRange(row, eventIdCol).clearContent();
  } else {
    sheet.getRange(row, eventIdCol).clearContent();
  }

  if (newStatus && statusCol) {
    sheet.getRange(row, statusCol).setValue(newStatus);
  }

  sheet.getRange(row, noteCol).setValue(`${baseNote} ${outcome}`.trim());
}

function getTargetCalendar_() {
  if (CONFIG.CALENDAR_MODE === 'default') {
    return CalendarApp.getDefaultCalendar();
  }
  return CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
}

function normalizeRoom_(value) {
  const v = trim_(value).toLowerCase();
  const match = CONFIG.ROOM_VALUES.find(room => room.toLowerCase() === v);
  return match || '';
}

function effectiveValue_(rowValues, headers, overrideHeader, originalHeader) {
  const overrideValue = valueByHeader_(rowValues, headers, overrideHeader);
  const originalValue = valueByHeader_(rowValues, headers, originalHeader);
  return trim_(overrideValue) ? overrideValue : originalValue;
}

function ensureColumnsExist() {
  const sheet = SpreadsheetApp.getActiveSpreadsheet().getSheetByName(CONFIG.SHEET_NAME);
  if (!sheet) throw new Error('Sheet not found.');

  const headers = getHeaders_(sheet);
  const required = [
    CONFIG.HEADERS.ASSIGNED_ROOM,
    CONFIG.HEADERS.STATUS,
    CONFIG.HEADERS.EVENT_ID,
    CONFIG.HEADERS.NOTE
  ];

  let lastCol = sheet.getLastColumn();

  required.forEach(name => {
    if (!headers[name]) {
      lastCol += 1;
      sheet.getRange(1, lastCol).setValue(name);
    }
  });

  const refreshed = getHeaders_(sheet);
  const statusCol = refreshed[CONFIG.HEADERS.STATUS];

  const rule = SpreadsheetApp.newDataValidation()
    .requireValueInList([
      CONFIG.STATUS_VALUES.PENDING,
      CONFIG.STATUS_VALUES.APPROVED,
      CONFIG.STATUS_VALUES.REJECTED,
      CONFIG.STATUS_VALUES.CANCELLED,
      CONFIG.STATUS_VALUES.CONFLICT
    ], true)
    .setAllowInvalid(false)
    .build();

  sheet.getRange(2, statusCol, Math.max(sheet.getMaxRows() - 1, 1), 1)
    .setDataValidation(rule);
}

function createInstallableTriggers() {
  const ss = SpreadsheetApp.getActive();
  const triggers = ScriptApp.getProjectTriggers();

  const hasEditTrigger = triggers.some(t =>
    t.getHandlerFunction() === 'onApprovalEdit' &&
    t.getEventType() === ScriptApp.EventType.ON_EDIT
  );

  const hasFormTrigger = triggers.some(t =>
    t.getHandlerFunction() === 'setPendingOnFormSubmit' &&
    t.getEventType() === ScriptApp.EventType.ON_FORM_SUBMIT
  );

  if (!hasEditTrigger) {
    ScriptApp.newTrigger('onApprovalEdit')
      .forSpreadsheet(ss)
      .onEdit()
      .create();
  }

  if (!hasFormTrigger) {
    ScriptApp.newTrigger('setPendingOnFormSubmit')
      .forSpreadsheet(ss)
      .onFormSubmit()
      .create();
  }
}

function combineDateAndTime_(datePart, timePart) {
  const dateObj = parseDatePart_(datePart);
  const timeObj = parseTimePart_(timePart);

  if (!dateObj || !timeObj) {
    return new Date('invalid');
  }

  return new Date(
    dateObj.year,
    dateObj.month,
    dateObj.day,
    timeObj.hours,
    timeObj.minutes,
    0,
    0
  );
}

function parseDatePart_(value) {
  if (value instanceof Date && !isNaN(value.getTime())) {
    return {
      year: value.getFullYear(),
      month: value.getMonth(),
      day: value.getDate()
    };
  }

  const d = new Date(value);
  if (d instanceof Date && !isNaN(d.getTime())) {
    return {
      year: d.getFullYear(),
      month: d.getMonth(),
      day: d.getDate()
    };
  }

  return null;
}

function parseTimePart_(value) {
  // Case 1: already a Date object
  if (value instanceof Date && !isNaN(value.getTime())) {
    return {
      hours: value.getHours(),
      minutes: value.getMinutes()
    };
  }

  // Case 2: text like "08:00" or "8:30"
  if (typeof value === 'string') {
    const m = value.trim().match(/^(\d{1,2}):(\d{2})$/);
    if (!m) return null;

    const hours = Number(m[1]);
    const minutes = Number(m[2]);

    if (hours < 0 || hours > 23 || minutes < 0 || minutes > 59) return null;

    return { hours, minutes };
  }

  // Case 3: numeric spreadsheet fraction of a day
  if (typeof value === 'number' && !isNaN(value)) {
    const totalMinutes = Math.round(value * 24 * 60);
    const hours = Math.floor(totalMinutes / 60) % 24;
    const minutes = totalMinutes % 60;
    return { hours, minutes };
  }

  return null;
}

function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (key) headers[key] = i + 1;
  });

  return headers;
}

function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return rowValues[col - 1];
}

function trim_(value) {
  return String(value || '').trim();
}

function setPendingOnFormSubmit(e) {
  if (!e || !e.range) return;

  const responseSheet = e.range.getSheet();
  if (responseSheet.getName() !== CONFIG.RESPONSE_SHEET_NAME) return;

  const row = e.range.getRow();
  if (row < 2) return;

  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const adminSheet = ss.getSheetByName(CONFIG.SHEET_NAME);
  if (!adminSheet) {
    throw new Error(`Sheet '${CONFIG.SHEET_NAME}' not found.`);
  }

  SpreadsheetApp.flush();

  const headers = getHeaders_(adminSheet);
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  if (!statusCol) {
    throw new Error(`Header '${CONFIG.HEADERS.STATUS}' not found on Admin sheet.`);
  }

  const statusCell = adminSheet.getRange(row, statusCol);
  if (statusCell.isBlank()) {
    statusCell.setValue(CONFIG.STATUS_VALUES.PENDING);
  }
}
```

---

<hr style="height:24px;border-width:0;color:black;background-color:black">
