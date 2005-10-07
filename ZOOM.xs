#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <yaz/zoom.h>


MODULE = ZOOM		PACKAGE = ZOOM		


const char *
ZOOM_connection_addinfo(c)
	ZOOM_connection	c

void
ZOOM_connection_connect(c, host, portnum)
	ZOOM_connection	c
	const char *	host
	int	portnum

ZOOM_connection
ZOOM_connection_create(options)
	ZOOM_options	options

void
ZOOM_connection_destroy(c)
	ZOOM_connection	c

int
ZOOM_connection_errcode(c)
	ZOOM_connection	c

const char *
ZOOM_connection_errmsg(c)
	ZOOM_connection	c

int
ZOOM_connection_error(c, cp, addinfo)
	ZOOM_connection	c
	const char **	cp
	const char **	addinfo

int
ZOOM_connection_error_x(c, cp, addinfo, diagset)
	ZOOM_connection	c
	const char **	cp
	const char **	addinfo
	const char **	diagset

int
ZOOM_connection_last_event(cs)
	ZOOM_connection	cs

ZOOM_connection
ZOOM_connection_new(host, portnum)
	const char *	host
	int	portnum

const char *
ZOOM_connection_option_get(c, key)
	ZOOM_connection	c
	const char *	key

void
ZOOM_connection_option_set(c, key, val)
	ZOOM_connection	c
	const char *	key
	const char *	val

void
ZOOM_connection_option_setl(c, key, val, len)
	ZOOM_connection	c
	const char *	key
	const char *	val
	int	len

ZOOM_package
ZOOM_connection_package(c, options)
	ZOOM_connection	c
	ZOOM_options	options

ZOOM_scanset
ZOOM_connection_scan(c, startterm)
	ZOOM_connection	c
	const char *	startterm

ZOOM_resultset
ZOOM_connection_search(arg0, q)
	ZOOM_connection	arg0
	ZOOM_query	q

ZOOM_resultset
ZOOM_connection_search_pqf(c, q)
	ZOOM_connection	c
	const char *	q

const char *
ZOOM_diag_str(error)
	int	error

int
ZOOM_event(no, cs)
	int	no
	ZOOM_connection *	cs

ZOOM_options
ZOOM_options_create()

ZOOM_options
ZOOM_options_create_with_parent(parent)
	ZOOM_options	parent

ZOOM_options
ZOOM_options_create_with_parent2(parent1, parent2)
	ZOOM_options	parent1
	ZOOM_options	parent2

void
ZOOM_options_destroy(opt)
	ZOOM_options	opt

const char *
ZOOM_options_get(opt, name)
	ZOOM_options	opt
	const char *	name

int
ZOOM_options_get_bool(opt, name, defa)
	ZOOM_options	opt
	const char *	name
	int	defa

int
ZOOM_options_get_int(opt, name, defa)
	ZOOM_options	opt
	const char *	name
	int	defa

void
ZOOM_options_set(opt, name, v)
	ZOOM_options	opt
	const char *	name
	const char *	v

ZOOM_options_callback
ZOOM_options_set_callback(opt, c, handle)
	ZOOM_options	opt
	ZOOM_options_callback	c
	void *	handle

void
ZOOM_options_set_int(opt, name, value)
	ZOOM_options	opt
	const char *	name
	int	value

void
ZOOM_options_setl(opt, name, value, len)
	ZOOM_options	opt
	const char *	name
	const char *	value
	int	len

void
ZOOM_package_destroy(p)
	ZOOM_package	p

const char *
ZOOM_package_option_get(p, key)
	ZOOM_package	p
	const char *	key

void
ZOOM_package_option_set(p, key, val)
	ZOOM_package	p
	const char *	key
	const char *	val

void
ZOOM_package_send(p, type)
	ZOOM_package	p
	const char *	type

int
ZOOM_query_cql(s, str)
	ZOOM_query	s
	const char *	str

ZOOM_query
ZOOM_query_create()

void
ZOOM_query_destroy(s)
	ZOOM_query	s

int
ZOOM_query_prefix(s, str)
	ZOOM_query	s
	const char *	str

int
ZOOM_query_sortby(s, criteria)
	ZOOM_query	s
	const char *	criteria

ZOOM_record
ZOOM_record_clone(srec)
	ZOOM_record	srec

void
ZOOM_record_destroy(rec)
	ZOOM_record	rec

const char *
ZOOM_record_get(rec, type, len)
	ZOOM_record	rec
	const char *	type
	int *	len

void
ZOOM_resultset_cache_reset(r)
	ZOOM_resultset	r

void
ZOOM_resultset_destroy(r)
	ZOOM_resultset	r

const char *
ZOOM_resultset_option_get(r, key)
	ZOOM_resultset	r
	const char *	key

void
ZOOM_resultset_option_set(r, key, val)
	ZOOM_resultset	r
	const char *	key
	const char *	val

ZOOM_record
ZOOM_resultset_record(s, pos)
	ZOOM_resultset	s
	size_t	pos

ZOOM_record
ZOOM_resultset_record_immediate(s, pos)
	ZOOM_resultset	s
	size_t	pos

void
ZOOM_resultset_records(r, recs, start, count)
	ZOOM_resultset	r
	ZOOM_record *	recs
	size_t	start
	size_t	count

size_t
ZOOM_resultset_size(r)
	ZOOM_resultset	r

void
ZOOM_resultset_sort(r, sort_type, sort_spec)
	ZOOM_resultset	r
	const char *	sort_type
	const char *	sort_spec

void
ZOOM_scanset_destroy(scan)
	ZOOM_scanset	scan

const char *
ZOOM_scanset_display_term(scan, pos, occ, len)
	ZOOM_scanset	scan
	size_t	pos
	int *	occ
	int *	len

const char *
ZOOM_scanset_option_get(scan, key)
	ZOOM_scanset	scan
	const char *	key

void
ZOOM_scanset_option_set(scan, key, val)
	ZOOM_scanset	scan
	const char *	key
	const char *	val

size_t
ZOOM_scanset_size(scan)
	ZOOM_scanset	scan

const char *
ZOOM_scanset_term(scan, pos, occ, len)
	ZOOM_scanset	scan
	size_t	pos
	int *	occ
	int *	len

