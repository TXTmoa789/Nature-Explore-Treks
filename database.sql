-- Run this in Supabase SQL Editor.
create extension if not exists pgcrypto;
create table if not exists public.treks(
 id uuid primary key default gen_random_uuid(), name text not null, client_name text,
 start_date date, client_count integer not null default 1 check(client_count>0),
 price_per_person numeric(14,2) not null default 0, amount_received numeric(14,2) not null default 0,
 notes text, created_at timestamptz not null default now(), updated_at timestamptz not null default now());
create table if not exists public.expenses(
 id uuid primary key default gen_random_uuid(), trek_id uuid not null references public.treks(id) on delete cascade,
 category text not null, amount numeric(14,2) not null default 0, note text, created_at timestamptz not null default now());
alter table public.treks enable row level security;
alter table public.expenses enable row level security;
drop policy if exists "auth treks select" on public.treks;
drop policy if exists "auth treks insert" on public.treks;
drop policy if exists "auth treks update" on public.treks;
drop policy if exists "auth treks delete" on public.treks;
create policy "auth treks select" on public.treks for select to authenticated using(true);
create policy "auth treks insert" on public.treks for insert to authenticated with check(true);
create policy "auth treks update" on public.treks for update to authenticated using(true) with check(true);
create policy "auth treks delete" on public.treks for delete to authenticated using(true);
drop policy if exists "auth expenses select" on public.expenses;
drop policy if exists "auth expenses insert" on public.expenses;
drop policy if exists "auth expenses update" on public.expenses;
drop policy if exists "auth expenses delete" on public.expenses;
create policy "auth expenses select" on public.expenses for select to authenticated using(true);
create policy "auth expenses insert" on public.expenses for insert to authenticated with check(true);
create policy "auth expenses update" on public.expenses for update to authenticated using(true) with check(true);
create policy "auth expenses delete" on public.expenses for delete to authenticated using(true);
alter publication supabase_realtime add table public.treks;
