export PORT=8000
export IHP_ENV=Production
export IHP_BASEURL=http://35.209.52.248:$PORT
export DATABASE_URL=postgresql://postgres@localhost/app
#export IHP_LIB=/nix/store/fprzkxymn6q8smh13z7r87r918m6gmrf-source/lib/IHP
# export PORT=80
./build/bin/RunProdServer
