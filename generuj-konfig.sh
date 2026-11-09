#!/usr/bin/env bash

if [[ $# -lt 1 ]]; then
    echo "Użycie: ${0##*/} <dev|stage|prod>" >&2
    exit 2
fi

srodowisko="$1"

# Dobór wartości przez case
case "$srodowisko" in
    dev)   db_host="localhost" ;;
    stage) db_host="stage.baza.lan" ;;
    prod)  db_host="prod.baza.lan" ;;
    *)     echo "Nieznane środowisko: $srodowisko" >&2; exit 2 ;;
esac

# 1. Plik konfiguracyjny z podstawianiem zmiennych
cat > app.env <<EOF
SRODOWISKO=$srodowisko
DB_HOST=$db_host
DATA_UTWORZENIA=$(date +%Y-%m-%d)
EOF

# 2. Skrypt startowy bez podstawiania zmiennych
cat > start.sh <<'EOF'
#!/usr/bin/env bash
echo "Uruchamiam aplikację..."
echo "Mój argument to: $1"
echo "Zmienna robocza: ${ZMIENNA:-domyslna}"
EOF

chmod +x start.sh
echo "Wygenerowano app.env oraz start.sh dla środowiska: $srodowisko"
