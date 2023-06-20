export APP_ID==$(openssl rand -hex 16)
export APP_SECRET=$(openssl rand -hex 16)

echo -e "APP_ID=$APP_ID\nAPP_SECRET=$APP_SECRET"

flutter build appbundle --release --dart-define-from-file=env-prod.json  --dart-define=APP_ID=$APP_ID  --dart-define=APP_SECRET=$APP_SECRET

exit_status=$?


if test $exit_status -eq 0
then
    curl -L -X  'POST' \
    'http://34.111.43.213/api/register_build' \
    -H 'accept: application/json' \
    -H 'Content-Type: multipart/form-data' \
    -F "app_id=$APP_ID" \
    -F "app_secret=$APP_SECRET" \
    -F "auth_key=1234"
    echo ""
else
    echo "build failed with exit staus - $exit_status"
fi
