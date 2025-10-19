
# Mattajirs Mobile (Flutter WebView MVP)

Application Android **MVP** pour `mattajirs.com`, basée sur Flutter, avec un **WebView** et une barre d’onglets (Accueil, Boutique, Panier, Compte).  
Objectif : publier rapidement une APK fonctionnelle, puis itérer (recherche, push notifications, offline, etc.).

## Fonctionnalités MVP
- WebView vers le site WordPress/WooCommerce existant
- Barre d’onglets native (Home / Shop / Cart / Account)
- Pull-to-refresh (Android)
- Ouverture des liens externes (WhatsApp, tel:, mailto:) hors WebView
- Gestion du bouton retour Android (navigation interne d’abord, puis sortie)
- CI GitHub Actions pour générer automatiquement une **APK**

> ⚠️ Cette version n’intègre pas (encore) le panier natif via API WooCommerce. Le checkout se fait côté site dans le WebView (fiable et rapide pour un MVP).

---

## Démarrage local (optionnel)
1) Installer Flutter (3.22+ recommandé).  
2) Cloner ce repo puis :
```bash
flutter pub get
flutter run -d android
```
3) Build APK localement :
```bash
flutter build apk --release
```
L’APK se trouvera dans `build/app/outputs/flutter-apk/app-release.apk`.

## CI – GitHub Actions (APK automatique)
- Poussez ce dossier sur un dépôt GitHub.
- Le workflow `.github/workflows/build-android.yml` va :
  - Installer Flutter
  - Construire l’APK release
  - Publier l’artefact téléchargeable dans la page du workflow.

Vous n’avez besoin **d’aucun** secret spécifique pour ce MVP (pas d’API).

## Personnalisation rapide
- Nom & identifiants app : modifiez `android/app/src/main/AndroidManifest.xml` et `applicationId` dans `android/app/build.gradle` **après** avoir généré le squelette via `flutter create` (le workflow s’en charge automatiquement).
- Icône & splash : nous pourrons ajouter `flutter_launcher_icons` et `flutter_native_splash` lors de la prochaine itération.
- Couleurs/brand : ajustez l’`AppBar` et la `BottomNavigationBar` dans `lib/main.dart` (TODO : matcher exactement le marron du logo).

## Roadmap (prochaines itérations)
- Recherche produits & catégories via WooCommerce REST API
- Panier natif + Checkout API (ou Cart Fragments)
- Notifications push (Firebase/OneSignal)
- Mode offline (caching basique)
- TWA (Trusted Web Activity) si le site devient **PWA** (service worker + assetlinks.json)

---

## Structure
```
.
├─ lib/
│  └─ main.dart          # Application Flutter (WebView + tabs)
├─ .github/workflows/
│  └─ build-android.yml  # CI GitHub Actions pour APK
└─ pubspec.yaml
```

## URLs par onglet (à adapter si besoin)
- Accueil : `https://mattajirs.com/`
- Boutique : `https://mattajirs.com/boutique/`
- Panier : `https://mattajirs.com/panier/`
- Compte : `https://mattajirs.com/mon-compte/`

---

## Support fichiers / paiement
Le composant `webview_flutter` gère très bien la majorité des scénarios (paiements intégrés, navigation, cookies).  
Si vous avez des passerelles de paiement spécifiques (Revolut, PayPal, Stripe…) déjà opérationnelles sur le site, elles fonctionneront à l’identique dans l’app.

---

## Licence
Propriété Mattajirs. Utilisation interne autorisée.
