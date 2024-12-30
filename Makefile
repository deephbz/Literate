release: lit/markdown/source d-files
	@mkdir -p bin
	dub build --build=release
	@rm bin/tangle

debug: lit/markdown/source d-files
	@mkdir -p bin
	dub build

bin/tangle:
	dub --root=lit/tangle build

d-files: bin/tangle
	@mkdir -p source
	bin/tangle -odir source lit/*.lit

test: lit
	dub test

lit/markdown/source:
	@if [ ! -s lit/markdown/source ]; then \
		echo "Missing lit/markdown/source"; \
		exit 1; \
	fi;

clean:
	dub clean
	dub clean --root=lit/markdown
	dub clean --root=lit/tangle

clean-all:
	dub clean
	dub clean --root=lit/markdown
	dub clean --root=lit/tangle
	rm -rf bin source
