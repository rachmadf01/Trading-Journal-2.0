-- Trading Journal 3.0 — Multi-account Supabase setup / migration
-- Safe to run after the original 2.2 SQL. RLS is kept enabled.

create table if not exists public.tpj_accounts (
  user_id uuid not null references auth.users(id) on delete cascade,
  id text not null,
  name text not null default 'Account',
  broker text not null default '',
  type text not null default 'Prop / Personal',
  initial_balance numeric not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now(),
  primary key (user_id, id)
);

alter table public.tpj_trades add column if not exists account_id text;
update public.tpj_trades set account_id = 'legacy' where account_id is null;
alter table public.tpj_trades alter column account_id set default 'legacy';
alter table public.tpj_trades alter column account_id set not null;

-- Keep the old settings row intact, while allowing one settings record per account.
alter table public.tpj_settings add column if not exists account_id text;
update public.tpj_settings set account_id = 'legacy' where account_id is null;
alter table public.tpj_settings alter column account_id set default 'legacy';
alter table public.tpj_settings alter column account_id set not null;
create unique index if not exists tpj_settings_user_account_uidx on public.tpj_settings(user_id, account_id);

alter table public.tpj_accounts enable row level security;
alter table public.tpj_trades enable row level security;
alter table public.tpj_settings enable row level security;

revoke all on table public.tpj_accounts from anon;
grant select, insert, update, delete on table public.tpj_accounts to authenticated;

revoke all on table public.tpj_trades from anon;
grant select, insert, update, delete on table public.tpj_trades to authenticated;

revoke all on table public.tpj_settings from anon;
grant select, insert, update, delete on table public.tpj_settings to authenticated;

drop policy if exists tpj_accounts_select on public.tpj_accounts;
drop policy if exists tpj_accounts_insert on public.tpj_accounts;
drop policy if exists tpj_accounts_update on public.tpj_accounts;
drop policy if exists tpj_accounts_delete on public.tpj_accounts;
create policy tpj_accounts_select on public.tpj_accounts for select to authenticated using ((select auth.uid()) = user_id);
create policy tpj_accounts_insert on public.tpj_accounts for insert to authenticated with check ((select auth.uid()) = user_id);
create policy tpj_accounts_update on public.tpj_accounts for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy tpj_accounts_delete on public.tpj_accounts for delete to authenticated using ((select auth.uid()) = user_id);

drop policy if exists tpj_trades_select on public.tpj_trades;
drop policy if exists tpj_trades_insert on public.tpj_trades;
drop policy if exists tpj_trades_update on public.tpj_trades;
drop policy if exists tpj_trades_delete on public.tpj_trades;
create policy tpj_trades_select on public.tpj_trades for select to authenticated using ((select auth.uid()) = user_id);
create policy tpj_trades_insert on public.tpj_trades for insert to authenticated with check ((select auth.uid()) = user_id);
create policy tpj_trades_update on public.tpj_trades for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy tpj_trades_delete on public.tpj_trades for delete to authenticated using ((select auth.uid()) = user_id);

drop policy if exists tpj_settings_select on public.tpj_settings;
drop policy if exists tpj_settings_insert on public.tpj_settings;
drop policy if exists tpj_settings_update on public.tpj_settings;
drop policy if exists tpj_settings_delete on public.tpj_settings;
create policy tpj_settings_select on public.tpj_settings for select to authenticated using ((select auth.uid()) = user_id);
create policy tpj_settings_insert on public.tpj_settings for insert to authenticated with check ((select auth.uid()) = user_id);
create policy tpj_settings_update on public.tpj_settings for update to authenticated using ((select auth.uid()) = user_id) with check ((select auth.uid()) = user_id);
create policy tpj_settings_delete on public.tpj_settings for delete to authenticated using ((select auth.uid()) = user_id);

create index if not exists tpj_accounts_user_idx on public.tpj_accounts(user_id);
create index if not exists tpj_trades_user_account_idx on public.tpj_trades(user_id, account_id);
create index if not exists tpj_trades_user_date_idx on public.tpj_trades(user_id, date);
create index if not exists tpj_settings_user_account_idx on public.tpj_settings(user_id, account_id);
