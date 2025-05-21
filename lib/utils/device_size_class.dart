// lib\utils\device_size_class.dart

enum DeviceSizeClass { mobile, tablet, desktop }

extension DeviceSizeClassExtension on DeviceSizeClass {
  String get name {
    switch (this) {
      case DeviceSizeClass.mobile:
        return 'mobile';
      case DeviceSizeClass.tablet:
        return 'tablet';
      case DeviceSizeClass.desktop:
      default:
        return 'desktop';
    }
  }
}
