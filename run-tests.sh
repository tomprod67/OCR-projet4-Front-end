#!/bin/bash

RESULT_DIR="test-results"

echo "Running tests..."

mkdir -p "$RESULT_DIR"


# -------------------------
# JAVA (Gradle)
# -------------------------
if [ -f "build.gradle" ]; then
  echo "Gradle project detected"

  ./gradlew clean test #Lancement des tests java

  if [ -d "build/test-results/test" ]; then
    cp build/test-results/test/*.xml "$RESULT_DIR"
    echo "Gradle reports copied"
  else
    echo "No result found"
    exit 1
  fi


# -------------------------
# ANGULAR
# -------------------------
elif [ -f "package.json" ]; then
  echo "Angular project detected"

  npm ci --cache .npm --prefer-offline

  # tests headless (important pour CI)
  npm test

  if [ -d "test-results" ]; then
    cp reports/*.xml "$RESULT_DIR"
    echo "Angular reports copied"
  else
    echo "No result found"
  fi


# -------------------------
# UNKNOWN
# -------------------------
else
  echo "❌ Unknown project type"
  exit 1
fi

echo "🎉 Done. Results in $RESULT_DIR"