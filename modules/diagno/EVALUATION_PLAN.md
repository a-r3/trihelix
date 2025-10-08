🩺 Diagno — Evaluation Plan (0 → 100)

Missiya: Layihələrin sağlamlıq vəziyyətini ölçən, səbəbləri açıqlayan və düzəliş yolunu göstərən “self-aware” diaqnostika mühərriki.
Tək halda məqsəd: Scan → Audit → Report → Learn.
Üçlü ekosistemdə rolu: Atlas-ın planını və Genom-un yaratdığı kodu daimi yoxlayıb, riskləri aşkarlamaq və düzəliş təklif etmək.

Ümumi inkişaf xətti
Faza	Aralıq	Adı	Fokus
🧪 0–20	Genesis	Scanner & Reporter əsası	Sürətli skan, standart report
🔍 20–40	Inspector	Keyfiyyət və təhlükəsizlik	Test/coverage, dep audit, SBOM, env doctor
🧠 40–60	Analyst	Korrelyasiya və trendlər	Trend analizi, policy integration, cloud sync
🧬 60–80	Specialist	AI explainers & root-cause	Proqnoz və səbəb-zəncir, tövsiyələr
🤖 80–100	Autonomous Physician	Self-healing & orchestration	Auto-fix PR-lar, tri-sistem orkestri
0–20: Genesis — “Skan et və göstər”

Hədəflər

diagno scan (Node/Python/Go əsas artefaktları tanıma)

Report engine: html/json/text

Envelope çıxışı (ok/cmd/duration_ms/payload)

CLI UX: --verbose/--quiet/--no-color

Uğur meyarları

1 dəqiqədən < skan (orta ölçülü repo)

HTML və JSON reportları eyni məlumatı daşıyır

Core unit coverage ≥ 80%

Sub-levellər

0–5: CLI skeleton, config loader

6–10: Scanner v1 (files, deps, scripts)

11–15: Reporter v1 (html/json/text)

16–20: Envelope + basic tests (green)

20–40: Inspector — “Ölç və audit et”

Hədəflər

Test nəticələri və coverage yığımı

Dependency audit (zəifliklər, lisenziyalar)

SBOM (sbom.json/cyclonedx) stub → tamam

Env doctor: versiyalar, portlar, tokenlər (redact)

CI inteqrasiyası (GitHub Actions)

Uğur meyarları

Coverage parsingi (jest/pytest/go test) stabil

SBOM generasiyası & schema valid

CI workflow-larda diagno scan yaşıl keçir

Sub-levellər

21–25: Test & coverage collector

26–30: Dep audit + license map

31–35: Env doctor + secrets redaction

36–40: SBOM + CI preset, docs

40–60: Analyst — “Anla və əlaqələndir”

Hədəflər

Trend engine: ardıcıl skanlardan indikator düzümü (build success, coverage, vuln count)

Korrelyasiya qaydaları: “coverage↓ ∧ build failures↑ → risk↑”

Policy integration (Atlas Guard ilə uyğun): qayda pozuntularını reporta əlavə et

Cloud sync (Diagno Cloud API): report arxivi və timeline

Multi-stack detektorlar (Next, FastAPI, Flask, gRPC, Monorepo)

Uğur meyarları

Trend qrafı/tabloları reportda göstərilir

Policy pozuntuları severity ilə markerlənir

Cloud sync → report timeline görünür

Sub-levellər

41–45: Trend model & history store

46–50: Correlation rules (rulebook.json)

51–55: Policy adapter (Atlas Guard)

56–60: Cloud sync + multi-stack detektorlar

60–80: Specialist — “İzah et və proqnoz ver”

Hədəflər

AI explainers: kök-səbəb analizi (root cause narrative)

Risk prediktoru: növbəti sprintdə risk ehtimalı (low/med/high, % intervalı)

Tövsiyə generatoru: “3 quick wins + 1 strategic fix”

“What changed?” diff-intel: son commit-lərin sağlamlığa təsiri

Alerting: eşik aşımı → CLI çıxış + JSON webhook

Uğur meyarları

AI explainers-in qəbul faizi ≥ 70% (insan review)

Risk modeli ≥ 0.7 F1 (daxili etalonlarda)

Alerting false-positive ≤ 10%

Sub-levellər

61–65: Explain v1 (template-based + AI)

66–70: Risk model (trend + dep drift + CI fail)

71–75: Recommendation packs (quick/strategic)

76–80: Diff-intel + alert/webhook

80–100: Autonomous Physician — “Özünü sağalt”

Hədəflər

Auto-fix PR-lar: linter/config/test harness təmir patch-ləri

Guided fixes: interaktiv CLI addım-addım düzəliş

Tri-sistem orkestri:

Diagno risk → Atlas roadmap update təklifi

Diagno fix PR → Genom kod generasiyası ilə uyğunlaşdırma

SLO/SLA health gates: buraxılış öncəsi “go/no-go” siqnalları

Uğur meyarları

Auto-fix PR acceptance ≥ 60%

Tri-sistem sync gecikməsi < 30s

Release health gate-ləri CI-də tətbiq olunur

Sub-levellər

81–85: Auto-fix (lint/config/test)

86–90: Guided fixes (CLI wizard)

91–95: Orkestr (Atlas plan ↔ Genom patch)

96–100: Health gates + continuous self-healing loop

Qiymətləndirmə metrikləri
Kateqoriya	Göstərici	Hədəf
⏱️ Performans	Skan müddəti (orta repo)	≤ 60s
📈 Sabitlik	CI success rate	≥ 98%
🔐 Təhlükəsizlik	Vulnerability MTTR	↓ 30%
🧪 Keyfiyyət	Coverage trend (3 sprint)	↑ ≥ 5%
🧠 AI faydalılığı	Explainer acceptance	≥ 70%
🧩 İnteqrasiya	Atlas/Genom sync	≥ 90% stabil
📊 Report istifadəsi	HTML/JSON açılış sayı	↑ sprint-sprint
100 ballıq yekun şkala
Bal aralığı	Səviyyə	Təsvir
0–20	Foundational	Scanner/Reporter hazır, sürətli və etibarlı
21–40	Operational	Test, SBOM, audit tam; CI inteqrasiya olunub
41–60	Systemic	Trend, korrelyasiya, policy + cloud sync
61–80	Intelligent	AI izahı, risk proqnozu, tövsiyələr
81–100	Autonomous	Auto-fix PR-lar, tri-sistem orkestri, health gates
Risklər & Mitigation (qısa)

False positives (audit/policy): qayda səviyyələrini tənzimlə, waiver-lər.

AI hallusinasiyası: şema-guard, insan təsdiqi, nizamlı etalon testləri.

Məlumat sızması: PII-redaction, offline rejim, opt-in telemetry.

Performans: fayl-filtri, incremental scan cache, paralel runner-lar.

Çıxış/İnteqrasiya səthi
diagno scan --out html
diagno audit --deps --licenses --sbom
diagno test --coverage
diagno report --format json --webhook <url>
diagno learn --since last
# Ekosistem:
atlas diagnose run
genom fix apply --from diagno:recommendations.json


Nəticə:
Diagno 0-dan 100-ə qədər irəlilədikcə “analiz aləti”ndən özünü sağalda bilən keyfiyyət mühərrikinə çevrilir.
100 səviyyəsində o, Atlas və Genom ilə birlikdə “Smart Development Ecosystem” daxilində avtomatik risk idarəetməsi, yönləndirilmiş düzəliş və buraxılış qapıları (health gates) təmin edir.
