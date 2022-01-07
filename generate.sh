flutter pub run pigeon \
  --input pigeons/book.dart \
  --dart_out lib/pigeon.dart \
  --objc_header_out ios/Runner/pigeon.h \
  --objc_source_out ios/Runner/pigeon.m \
  --java_out ./android/app/src/main/java/io/flutter/plugins/pigeon.java \
  --java_package "io.flutter.plugins"
