

pre-commit: generate-helmdocs
pre-release: generate-helmdocs generate-changelog

generate-changelog:
	./scripts/generate-changelog.sh

generate-helmdocs:
	./scripts/generate-helmdocs.sh
