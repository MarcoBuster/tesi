# Thanks to https://gitlab.com/martisak/latex-pipeline/

SOURCES=elaborato.tex
PDF_OBJECTS=$(SOURCES:.tex=.pdf)

LATEXMK=latexmk
LATEXMK_OPTIONS=-bibtex -pdf -pdflatex="pdflatex -interaction=nonstopmode -shell-escape"

DOCKER=docker
DOCKER_COMMAND=run --rm -w /data/ --env LATEXMK_OPTIONS_EXTRA=$(LATEXMK_OPTIONS_EXTRA)
DOCKER_MOUNT=-v`pwd`:/data

all: render

pdf: $(PDF_OBJECTS)

%.pdf: %.tex
	@echo Input file: $<
	$(LATEXMK) $(LATEXMK_OPTIONS_EXTRA) $(LATEXMK_OPTIONS) $<

clean:
	-$(LATEXMK) -bibtex -C main
	-make -C clean

dist-clean: clean
	-rm $(FILENAME).tar.gz

render:
	$(DOCKER) $(DOCKER_COMMAND) $(DOCKER_MOUNT) kjarosh/latex:2023.1 \
		apk add make && \
		make pdf
