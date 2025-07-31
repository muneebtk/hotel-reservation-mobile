import 'package:get/get.dart';

import '../arabic_english/ar_sa_translations.dart';
import '../arabic_english/en_us_controller.dart';

class MyTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
        'en_US': enUs,
        'ar_SA': arSa,
      };
}
