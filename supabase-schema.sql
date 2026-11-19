-- SATYABHA AUTOZ SPA — Supabase database setup
-- Run this entire script in Supabase Dashboard > SQL Editor > New query.
create extension if not exists pgcrypto;

create table if not exists public.bookings (
  id uuid primary key default gen_random_uuid(),
  customer_name text not null check (char_length(customer_name) between 2 and 80),
  mobile text not null check (char_length(mobile) between 10 and 16),
  car_model text not null check (char_length(car_model) between 1 and 80),
  service text not null check (service in ('Hydraulic Lift Car Wash','Standard Car Wash','Interior Cleaning','Engine Cleaning','Wax & Polish')),
  appointment_date date not null check (appointment_date >= current_date),
  preferred_time text not null check (preferred_time in ('9:00 AM – 11:00 AM','11:00 AM – 1:00 PM','1:00 PM – 3:00 PM','3:00 PM – 5:00 PM','5:00 PM – 7:00 PM')),
  status text not null default 'Pending' check (status in ('Pending','Contacted','Confirmed','Completed','Cancelled')),
  created_at timestamptz not null default now()
);

create table if not exists public.admin_users (
  user_id uuid primary key references auth.users(id) on delete cascade,
  created_at timestamptz not null default now()
);

alter table public.bookings enable row level security;
alter table public.admin_users enable row level security;

create or replace function public.is_satyabha_admin()
returns boolean language sql stable security definer set search_path = public
as $$ select exists (select 1 from public.admin_users where user_id = auth.uid()); $$;

grant usage on schema public to anon, authenticated;
grant insert on public.bookings to anon, authenticated;
grant select, update on public.bookings to authenticated;
grant select on public.admin_users to authenticated;
grant execute on function public.is_satyabha_admin() to anon, authenticated;

drop policy if exists "Anyone can submit booking request" on public.bookings;
create policy "Anyone can submit booking request" on public.bookings
for insert to anon, authenticated with check (status = 'Pending');

drop policy if exists "Only admins can view bookings" on public.bookings;
create policy "Only admins can view bookings" on public.bookings
for select to authenticated using (public.is_satyabha_admin());

drop policy if exists "Only admins can update bookings" on public.bookings;
create policy "Only admins can update bookings" on public.bookings
for update to authenticated using (public.is_satyabha_admin()) with check (public.is_satyabha_admin());

drop policy if exists "Admins can view their own admin record" on public.admin_users;
create policy "Admins can view their own admin record" on public.admin_users
for select to authenticated using (user_id = auth.uid());

-- After creating the admin login in Supabase Authentication > Users,
-- copy that user's UUID and run the following separately (replace the UUID):
-- insert into public.admin_users (user_id) values ('PASTE-AUTH-USER-UUID-HERE');
