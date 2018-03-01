presfilename=s3-pres

all: $(presfilename).pdf

clean:
	rm -rf *.aux *.bbl *.blg *-blx.bib *.gz *.log *.nav *.out *.snm *.toc *.tex *.vrb *.xml .Rhistory *~ figure

$(presfilename).pdf: $(presfilename).tex references.bib
	pdflatex $(presfilename).tex
	bibtex $(presfilename)
	pdflatex $(presfilename).tex
	pdflatex $(presfilename).tex
	Rscript --vanilla -e "require(extrafont);embed_fonts('$(presfilename).pdf')"

$(presfilename).tex: $(presfilename).rnw
	Rscript --vanilla -e "require(knitr);knit('$(presfilename).rnw')"

$(presfilename).rnw:

references.bib:
