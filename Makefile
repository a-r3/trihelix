.PHONY: audit smoke release release-minor release-major release-dry

audit:
	@bash scripts/trihelix-repo-audit.sh

smoke:
	@bash scripts/trihelix-smoke.sh

release:
	@bash scripts/auto-tag-and-release.sh

release-minor:
	@bash scripts/auto-tag-and-release.sh --minor

release-major:
	@bash scripts/auto-tag-and-release.sh --major

release-dry:
	@bash scripts/auto-tag-and-release.sh --dry-run
