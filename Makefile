# Ermittle das Datum von gestern
YESTERDAY = $(shell date -d "yesterday" +'%Y-%m-%d')



# Liste der zu löschenden Dateierweiterungen
TEMP_EXTENSIONS = aux log out toc synctex.gz fdb_latexmk fls lof lot nav snm bbl blg


DATE_DIR = $(shell date +%y%m%d)

# Quellverzeichnis
SOURCE_DIR = out/

# Zielverzeichnis
TARGET_DIR = /mnt/c/Users/Stefan/Desktop/

# Standardziel
.PHONY: help


# Hilfsziel, das alle verfügbaren Befehle anzeigt
help:
	@echo "Verfügbare Befehle im Makefile:"
	@echo "  help		- Zeigt diese Hilfemeldung an"
	@echo "  up		  - Führt docker-compose up für jede am heutigen Tag geänderte .tex-Datei aus"
	@echo "  run FILE=FILENAME - Kompiliert die angegebene Datei mit docker-compose up"
	@echo "  generate - Kompiliert den Lebenslauf in deutsch und english"
	@echo "  cv_de - Kompiliert den Lebenslauf in deutsch"
	@echo "  cv_en - Kompiliert den Lebenslauf in english"
	@echo "  extract - Extrahiert die ersten 6 Seiten und die Seiten 7-17 in zwei separate PDF-Dateien"
	@echo "  copy - Kopiert die PDF-Datei auf den Desktop"
	@echo "  clean	   - Löscht temporäre Dateien und Logdateien"

clean:
	@echo -n "Lösche temporäre Dateien und Logdateien... "
	@find . -type f  \( -name '*.aux' \) -o  \( -name '*.log' \) -o  \( -name '*.out' \) -o  \( -name '*.toc' \) -o  \( -name '*.synctex.gz' \) -o  \( -name '*.fdb_latexmk' \) -o  \( -name '*.fls' \) -o  \( -name '*.lof' \) -o  \( -name '*.lot' \) -o  \( -name '*.nav' \) -o  \( -name '*.snm' \) -o  \( -name '*.bbl' \) -o  \( -name '*.blg' \) -exec rm -r '{}' \;
	@echo "\e[32m[OK] done\e[0m"

# Kompiliert die angegebene Datei mit docker compose up
run:
	@if [ -z "$(FILE)" ]; then \
		echo "Fehler: Bitte geben Sie eine Datei mit FILE=FILENAME an."; \
	elif [ ! -f "$(FILE)" ]; then \
		echo "Fehler: Die Datei $(FILE) existiert nicht."; \
	else \
		echo -n "Compiling ... "; \
		MY_FILE="$(FILE)" docker compose up -t 60; \
		if [ $$? -eq 0 ]; then \
			echo "Compilation successful."; \
		else \
			echo "Compilation failed."; \
		fi \
	fi


# Kompiliert die deutsche Version vom meinem CV mit docker-compose up
pmi:
	make run FILE=PMI.tex


copy:
	@echo "Erstelle Zielordner: $(TARGET_DIR)"
	@mkdir -p $(TARGET_DIR)
	@echo "Verschiebe PDF-Dateien nach $(TARGET_DIR)"
	@mv $(SOURCE_DIR)/*.pdf $(TARGET_DIR) || echo "Keine PDFs zum Verschieben gefunden"


up:
	MY_FILE='' docker compose run -d latex "/bin/bash -c 'sleep 600'"