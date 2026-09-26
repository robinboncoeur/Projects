# Booking App v1.5 [TEST]

## Update
### 27.Sep.2026

<hr class="section-break strong" />




## Update Note

**v1.5 — Alpha testing baseline, 27 Sep 2026**

* Simplified booking lifecycle to Approved / Rejected / Cancelled.  
* Removed Pending, Conflict status, Assigned Room and manual approval workflow.   
* Conflict detection retained as rejection logic.   
* Cancellation removes linked calendar event and releases booking time.   
* Tutor website links added. Header-based submission/accounting fields retained.   
* Tested creation, cancellation/rebooking and conflicting-booking rejection.   
* Web app deployed for external tutor testing and embedded in password-protected RCAS Tutor Booking Platform.

---

### Left to do

1. Preserve the frozen TEST version first. Keep today's known-good v1.5 code/workbook as the historical alpha baseline. Don't turn the only copy into LIVE.  
2. Create/copy the production workbook into the proper RCAS Google Drive working folder. That gives the LIVE system its permanent home before we wire anything to it.  
3. Remove TESTING labels/test data from the production copy. That includes the visible Booking Request - ver 1.5 - TESTING heading and whatever TEST identification exists in the sheet/workbook. I'd keep the actual version number somewhere unobtrusive; it's useful provenance.  
4. Point the production code at the LIVE RCAS calendar. In particular, verify CONFIG.CALENDAR_ID rather than merely assuming the copied code is pointing at the right calendar. This is the moment when mistakes start affecting real bookings.  
5. Confirm the production workbook's installed triggers. We now know exactly what we require: the spreadsheet On edit trigger calling onApprovalEdit. And importantly, there should be no resurrected form-submit/Pending trigger.  
6. Check permissions/ownership from the production location. RCAS account owns/has the necessary access to the workbook and LIVE calendar; tutors do not require workbook access.  
7. Update the existing web-app deployment to the production code. As you say, editing the deployment means the /exec URL remains the same — excellent, because the Squarespace iframe doesn't then need another URL change. Keep Execute as RCAS and Who has access: Anyone, because we've established that's required for the iframe.  
8. Run one controlled LIVE smoke test. Make a clearly identifiable short test booking in an otherwise free future slot; confirm sheet row → Approved → LIVE calendar event → Event ID. Then change it to Cancelled and confirm calendar deletion/Event ID clearing. After that, the production lifecycle has been tested once against the actual production resources.  

**Then I'd call v1.5 LIVE.**

And after today's adventures, I would absolutely write a tiny release-history entry:  
**v1.5 LIVE — [date] — production workbook, LIVE calendar, production trigger verified, /exec deployment updated, smoke test passed.**

Then if somebody else inherits it, there is a clean boundary between Alpha-tested v1.5 and Production v1.5.

<hr class="section-break strong" />






## Code.gs

```javascript
function doGet() {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Booking Request - ver1.5 - TESTING')
    .setXFrameOptionsMode(HtmlService.XFrameOptionsMode.ALLOWALL);
}



// ================================================
// submit Booking
// ================================================

function submitBooking(formData) {
  const sheetName = CONFIG.SHEET_NAME;
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    throw new Error(`Sheet "${sheetName}" not found.`);
  }

// --- logger
  Logger.log('=== formData received ===');
  Logger.log(JSON.stringify(formData, null, 2));
// --- logger

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

  // ------------------------------------------------
  // v1.5 validation

  const priceType = String(formData.priceType || '').trim().toLowerCase();

  if (!['paid', 'free'].includes(priceType)) {
    throw new Error('Price must be either Paid or Free.');
  }

  // ------------------------------------------------
  // v1.5 pricing
  
  if (priceType === 'free') {

    // Free bookings must not carry price values.
    formData.membersPrice = '';
    formData.nonMembersPrice = '';

  } else {

    const membersPriceText =
      String(formData.membersPrice || '').trim();

    const nonMembersPriceText =
      String(formData.nonMembersPrice || '').trim();

    if (!membersPriceText) {
      throw new Error(
        'Members Price is required for a paid event.'
      );
    }

    if (!nonMembersPriceText) {
      throw new Error(
        'Non-Members Price is required for a paid event.'
      );
    }

    const membersPrice =
      Number(membersPriceText);

    const nonMembersPrice =
      Number(nonMembersPriceText);

    if (
      !Number.isFinite(membersPrice) ||
      membersPrice < 0
    ) {
      throw new Error(
        'Members Price must be zero or greater.'
      );
    }

    if (
      !Number.isFinite(nonMembersPrice) ||
      nonMembersPrice < 0
    ) {
      throw new Error(
        'Non-Members Price must be zero or greater.'
      );
    }

    // Store validated numeric values rather than
    // arbitrary strings received from the browser.
    formData.membersPrice = membersPrice;
    formData.nonMembersPrice = nonMembersPrice;
  }


  // ------------------------------------------------
  // v1.5 skill level

  const allowedSkillLevels = [
    'Beginner',
    'Intermediate',
    'Advanced',
    'All Levels'
  ];

  const skillLevel =
    String(formData.skillLevel || '').trim();

  if (!allowedSkillLevels.includes(skillLevel)) {
    throw new Error(
      'Please select a valid Skill Level.'
    );
}

formData.priceType = priceType;
formData.skillLevel = skillLevel;

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

    // ------------------------------------------------
    //   v1.5 Build booking row by header name

    const rowData = new Array(sheet.getLastColumn()).fill('');

    function setRowValue_(headerName, value) {
      const col = headers[headerName];

      if (!col) {
        throw new Error(`Missing header: ${headerName}`);
      }
      rowData[col - 1] = value;
    }

    setRowValue_(CONFIG.HEADERS.TIMESTAMP, new Date());
    setRowValue_(CONFIG.HEADERS.FULL_NAME, tutor.fullName);
    setRowValue_(CONFIG.HEADERS.EMAIL, tutor.email);
    setRowValue_(CONFIG.HEADERS.COURSE_NAME, formData.courseName);
    setRowValue_(CONFIG.HEADERS.LOCATION, evaluation.location);
    setRowValue_(CONFIG.HEADERS.EVENT_DATE, formData.eventDate);
    setRowValue_(CONFIG.HEADERS.START_TIME, formData.startTime);
    setRowValue_(CONFIG.HEADERS.END_TIME, formData.endTime);
    setRowValue_(CONFIG.HEADERS.PRICE_TYPE, formData.priceType);
    setRowValue_(CONFIG.HEADERS.MEMBERS_PRICE, formData.membersPrice);
    setRowValue_(CONFIG.HEADERS.NON_MEMBERS_PRICE, formData.nonMembersPrice);
    setRowValue_(CONFIG.HEADERS.SKILL_LEVEL, formData.skillLevel);
    setRowValue_(CONFIG.HEADERS.OTHER_DETAILS, formData.otherDetails);
    setRowValue_(CONFIG.HEADERS.STATUS, evaluation.status);
    setRowValue_(CONFIG.HEADERS.PROCESSING_NOTE, evaluation.processingNote);

    sheet
      .getRange(row, 1, 1, rowData.length)
      .setValues([rowData]);


    // ------------------------------------------------
    // v 1.4 write to calendar

    if (evaluation.status === CONFIG.STATUS_VALUES.APPROVED) {

      const calendar = getTargetCalendar_();

      const booking = {
        fullName: tutor.fullName,
        email: tutor.email,
        courseName: formData.courseName,
        location: evaluation.location,
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
      `Approved. Calendar event created in ${evaluation.location}.`
    );
  }

  // ------------------------------------------------
  //    v1.5 Accounting formulas

  const startTimeCol = headers[CONFIG.HEADERS.START_TIME];
  const endTimeCol = headers[CONFIG.HEADERS.END_TIME];
  const statusCol = headers[CONFIG.HEADERS.STATUS];
  const billableHoursCol = headers[CONFIG.HEADERS.BILLABLE_HOURS];
  const hourlyRateCol = headers[CONFIG.HEADERS.HOURLY_RATE];
  const totalFeeCol = headers[CONFIG.HEADERS.TOTAL_FEE];

  if (
    !startTimeCol ||
    !endTimeCol ||
    !statusCol ||
    !billableHoursCol ||
    !hourlyRateCol ||
    !totalFeeCol
  ) {
    throw new Error(
      'One or more accounting headers are missing.'
    );
  }

  const startTimeA1 = sheet.getRange(row, startTimeCol).getA1Notation();
  const endTimeA1 = sheet.getRange(row, endTimeCol).getA1Notation();
  const statusA1 = sheet.getRange(row, statusCol).getA1Notation();
  const billableHoursA1 = sheet.getRange(row, billableHoursCol).getA1Notation();
  const hourlyRateA1 = sheet.getRange(row, hourlyRateCol).getA1Notation();

  sheet
    .getRange(row, billableHoursCol)
    .setFormula(
      `=IF(OR(${statusA1}<>"Approved",` +
      `${startTimeA1}="",${endTimeA1}=""),"",` +
      `(${endTimeA1}-${startTimeA1})*24)`
    );

  sheet
    .getRange(row, totalFeeCol)
    .setFormula(
      `=IF(OR(${billableHoursA1}="",` +
      `${hourlyRateA1}=""),"",` +
      `${billableHoursA1}*${hourlyRateA1})`
    );


  logAction_('INFO', 'Booking submitted', {
    tutorId: formData.tutorId,
    courseName: formData.courseName,
    location: evaluation.location,
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

      .time-row {
        display: flex;
        align-items: center;
        gap: 10px;
      }

      .time-row input {
        flex: 1;
        min-width: 0;
      }

      .radio-row {
        display: flex;
        align-items: center;
        gap: 24px;
      }

      .radio-option {
        display: flex;
        flex-direction: row;
        align-items: center;
        gap: 6px;
        font-weight: normal;
        margin-bottom: 0;
      }

      .required {
        color: #c5221f;
      }
    
      .required-note {
        margin-top: -8px;
        margin-bottom: 20px;
        font-size: 13px;
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Booking Request - ver 1.5 - TESTING</h1>

      <p class="required-note"><span class="required">*</span> Required</p>
      
      <form id="bookingForm">
        <div class="grid">

          <!-- Tutor selection -->
          <div class="field">
            <label for="tutorId">
              Tutor <span class="required">*</span>
            </label>
            <select
              id="tutorId"
              name="tutorId"
              required
            >
              <option value="">Select your name...</option>
            </select>
          </div>

          <!-- Tutor Website -->
          <div class="field full">
            <div id="furtherDetails"></div>
          </div>

          <!-- Event Title -->
          <div class="field full">
            <label for="courseName">
              Event Title<span class="required">*</span>
            </label>
            <input
              type="text"
              id="courseName"
              name="courseName"
              required
            >
          </div>

          <!-- Event Date -->
          <div class="field">
            <label for="eventDate">
              Date<span class="required">*</span>
            </label>
            <input
              type="date"
              id="eventDate"
              name="eventDate"
              required
            >
          </div>

          <!-- Class Time -->
          <div class="field">
            <label>
              Class Time<span class="required">*</span>
            </label>

            <div class="time-row">
              <input
                type="time"
                id="startTime"
                name="startTime"
                step="1800"
                required
                aria-label="Start Time"
              >
              <span>to</span>
              <input
                type="time"
                id="endTime"
                name="endTime"
                step="1800"
                required
                aria-label="End Time"
              >
            </div>
          </div>

          <!-- Location -->
          <div class="field">
            <label for="room">
              Location<span class="required">*</span>
            </label>
            <select
              id="room"
              name="room"
              required
            >
              <option value="">Select a location...</option>
              <option value="Studio">Studio</option>
              <option value="Gallery">Gallery</option>
              <option value="Other">Other</option>
            </select>
          </div>

          <!-- Other Location -->
          <div class="field">
            <label for="otherLocation">Other Location</label>
            <input
              type="text"
              id="otherLocation"
              name="otherLocation"
              placeholder="Venue Name, Street Address, Suburb"
            >
          </div>

          <!-- Pricing -->
          <div class="field full">
            <label>
              Price<span class="required">*</span>
            </label>

            <div class="radio-row">
              <label class="radio-option">
                <input
                  type="radio"
                  name="priceType"
                  value="paid"
                  checked
                >
                Paid
              </label>

              <label class="radio-option">
                <input
                  type="radio"
                  name="priceType"
                  value="free"
                >
                Free
              </label>
            </div>
          </div>

          <!-- Members Price -->
          <div class="field">
            <label for="membersPrice">Members Price</label>
            <input
              type="number"
              id="membersPrice"
              name="membersPrice"
              min="0"
              step="0.01"
              placeholder="$"
            >
          </div>

          <!-- Non-Members Price -->
          <div class="field">
            <label for="nonMembersPrice">Non-Members Price</label>
            <input
              type="number"
              id="nonMembersPrice"
              name="nonMembersPrice"
              min="0"
              step="0.01"
              placeholder="$"
            >
          </div>

          <!-- Skill Level -->
          <div class="field">
            <label for="skillLevel">
              Skill Level<span class="required">*</span>
            </label>
            <select
              id="skillLevel"
              name="skillLevel"
              required
            >
              <option value="">Select skill level...</option>
              <option value="Beginner">Beginner</option>
              <option value="Intermediate">Intermediate</option>
              <option value="Advanced">Advanced</option>
              <option value="All Levels">All Levels</option>
            </select>
          </div>

          <!-- Other -->
          <div class="field full">
            <label for="otherDetails">Other</label>
            <input
              type="text"
              id="otherDetails"
              name="otherDetails"
            >
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
            <strong>Location:</strong>
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

          <p>
            <strong>Price:</strong>
            <span id="reviewPrice"></span>
          </p>

          <p>
            <strong>Skill Level:</strong>
            <span id="reviewSkillLevel"></span>
          </p>

          <p>
            <strong>Other:</strong>
            <span id="reviewOtherDetails"></span>
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
    // const reviewLocation = document.getElementById('reviewLocation');

    const reviewPrice = document.getElementById('reviewPrice');
    const reviewSkillLevel = document.getElementById('reviewSkillLevel');
    const reviewOtherDetails = document.getElementById('reviewOtherDetails');

    const backButton = document.getElementById('backButton');
    const confirmButton = document.getElementById('confirmButton');

    // ver 1.5
    const priceTypeInputs = document.querySelectorAll('input[name="priceType"]');
    const membersPriceInput = document.getElementById('membersPrice');
    const nonMembersPriceInput = document.getElementById('nonMembersPrice');

    const roomSelect = document.getElementById('room');
    const otherLocationInput = document.getElementById('otherLocation');

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

      const selectedTutorName =
        tutorSelect.options[tutorSelect.selectedIndex].text;

      reviewTutor.textContent = selectedTutorName;
      reviewCourseName.textContent = formData.courseName;
      reviewRoom.textContent =
        formData.room === 'Other'
          ? formData.otherLocation
          : formData.room;
      reviewEventDate.textContent = formData.eventDate;

        // ver 1.5
      const [year, month, day] = formData.eventDate.split('-').map(Number);
      const displayDate = new Date(year, month - 1, day).toLocaleDateString(
          'en-AU',
          {
            weekday: 'long',
            day: 'numeric',
            month: 'long',
            year: 'numeric'
          }
        );
      reviewEventDate.textContent = displayDate;

      reviewTime.textContent =
        `${formData.startTime} - ${formData.endTime}`;

      // v1.5 location
      // reviewLocation.textContent =
      //  formData.room === 'Other'
      //    ? formData.otherLocation
      //    : formData.room;

      // v1.5 pricing
      if (formData.priceType === 'free') {
        reviewPrice.textContent = 'Free';
      } else {
        reviewPrice.textContent =
          `Members: $${formData.membersPrice || '0.00'} | ` +
          `Non-members: $${formData.nonMembersPrice || '0.00'}`;
      }

      reviewSkillLevel.textContent =
        formData.skillLevel;

      reviewOtherDetails.textContent =
        formData.otherDetails || '—';
    }



    // -------------------------------------------------
    // Show Review Panel
    // -------------------------------------------------

    function showReviewPanel(formData) {
      populateReviewPanel(formData);

      form.classList.add('hidden');
      reviewPanel.classList.remove('hidden');
    }


    // -------------------------------------------------
    // v1.5 Update Price Fields
    // -------------------------------------------------

    function updatePriceFields() {
      const selectedPriceType =
        document.querySelector(
          'input[name="priceType"]:checked'
        ).value;

      const isFree = selectedPriceType === 'free';

      membersPriceInput.disabled = isFree;
      nonMembersPriceInput.disabled = isFree;

      membersPriceInput.required = !isFree;
      nonMembersPriceInput.required = !isFree;

      if (isFree) {
        membersPriceInput.value = '';
        nonMembersPriceInput.value = '';
      }
    }



    // -------------------------------------------------
    // v1.5 Update Other Location Field
    // -------------------------------------------------

    function updateOtherLocationField() {
      const isOther = roomSelect.value === 'Other';

      otherLocationInput.disabled = !isOther;
      otherLocationInput.required = isOther;

      if (!isOther) {
        otherLocationInput.value = '';
      }
    }




// ==================================================
// Tutor Functions
// ==================================================

function populateTutorDropdown() {
  google.script.run
    .withSuccessHandler(function (tutors) {

      console.log('Tutors returned:', tutors);

      const tutorSelect =
        document.getElementById('tutorId');

      tutors.forEach(function (tutor) {

        const option =
          document.createElement('option');

        option.value = tutor.tutorId;
        option.textContent = tutor.fullName;
        option.dataset.website = tutor.website || '';

        tutorSelect.appendChild(option);
      });

    })

    .withFailureHandler(function (error) {
      console.error('getTutors failed:', error);

      showMessage(
        'Could not load tutors: ' +
        (error.message || error),
        'error'
      );
    })

  .getTutors();
}


// --------------------------------------------------
// v1.5: update Tutor Website
// --------------------------------------------------

function updateTutorWebsite() {
  const tutorSelect = document.getElementById('tutorId');
  const furtherDetails = document.getElementById('furtherDetails');

  const selectedOption =
    tutorSelect.options[tutorSelect.selectedIndex];

  const website =
    selectedOption ? selectedOption.dataset.website : '';

  if (website) {
    furtherDetails.innerHTML = '';

    const link = document.createElement('a');
    link.href = website;
    link.target = '_blank';
    link.rel = 'noopener noreferrer';
    link.textContent = 'View tutor page';

    furtherDetails.appendChild(link);
  } else {
    furtherDetails.textContent = '';
  }
}





    // ==================================================
    // Initialisation
    // ==================================================

    // populate controls
    populateTutorDropdown();

    document
      .getElementById('tutorId')
      .addEventListener('change', updateTutorWebsite);

    //set initial UI state
    setMinimumEventDate();

    // v1.5 Location
    roomSelect.addEventListener(
      'change',
      updateOtherLocationField
    );
    updateOtherLocationField();
    
    // v1.5 Member - Non-Member - Free
    priceTypeInputs.forEach(function (radio) {
      radio.addEventListener('change', updatePriceFields);
    });
    updatePriceFields();






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
        otherLocation: form.otherLocation.value.trim(),
        eventDate: form.eventDate.value,
        startTime: form.startTime.value,
        endTime: form.endTime.value,
        priceType: form.priceType.value,
        membersPrice: form.membersPrice.value,
        nonMembersPrice: form.nonMembersPrice.value,
        skillLevel: form.skillLevel.value,
        otherDetails: form.otherDetails.value.trim()
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
          //v1.5
          updatePriceFields();
          updateOtherLocationField();
          setMinimumEventDate();

          confirmButton.disabled = false;
          confirmButton.textContent = 'Confirm Booking';

          showMessage(response.message, 'success');
          setTimeout(function () {clearMessage();}, 10000);
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
  // NOTE: This ID is to a TEST calendar - changed at GoLIVE 18.08.2026
  // 1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549 = TESTING
  // fb9defee74020745b9fe88a22a9f95429d6499037d116a29f151616c912a6683 = LIVE
  CALENDAR_ID: '1c26f492c1488f8852cbf50f1203ce8efe868869ee4aa77768f73249736a3549@group.calendar.google.com', 
  // only used if CALENDAR_MODE = 'id'

  SHEET_NAME: 'WebForm_Submissions',
  TUTORS_SHEET_NAME: 'Tutors',
  ROOM_VALUES: ['Studio', 'Gallery'],

  STATUS_VALUES: {
    APPROVED: 'Approved',
    REJECTED: 'Rejected',
    CANCELLED: 'Cancelled'
  },

  HEADERS: {
    TIMESTAMP: 'Timestamp',
    FULL_NAME: 'Full Name',
    EMAIL: 'Email',
    COURSE_NAME: 'Course Name',
    LOCATION: 'Location',
    EVENT_DATE: 'Event Date',
    START_TIME: 'Start Time',
    END_TIME: 'End Time',
    PRICE_TYPE: 'Price Type',
    MEMBERS_PRICE: 'Members Price',
    NON_MEMBERS_PRICE: 'Non-Members Price',
    SKILL_LEVEL: 'Skill Level',
    OTHER_DETAILS: 'Other Details',
    STATUS: 'Status',
    CALENDAR_EVENT_ID: 'Calendar Event ID',
    PROCESSING_NOTE: 'Processing Note',
    BILLABLE_HOURS: 'Billable Hours',
    HOURLY_RATE: 'Hourly Rate',
    TOTAL_FEE: 'Total Fee',
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

  const headers = getHeaders_(sheet);

  const statusCol = headers[CONFIG.HEADERS.STATUS];
  if (!statusCol) {
    throw new Error(`Missing header: ${CONFIG.HEADERS.STATUS}`);
  }

  if (col === statusCol) {
    handleStatusEdit_(sheet, row, headers, e);
  }
}



// * (mod v1.5) handle Status Edit

function handleStatusEdit_(sheet, row, headers, e) {
  const newStatus = trim_(e.range.getValue());
  const oldStatus = trim_(e.oldValue);
  const noteCol = headers[CONFIG.HEADERS.PROCESSING_NOTE];

  if (!noteCol) {
    throw new Error(`Missing header: ${CONFIG.HEADERS.PROCESSING_NOTE}`);
  }

  // Ignore an empty status cell
  if (!newStatus) return;

  // Only three valid statuses are permitted
  const allowedStatuses = Object.values(CONFIG.STATUS_VALUES);

  if (!allowedStatuses.includes(newStatus)) {
    sheet.getRange(row, noteCol).setValue(
      `Unknown status: ${newStatus}`
    );
    return;
  }

  // Cancellation of an approved booking removes
  // the linked calendar event.
  if (
    newStatus === CONFIG.STATUS_VALUES.CANCELLED &&
    oldStatus === CONFIG.STATUS_VALUES.APPROVED
  ) {
    processCancellationRow_(sheet, row, headers, oldStatus);
    return;
  }

  // No further action is required for other status changes.
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

  const isInternalRoom =
    formData.room === 'Studio' ||
    formData.room === 'Gallery';

  const location = isInternalRoom
    ? normalizeRoom_(formData.room)
    : String(formData.otherLocation || '').trim();

  if (!location) {
    throw new Error('Location is required.');
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


  // * v1.5 prevent past date bookings
  const now = new Date();
  if (startDateTime < now) {
    throw new Error('Booking start time cannot be in the past.');
  }
  if (endDateTime <= startDateTime) {
    throw new Error('End time must be later than start time.');
  }


  let conflict = null;

  if (isInternalRoom) {
    conflict = findRoomConflict_(
      calendar,
      location,
      startDateTime,
      endDateTime
    );
  }

  const result = {
    location: location,
    startDateTime: startDateTime,
    endDateTime: endDateTime,

    conflictDetected: Boolean(conflict),

    conflictTitle: conflict ? conflict.getTitle() : '',
    conflictStart: conflict ? conflict.getStartTime() : null,
    conflictEnd: conflict ? conflict.getEndTime() : null,

    status: conflict
      ? CONFIG.STATUS_VALUES.REJECTED
      : CONFIG.STATUS_VALUES.APPROVED,

    message: conflict
      ? 'Your booking could not be approved because the selected location is already booked at that time.'
      : 'Your booking has been approved.',

    processingNote: conflict
      ? buildConflictNote_(conflict, location)
      : `Approved for ${location}.`
  };

  logAction_(
    'INFO',
    'Submission conflict check',
    {
      location: result.location,
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
  const title =
    `${booking.courseName} (${booking.location})`;

  const descriptionLines = [
    `Full Name: ${booking.fullName || ''}`,
    `Email: ${booking.email || ''}`,
    `Location: ${booking.location}`,
    `Course Name: ${booking.courseName || ''}`
  ];

  return calendar.createEvent(
    title,
    booking.startDateTime,
    booking.endDateTime,
    {
      location: booking.location,
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
```
<hr class="section-break strong" />








## Tutors.gs

```javascript
function getTutors() {
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(CONFIG.TUTORS_SHEET_NAME);

  if (!sheet) {
    throw new Error(
      `Sheet "${CONFIG.TUTORS_SHEET_NAME}" not found.`
    );
  }

  const data = sheet.getDataRange().getValues();

  if (data.length < 2) {
    return [];
  }

  const headers = data[0].map(function (header) {
    return String(header).trim();
  });

  const tutorIdCol = headers.indexOf('TutorID');
  const fullNameCol = headers.indexOf('Full Name');
  const emailCol = headers.indexOf('Email');
  const phoneCol = headers.indexOf('Phone');
  const activeCol = headers.indexOf('Active');
  const websiteCol = headers.indexOf('Website');

  if (tutorIdCol === -1) {
    throw new Error('Missing Tutors header: Tutor ID');
  }

  if (fullNameCol === -1) {
    throw new Error('Missing Tutors header: Full Name');
  }

  if (emailCol === -1) {
    throw new Error('Missing Tutors header: Email');
  }

  if (phoneCol === -1) {
    throw new Error('Missing Tutors header: Phone');
  }

  if (activeCol === -1) {
    throw new Error('Missing Tutors header: Active');
  }

return data
  .slice(1)

  .filter(function (row) {
    const active = row[activeCol];

    return (
      row[tutorIdCol] &&
      row[fullNameCol] &&
      (
        active === true ||
        String(active).trim().toUpperCase() === 'TRUE'
      )
    );
  })

  .map(function (row) {
    return {
      tutorId: String(row[tutorIdCol]).trim(),
      fullName: String(row[fullNameCol]).trim(),
      email: String(row[emailCol]).trim(),
      phone: String(row[phoneCol]).trim(),
      active: row[activeCol],
      website: websiteCol === -1
    ? ''
    : String(row[websiteCol] || '').trim()
    };
  });
}


function findTutorById_(tutorId) {
  const tutors = getTutors();

  return tutors.find(function (tutor) {
    return tutor.tutorId === String(tutorId).trim();
  }) || null;
}
```
