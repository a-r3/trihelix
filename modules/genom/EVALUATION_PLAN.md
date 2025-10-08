Missiya: Planı (Atlas-dan) və analizləri (Diagno-dan) kod şəklinə çevirən, yaradan, təkmilləşdirən və optimallaşdıran “intelligent code forge”.
Tək halda məqsəd: Kod generasiyası, modul quruluşu, pattern tətbiqi və AI-assisted yazılış.
Üçlü ekosistemdə rolu: Atlas-ın planlarını reallaşdırmaq, Diagno-nun düzəlişlərini tətbiq etmək, ekosistemdə yaradıcı “icraçı” olmaq.

Ümumi inkişaf mərhələləri
Faza	Aralıq	Ad	Fokus
⚙️ 0–20	Genesis	Skeleton & Template Engine	Kod generasiyasının bazası
🧩 20–40	Builder	Pattern və Struktur Generator	Layer, API, Model, Test
🧠 40–60	Synthesizer	AI-assisted Code & Refactor	Kod yazma, redaktə, təkmilləşmə
🔄 60–80	Integrator	Atlas/Diagno sinxronluğu	Plan → Kod → Audit dövrü
🤖 80–100	Autonomous Creator	Self-building & Evolving Code	Özünü yeniləyən, adaptiv yaradıcı mühərrik
0–20: Genesis — “İlkin yaradıcılıq qatı”

Hədəflər:

CLI skeleti (genom new, genom generate)

Template mühərriki (hbs/ejs support)

Metadata sistemi (manifest.json → project spec)

FS-atomic yazma (rollback ilə)

Envelope çıxışı (ok, cmd, duration_ms, payload)

Uğur meyarları:

Template generasiyası ≤ 2s

Fayllar idempotent yazılır (təkrar generasiya təhlükəsiz)

Basic unit testlər 80% coverage

Sub-levellər:

Səviyyə	Ad	İrəliləyiş
0–5	CLI & Config	genom --version, genom doctor
6–10	Template engine v1	.hbs, .json, .ts template dəstəyi
11–15	FS-atomic	təhlükəsiz yazma və backup
16–20	Manifest meta	Template manifest.json + schema validation
20–40: Builder — “Formanı kodla doldur”

Hədəflər:

Generator modul (genom generate model, api, ui)

Pattern-lər (mvc, clean, layered)

Test scaffolding (genom test init)

Deployment setup (docker, compose, ci)

Template sandbox (preview & dry-run)

Uğur meyarları:

3 pattern işlək və sınaqdan keçib

CI workflow-lar avtomatik yaranır

Testlər avtomatik skeleton yaradır

Dry-run preview tam funksional

Sub-levellər:

Səviyyə	Ad	İrəliləyiş
21–25	Generator engine	generate model/controller/api
26–30	Pattern builder	apply pattern layered
31–35	Test scaffolder	unit + e2e templates
36–40	Deploy setup	Docker + CI generator
40–60: Synthesizer — “Ağıllı kod yaradıcısı”

Hədəflər:

AI-assisted code generation (prompt → file)

Smart refactor (rename, restructure, extract)

Prompt template sistemi (prompts/*.yml)

Context-aware generator (Atlas spec, roadmap input)

Change detection və diff-mapping (genom diff --with atlas)

Uğur meyarları:

AI kod təklifi qəbul faizi ≥ 70%

Refactor-lar semantik qoruma saxlayır

Atlas spec-dən 80% uyğun kod skeleton

Diff viewer düzgün mapping göstərir

Sub-levellər:

Səviyyə	Ad	İrəliləyiş
41–45	AI writer	prompt → kod faylı
46–50	Refactor engine	AST-level dəyişiklik
51–55	Prompt library	/prompts/*.yml → roles/templates
56–60	Context bridge	Atlas → Genom input sync
60–80: Integrator — “Ekosistemlə birləşən yaradıcı”

Hədəflər:

Atlas plan → Genom code → Diagno report tam dövr

genom sync (Atlas ilə plan müqayisəsi)

genom fix apply (Diagno təkliflərini tətbiq edir)

Live coding mode (interactive generation)

Cloud sync və telemetry (genom cloud push)

Uğur meyarları:

Tri-data flow: Plan → Kod → Audit işlək

Fix apply latency < 15s

Live coding stabil (rollback + preview)

Cloud syncdə report tarixçəsi görünür

Sub-levellər:

Səviyyə	Ad	İrəliləyiş
61–65	Atlas sync	Plan strukturu kodla uyğunlaşdırılır
66–70	Diagno apply	Risk və fix-lər tətbiq olunur
71–75	Live mode	real-time generation və rollback
76–80	Cloud sync	kod və metadata upload
80–100: Autonomous Creator — “Özünü inkişaf etdirən orqanizm”

Hədəflər:

Self-improving generator (AI learns from telemetry)

Style adaptation (komandanın yazı tərzinə uyğun)

Auto-review PR-lar və commit təklifi

Continuous generation agent (sprintlərə uyğun modullar yaradır)

Tri-sistem “creation loop”:

Atlas → Plan

Genom → Kod

Diagno → Feedback → Atlas update

Uğur meyarları:

Self-learning təklif dəqiqliyi ≥ 75%

Auto-review səhv faizi ≤ 5%

Tri-sistem gecikməsi < 20s

AI generation təkrarı < 10%

Sub-levellər:

Səviyyə	Ad	İrəliləyiş
81–85	Self-learn model	telemetry-dən öyrənmə
86–90	Style adaptation	pattern + tərz qorunur
91–95	Auto-review agent	PR təklifi və təhlili
96–100	Full orchestration	Atlas + Diagno ilə dövr tamamlanır
⚙️ Qiymətləndirmə Metrikləri
Kateqoriya	Göstərici	Hədəf
⚡ Performance	Generator sürəti	< 2s per file
🧠 AI quality	Kod uyğunluğu	≥ 70%
🔁 Integration	Atlas/Diagno sync	≥ 90% stabil
🧩 Automation	Auto-review + apply success	≥ 80%
📊 Usability	CLI UX rating (user feedback)	≥ 4.5/5
🧪 Reliability	Error-free generation	≥ 98%
🔒 Security	Policy compliance (Atlas Guard)	100%
🧭 100 ballıq yekun şkala
Bal aralığı	Səviyyə	Təsvir
0–20	Foundational	Kod generator skeleti və template sistemi işlək
21–40	Operational	Pattern və test generatorları aktiv
41–60	Intelligent	AI-assisted yazılış və kontekstli refaktor
61–80	Integrated	Atlas və Diagno ilə real-time sync
81–100	Autonomous	Özünü öyrədən, tərzə uyğunlaşan, tam yaradıcı agent
🔄 Tri-System Loop: “Creation Flow”
   ┌─────────── Atlas ───────────┐
   │ Plan & Structure (ROADMAP) │
   └───────────┬────────────────┘
               │
        plan.json / spec.yml
               │
          ⬇
   ┌─────────── Genom ───────────┐
   │ Code, Modules, CI, Docs    │
   └───────────┬────────────────┘
               │
       repo/, diff, patch
               │
          ⬇
   ┌────────── Diagno ──────────┐
   │ Scan, Audit, Health Report│
   └───────────┬────────────────┘
               │
       feedback.json / risk.log
               │
          ⬆
   (back to Atlas → update plan)

🚧 Risklər & Həlli
Risk	İzah	Mitigation
Kod hallusinasiyası	AI səhv kod yarada bilər	Schema validation + human-in-loop
Security drift	Auth və secret-lər sızar	Policy check + Diagno audit
Performance	Böyük layihələrdə gecikmə	Parallel generator + cache reuse
Conflict	Manual dəyişikliklə sync problemi	AST diff və merge resolver
AI drift	Model keyfiyyətinin azalması	Continuous fine-tuning + feedback loop
✨ Nəticə

Genom, 0-dan 100-ə qədər inkişaf edərkən,
sadə “code generator”dan AI-assisted, özünü öyrədən, adaptiv yaradıcı mühərrikə çevrilir.
100 səviyyəsində o:

Atlas-ın planlarını avtomatik həyata keçirir,

Diagno-nun təkliflərini kod səviyyəsində tətbiq edir,

və öz təcrübəsindən öyrənərək özünü yenidən yazma mərhələsinə çatır.
