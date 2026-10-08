-- 가람중학교 「전기와 자기」 수업 피드백 사이트
-- Spec의 수업 정보와 학생 답변을 저장하는 Supabase 스키마

create table if not exists public.lessons (
  lesson_date date primary key,
  title text not null,
  learning_guide text not null
);

create table if not exists public.student_submissions (
  lesson_date date not null references public.lessons (lesson_date),
  student_name text not null,
  understood_content text not null,
  difficult_content text not null,
  submitted boolean not null default true,
  feedback_content text,
  feedback_public boolean not null default false,
  primary key (lesson_date, student_name)
);

alter table public.lessons enable row level security;
alter table public.student_submissions enable row level security;

-- RLS 정책과 함께 익명 역할의 SQL 권한도 명시한다.
-- DELETE 권한은 부여하지 않는다.
grant select, insert, update on table public.lessons to anon;
grant select, insert, update on table public.student_submissions to anon;

-- Supabase의 익명 사용자(anon)는 읽기·추가·수정만 할 수 있다.
-- DELETE 정책은 만들지 않으므로 익명 사용자의 삭제는 허용되지 않는다.
do $$
begin
  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'lessons'
      and policyname = 'anon can read lessons'
  ) then
    create policy "anon can read lessons"
      on public.lessons
      for select
      to anon
      using (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'lessons'
      and policyname = 'anon can insert lessons'
  ) then
    create policy "anon can insert lessons"
      on public.lessons
      for insert
      to anon
      with check (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'lessons'
      and policyname = 'anon can update lessons'
  ) then
    create policy "anon can update lessons"
      on public.lessons
      for update
      to anon
      using (true)
      with check (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'student_submissions'
      and policyname = 'anon can read student submissions'
  ) then
    create policy "anon can read student submissions"
      on public.student_submissions
      for select
      to anon
      using (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'student_submissions'
      and policyname = 'anon can insert student submissions'
  ) then
    create policy "anon can insert student submissions"
      on public.student_submissions
      for insert
      to anon
      with check (true);
  end if;

  if not exists (
    select 1
    from pg_policies
    where schemaname = 'public'
      and tablename = 'student_submissions'
      and policyname = 'anon can update student submissions'
  ) then
    create policy "anon can update student submissions"
      on public.student_submissions
      for update
      to anon
      using (true)
      with check (true);
  end if;
end
$$;
