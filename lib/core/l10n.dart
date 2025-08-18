import 'package:flutter/widgets.dart';

class L10n {
  static bool isArabic(Locale l) => l.languageCode.toLowerCase().startsWith('ar');

  static final Map<String, Map<String, String>> _t = {
    'en': {
      'login': 'Login',
      'register': 'Register',
      'email': 'Email',
      'password': 'Password',
      'sign_in': 'Sign In',
      'create_account': 'Create account',
      'i_have_account': 'I have an account',
      'live_map': 'Live Map',
      'stop': 'Stop',
      'share': 'Share',
    },
    'ar': {
      'login': 'تسجيل الدخول',
      'register': 'تسجيل حساب جديد',
      'email': 'البريد الإلكتروني',
      'password': 'كلمة المرور',
      'sign_in': 'دخول',
      'create_account': 'إنشاء حساب',
      'i_have_account': 'لدي حساب',
      'live_map': 'الخريطة الحية',
      'stop': 'إيقاف',
      'share': 'مشاركة',
    }
  };

  static String of(BuildContext context, String key) {
    final code = Localizations.localeOf(context).languageCode;
    return _t[code]?[key] ?? _t['en']![key] ?? key;
  }
}