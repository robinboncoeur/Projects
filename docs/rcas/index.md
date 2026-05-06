# Redlands Coast Art Society

🌹

<hr style="height:4px; border-width:0; color:blue; background-color:blue" />

🌼 [Documentation v0.1](BookingDoc.md)  





## Introduction

### 1. Purpose

The RCAS Booking Manager is designed to provide a reliable, structured way to manage room bookings for the Studio and Gallery.
It ensures:

- bookings are reviewed before being committed
- room conflicts are prevented
- the spreadsheet remains the single source of truth

---

### 2. How the System Works

1. A tutor submits a booking request via the form
2. The request appears in the Admin sheet as **Pending**
3. The booking manager reviews the request
4. When marked **Approved**, the system creates a calendar event 5. If a conflict exists, the system prevents approval

---

### 3. Status Meanings


**Pending** — Awaiting review

**Approved** — Booking confirmed and written to calendar

**Rejected** — Booking declined

**Conflict** — System detected an issue (see Processing Note)

**Cancelled** — Booking removed and calendar event deleted

---

### 4. Admin Workflow (Daily Use)

1. Open Admin sheet and Calendar
2. Review new **Pending** entries
3. Check availability
4. Adjust **Assigned Room** if needed 
5. Set Status → **Approved**

Finally, confirm:
  
  - Status remains Approved
  - Calendar Event ID populated
  - Processing Note confirms success

---

### 5. Assigned Room Logic

- Do NOT edit original Room
- Use Assigned Room for overrides
- System uses Assigned Room if present

Changing Assigned Room on an approved booking:  
→ removes calendar event  
→ resets booking to Pending

---

### 6. If Something Goes Wrong

Check in this order: 

1. Status
2. Processing Note 
3. Calendar Event ID 
4. Calendar

Common causes:  

- overlapping booking 
- invalid time
- missing data

---

### 7. Key Rules

Never:

- edit base booking fields   
- rename headers  
- delete system columns

Always:

- trust Processing Note
- approve only after checking availability

---

### 8. Technical Overview

Flow:

Form → Sheet → Script → Calendar

Core behaviours:

- Approval creates event
- Status change removes event if needed 
- Conflict blocks invalid bookings

---

### 9. Notes

- Recurring bookings are validated but not fully automated 
- System_Log records system activity
- Sheet is the single source of truth

---

### 10. Philosophy

The system is designed to:

- prevent errors rather than fix them later 
- make state changes explicit
- support confident decision-making

🌹

<hr style="height:24px; border-width:0; color:blue; background-color:blue" />
