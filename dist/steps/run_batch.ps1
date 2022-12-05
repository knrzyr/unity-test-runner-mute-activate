#
# Set and display project path
#

$UNITY_PROJECT_PATH = "${env:GITHUB_WORKSPACE}/${env:PROJECT_PATH}"
Write-Output "Using project path $UNITY_PROJECT_PATH"

#
# Set and display the artifacts path
#

Write-Output "Using artifacts path ${env:ARTIFACTS_PATH} to save test results."
$FULL_ARTIFACTS_PATH = "${env:GITHUB_WORKSPACE}\${env:ARTIFACTS_PATH}"

#
# Display custom parameters
#

Write-Output "Using custom parameters ${env:CUSTOM_PARAMETERS}"

# The following tests are 2019 mode (requires Unity 2019.2.11f1 or later)
# Reference: https://docs.unity3d.com/2019.3/Documentation/Manual/CommandLineArguments.html

#
# Display the unity version
#

Write-Output "Using Unity version ${env:UNITY_VERSION} to test."

#
# Overall info
#

Write-Output ""
Write-Output "###########################"
Write-Output "#    Artifacts folder     #"
Write-Output "###########################"
Write-Output ""
Write-Output "Creating $FULL_ARTIFACTS_PATH if it does not exist."
New-Item -Path "$FULL_ARTIFACTS_PATH" -ItemType Directory

Write-Output ""
Write-Output "###########################"
Write-Output "#    Project directory    #"
Write-Output "###########################"
Write-Output ""
Get-ChildItem -Hidden -Path $UNITY_PROJECT_PATH

#
# Run batchmode
#
Write-Output ""
Write-Output "###########################"
Write-Output "#   Batchmode             #"
Write-Output "###########################"
Write-Output ""

$RUN_OUTPUT = Start-Process -NoNewWindow -Wait -PassThru "C:\Program Files\Unity\Hub\Editor\${env:UNITY_VERSION}\editor\Unity.exe" -ArgumentList "-batchmode  -projectPath $UNITY_PROJECT_PATH -executeMethod $EXECUTE_METHOD -quit ${env:CUSTOM_PARAMETERS} | Tee-Object -FilePath $FULL_ARTIFACTS_PATH\run.log"

# Catch exit code
$RUN_EXIT_CODE = $RUN_OUTPUT.ExitCode

# Print unity log output
Get-Content "$FULL_ARTIFACTS_PATH/run.log"

# Display results
if ($RUN_EXIT_CODE -eq 0)
{
    Write-Output "Run succeeded, no failures occurred";
}
elseif ($RUN_EXIT_CODE -eq 2)
{
    Write-Output "Run succeeded, some tests failed";
}
elseif ($RUN_EXIT_CODE -eq 3)
{
    Write-Output "Run failure (other failure)";
}
else
{
    Write-Output "Unexpected exit code $RUN_EXIT_CODE";
}

if ( $RUN_EXIT_CODE -ne 0)
{
    $UNITY_RUNNER_EXIT_CODE = $RUN_EXIT_CODE
}
