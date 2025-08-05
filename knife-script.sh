#!/bin/bash
# Script Utility SysAdmin aggiornato con WordPress Tips & MySQLTuner

# ===== Funzioni di servizio =====

search_file() {
    read -rp "Inserire il nome del file da cercare: " file_name
    echo "Cerco il file $file_name..."
    find / -type f -name "$file_name" 2>/dev/null
}

delete_file() {
    read -rp "Inserire il percorso completo del file da cancellare: " file_name
    if [[ -f "$file_name" ]]; then
        rm -f -- "$file_name"
        echo "File $file_name cancellato."
    else
        echo "File non trovato."
    fi
}

search_text() {
    read -rp "Inserire il testo da cercare: " search_text
    echo "Cerco il testo \"$search_text\"..."
    grep -r --color=always -i "$search_text" / 2>/dev/null
}

replace_text() {
    read -rp "Inserire il testo da cercare: " search_text
    read -rp "Inserire il testo di sostituzione: " replace_text
    echo "Sostituisco \"$search_text\" con \"$replace_text\"..."
    grep -rl "$search_text" / 2>/dev/null | xargs sed -i "s/$search_text/$replace_text/g"
}

backup_db() {
    read -rp "Inserire il nome del database: " db_name
    read -rp "Inserire il nome del file di backup: " backup_file
    echo "Eseguo il backup del database $db_name in $backup_file..."
    mysqldump "$db_name" > "$backup_file" && echo "Backup completato."
}

backup_folder() {
    read -rp "Inserire il percorso della cartella: " folder_name
    read -rp "Inserire il nome del file di backup (es. backup.tar.gz): " backup_file
    tar -zcvf "$backup_file" "$folder_name" && echo "Backup completato: $backup_file"
}

search_include() {
    echo "Cerco file .php contenenti \"@include\"..."
    grep -ir --include="*.php" '@include' / 2>/dev/null
}

search_preg_replace() {
    echo "Cerco file .ico contenenti \"preg_replace\"..."
    grep -ir --include="*.ico" 'preg_replace' / 2>/dev/null
}

restart_service() {
    local service_name="$1"
    echo "Riavvio il servizio $service_name..."
    systemctl restart "$service_name" && echo "$service_name riavviato."
}

delete_postfix_queue() {
    echo "Cancello tutte le email dalla coda di Postfix..."
    postsuper -d ALL && echo "Coda Postfix svuotata."
}

# ===== Funzione per comandi dal repository WordPress =====
wordpress_tips() {
    local repo_url="https://github.com/theprincy/Tips-Tricks-and-Hacks-Wordpress.git"
    local repo_dir="/tmp/wp_tips"

    # Clona o aggiorna il repository
    if [ -d "$repo_dir/.git" ]; then
        echo "Aggiorno il repository..."
        git -C "$repo_dir" pull
    else
        echo "Clono il repository..."
        git clone "$repo_url" "$repo_dir"
    fi

    # Trova tutti i file di script
    mapfile -t scripts < <(find "$repo_dir" -type f -name "*.sh" -o -name "*.php")

    if [ ${#scripts[@]} -eq 0 ]; then
        echo "Nessuno script trovato nel repository."
        return
    fi

    echo "=== Script disponibili ==="
    for i in "${!scripts[@]}"; do
        echo "$((i+1)). ${scripts[$i]}"
    done

    read -rp "Scegli uno script da eseguire (numero): " script_choice
    if [[ "$script_choice" =~ ^[0-9]+$ ]] && [ "$script_choice" -ge 1 ] && [ "$script_choice" -le "${#scripts[@]}" ]; then
        selected_script="${scripts[$((script_choice-1))]}"
        echo "Eseguo: $selected_script"
        bash "$selected_script"
    else
        echo "Scelta non valida."
    fi
}

# ===== Funzione per MySQLTuner =====
mysql_tuner() {
    local tuner_url="https://raw.githubusercontent.com/theprincy/MySQLTuner-perl/master/mysqltuner.pl"
    local tuner_path="/tmp/mysqltuner.pl"

    # Scarica o aggiorna lo script
    echo "Scarico/aggiorno MySQLTuner..."
    curl -s -o "$tuner_path" "$tuner_url"
    chmod +x "$tuner_path"

    # Chiede credenziali MySQL
    read -rp "Inserire host MySQL (default: localhost): " host
    read -rp "Inserire username MySQL: " user
    read -srp "Inserire password MySQL: " pass
    echo

    # Esegue lo script
    echo "Eseguo MySQLTuner..."
    perl "$tuner_path" --host "${host:-localhost}" --user "$user" --pass "$pass"
}

# ===== Menu principale =====
while true; do
    clear
    echo "=== Utility SysAdmin ==="
    echo "1) Ricerca di un file"
    echo "2) Cancellazione di un file"
    echo "3) Ricerca testo nei file"
    echo "4) Sostituzione testo nei file"
    echo "5) Ricerca \"@include\" nei .php"
    echo "6) Ricerca \"preg_replace\" nei .ico"
    echo "7) Backup database MySQL"
    echo "8) Backup cartella"
    echo "9) Riavvio Apache2"
    echo "10) Riavvio Nginx"
    echo "11) Riavvio PHP-FPM"
    echo "12) Riavvio Postfix"
    echo "13) Riavvio Dovecot"
    echo "14) Svuotamento coda Postfix"
    echo "15) Comandi dal repository Tips-Tricks-and-Hacks-Wordpress"
    echo "16) Esegui MySQLTuner (Analisi Database)"
    echo "0) Esci"
    read -rp "Scelta: " choice

    case $choice in
        1) search_file ;;
        2) delete_file ;;
        3) search_text ;;
        4) replace_text ;;
        5) search_include ;;
        6) search_preg_replace ;;
        7) backup_db ;;
        8) backup_folder ;;
        9) restart_service apache2 ;;
        10) restart_service nginx ;;
        11) restart_service php7.4-fpm ;; # aggiorna la versione PHP se necessario
        12) restart_service postfix ;;
        13) restart_service dovecot ;;
        14) delete_postfix_queue ;;
        15) wordpress_tips ;;
        16) mysql_tuner ;;
        0) echo "Uscita."; break ;;
        *) echo "Scelta non valida." ;;
    esac

    echo
    read -rp "Premere INVIO per continuare..."
done
