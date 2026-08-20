# Booking App v1.5 [TEST]

## Update
### 20.Aug.2026

<hr class="section-break strong" />



## Code.gs

```javascript
function doGet() {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Booking Request - ver1.4')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}


function submitBooking(formData) {
  const sheetName = CONFIG.SHEET_NAME;
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    throw new Error(`Sheet "${sheetName}" not found.`);
  }


  Logger.log('=== formData received ===');
  Logger.log(JSON.stringify(formData, null, 2));


  const requiredFields = [
    'tutorId',
    'courseName',
    'room',
    'eventDate',
    'startTime',
    'endTime',
  ];

  for (const field of requiredFields) {
    if (!formData[field] || String(formData[field]).trim() === '') {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  const tutor = findTutorById_(formData.tutorId);
  if (!tutor) {
    throw new Error(`Tutor not found: ${formData.tutorId}`);
  }
  
  const start = parseTimeToMinutes(formData.startTime);
  const end = parseTimeToMinutes(formData.endTime);

  if (start % 30 !== 0 || end % 30 !== 0) {
    throw new Error('Times must be entered in 30-minute increments.');
  }

  if (end <= start) {
    throw new Error('End time must be later than start time.');
  }


  const lock = LockService.getScriptLock();
  lock.waitLock(10000);

  try {
    // v1.4 diagnostic step:
    // inspect the booking, but do not yet alter its status
    const evaluation = evaluateBooking_(formData);

    Logger.log('=== booking evaluation ===');
    Logger.log(JSON.stringify(evaluation, null, 2));
    
    const row = sheet.getLastRow() + 1;
    const headers = getHeaders_(sheet);

    const procNoteCol =
      headers[CONFIG.HEADERS.PROCESSING_NOTE];

    if (!procNoteCol) {
      throw new Error(
        `Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`
      );
    }

    const [year, month, day] = formData.eventDate.split('-').map(Number);
    const eventDate = new Date(year, month - 1, day);

    const rowData = [
      new Date(),
      tutor.fullName,
      tutor.email,
      formData.courseName,
      formData.room,
      formData.eventDate,
      formData.startTime,
      formData.endTime,
      '', // Recurring
      '', // Frequency
      '', // Repeat Until
      evaluation.status,
      '',
      '',
      '',
      ''
    ];
    
    sheet.getRange(row, 1, 1, rowData.length).setValues([rowData]);
    sheet.getRange(row, procNoteCol).setValue(
      evaluation.processingNote
    );

    // v 1.4 write to calendar
    if (evaluation.status === CONFIG.STATUS_VALUES.APPROVED) {

      const calendar = getTargetCalendar_();

      const booking = {
        fullName: tutor.fullName,
        email: tutor.email,
        courseName: formData.courseName,
        room: evaluation.room,
        startDateTime: evaluation.startDateTime,
        endDateTime: evaluation.endDateTime
      };

      const event = createCalendarEvent_(
        calendar,
        booking
      );

      const eventId = event.getId();

      const eventIdCol =
        headers[CONFIG.HEADERS.CALENDAR_EVENT_ID];

      if (!eventIdCol) {
        throw new Error(
          `Missing header: ${CONFIG.HEADERS.CALENDAR_EVENT_ID}`
        );
    }
    sheet.getRange(row, eventIdCol).setValue(eventId);
    sheet.getRange(row, procNoteCol).setValue(
      `Automatically approved. Calendar event created in ${evaluation.room}.`
    );
  }

    // Assuming:
    // G = Start Time
    // H = End Time
    // L = Status
    // P = Billable Hours
    // Q = Hourly Rate
    // R = Total Fee

    sheet.getRange(row, 16).setFormula(
      `=IF(OR($L${row}<>"Approved",$G${row}="",$H${row}=""),"",($H${row}-$G${row})*24)`
    );

    sheet.getRange(row, 18).setFormula(
      `=IF(OR($P${row}="",$Q${row}=""),"",$P${row}*$Q${row})`
    );

  // email: formData.email,
  logAction_('INFO', 'Booking submitted', {
    tutorId: formData.tutorId,
    courseName: formData.courseName,
    room: formData.room,
    eventDate: formData.eventDate,
    startTime: formData.startTime,
    endTime: formData.endTime,
  });

  return {
    success: true,
    status: evaluation.status,
    message: evaluation.message
  };

  } finally {
    try {
      lock.releaseLock();
    } catch (err) {
      // Ignore release errors; lock may not have been acquired.
    }
  }
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

<hr class="section-break strong" />










## Index.html

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
    
      #reviewPanel {
        max-width: 650px;
      }

      .review-details {
        margin-top: 20px;
        padding: 16px;
        background: #f7f7f7;
        border-radius: 8px;
      }

      .review-details p {
        margin: 10px 0;
      }

      #reviewPanel .actions {
        display: flex;
        gap: 12px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Booking Request - ver 1.4</h1>
      <form id="bookingForm">
        <div class="grid">

          <!-- Tutor selection -->
          <div class="field">
            <label for="tutorId">Tutor</label>
            <select
              id="tutorId"
              name="tutorId"
              required
            >
              <option value="">Select your name...</option>
            </select>
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
        </div>

        <div class="actions">
          <button type="submit">Review Booking</button>
        </div>

        <div id="message" class="message"></div>
      </form>


      <div id="reviewPanel" class="hidden">
        <h2>Review Booking</h2>

        <div class="review-details">
          <p>
            <strong>Tutor:</strong>
            <span id="reviewTutor"></span>
          </p>

          <p>
            <strong>Class:</strong>
            <span id="reviewCourseName"></span>
          </p>

          <p>
            <strong>Room:</strong>
            <span id="reviewRoom"></span>
          </p>

          <p>
            <strong>Date:</strong>
            <span id="reviewEventDate"></span>
          </p>

          <p>
            <strong>Time:</strong>
            <span id="reviewTime"></span>
          </p>

        </div>

        <div class="actions">
          <button type="button" id="backButton">
            Back to Edit
          </button>

          <button type="button" id="confirmButton">
            Confirm Booking
          </button>
        </div>
      </div>
    </div>

<script>
  document.addEventListener('DOMContentLoaded', function () {

    // ==================================================
    // Static Data
    // ==================================================

    // const tutors = []
    // moved to Tutors.gs


    // ==================================================
    // Element References
    // ==================================================

    const form = document.getElementById('bookingForm');
    const messageBox = document.getElementById('message');

    const eventDateInput = document.getElementById('eventDate');

    const reviewPanel = document.getElementById('reviewPanel');

    const reviewTutor = document.getElementById('reviewTutor');
    const reviewCourseName = document.getElementById('reviewCourseName');
    const reviewRoom = document.getElementById('reviewRoom');
    const reviewEventDate = document.getElementById('reviewEventDate');
    const reviewTime = document.getElementById('reviewTime');

    const backButton = document.getElementById('backButton');
    const confirmButton = document.getElementById('confirmButton');

    let currentBooking = null;


    // ==================================================
    // Message Functions
    // ==================================================

    function showMessage(text, type) {
      messageBox.textContent = text;
      messageBox.className = `message ${type}`;
    }

    function clearMessage() {
      messageBox.textContent = '';
      messageBox.className = 'message';
    }


    // ==================================================
    // Utility Functions
    // ==================================================

    function timeToMinutes(timeStr) {
      const [hours, minutes] = timeStr.split(':').map(Number);

      return hours * 60 + minutes;
    }


    // ==================================================
    // Date Functions
    // ==================================================

    function setMinimumEventDate() {
      const today = new Date();

      const yyyy = today.getFullYear();
      const mm = String(today.getMonth() + 1).padStart(2, '0');
      const dd = String(today.getDate()).padStart(2, '0');

      eventDateInput.min = `${yyyy}-${mm}-${dd}`;
    }


    // ==================================================
    // Form Display Functions
    // ==================================================


    // -------------------------------------------------
    // Review Panel
    // -------------------------------------------------

    function populateReviewPanel(formData) {
      const tutorSelect = document.getElementById('tutorId');

      const selectedTutorName = tutorSelect.options[tutorSelect.selectedIndex].text;

      reviewTutor.textContent = selectedTutorName;
      reviewCourseName.textContent = formData.courseName;
      reviewRoom.textContent = formData.room;
      reviewEventDate.textContent = formData.eventDate;

      reviewTime.textContent = `${formData.startTime} - ${formData.endTime}`;
    }


    // -------------------------------------------------
    // Show Review Panel
    // -------------------------------------------------

    function showReviewPanel(formData) {
      populateReviewPanel(formData);

      form.classList.add('hidden');
      reviewPanel.classList.remove('hidden');
    }

    // ==================================================
    // Tutor Functions
    // ==================================================

    function populateTutorDropdown() {
      google.script.run
        .withSuccessHandler(function (tutors) {

          const tutorSelect = document.getElementById('tutorId');

          tutors.forEach(function (tutor) {

            const option =
              document.createElement('option');

            option.value = tutor.tutorId;
            option.textContent = tutor.fullName;

            tutorSelect.appendChild(option);

          });

        })
        .getTutors();
    }


    // ==================================================
    // Initialisation
    // ==================================================

    // populate controls
    populateTutorDropdown();

    //set initial UI state
    setMinimumEventDate();


    // ==================================================
    // Form Submission
    // ==================================================

    form.addEventListener('submit', function (e) {
      e.preventDefault();
      clearMessage();


      // --------------------------------------------------
      // Collect Form Data
      // --------------------------------------------------

      const formData = {
        tutorId: form.tutorId.value,
        courseName: form.courseName.value.trim(),
        room: form.room.value,
        eventDate: form.eventDate.value,
        startTime: form.startTime.value,
        endTime: form.endTime.value
       };

      // console.log(formData);
      // debugger;


      // --------------------------------------------------
      // Required Field Validation
      // --------------------------------------------------

      if (
        !formData.tutorId ||
        !formData.courseName ||
        !formData.room ||
        !formData.eventDate ||
        !formData.startTime ||
        !formData.endTime
      ) {
        showMessage('Please complete all required fields.', 'error');
        return;
      }


      // --------------------------------------------------
      // Date Validation
      // --------------------------------------------------

      const today = new Date();
      today.setHours(0, 0, 0, 0);

      const selectedDate = new Date(
        formData.eventDate + 'T00:00:00'
      );

      if (selectedDate < today) {
        showMessage(
          'Please choose today or a future date.',
          'error'
        );

        return;
      }


      // --------------------------------------------------
      // Time Validation
      // --------------------------------------------------

      if (
        timeToMinutes(formData.startTime) % 30 !== 0 ||
        timeToMinutes(formData.endTime) % 30 !== 0
      ) {
        showMessage(
          'Please use 30-minute increments only.',
          'error'
        );

        return;
      }

      if (
        timeToMinutes(formData.endTime) <=
        timeToMinutes(formData.startTime)
      ) {
        showMessage(
          'End time must be later than start time.',
          'error'
        );

        return;
      }



      // --------------------------------------------------
      // Was: SubmitToAppsScript, now: Show Review Panel
      // --------------------------------------------------
      // --------------------------------------------------
      // Show Review Panel
      // --------------------------------------------------

      currentBooking = formData;
      showReviewPanel(currentBooking);

    }); // closes form submit handler


    // --------------------------------------------------
    // Back to Edit
    // --------------------------------------------------

    backButton.addEventListener('click', function () {
      reviewPanel.classList.add('hidden');
      form.classList.remove('hidden');
    });


    // --------------------------------------------------
    // Confirm Booking
    // --------------------------------------------------

    confirmButton.addEventListener('click', function () {
      if (!currentBooking) {
        return;
      }

      confirmButton.disabled = true;
      confirmButton.textContent = 'Submitting...';

      google.script.run
        .withSuccessHandler(function (response) {
          currentBooking = null;

          reviewPanel.classList.add('hidden');
          form.classList.remove('hidden');

          form.reset();
          setMinimumEventDate();

          confirmButton.disabled = false;
          confirmButton.textContent = 'Confirm Booking';

          showMessage(response.message, 'success');
          setTimeout(function () {clearMessage();}, 5000);
        })

        .withFailureHandler(function (error) {
          confirmButton.disabled = false;
          confirmButton.textContent = 'Confirm Booking';

          reviewPanel.classList.add('hidden');
          form.classList.remove('hidden');

          showMessage(
            error.message || 'Something went wrong.',
            'error'
          );
        })
        .submitBooking(currentBooking);
    });

  }); // closes DOMContentLoaded handler

</script>
</body>
</html>
```
<hr class="section-break strong" />











## SheetFunct.gs


```javascript
const CONFIG = {
  CALENDAR_MODE: 'id', // 'default' or 'id'
  // NOTE: This ID was to a TEST calendar - changed at GoLIVE 18.08.2026
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'WebForm_Submissions',
  TUTORS_SHEET_NAME: 'Tutors',
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
    approveBooking_(sheet, row, headers);
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





// * approveBooking

function approveBooking_(sheet, row, headers) {

  const lock = LockService.getScriptLock();
  lock.waitLock(30000);

  try {
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

    const conflict = findRoomConflict_(calendar, room, start, end);
    if (conflict) {
      sheet.getRange(row, statusCol).setValue(CONFIG.STATUS_VALUES.CONFLICT);
      sheet.getRange(row, procNoteCol).setValue(
        `Conflict detected at approval time: ${room} is already booked.`
      );
      return;
    }

    const booking = {
      fullName: fullName,
      email: fnEmail,
      courseName: courseName,
      room: room,
      startDateTime: start,
      endDateTime: end
    };

    const event = createCalendarEvent_(
      calendar,
      booking
    );

    const eventId = event.getId();
    const noteMessage =
      `Calendar event created successfully in ${room}.`;

    sheet.getRange(row, eventIdCol).setValue(eventId);
    sheet.getRange(row, procNoteCol).setValue(noteMessage);

  } finally {
    lock.releaseLock();
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


// ===================================================
// Test Functions: Duplicate Approval
// ===================================================

function testDuplicateApproval() {
  const sheet = SpreadsheetApp
    .getActiveSpreadsheet()
    .getSheetByName(CONFIG.SHEET_NAME);

  const headers = getHeaders_(sheet);

  approveBooking_(sheet, 28, headers);
}
```

<hr class="section-break strong" />






## Tutors.gs

**Left in for testing purposes**

```javascript
const TUTORS = [
  {
    id: "celeste",
    name: "Celeste Shelley",
    email: "celeste@wardrobe.org.au",
    phone: "0400 111 111"
  },
  {
    id: "charlotte",
    name: "Charlotte Rossignol",
    email: "charlotte@wardrobe.org.au",
    phone: "0400 111 112"
  },
  {
    id: "sarah",
    name: "Sarah St Michaels",
    email: "sarah@wardrobe.org.au",
    phone: "0400 111 113"
  },
  {
    id: "brittany",
    name: "Brittany Finlayson",
    email: "brittany@wardrobe2.org.au",
    phone: "0400 111 114"
  },
  {
    id: "harriet",
    name: "Harriet Maleny",
    email: "harriet@wardrobe2.org.au",
    phone: "0400 111 115"
  },
  {
    id: "mara",
    name: "Mara Tallbanks",
    email: "mara@wardrobe.org.au",
    phone: "0400 111 116"
  },
  {
    id: "lisa",
    name: "Lisa Intern",
    email: "lisa@wardrobe2.org.au",
    phone: "0400 111 117"
  },
  {
    id: "ellie",
    name: "Ellen Montville",
    email: "ellie@wardrobe2.org.au",
    phone: "0400 111 118"
  },
  {
    id: "lucy",
    name: "Lucy Tester",
    email: "lucy@wardrobe.org.au",
    phone: "0400 111 119"
  },
  {
    id: "lauren",
    name: "Lauren Rossignol",
    email: "lauren@wardrobe.org.au",
    phone: "0400 111 120"
  },
];


// to be called by Index.html via google.script.run
function getTutors() {
  return TUTORS;
}



function findTutorById_(tutorId) { 
  return TUTORS.find(function (tutor) { 
    return tutor.id === tutorId; 
  }); 
}
```
<hr class="section-break strong" />







## BookingLogic.gs

```javascript
// ==========================================================
// *             evaluateBooking_()
// ==========================================================

function evaluateBooking_(formData) {
  const calendar = getTargetCalendar_();

  if (!calendar) {
    throw new Error(
      'Calendar not found. Check CALENDAR_MODE / CALENDAR_ID.'
    );
  }

  const room = normalizeRoom_(formData.room);

  if (!room) {
    throw new Error(`Unknown room: ${formData.room}`);
  }

  const startDateTime = combineDateAndTime_(
    formData.eventDate,
    formData.startTime
  );

  const endDateTime = combineDateAndTime_(
    formData.eventDate,
    formData.endTime
  );

  if (
    !(startDateTime instanceof Date) ||
    isNaN(startDateTime.getTime()) ||
    !(endDateTime instanceof Date) ||
    isNaN(endDateTime.getTime())
  ) {
    throw new Error('Invalid booking date or time.');
  }

  const conflict = findRoomConflict_(
  calendar,
  room,
  startDateTime,
  endDateTime
  );

  const result = {
    room: room,
    startDateTime: startDateTime,
    endDateTime: endDateTime,

    conflictDetected: Boolean(conflict),

    conflictTitle: conflict ? conflict.getTitle() : '',
    conflictStart: conflict ? conflict.getStartTime() : null,
    conflictEnd: conflict ? conflict.getEndTime() : null,

    status: conflict
      ? CONFIG.STATUS_VALUES.PENDING
      : CONFIG.STATUS_VALUES.APPROVED,

    message: conflict
      ? 'Your booking has been recorded for review because the room may already be booked.'
      : 'Your booking has been approved.',
  
    processingNote: conflict
      ? buildConflictNote_(conflict, room)
      : `Automatically approved. for ${room}.`
  
  };

  logAction_(
    'INFO',
    'Submission conflict check',
    {
      room: result.room,
      startDateTime: result.startDateTime,
      endDateTime: result.endDateTime,
      conflictDetected: result.conflictDetected,
      conflictTitle: result.conflictTitle,
      conflictStart: result.conflictStart,
      conflictEnd: result.conflictEnd
    }
  );

  return result;
}



// ==========================================================
// *              findRoomConflict_()
// ==========================================================

function findRoomConflict_(calendar, room, startDateTime, endDateTime) {
  const overlappingEvents = calendar.getEvents(startDateTime, endDateTime);

  for (const event of overlappingEvents) {
    const eventRoom = normalizeRoom_(event.getLocation())
    
    if (eventRoom === room) {
      return event;
    }
  }
  
  /// else
  return null;
}




// ==========================================================
// *             createCalendarEvent_()
// ==========================================================

function createCalendarEvent_(calendar, booking) {
  const title = `${booking.courseName} (${booking.room})`;

  const descriptionLines = [
    `Full Name: ${booking.fullName || ''}`,
    `Email: ${booking.email || ''}`,
    `Room: ${booking.room}`,
    `Course Name: ${booking.courseName || ''}`
  ];

  return calendar.createEvent(title, booking.startDateTime, booking.endDateTime, {
      location: booking.room,
      description: descriptionLines.join('\n')
    }
  );
}



// ==========================================================
// *             buildConflictNote_()
// ==========================================================


function buildConflictNote_(conflict, room) {
  return `Conflict detected: ${room} is already booked by "${conflict.getTitle()}".`;
}






// ==========================================================
// *             Unused Function Stubs
// ==========================================================


function writeBookingRow_() {

}



// ====

function validateBooking_() {

}
```

<hr class="section-break strong" />
