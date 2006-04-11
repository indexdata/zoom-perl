use ZOOM;
@targets = ('z3950.loc.gov:7090/Voyager',
	    'bagel.indexdata.com:210/gils');
$o = new ZOOM::Options();
$o->option(async => 1);		# asynchronous mode
$o->option(count => 1);		# piggyback retrieval count
$o->option(preferredRecordSyntax => "usmarc");
for ($i = 0; $i < @targets; $i++) {
    $z[$i] = create ZOOM::Connection($o);
    $z[$i]->connect($targets[$i]);
    $r[$i] = $z[$i]->search_pqf("mineral");
}
while (($i = ZOOM::event(\@z)) != 0) {
    $ev = $z[$i-1]->last_event();
    print("connection ", $i-1, ": ", ZOOM::event_str($ev), "\n");
    if ($ev == ZOOM::Event::ZEND) {
	$size = $r[$i-1]->size();
	print "connection ", $i-1, ": $size hits\n";
	print $r[$i-1]->record(0)->render()
	    if $size > 0;
    }
}
