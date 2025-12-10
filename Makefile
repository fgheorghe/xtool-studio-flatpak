BRANCH ?= stable
export BRANCH_NAME=$(BRANCH)

all:
	envsubst < com.xtool.Studio.yml.template > com.xtool.Studio.yml
	flatpak-builder --force-clean build-dir com.xtool.Studio.yml
	flatpak-builder --repo=repo --force-clean build-dir com.xtool.Studio.yml
	flatpak build-bundle repo ./releases/xtool-studio-$(BRANCH).flatpak com.xtool.Studio $(BRANCH)

clean:
	rm -rf build-dir repo com.xtool.Studio.yml
