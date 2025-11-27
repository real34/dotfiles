.PHONY: all fmt fmt-nix fmt-shell lint lint-shell check clean

all: fmt lint

# Formatage
fmt: fmt-nix fmt-shell

fmt-nix:
	find . -name '*.nix' -not -path './.direnv/*' | xargs nixfmt

fmt-shell:
	find . -name '*.sh' -not -path './.direnv/*' | xargs shfmt -w -i 2

# Validation
lint: lint-shell

lint-shell:
	find . -name '*.sh' -not -path './.direnv/*' | xargs shellcheck

# Vérification sans modification
check:
	find . -name '*.nix' -not -path './.direnv/*' | xargs nixfmt --check
	find . -name '*.sh' -not -path './.direnv/*' | xargs shfmt -d -i 2

# Nettoyage
clean:
	rm -rf .direnv result
