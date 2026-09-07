import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;

  bool get _tr => locale.languageCode.toLowerCase() == 'tr';

  static const supportedLocales = <Locale>[
    Locale('en'),
    Locale('tr'),
  ];

  static const LocalizationsDelegate<AppStrings> delegate =
      _AppStringsDelegate();

  static AppStrings of(BuildContext context) {
    final strings = Localizations.of<AppStrings>(context, AppStrings);
    assert(strings != null, 'AppStrings not found in widget tree');
    return strings!;
  }

  String get cancel => _tr ? 'İptal' : 'Cancel';
  String get save => _tr ? 'Kaydet' : 'Save';
  String get confirm => _tr ? 'Onayla' : 'Confirm';
  String get retry => _tr ? 'Tekrar dene' : 'Retry';
  String get connect => _tr ? 'Bağlan' : 'Connect';
  String get stop => _tr ? 'Durdur' : 'Stop';
  String get reset => _tr ? 'Sıfırla' : 'Reset';

  String get settings => _tr ? 'Ayarlar' : 'Settings';
  String get scanAgain => _tr ? 'Yeniden tara' : 'Scan again';
  String get bluetoothPermissionsRequired => _tr
      ? 'Kulaklığı kontrol etmek için Bluetooth izinleri gereklidir'
      : 'Bluetooth permissions are required to control earbuds';
  String scanFailed(Object error) =>
      _tr ? 'Tarama başarısız: $error' : 'Scan failed: $error';
  String connectFailed(Object error) =>
      _tr ? 'Bağlantı başarısız: $error' : 'Connect failed: $error';
  String reconnectFailed(Object error) => _tr
      ? 'Yeniden bağlanma başarısız: $error'
      : 'Reconnect failed: $error';
  String reconnectTo(String name) =>
      _tr ? '$name cihazına yeniden bağlan' : 'Reconnect to $name';
  String get scanningForQcy =>
      _tr ? 'QCY kulaklıklar taranıyor…' : 'Scanning for QCY earbuds…';
  String get pullOrRefresh => _tr
      ? 'Taramak için aşağı çekin veya yenileye dokunun'
      : 'Pull down or tap refresh to scan';
  String get worksWhilePlaying => _tr
      ? 'Müzik çalarken de çalışır. Kulaklıkları kutudan çıkarın veya kutuyu açık tutun.'
      : 'Works while music is playing. Keep buds out or case open.';
  String get noQcyDevices =>
      _tr ? 'Henüz QCY cihazı bulunamadı.' : 'No QCY devices found yet.';
  String batterySummary(int left, int right, [int? caseLevel]) {
    if (_tr) {
      return caseLevel == null
          ? 'Sol $left% · Sağ $right%'
          : 'Sol $left% · Sağ $right% · Kutu $caseLevel%';
    }
    return caseLevel == null
        ? 'L $left% · R $right%'
        : 'L $left% · R $right% · Case $caseLevel%';
  }

  String actionFailed(String label, Object error) =>
      _tr ? '$label başarısız: $error' : '$label failed: $error';
  String get renameDevice => _tr ? 'Cihazın adını değiştir' : 'Rename device';
  String get deviceName => _tr ? 'Cihaz adı' : 'Device name';
  String get findEarbuds => _tr ? 'Kulaklıkları bul' : 'Find earbuds';
  String get findEarbudsDescription => _tr
      ? 'Kulaklıklarda bulma sesi çalar. Kulaklıkları bulduğunuzda durdurun.'
      : 'Plays a locating tone on the earbuds. Stop when you find them.';
  String get startLocating => _tr ? 'Bulma sesini başlat' : 'Start locating';
  String get device => _tr ? 'Cihaz' : 'Device';
  String get backToScan => _tr ? 'Taramaya dön' : 'Back to scan';
  String get disconnect => _tr ? 'Bağlantıyı kes' : 'Disconnect';
  String get noiseControl => _tr ? 'Gürültü kontrolü' : 'Noise control';
  String get noiseControlSubtitle => _tr
      ? 'Değişiklikte kulaklıktan sesli bildirim duymalısınız.'
      : 'You should hear the voice prompt on change.';
  String get equalizer => _tr ? 'Ekolayzır' : 'Equalizer';
  String get customizeBands => _tr ? 'Bantları özelleştir' : 'Customize bands';
  String get audio => _tr ? 'Ses' : 'Audio';
  String get volume => _tr ? 'Ses seviyesi' : 'Volume';
  String get channelBalance => _tr ? 'Kanal dengesi' : 'Channel balance';
  String get center => _tr ? 'Orta' : 'Center';
  String get left => _tr ? 'Sol' : 'Left';
  String get right => _tr ? 'Sağ' : 'Right';
  String get controls => _tr ? 'Kontroller' : 'Controls';
  String get controlsSubtitle => _tr
      ? 'Her kulaklık için dokunma hareketlerini özelleştirin.'
      : 'Customize touch gestures per earbud.';
  String get touchControls => _tr ? 'Dokunmatik kontroller' : 'Touch controls';
  String get tapTypes =>
      _tr ? 'Tek, çift ve üçlü dokunma' : 'Single, double, and triple tap';
  String get power => _tr ? 'Güç' : 'Power';
  String get powerSubtitle => _tr
      ? 'Boştayken otomatik kapanma.'
      : 'Auto power-off when idle.';
  String get autoPowerOff => _tr ? 'Otomatik kapanma' : 'Auto power-off';
  String get features => _tr ? 'Özellikler' : 'Features';
  String get gamingMode => _tr ? 'Oyun modu' : 'Gaming mode';
  String get lowLatency => _tr ? 'Düşük gecikme' : 'Low latency';
  String get highQualityCodec => _tr ? 'Yüksek kaliteli codec' : 'High quality codec';
  String get sleepMode => _tr ? 'Uyku modu' : 'Sleep mode';
  String get spatialAudio => _tr ? 'Uzamsal ses' : 'Spatial audio';
  String get inEarDetection => _tr ? 'Kulakta algılama' : 'In-ear detection';
  String get dualDeviceConnection =>
      _tr ? 'Çift cihaz bağlantısı' : 'Dual device connection';
  String get rename => _tr ? 'Yeniden adlandır' : 'Rename';
  String get resetToDefaults =>
      _tr ? 'Varsayılan ayarlara dön' : 'Reset to defaults';
  String get resetSettingsTitle => _tr ? 'Ayarlar sıfırlansın mı?' : 'Reset settings?';
  String get resetSettingsMessage => _tr
      ? 'Fabrika varsayılan ayarlarını geri yükler (eşleştirme silinmez).'
      : 'Restores factory default settings (not pairing).';
  String get factoryReset => _tr ? 'Fabrika ayarlarına sıfırla' : 'Factory reset';
  String get factoryResetTitle =>
      _tr ? 'Fabrika ayarlarına sıfırlansın mı?' : 'Factory reset?';
  String get factoryResetMessage => _tr
      ? 'Tüm ayarları ve eşleştirmeyi siler. Bu işlem geri alınamaz.'
      : 'Clears all settings and pairing. This cannot be undone.';
  String get reconnect => _tr ? 'Yeniden bağlan' : 'Reconnect';
  String get leftEarbud => _tr ? 'Sol' : 'Left';
  String get rightEarbud => _tr ? 'Sağ' : 'Right';
  String get caseLabel => _tr ? 'Kutu' : 'Case';
  String get connected => _tr ? 'Bağlandı' : 'Connected';
  String get connecting => _tr ? 'Bağlanıyor…' : 'Connecting…';
  String get reconnecting => _tr ? 'Yeniden bağlanıyor…' : 'Reconnecting…';
  String get error => _tr ? 'Hata' : 'Error';
  String get disconnected => _tr ? 'Bağlantı kesildi' : 'Disconnected';

  String localizeStatusMessage(String? message) {
    if (message == null || !_tr) return message ?? '';
    if (message == 'Connecting…') return connecting;
    if (message == 'Earbuds restarting — reconnecting…') {
      return 'Kulaklık yeniden başlatılıyor — yeniden bağlanıyor…';
    }
    final match = RegExp(
      r'^Earbuds restarting — reconnecting \((\d+)/(\d+)\)…$',
    ).firstMatch(message);
    if (match != null) {
      return 'Kulaklık yeniden başlatılıyor — yeniden bağlanıyor '
          '(${match.group(1)}/${match.group(2)})…';
    }
    return message;
  }

  String localizeErrorMessage(String message) {
    if (!_tr) return message;
    if (message == 'Device disconnected') return 'Cihaz bağlantısı kesildi';
    if (message ==
        'Could not reconnect after restart. Tap Retry or go back and scan.') {
      return 'Yeniden başlatmadan sonra bağlantı kurulamadı. Tekrar deneyin veya geri dönüp tarayın.';
    }
    return message;
  }

  String get eqBands => _tr ? 'EQ bantları' : 'EQ bands';
  String eqUpdateFailed(Object error) =>
      _tr ? 'EQ güncellemesi başarısız: $error' : 'EQ update failed: $error';
  String get presetAppliedNoBandData => _tr
      ? 'Ön ayar uygulandı ancak bant verileri dönmedi. Yenileyin veya elle ayarlayın.'
      : 'Preset applied — band data not returned. Tap refresh or adjust manually.';
  String presetFailed(Object error) =>
      _tr ? 'Ön ayar uygulanamadı: $error' : 'Preset failed: $error';
  String get presets => _tr ? 'Ön ayarlar' : 'Presets';
  String get presetSubtitle => _tr
      ? 'Aşağıdaki bantlara eğrisini yüklemek için bir ön ayar seçin.'
      : 'Switch preset to load its curve into the bands below.';
  String get bandLevels => _tr ? 'Bant seviyeleri' : 'Band levels';
  String bandLevelsSubtitle(double maxDb) => _tr
      ? 'Her bant için ±${maxDb.toStringAsFixed(0)} dB. Özelleştirmek için kaydırıcıları sürükleyin.'
      : '±${maxDb.toStringAsFixed(0)} dB per band. Drag sliders to customize.';
  String get resetToFlat => _tr ? 'Düz EQ’ya sıfırla' : 'Reset to flat';

  String get touchControlsSaved =>
      _tr ? 'Dokunmatik kontroller kaydedildi' : 'Touch controls saved';
  String saveFailed(Object error) =>
      _tr ? 'Kaydetme başarısız: $error' : 'Save failed: $error';
  String get assignActions => _tr
      ? 'Her kulaklık hareketi için bir işlem atayın.'
      : 'Assign actions for each earbud gesture.';

  String get autoReconnect => _tr ? 'Otomatik yeniden bağlan' : 'Auto-reconnect';
  String get autoReconnectSubtitle => _tr
      ? 'Son cihaza hızlı yeniden bağlanma seçeneğini göster'
      : 'Offer quick reconnect to last device';
  String savedDevice(String name) =>
      _tr ? 'Kayıtlı cihaz: $name' : 'Saved device: $name';
  String get savedDeviceCleared =>
      _tr ? 'Kayıtlı cihaz temizlendi' : 'Saved device cleared';
  String get aboutOpenQcy => _tr ? 'OpenQCY hakkında' : 'About OpenQCY';
  String get aboutDescription => _tr
      ? 'BLE GATT üzerinden çalışan resmi olmayan QCY kulaklık denetleyicisi.\n'
          'Quicky protokolünü temel alır.\n'
          'com.httpkiwi.melocontrol · v1.0.0'
      : 'Unofficial QCY earbud controller via BLE GATT.\n'
          'Based on the Quicky protocol.\n'
          'com.httpkiwi.melocontrol · v1.0.0';

  String ancMode(String modeName) {
    if (!_tr) {
      return switch (modeName) {
        'off' => 'Off',
        'indoor' => 'ANC',
        'commuting' => 'Outdoor',
        'noisy' => 'Noisy',
        'antiWind' => 'Wind',
        'adaptive' => 'Adaptive',
        'transparency' => 'Transparency',
        _ => modeName,
      };
    }
    return switch (modeName) {
      'off' => 'Kapalı',
      'indoor' => 'ANC',
      'commuting' => 'Dış ortam',
      'noisy' => 'Gürültülü',
      'antiWind' => 'Rüzgâr',
      'adaptive' => 'Uyarlanabilir',
      'transparency' => 'Şeffaflık',
      _ => modeName,
    };
  }

  String eqPreset(String value) {
    if (!_tr) return value;
    return switch (value) {
      'Spatial' => 'Uzamsal',
      'Default' => 'Varsayılan',
      'Pop' => 'Pop',
      'Heavy Bass' => 'Güçlü Bas',
      'Bass' => 'Bas',
      'Rock' => 'Rock',
      'Soft' => 'Yumuşak',
      'Classic' => 'Klasik',
      _ => value,
    };
  }

  String gestureName(String value) {
    if (!_tr) return value;
    return switch (value) {
      'Touch' => 'Dokunma',
      'Double touch' => 'Çift dokunma',
      'Triple touch' => 'Üçlü dokunma',
      _ => value,
    };
  }

  String keyFunction(String value) {
    if (!_tr) return value;
    return switch (value) {
      'Not work' => 'İşlem yok',
      'Play/pause' => 'Oynat/duraklat',
      'Previous track' => 'Önceki parça',
      'Next track' => 'Sonraki parça',
      'Voice Assistant' => 'Sesli asistan',
      'Volume up' => 'Sesi artır',
      'Volume down' => 'Sesi azalt',
      'Gaming mode' => 'Oyun modu',
      'ANC mode' => 'ANC modu',
      _ => value,
    };
  }

  String autoOffMinutes(int minutes) {
    if (minutes >= 50000 || minutes == 0) return _tr ? 'Asla' : 'Never';
    return _tr ? '$minutes dk' : '$minutes min';
  }
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      AppStrings.supportedLocales.any((item) => item.languageCode == locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) => SynchronousFuture(AppStrings(locale));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}

extension AppStringsContext on BuildContext {
  AppStrings get strings => AppStrings.of(this);
}
