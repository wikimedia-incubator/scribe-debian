If you are looking for Debian/Ubuntu packaging for scribe, you have come to
the right place!

build.sh will clone thrift, thrift-fb303, and scribe repositories, 
and build deb packages for each.  Packages are stored in deb/.

uninstall.sh will use aptitude to uninstall anything that ./build.sh installed
while it was building the packages.  

This is meant to be used with the wmf-analytics repositories.  
These repositories have been cloned from simplegeo's, but modified and updated
so that they work seemlessly, and also build java libraries for scribe.

Note that wmf-analytics/thrift-debian also exists to build thrift packages.
This repository is not used with scribe, since getting the correct version of
thrift installed to work with scribe is a bit tricky.
