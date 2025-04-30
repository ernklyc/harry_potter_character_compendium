# Harry Potter Character Compendium

# Harry Potter Karakter & Büyü Ansiklopedisi

Bu Flutter uygulaması, Harry Potter evrenindeki karakterler ve büyüler hakkında bilgi sunan bir mobil ansiklopedidir. Kullanıcılar karakterleri ve büyüleri listeleyebilir, detaylarını görüntüleyebilir, favorilerine ekleyebilir ve çeşitli kriterlere göre filtreleme ve arama yapabilirler.

## ✨ Özellikler

*   **Karakter Listeleme:** Tüm karakterleri, Hogwarts öğrencilerini ve personelini ayrı sekmelerde görüntüleme.
*   **Karakter Detayları:** Seçilen karakterin detaylı bilgilerini (ev, tür, doğum tarihi, asa bilgileri, aktör vb.) görme.
*   **Karakter Filtreleme:** Karakterleri evlerine, türlerine, cinsiyetlerine ve soy bilgilerine göre filtreleme.
*   **Karakter Arama:** Karakterleri isme göre arama.
*   **Büyü Listeleme:** Harry Potter evrenindeki büyüleri ve açıklamalarını listeleme.
*   **Büyü Arama:** Büyüleri isme veya açıklamasına göre arama.
*   **Favoriler:** Beğenilen karakterleri ve büyüleri favorilere ekleyip ayrı bir ekranda görüntüleme.
*   **Dil Desteği:** Türkçe ve İngilizce dil seçenekleri arasında geçiş yapma.
*   **Tema:** Harry Potter evrenine uygun, dinamik (Açık/Koyu Mod) ve özelleştirilmiş tema.
*   **Animasyonlar:** Akıcı kullanıcı deneyimi için çeşitli arayüz animasyonları.
*   **Resim Önbellekleme:** Karakter resimlerini verimli bir şekilde yüklemek ve göstermek için önbellekleme.

## 📸 Ekran Görüntüleri

Uygulamanın çeşitli ekranlarına ait görünümler:

| Açılış & Karakterler | Karakter Detayı | Büyü Listesi |
| :------------------: | :-------------: | :----------: |
| ![Ekran Görüntüsü 1](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/1.jpg) | ![Ekran Görüntüsü 2](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/2.jpg) | ![Ekran Görüntüsü 3](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/3.jpg) |
| ![Ekran Görüntüsü 4](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/3.1.jpg) | ![Ekran Görüntüsü 5](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/4.jpg) | ![Ekran Görüntüsü 6](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/5.jpg) |
| ![Ekran Görüntüsü 7](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/6.jpg) | ![Ekran Görüntüsü 8](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/7.jpg) | ![Ekran Görüntüsü 9](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/8.jpg) |



## 🚀 Teknolojiler ve Mimarî

*   **Framework:** Flutter (v3.x veya güncel)
*   **Dil:** Dart
*   **Mimari Yaklaşım:** Feature-First (Özellik Odaklı) mimari kullanılarak katmanlara (Data, Domain, Presentation) ayrılmıştır. Bu, kodun modülerliğini ve sürdürülebilirliğini artırır.
*   **State Management:** `Riverpod` (`flutter_riverpod`, `hooks_riverpod`) paketi ile reaktif ve verimli state yönetimi sağlanmıştır. `StateNotifierProvider`, `FutureProvider`, `StateProvider` gibi çeşitli provider'lar kullanılmıştır.
*   **API İstemcisi:** Karakter ve büyü verileri için [Potter API](https://hp-api.onrender.com/) (veya kullandığın API'nin adı/linki) kullanılmıştır. Veri çekme işlemleri için `http` veya `dio` gibi bir paket kullanılmış olabilir (Provider'lar içinde soyutlanmış).
*   **Asenkron İşlemler:** `FutureProvider` ve `async/await` kullanılarak API istekleri ve diğer asenkron operasyonlar yönetilmiştir.
*   **Yerelleştirme:** `AppStrings` sınıfı ile basit, manuel bir yerelleştirme (Türkçe/İngilizce) mekanizması kurulmuştur.
*   **Tema Yönetimi:** `AppTheme`, `AppDimensions`, `AppTextStyles` sınıfları ile merkezi ve tutarlı bir tema yönetimi yapılmıştır. Açık ve Koyu Mod desteklenmektedir.
*   **Navigasyon:** Temel Flutter navigasyon mekanizmaları (`MaterialPageRoute`) kullanılmıştır. Global ScrollController (`charactersScrollController`) ile liste kaydırma pozisyonu yönetilmiştir.
*   **Veri Depolama (Favoriler):** Favori karakter ve büyü ID'leri, `StateNotifier` ve `shared_preferences` (veya Riverpod state kalıcılığı mekanizması) kullanılarak cihaz üzerinde saklanmaktadır.

## 📦 Kullanılan Paketler

*   `flutter`: Flutter UI toolkit.
*   `cupertino_icons`: iOS stili ikonlar için.
*   `dio`: HTTP istekleri yapmak ve API ile iletişim kurmak için.
*   `flutter_riverpod`: State yönetimi için temel Riverpod paketi.
*   `hooks_riverpod`: Flutter Hook'ları ile Riverpod'ı entegre etmek için.
*   `freezed_annotation` & `json_annotation`: `freezed` ve `json_serializable` ile birlikte değişmez (immutable) veri modelleri ve JSON serileştirme/deserileştirme için.
*   `flutter_hooks`: Fonksiyonel widget'larda state ve widget lifecycle yönetimi için.
*   `cached_network_image`: Ağdan indirilen resimleri verimli bir şekilde önbelleğe almak ve göstermek için.
*   `go_router`: Deklaratif yönlendirme (routing) ve navigasyon yönetimi için.
*   `google_fonts`: Google Fonts kütüphanesinden fontları kolayca kullanmak için.
*   `flutter_animate`: Kullanıcı arayüzüne kolayca zincirleme animasyonlar eklemek için.
*   `shimmer`: Yükleme durumlarında iskelet (skeleton) yükleme efekti (shimmer) göstermek için.
*   `shared_preferences`: Basit verileri (favoriler, dil tercihi gibi) cihazda kalıcı olarak saklamak için.
*   `lottie`: Lottie formatındaki animasyonları (genellikle yükleme veya boş durum göstergeleri için) oynatmak için.

**Geliştirme Bağımlılıkları (`dev_dependencies`):**

*   `build_runner`: Kod üretimi görevlerini çalıştırmak için.
*   `freezed`: Değişmez veri sınıfları ve union/sealed class'lar oluşturmak için kod üreteci.
*   `json_serializable`: JSON dönüşüm kodlarını otomatik olarak üretmek için.
*   `flutter_lints`: İyi kodlama pratiklerini teşvik eden lint kuralları seti.

## ⚙️ Kurulum ve Çalıştırma

1.  **Depoyu Klonla:**
    ```bash
    git clone https://github.com/senin-kullanici-adin/harry-potter-character-compendium.git
    cd harry-potter-character-compendium
    ```
2.  **Bağımlılıkları Yükle:**
    ```bash
    flutter pub get
    ```
3.  **Uygulamayı Çalıştır:**
    Flutter kurulu bir cihaz veya emülatörde aşağıdaki komutu çalıştırın:
    ```bash
    flutter run
    ```
