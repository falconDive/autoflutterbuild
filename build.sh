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
echo "version = '${myarray[version]}'"
#echo "permissions = '${myarray[permissions]}'"

rm obj/AndroidManifest.xml
rm obj/build.gradle 
rm obj/pubspec.yaml
rm obj/MainActivity.java

foldername=`sed -e ':b; s/^\([^=]*\)*\./\1\//; tb;' <<<android/app/src/main/java/${myarray[packagename]}`
echo $foldername
mkdir -p $foldername
echo "package ${myarray[packagename]};import io.flutter.embedding.android.FlutterActivity;public class MainActivity extends FlutterActivity {}" > obj/MainActivity.java
cp obj/MainActivity.java $foldername

cp source/AndroidManifest.xml obj/
sed -i 's#android:label="dummyProject"#android:label="'${myarray[appname]}'"#' obj/AndroidManifest.xml
sed -i 's#package="com.example.fl_webview_task1"#package="'${myarray[packagename]}'"#' obj/AndroidManifest.xml
cp source/build.gradle obj/
sed -i 's#com.dummy.webview#'${myarray[packagename]}'#' obj/build.gradle
cp source/pubspec.yaml obj/
sed -i 's#0.0.0+1#'${myarray[version]}'#' obj/pubspec.yaml

cp obj/AndroidManifest.xml android/app/src/main/AndroidManifest.xml
cp obj/build.gradle android/app/build.gradle
cp obj/pubspec.yaml pubspec.yaml

#flutter clean

flutter build apk --release

echo "Starting clean"
IN=android/app/src/main/java/${myarray[packagename]}
arrIN=(${IN//./ })
echo ${arrIN[0]}
rm -fr ${arrIN[0]}

exit 0
