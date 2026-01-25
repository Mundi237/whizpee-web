#!/bin/bash
# Script de validation pré-build pour Whizpee
# Vérifie tous les prérequis avant de lancer le build de release

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

APP_PATH="/home/nce/StudioProjects/whizpee/apps/super_up_app"
ERRORS=0
WARNINGS=0

log_info() { echo -e "${BLUE}ℹ️  $1${NC}"; }
log_success() { echo -e "${GREEN}✅ $1${NC}"; }
log_warning() { echo -e "${YELLOW}⚠️  $1${NC}"; ((WARNINGS++)); }
log_error() { echo -e "${RED}❌ $1${NC}"; ((ERRORS++)); }

echo -e "${BLUE}🔍 Validation pré-build pour Whizpee${NC}"
echo "========================================"

# 1. Vérification de l'environnement Flutter
log_info "Vérification de l'environnement Flutter..."
if command -v flutter &> /dev/null; then
    FLUTTER_VERSION=$(flutter --version | head -n1)
    log_success "Flutter installé: $FLUTTER_VERSION"
    
    # Vérifier la version minimale
    FLUTTER_VERSION_NUM=$(flutter --version | head -n1 | grep -o '[0-9]\+\.[0-9]\+\.[0-9]\+' | head -n1)
    if [[ $(echo "$FLUTTER_VERSION_NUM 3.0.5" | tr ' ' '\n' | sort -V | head -n1) == "3.0.5" ]]; then
        log_success "Version Flutter compatible (≥3.0.5)"
    else
        log_warning "Version Flutter potentiellement incompatible: $FLUTTER_VERSION_NUM (recommandé: ≥3.0.5)"
    fi
else
    log_error "Flutter n'est pas installé ou pas dans le PATH"
fi

# 2. Vérification de l'environnement Android
log_info "Vérification de l'environnement Android..."
if [ -n "$ANDROID_HOME" ]; then
    log_success "ANDROID_HOME défini: $ANDROID_HOME"
else
    log_error "Variable ANDROID_HOME non définie"
fi

if command -v java &> /dev/null; then
    JAVA_VERSION=$(java -version 2>&1 | head -n1)
    log_success "Java installé: $JAVA_VERSION"
else
    log_error "Java n'est pas installé ou pas dans le PATH"
fi

# 3. Vérification des fichiers de configuration
log_info "Vérification des fichiers de configuration..."

# Vérifier pubspec.yaml
if [ -f "$APP_PATH/pubspec.yaml" ]; then
    log_success "pubspec.yaml trouvé"
    
    # Vérifier la version
    VERSION=$(grep "version:" "$APP_PATH/pubspec.yaml" | cut -d' ' -f2)
    if [ -n "$VERSION" ]; then
        log_success "Version détectée: $VERSION"
    else
        log_warning "Version non détectée dans pubspec.yaml"
    fi
else
    log_error "pubspec.yaml manquant"
fi

# Vérifier key.properties
if [ -f "$APP_PATH/android/key.properties" ]; then
    log_success "Fichier key.properties trouvé"
    
    # Vérifier le contenu
    if grep -q "storeFile" "$APP_PATH/android/key.properties"; then
        KEYSTORE_FILE=$(grep "storeFile" "$APP_PATH/android/key.properties" | cut -d'=' -f2)
        if [ -f "$APP_PATH/android/$KEYSTORE_FILE" ]; then
            log_success "Keystore trouvé: $KEYSTORE_FILE"
        else
            log_error "Keystore introuvable: $KEYSTORE_FILE"
        fi
    else
        log_error "Configuration storeFile manquante dans key.properties"
    fi
else
    log_error "Fichier key.properties manquant (exécutez generate_keystore.sh)"
fi

# Vérifier AndroidManifest.xml
if [ -f "$APP_PATH/android/app/src/main/AndroidManifest.xml" ]; then
    log_success "AndroidManifest.xml trouvé"
    
    # Vérifier les permissions critiques
    MANIFEST="$APP_PATH/android/app/src/main/AndroidManifest.xml"
    CRITICAL_PERMS=("INTERNET" "CAMERA" "RECORD_AUDIO" "READ_EXTERNAL_STORAGE")
    
    for perm in "${CRITICAL_PERMS[@]}"; do
        if grep -q "android.permission.$perm" "$MANIFEST"; then
            log_success "Permission $perm configurée"
        else
            log_warning "Permission $perm manquante"
        fi
    done
else
    log_error "AndroidManifest.xml manquant"
fi

# 4. Vérification des dépendances
log_info "Vérification des dépendances..."
cd "$APP_PATH"

# Flutter pub get
if flutter pub get &> /dev/null; then
    log_success "Dépendances Flutter récupérées"
else
    log_error "Échec de récupération des dépendances Flutter"
fi

# Vérifier les dépendances critiques
CRITICAL_DEPS=("firebase_core" "firebase_messaging" "v_chat_sdk_core" "super_up_core")
for dep in "${CRITICAL_DEPS[@]}"; do
    if grep -q "$dep:" "pubspec.yaml"; then
        log_success "Dépendance critique $dep trouvée"
    else
        log_warning "Dépendance critique $dep manquante"
    fi
done

# 5. Vérification des assets
log_info "Vérification des assets..."
if [ -d "$APP_PATH/assets" ]; then
    log_success "Dossier assets trouvé"
    
    # Vérifier les assets critiques
    if [ -f "$APP_PATH/assets/logo.png" ]; then
        log_success "Logo de l'app trouvé"
    else
        log_warning "Logo de l'app manquant (assets/logo.png)"
    fi
else
    log_warning "Dossier assets manquant"
fi

# 6. Vérification de l'espace disque
log_info "Vérification de l'espace disque..."
AVAILABLE_SPACE=$(df "$APP_PATH" | awk 'NR==2 {print $4}')
REQUIRED_SPACE=1048576  # 1GB en KB

if [ "$AVAILABLE_SPACE" -gt "$REQUIRED_SPACE" ]; then
    log_success "Espace disque suffisant ($(( AVAILABLE_SPACE / 1024 / 1024 ))GB disponible)"
else
    log_warning "Espace disque limité ($(( AVAILABLE_SPACE / 1024 / 1024 ))GB disponible, 1GB recommandé)"
fi

# 7. Vérification de la connectivité réseau
log_info "Vérification de la connectivité réseau..."
if ping -c 1 google.com &> /dev/null; then
    log_success "Connectivité réseau OK"
else
    log_warning "Problème de connectivité réseau détecté"
fi

# 8. Test de compilation rapide
log_info "Test de compilation rapide..."
if flutter build apk --debug --target-platform android-arm64 &> /dev/null; then
    log_success "Compilation test réussie"
    rm -f "$APP_PATH/build/app/outputs/flutter-apk/app-debug.apk" 2>/dev/null
else
    log_error "Échec de compilation test"
fi

# 9. Vérification Git (optionnel)
log_info "Vérification Git..."
cd "$APP_PATH"
if git status &> /dev/null; then
    if [ -z "$(git status --porcelain)" ]; then
        log_success "Répertoire Git propre"
    else
        log_warning "Modifications non commitées détectées"
        git status --short
    fi
    
    CURRENT_BRANCH=$(git branch --show-current 2>/dev/null || echo "N/A")
    log_info "Branche actuelle: $CURRENT_BRANCH"
else
    log_warning "Pas un répertoire Git ou Git non installé"
fi

# Résumé final
echo ""
echo "========================================"
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}🎉 VALIDATION RÉUSSIE! Prêt pour le build de release.${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}⚠️  VALIDATION OK AVEC AVERTISSEMENTS ($WARNINGS avertissements)${NC}"
    echo -e "${YELLOW}Le build peut continuer mais vérifiez les avertissements ci-dessus.${NC}"
    exit 0
else
    echo -e "${RED}❌ VALIDATION ÉCHOUÉE! ($ERRORS erreurs, $WARNINGS avertissements)${NC}"
    echo -e "${RED}Corrigez les erreurs avant de continuer le build.${NC}"
    exit 1
fi
