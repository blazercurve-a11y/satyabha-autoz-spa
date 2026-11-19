SATYABHA AUTOZ SPA — WEBSITE + BOOKING SYSTEM

WHAT IS INCLUDED
- Existing cinematic black-and-gold website and original Jeep Compass photos.
- Visible number plates covered in the website image assets.
- Online appointment request form.
- Private admin sign-in page at /admin.html.
- Booking status workflow: Pending, Contacted, Confirmed, Completed, Cancelled.
- Supabase SQL with Row Level Security: visitors can submit requests, but only authorised admins can read or update booking records.

IMPORTANT: THE DATABASE IS NOT CONNECTED YET
This ZIP is the website code. It is not live, and bookings will not save until the owner creates a Supabase project, runs supabase-schema.sql, creates an admin login, adds that login's UUID to admin_users, and fills supabase-config.js with the Supabase Project URL and anon/public key. Never paste a service_role key into this website. Never share passwords in chat.

SETUP
See SETUP-GUIDE.txt for the beginner-friendly steps.

PAGES
index.html — Home
services.html — Services
book.html — Customer appointment request
contact.html — Contact details
admin.html — Private admin login/dashboard
