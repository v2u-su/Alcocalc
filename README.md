# Калькулятор самогона (Flutter)

Мобильное приложение по формулам из Google-таблицы «Калькулятор самогона»
и по макету с тёмной темой (бирюзовый/янтарный акценты).

## Запуск

В репозитории только `lib/`, `test/` и `pubspec.yaml` — платформенных папок нет.
Чтобы их сгенерировать:

```bash
cd alcocalc
flutter create . --project-name alcocalc --platforms=android,ios
flutter pub get
flutter run
```

Тесты: `flutter test` (сверяют расчёты с контрольными значениями таблицы).

Требуется Flutter 3.19+ (используется `TabAlignment.start`).

## Экраны и формулы

| Вкладка | Вход | Выход |
| --- | --- | --- |
| Разбавление водой | крепость, объём, нужная крепость | `V₂ = V·C/C₂`, вода `= V₂ − V` |
| Расчёт крепости | крепость, объём, нужный объём | `C₂ = C·V/V₂` |
| Расчёт смеси | крепость спирта, нужный объём, нужная крепость | спирт `= V₂·C₂/C`, вода `= V₂ − спирт` |
| Объём и вода | крепость, объём, объём воды | `C₂ = C·V/(V+Vводы)`, объём `= V+Vводы` |
| Два напитка | крепость и объём двух напитков | `C = (C₁V₁+C₂V₂)/(V₁+V₂)` |

Объёмы складываются линейно — как в таблице. Контракция спирто-водяной смеси
(реальные 500 мл 85 % + 563 мл воды дают чуть меньше 1063 мл) не учитывается.
Если нужна точность по ГОСТ 3639 — считать через массовые доли и таблицу
плотностей, формулы в `lib/domain/calculators.dart` тогда меняются в одном месте.

## Иконка и название

Иконка уже нарезана и лежит по нужным путям — после `flutter create .` файлы
просто перезапишут дефолтные:

- `android/app/src/main/res/mipmap-*/ic_launcher.png` (48…192 px)
- `ios/Runner/Assets.xcassets/AppIcon.appiconset/Icon-App-*.png` (20…1024 px, без альфа-канала)
- `web/favicon.png`, `web/icons/Icon-{192,512}.png`
- мастер-файл `assets/icon/icon.png` (1024 px)

Отображаемое имя — «Калькулятор самогона»:

- Android: в `android/app/src/main/AndroidManifest.xml` поставить
  `android:label="@string/app_name"` (строка лежит в
  `android/app/src/main/res/values/strings.xml`).
- iOS: в `ios/Runner/Info.plist` ключ `CFBundleDisplayName` = `Калькулятор самогона`.
- Локально это делает `bash tools/rename_app.sh`.

Имя пакета Dart остаётся `alcocalc` — его менять не нужно, на экране оно не видно,
зато от него зависят все импорты `package:alcocalc/...`.

Если иконку захочется перерисовать: заменить `assets/icon/icon.png` и выполнить
`dart run flutter_launcher_icons` — конфиг уже в `pubspec.yaml`.

## Структура

```
lib/
  main.dart                 таб-бар и сборка приложения
  core/theme.dart           палитра из макета
  core/format.dart          форматирование и парсинг чисел
  core/widgets/             ValueField (−/+ и ручной ввод), ResultCard, CalcPage
  domain/calculators.dart   чистые функции расчёта (покрыты тестами)
  features/<экран>/         по одному экрану на вкладку
```

Состояние — локальный `setState` в каждом экране, вкладки не сбрасываются
(`AutomaticKeepAliveClientMixin`). Значения между запусками не сохраняются:
если нужно — добавить `shared_preferences` в `initState`/`onChanged`.

## Что можно доделать

- Сохранение последних значений и единицы измерения (мл / л).
- Поправка ареометра на температуру — в таблице этого нет, но для самогона
  спрашивают часто.
- Иконки и splash: `flutter_launcher_icons` + `flutter_native_splash`.
