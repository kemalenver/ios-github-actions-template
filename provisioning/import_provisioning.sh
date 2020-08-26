#!/bin/sh

# To encrypt a file, use this: 
# brew install gnupg
# gpg --symmetric --cipher-algo AES256 my_secret_file.xxx

# Decrypt the files
# --batch to prevent interactive command --yes to assume "yes" for questions
gpg --quiet --batch --yes --decrypt --passphrase="$PROVISIONING_PASSWORD" --output provisioning/AppStoreCertificates.p12 provisioning/AppStoreCertificates.p12.gpg
gpg --quiet --batch --yes --decrypt --passphrase="$PROVISIONING_PASSWORD" --output provisioning/release.mobileprovision provisioning/appstorexcodeactionssetup.mobileprovision.gpg

mkdir -p ~/Library/MobileDevice/Provisioning\ Profiles

echo "List profiles"
ls ~/Library/MobileDevice/Provisioning\ Profiles/
echo "Move profiles"
cp provisioning/*.mobileprovision ~/Library/MobileDevice/Provisioning\ Profiles/
echo "List profiles"
ls ~/Library/MobileDevice/Provisioning\ Profiles/

security create-keychain -p "" build.keychain
security import provisioning/AppStoreCertificates.p12 -t agg -k ~/Library/Keychains/build.keychain -P "$PROVISIONING_PASSWORD" -A

security list-keychains -s ~/Library/Keychains/build.keychain
security default-keychain -s ~/Library/Keychains/build.keychain
security unlock-keychain -p "" ~/Library/Keychains/build.keychain
security set-key-partition-list -S apple-tool:,apple: -s -k "" ~/Library/Keychains/build.keychain
