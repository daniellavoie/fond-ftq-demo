#!/bin/sh

echo "Deploying to production"

unzip artefacts/publish.zip -d artefacts
rm artefacts/manifest.yml
cp src/ci/environments/manifest-$ENVIRONMENT.yml artefacts/manifest.yml

cf api $CF_API --skip-ssl-validation

cf auth $CF_USER $CF_PASSWORD

cf target -o $CF_ORG -s $CF_SPACE

cf rename FortunesLegacyService FortunesLegacyService-old
cf rename FortunesLegacyUI FortunesLegacyUI-old
cf rename FortunesService FortunesService-old
cf rename FortunesUI FortunesUI-old

cf push -f artefacts/manifest.yml

cf delete -f FortunesLegacyService-old
cf delete -f FortunesLegacyUI-old
cf delete -f FortunesService-old
cf delete -f FortunesUI-old