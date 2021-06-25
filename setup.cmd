rem call flutter pub global activate intl_utils
if not "%1%" == "" (
    echo Renaming package
    call flutter pub global activate rename
    call flutter pub global run rename --bundleId %1%
)
call flutter packages pub run build_runner build --delete-conflicting-outputs