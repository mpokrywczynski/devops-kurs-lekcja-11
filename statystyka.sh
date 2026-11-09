#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Użycie: ${0##*/} <katalog>" >&2
    exit 2
fi

katalog="$1"

if [[ ! -d "$katalog" ]]; then
    echo "Błąd: '$katalog' nie jest katalogiem." >&2
    exit 1
fi

liczba_plikow=0
liczba_katalogow=0
najwiekszy_rozmiar=0
najwiekszy_plik=""

declare -A rozszerzenia

# Iteracja katalogach
for f in "$katalog"/*; do
    [[ -e "$f" ]] || continue
    
    if [[ -d "$f" ]]; then
        liczba_katalogow=$((liczba_katalogow + 1))
    elif [[ -f "$f" ]]; then
        liczba_plikow=$((liczba_plikow + 1))
        
        # Pobranie rozmiaru pliku
        rozmiar=$(stat -c%s "$f" 2>/dev/null || echo 0)
        if ((rozmiar > najwiekszy_rozmiar)); then
            najwiekszy_rozmiar=$rozmiar
            najwiekszy_plik="$f"
        fi
        
        # Wyciąganie rozszerzenia
        nazwa="${f##*/}"
        if [[ "$nazwa" == *.* && "$nazwa" != .* ]]; then
            rozs="${nazwa##*.}"
            rozs="${rozs,,}"
        else
            rozs="brak"
        fi
        
        rozszerzenia["$rozs"]=$(( ${rozszerzenia["$rozs"]:-0} + 1 ))
    fi
done

# Wyniki
echo "=== STATYSTYKA DLA: $katalog ==="
echo "Plików: $liczba_plikow"
echo "Katalogów: $liczba_katalogow"
if [[ -n "$najwiekszy_plik" ]]; then
    echo "Największy plik: $najwiekszy_plik ($najwiekszy_rozmiar bajtów)"
fi

echo "Rozszerzenia:"
for r in "${!rozszerzenia[@]}"; do
    echo "  - $r: ${rozszerzenia[$r]}"
done
