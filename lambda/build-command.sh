BUILD_NON_PARALLEL="nix-build"
LAMBDA_NAME='i-have-the-godly-lambda-name-of-hs-lambda'

${BUILD_NON_PARALLEL} -E '(import ./lambda.nix { lambda-version = "0.2.0"; })' -o my-out-dir/${LAMBDA_NAME}