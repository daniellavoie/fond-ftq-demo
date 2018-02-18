#!/bin/sh

echo "Deploying to production"

unzip artefacts/publish.zip -d artefacts

cf api $CF_API --skip-ssl-validation

cf auth $CF_USER $CF_PASSWORD

cf target -o $CF_ORG -s $CF_SPACE

cf rename FortunesLegacyService FortunesLegacyService-old
cf rename FortunesLegacyUI FortunesLegacyUI-old
cf rename FortunesService FortunesService-old
cf rename FortunesUI FortunesUI-old

cf push -f src/ci/environments/manifest-$ENVIRONMENT.yml

cf delete -f FortunesLegacyService-old
cf delete -f FortunesLegacyUI-old
cf delete -f FortunesService-old
cf delete -f FortunesUI-old