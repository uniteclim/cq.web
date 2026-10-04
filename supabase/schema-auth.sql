-- V1.1 secure identity layer. Run after the base schema.sql.
create table if not exists public.profiles (
  id uuid primary key references auth.users(id) on delete cascade,
  username text unique,
  full_name text not null default '',
  role text not null default 'operator' check (role in ('admin','operator','viewer')),
  active boolean not null default true,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);
alter table public.profiles enable row level security;
drop policy if exists profiles_self_select on public.profiles;
drop policy if exists profiles_admin_all on public.profiles;
create policy profiles_self_select on public.profiles for select to authenticated using (id=auth.uid());
create policy profiles_admin_all on public.profiles for all to authenticated using (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin')) with check (exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='admin'));
create or replace function public.is_admin() returns boolean language sql stable security definer set search_path=public as $$ select exists(select 1 from public.profiles where id=auth.uid() and role='admin' and active=true); $$;
