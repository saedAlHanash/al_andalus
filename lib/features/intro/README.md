# Intro Feature - شاشة المقدمة

## 📁 البنية
```
lib/features/intro/
├── ui/
│   ├── pages/
│   │   └── intro_page.dart          # الصفحة الرئيسية
│   └── widget/
│       └── intro_card_widget.dart   # Widget لكل صفحة
```

## ✨ المميزات
- ✅ 3 صفحات قابلة للتخصيص
- ✅ تمرير يدوي وزر Next
- ✅ Page indicators متحركة
- ✅ زر تخطي
- ✅ حفظ حالة المشاهدة
- ✅ متوافق مع أسلوب المشروع

## 🎨 التخصيص

### تغيير المحتوى
في `intro_page.dart`، عدّل قائمة `_pages`:

```dart
final List<IntroPageModel> _pages = [
  IntroPageModel(
    image: Assets.imagesIntro1,  // صورتك
    title: 'العنوان',
    description: 'الوصف',
  ),
];
```

### إضافة الصور
1. ضع الصور في `assets/images/`
2. عدّل `pubspec.yaml`:
```yaml
flutter:
  assets:
    - assets/images/intro1.png
```

## 🔄 كيفية العمل
- المستخدم الجديد: `Splash → Intro → Login`
- المستخدم القديم: `Splash → Login/Home`
