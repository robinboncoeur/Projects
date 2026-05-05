# Booking App v.1

## Original
### 05.Apr.2026

```javascript
/**
 * One-calendar, two-room booking workflow
 */

const CONFIG = {
  CALENDAR_MODE: 'id', // 'default' or 'id'
  // NOTE: This ID is to a TEST calendar - change at GoLIVE
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'Admin',

  // NOTE: Check Form response # at GoLIVE... subject to change
  RESPONSE_SHEET_NAME: 'Form responses 4',

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


// Updated 30-Mar-2026 to improve 'Processing Note' output (col K)

function handleStatusEdit_(sheet, row, headers, e) {
  const newStatus = trim_(e.range.getValue());
  const oldStatus = trim_(e.oldValue);
  const noteCol = headers[CONFIG.HEADERS.NOTE];

  if (!newStatus) return;

  if (newStatus === CONFIG.STATUS_VALUES.APPROVED) {
    processApprovalRow_(sheet, row, headers);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.CANCELLED) {
    processCancellationRow_(sheet, row, headers, oldStatus);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.REJECTED) {
    if (oldStatus === CONFIG.STATUS_VALUES.APPROVED) {
      removeLiveCalendarEvent_(
        sheet,
        row,
        headers,
        'Booking rejected by manager.',
        CONFIG.STATUS_VALUES.REJECTED
      );
    } else {
      sheet.getRange(row, noteCol).setValue('Booking rejected by manager.');
    }
    return;
  }

  // Optional: if someone manually sets Conflict, leave a note.
  if (newStatus === CONFIG.STATUS_VALUES.CONFLICT) {
    sheet.getRange(row, noteCol).setValue('Booking marked as conflict. Review room/date/time before re-approval.');
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


// Updated 30-Mar-2026 to improve 'Processing Note' output (col K)

function handleAssignedRoomEdit_(sheet, row, headers, e) {
  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const currentStatus = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.STATUS));
  const noteCol = headers[CONFIG.HEADERS.NOTE];
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

  // If the booking is live, changing room invalidates approval and removes the event.
  if (currentStatus === CONFIG.STATUS_VALUES.APPROVED) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Assigned Room changed from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}; approval invalidated and returned to Pending.`,
      CONFIG.STATUS_VALUES.PENDING
    );
    return;
  }

  // If the booking is currently in conflict, update the note so the manager knows
  // the new room choice has been recorded, but still needs re-approval to test.
  if (currentStatus === CONFIG.STATUS_VALUES.CONFLICT) {
    sheet.getRange(row, noteCol).setValue(
      `Assigned Room changed from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}. Re-approve to test availability for the new room.`
    );
    return;
  }

  // For Pending / Rejected / Cancelled, just note the room change.
  sheet.getRange(row, noteCol).setValue(
    `Assigned Room updated from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}.`
  );
}


// Updated 30-Mar-2026 to improve 'Processing Note' output (col K)

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const tutorName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.FULL_NAME);
  const tutorEmail = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EMAIL);

  const requestedRoomRaw = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ROOM);
  const assignedRoomRaw = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ASSIGNED_ROOM);

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
  const usingAssignedRoom = trim_(assignedRoomRaw) !== '';

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

    const conflictMessage = usingAssignedRoom
      ? `Conflict detected at approval time: reassigned room ${room} is also already booked.`
      : `Conflict detected at approval time: ${room} is already booked.`;

    sheet.getRange(row, noteCol).setValue(conflictMessage);
    return;
  }

  const title = `RCAS - ${tutorName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Tutor: ${tutorName || ''}`,
    `Email: ${tutorEmail || ''}`,
    `Requested Room: ${requestedRoomRaw || ''}`,
    `Assigned Room: ${assignedRoomRaw || ''}`,
    `Effective Room: ${room}`,
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










## Edited
### 05.Apr.2026

```javascript
/**
 * One-calendar, two-room booking workflow
 */


// ** Constants Set ** //
const CONFIG = {
  CALENDAR_MODE: 'id', // 'default' or 'id'
  // NOTE: This ID is to a TEST calendar - change at GoLIVE
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'WebForm_Submissions',

  // NOTE: Check Form response # at GoLIVE... subject to change
  RESPONSE_SHEET_NAME: 'Form responses 4',

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
// ** onApprovalEdit(e) ** //
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




// **     handleStatusEdit_(sheet, row, headers, e)     ** //
// Updated 30-Mar-2026 to improve 
// 'Processing Note' output (col K)

function handleStatusEdit_(sheet, row, headers, e) {
  const newStatus = trim_(e.range.getValue());
  const oldStatus = trim_(e.oldValue);
  const noteCol = headers[CONFIG.HEADERS.NOTE];

  if (!newStatus) return;

  if (newStatus === CONFIG.STATUS_VALUES.APPROVED) {
    processApprovalRow_(sheet, row, headers);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.CANCELLED) {
    processCancellationRow_(sheet, row, headers, oldStatus);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.REJECTED) {
    if (oldStatus === CONFIG.STATUS_VALUES.APPROVED) {
      removeLiveCalendarEvent_(
        sheet,
        row,
        headers,
        'Booking rejected by manager.',
        CONFIG.STATUS_VALUES.REJECTED
      );
    } else {
      sheet.getRange(row, noteCol).setValue('Booking rejected by manager.');
    }
    return;
  }

  // Optional: if someone manually sets Conflict, leave a note.
  if (newStatus === CONFIG.STATUS_VALUES.CONFLICT) {
    sheet.getRange(row, noteCol).setValue('Booking marked as conflict. Review room/date/time before re-approval.');
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




// **     handleAssignedRoomEdit_(sheet, row, headers, e)     ** //
// Updated 30-Mar-2026 to improve 
// 'Processing Note' output (col K)

function handleAssignedRoomEdit_(sheet, row, headers, e) {
  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const currentStatus = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.STATUS));
  const noteCol = headers[CONFIG.HEADERS.NOTE];
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

  // If the booking is live, changing room invalidates approval and removes the event.
  if (currentStatus === CONFIG.STATUS_VALUES.APPROVED) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Assigned Room changed from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}; approval invalidated and returned to Pending.`,
      CONFIG.STATUS_VALUES.PENDING
    );
    return;
  }

  // If the booking is currently in conflict, update the note so the manager knows
  // the new room choice has been recorded, but still needs re-approval to test.
  if (currentStatus === CONFIG.STATUS_VALUES.CONFLICT) {
    sheet.getRange(row, noteCol).setValue(
      `Assigned Room changed from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}. Re-approve to test availability for the new room.`
    );
    return;
  }

  // For Pending / Rejected / Cancelled, just note the room change.
  sheet.getRange(row, noteCol).setValue(
    `Assigned Room updated from ${previousEffectiveRoom || previousEffectiveRoomRaw || '(blank)'} to ${currentEffectiveRoom || currentEffectiveRoomRaw || '(blank)'}.`
  );
}




// **     processApprovalRow_(sheet, row, headers)     ** //
// Updated 30-Mar-2026 to improve 
// 'Processing Note' output (col K)

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const tutorName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.FULL_NAME);
  const tutorEmail = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EMAIL);

  const requestedRoomRaw = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ROOM);
  const assignedRoomRaw = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ASSIGNED_ROOM);

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
  const usingAssignedRoom = trim_(assignedRoomRaw) !== '';

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

    const conflictMessage = usingAssignedRoom
      ? `Conflict detected at approval time: reassigned room ${room} is also already booked.`
      : `Conflict detected at approval time: ${room} is already booked.`;

    sheet.getRange(row, noteCol).setValue(conflictMessage);
    return;
  }

  const title = `RCAS - ${tutorName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Tutor: ${tutorName || ''}`,
    `Email: ${tutorEmail || ''}`,
    `Requested Room: ${requestedRoomRaw || ''}`,
    `Assigned Room: ${assignedRoomRaw || ''}`,
    `Effective Room: ${room}`,
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



// **     processCancellationRow_(sheet, row, headers, oldStatus)     ** //

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



// **     removeLiveCalendarEvent_(sheet, row, headers, baseNote, newStatus)     ** //

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



// **     getTargetCalendar_()     ** //

function getTargetCalendar_() {
  if (CONFIG.CALENDAR_MODE === 'default') {
    return CalendarApp.getDefaultCalendar();
  }
  return CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
}




// **     normalizeRoom_(value)     ** //

function normalizeRoom_(value) {
  const v = trim_(value).toLowerCase();
  const match = CONFIG.ROOM_VALUES.find(room => room.toLowerCase() === v);
  return match || '';
}




// **     effectiveValue_(rowValues, headers, overrideHeader, originalHeader)     ** //

function effectiveValue_(rowValues, headers, overrideHeader, originalHeader) {
  const overrideValue = valueByHeader_(rowValues, headers, overrideHeader);
  const originalValue = valueByHeader_(rowValues, headers, originalHeader);
  return trim_(overrideValue) ? overrideValue : originalValue;
}




// **     ensureColumnsExist()     ** //

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




// **     createInstallableTriggers()     ** //

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




// **     combineDateAndTime_(datePart, timePart)     ** //

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




// **     parseDatePart_(value)     ** //

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




// **     parseTimePart_(value)     ** //

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




// **     getHeaders_(sheet)     ** //

function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (key) headers[key] = i + 1;
  });

  return headers;
}




// **     valueByHeader_(rowValues, headers, headerName)     ** //

function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return rowValues[col - 1];
}




// **     trim_(value)     ** //

function trim_(value) {
  return String(value || '').trim();
}




// **     setPendingOnFormSubmit(e)     ** //

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




## Constants

So, the first thing I'm copying are the constants:

```javascript
const CONFIG = {
  CALENDAR_MODE: 'id', // 'default' or 'id'
  // NOTE: This ID is to a TEST calendar - change at GoLIVE
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'WebForm_Submissions',
  RESPONSE_SHEET_NAME: 'WebForm_Submissions',

  ROOM_VALUES: ['Studio', 'Gallery'],

  STATUS_VALUES: {
    PENDING: 'Pending',
    APPROVED: 'Approved',
    REJECTED: 'Rejected',
    CANCELLED: 'Cancelled',
    CONFLICT: 'Conflict'
  },

  HEADERS: {
    TIMESTAMP: 'Timestamp',
    FULL_NAME: 'Full Name',
    EMAIL: 'Email',
    COURSE_NAME: 'Course Name',
    ROOM: 'Room',
    EVENT_DATE: 'Event Date',
    START_TIME: 'Start Time',
    END_TIME: 'End Time',
    RECURRING: 'Recurring',
    FREQUENCY: 'Frequency',
    REPEAT_UNTIL: 'Repeat Until',
    STATUS: 'Status',
    EVENT_ID: 'Calendar Event ID',
    NOTE: 'Processing Note'
  }
};
```







## BP 02-May-2026


129/79 73   
118/76 74   
115/74 74


132/84 70   
125/82 69   
120/80 68   
119/79 68


122/74 67   
118/72 64   
114/71 63
