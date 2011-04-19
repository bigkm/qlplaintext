QLPlainText
===========

QLPlainText is a QuickLook plugin based on QuickLookStephen that lets you view
plain text files without a file extension. Plus it allows for simple adaption of
new file types with ease. 

Files like:

* README
* INSTALL
* CapFile
* CHANGELOG
* [KitSpec](https://github.com/nkpart/kit) (YAML specification)
* etc...


Install
=======
Run the build and it will be installed

or 

1. copy the QLPlainText.qlgenerator file into ~/Library/Quicklook/
2. run `qlmanage -r`


Building
========
There is a file inside `QLPlainText.xcodeproj/user.pbxuser` you can copy this 
to your username, and you will get an executable, so that your build and run 
button will do something. 
