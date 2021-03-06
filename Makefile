.PHONY: clean all data app slides report all
#Input data to be cleaned
raw_data = data/input_data/MERGED2014_15_PP.csv

all: data eda.txt slides report session

#Phony data target to make clean data
data: data/generated_data/clean_data.csv data/generated_data/scaled_data.csv

#runs script that scales data
data/generated_data/scaled_data.csv: data/generated_data/clean_data.csv
	Rscript code/scripts/data_process.R $^

#runs script that cleans and formats data
data/generated_data/clean_data.csv:
	Rscript code/scripts/data_clean.R $(raw_data)

#creates a text files with exploratory data analysis information of data set
eda.txt: data/generated_data/clean_data.csv
	Rscript code/scripts/eda.R $^ $(raw_data)

#generate  slides using files from slide directory
slides:
	Rscript -e "require(knitr); require(markdown); knit('slides/slide.Rmd')"
	pandoc -s -t slidy slide.md -o slides.html
	rm slide.md

#generate report from files inside report directory
report:
	cd report; Rscript -e "require(knitr); require(markdown); knit('Report.Rnw')"
	cd report; pandoc Report.tex -o report.pdf
	cd report; rm Report.tex

#runs the shiny app
app:
	Rscript code/scripts/shiny.R

#generates session information to stdout
session:
	bash session.sh

#delete data generated by processes in the project
clean:
	rm data/generated_data/*
	rm *.pdf
	rm *.html
