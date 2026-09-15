# Left To Do



<hr class="section-break strong" />




## Items

### Tutor notification for a rejected booking.

At present the tutor sees the rejection on screen and the rejected request is recorded in the worksheet, but we wanted them to receive an email as well: essentially, Studio/Gallery is unavailable at that time; check the calendar and try another time/location. This is probably the next actual feature.

<hr class="section-break soft" />


### Do a little server-side location hardening.

The server should explicitly accept only Studio, Gallery, or Other as the form's location choice. At present evaluateBooking_() distinguishes Studio/Gallery from everything else; technically a mischievous browser could submit room = "Elephant" plus an address and we'd treat it as an external location. 🐘 Not remotely urgent, but very easy to close.

<hr class="section-break soft" />


### Past-date validation on the server.

The browser prevents choosing an old date, but—as with the prices—we shouldn't rely entirely on the browser. The server should refuse a booking whose date/time has already passed.

<hr class="section-break soft" />


### Deal with the now-obsolete Assigned Room machinery.

The worksheet column is gone, but some old backend code (handleAssignedRoomEdit_(), parts of onApprovalEdit(), etc.) is still hanging around. Likewise, we've deliberately retained the old Pending infrastructure because TPTB may yet change their minds. I would not rip all of that out tonight. Once the requirements stop moving, we can mark/deactivate the Assigned Room code cleanly rather than performing surgery while the patient is still changing shape.

<hr class="section-break soft" />


### Future multi-session booking.

We've settled the important architecture: one worksheet row = one actual session. If a tutor eventually wants six dates, the form can submit six ordinary bookings. But we haven't decided how many dates they may request at once or how far ahead. That's a later v1.6-ish feature, not something v1.5 needs before it can work.

<hr class="section-break soft" />


### “Further Details”.

Still deliberately a placeholder because we haven't decided where that information eventually comes from. Again, no reason for it to hold up the booking system.






## Summary

There is also the accounting end: Billable Hours is working, while Hourly Rate and Total Fee are deliberately blank because we haven't yet established how the rate is supplied. That's not a bug; it's unfinished policy/business logic.

So I'd describe the state of the project as:

* Booking engine: essentially complete.
* New v1.5 data model: complete.
* New rejection workflow: working.
* Notification + defensive validation + cleanup: remaining.
* Multi-session/further-details/accounting policy: future work.

And I think the nicest next bite-sized job is the rejection email. It gives us a genuinely useful completed workflow: tutor tries an unavailable room → request is recorded as Rejected → no calendar event → tutor gets immediate on-screen feedback and an email telling them what happened.
