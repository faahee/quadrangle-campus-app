-- Complaints, reports and other student requests sent from the MIT Campus app.
create table if not exists public.campus_requests (
  id            uuid primary key default gen_random_uuid(),
  reference     text not null unique,
  student_id    text not null,
  student_name  text not null,
  email         text not null,
  request_type  text not null,
  subject       text not null check (char_length(subject) between 5 and 80),
  details       text not null check (char_length(details) between 20 and 500),
  needed_by     date not null,
  priority      text not null check (priority in ('Low', 'Normal', 'Urgent')),
  contact_method text not null check (contact_method in ('Email', 'Phone', 'In person')),
  phone         text,
  status        text not null default 'Submitted',
  created_at    timestamptz not null default now()
);

alter table public.campus_requests enable row level security;

-- The app (anon / publishable key) may only ADD new submissions.
-- Nobody can read, change or delete them with the public key; staff review
-- them in the Supabase dashboard.
create policy "App can submit requests"
  on public.campus_requests
  for insert
  to anon, authenticated
  with check (status = 'Submitted');

create index if not exists campus_requests_created_at_idx
  on public.campus_requests (created_at desc);
