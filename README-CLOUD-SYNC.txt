TRADING JOURNAL 3.0 — MULTI-ACCOUNT

What changed:
- Multiple trading accounts / workspaces.
- Quick account switcher in the top bar.
- Each account has its own trades, PnL/statistics and account settings.
- Existing local trades are automatically assigned to Main Account during migration.
- Supabase cloud sync now stores accounts + account_id on trades.
- Supabase session persistence remains enabled: do NOT press Logout if you want automatic login.
- No recurring first-login merge confirmation. After the initial migration, the app silently syncs.
- Offline-first queue remains active.

SUPABASE:
1. Run supabase-setup.sql in SQL Editor.
2. Keep the browser key as Publishable/anon only. Never use service_role/secret key.
3. Keep the existing Site URL / Redirect URL pointing to the GitHub Pages site.

AUTO LOGIN:
The app uses Supabase persistSession=true and autoRefreshToken=true. The login session is stored by the browser/PWA. If browser site data is cleared, private/incognito mode is used, or the user explicitly logs out, login will be required again.

UPGRADE:
Replace the GitHub Pages index.html and supporting files with this package. Existing localStorage keys remain compatible with 2.2.
