#!/bin/bash
# Script de déploiement automatique vers les stores
# Supporte Google Play Store et distribution directe

set -e

# Configuration
APP_PATH="/home/nce/StudioProjects/whizpee/apps/super_up_app"
UPLOAD_PATH="$APP_PATH/uploads"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; }
log_error() { echo -e "${RED}❌ $1${NC}"; }

print_header() {
    echo -e "${BLUE}"
    echo "============================================"
    echo "🚀 Whizpee - Déploiement vers les Stores"
    echo "============================================"
    echo -e "${NC}"
}

# Fonction pour préparer les métadonnées du store
prepare_store_metadata() {
    log_info "Préparation des métadonnées du store..."
    
    mkdir -p "$UPLOAD_PATH/metadata/fr-FR"
    mkdir -p "$UPLOAD_PATH/metadata/en-US"
    mkdir -p "$UPLOAD_PATH/screenshots"
    
    # Créer les fichiers de métadonnées
    cat > "$UPLOAD_PATH/metadata/fr-FR/title.txt" << 'EOF'
Whizpee - Messagerie et Annonces
EOF

    cat > "$UPLOAD_PATH/metadata/fr-FR/short_description.txt" << 'EOF'
Application de messagerie instantanée avec système d'annonces intégré pour le Cameroun
EOF

    cat > "$UPLOAD_PATH/metadata/fr-FR/full_description.txt" << 'EOF'
🌟 Whizpee - La nouvelle façon de communiquer et de vendre au Cameroun!

📱 FONCTIONNALITÉS PRINCIPALES:
• Messagerie instantanée sécurisée avec chiffrement de bout en bout
• Appels vocaux et vidéo de haute qualité
• Système d'annonces classées intégré
• Stories éphémères pour partager vos moments
• Géolocalisation des annonces par ville
• Système de crédits pour contacter les vendeurs

💬 MESSAGERIE AVANCÉE:
• Messages texte, photos, vidéos et fichiers
• Groupes et diffusions
• Réactions aux messages
• Indicateurs de lecture
• Mode sombre élégant

🛍️ MARKETPLACE INTÉGRÉ:
• Publiez vos annonces facilement
• Système de boost pour plus de visibilité
• Filtrage par catégorie et localisation
• Contact direct via chat sécurisé
• Système anti-spam avec crédits

🔒 SÉCURITÉ ET CONFIDENTIALITÉ:
• Chiffrement de bout en bout
• Contrôles de confidentialité avancés
• Signalement et blocage d'utilisateurs
• Données stockées localement

🌍 SPÉCIALEMENT CONÇU POUR LE CAMEROUN:
• Interface en français
• Villes et quartiers du Cameroun
• Adapté aux besoins locaux
• Support client local

Rejoignez la révolution Whizpee dès aujourd'hui!
EOF

    cat > "$UPLOAD_PATH/metadata/en-US/title.txt" << 'EOF'
Whizpee - Chat & Classifieds
EOF

    cat > "$UPLOAD_PATH/metadata/en-US/short_description.txt" << 'EOF'
Instant messaging app with integrated classifieds system for Cameroon
EOF

    log_success "Métadonnées du store préparées"
}

# Fonction pour valider l'AAB
validate_aab() {
    local aab_file="$1"
    
    log_info "Validation de l'App Bundle..."
    
    if [ ! -f "$aab_file" ]; then
        log_error "Fichier AAB introuvable: $aab_file"
        return 1
    fi
    
    # Vérifier la signature
    if jarsigner -verify "$aab_file" &>/dev/null; then
        log_success "App Bundle correctement signé"
    else
        log_error "App Bundle non signé ou signature invalide"
        return 1
    fi
    
    # Afficher les informations sur l'AAB
    log_info "Informations sur l'App Bundle:"
    bundletool build-apks --bundle="$aab_file" --output=temp.apks --mode=universal &>/dev/null || true
    if [ -f "temp.apks" ]; then
        log_success "App Bundle valide"
        rm -f temp.apks
    fi
    
    return 0
}

# Fonction pour créer la release GitHub
create_github_release() {
    local version="$1"
    local apk_file="$2"
    local aab_file="$3"
    
    log_info "Création de la release GitHub..."
    
    # Vérifier si gh CLI est installé
    if ! command -v gh &> /dev/null; then
        log_warning "GitHub CLI (gh) n'est pas installé, sautant la release GitHub"
        return 0
    fi
    
    # Créer la release
    cd "$APP_PATH"
    
    local release_notes="## 🚀 Whizpee v$version

### ✨ Nouveautés
- Améliorations de performance
- Corrections de bugs
- Optimisations de l'interface utilisateur

### 📱 Téléchargements
- **APK Android**: Pour installation directe
- **App Bundle**: Pour Google Play Store

### 🔧 Notes techniques
- Version minimum d'Android: 5.0 (API 21)
- Taille approximative: $(du -h "$apk_file" | cut -f1 2>/dev/null || echo "N/A")
- Architecture: ARM64, ARM32, x86_64

### 🐛 Corrections de bugs
- Amélioration de la stabilité des appels
- Optimisation des notifications
- Corrections mineures de l'interface"

    if gh release create "v$version" \
        "$apk_file#Whizpee-v$version.apk" \
        "$aab_file#Whizpee-v$version.aab" \
        --title "Whizpee v$version" \
        --notes "$release_notes"; then
        log_success "Release GitHub créée avec succès"
    else
        log_warning "Échec de création de la release GitHub"
    fi
}

# Fonction pour uploader vers Google Play
upload_to_play_store() {
    local aab_file="$1"
    
    log_info "Préparation pour Google Play Store..."
    
    # Créer le dossier de préparation
    mkdir -p "$UPLOAD_PATH/playstore"
    
    # Copier l'AAB
    cp "$aab_file" "$UPLOAD_PATH/playstore/"
    
    # Créer les instructions d'upload
    cat > "$UPLOAD_PATH/playstore/UPLOAD_INSTRUCTIONS.md" << 'EOF'
# Instructions d'upload Google Play Store

## Étapes à suivre:

1. **Connectez-vous à Google Play Console:**
   - Allez sur https://play.google.com/console
   - Sélectionnez l'app Whizpee

2. **Créez une nouvelle version:**
   - Allez dans "Production" → "Créer une version"
   - Uploadez le fichier .aab
   - Ajoutez les notes de version

3. **Configurez les métadonnées:**
   - Utilisez les fichiers du dossier metadata/
   - Ajoutez les captures d'écran
   - Vérifiez la fiche du store

4. **Tests et validation:**
   - Lancez les tests internes
   - Vérifiez la compatibilité des appareils
   - Validez les permissions

5. **Publication:**
   - Soumettez pour révision
   - Attendez l'approbation (1-3 jours)
   - Publiez en production

## Notes importantes:
- Version minimum: Android 5.0 (API 21)
- Permissions sensibles: Caméra, Microphone, Contacts
- Taille de l'app: Optimisée avec App Bundle
- Chiffrement: Oui (déclaration requise)
EOF
    
    log_success "Fichiers préparés pour Google Play Store dans: $UPLOAD_PATH/playstore/"
    log_info "Suivez les instructions dans UPLOAD_INSTRUCTIONS.md"
}

# Fonction pour créer un package de distribution
create_distribution_package() {
    local version="$1"
    local apk_file="$2"
    local aab_file="$3"
    
    log_info "Création du package de distribution..."
    
    local dist_dir="$UPLOAD_PATH/distribution_v$version"
    mkdir -p "$dist_dir"
    
    # Copier les fichiers
    cp "$apk_file" "$dist_dir/"
    cp "$aab_file" "$dist_dir/"
    
    # Créer le fichier README
    cat > "$dist_dir/README.md" << EOF
# Whizpee v$version - Package de Distribution

## 📦 Contenu du package
- \`$(basename "$apk_file")\` - APK pour installation directe
- \`$(basename "$aab_file")\` - App Bundle pour Google Play Store
- \`checksums.txt\` - Sommes de contrôle pour vérification d'intégrité

## 📱 Installation APK
1. Activez "Sources inconnues" dans les paramètres Android
2. Téléchargez et installez le fichier APK
3. Accordez les permissions nécessaires

## 🔒 Vérification d'intégrité
Vérifiez les sommes de contrôle avec:
\`\`\`bash
sha256sum -c checksums.txt
\`\`\`

## ℹ️ Informations techniques
- **Version**: $version
- **Taille APK**: $(du -h "$apk_file" | cut -f1)
- **Taille AAB**: $(du -h "$aab_file" | cut -f1)
- **Date de build**: $(date)
- **Android minimum**: 5.0 (API 21)
- **Architectures**: ARM64, ARM32, x86_64

## 🆘 Support
- Email: support@whizpee.com
- Site web: https://whizpee.com
EOF

    # Créer les checksums
    cd "$dist_dir"
    sha256sum "$(basename "$apk_file")" "$(basename "$aab_file")" > checksums.txt
    
    # Créer l'archive
    cd "$UPLOAD_PATH"
    tar -czf "whizpee_v${version}_distribution.tar.gz" "distribution_v$version"
    
    log_success "Package de distribution créé: whizpee_v${version}_distribution.tar.gz"
}

# Fonction principale
main() {
    print_header
    
    # Vérifier les arguments
    if [ $# -lt 1 ]; then
        log_error "Usage: $0 <release_directory> [--github] [--playstore] [--all]"
        log_info "Exemple: $0 /path/to/releases/release_1.0.1+11_20241201_120000"
        exit 1
    fi
    
    local release_dir="$1"
    shift
    
    # Options
    local deploy_github=false
    local deploy_playstore=false
    local create_dist=true
    
    while [[ $# -gt 0 ]]; do
        case $1 in
            --github)
                deploy_github=true
                shift
                ;;
            --playstore)
                deploy_playstore=true
                shift
                ;;
            --all)
                deploy_github=true
                deploy_playstore=true
                shift
                ;;
            *)
                log_warning "Option inconnue: $1"
                shift
                ;;
        esac
    done
    
    # Vérifier que le dossier de release existe
    if [ ! -d "$release_dir" ]; then
        log_error "Dossier de release introuvable: $release_dir"
        exit 1
    fi
    
    # Trouver les fichiers APK et AAB
    local apk_file=$(find "$release_dir" -name "*.apk" | head -n1)
    local aab_file=$(find "$release_dir" -name "*.aab" | head -n1)
    
    if [ -z "$apk_file" ] || [ -z "$aab_file" ]; then
        log_error "Fichiers APK ou AAB introuvables dans $release_dir"
        exit 1
    fi
    
    # Extraire la version
    local version=$(basename "$apk_file" | sed 's/whizpee-v\(.*\)\.apk/\1/')
    
    log_info "Déploiement de Whizpee v$version"
    log_info "APK: $(basename "$apk_file")"
    log_info "AAB: $(basename "$aab_file")"
    
    # Créer le dossier d'upload
    mkdir -p "$UPLOAD_PATH"
    
    # Préparer les métadonnées
    prepare_store_metadata
    
    # Valider l'AAB
    validate_aab "$aab_file"
    
    # Déploiements selon les options
    if [ "$create_dist" = true ]; then
        create_distribution_package "$version" "$apk_file" "$aab_file"
    fi
    
    if [ "$deploy_github" = true ]; then
        create_github_release "$version" "$apk_file" "$aab_file"
    fi
    
    if [ "$deploy_playstore" = true ]; then
        upload_to_play_store "$aab_file"
    fi
    
    # Résumé final
    echo -e "${GREEN}"
    echo "================================================"
    echo "🎉 DÉPLOIEMENT TERMINÉ AVEC SUCCÈS!"
    echo "================================================"
    echo -e "${NC}"
    echo "📁 Fichiers de déploiement: $UPLOAD_PATH"
    
    if [ "$deploy_github" = true ]; then
        echo "🐙 Release GitHub créée"
    fi
    
    if [ "$deploy_playstore" = true ]; then
        echo "🏪 Prêt pour Google Play Store"
    fi
    
    echo "📦 Package de distribution créé"
    echo ""
    echo "📋 Prochaines étapes recommandées:"
    echo "1. Testez l'APK sur plusieurs appareils"
    echo "2. Vérifiez les métadonnées du store"
    echo "3. Préparez les captures d'écran"
    echo "4. Lancez la campagne de communication"
}

# Exécution
main "$@"
