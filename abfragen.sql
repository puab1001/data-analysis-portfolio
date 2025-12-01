-- SQL Abfragen für Datenanalyse und Reporting
-- Purja Abdshahzadeh

-- Umsatz nach Produktkategorie
SELECT 
    kategorie,
    COUNT(*) as anzahl_verkaufe,
    SUM(umsatz) as gesamtumsatz,
    AVG(umsatz) as durchschnitt,
    MAX(umsatz) as hochster_verkauf,
    MIN(umsatz) as niedrigster_verkauf
FROM verkaufe
WHERE datum >= '2024-01-01'
GROUP BY kategorie
ORDER BY gesamtumsatz DESC;

-- Monatlicher Umsatzverlauf
SELECT 
    YEAR(datum) as jahr,
    MONTH(datum) as monat,
    SUM(umsatz) as monatsumsatz,
    COUNT(*) as anzahl_transaktionen,
    AVG(umsatz) as durchschnittswert
FROM verkaufe
GROUP BY YEAR(datum), MONTH(datum)
ORDER BY jahr DESC, monat DESC;

-- Top 10 Kunden nach Umsatz
SELECT 
    k.kunden_id,
    k.name,
    k.segment,
    COUNT(v.auftrag_id) as anzahl_bestellungen,
    SUM(v.umsatz) as gesamtumsatz,
    AVG(v.umsatz) as durchschnittlicher_auftragswert
FROM kunden k
INNER JOIN verkaufe v ON k.kunden_id = v.kunden_id
WHERE v.datum >= DATE_SUB(CURDATE(), INTERVAL 12 MONTH)
GROUP BY k.kunden_id, k.name, k.segment
ORDER BY gesamtumsatz DESC
LIMIT 10;

-- Produktanalyse mit Gewinnmargen
SELECT 
    p.produkt_id,
    p.name,
    p.kategorie,
    COUNT(v.auftrag_id) as verkaufte_einheiten,
    SUM(v.umsatz) as umsatz,
    SUM(v.umsatz - p.einkaufspreis * v.menge) as gewinn,
    ROUND((SUM(v.umsatz - p.einkaufspreis * v.menge) / SUM(v.umsatz)) * 100, 2) as gewinnmarge_prozent
FROM produkte p
LEFT JOIN verkaufe v ON p.produkt_id = v.produkt_id
WHERE v.datum >= '2024-01-01'
GROUP BY p.produkt_id, p.name, p.kategorie
HAVING umsatz > 1000
ORDER BY gewinn DESC;

-- Kundensegmentierung nach Kaufhaufigkeit
SELECT 
    segment,
    COUNT(DISTINCT kunden_id) as anzahl_kunden,
    SUM(gesamtkaufe) as gesamt_transaktionen,
    AVG(gesamtkaufe) as durchschnitt_pro_kunde,
    SUM(ausgaben) as segment_umsatz
FROM (
    SELECT 
        k.kunden_id,
        k.segment,
        COUNT(v.auftrag_id) as gesamtkaufe,
        SUM(v.umsatz) as ausgaben
    FROM kunden k
    LEFT JOIN verkaufe v ON k.kunden_id = v.kunden_id
    WHERE v.datum >= DATE_SUB(CURDATE(), INTERVAL 6 MONTH)
    GROUP BY k.kunden_id, k.segment
) as zusammenfassung
GROUP BY segment
ORDER BY segment_umsatz DESC;

-- Tagesumsatz mit 7-Tage-Durchschnitt
SELECT 
    datum,
    SUM(umsatz) as tagesumsatz,
    AVG(SUM(umsatz)) OVER (
        ORDER BY datum 
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) as durchschnitt_7tage
FROM verkaufe
WHERE datum >= DATE_SUB(CURDATE(), INTERVAL 90 DAY)
GROUP BY datum
ORDER BY datum DESC;

-- Lagerbestand mit Abverkaufsgeschwindigkeit
SELECT 
    p.produkt_id,
    p.name,
    l.aktueller_bestand,
    COALESCE(letzte30.verkaufte_einheiten, 0) as verkauft_30tage,
    ROUND(l.aktueller_bestand / NULLIF(letzte30.verkaufte_einheiten, 0) * 30, 1) as reichweite_tage
FROM produkte p
INNER JOIN lager l ON p.produkt_id = l.produkt_id
LEFT JOIN (
    SELECT 
        produkt_id,
        SUM(menge) as verkaufte_einheiten
    FROM verkaufe
    WHERE datum >= DATE_SUB(CURDATE(), INTERVAL 30 DAY)
    GROUP BY produkt_id
) letzte30 ON p.produkt_id = letzte30.produkt_id
WHERE l.aktueller_bestand > 0
ORDER BY reichweite_tage ASC;
