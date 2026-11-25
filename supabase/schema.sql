-- WearWhat MVP: tabel, aturan akses (RLS), dan bucket foto.
-- Jalankan sekali di Supabase Dashboard > SQL Editor > New query > Run.
-- Aman dijalankan ulang: semua perintah memakai "if not exists" atau "drop ... if exists".


-- 1. Profil user (1 baris per akun).
create table if not exists public.profiles (
  id uuid primary key references auth.users on delete cascade,
  name text not null default '',
  age int not null default 0,
  gender text not null default 'male',
  skin_tone int not null default 2,
  updated_at timestamptz not null default now()
);


-- 2. Baju di wardrobe.
create table if not exists public.clothing_items (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  category text not null,
  color bigint not null,
  seasons text[] not null default '{}',
  worn int not null default 0,
  last_worn timestamptz,
  cooldown boolean not null default false,
  photo_path text,
  created_at timestamptz not null default now()
);


-- 3. Outfit. Kolom items berisi {"top": "<id baju>", "bottom": "<id baju>", ...}.
create table if not exists public.outfits (
  id uuid primary key,
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  name text not null,
  items jsonb not null default '{}',
  last_worn_on date,
  created_at timestamptz not null default now()
);


-- 4. Rencana outfit per tanggal (kalender).
create table if not exists public.plans (
  user_id uuid not null default auth.uid() references auth.users on delete cascade,
  date date not null,
  outfit_id uuid not null references public.outfits on delete cascade,
  created_at timestamptz not null default now(),
  primary key (user_id, date, outfit_id)
);


-- 5. RLS: tiap user hanya bisa membaca dan mengubah datanya sendiri.
alter table public.profiles enable row level security;
alter table public.clothing_items enable row level security;
alter table public.outfits enable row level security;
alter table public.plans enable row level security;


drop policy if exists "own profile" on public.profiles;
create policy "own profile" on public.profiles
  for all to authenticated
  using (id = auth.uid()) with check (id = auth.uid());


drop policy if exists "own items" on public.clothing_items;
create policy "own items" on public.clothing_items
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());


drop policy if exists "own outfits" on public.outfits;
create policy "own outfits" on public.outfits
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());


drop policy if exists "own plans" on public.plans;
create policy "own plans" on public.plans
  for all to authenticated
  using (user_id = auth.uid()) with check (user_id = auth.uid());


-- 6. Bucket foto baju (private). Path file: <user id>/<id baju>.jpg
insert into storage.buckets (id, name, public)
values ('clothes', 'clothes', false)
on conflict (id) do nothing;


drop policy if exists "own clothes photos" on storage.objects;
create policy "own clothes photos" on storage.objects
  for all to authenticated
  using (bucket_id = 'clothes' and (storage.foldername(name))[1] = auth.uid()::text)
  with check (bucket_id = 'clothes' and (storage.foldername(name))[1] = auth.uid()::text);
