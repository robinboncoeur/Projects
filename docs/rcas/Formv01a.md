# Booking App v.1a Forms

## Code Base
### 05.Apr.2026

<img src="/assets/images/docimgs/260331aa.jpg" style="float: right; width: 300px; margin-left: 20px" />

```javascript
function doGet() {
  return HtmlService.createHtmlOutputFromFile('Index')
    .setTitle('Booking Request Prototype');
}

function submitBooking(formData) {
  const sheetName = 'WebForm_Submissions';
  const ss = SpreadsheetApp.getActiveSpreadsheet();
  const sheet = ss.getSheetByName(sheetName);

  if (!sheet) {
    throw new Error(`Sheet "${sheetName}" not found.`);
  }

  // Basic server-side validation
  const requiredFields = [
    'fullName',
    'email',
    'courseName',
    'eventDate',
    'startTime',
    'endTime'
  ];

  for (const field of requiredFields) {
    if (!formData[field] || String(formData[field]).trim() === '') {
      throw new Error(`Missing required field: ${field}`);
    }
  }

  // Validate time order
  const start = parseTimeToMinutes(formData.startTime);
  const end = parseTimeToMinutes(formData.endTime);

  if (end <= start) {
    throw new Error('End time must be later than start time.');
  }

  sheet.appendRow([
    new Date(),
    formData.fullName,
    formData.email,
    formData.courseName,
    formData.eventDate,
    formData.startTime,
    formData.endTime
  ]);

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




## HTML Form 1

<img src="/assets/images/docimgs/260331ab.jpg" style="float: right; width: 300px; margin-left: 20px" />

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

      input {
        padding: 10px;
        border: 1px solid #ccc;
        border-radius: 8px;
        font-size: 14px;
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

      @media (max-width: 700px) {
        .grid {
          grid-template-columns: 1fr;
        }
      }
    </style>
  </head>
  <body>
    <div class="container">
      <h1>Booking Request Prototype</h1>
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
            <label for="courseName">Course Name</label>
            <input type="text" id="courseName" name="courseName" required>
          </div>

          <div class="field">
            <label for="eventDate">Event Date</label>
            <input type="date" id="eventDate" name="eventDate" required>
          </div>

          <div class="field">
            <label for="startTime">Start Time</label>
            <input type="time" id="startTime" name="startTime" required>
          </div>

          <div class="field">
            <label for="endTime">End Time</label>
            <input type="time" id="endTime" name="endTime" required>
          </div>
        </div>

        <div class="actions">
          <button type="submit">Submit Booking Request</button>
        </div>

        <div id="message" class="message"></div>
      </form>
    </div>

    <script>
      const form = document.getElementById('bookingForm');
      const messageBox = document.getElementById('message');

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

      form.addEventListener('submit', function (e) {
        e.preventDefault();
        clearMessage();

        const formData = {
          fullName: form.fullName.value.trim(),
          email: form.email.value.trim(),
          courseName: form.courseName.value.trim(),
          eventDate: form.eventDate.value,
          startTime: form.startTime.value,
          endTime: form.endTime.value
        };

        if (
          !formData.fullName ||
          !formData.email ||
          !formData.courseName ||
          !formData.eventDate ||
          !formData.startTime ||
          !formData.endTime
        ) {
          showMessage('Please complete all required fields.', 'error');
          return;
        }

        if (timeToMinutes(formData.endTime) <= timeToMinutes(formData.startTime)) {
          showMessage('End time must be later than start time.', 'error');
          return;
        }

        google.script.run
          .withSuccessHandler(function (response) {
            showMessage(response.message, 'success');
            form.reset();
          })
          .withFailureHandler(function (error) {
            showMessage(error.message || 'Something went wrong.', 'error');
          })
          .submitBooking(formData);
      });
    </script>
  </body>
</html>
```








## New HTML

<img src="/assets/images/docimgs/260331ae.jpg" style="float: right; width: 300px; margin-left: 20px" />

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
      <h1>Booking Request Prototype</h1>
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
            <label for="courseName">Course Name</label>
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
      const form = document.getElementById('bookingForm');
      const messageBox = document.getElementById('message');
      const recurringSelect = document.getElementById('recurring');
      const frequencyField = document.getElementById('frequencyField');
      const repeatUntilField = document.getElementById('repeatUntilField');
      const frequencyInput = document.getElementById('frequency');
      const repeatUntilInput = document.getElementById('repeatUntil');

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

      recurringSelect.addEventListener('change', toggleRecurringFields);
      toggleRecurringFields();

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

        if (
          timeToMinutes(formData.startTime) % 30 !== 0 ||
          timeToMinutes(formData.endTime) % 30 !== 0
        ) {
          showMessage('Please use 30-minute increments only.', 'error');
          return;
        }

        if (timeToMinutes(formData.endTime) <= timeToMinutes(formData.startTime)) {
          showMessage('End time must be later than start time.', 'error');
          return;
        }

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

        google.script.run
          .withSuccessHandler(function (response) {
            showMessage(response.message, 'success');
            form.reset();
            toggleRecurringFields();
          })
          .withFailureHandler(function (error) {
            showMessage(error.message || 'Something went wrong.', 'error');
          })
          .submitBooking(formData);
      });
    </script>
  </body>
</html>
```
