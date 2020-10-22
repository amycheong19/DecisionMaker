#!/bin/bash

VERSION="$1"
ARTIFACT="Pickr"

set -e
set -o xtrace

cd "$(dirname "$0")/../"

git checkout master

if [ -z "$VERSION" ]
then
    echo "Building older version"
else
    ARTIFACT="Pickr-$VERSION"
    echo "Creating $ARTIFACT"
    sleep 3
    
    # Update marketting version to match $VERSION
    sed -i '' "s/^				MARKETING_VERSION =.*$/				MARKETING_VERSION = $VERSION;/g" 'DecisionMaker.xcodeproj/project.pbxproj'
    
    # Increment build number
    BUILD_VERSION=$(xcodebuild -project DecisionMaker.xcodeproj -target DecisionMaker -showBuildSettings | grep "CURRENT_PROJECT_VERSION" | sed 's/[ ]*CURRENT_PROJECT_VERSION = //')
    BUILD_VERSION=$((BUILD_VERSION+1))
    sed -i '' "s/^				CURRENT_PROJECT_VERSION =.*$/				CURRENT_PROJECT_VERSION = $BUILD_VERSION;/g" 'DecisionMaker.xcodeproj/project.pbxproj'

    # Commit changes
    git add 'DecisionMaker.xcodeproj/project.pbxproj'
    git commit -m "Increment version to $VERSION ($BUILD_VERSION)"
    git push
    git tag "$VERSION"
    git push --tags
fi

# Build
xcodebuild -project DecisionMaker.xcodeproj -scheme AppStore -sdk iphoneos -configuration Release archive -archivePath /tmp/build/${ARTIFACT}.xcarchive

# Export & upload the archive
xcodebuild -exportArchive -archivePath /tmp/build/${ARTIFACT}.xcarchive -allowProvisioningUpdates -exportOptionsPlist scripts/exportOptions.plist

