-- CQ Web / Supabase schema
-- Run this file in Supabase SQL Editor.

create table if not exists public.cq_app_state (
  id text primary key,
  payload jsonb not null,
  updated_at timestamptz not null default now(),
  updated_by text
);

create table if not exists public.cq_notifications (
  id text primary key,
  type text not null default 'info',
  title text not null default '',
  message text not null default '',
  page text,
  target_user_id text,
  created_by text,
  created_at timestamptz not null default now()
);

create index if not exists cq_notifications_created_at_idx on public.cq_notifications(created_at desc);
create index if not exists cq_notifications_target_idx on public.cq_notifications(target_user_id);

alter table public.cq_app_state enable row level security;
alter table public.cq_notifications enable row level security;

-- V1 browser application policies.
-- The current CQ Web login is application-level, so these policies allow the browser
-- client to reach the shared state. Do NOT place a Supabase service_role key in the HTML.
drop policy if exists cq_state_select on public.cq_app_state;
drop policy if exists cq_state_insert on public.cq_app_state;
drop policy if exists cq_state_update on public.cq_app_state;
drop policy if exists cq_notif_select on public.cq_notifications;
drop policy if exists cq_notif_insert on public.cq_notifications;

create policy cq_state_select on public.cq_app_state for select to anon, authenticated using (true);
create policy cq_state_insert on public.cq_app_state for insert to anon, authenticated with check (true);
create policy cq_state_update on public.cq_app_state for update to anon, authenticated using (true) with check (true);
create policy cq_notif_select on public.cq_notifications for select to anon, authenticated using (true);
create policy cq_notif_insert on public.cq_notifications for insert to anon, authenticated with check (true);

-- Enable Realtime for instant notification delivery.
do $$
begin
  alter publication supabase_realtime add table public.cq_notifications;
exception when duplicate_object then null;
end $$;

-- Optional cleanup: keep the most recent 500 notifications.
create or replace function public.cq_cleanup_notifications()
returns void language sql security definer as $$
  delete from public.cq_notifications
  where id in (
    select id from public.cq_notifications
    order by created_at desc
    offset 500
  );
$$;
