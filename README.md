# Harry Potter Karakter ve Büyü Ansiklopedisi

Bu Flutter uygulaması, Harry Potter evrenindeki karakterler ve büyüler hakkında detaylı bilgi sunmak amacıyla geliştirilmiş bir mobil ansiklopedidir. Uygulama, kullanıcıların karakterleri ve büyüleri listelemesine, ayrıntılı bilgilerini görüntülemesine, sık kullanılan öğeleri favorilerine eklemesine ve çeşitli kriterler kullanarak filtreleme ve arama yapmasına olanak tanır.

## ✨ Temel Özellikler

*   **Karakter Listeleme:** Tüm karakterler, Hogwarts öğrencileri ve Hogwarts personeli olmak üzere üç ayrı sekmede karakter verilerinin sunulması.
*   **Karakter Detayları:** Seçilen bir karakterin evi, türü, doğum tarihi, asa özellikleri, canlandıran aktör vb. gibi ayrıntılı bilgilerinin gösterilmesi.
*   **Karakter Filtreleme:** Karakter listesinin; ev, tür, cinsiyet ve soy kriterlerine göre filtrelenebilmesi.
*   **Karakter Arama:** Karakter veritabanında isme göre arama yapılması.
*   **Büyü Listeleme:** Harry Potter evreninde yer alan büyülerin isimleri ve açıklamaları ile birlikte listelenmesi.
*   **Büyü Arama:** Büyülerin isimleri veya açıklamaları içinde metin araması yapılması.
*   **Favoriler Yönetimi:** Kullanıcıların sık erişmek istediği karakterleri ve büyüleri favori olarak işaretleyebilmesi ve bu öğelerin ayrı bir ekranda yönetilebilmesi.
*   **Çoklu Dil Desteği:** Uygulama arayüzünün Türkçe ve İngilizce dilleri arasında dinamik olarak değiştirilebilmesi.
*   **Temalandırma:** Harry Potter temasına uygun, açık ve koyu modları destekleyen, özelleştirilmiş bir kullanıcı arayüzü teması.
*   **Kullanıcı Deneyimi İyileştirmeleri:** Çeşitli arayüz animasyonları ile daha akıcı bir kullanıcı deneyimi sunulması.
*   **Görüntü Yönetimi:** Karakter görüntülerinin `cached_network_image` paketi kullanılarak verimli bir şekilde yüklenmesi ve önbelleğe alınması.

## 📸 Ekran Görüntüleri

Uygulamanın çeşitli ekranlarına ait görünümler:

| Açılış & Karakter Listesi | Açılış & Karakter Listesi | Karakter Filtreleme |
| :-----------------------: | :-------------: | :----------: |
| ![Açılış & Karakter Listesi](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/1.jpg) | ![Açılış & Karakter Listesi](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/2.jpg) | ![Karakter Filtreleme](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/3.jpg) |
| **Karakter Filtreleme** | **Karakter Detayı** | **Karakter Detayı** |
| ![Favoriler - Karakter Sekmesi](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/3.1.jpg) | ![Favoriler - Büyü Sekmesi](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/4.jpg) | ![Karakter Filtreleme Dialogu](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/5.jpg) |
| **Büyü Listesi** | **Favoriler** | **Favoriler** |
| ![Karakter Arama Sonucu](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/6.jpg) | ![Büyü Arama Sonucu](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/7.jpg) | ![Dil Değiştirme Butonu](https://raw.githubusercontent.com/ernklyc/harry_potter_character_compendium/main/assets/8.jpg) |

## 🚀 Teknolojiler ve Mimari Yapı

*   **Framework:** Flutter (v3.x veya üzeri)
*   **Programlama Dili:** Dart
*   **Mimari Yaklaşım:** Proje, kodun modülerliğini ve bakımını kolaylaştırmak amacıyla "Feature-First" (Özellik Odaklı) mimari prensibiyle geliştirilmiştir. Kod tabanı Data, Domain ve Presentation katmanlarına ayrılmıştır.
*   **Durum Yönetimi (State Management):** Uygulama genelinde durum yönetimi için `Riverpod` (`flutter_riverpod`, `hooks_riverpod`) kütüphanesi tercih edilmiştir. Reaktif programlama prensiplerine uygun olarak `StateNotifierProvider`, `FutureProvider`, `StateProvider` gibi çeşitli provider yapıları kullanılmıştır.
*   **API Entegrasyonu:** Karakter ve büyü verileri [Potter API](https://hp-api.onrender.com/) (veya belirtilen API kaynağı) üzerinden alınmaktadır. API istekleri için `dio` paketi kullanılmıştır ve bu işlemler ilgili provider'lar içerisinde soyutlanmıştır.
*   **Asenkron İşlemler:** API çağrıları ve diğer asenkron görevler, Dart'ın `async/await` mekanizmaları ve Riverpod'un `FutureProvider` yapısı ile yönetilmektedir.
*   **Yerelleştirme (Localization):** Uygulama, `AppStrings` sınıfı aracılığıyla yönetilen basit bir manuel yerelleştirme mekanizması ile Türkçe ve İngilizce dillerini desteklemektedir.
*   **Tema Yönetimi:** `AppTheme`, `AppDimensions` ve `AppTextStyles` sınıfları kullanılarak merkezi ve tutarlı bir tema yönetimi sağlanmıştır.
*   **Navigasyon (Routing):** Sayfa yönlendirmeleri için Flutter'ın temel `MaterialPageRoute` mekanizması kullanılmıştır. Liste kaydırma pozisyonunun korunması amacıyla global bir `ScrollController` (`charactersScrollController`) tanımlanmıştır.
*   **Yerel Veri Saklama:** Favori olarak işaretlenen karakter ve büyülerin ID'leri, `StateNotifier` ve `shared_preferences` paketi kullanılarak cihazın yerel depolama alanında kalıcı olarak saklanmaktadır.

## 📦 Kullanılan Kütüphaneler (Paketler)

*   `flutter`: Flutter UI toolkit.
*   `cupertino_icons`: iOS stili ikonlar.
*   `dio`: HTTP istemcisi; API entegrasyonu için.
*   `flutter_riverpod`: Temel Riverpod state yönetimi paketi.
*   `hooks_riverpod`: Riverpod'ın Flutter Hooks ile entegrasyonu.
*   `freezed_annotation` & `json_annotation`: Veri modelleri ve JSON serileştirme/deserileştirme için anotasyonlar.
*   `flutter_hooks`: Fonksiyonel widget'lar için state ve lifecycle hook'ları.
*   `cached_network_image`: Ağdan görüntü yükleme ve önbelleğe alma.
*   `go_router`: Deklaratif yönlendirme yönetimi.
*   `google_fonts`: Google Fonts kütüphanesinden font kullanımı.
*   `flutter_animate`: Zincirleme UI animasyonları.
*   `shimmer`: Yükleme durumları için iskelet (skeleton) efekti.
*   `shared_preferences`: Basit anahtar-değer verilerini yerel olarak saklama.
*   `lottie`: Lottie formatındaki vektörel animasyonları oynatma.

**Geliştirme Bağımlılıkları (`dev_dependencies`):**

*   `build_runner`: Kod üretimi için görev çalıştırıcı.
*   `freezed`: Değişmez veri sınıfları için kod üreteci.
*   `json_serializable`: JSON serileştirme kodlarını otomatik üretme.
*   `flutter_lints`: Statik kod analizi ve lint kuralları seti.
