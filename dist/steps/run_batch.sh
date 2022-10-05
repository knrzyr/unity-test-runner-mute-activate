#!/usr/bin/env bash

#
# Set and display project path
#

UNITY_PROJECT_PATH="$GITHUB_WORKSPACE/$PROJECT_PATH"
echo "Using project path \"$UNITY_PROJECT_PATH\"."

#
# Set and display the artifacts path
#

echo "Using artifacts path \"$ARTIFACTS_PATH\" to save test results."
FULL_ARTIFACTS_PATH=$GITHUB_WORKSPACE/$ARTIFACTS_PATH

#
# Display custom parameters
#

echo "Using custom parameters $CUSTOM_PARAMETERS."

# The following tests are 2019 mode (requires Unity 2019.2.11f1 or later)
# Reference: https://docs.unity3d.com/2019.3/Documentation/Manual/CommandLineArguments.html

#
# Display the unity version
#

echo "Using Unity version \"$UNITY_VERSION\" to test."

#
# Overall info
#

echo ""
echo "###########################"
echo "#    Artifacts folder     #"
echo "###########################"
echo ""
echo "Creating \"$FULL_ARTIFACTS_PATH\" if it does not exist."
mkdir -p $FULL_ARTIFACTS_PATH

echo ""
echo "###########################"
echo "#    Project directory    #"
echo "###########################"
echo ""
ls -alh $UNITY_PROJECT_PATH

#
# Run batchmode
#

echo ""
echo "###########################"
echo "#   Batchmode             #"
echo "###########################"
echo ""

unity-editor \
    -batchmode \
    -logFile "$FULL_ARTIFACTS_PATH/run.log" \
    -projectPath "$UNITY_PROJECT_PATH" \
    -executeMethod "$EXECUTE_METHOD" \
    -quit \
    $CUSTOM_PARAMETERS

# Catch exit code
RUN_EXIT_CODE=$?

# Print unity log output
cat "$FULL_ARTIFACTS_PATH/run.log"

# Display results
if [ $RUN_EXIT_CODE -eq 0 ]; then
  echo "Run succeeded, no failures occurred";
elif [ $RUN_EXIT_CODE -eq 2 ]; then
  echo "Run succeeded, some tests failed";
elif [ $RUN_EXIT_CODE -eq 3 ]; then
  echo "Run failure (other failure)";
else
  echo "Unexpected exit code $RUN_EXIT_CODE";
fi

if [ $RUN_EXIT_CODE -ne 0 ]; then
  UNITY_RUNNER_EXIT_CODE=$RUN_EXIT_CODE
fi

#
# Permissions
#

# Make a given user owner of all artifacts
if [[ -n "$CHOWN_FILES_TO" ]]; then
  chown -R "$CHOWN_FILES_TO" "$UNITY_PROJECT_PATH"
  chown -R "$CHOWN_FILES_TO" "$FULL_ARTIFACTS_PATH"
fi

# Add read permissions for everyone to all artifacts
chmod -R a+r "$UNITY_PROJECT_PATH"
chmod -R a+r "$FULL_ARTIFACTS_PATH"
