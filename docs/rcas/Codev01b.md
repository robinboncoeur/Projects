# Booking App v0.1b

## Update
### 11.Apr.2026

<hr style="height:8px; border-width:0; color:blue; background-color:blue" />



## Code.gs

```javascript

// Code.gs

function doGet() {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Booking Request - Test App');
}



function submitBooking(formData) {
  const sheetName = CONFIG.SHEET_NAME;
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    throw new Error(`Sheet "${sheetName}" not found.`);
  }

  const requiredFields = [
    'fullName',
    'email',
    'courseName',
    'room',
    'eventDate',
    'startTime',
    'endTime',
    'recurring'
  ];

  for (const field of requiredFields) {
    if (!formData[field] || String(formData[field]).trim() === '') {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  if (formData.recurring === 'Yes') {
    if (!formData.frequency || !formData.repeatUntil) {
      throw new Error('Recurring bookings require Frequency and Repeat Until.');
    }
  }

  const start = parseTimeToMinutes(formData.startTime);
  const end = parseTimeToMinutes(formData.endTime);

  if (start % 30 !== 0 || end % 30 !== 0) {
    throw new Error('Times must be entered in 30-minute increments.');
  }

  if (end <= start) {
    throw new Error('End time must be later than start time.');
  }

  sheet.appendRow([
    new Date(),
    formData.fullName,
    formData.email,
    formData.courseName,
    formData.room,
    formData.eventDate,
    formData.startTime,
    formData.endTime,
    formData.recurring,
    formData.frequency || '',
    formData.repeatUntil || '',
    CONFIG.STATUS_VALUES.PENDING,
    '',
    ''
  ]);

  logAction_('INFO', 'Booking submitted', {
    fullName: formData.fullName,
    email: formData.email,
    courseName: formData.courseName,
    room: formData.room,
    eventDate: formData.eventDate,
    startTime: formData.startTime,
    endTime: formData.endTime,
    recurring: formData.recurring
  });

  return {
    success: true,
    message: 'Booking request submitted successfully.'
  };
}



function parseTimeToMinutes(timeStr) {
  const parts = String(timeStr).split(':');
  if (parts.length !== 2) {
    throw new Error(`Invalid time format: ${timeStr}`);
  }

  const hours = Number(parts[0]);
  const minutes = Number(parts[1]);

  if (
    Number.isNaN(hours) ||
    Number.isNaN(minutes) ||
    hours < 0 ||
    hours > 23 ||
    minutes < 0 ||
    minutes > 59
  ) {
    throw new Error(`Invalid time value: ${timeStr}`);
  }

  return hours * 60 + minutes;
}
```

<hr style="height:8px; border-width:0; color:blue; background-color:blue" />










## Index.html

```html

// Index.html

<!DOCTYPE html>
<html>
  <head>
    <base target="_top">
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 24px;
        background: #f7f7f7;
      }

      .container {
        max-width: 850px;
        margin: 0 auto;
        background: white;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
      }

      h1 {
        margin-top: 0;
        font-size: 1.6rem;
      }

      .grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px 20px;
      }

      .field {
        display: flex;
        flex-direction: column;
      }

      .field.full {
        grid-column: 1 / -1;
      }

      label {
        font-weight: 600;
        margin-bottom: 6px;
      }

      input,
      select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
        background: white;
      }

      .actions {
        margin-top: 24px;
      }

      button {
        background: #1a73e8;
        color: white;
        border: none;
        padding: 12px 18px;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
      }

      button:hover {
        background: #155ec4;
      }

      .message {
        margin-top: 16px;
        padding: 12px;
        border-radius: 8px;
        display: none;
      }

      .message.success {
        background: #e6f4ea;
        color: #137333;
        display: block;
      }

      .message.error {
        background: #fce8e6;
        color: #c5221f;
        display: block;
      }

      .hidden {
        display: none;
      }

      @media (max-width: 700px) {
        .grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="logo-wrap">
        <img src="https://celestesgrl.github.io/rcas/images/Logo-RCASsm.png" alt="Art Society logo" class="logo" style="width=150px;">
      </div>
      <h1>Booking Request - Testing</h1>
      <form id="bookingForm">
        <div class="grid">
          <div class="field">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" required>
          </div>

          <div class="field">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
          </div>

          <div class="field full">
            <label for="courseName">Class Name</label>
            <input type="text" id="courseName" name="courseName" required>
          </div>

          <div class="field">
            <label for="room">Room</label>
            <select id="room" name="room" required>
              <option value="">Select a room</option>
              <option value="Studio">Studio</option>
              <option value="Gallery">Gallery</option>
            </select>
          </div>

          <div class="field">
            <label for="eventDate">Event Date</label>
            <input type="date" id="eventDate" name="eventDate" required>
          </div>

          <div class="field">
            <label for="startTime">Start Time</label>
            <input type="time" id="startTime" name="startTime" step="1800" required>
          </div>

          <div class="field">
            <label for="endTime">End Time</label>
            <input type="time" id="endTime" name="endTime" step="1800" required>
          </div>

          <div class="field">
            <label for="recurring">Recurring?</label>
            <select id="recurring" name="recurring" required>
              <option value="No" selected>No</option>
              <option value="Yes">Yes</option>
            </select>
          </div>

          <div class="field hidden" id="frequencyField">
            <label for="frequency">Frequency</label>
            <select id="frequency" name="frequency">
              <option value="">Select frequency</option>
              <option value="Weekly">Weekly</option>
              <option value="Fortnightly">Fortnightly</option>
            </select>
          </div>

          <div class="field hidden" id="repeatUntilField">
            <label for="repeatUntil">Repeat Until</label>
            <input type="date" id="repeatUntil" name="repeatUntil">
          </div>
        </div>

        <div class="actions">
          <button type="submit">Submit Booking Request</button>
        </div>

        <div id="message" class="message"></div>
      </form>
    </div>

    <script>
      document.addEventListener('DOMContentLoaded', function () {

        const form = document.getElementById('bookingForm');
        const messageBox = document.getElementById('message');
        const recurringSelect = document.getElementById('recurring');
        const frequencyField = document.getElementById('frequencyField');
        const repeatUntilField = document.getElementById('repeatUntilField');
        const frequencyInput = document.getElementById('frequency');
        const repeatUntilInput = document.getElementById('repeatUntil');
        const eventDateInput = document.getElementById('eventDate');

        function showMessage(text, type) {
          messageBox.textContent = text;
          messageBox.className = `message ${type}`;
        }

        function clearMessage() {
          messageBox.textContent = '';
          messageBox.className = 'message';
        }

        function timeToMinutes(timeStr) {
          const [hours, minutes] = timeStr.split(':').map(Number);
          return hours * 60 + minutes;
        }

        function setMinimumEventDate() {
          const today = new Date();
          const yyyy = today.getFullYear();
          const mm = String(today.getMonth() + 1).padStart(2, '0');
          const dd = String(today.getDate()).padStart(2, '0');

          eventDateInput.min = `${yyyy}-${mm}-${dd}`;
        }

        function toggleRecurringFields() {
          const isRecurring = recurringSelect.value === 'Yes';

          frequencyField.classList.toggle('hidden', !isRecurring);
          repeatUntilField.classList.toggle('hidden', !isRecurring);

          frequencyInput.required = isRecurring;
          repeatUntilInput.required = isRecurring;

          if (!isRecurring) {
            frequencyInput.value = '';
            repeatUntilInput.value = '';
          }
        }

        // Initialise UI state
        recurringSelect.addEventListener('change', toggleRecurringFields);
        toggleRecurringFields();
        setMinimumEventDate();

        form.addEventListener('submit', function (e) {
          e.preventDefault();
          clearMessage();

          const formData = {
            fullName: form.fullName.value.trim(),
            email: form.email.value.trim(),
            courseName: form.courseName.value.trim(),
            room: form.room.value,
            eventDate: form.eventDate.value,
            startTime: form.startTime.value,
            endTime: form.endTime.value,
            recurring: form.recurring.value,
            frequency: form.frequency.value,
            repeatUntil: form.repeatUntil.value
          };

          // Required fields
          if (
            !formData.fullName ||
            !formData.email ||
            !formData.courseName ||
            !formData.room ||
            !formData.eventDate ||
            !formData.startTime ||
            !formData.endTime ||
            !formData.recurring
          ) {
            showMessage('Please complete all required fields.', 'error');
            return;
          }

          // Prevent past dates
          const today = new Date();
          today.setHours(0, 0, 0, 0);

          const selectedDate = new Date(formData.eventDate + 'T00:00:00');

          if (selectedDate < today) {
            showMessage('Please choose today or a future date.', 'error');
            return;
          }

          // 30-minute increments
          if (
            timeToMinutes(formData.startTime) % 30 !== 0 ||
            timeToMinutes(formData.endTime) % 30 !== 0
          ) {
            showMessage('Please use 30-minute increments only.', 'error');
            return;
          }

          // End after start
          if (timeToMinutes(formData.endTime) <= timeToMinutes(formData.startTime)) {
            showMessage('End time must be later than start time.', 'error');
            return;
          }

          // Recurring validation
          if (formData.recurring === 'Yes') {
            if (!formData.frequency || !formData.repeatUntil) {
              showMessage('Please complete the recurring booking fields.', 'error');
              return;
            }

            if (formData.repeatUntil < formData.eventDate) {
              showMessage('Repeat Until must be on or after the Event Date.', 'error');
              return;
            }
          }

          // Submit to Apps Script
          google.script.run
            .withSuccessHandler(function (response) {
              showMessage(response.message, 'success');
              form.reset();
              toggleRecurringFields();
              setMinimumEventDate();
            })
            .withFailureHandler(function (error) {
              showMessage(error.message || 'Something went wrong.', 'error');
            })
            .submitBooking(formData);
        });

      });
    </script>
  </body>
</html>

```
<hr style="height:8px; border-width:0; color:blue; background-color:blue" />











## SheetFunct.gs


```javascript
// SheetFunct.gs

const CONFIG = {
  CALENDAR_MODE: 'id', // 'default' or 'id'
  // NOTE: This ID is to a TEST calendar - change at GoLIVE
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'WebForm_Submissions',
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
    CALENDAR_EVENT_ID: 'Calendar Event ID',
    PROCESSING_NOTE: 'Processing Note',
    ASSIGNED_ROOM: 'Assigned Room',
  }
};


// * onApprovalEdit(e)

function onApprovalEdit(e) {
// Writes action to System_Log
  logAction_('INFO', 'onApprovalEdit fired', {
    sheet: e && e.range ? e.range.getSheet().getName() : '',
    row: e && e.range ? e.range.getRow() : '',
    col: e && e.range ? e.range.getColumn() : '',
    value: e && e.value ? e.value : '',
    oldValue: e && e.oldValue ? e.oldValue : ''
  });


  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  const col = e.range.getColumn();
  if (row < 2) return;

  const headerRow = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const editedHeader = String(headerRow[col - 1] || '').trim();

  const headers = getHeaders_(sheet);

  if (editedHeader === CONFIG.HEADERS.ASSIGNED_ROOM) {
    handleAssignedRoomEdit_(e, sheet, row, headers);
    return;
  }

  const statusCol = headers[CONFIG.HEADERS.STATUS];
  if (!statusCol) {
    throw new Error(`Missing header: ${CONFIG.HEADERS.STATUS}`);
  }

  if (col === statusCol) {
    handleStatusEdit_(sheet, row, headers, e);
  }
}




function handleStatusEdit_(sheet, row, headers, e) {
  const newStatus = trim_(e.range.getValue());
  const oldStatus = trim_(e.oldValue);
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!noteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  // Ignore an empty status cell
  if (!newStatus) return;

  // Added to trap for someone deleting the dropdown and typing their own status
  const allowedStatuses = Object.values(CONFIG.STATUS_VALUES);
  if (!allowedStatuses.includes(newStatus)) {
    sheet.getRange(row, noteCol).setValue(`Unknown status: ${newStatus}`);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.APPROVED) {
    processApprovalRow_(sheet, row, headers);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.CANCELLED) {
    processCancellationRow_(sheet, row, headers, oldStatus);
    return;
  }

  if (newStatus === CONFIG.STATUS_VALUES.REJECTED) {
    if (oldStatus !== CONFIG.STATUS_VALUES.APPROVED) {
      sheet.getRange(row, noteCol).setValue('Booking rejected by manager.');
      return;
    }
    // fall through to safety net below
  } else if (newStatus === CONFIG.STATUS_VALUES.CONFLICT) {
    if (oldStatus !== CONFIG.STATUS_VALUES.APPROVED) {
      sheet.getRange(row, noteCol).setValue(
        'Booking marked as conflict. Review room/date/time before re-approval.'
      );
      return;
    }
    // fall through to safety net below
  }

  // Safety net: any move away from Approved should remove the live event.
  if (
    oldStatus === CONFIG.STATUS_VALUES.APPROVED &&
    newStatus !== CONFIG.STATUS_VALUES.APPROVED
  ) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Status changed from Approved to ${newStatus}.`,
      newStatus
    );
  }
}


// * handleAssignedRoomEdit

function handleAssignedRoomEdit_(e, sheet, row, headers) {
  const oldValue = String(e.oldValue || '').trim();
  const newValue = String(e.value || '').trim();

  // If nothing materially changed, do nothing
  if (oldValue === newValue) return;

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const status = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.STATUS));
  const requestedRoom = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.ROOM));
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];
  if (!noteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  const oldEffectiveRoom = normalizeRoom_(oldValue || requestedRoom);
  const newEffectiveRoom = normalizeRoom_(newValue || requestedRoom);

  const oldEffectiveRoomDisplay = oldEffectiveRoom || oldValue || requestedRoom || '(blank)';
  const newEffectiveRoomDisplay = newEffectiveRoom || newValue || requestedRoom || '(blank)';

  // If effective room did not actually change, do nothing
  if (oldEffectiveRoom === newEffectiveRoom) return;

  // If the booking is live, changing room invalidates approval and removes the event
  if (status === CONFIG.STATUS_VALUES.APPROVED) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Assigned Room changed from ${oldEffectiveRoomDisplay} to ${newEffectiveRoomDisplay}; approval invalidated and returned to Pending.`,
      CONFIG.STATUS_VALUES.PENDING
    );
    return;
  }

  // If the booking is currently in conflict, keep Conflict but update the note
  if (status === CONFIG.STATUS_VALUES.CONFLICT) {
    sheet.getRange(row, noteCol).setValue(
      `Assigned Room changed from ${oldEffectiveRoomDisplay} to ${newEffectiveRoomDisplay}. Re-approve to test availability for the new room.`
    );
    return;
  }

  // For Pending / Rejected / Cancelled, just note the room change
  sheet.getRange(row, noteCol).setValue(
    `Assigned Room updated from ${oldEffectiveRoomDisplay} to ${newEffectiveRoomDisplay}.`
  );
}





// * processApprovalRow

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const fullName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.FULL_NAME);
  const fnEmail = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EMAIL);
  const courseName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.COURSE_NAME);
  const requestedRoom = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ROOM);
  const assignedRoom = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ASSIGNED_ROOM);
  const effectiveRoomRaw = trim_(assignedRoom) || trim_(requestedRoom);
  const room = normalizeRoom_(effectiveRoomRaw);
  const bookingDate = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EVENT_DATE);
  const startTime = valueByHeader_(rowValues, headers, CONFIG.HEADERS.START_TIME);
  const endTime = valueByHeader_(rowValues, headers, CONFIG.HEADERS.END_TIME);
  const recurring = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.RECURRING));
  const frequency = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.FREQUENCY));
  const repeatUntil = valueByHeader_(rowValues, headers, CONFIG.HEADERS.REPEAT_UNTIL);
  const existingEventId = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.CALENDAR_EVENT_ID));

  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const eventIdCol = headers[CONFIG.HEADERS.CALENDAR_EVENT_ID];
  const procNoteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!statusCol) throw new Error(`Missing header: ${CONFIG.HEADERS.STATUS}`);
  if (!eventIdCol) throw new Error(`Missing header: ${CONFIG.HEADERS.CALENDAR_EVENT_ID}`);
  if (!procNoteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  if (existingEventId) {
    sheet.getRange(row, procNoteCol).setValue('Already created; skipped duplicate approval.');
    return;
  }

  if (!room) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue(`Unknown room: ${effectiveRoomRaw}`);
    return;
  }

  if (!bookingDate || !startTime || !endTime) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('Missing date/time fields.');
    return;
  }

  const start = combineDateAndTime_(bookingDate, startTime);
  const end = combineDateAndTime_(bookingDate, endTime);

  if (
    !(start instanceof Date) || isNaN(start.getTime()) ||
    !(end instanceof Date) || isNaN(end.getTime())
  ) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('Invalid date/time values.');
    return;
  }

  const now = new Date();
  if (start < now) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('Booking start time is in the past.');
    return;
  }

  if (end <= start) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('End time must be after start time.');
    return;
  }

  if (recurring === 'Yes') {
    if (!frequency || !repeatUntil) {
      sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
      sheet.getRange(row, procNoteCol).setValue(
        'Recurring booking is missing Frequency or Repeat Until.'
      );
      return;
    }

    if (repeatUntil < bookingDate) {
      sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
      sheet.getRange(row, procNoteCol).setValue(
        'Repeat Until must be on or after the Event Date.'
      );
      return;
    }
  }

  const sameRoomConflict = hasRoomConflict_(calendar, start, end, room);
  if (sameRoomConflict) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue(
      `Conflict detected at approval time: ${room} is already booked.`
    );
    return;
  }

  const title = `${fullName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Full Name: ${fullName || ''}`,
    `Email: ${fnEmail || ''}`,
    `Room: ${room}`,
    `Course Name: ${courseName || ''}`,
    `Recurring: ${recurring || 'No'}`,
    `Frequency: ${frequency || ''}`,
    `Repeat Until: ${repeatUntil || ''}`
  ];

  const event = calendar.createEvent(title, start, end, {
    location: room,
    description: descriptionLines.join('\n')
  });

  sheet.getRange(row, eventIdCol).setValue(event.getId());

  if (recurring === 'Yes') {
    sheet.getRange(row, procNoteCol).setValue(
      `Calendar event created successfully in ${room}. Recurring logic not yet implemented.`
    );
  } else {
    sheet.getRange(row, procNoteCol).setValue(
      `Calendar event created successfully in ${room}.`
    );
  }
}



// * processCancellationRow

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



// ------------------------------------------------
// Helper Functions
// ------------------------------------------------

function hasRoomConflict_(calendar, start, end, room) {
  const overlapping = calendar.getEvents(start, end);

  return overlapping.some(event => {
    const eventRoom = normalizeRoom_(event.getLocation());
    return eventRoom === room;
  });
}







function normalizeRoom_(value) {
  const room = String(value || '').trim();

  if (!room) return '';

  const normalized = room.toLowerCase();

  if (normalized === 'studio') return 'Studio';
  if (normalized === 'gallery') return 'Gallery';

  return '';
}



// * removeLiveCalendarEvent

function removeLiveCalendarEvent_(sheet, row, headers, baseNote, newStatus) {
  const eventIdCol = headers[CONFIG.HEADERS.CALENDAR_EVENT_ID];
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!eventIdCol) throw new Error(`Missing header: ${CONFIG.HEADERS.CALENDAR_EVENT_ID}`);
  if (!noteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const existingEventId = trim_(
    valueByHeader_(rowValues, headers, CONFIG.HEADERS.CALENDAR_EVENT_ID)
  );

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
  }

  sheet.getRange(row, eventIdCol).clearContent();

  if (newStatus && statusCol) {
    const currentStatus = trim_(sheet.getRange(row, statusCol).getValue());
    if (currentStatus !== newStatus) {
      sheet.getRange(row, statusCol).setValue(newStatus);
    }
  }

  sheet.getRange(row, noteCol).setValue(`${baseNote} ${outcome}`.trim());
}



function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (!key) return;

    if (headers[key]) {
      throw new Error(`Duplicate header found: ${key}`);
    }

    headers[key] = i + 1;
  });

  return headers;
}



function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return col - 1 < rowValues.length ? rowValues[col - 1] : '';
}



function trim_(value) {
  return value == null ? '' : String(value).trim();
}



// * getTargetCalendar

function getTargetCalendar_() {
  if (CONFIG.CALENDAR_MODE === 'default') {
    return CalendarApp.getDefaultCalendar();
  }

  if (CONFIG.CALENDAR_MODE === 'id') {
    if (!CONFIG.CALENDAR_ID) {
      throw new Error('CONFIG.CALENDAR_ID is missing.');
    }
    return CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
  }

  throw new Error(`Invalid CALENDAR_MODE: ${CONFIG.CALENDAR_MODE}`);
}



// * setPendingOnFormSubmit(e)

function setPendingOnFormSubmit(e) {
  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  if (row < 2) return;

  SpreadsheetApp.flush();

  const headers = getHeaders_(sheet);
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  if (!statusCol) {
    throw new Error(`Header '${CONFIG.HEADERS.STATUS}' not found.`);
  }

  const statusCell = sheet.getRange(row, statusCol);
  if (statusCell.isBlank()) {
    statusCell.setValue(CONFIG.STATUS_VALUES.PENDING);
  }
}



function logAction_(level, message, details) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let logSheet = ss.getSheetByName('System_Log');

  if (!logSheet) {
    logSheet = ss.insertSheet('System_Log');
    logSheet.appendRow(['Timestamp', 'Level', 'Message', 'Details']);
    // logSheet.hideSheet();   // leave this off while testing
  }

  logSheet.appendRow([
    new Date(),
    level || 'INFO',
    message || '',
    details ? JSON.stringify(details) : ''
  ]);
}




// * combineDateAndTime

function combineDateAndTime_(dateValue, timeValue) {
  if (!dateValue || !timeValue) return null;

  const date = new Date(dateValue);
  if (isNaN(date.getTime())) return null;

  let hours;
  let minutes;

  if (timeValue instanceof Date) {
    hours = timeValue.getHours();
    minutes = timeValue.getMinutes();
  } else {
    const timeText = String(timeValue).trim();
    const match = timeText.match(/^(\d{1,2}):(\d{2})$/);
    if (!match) return null;

    hours = Number(match[1]);
    minutes = Number(match[2]);
  }

  const combined = new Date(date);
  combined.setHours(hours, minutes, 0, 0);
  return combined;
}
```

<hr style="height:4px; border-width:0; color:blue; background-color:blue" />

💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛
😄🧵💛👭 😁 💞 🖤 🍓 🌶 🚪 🔑 🛋 🫧 🌩 🌧 🧵 🪡 👗 👚 👜 👠 🩰 💄 💋 🎻 📒 ✂ 🩸 💧 🌸 🌺 🦩 — 
💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛💛




## Final-2026-04-24

### Code.gs

```javascipt
function doGet() {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Booking Request - Test App');
}



function submitBooking(formData) {
  const sheetName = CONFIG.SHEET_NAME;
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    throw new Error(`Sheet "${sheetName}" not found.`);
  }

  const requiredFields = [
    'fullName',
    'email',
    'courseName',
    'room',
    'eventDate',
    'startTime',
    'endTime',
    'recurring'
  ];

  for (const field of requiredFields) {
    if (!formData[field] || String(formData[field]).trim() === '') {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  if (formData.recurring === 'Yes') {
    if (!formData.frequency || !formData.repeatUntil) {
      throw new Error('Recurring bookings require Frequency and Repeat Until.');
    }
  }

  const start = parseTimeToMinutes(formData.startTime);
  const end = parseTimeToMinutes(formData.endTime);

  if (start % 30 !== 0 || end % 30 !== 0) {
    throw new Error('Times must be entered in 30-minute increments.');
  }

  if (end <= start) {
    throw new Error('End time must be later than start time.');
  }

  sheet.appendRow([
    new Date(),
    formData.fullName,
    formData.email,
    formData.courseName,
    formData.room,
    formData.eventDate,
    formData.startTime,
    formData.endTime,
    formData.recurring,
    formData.frequency || '',
    formData.repeatUntil || '',
    CONFIG.STATUS_VALUES.PENDING,
    '',
    ''
  ]);

  logAction_('INFO', 'Booking submitted', {
    fullName: formData.fullName,
    email: formData.email,
    courseName: formData.courseName,
    room: formData.room,
    eventDate: formData.eventDate,
    startTime: formData.startTime,
    endTime: formData.endTime,
    recurring: formData.recurring
  });

  return {
    success: true,
    message: 'Booking request submitted successfully.'
  };
}



function parseTimeToMinutes(timeStr) {
  const parts = String(timeStr).split(':');
  if (parts.length !== 2) {
    throw new Error(`Invalid time format: ${timeStr}`);
  }

  const hours = Number(parts[0]);
  const minutes = Number(parts[1]);

  if (
    Number.isNaN(hours) ||
    Number.isNaN(minutes) ||
    hours < 0 ||
    hours > 23 ||
    minutes < 0 ||
    minutes > 59
  ) {
    throw new Error(`Invalid time value: ${timeStr}`);
  }

  return hours * 60 + minutes;
}
```




---

### index.html

```html
<!DOCTYPE html>
<html>
  <head>
    <base target="_top">
    <style>
      body {
        font-family: Arial, sans-serif;
        margin: 0;
        padding: 24px;
        background: #f7f7f7;
      }

      .container {
        max-width: 850px;
        margin: 0 auto;
        background: white;
        padding: 24px;
        border-radius: 12px;
        box-shadow: 0 2px 10px rgba(0,0,0,0.08);
      }

      h1 {
        margin-top: 0;
        font-size: 1.6rem;
      }

      .grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 16px 20px;
      }

      .field {
        display: flex;
        flex-direction: column;
      }

      .field.full {
        grid-column: 1 / -1;
      }

      label {
        font-weight: 600;
        margin-bottom: 6px;
      }

      input,
      select {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
        background: white;
      }

      .actions {
        margin-top: 24px;
      }

      button {
        background: #1a73e8;
        color: white;
        border: none;
        padding: 12px 18px;
        border-radius: 8px;
        font-size: 14px;
        cursor: pointer;
      }

      button:hover {
        background: #155ec4;
      }

      .message {
        margin-top: 16px;
        padding: 12px;
        border-radius: 8px;
        display: none;
      }

      .message.success {
        background: #e6f4ea;
        color: #137333;
        display: block;
      }

      .message.error {
        background: #fce8e6;
        color: #c5221f;
        display: block;
      }

      .hidden {
        display: none;
      }

      @media (max-width: 700px) {
        .grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <div class="logo-wrap">
        <img src="https://celestesgrl.github.io/rcas/images/Logo-RCASsm.png" alt="Art Society logo" class="logo" style="width=150px;">
      </div>
      <h1>Booking Request - Testing</h1>
      <form id="bookingForm">
        <div class="grid">
          <div class="field">
            <label for="fullName">Full Name</label>
            <input type="text" id="fullName" name="fullName" required>
          </div>

          <div class="field">
            <label for="email">Email</label>
            <input type="email" id="email" name="email" required>
          </div>

          <div class="field full">
            <label for="courseName">Class Name</label>
            <input type="text" id="courseName" name="courseName" required>
          </div>

          <div class="field">
            <label for="room">Room</label>
            <select id="room" name="room" required>
              <option value="">Select a room</option>
              <option value="Studio">Studio</option>
              <option value="Gallery">Gallery</option>
            </select>
          </div>

          <div class="field">
            <label for="eventDate">Event Date</label>
            <input type="date" id="eventDate" name="eventDate" required>
          </div>

          <div class="field">
            <label for="startTime">Start Time</label>
            <input type="time" id="startTime" name="startTime" step="1800" required>
          </div>

          <div class="field">
            <label for="endTime">End Time</label>
            <input type="time" id="endTime" name="endTime" step="1800" required>
          </div>

          <div class="field">
            <label for="recurring">Recurring?</label>
            <select id="recurring" name="recurring" required>
              <option value="No" selected>No</option>
              <option value="Yes">Yes</option>
            </select>
          </div>

          <div class="field hidden" id="frequencyField">
            <label for="frequency">Frequency</label>
            <select id="frequency" name="frequency">
              <option value="">Select frequency</option>
              <option value="Weekly">Weekly</option>
              <option value="Fortnightly">Fortnightly</option>
            </select>
          </div>

          <div class="field hidden" id="repeatUntilField">
            <label for="repeatUntil">Repeat Until</label>
            <input type="date" id="repeatUntil" name="repeatUntil">
          </div>
        </div>

        <div class="actions">
          <button type="submit">Submit Booking Request</button>
        </div>

        <div id="message" class="message"></div>
      </form>
    </div>

    <script>
      document.addEventListener('DOMContentLoaded', function () {

        const form = document.getElementById('bookingForm');
        const messageBox = document.getElementById('message');
        const recurringSelect = document.getElementById('recurring');
        const frequencyField = document.getElementById('frequencyField');
        const repeatUntilField = document.getElementById('repeatUntilField');
        const frequencyInput = document.getElementById('frequency');
        const repeatUntilInput = document.getElementById('repeatUntil');
        const eventDateInput = document.getElementById('eventDate');

        function showMessage(text, type) {
          messageBox.textContent = text;
          messageBox.className = `message ${type}`;
        }

        function clearMessage() {
          messageBox.textContent = '';
          messageBox.className = 'message';
        }

        function timeToMinutes(timeStr) {
          const [hours, minutes] = timeStr.split(':').map(Number);
          return hours * 60 + minutes;
        }

        function setMinimumEventDate() {
          const today = new Date();
          const yyyy = today.getFullYear();
          const mm = String(today.getMonth() + 1).padStart(2, '0');
          const dd = String(today.getDate()).padStart(2, '0');

          eventDateInput.min = `${yyyy}-${mm}-${dd}`;
        }

        function toggleRecurringFields() {
          const isRecurring = recurringSelect.value === 'Yes';

          frequencyField.classList.toggle('hidden', !isRecurring);
          repeatUntilField.classList.toggle('hidden', !isRecurring);

          frequencyInput.required = isRecurring;
          repeatUntilInput.required = isRecurring;

          if (!isRecurring) {
            frequencyInput.value = '';
            repeatUntilInput.value = '';
          }
        }

        // Initialise UI state
        recurringSelect.addEventListener('change', toggleRecurringFields);
        toggleRecurringFields();
        setMinimumEventDate();

        form.addEventListener('submit', function (e) {
          e.preventDefault();
          clearMessage();

          const formData = {
            fullName: form.fullName.value.trim(),
            email: form.email.value.trim(),
            courseName: form.courseName.value.trim(),
            room: form.room.value,
            eventDate: form.eventDate.value,
            startTime: form.startTime.value,
            endTime: form.endTime.value,
            recurring: form.recurring.value,
            frequency: form.frequency.value,
            repeatUntil: form.repeatUntil.value
          };

          // Required fields
          if (
            !formData.fullName ||
            !formData.email ||
            !formData.courseName ||
            !formData.room ||
            !formData.eventDate ||
            !formData.startTime ||
            !formData.endTime ||
            !formData.recurring
          ) {
            showMessage('Please complete all required fields.', 'error');
            return;
          }

          // Prevent past dates
          const today = new Date();
          today.setHours(0, 0, 0, 0);

          const selectedDate = new Date(formData.eventDate + 'T00:00:00');

          if (selectedDate < today) {
            showMessage('Please choose today or a future date.', 'error');
            return;
          }

          // 30-minute increments
          if (
            timeToMinutes(formData.startTime) % 30 !== 0 ||
            timeToMinutes(formData.endTime) % 30 !== 0
          ) {
            showMessage('Please use 30-minute increments only.', 'error');
            return;
          }

          // End after start
          if (timeToMinutes(formData.endTime) <= timeToMinutes(formData.startTime)) {
            showMessage('End time must be later than start time.', 'error');
            return;
          }

          // Recurring validation
          if (formData.recurring === 'Yes') {
            if (!formData.frequency || !formData.repeatUntil) {
              showMessage('Please complete the recurring booking fields.', 'error');
              return;
            }

            if (formData.repeatUntil < formData.eventDate) {
              showMessage('Repeat Until must be on or after the Event Date.', 'error');
              return;
            }
          }

          // Submit to Apps Script
          google.script.run
            .withSuccessHandler(function (response) {
              showMessage(response.message, 'success');
              form.reset();
              toggleRecurringFields();
              setMinimumEventDate();
            })
            .withFailureHandler(function (error) {
              showMessage(error.message || 'Something went wrong.', 'error');
            })
            .submitBooking(formData);
        });

      });
    </script>
  </body>
</html>
```




### SheetFunct.gs

```javascript
// Central configuration object.
// Holds workbook names, allowed statuses, room names, calendar settings,
// and expected column headers. Other functions refer to CONFIG rather
// than hardcoding these values repeatedly.
const CONFIG = {
  CALENDAR_MODE: 'id', // 'default' or 'id'
  // NOTE: This ID is to a TEST calendar - change at GoLIVE
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'WebForm_Submissions',
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
    CALENDAR_EVENT_ID: 'Calendar Event ID',
    PROCESSING_NOTE: 'Processing Note',
    ASSIGNED_ROOM: 'Assigned Room',
  }
};


// * onApprovalEdit(e)

function onApprovalEdit(e) {
// Writes action to System_Log: every edit that reaches this
// trigger leaves a footprint in System_Log.
  logAction_('INFO', 'onApprovalEdit fired', {
    sheet: e && e.range ? e.range.getSheet().getName() : '',
    row: e && e.range ? e.range.getRow() : '',
    col: e && e.range ? e.range.getColumn() : '',
    value: e && e.value ? e.value : '',
    oldValue: e && e.oldValue ? e.oldValue : ''
  });

  // If there is no event object, or no edited range, stop here.
  if (!e || !e.range) return;

  // check that the edit happened on the actual submissions sheet:
  // WebForm_Submissions
  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  // ignore the header row. Row 1 contains column names, not bookings.
  const row = e.range.getRow();
  const col = e.range.getColumn();
  if (row < 2) return;

  // Instead of: “column 12=Status” or “column 15=Assigned Room,” 
  // look at the heading above the edited cell. If editing column O, 
  // the script looks up the header to find column type.
  const headerRow = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const editedHeader = String(headerRow[col - 1] || '').trim();

  // create map of column name: #
  const headers = getHeaders_(sheet);


  // Branching:
  // If the manager edited the Assigned Room column, don’t  
  // treat it as a status change. Send it to the assigned-room 
  // handler, because changing the room is not approving or cancelling.  
  if (editedHeader === CONFIG.HEADERS.ASSIGNED_ROOM) {
    handleAssignedRoomEdit_(e, sheet, row, headers);
    return;
  }

  // Find the Status column. If it does not exist, throw an error.
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  if (!statusCol) {
    throw new Error(`Missing header: ${CONFIG.HEADERS.STATUS}`);
  }

  // If the edited cell is in the Status column, do status logic.
  if (col === statusCol) {
    handleStatusEdit_(sheet, row, headers, e);
  }
}




function handleStatusEdit_(sheet, row, headers, e) {
  const newStatus = trim_(e.range.getValue());
  const oldStatus = trim_(e.oldValue);
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!noteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  // Ignore an empty status cell
  if (!newStatus) return;

  // Added to trap for someone deleting the dropdown and typing their own status
  const allowedStatuses = Object.values(CONFIG.STATUS_VALUES);
  if (!allowedStatuses.includes(newStatus)) {
    sheet.getRange(row, noteCol).setValue(`Unknown status: ${newStatus}`);
    return;
  }

  // change status to Approved, the script tries to create a calendar event.
  if (newStatus === CONFIG.STATUS_VALUES.APPROVED) {
    processApprovalRow_(sheet, row, headers);
    return;
  }

  // status becomes Cancelled, the script removes the live calendar event if 
  // one exists, clears the event ID, and updates the note.
  if (newStatus === CONFIG.STATUS_VALUES.CANCELLED) {
    processCancellationRow_(sheet, row, headers, oldStatus);
    return;
  }

  // If a pending booking is rejected, just write a note. But if an approved 
  // booking is changed to rejected, we must also remove the calendar event.
  if (newStatus === CONFIG.STATUS_VALUES.REJECTED) {
    if (oldStatus !== CONFIG.STATUS_VALUES.APPROVED) {
      sheet.getRange(row, noteCol).setValue('Booking rejected by manager.');
      return;
    }
    // fall through to safety net below
  } else if (newStatus === CONFIG.STATUS_VALUES.CONFLICT) {
    if (oldStatus !== CONFIG.STATUS_VALUES.APPROVED) {
      sheet.getRange(row, noteCol).setValue(
        'Booking marked as conflict. Review room/date/time before re-approval.'
      );
      return;
    }
    // Pending → Conflict: just write a note.
    // Approved → Conflict: remove the calendar event.
    // fall through to safety net below
  }

  // Safety net: any move away from Approved should remove the live event.
  if (
    oldStatus === CONFIG.STATUS_VALUES.APPROVED &&
    newStatus !== CONFIG.STATUS_VALUES.APPROVED
  ) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Status changed from Approved to ${newStatus}.`,
      newStatus
    );
  }
}


// * handleAssignedRoomEdit

function handleAssignedRoomEdit_(e, sheet, row, headers) {
  const oldValue = String(e.oldValue || '').trim();
  const newValue = String(e.value || '').trim();

  // If nothing materially changed, do nothing
  if (oldValue === newValue) return;

  // current status
  // requested room
  // processing note column
  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const status = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.STATUS));
  const requestedRoom = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.ROOM));
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];
  if (!noteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  const oldEffectiveRoom = normalizeRoom_(oldValue || requestedRoom);
  const newEffectiveRoom = normalizeRoom_(newValue || requestedRoom);

  const oldEffectiveRoomDisplay = oldEffectiveRoom || oldValue || requestedRoom || '(blank)';
  const newEffectiveRoomDisplay = newEffectiveRoom || newValue || requestedRoom || '(blank)';

  // If effective room did not actually change, do nothing
  if (oldEffectiveRoom === newEffectiveRoom) return;

  // If the booking is live, changing room invalidates approval and removes the event
  if (status === CONFIG.STATUS_VALUES.APPROVED) {
    removeLiveCalendarEvent_(
      sheet,
      row,
      headers,
      `Assigned Room changed from ${oldEffectiveRoomDisplay} to ${newEffectiveRoomDisplay}; approval invalidated and returned to Pending.`,
      CONFIG.STATUS_VALUES.PENDING
    );
    return;
  }

  // If the booking is currently in conflict, keep Conflict but update the note
  if (status === CONFIG.STATUS_VALUES.CONFLICT) {
    sheet.getRange(row, noteCol).setValue(
      `Assigned Room changed from ${oldEffectiveRoomDisplay} to ${newEffectiveRoomDisplay}. Re-approve to test availability for the new room.`
    );
    return;
  }

  // For Pending / Rejected / Cancelled, just note the room change
  sheet.getRange(row, noteCol).setValue(
    `Assigned Room updated from ${oldEffectiveRoomDisplay} to ${newEffectiveRoomDisplay}.`
  );
}





// * processApprovalRow

function processApprovalRow_(sheet, row, headers) {
  const calendar = getTargetCalendar_();
  if (!calendar) {
    throw new Error('Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.');
  }

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];

  const fullName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.FULL_NAME);
  const fnEmail = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EMAIL);
  const courseName = valueByHeader_(rowValues, headers, CONFIG.HEADERS.COURSE_NAME);
  const requestedRoom = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ROOM);
  const assignedRoom = valueByHeader_(rowValues, headers, CONFIG.HEADERS.ASSIGNED_ROOM);
  const effectiveRoomRaw = trim_(assignedRoom) || trim_(requestedRoom);
  const room = normalizeRoom_(effectiveRoomRaw);
  const bookingDate = valueByHeader_(rowValues, headers, CONFIG.HEADERS.EVENT_DATE);
  const startTime = valueByHeader_(rowValues, headers, CONFIG.HEADERS.START_TIME);
  const endTime = valueByHeader_(rowValues, headers, CONFIG.HEADERS.END_TIME);
  const recurring = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.RECURRING));
  const frequency = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.FREQUENCY));
  const repeatUntil = valueByHeader_(rowValues, headers, CONFIG.HEADERS.REPEAT_UNTIL);
  const existingEventId = trim_(valueByHeader_(rowValues, headers, CONFIG.HEADERS.CALENDAR_EVENT_ID));

  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const eventIdCol = headers[CONFIG.HEADERS.CALENDAR_EVENT_ID];
  const procNoteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!statusCol) throw new Error(`Missing header: ${CONFIG.HEADERS.STATUS}`);
  if (!eventIdCol) throw new Error(`Missing header: ${CONFIG.HEADERS.CALENDAR_EVENT_ID}`);
  if (!procNoteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  if (existingEventId) {
    sheet.getRange(row, procNoteCol).setValue('Already created; skipped duplicate approval.');
    return;
  }

  if (!room) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue(`Unknown room: ${effectiveRoomRaw}`);
    return;
  }

  if (!bookingDate || !startTime || !endTime) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('Missing date/time fields.');
    return;
  }

  const start = combineDateAndTime_(bookingDate, startTime);
  const end = combineDateAndTime_(bookingDate, endTime);

  if (
    !(start instanceof Date) || isNaN(start.getTime()) ||
    !(end instanceof Date) || isNaN(end.getTime())
  ) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('Invalid date/time values.');
    return;
  }

  const now = new Date();
  if (start < now) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('Booking start time is in the past.');
    return;
  }

  if (end <= start) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue('End time must be after start time.');
    return;
  }

  if (recurring === 'Yes') {
    if (!frequency || !repeatUntil) {
      sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
      sheet.getRange(row, procNoteCol).setValue(
        'Recurring booking is missing Frequency or Repeat Until.'
      );
      return;
    }

    if (repeatUntil < bookingDate) {
      sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
      sheet.getRange(row, procNoteCol).setValue(
        'Repeat Until must be on or after the Event Date.'
      );
      return;
    }
  }

  const sameRoomConflict = hasRoomConflict_(calendar, start, end, room);
  if (sameRoomConflict) {
    sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
    sheet.getRange(row, procNoteCol).setValue(
      `Conflict detected at approval time: ${room} is already booked.`
    );
    return;
  }

  const title = `${fullName || 'Tutor'} (${room})`;

  const descriptionLines = [
    `Full Name: ${fullName || ''}`,
    `Email: ${fnEmail || ''}`,
    `Room: ${room}`,
    `Course Name: ${courseName || ''}`,
    `Recurring: ${recurring || 'No'}`,
    `Frequency: ${frequency || ''}`,
    `Repeat Until: ${repeatUntil || ''}`
  ];

let eventId;
let noteMessage;

if (recurring === 'Yes') {

  const recurrence = buildRecurrence_(frequency, repeatUntil, bookingDate);

  const series = calendar.createEventSeries(title, start, end, recurrence, {
    location: room,
    description: descriptionLines.join('\n')
  });

  eventId = series.getId();
  noteMessage = `Recurring event series created successfully in ${room} until ${repeatUntil}.`;

} else {

  const event = calendar.createEvent(title, start, end, {
    location: room,
    description: descriptionLines.join('\n')
  });

  eventId = event.getId();
  noteMessage = `Calendar event created successfully in ${room}.`;
}

sheet.getRange(row, eventIdCol).setValue(eventId);
sheet.getRange(row, procNoteCol).setValue(noteMessage);

}




// * processCancellationRow

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



// ------------------------------------------------
// Helper Functions
// ------------------------------------------------

function hasRoomConflict_(calendar, start, end, room) {
  const overlapping = calendar.getEvents(start, end);

  return overlapping.some(event => {
    const eventRoom = normalizeRoom_(event.getLocation());
    return eventRoom === room;
  });
}







function normalizeRoom_(value) {
  const room = String(value || '').trim();

  if (!room) return '';

  const normalized = room.toLowerCase();

  if (normalized === 'studio') return 'Studio';
  if (normalized === 'gallery') return 'Gallery';

  return '';
}



// * removeLiveCalendarEvent

function removeLiveCalendarEvent_(sheet, row, headers, baseNote, newStatus) {
  const eventIdCol = headers[CONFIG.HEADERS.CALENDAR_EVENT_ID];
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!eventIdCol) throw new Error(`Missing header: ${CONFIG.HEADERS.CALENDAR_EVENT_ID}`);
  if (!noteCol) throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);

  const rowValues = sheet.getRange(row, 1, 1, sheet.getLastColumn()).getValues()[0];
  const existingEventId = trim_(
    valueByHeader_(rowValues, headers, CONFIG.HEADERS.CALENDAR_EVENT_ID)
  );

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
  }

  sheet.getRange(row, eventIdCol).clearContent();

  if (newStatus && statusCol) {
    const currentStatus = trim_(sheet.getRange(row, statusCol).getValue());
    if (currentStatus !== newStatus) {
      sheet.getRange(row, statusCol).setValue(newStatus);
    }
  }

  sheet.getRange(row, noteCol).setValue(`${baseNote} ${outcome}`.trim());
}



function getHeaders_(sheet) {
  const headerValues = sheet.getRange(1, 1, 1, sheet.getLastColumn()).getValues()[0];
  const headers = {};

  headerValues.forEach((name, i) => {
    const key = String(name).trim();
    if (!key) return;

    if (headers[key]) {
      throw new Error(`Duplicate header found: ${key}`);
    }

    headers[key] = i + 1;
  });

  return headers;
}



function valueByHeader_(rowValues, headers, headerName) {
  const col = headers[headerName];
  if (!col) return '';
  return col - 1 < rowValues.length ? rowValues[col - 1] : '';
}



function trim_(value) {
  return value == null ? '' : String(value).trim();
}



// * getTargetCalendar

function getTargetCalendar_() {
  if (CONFIG.CALENDAR_MODE === 'default') {
    return CalendarApp.getDefaultCalendar();
  }

  if (CONFIG.CALENDAR_MODE === 'id') {
    if (!CONFIG.CALENDAR_ID) {
      throw new Error('CONFIG.CALENDAR_ID is missing.');
    }
    return CalendarApp.getCalendarById(CONFIG.CALENDAR_ID);
  }

  throw new Error(`Invalid CALENDAR_MODE: ${CONFIG.CALENDAR_MODE}`);
}



// * setPendingOnFormSubmit(e)

function setPendingOnFormSubmit(e) {
  if (!e || !e.range) return;

  const sheet = e.range.getSheet();
  if (sheet.getName() !== CONFIG.SHEET_NAME) return;

  const row = e.range.getRow();
  if (row < 2) return;

  SpreadsheetApp.flush();

  const headers = getHeaders_(sheet);
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  if (!statusCol) {
    throw new Error(`Header '${CONFIG.HEADERS.STATUS}' not found.`);
  }

  const statusCell = sheet.getRange(row, statusCol);
  if (statusCell.isBlank()) {
    statusCell.setValue(CONFIG.STATUS_VALUES.PENDING);
  }
}



function logAction_(level, message, details) {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  let logSheet = ss.getSheetByName('System_Log');

  if (!logSheet) {
    logSheet = ss.insertSheet('System_Log');
    logSheet.appendRow(['Timestamp', 'Level', 'Message', 'Details']);
    // logSheet.hideSheet();   // leave this off while testing
  }

  logSheet.appendRow([
    new Date(),
    level || 'INFO',
    message || '',
    details ? JSON.stringify(details) : ''
  ]);
}




// * combineDateAndTime

function combineDateAndTime_(dateValue, timeValue) {
  if (!dateValue || !timeValue) return null;

  const date = new Date(dateValue);
  if (isNaN(date.getTime())) return null;

  let hours;
  let minutes;

  if (timeValue instanceof Date) {
    hours = timeValue.getHours();
    minutes = timeValue.getMinutes();
  } else {
    const timeText = String(timeValue).trim();
    const match = timeText.match(/^(\d{1,2}):(\d{2})$/);
    if (!match) return null;

    hours = Number(match[1]);
    minutes = Number(match[2]);
  }

  const combined = new Date(date);
  combined.setHours(hours, minutes, 0, 0);
  return combined;
}



// buildRecurrence

function buildRecurrence_(frequency, repeatUntil, startDate) {
  const recurrence = CalendarApp.newRecurrence();

  const untilDate = new Date(repeatUntil);

  if (frequency === 'Weekly') {
    recurrence.addWeeklyRule().until(untilDate);
  } else if (frequency === 'Fortnightly') {
    recurrence.addWeeklyRule().interval(2).until(untilDate);
  } else {
    throw new Error(`Unsupported frequency: ${frequency}`);
  }

  return recurrence;
}
```


<hr style="height:24px; border-width:0; color:blue; background-color:blue" />
