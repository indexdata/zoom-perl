# Creates a distribution tarball of the kind that Debian packages are
# made from.
DEBCHANGELOG=debian/changelog

l=`head -1 $DEBCHANGELOG`
NAME=`echo $l|sed 's/ .*//g'`
FULLVERSION=`echo $l|sed 's/.*(//g'|sed 's/).*//g'`
VERSION=`echo $FULLVERSION|sed 's/-.*//g'`

git archive --format=tar --prefix=$NAME-$VERSION/ HEAD > $NAME-$VERSION.tar
tar xf $NAME-$VERSION.tar
rm -r $NAME-$VERSION/{debian,archive,modules}
tar cfz $NAME-$VERSION.tar.gz $NAME-$VERSION
rm $NAME-$VERSION.tar
rm -r $NAME-$VERSION
