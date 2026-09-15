#!/usr/bin/env bash
# Проставляет отображаемое имя приложения в Android и iOS.
# Запускать из корня проекта после flutter create.
set -e

NAME="Калькулятор самогона"
MANIFEST="android/app/src/main/AndroidManifest.xml"
PLIST="ios/Runner/Info.plist"

if [ -f "$MANIFEST" ]; then
  sed -i -E 's|android:label="[^"]*"|android:label="@string/app_name"|' "$MANIFEST"
  echo "AndroidManifest.xml -> @string/app_name"
fi

if [ -f "$PLIST" ]; then
  /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $NAME" "$PLIST" 2>/dev/null \
    || python3 - "$PLIST" "$NAME" <<'PY'
import re, sys
path, name = sys.argv[1], sys.argv[2]
s = open(path, encoding='utf-8').read()
s = re.sub(r'(<key>CFBundleDisplayName</key>\s*<string>)[^<]*(</string>)',
           lambda m: m.group(1) + name + m.group(2), s)
open(path, 'w', encoding='utf-8').write(s)
PY
  echo "Info.plist -> CFBundleDisplayName"
fi
