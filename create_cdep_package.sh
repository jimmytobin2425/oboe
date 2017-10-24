# Copyright 2017 The Android Open Source Project
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

mkdir -p staging/lib/armeabi
cp build/lib/armeabi/liboboe.a staging/lib/armeabi
mkdir upload
pushd staging
zip -r ../upload/oboe-armeabi.zip .
popd

zip -r upload/oboe-headers.zip include/


printf "%s\r\n" "coordinate:" > upload/cdep-manifest.yml
printf "  %s\r\n" "groupId: com.github.google" >> upload/cdep-manifest.yml
printf "  %s\r\n" "artifactId: oboe" >> upload/cdep-manifest.yml
printf "  %s\r\n" "version: 0.9.0"  >> upload/cdep-manifest.yml
printf "%s\r\n" "license:" >> upload/cdep-manifest.yml
printf "  %s\r\n" "url: https://raw.githubusercontent.com/google/oboe/master/LICENSE" \
  >> upload/cdep-manifest.yml

printf "%s\r\n" "interfaces:" >> upload/cdep-manifest.yml
printf "  %s\r\n" "headers:" >> upload/cdep-manifest.yml
printf "    %s\r\n" "file: oboe-headers.zip" >> upload/cdep-manifest.yml
printf "    %s\r\n" "include: include" >> upload/cdep-manifest.yml

printf "    sha256: " >> upload/cdep-manifest.yml
shasum -a 256 upload/oboe-headers.zip | awk '{print $1}' >> upload/cdep-manifest.yml

printf "    size: " >> upload/cdep-manifest.yml
ls -l upload/oboe-headers.zip | awk '{print $5}' >> upload/cdep-manifest.yml

printf "%s\r\n" "android:" >> upload/cdep-manifest.yml
printf "  %s\r\n" "archives:" >> upload/cdep-manifest.yml
printf "    %s\r\n" "- file: oboe-armeabi.zip" >> upload/cdep-manifest.yml

printf "      sha256: " >> upload/cdep-manifest.yml
shasum -a 256 upload/oboe-armeabi.zip | awk '{print $1}' >> upload/cdep-manifest.yml

printf "      size: " >> upload/cdep-manifest.yml
ls -l upload/oboe-armeabi.zip | awk '{print $5}' >> upload/cdep-manifest.yml

printf "    %s\r\n" "  abi: armeabi" >> upload/cdep-manifest.yml
printf "    %s\r\n" "  platform: 16" >> upload/cdep-manifest.yml
printf "      libs: [liboboe.a]\r\n" >> upload/cdep-manifest.yml

printf "%s\r\n" "example: |" >> upload/cdep-manifest.yml
printf "%s\r\n" "  #include <oboe/Oboe.h>" >> upload/cdep-manifest.yml
printf "%s\r\n" "  void openStream() {" >> upload/cdep-manifest.yml
printf "%s\r\n" "    OboeStreamBuilder builder;" >> upload/cdep-manifest.yml
printf "%s\r\n" "    OboeStream *stream;" >> upload/cdep-manifest.yml
printf "%s\r\n" "    builder.openStream(&stream);" >> upload/cdep-manifest.yml
printf "%s\r\n" "  }" >> upload/cdep-manifest.yml
