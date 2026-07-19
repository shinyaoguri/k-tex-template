# ==============================================================
# LaTeX ビルド用 Makefile
#   make / make pdf   ローカル (MacTeX) でビルド
#   make docker       Docker (texlive/texlive) でビルド
#   make container    Apple コンテナでビルド（make apple も同じ）
#   make watch        保存のたびに自動再ビルド（ローカル専用）
#   make clean        中間ファイルを削除（PDF は残す）
#   make distclean    PDF も含めて生成物を削除
#   make help         ターゲット一覧を表示
#
#   卒論をビルドする場合: make docker TARGET=thesis.tex
#   イメージ差し替え:     make docker IMAGE=texlive/texlive:TL2025-historic
# ==============================================================

TARGET ?= main.tex
IMAGE  ?= texlive/texlive:latest

# Linux ホストの Docker では生成物が root 所有になるため UID/GID を合わせる
# （macOS の Docker Desktop / Apple コンテナではホストユーザーに揃うので不要だが無害）
UNAME_S := $(shell uname -s)
DOCKER_USER_OPT :=
ifeq ($(UNAME_S),Linux)
DOCKER_USER_OPT := --user $(shell id -u):$(shell id -g)
endif

DOCKER_RUN    = docker run --rm $(DOCKER_USER_OPT) -v "$(CURDIR):/workdir" -w /workdir $(IMAGE)
CONTAINER_RUN = container run --rm -v "$(CURDIR):/workdir" -w /workdir $(IMAGE)

.PHONY: pdf watch docker container apple clean distclean docker-clean container-clean help

pdf: ## ローカル (MacTeX) でビルド
	latexmk $(TARGET)

watch: ## 保存のたびに自動再ビルド（ローカル専用・Ctrl-C で停止）
	latexmk -pvc $(TARGET)

docker: ## Docker でビルド
	$(DOCKER_RUN) latexmk $(TARGET)

container: ## Apple コンテナでビルド（事前に container system start が必要）
	$(CONTAINER_RUN) latexmk $(TARGET)

apple: container ## container のエイリアス

clean: ## 中間ファイルを削除（PDF は残す）
	latexmk -c $(TARGET)

distclean: ## PDF も含めて生成物を削除
	latexmk -C $(TARGET)

docker-clean: ## ローカルに TeX が無い場合の掃除（Docker 経由）
	$(DOCKER_RUN) latexmk -c $(TARGET)

container-clean: ## ローカルに TeX が無い場合の掃除（Apple コンテナ経由）
	$(CONTAINER_RUN) latexmk -c $(TARGET)

help: ## このヘルプを表示
	@grep -E '^[a-zA-Z_-]+:.*## ' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*## "} {printf "  %-16s %s\n", $$1, $$2}'
