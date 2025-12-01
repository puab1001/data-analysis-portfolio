import pandas as pd
import matplotlib.pyplot as plt

def lade_daten(pfad):
    try:
        df = pd.read_csv(pfad)
        print(f"Daten geladen: {len(df)} Zeilen")
        return df
    except FileNotFoundError:
        print(f"Fehler: Datei {pfad} nicht gefunden")
        return None

def bereinige_daten(df):
    df = df.drop_duplicates()
    df = df.dropna(subset=['umsatz', 'produkt_id'])
    
    if 'datum' in df.columns:
        df['datum'] = pd.to_datetime(df['datum'])
    
    return df

def berechne_kennzahlen(df):
    kennzahlen = {
        'gesamtumsatz': df['umsatz'].sum(),
        'durchschnitt': df['umsatz'].mean(),
        'median': df['umsatz'].median(),
        'maximum': df['umsatz'].max(),
        'minimum': df['umsatz'].min(),
        'anzahl_transaktionen': len(df)
    }
    return kennzahlen

def umsatz_nach_produkt(df):
    if 'kategorie' in df.columns:
        ergebnis = df.groupby('kategorie')['umsatz'].agg([
            ('gesamt', 'sum'),
            ('durchschnitt', 'mean'),
            ('anzahl', 'count')
        ]).round(2)
        return ergebnis.sort_values('gesamt', ascending=False)
    return None

def monatlicher_umsatz(df):
    if 'datum' in df.columns:
        df['monat'] = df['datum'].dt.to_period('M')
        monatlich = df.groupby('monat')['umsatz'].sum()
        return monatlich
    return None

def erstelle_diagramm(monatsdaten):
    plt.figure(figsize=(10, 6))
    monatsdaten.plot(kind='bar')
    plt.title('Umsatz nach Monat')
    plt.xlabel('Monat')
    plt.ylabel('Umsatz (EUR)')
    plt.xticks(rotation=45)
    plt.tight_layout()
    plt.savefig('umsatz_diagramm.png')
    print("Diagramm gespeichert")

def main():
    df = lade_daten('verkaufsdaten.csv')
    
    if df is not None:
        df = bereinige_daten(df)
        
        kennzahlen = berechne_kennzahlen(df)
        print("\n=== Verkaufskennzahlen ===")
        for key, value in kennzahlen.items():
            if isinstance(value, float):
                print(f"{key}: {value:,.2f} EUR")
            else:
                print(f"{key}: {value:,}")
        
        produkte = umsatz_nach_produkt(df)
        if produkte is not None:
            print("\n=== Umsatz nach Produktkategorie ===")
            print(produkte)
        
        monate = monatlicher_umsatz(df)
        if monate is not None:
            print("\n=== Monatlicher Umsatzverlauf ===")
            print(monate)
            erstelle_diagramm(monate)

if __name__ == "__main__":
    main()
