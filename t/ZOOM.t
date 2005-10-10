# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl ZOOM.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 1;
BEGIN { use_ok('ZOOM') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $host = "localhost";
my $port = 3950;
my $errcode;
my($errmsg, $addinfo) = ("dummy", "dummy");

my $conn = ZOOM::ZOOM_connection_new($host, $port);
if (($errcode = ZOOM::ZOOM_connection_error($conn, $errmsg, $addinfo)) != 0) {
    die("Can't connect to host '$host', port '$port': ",
	"errcode='$errcode', errmsg='$errmsg', addinfo='$addinfo'");
}

my $query = '@attr 1=4 taylor';
my $rs = ZOOM::ZOOM_connection_search_pqf($conn, $query);
if (($errcode = ZOOM::ZOOM_connection_error($conn, $errmsg, $addinfo)) != 0) {
    die("Can't search for '$query': ",
	"errcode='$errcode', errmsg='$errmsg', addinfo='$addinfo'");
}

print STDERR "Result count: ", ZOOM::ZOOM_resultset_size($rs), "\n";
ZOOM::ZOOM_resultset_destroy($rs);
ZOOM::ZOOM_connection_destroy($conn);
