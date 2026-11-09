#!/usr/bin/env bash

# 1. Sprawdzenie czy podano argument
if [[ $# -lt 1 ]]; then
    echo "Użycie: ${0##*/} <katalog-źródłowy> [katalog-docelowy]" >&2
    exit 2
fi

zrodlo="$1"
docelowy="${2:-$HOME/kopie}"

# 2. Sprawdzenie czy źródło to faktycznie katalog
if [[ ! -d "$zrodlo" ]]; then
    echo "Błąd: Katalog '$zrodlo' nie istnieje." >&2
    exit 1
fi

# 3. Utworzenie katalogu docelowego, jeśli go nie ma
mkdir -p "$docelowy"

# 4. Przygotowanie nazwy archiwum z datą
data=$(date +%Y-%m-%d-%H%M)
nazwa_bazowa="${zrodlo%/}"
nazwa_bazowa="${nazwa_bazowa##*/}"
archiwum="$docelowy/${nazwa_bazowa}-${data}.tar.gz"

# 5. Tworzenie archiwum
echo "Tworzę kopię..."
tar -czf "$archiwum" "$zrodlo"

# 6. Test integralności
if tar -tzf "$archiwum" >/dev/null; then
    echo "Sukces! Archiwum gotowe: $archiwum"
    du -h "$archiwum"
else
    echo "Błąd podczas testu archiwum!" >&2
    exit 1
fi
