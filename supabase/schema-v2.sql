-- V2 quality intelligence tables. Run after V1.1 schemas.
create table if not exists public.quality_problems (
 id uuid primary key default gen_random_uuid(),
 ncr text unique,
 title text not null,
 description text default '',
 severity text not null default 'medium',
 status text not null default 'open',
 product_code text,
 product_name text,
 line text,
 production_order text,
 root_cause text,
 corrective_action text,
 preventive_action text,
 responsible text,
 due_date date,
 closed_at timestamptz,
 created_by uuid references auth.users(id),
 updated_by uuid references auth.users(id),
 created_at timestamptz not null default now(),
 updated_at timestamptz not null default now()
);
create table if not exists public.quality_problem_actions (
 id uuid primary key default gen_random_uuid(),
 problem_id uuid not null references public.quality_problems(id) on delete cascade,
 action_type text not null,
 description text not null,
 responsible text,
 due_date date,
 status text not null default 'open',
 completed_at timestamptz,
 created_by uuid references auth.users(id),
 created_at timestamptz not null default now()
);
create table if not exists public.audit_logs (
 id uuid primary key default gen_random_uuid(),
 user_id uuid references auth.users(id),
 entity text not null,
 entity_id text,
 action text not null,
 old_data jsonb,
 new_data jsonb,
 created_at timestamptz not null default now()
);
create index if not exists quality_problems_status_idx on public.quality_problems(status);
create index if not exists quality_problems_created_idx on public.quality_problems(created_at desc);
create index if not exists audit_logs_created_idx on public.audit_logs(created_at desc);
alter table public.quality_problems enable row level security;
alter table public.quality_problem_actions enable row level security;
alter table public.audit_logs enable row level security;
drop policy if exists qp_read on public.quality_problems;
drop policy if exists qp_write on public.quality_problems;
drop policy if exists qpa_read on public.quality_problem_actions;
drop policy if exists qpa_write on public.quality_problem_actions;
drop policy if exists audit_read on public.audit_logs;
create policy qp_read on public.quality_problems for select to authenticated using (true);
create policy qp_write on public.quality_problems for all to authenticated using (public.is_admin() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='operator' and p.active=true)) with check (public.is_admin() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='operator' and p.active=true));
create policy qpa_read on public.quality_problem_actions for select to authenticated using (true);
create policy qpa_write on public.quality_problem_actions for all to authenticated using (public.is_admin() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='operator' and p.active=true)) with check (public.is_admin() or exists(select 1 from public.profiles p where p.id=auth.uid() and p.role='operator' and p.active=true));
create policy audit_read on public.audit_logs for select to authenticated using (public.is_admin() or user_id=auth.uid());

-- Realtime for V2 problems and actions.
do $$ begin
 alter publication supabase_realtime add table public.quality_problems;
 alter publication supabase_realtime add table public.quality_problem_actions;
exception when duplicate_object then null; end $$;
