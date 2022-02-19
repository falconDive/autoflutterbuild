#!/bin/bash

typeset -A myarray

while IFS== read -r key value; do
    myarray["$key"]="$value"
done < <(jq -r '. | to_entries | .[] | .key + "=" + .value ' assets/configuration.json)

# show the array definition
typeset -p myarray

# make use of the array variables
echo "appname = '${myarray[appname]}'"
echo "package = '${myarray[packagename]}'"

rm obj/AndroidManifest.xml
rm obj/build.gradle 
rm obj/pubspec.yaml

mkdir -p `sed -e ':b; s/^\([^=]*\)*\./\1\//; tb;' <<<android/app/src/main/java/${myarray[packagename]}`


cp source/AndroidManifest.xml obj/
sed -i 's#android:label="dummyProject"#android:label="'${myarray[appname]}'"#' obj/AndroidManifest.xml
cp source/build.gradle obj/
sed -i 's#com.dummy.webview#'${myarray[packagename]}'#' obj/build.gradle
cp source/pubspec.yaml obj/
sed -i 's#0.0.0+1#'${myarray[version]}'#' obj/pubspec.yaml

cp obj/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
cp obj/build.gradle android/app/build.gradle
cp obj/pubspec.yaml pubspec.yaml

flutter build apk --release
flutter install

IN=android/app/src/main/java/${myarray[packagename]}
arrIN=(${IN//./ })
echo ${arrIN[0]}
rm -fr ${arrIN[0]}

exit 0
