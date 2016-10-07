# build md into html in _book folder
gitbook build

# for some reason Heroku doesn't like the _book folder...
cp -R _book public
