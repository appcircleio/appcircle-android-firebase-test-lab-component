# Firebase Test Lab for Android

This step allows you to run Firebase Test Lab tests using [gcloud](https://cloud.google.com/sdk/gcloud/reference/firebase/test/android/run). `gcloud firebase test android run` invokes tests in Firebase Test Lab tests for Android. 

Required Input Variables
- `$AC_FIREBASE_PROJECT_ID`: Specifies the firebase project id
- `$AC_FIREBASE_KEY_FILE`: Specifies the firebase key file (P12 or JSON format)
- `$AC_FIREBASE_BUCKET_NAME`: Specifies the bucket name
- `$AC_APK_PATH`: The path to the application binary file
- `$AC_TEST_APK_PATH`: The path to the application binary file for instrumentation tests

Optional Input Variables
- `$AC_FIREBASE_TEST_TYPE`: Specifies the firebase test type. Defaults to `robo`
- `$AC_FIREBASE_EXTRA_ARGS`: Specifies extra arguments