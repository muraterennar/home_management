# 🏡 Home Management

<p align="center">
  <img src="https://fyhidojcaouuqisljhbw.supabase.co/storage/v1/object/sign/home-mangement-base/app_icon.png?token=eyJraWQiOiJzdG9yYWdlLXVybC1zaWduaW5nLWtleV9hZjRiMzE3YS01NWMzLTRiOWItOTg0OC04NWU5YTA5ZDFkYTkiLCJhbGciOiJIUzI1NiJ9.eyJ1cmwiOiJob21lLW1hbmdlbWVudC1iYXNlL2FwcF9pY29uLnBuZyIsImlhdCI6MTc1MTgzMzEzOSwiZXhwIjoyMDY3MTkzMTM5fQ.cSlmOFA8WeeojuBjqWepc9HH1kEdkkWHLSuVIO9b2I8" alt="Uygulama Simgesi" style="border-radius:8px;" width="150" />
</p>

Home Management, kullanıcıların ev işleri, harcamalar ve kaynakları kolayca yönetmesini sağlayan bir
Flutter uygulamasıdır. Uygulama; görev takibi, harcama yönetimi ve aile/ev arkadaşlarıyla iş birliği
gibi özellikler sunar.

---

## ✨ Özellikler

- ✅ Görev yönetimi: Ev işlerini oluşturun, atayın ve takip edin. _(Yakında)_
- 💸 Harcama takibi: Ortak harcamaları kaydedin ve kategorilere ayırın.
- 📦 Kaynak yönetimi: Evdeki stokları ve kaynakları izleyin. _(Yakında)_
- 🔔 Bildirimler: Yaklaşan görevler ve ödemeler için hatırlatıcılar alın. _(Yakında)_
- 👨‍👩‍👧‍👦 Kullanıcı iş birliği: Birden fazla kullanıcı aynı evi yönetebilir.
- 📱 Duyarlı arayüz: Android ve iOS cihazlarda sorunsuz çalışır.

---

## 🚀 Kurulum ve Başlangıç

### 1. Gereksinimler

- [Flutter SDK](https://flutter.dev/docs/get-started/install)
- Dart SDK (Flutter ile birlikte gelir)
- Android Studio veya Xcode (mobil emülatör için)
- Gerçek cihaz veya emülatör

### 2. Projeyi Klonlayın

```bash
git clone https://github.com/muraterennar/home_management.git
cd home_management
```

### 3. Bağımlılıkları Yükleyin

```bash
flutter pub get
```

### 4. Firebase Entegrasyonu

1. [Firebase Console](https://console.firebase.google.com/) üzerinden yeni bir proje oluşturun.
2. Android için `android/app/google-services.json`, iOS için `ios/Runner/GoogleService-Info.plist`
   dosyalarını indirin ve ilgili dizinlere ekleyin.
3. Gerekli paketleri ekleyin:
   ```bash
   dart pub add firebase_core firebase_auth cloud_firestore
   ```
4. `lib/firebase_options.dart` dosyasını oluşturmak için:
   ```bash
   flutterfire configure
   ```
5. `main.dart` dosyanızda Firebase'i başlatın:
   ```dart
   await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
   ```

### 5. Supabase Entegrasyonu

1. [Supabase](https://supabase.com/) üzerinden yeni bir proje oluşturun.
2. Proje ayarlarından `anon` ve `service_role` anahtarlarını alın.
3. Gerekli paketi ekleyin:
   ```bash
   dart pub add supabase_flutter
   ```
4. `lib/services/` altında bir servis dosyası oluşturup anahtarlarınızı burada kullanın:
   ```dart
   final supabase = Supabase.instance.client;
   ```
5. Anahtarlarınızı doğrudan kodda tutmak yerine `.env` veya benzeri bir gizli yapılandırma yöntemi
   kullanın.

### 6. Uygulamayı Çalıştırın

```bash
flutter run
```

---

## 📁 Klasör Yapısı

```
home_management/
├── lib/
│   ├── main.dart           # Uygulama giriş noktası
│   ├── models/             # Veri modelleri
│   ├── screens/            # Ekranlar
│   ├── widgets/            # Tekrar kullanılabilir bileşenler
│   ├── services/           # Servisler ve iş mantığı
├── assets/                 # Görseller, fontlar vb.
├── pubspec.yaml            # Bağımlılıklar ve varlıklar
└── README.md               # Dokümantasyon
```

---

## 📝 Kullanım

1. Uygulamayı cihazınızda veya emülatörde başlatın.
2. Kayıt olun veya giriş yapın.
3. Ev üyelerini ekleyin, görev ve harcama oluşturun.
4. Gösterge panelinden ilerlemeyi ve bildirimleri takip edin.

---

## ⚠️ Güvenlik ve Gizlilik

- `google-services.json`, `firebase_options.dart`, Supabase anahtarları gibi hassas dosyaları asla
  herkese açık şekilde paylaşmayın.
- Bu dosyaları `.gitignore` dosyanıza ekleyin ve versiyon kontrolüne dahil etmeyin.
- Ortam değişkenleri veya güvenli bir yapılandırma yöntemi kullanarak anahtarlarınızı gizli tutun.

---

## 🤝 Katkı Sağlama

Katkılarınızı bekliyoruz! Lütfen şu adımları izleyin:

1. Repoyu çatallayın (fork).
2. Yeni bir dal oluşturun: `git checkout -b feature/ozellik-adi`
3. Değişikliklerinizi kaydedin: `git commit -m 'Özellik eklendi'`
4. Dalı gönderin: `git push origin feature/ozellik-adi`
5. Pull request açın.

---

## 📄 Lisans

Bu proje MIT lisansı ile lisanslanmıştır. Ayrıntılar için [LICENSE](LICENSE) dosyasına
bakabilirsiniz.
