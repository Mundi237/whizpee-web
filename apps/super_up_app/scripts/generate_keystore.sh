#!/bin/bash
# Script pour générer un keystore de production pour Whizpee
# Usage: ./generate_keystore.sh

set -e

echo "🔐 Génération du keystore de production pour Whizpee..."

# Configuration
KEYSTORE_NAME="whizpee-release-key.jks"
KEY_ALIAS="whizpee-release-key"
KEYSTORE_PATH="../android/$KEYSTORE_NAME"

# Vérifier si le keystore existe déjà
if [ -f "$KEYSTORE_PATH" ]; then
    echo "❌ Le keystore existe déjà : $KEYSTORE_PATH"
    read -p "Voulez-vous le remplacer ? (y/N): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Abandon de la génération du keystore."
        exit 1
    fi
    rm "$KEYSTORE_PATH"
fi

# Demander les informations
echo "📋 Veuillez fournir les informations suivantes:"
read -p "Nom complet ou organisation: " DNAME_CN
read -p "Unité organisationnelle: " DNAME_OU
read -p "Organisation: " DNAME_O
read -p "Ville: " DNAME_L
read -p "État/Province: " DNAME_ST
read -p "Code pays (ex: CM): " DNAME_C

read -s -p "Mot de passe du keystore: " STORE_PASSWORD
echo
read -s -p "Confirmez le mot de passe: " STORE_PASSWORD_CONFIRM
echo

if [ "$STORE_PASSWORD" != "$STORE_PASSWORD_CONFIRM" ]; then
    echo "❌ Les mots de passe ne correspondent pas!"
    exit 1
fi

# Générer le keystore
echo "🔧 Génération du keystore..."
keytool -genkey -v \
    -keystore "$KEYSTORE_PATH" \
    -keyalg RSA \
    -keysize 2048 \
    -validity 10000 \
    -alias "$KEY_ALIAS" \
    -dname "CN=$DNAME_CN, OU=$DNAME_OU, O=$DNAME_O, L=$DNAME_L, ST=$DNAME_ST, C=$DNAME_C" \
    -storepass "$STORE_PASSWORD" \
    -keypass "$STORE_PASSWORD"

# Créer le fichier key.properties
KEY_PROPS_PATH="../android/key.properties"
echo "📝 Création du fichier key.properties..."

cat > "$KEY_PROPS_PATH" << EOF
storeFile=$KEYSTORE_NAME
storePassword=$STORE_PASSWORD
keyAlias=$KEY_ALIAS
keyPassword=$STORE_PASSWORD
EOF

echo "✅ Keystore généré avec succès!"
echo "📍 Emplacement: $KEYSTORE_PATH"
echo "📍 Configuration: $KEY_PROPS_PATH"
echo ""
echo "⚠️  IMPORTANT: Sauvegardez ces fichiers en lieu sûr et ne les commitez JAMAIS dans Git!"
echo "⚠️  Ajoutez ces lignes à votre .gitignore:"
echo "android/key.properties"
echo "android/*.jks"
echo "android/*.keystore"
