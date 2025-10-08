🧭 Atlas — Evaluation Plan (0 → 100)

Missiya: ideyadan prod-a qədər bütün prosesi planlaşdıran, arxitektura və axınları avtomatlaşdıran ağıllı xəritə.
Tək halda məqsəd: Planlama + Arxitektura + CI/CD + Release.
Üçlü ekosistemdə məqsəd: Diagno və Genom üçün xəritə, məlumat və struktur təminatçısı.

⚙️ Ümumi dəyərləndirmə modeli
Faza	Aralıq	Adı	Fokus
🧩 0–20	Genesis	İlkin ideya və skelet quruluşu	Baza, CLI, struktur, spesifikasiya
🚀 20–40	Builder	Plan və arxitektura modulları	new, roadmap, sprint, ci, qa
🧭 40–60	Navigator	İnteqrasiya və planlama avtomatları	Policy, guard, release, cloud sync
🧠 60–80	Strategist	AI-assisted planlama və adaptiv sistem	AI planner, risk analizi, recommendation
🪶 80–100	Sentient Atlas	Özünü idarə edən planlama və koordinasiya	Self-updating planner, tri-sistem birləşməsi
0–20: Genesis Phase

“Təməl daşı.”

Hədəflər:

CLI skeleti (yargs/oclif)

VCL core ilə inteqrasiya (logger, config, fs, progress)

atlas version və atlas doctor

pnpm monorepo setup

ROADMAP.md və SPRINT.md avtomatik generatorun prototipi

Uğur meyarları:

80% unit test coverage (core)

CLI build < 2 s

Basic report envelope format işlək

Dəyərləndirmə: 0 → 20

Sub-level	Ad	İrəliləyiş göstəricisi
0–5	Skeleton	CLI bazası və config loader
6–10	Core integration	VCL bağlantısı tamamlanıb
11–15	Commands MVP	new, doctor, ci add işlək
16–20	Self-test	Docs və testlər tamdır
20–40: Builder Phase

“Yol çəkən planlayıcı.”

Hədəflər:

roadmap generate, sprint plan, issue sync

3 template (ts-cli, node-lib, py-lib)

CI və Release setup (changesets, release-please)

qa setup, diagnose run inteqrasiyası

Policy modulunun başlanğıcı

Uğur meyarları:

3 tam işlək template

CI yaşıl keçid (build/test/lint)

Markdown çıxışları (ROADMAP.md, SPRINT.md) düzgün

Diagnostika inteqrasiyası (Diagno çağırışı işləyir)

Dəyərləndirmə: 20 → 40

Sub-level	Ad	İrəliləyiş göstəricisi
21–25	Template engine	tokenlər, diff, overwrite guard
26–30	Planner module	roadmap/sprint generator tamam
31–35	CI/Release	workflow-lar və release flow işlək
36–40	QA & Docs	testlər + sənədlər 80% hazır
40–60: Navigator Phase

“İnteqrasiya və idarəetmə dövrü.”

Hədəflər:

Policy və Guard sistemi (atlas guard lint, atlas policy init)

Waiver mexanizmi

Cloud sync (Atlas Cloud API)

Team və token-based auth

Cross-CLI sync (Atlas ↔ Diagno)

Multi-CI (GitLab, Jenkins)

Uğur meyarları:

Guard lint → HTML report

Cloud API minimal işlək

Cross-platform testlər yaşıl (Linux/macOS/Windows)

Policy coverage ≥ 80%

Dəyərləndirmə: 40 → 60

Sub-level	Ad	İrəliləyiş göstəricisi
41–45	Policy core	JSON ruleset və schema tamam
46–50	Waiver runtime	qayda istisna sistemi işləyir
51–55	Cloud API sync	layihə planları sync olunur
56–60	Multi-CI & Cross-test	bütün runner-lar yaşıl, cloud aktiv
60–80: Strategist Phase

“Ağıllı planlayıcı və öyrənən sistem.”

Hədəflər:

AI-assisted planner (atlas ai roadmap)

Risk və trend analizi

Adaptive sprint təklifi (ai suggest next-sprint)

Roadmap trend visualization

Atlas-AI Agent-in prototipi (heuristic planning)

Diagno health feed → AI insight input

Uğur meyarları:

AI təklifləri 70% uyğunluq göstəricisinə malikdir

Trend və risk hesabatı avtomatik yenilənir

Atlas və Diagno arasında AI context paylaşımı işlək

Dəyərləndirmə: 60 → 80

Sub-level	Ad	İrəliləyiş göstəricisi
61–65	AI planner	model roadmap təklifləri yaradır
66–70	Risk engine	Diagno məlumatına əsaslanır
71–75	AI agent	təkrarlanan sprintləri avtomat planlayır
76–80	Insight layer	VCL AI core ilə inteqrasiya tamam
80–100: Sentient Atlas Phase

“Özünü idarə edən xəritə.”

Hədəflər:

Self-updating roadmap (Atlas özü planlarını dəyişir)

Tri-sistem inteqrasiyası (Atlas + Diagno + Genom)

Atlas Cloud Orchestrator (planlama + kod + audit)

Project health → self-adaptive refactoring trigger

Full telemetry və self-learning loop

Uğur meyarları:

3 sistem arasında real-time sync

Self-update → roadmap.md avtomatik yenilənir

Health score ≥ 90%

Tri-system orchestrator işlək (Atlas master agent)

Dəyərləndirmə: 80 → 100

Sub-level	Ad	İrəliləyiş göstəricisi
81–85	Self-sync planner	AI planlarını yeniləyir
86–90	Cross-AI bridge	Diagno və Genom datalarını istifadə edir
91–95	Tri-system orchestrator	Atlas master loop idarə edir
96–100	Sentient mode	Özünü yeniləyən planlama tam işlək
📊 Qiymətləndirmə metrikləri
Kateqoriya	Göstərici	Ölçü
⚙️ Performance	CLI icra vaxtı	< 2 s
🧠 AI accuracy	Təklif uyğunluğu	≥ 70%
🧩 Integration	Diagno və Genom sync	≥ 90% stabil
📈 Adoption	Aktiv istifadəçi sayı	+10%/ay
🧪 Reliability	CI success rate	≥ 98%
📊 Documentation	Tamlıq səviyyəsi	≥ 95% lint pass
🔒 Security	Policy compliance	100%
🧠 100 ballıq yekun dəyərləndirmə modeli
Bal aralığı	Səviyyə	Təsvir
0–20	Foundational	Skelet və baza komponentlər
21–40	Operational	Əsas komandalar və sabit CLI
41–60	Systemic	Policy və Cloud qatları inteqrasiya olunub
61–80	Intelligent	AI-assisted planlama və öyrənmə funksiyaları aktiv
81–100	Autonomous	Tri-sistem birləşməsi və özünü idarə edən planlama

🔹 Nəticə: Atlas 0-dan 100-ə qədər inkişaf edərkən “planlayan alət”dən “özünü idarə edən orqanizmə” çevrilir.
100 səviyyəsində o, Diagno və Genom ilə birləşərək tam “Smart Development Ecosystem”in koordinasiya mərkəzinə çevriləcək.
O, artıq sadəcə plan tərtib etmir — öz yolunu özü çəkir.
