export IHP_ENV=Production
export IHP_BASEURL=https://35.209.52.248
export DATABASE_URL=postgresql://postgres@localhost/app
#export IHP_LIB=/nix/store/fprzkxymn6q8smh13z7r87r918m6gmrf-source/lib/IHP
# export PORT=80
export PORT=8000
./build/bin/RunProdServer
