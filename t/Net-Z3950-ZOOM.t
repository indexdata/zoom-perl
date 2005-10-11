# $Id: Net-Z3950-ZOOM.t,v 1.4 2005-10-11 15:48:15 mike Exp $

# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl Net-Z3950-ZOOM.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use Test::More tests => 1;
BEGIN { use_ok('Net::Z3950::ZOOM') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

my $host = "indexdata.com/gils";
my $port = 0;
my $errcode;
my($errmsg, $addinfo) = ("dummy", "dummy");

my $conn = Net::Z3950::ZOOM::connection_new($host, $port);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
if ($errcode != 0) {
    die("Can't connect to host '$host', port '$port': ",
	"errcode='$errcode', errmsg='$errmsg', addinfo='$addinfo'");
}

Net::Z3950::ZOOM::connection_option_set($conn,
					preferredRecordSyntax => "usmarc");

my $query = '@attr 1=4 minerals';
my $rs = Net::Z3950::ZOOM::connection_search_pqf($conn, $query);
$errcode = Net::Z3950::ZOOM::connection_error($conn, $errmsg, $addinfo);
if ($errcode != 0) {
    die("Can't search for '$query': ",
	"errcode='$errcode', errmsg='$errmsg', addinfo='$addinfo'");
}

my $n = Net::Z3950::ZOOM::resultset_size($rs);
print STDERR "Result count: $n\n";

for (my $i = 0; $i < $n; $i++) {
    my $rec = Net::Z3950::ZOOM::resultset_record($rs, $i);
    my $len = 0;
    my $data = Net::Z3950::ZOOM::record_get($rec, "render", $len);
    print STDERR "=== record ", $i+1, " of $n ===\n", $data;
    my $raw = Net::Z3950::ZOOM::record_get($rec, "raw", $len);
    print STDERR "--- raw version ---\n", $raw;
}

Net::Z3950::ZOOM::resultset_destroy($rs);
Net::Z3950::ZOOM::connection_destroy($conn);
