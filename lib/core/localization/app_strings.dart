// Uygulama genelinde kullanılan sabit metinler.
class AppStrings {
  // Aktif dil - varsayılan olarak Türkçe (tr)
  static String _currentLanguage = 'tr';

  // Dil değiştirme metodu
  static void setLanguage(String languageCode) {
    if (languageCode == 'tr' || languageCode == 'en') {
      if (_currentLanguage != languageCode) {
        _currentLanguage = languageCode;
        _notifyListeners(); // Dil değiştiğinde dinleyicileri haberdar et
      }
    }
  }

  // Geçerli dil kodunu alma metodu
  static String getCurrentLanguage() {
    return _currentLanguage;
  }

  // Dil değişimini dinleyecek listener'lar için
  static final List<Function()> _listeners = [];

  // Listener ekleme
  static void addListener(Function() listener) {
    _listeners.add(listener);
  }

  // Listener kaldırma
  static void removeListener(Function() listener) {
    _listeners.remove(listener);
  }

  // Listener'ları bildirme
  static void _notifyListeners() {
    for (var listener in _listeners) {
      listener();
    }
  }

  // Genel
  static String get appName => _currentLanguage == 'tr' ? 'Harry Potter Compendium' : 'Harry Potter Compendium';
  static String get errorTitle => _currentLanguage == 'tr' ? 'Hata' : 'Error';
  static String get retry => _currentLanguage == 'tr' ? 'Tekrar Dene' : 'Retry';
  static String get cancel => _currentLanguage == 'tr' ? 'İptal' : 'Cancel';
  static String get apply => _currentLanguage == 'tr' ? 'Uygula' : 'Apply';
  static String get clear => _currentLanguage == 'tr' ? 'Temizle' : 'Clear';

  // Karakterler Ekranı
  static String get charactersTitle => _currentLanguage == 'tr' ? 'Karakterler' : 'Characters';
  static String get charactersSearchHint => _currentLanguage == 'tr' ? 'Karakter Ara...' : 'Search Characters...';
  static String get charactersFilterTitle => _currentLanguage == 'tr' ? 'Karakterleri Filtrele' : 'Filter Characters';
  static String get charactersTabAll => _currentLanguage == 'tr' ? 'Tümü' : 'All';
  static String get charactersTabStudents => _currentLanguage == 'tr' ? 'Ögrenciler' : 'Students';
  static String get charactersTabStaff => _currentLanguage == 'tr' ? 'Personel' : 'Staff';
  static String get charactersFilterHouse => _currentLanguage == 'tr' ? 'Ev' : 'House';
  static String get charactersFilterSpecies => _currentLanguage == 'tr' ? 'Tür' : 'Species';
  static String get charactersFilterGender => _currentLanguage == 'tr' ? 'Cinsiyet' : 'Gender';
  static String get charactersFilterAncestry => _currentLanguage == 'tr' ? 'Soy' : 'Ancestry';
  static String get charactersFilterClearTooltip => _currentLanguage == 'tr' ? 'Filtreleri Temizle' : 'Clear Filters';
  static String get charactersLoadingError => _currentLanguage == 'tr' ? 'Karakterler yüklenemedi.' : 'Failed to load characters.';
  static String get studentsLoadingError => _currentLanguage == 'tr' ? 'Ögrenciler yüklenemedi.' : 'Failed to load students.';
  static String get staffLoadingError => _currentLanguage == 'tr' ? 'Personel yüklenemedi.' : 'Failed to load staff.';
  static String get filterOptionsNotFound => _currentLanguage == 'tr' ? 'Filtre seçenegi bulunamadı.' : 'Filter options not found.';

  // Büyüler Ekranı
  static String get spellsTitle => _currentLanguage == 'tr' ? 'Büyüler' : 'Spells';
  static String get spellsSearchHint => _currentLanguage == 'tr' ? 'Büyü Ara...' : 'Search Spells...';
  static String get spellsLoadingError => _currentLanguage == 'tr' ? 'Büyüler yüklenirken bir hata oluştu.' : 'An error occurred while loading spells.';
  static String get spellsSearchNotFound => _currentLanguage == 'tr' ? 'Arama kriterlerinize uygun büyü bulunamadı.' : 'No spells found matching your search criteria.';
  static String get spellsNotFound => _currentLanguage == 'tr' ? 'Gösterilecek büyü bulunamadı.' : 'No spells found to display.';
  static String get spellsClearFilters => _currentLanguage == 'tr' ? 'Filtreleri Temizle' : 'Clear Filters';

  // Karakter Detay Ekranı
  static String get characterNotFound => _currentLanguage == 'tr' ? 'Karakter bulunamadı.' : 'Character not found.';
  static String get characterLoadingError => _currentLanguage == 'tr' ? 'Karakter yüklenirken bir hata oluştu.' : 'An error occurred while loading character.';
  static String get characterInfoBasic => _currentLanguage == 'tr' ? 'Temel Bilgiler' : 'Basic Information';
  static String get characterInfoPhysical => _currentLanguage == 'tr' ? 'Fiziksel Özellikler' : 'Physical Attributes';
  static String get characterInfoWand => _currentLanguage == 'tr' ? 'Asa Bilgileri' : 'Wand Information';
  static String get characterInfoPatronus => _currentLanguage == 'tr' ? 'Patronus' : 'Patronus';
  static String get characterInfoHogwarts => _currentLanguage == 'tr' ? 'Hogwarts Bilgileri' : 'Hogwarts Information';
  static String get characterInfoFilm => _currentLanguage == 'tr' ? 'Film Bilgileri' : 'Film Information';
  static String get characterAlternateNames => _currentLanguage == 'tr' ? 'Diger İsimler' : 'Alternate Names';
  static String get characterHouse => _currentLanguage == 'tr' ? 'Ev' : 'House';
  static String get characterSpecies => _currentLanguage == 'tr' ? 'Tür' : 'Species';
  static String get characterGender => _currentLanguage == 'tr' ? 'Cinsiyet' : 'Gender';
  static String get characterDob => _currentLanguage == 'tr' ? 'Dogum Tarihi' : 'Date of Birth';
  static String get characterYob => _currentLanguage == 'tr' ? 'Dogum Yılı' : 'Year of Birth';
  static String get characterIsWizard => _currentLanguage == 'tr' ? 'Büyücü' : 'Wizard';
  static String get characterAncestry => _currentLanguage == 'tr' ? 'Soy' : 'Ancestry';
  static String get characterIsAlive => _currentLanguage == 'tr' ? 'Hayatta Mı' : 'Is Alive';
  static String get characterEyeColor => _currentLanguage == 'tr' ? 'Göz Rengi' : 'Eye Color';
  static String get characterHairColor => _currentLanguage == 'tr' ? 'Saç Rengi' : 'Hair Color';
  static String get characterWandWood => _currentLanguage == 'tr' ? 'Odun' : 'Wood';
  static String get characterWandCore => _currentLanguage == 'tr' ? 'Öz' : 'Core';
  static String get characterWandLength => _currentLanguage == 'tr' ? 'Uzunluk' : 'Length';
  static String get characterPatronusLabel => _currentLanguage == 'tr' ? 'Patronus' : 'Patronus';
  static String get characterIsStudent => _currentLanguage == 'tr' ? 'Hogwarts Ögrencisi' : 'Hogwarts Student';
  static String get characterIsStaff => _currentLanguage == 'tr' ? 'Hogwarts Personeli' : 'Hogwarts Staff';
  static String get characterActor => _currentLanguage == 'tr' ? 'Aktör' : 'Actor';
  static String get characterAlternateActors => _currentLanguage == 'tr' ? 'Diger Aktörler' : 'Alternate Actors';
  static String get yes => _currentLanguage == 'tr' ? 'Evet' : 'Yes';
  static String get no => _currentLanguage == 'tr' ? 'Hayır' : 'No';

  // Favoriler (Profil) Ekranı
  static String get favoritesTitle => _currentLanguage == 'tr' ? 'Favorilerim' : 'My Favorites';
  static String get favoritesTabCharacters => _currentLanguage == 'tr' ? 'Karakterler' : 'Characters';
  static String get favoritesTabSpells => _currentLanguage == 'tr' ? 'Büyüler' : 'Spells';
  static String get favoritesEmptyCharacters => _currentLanguage == 'tr' ? 'Henüz favori karakteriniz yok.' : 'You have no favorite characters yet.';
  static String get favoritesEmptySpells => _currentLanguage == 'tr' ? 'Henüz favori büyünüz yok.' : 'You have no favorite spells yet.';
  static String get favoritesEmptyGeneric => _currentLanguage == 'tr' ? 'Henüz favori {type}\n bulunmuyor.' : 'No favorite {type} found yet.'; // {type} yerine karakter/büyü gelecek
  static String get favoritesLoadingErrorCharacters => _currentLanguage == 'tr' ? 'Favori karakterler yüklenirken bir hata oluştu.' : 'An error occurred while loading favorite characters.';
  static String get favoritesLoadingErrorSpells => _currentLanguage == 'tr' ? 'Favori büyüler yüklenirken bir hata oluştu.' : 'An error occurred while loading favorite spells.';
  
  // Navigasyon Çubuğu
  static String get characters => _currentLanguage == 'tr' ? 'Karakterler' : 'Characters';
  static String get viewCharacters => _currentLanguage == 'tr' ? 'Karakterleri Görüntüle' : 'View Characters';
  static String get spells => _currentLanguage == 'tr' ? 'Büyüler' : 'Spells';
  static String get viewSpells => _currentLanguage == 'tr' ? 'Büyüleri Görüntüle' : 'View Spells';
  static String get profile => _currentLanguage == 'tr' ? 'Profil' : 'Profile';
  static String get viewProfile => _currentLanguage == 'tr' ? 'Profili Görüntüle' : 'View Profile';
  
  // Yükleme ve Hata Ekranları
  static String get loading => _currentLanguage == 'tr' ? 'Yükleniyor...' : 'Loading...';
  static String get characterDetailsLoading => _currentLanguage == 'tr' ? 'Karakter bilgileri yükleniyor...' : 'Loading character details...';
  static String get error => _currentLanguage == 'tr' ? 'Bir hata oluştu' : 'An error occurred';
  static String get noData => _currentLanguage == 'tr' ? 'Veri bulunamadı' : 'No data found';
  static String get noCharactersFound => _currentLanguage == 'tr' ? 'Karakter bulunamadı' : 'No characters found';
  static String get noStudentsFound => _currentLanguage == 'tr' ? 'Öğrenci bulunamadı' : 'No students found';  
  static String get noStaffFound => _currentLanguage == 'tr' ? 'Personel bulunamadı' : 'No staff found';
  static String get tryAgain => _currentLanguage == 'tr' ? 'Tekrar Dene' : 'Try Again';
  static String get somethingWentWrong => _currentLanguage == 'tr' ? 'Bir şeyler yanlış gitti' : 'Something went wrong';
} 