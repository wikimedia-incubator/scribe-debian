If you are looking for Debian/Ubuntu packaging for scribe, you have come to
the right place!

# Prebuilt deb packages
The packages in deb/ were built on amd64 Ubuntu Lucid 10.04.

# Building Packages
```build.sh``` will clone the [thrift](https://github.com/wikimedia-incubator/thrift),
[thrift-fb303](https://github.com/wikimedia-incubator/thrift-fb303),
[scribe](https://github.com/wikimedia-incubator/scribe) and 
[log4j-scribe-appender](https://github.com/wikimedia-incubator/log4j-scribe-appender/) repositories,
and build deb packages for each.  Packages are stored in deb/.

```uninstall.sh``` will use aptitude to find and uninstall anything that
```build.sh``` installed while it was building the packages.  


# History
This is meant to be used with the wmf-analytics repositories.

The thrift, fb303 and scribe repositories have been forked from 
[simplegeo](https://github.com/simplegeo)'s, but modified and updated so that
they build more seemless.  The wmf-analytics forks build the java libraries for
thrift, fb303 and scribe.  

[log4j-scribe-appender](https://github.com/wikimedia-incubator/log4j-scribe-appender/)
was forked from [joshdevins](https://github.com/joshdevins/log4j-scribe-appender)
so that debian/ packaging could be added.

*NOTE*: A [thrift-debian](https://github.com/wikimedia-incubator/thrift-debian)
repository also exists to build thrift packages. That repository is not used
for this packaging of scribe, since getting building scribe against a newer
version of thrift proved to be pretty much impossible.
