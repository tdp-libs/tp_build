
## OSX
Install and locate the library.
```
brew install freetype
sudo /usr/libexec/locate.updatedb
locate ft2build.h
```
The locate command will return the path to the library, add this path to your projects top level project.inc file.
```
INCLUDEPATHS += /usr/local/Cellar/freetype/2.9.1/include/freetype2/
LIBRARYPATHS += /usr/local/Cellar/freetype/2.9.1/lib/
```
