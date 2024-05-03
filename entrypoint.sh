#!/usr/bin/env bash
#set -uo pipefail -o functrace -o xtrace
set -uo pipefail

: "${SOURCE_DIR:=/ca-certs}"
: "${TARGET:=/truststore/truststore.jks}"

cp "${JAVA_HOME}/lib/security/cacerts" "$TARGET"
find ./ -type f \( -iname \*.jpg -o -iname \*.png \)
find "${SOURCE_DIR}" -type f \( -iname \*.crt -o -iname \*.cer -o -iname \*.pem \) -print0 | while read -d $'\0' CERT; do
    "${JAVA_HOME}/bin/keytool" -import -trustcacerts -keystore "${TARGET}" -storepass changeit -noprompt -alias "$(basename "${CERT%.*}")" -file "${CERT}"
done

"${JAVA_HOME}/bin/keytool" -v -list -keystore "${TARGET}" -storepass changeit
