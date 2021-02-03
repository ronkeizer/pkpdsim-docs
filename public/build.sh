# build md into html in _book folder
# npm install
# gitbook install
gitbook build

# for some reason Heroku doesn't like the _book folder...
rm -rf public
cp -R _book public
