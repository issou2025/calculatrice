# Calculatrice Flutter

Application mobile Android simple, moderne et fonctionnelle créée avec Flutter.

## Fonctions

- Addition
- Soustraction
- Multiplication
- Division
- Pourcentage
- Changement de signe
- Suppression du dernier chiffre
- Réinitialisation complète

## Génération automatique de l'APK

Ce dépôt contient un workflow GitHub Actions :

```text
.github/workflows/build-apk.yml
```

À chaque modification sur la branche `main`, GitHub compile automatiquement l'application Android.

## Télécharger l'APK

1. Ouvrir le dépôt GitHub.
2. Aller dans l'onglet **Actions**.
3. Cliquer sur le dernier workflow **Build APK**.
4. Descendre dans la partie **Artifacts**.
5. Télécharger **calculatrice-release-apk**.
6. Extraire le fichier ZIP.
7. Installer `app-release.apk` sur le téléphone Android.

## Compilation locale

```bash
flutter pub get
flutter create . --platforms=android --project-name calculatrice
flutter build apk --release
```

Le fichier APK sera généré ici :

```text
build/app/outputs/flutter-apk/app-release.apk
```
