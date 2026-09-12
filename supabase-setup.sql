-- Trading Journal 2.1 — Supabase setup
-- Run this whole script in Supabase Dashboard > SQL Editor.
-- IMPORTANT: never put a service_role key in the website.

create table if not exists public.tpj_trades (
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  date date not null,
  timestamp bigint not null,
  result text not null check (result in ('win','loss')),
  pnl numeric not null,
  symbol text not null default '',
  entry_time text not null default '',
  notes text not null default '',
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

create table if not exists public.tpj_settings (
  user_id uuid primary key references auth.users(id) on delete cascade,
  settings jsonb not null default '{}'::jsonb,
  updated_at timestamptz not null default now()
);

alter table public.tpj_trades enable row level security;
alter table public.tpj_settings enable row level security;

-- Remove broad default access if present.
revoke all on table public.tpj_trades from anon;
revoke all on table public.tpj_settings from anon;
grant select, insert, update, delete on table public.tpj_trades to authenticated;
grant select, insert, update, delete on table public.tpj_settings to authenticated;

-- Recreate policies safely.
drop policy if exists "Users can read own trades" on public.tpj_trades;
drop policy if exists "Users can insert own trades" on public.tpj_trades;
drop policy if exists "Users can update own trades" on public.tpj_trades;
drop policy if exists "Users can delete own trades" on public.tpj_trades;

create policy "Users can read own trades" on public.tpj_trades
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "Users can insert own trades" on public.tpj_trades
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "Users can update own trades" on public.tpj_trades
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Users can delete own trades" on public.tpj_trades
  for delete to authenticated
  using ((select auth.uid()) = user_id);

drop policy if exists "Users can read own settings" on public.tpj_settings;
drop policy if exists "Users can insert own settings" on public.tpj_settings;
drop policy if exists "Users can update own settings" on public.tpj_settings;
drop policy if exists "Users can delete own settings" on public.tpj_settings;

create policy "Users can read own settings" on public.tpj_settings
  for select to authenticated
  using ((select auth.uid()) = user_id);

create policy "Users can insert own settings" on public.tpj_settings
  for insert to authenticated
  with check ((select auth.uid()) = user_id);

create policy "Users can update own settings" on public.tpj_settings
  for update to authenticated
  using ((select auth.uid()) = user_id)
  with check ((select auth.uid()) = user_id);

create policy "Users can delete own settings" on public.tpj_settings
  for delete to authenticated
  using ((select auth.uid()) = user_id);

create index if not exists tpj_trades_user_id_idx on public.tpj_trades(user_id);
create index if not exists tpj_trades_date_idx on public.tpj_trades(user_id, date);
