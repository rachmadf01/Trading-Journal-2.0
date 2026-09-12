TRADING JOURNAL 2.2 — OFFLINE FIRST + CLOUD SYNC

Files:
- index.html
- sw.js
- manifest.webmanifest
- icon-180.png / icon-512.png
- supabase-setup.sql

Setup:
1. Create a Supabase project (Free plan is enough for a personal journal).
2. SQL Editor -> paste supabase-setup.sql -> Run.
3. Project Settings -> API -> copy Project URL + Publishable/anon key.
4. Deploy all files to GitHub Pages root.
5. On each device, open the same GitHub Pages URL.
6. Cloud Sync -> enter URL/key. Login or create an account. Use the SAME account on every device.

OFFLINE-FIRST:
- Trades always save to localStorage first.
- If offline, changes remain on-device and are queued.
- When internet returns, the app attempts a full snapshot sync.
- Sync handles add/edit/delete/import/replace/clear consistently.
- If a pending queue exists, the app pushes local state before pulling cloud state, reducing accidental overwrite of offline changes.

IMPORTANT:
- Never put a service_role key in the browser. Use only the publishable/anon key.
- GitHub Pages repo can be public, so do not commit private trading data.
- Export JSON backups periodically.
- Cloud sync is not instant realtime; it refreshes on save, when returning to the app, when internet comes back, or with Sync Now.
