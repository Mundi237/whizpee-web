#!/bin/bash
# Script automatisé pour générer une release Android de Whizpee
# Usage: ./build_release.sh [version] [build_number]

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
PROJECT_NAME="Whizpee"
APP_PATH="/home/nce/StudioProjects/whizpee/apps/super_up_app"
OUTPUT_DIR="$APP_PATH/releases"

# Functions
log_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

log_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

log_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

log_error() {
    echo -e "${RED}❌ $1${NC}"
}

print_header() {
    echo -e "${BLUE}"
    echo "=========================================="
    echo "🚀 $PROJECT_NAME - Build Release Android"
    echo "=========================================="
    echo -e "${NC}"
}

# Vérification des prérequis
check_prerequisites() {
    log_info "Vérification des prérequis..."
    
    # Vérifier Flutter
    if ! command -v flutter &> /dev/null; then
        log_error "Flutter n'est pas installé ou pas dans le PATH"
        exit 1
    fi
    
    # Vérifier Java
    if ! command -v java &> /dev/null; then
        log_error "Java n'est pas installé ou pas dans le PATH"
        exit 1
    fi
    
    # Vérifier le keystore
    if [ ! -f "$APP_PATH/android/key.properties" ]; then
        log_error "Fichier key.properties manquant. Exécutez d'abord generate_keystore.sh"
        exit 1
    fi
    
    log_success "Tous les prérequis sont satisfaits"
}

# Nettoyage des builds précédents
clean_build() {
    log_info "Nettoyage des builds précédents..."
    cd "$APP_PATH"
    flutter clean
    rm -rf build/
    log_success "Nettoyage terminé"
}

# Récupération des dépendances
get_dependencies() {
    log_info "Récupération des dépendances..."
    cd "$APP_PATH"
    flutter pub get
    log_success "Dépendances récupérées"
}

# Mise à jour de la version
update_version() {
    local version=$1
    local build_number=$2
    
    if [ -n "$version" ] && [ -n "$build_number" ]; then
        log_info "Mise à jour de la version vers $version+$build_number"
        cd "$APP_PATH"
        
        # Sauvegarder l'ancien pubspec.yaml
        cp pubspec.yaml pubspec.yaml.backup
        
        # Mettre à jour la version
        sed -i "s/version: .*/version: $version+$build_number/" pubspec.yaml
        
        log_success "Version mise à jour"
    else
        log_warning "Version non spécifiée, utilisation de la version actuelle"
    fi
}

# Analyse statique du code
analyze_code() {
    log_info "Analyse statique du code..."
    cd "$APP_PATH"
    
    # Flutter analyze
    if flutter analyze; then
        log_success "Analyse statique réussie"
    else
        log_warning "Des avertissements ont été détectés lors de l'analyse"
        read -p "Continuer malgré les avertissements ? (y/N): " -n 1 -r
        echo
        if [[ ! $REPLY =~ ^[Yy]$ ]]; then
            log_error "Build annulé par l'utilisateur"
            exit 1
        fi
    fi
}

# Tests automatisés
run_tests() {
    log_info "Exécution des tests..."
    cd "$APP_PATH"
    
    if [ -d "test" ] && [ "$(ls -A test)" ]; then
        if flutter test; then
            log_success "Tous les tests sont passés"
        else
            log_error "Des tests ont échoué"
            read -p "Continuer malgré les échecs de tests ? (y/N): " -n 1 -r
            echo
            if [[ ! $REPLY =~ ^[Yy]$ ]]; then
                exit 1
            fi
        fi
    else
        log_warning "Aucun test trouvé, passage de cette étape"
    fi
}

# Build de la release
build_release() {
    log_info "Construction de la release Android..."
    cd "$APP_PATH"
    
    # Build des différents formats
    log_info "🔨 Build APK..."
    flutter build apk --release --no-tree-shake-icons
    
    log_info "🔨 Build App Bundle (AAB)..."
    flutter build appbundle --release --no-tree-shake-icons
    
    log_success "Build terminé avec succès"
}

# Organisation des fichiers de sortie
organize_output() {
    log_info "Organisation des fichiers de sortie..."
    
    # Créer le dossier de sortie avec timestamp
    TIMESTAMP=$(date "+%Y%m%d_%H%M%S")
    local current_version=$(grep "version:" "$APP_PATH/pubspec.yaml" | cut -d' ' -f2)
    RELEASE_DIR="$OUTPUT_DIR/release_${current_version}_$TIMESTAMP"
    
    mkdir -p "$RELEASE_DIR"
    
    # Copier les fichiers de build
    cp "$APP_PATH/build/app/outputs/flutter-apk/app-release.apk" "$RELEASE_DIR/whizpee-v${current_version}.apk"
    cp "$APP_PATH/build/app/outputs/bundle/release/app-release.aab" "$RELEASE_DIR/whizpee-v${current_version}.aab"
    
    # Créer un fichier de métadonnées
    cat > "$RELEASE_DIR/build_info.txt" << EOF
🚀 Whizpee Release Build Information
=====================================

Version: $current_version
Build Date: $(date)
Build Machine: $(hostname)
Flutter Version: $(flutter --version | head -n1)
Git Commit: $(cd "$APP_PATH" && git rev-parse HEAD 2>/dev/null || echo "N/A")
Git Branch: $(cd "$APP_PATH" && git branch --show-current 2>/dev/null || echo "N/A")

Files Generated:
- whizpee-v${current_version}.apk (APK for direct installation)
- whizpee-v${current_version}.aab (App Bundle for Play Store)

APK Size: $(du -h "$RELEASE_DIR/whizpee-v${current_version}.apk" | cut -f1)
AAB Size: $(du -h "$RELEASE_DIR/whizpee-v${current_version}.aab" | cut -f1)
EOF
    
    log_success "Fichiers organisés dans: $RELEASE_DIR"
    return 0
}

# Vérification post-build
verify_build() {
    log_info "Vérification du build..."
    
    local apk_file="$RELEASE_DIR/whizpee-v${current_version}.apk"
    local aab_file="$RELEASE_DIR/whizpee-v${current_version}.aab"
    
    # Vérifier que les fichiers existent et ne sont pas vides
    if [ -f "$apk_file" ] && [ -s "$apk_file" ]; then
        log_success "APK généré avec succès ($(du -h "$apk_file" | cut -f1))"
    else
        log_error "Échec de génération de l'APK"
        return 1
    fi
    
    if [ -f "$aab_file" ] && [ -s "$aab_file" ]; then
        log_success "AAB généré avec succès ($(du -h "$aab_file" | cut -f1))"
    else
        log_error "Échec de génération de l'AAB"
        return 1
    fi
    
    # Afficher les informations sur l'APK
    log_info "Informations de l'APK:"
    aapt dump badging "$apk_file" | head -n 5 || true
}

# Nettoyage final
cleanup() {
    log_info "Nettoyage final..."
    cd "$APP_PATH"
    
    # Restaurer le pubspec.yaml si une sauvegarde existe
    if [ -f "pubspec.yaml.backup" ]; then
        mv pubspec.yaml.backup pubspec.yaml
        log_info "Version restaurée"
    fi
    
    log_success "Nettoyage terminé"
}

# Fonction principale
main() {
    print_header
    
    local version=$1
    local build_number=$2
    
    # Vérification des arguments
    if [ -n "$version" ] && [ -z "$build_number" ]; then
        log_error "Si vous spécifiez une version, vous devez aussi spécifier un numéro de build"
        log_info "Usage: $0 [version] [build_number]"
        log_info "Exemple: $0 1.0.2 12"
        exit 1
    fi
    
    # Exécution séquentielle
    check_prerequisites
    clean_build
    get_dependencies
    update_version "$version" "$build_number"
    analyze_code
    run_tests
    build_release
    organize_output
    verify_build
    cleanup
    
    # Résumé final
    echo -e "${GREEN}"
    echo "=========================================="
    echo "🎉 BUILD RELEASE TERMINÉ AVEC SUCCÈS!"
    echo "=========================================="
    echo -e "${NC}"
    echo "📦 Fichiers générés dans: $RELEASE_DIR"
    echo "📱 APK: whizpee-v${current_version}.apk"
    echo "🏪 AAB: whizpee-v${current_version}.aab"
    echo ""
    echo "📋 Prochaines étapes:"
    echo "1. Testez l'APK sur différents appareils"
    echo "2. Uploadez l'AAB sur Google Play Console"
    echo "3. Configurez les métadonnées du store si nécessaire"
    
    # Ouvrir le dossier de sortie
    if command -v xdg-open &> /dev/null; then
        xdg-open "$RELEASE_DIR" &>/dev/null &
    fi
}

# Trap pour le nettoyage en cas d'interruption
trap cleanup EXIT

# Exécution
main "$@"
