
If you are looking for Debian/Ubuntu packaging for scribe, you have come to
the right place!

# Prebuilt deb packages
The packages in deb/ were built on amd64 Ubuntu Lucid 10.04.

# Building Packages
```build.sh``` will clone the [thrift](https://github.com/wmf-analytics/thrift),
[thrift-fb303](https://github.com/wmf-analytics/thrift-fb303), and
[scribe](https://github.com/wmf-analytics/scribe) repositories,
and build deb packages for each.  Packages are stored in deb/.

```uninstall.sh``` will use aptitude to find and uninstall anything that
```build.sh``` installed while it was building the packages.  


# History
This is meant to be used with the wmf-analytics repositories.
These repositories have been forked from 
[simplegeo](https://github.com/simplegeo)'s, but modified and updated so that
they build more seemless.  The wmf-analytics forks build the java libraries for
thrift, fb303 and scribe.  

NOTE: A [thrift-debian](https://github.com/wmf-analytics/thrift-debian)
repository also exists to build thrift packages. That repository is not used
this packaging of scribe, since getting building scribe against a newer
version of thrift proved to be pretty much impossible.
