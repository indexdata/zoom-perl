/* $Id: ZOOM.xs,v 1.13 2005-10-17 13:42:43 mike Exp $ */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <yaz/zoom.h>

/* Used by the *_setl() functions */
typedef char opaquechar;

/* Used as the return value of the *_getl() functions */
struct datachunk {
	char *data;
	int len;
};

MODULE = Net::Z3950::ZOOM		PACKAGE = Net::Z3950::ZOOM		PREFIX=ZOOM_

PROTOTYPES: ENABLE


# TESTED
ZOOM_connection
ZOOM_connection_new(host, portnum)
	const char* host
	int portnum

# TESTED
ZOOM_connection
ZOOM_connection_create(options)
	ZOOM_options options

# TESTED
void
ZOOM_connection_connect(c, host, portnum)
	ZOOM_connection	c
	const char* host
	int portnum

# TESTED
void
ZOOM_connection_destroy(c)
	ZOOM_connection	c

# TESTED
const char *
ZOOM_connection_option_get(c, key)
	ZOOM_connection	c
	const char *key

# TESTED
struct datachunk
ZOOM_connection_option_getl(c, key, len)
	ZOOM_connection	c
	const char *key
	int &len
	CODE:
		RETVAL.data = (char*) ZOOM_connection_option_getl(c, key, &RETVAL.len);
	OUTPUT:
		RETVAL

# TESTED
void
ZOOM_connection_option_set(c, key, val)
	ZOOM_connection	c
	const char *key
	const char *val

# In ZOOM-C, the `val' parameter is const char*.  However, our typemap
# treats this as T_PV, i.e. it's "known" that it points to a
# NUL-terminated string.  Instead, then, I here use const void*, which
# is an opaque pointer.  The underlying C function can then use this
# along with `len' to Do The Right Thing.
#
# TESTED
void
ZOOM_connection_option_setl(c, key, val, len)
	ZOOM_connection	c
	const char* key
	opaquechar* val
	int len

# The reference parameters, `cp' and `addinfo', need to already have
# values when this function is called, otherwise an "uninitialised
# value" warning is generated.  As far as I can see, there is no way
# around this: no way to specify in a prototype that an argument is
# allowed to be undefined, for example.  Since these function will
# never be called directly by well-behaved client code, but only by
# our own wrapper classes, I think we can live with that.
#
# The poxing about with cpp and caddinfo is due to Perl XS's lack of
# support for const char**, but who can blame it?  If you ask me, the
# whole "const" thing was well-intentioned by ghastly mistake.
#
# TESTED
int
ZOOM_connection_error(c, cp, addinfo)
	ZOOM_connection	c
	char* &cp
	char* &addinfo
	CODE:
		const char *ccp, *caddinfo;
		RETVAL = ZOOM_connection_error(c, &ccp, &caddinfo);
		cp = (char*) ccp;
		addinfo = (char*) caddinfo;
	OUTPUT:
		RETVAL
		cp
		addinfo

# See comments for ZOOM_connection_error() above
# TESTED
int
ZOOM_connection_error_x(c, cp, addinfo, diagset)
	ZOOM_connection	c
	const char * &cp
	const char * &addinfo
	const char * &diagset
	CODE:
		const char *ccp, *caddinfo, *cdset;
		RETVAL = ZOOM_connection_error_x(c, &ccp, &caddinfo, &cdset);
		cp = (char*) ccp;
		addinfo = (char*) caddinfo;
		diagset = (char*) cdset;
	OUTPUT:
		RETVAL
		cp
		addinfo
		diagset

# TESTED
int
ZOOM_connection_errcode(c)
	ZOOM_connection	c

# TESTED
const char *
ZOOM_connection_errmsg(c)
	ZOOM_connection	c

# TESTED
const char *
ZOOM_connection_addinfo(c)
	ZOOM_connection	c

# TESTED
const char *
ZOOM_diag_str(error)
	int error

# UNTESTED
int
ZOOM_connection_last_event(cs)
	ZOOM_connection	cs

# UNTESTED
ZOOM_resultset
ZOOM_connection_search(arg0, q)
	ZOOM_connection	arg0
	ZOOM_query	q

# TESTED
ZOOM_resultset
ZOOM_connection_search_pqf(c, q)
	ZOOM_connection c
	const char *q

# TESTED
void
ZOOM_resultset_destroy(r)
	ZOOM_resultset r

# UNTESTED
const char *
ZOOM_resultset_option_get(r, key)
	ZOOM_resultset	r
	const char *	key

# UNTESTED
void
ZOOM_resultset_option_set(r, key, val)
	ZOOM_resultset	r
	const char *	key
	const char *	val

# TESTED
size_t
ZOOM_resultset_size(r)
	ZOOM_resultset r

# UNTESTED
void
ZOOM_resultset_records(r, recs, start, count)
	ZOOM_resultset	r
	ZOOM_record *	recs
	size_t	start
	size_t	count

# TESTED
ZOOM_record
ZOOM_resultset_record(s, pos)
	ZOOM_resultset s
	size_t pos

# UNTESTED
ZOOM_record
ZOOM_resultset_record_immediate(s, pos)
	ZOOM_resultset	s
	size_t	pos

# UNTESTED
void
ZOOM_resultset_cache_reset(r)
	ZOOM_resultset	r

# See "typemap" for discussion of the "const char *" return-type.
#
# TESTED
### but should use datachunk
const char *
ZOOM_record_get(rec, type, len)
	ZOOM_record rec
	const char* type
	int &len
	OUTPUT:
		RETVAL
		len

# UNTESTED
void
ZOOM_record_destroy(rec)
	ZOOM_record	rec

# UNTESTED
ZOOM_record
ZOOM_record_clone(srec)
	ZOOM_record	srec

# UNTESTED
ZOOM_query
ZOOM_query_create()

# UNTESTED
void
ZOOM_query_destroy(s)
	ZOOM_query	s

# UNTESTED
int
ZOOM_query_cql(s, str)
	ZOOM_query	s
	const char *	str

# UNTESTED
int
ZOOM_query_prefix(s, str)
	ZOOM_query	s
	const char *	str

# UNTESTED
int
ZOOM_query_sortby(s, criteria)
	ZOOM_query	s
	const char *	criteria

# UNTESTED
ZOOM_scanset
ZOOM_connection_scan(c, startterm)
	ZOOM_connection	c
	const char *	startterm

# UNTESTED
const char *
ZOOM_scanset_term(scan, pos, occ, len)
	ZOOM_scanset	scan
	size_t	pos
	int *	occ
	int *	len

# UNTESTED
const char *
ZOOM_scanset_display_term(scan, pos, occ, len)
	ZOOM_scanset	scan
	size_t	pos
	int *	occ
	int *	len

# UNTESTED
size_t
ZOOM_scanset_size(scan)
	ZOOM_scanset	scan

# UNTESTED
void
ZOOM_scanset_destroy(scan)
	ZOOM_scanset	scan

# UNTESTED
const char *
ZOOM_scanset_option_get(scan, key)
	ZOOM_scanset	scan
	const char *	key

# UNTESTED
void
ZOOM_scanset_option_set(scan, key, val)
	ZOOM_scanset	scan
	const char *	key
	const char *	val

# UNTESTED
ZOOM_package
ZOOM_connection_package(c, options)
	ZOOM_connection	c
	ZOOM_options	options

# UNTESTED
void
ZOOM_package_destroy(p)
	ZOOM_package	p

# UNTESTED
void
ZOOM_package_send(p, type)
	ZOOM_package	p
	const char *	type

# UNTESTED
const char *
ZOOM_package_option_get(p, key)
	ZOOM_package	p
	const char *	key

# UNTESTED
void
ZOOM_package_option_set(p, key, val)
	ZOOM_package	p
	const char *	key
	const char *	val

# UNTESTED
void
ZOOM_resultset_sort(r, sort_type, sort_spec)
	ZOOM_resultset	r
	const char *	sort_type
	const char *	sort_spec

# UNTESTED
ZOOM_options_callback
ZOOM_options_set_callback(opt, c, handle)
	ZOOM_options	opt
	ZOOM_options_callback	c
	void *	handle

# TESTED
ZOOM_options
ZOOM_options_create()

# UNTESTED
ZOOM_options
ZOOM_options_create_with_parent(parent)
	ZOOM_options	parent

# UNTESTED
ZOOM_options
ZOOM_options_create_with_parent2(parent1, parent2)
	ZOOM_options	parent1
	ZOOM_options	parent2

# UNTESTED
const char *
ZOOM_options_get(opt, name)
	ZOOM_options	opt
	const char *	name

# UNTESTED
const char *
ZOOM_options_getl(opt, name, len)
	ZOOM_options	opt
	const char *	name
	int	&len

# UNTESTED
void
ZOOM_options_set(opt, name, v)
	ZOOM_options	opt
	const char *	name
	const char *	v

# UNTESTED
void
ZOOM_options_setl(opt, name, value, len)
	ZOOM_options	opt
	const char *	name
	const char *	value
	int	len

# UNTESTED
void
ZOOM_options_destroy(opt)
	ZOOM_options	opt

# UNTESTED
int
ZOOM_options_get_bool(opt, name, defa)
	ZOOM_options	opt
	const char *	name
	int	defa

# UNTESTED
int
ZOOM_options_get_int(opt, name, defa)
	ZOOM_options	opt
	const char *	name
	int	defa

# UNTESTED
void
ZOOM_options_set_int(opt, name, value)
	ZOOM_options	opt
	const char *	name
	int	value

# UNTESTED
int
ZOOM_event(no, cs)
	int	no
	ZOOM_connection *	cs

