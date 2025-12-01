# Datenanalyse Portfolio

Sammlung praktischer Datenanalyse-Arbeiten mit Python und SQL.

## Inhalt

### Python

**verkaufsanalyse.py**
- Lädt CSV-Verkaufsdaten und bereinigt sie
- Berechnet Kennzahlen (Gesamtumsatz, Durchschnitt, Median)
- Analysiert Verkäufe nach Produktkategorie und Zeitraum
- Erstellt Diagramme mit matplotlib
- Benötigt: pandas, matplotlib

### SQL

**sql_abfragen.sql**
- 7 SQL-Abfragen für Verkaufs- und Kundenanalysen
- Umsatzauswertungen mit Aggregationen
- Kundensegmentierung nach Kaufverhalten
- Produktanalyse mit Gewinnberechnungen
- Lagerreichweiten basierend auf Abverkaufsgeschwindigkeit
- Zeitreihenanalyse mit gleitenden Durchschnitten

## Verwendete Technologien

- Python (pandas, matplotlib)
- SQL (JOINs, GROUP BY, Window Functions, Subqueries)
- Statistische Auswertungen
- Datenbereinigung
- KPI-Tracking

## Verwendung

### Python Script ausführen

pip install pandas matplotlib
python verkaufsanalyse.py

### SQL Abfragen
Queries können in MySQL oder PostgreSQL ausgeführt werden. 
Benötigte Tabellenstruktur:
- `verkaufe`: datum, produkt_id, kunden_id, umsatz, menge
- `produkte`: produkt_id, name, kategorie, einkaufspreis
- `kunden`: kunden_id, name, segment
- `lager`: produkt_id, aktueller_bestand

## Ausgabe

Das Python-Script generiert:
- Konsolen-Ausgabe mit statistischen Zusammenfassungen
- umsatz_diagramm.png: Balkendiagramm mit monatlichem Umsatzverlauf


## Kontakt

Purja Abdshahzadeh  
pu.shahzadeh@gmail.com
