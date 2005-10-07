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

void
_Exit(__status)
	int	__status

size_t
__ctype_get_mb_cur_max()

char *
__secure_getenv(__name)
	__const char *	__name

double
__strtod_internal(__nptr, __endptr, __group)
	__const char *	__nptr
	char **	__endptr
	int	__group

float
__strtof_internal(__nptr, __endptr, __group)
	__const char *	__nptr
	char **	__endptr
	int	__group

long int
__strtol_internal(__nptr, __endptr, __base, __group)
	__const char *	__nptr
	char **	__endptr
	int	__base
	int	__group

long double
__strtold_internal(__nptr, __endptr, __group)
	__const char *	__nptr
	char **	__endptr
	int	__group

__extension__ extern long long int
__strtoll_internal(__nptr, __endptr, __base, __group)
	__const char *	__nptr
	char **	__endptr
	int	__base
	int	__group

unsigned long int
__strtoul_internal(__nptr, __endptr, __base, __group)
	__const char *	__nptr
	char **	__endptr
	int	__base
	int	__group

__extension__ extern unsigned long long int
__strtoull_internal(__nptr, __endptr, __base, __group)
	__const char *	__nptr
	char **	__endptr
	int	__base
	int	__group

long int
a64l(__s)
	__const char *	__s

void
abort()

int
abs(__x)
	int	__x

void *
alloca(__size)
	size_t	__size

int
atexit(arg0)
	void ( * __func ) ( void )	arg0

double
atof(__nptr)
	__const char *	__nptr

int
atoi(__nptr)
	__const char *	__nptr

long int
atol(__nptr)
	__const char *	__nptr

__extension__ extern long long int
atoll(__nptr)
	__const char *	__nptr

void *
bsearch(__key, __base, __nmemb, __size, __compar)
	__const void *	__key
	__const void *	__base
	size_t	__nmemb
	size_t	__size
	__compar_fn_t	__compar

void *
calloc(__nmemb, __size)
	size_t	__nmemb
	size_t	__size

char *
canonicalize_file_name(__name)
	__const char *	__name

void
cfree(__ptr)
	void *	__ptr

int
clearenv()

div_t
div(__numer, __denom)
	int	__numer
	int	__denom

double
drand48()

int
drand48_r(__buffer, __result)
	struct drand48_data *	__buffer
	double *	__result

char *
ecvt(__value, __ndigit, __decpt, __sign)
	double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign

int
ecvt_r(__value, __ndigit, __decpt, __sign, __buf, __len)
	double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign
	char *	__buf
	size_t	__len

double
erand48(__xsubi)
	unsigned short int	__xsubi[3]

int
erand48_r(__xsubi, __buffer, __result)
	unsigned short int	__xsubi[3]
	struct drand48_data *	__buffer
	double *	__result

void
exit(__status)
	int	__status

char *
fcvt(__value, __ndigit, __decpt, __sign)
	double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign

int
fcvt_r(__value, __ndigit, __decpt, __sign, __buf, __len)
	double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign
	char *	__buf
	size_t	__len

void
free(__ptr)
	void *	__ptr

char *
gcvt(__value, __ndigit, __buf)
	double	__value
	int	__ndigit
	char *	__buf

char *
getenv(__name)
	__const char *	__name

int
getloadavg(__loadavg, __nelem)
	double	__loadavg[]
	int	__nelem

int
getpt()

int
getsubopt(__optionp, __tokens, __valuep)
	char **	__optionp
	char * __const *	__tokens
	char **	__valuep

int
grantpt(__fd)
	int	__fd

char *
initstate(__seed, __statebuf, __statelen)
	unsigned int	__seed
	char *	__statebuf
	size_t	__statelen

int
initstate_r(__seed, __statebuf, __statelen, __buf)
	unsigned int	__seed
	char *	__statebuf
	size_t	__statelen
	struct random_data *	__buf

long int
jrand48(__xsubi)
	unsigned short int	__xsubi[3]

int
jrand48_r(__xsubi, __buffer, __result)
	unsigned short int	__xsubi[3]
	struct drand48_data *	__buffer
	long int *	__result

char *
l64a(__n)
	long int	__n

long int
labs(__x)
	long int	__x

void
lcong48(__param)
	unsigned short int	__param[7]

int
lcong48_r(__param, __buffer)
	unsigned short int	__param[7]
	struct drand48_data *	__buffer

ldiv_t
ldiv(__numer, __denom)
	long int	__numer
	long int	__denom

__extension__ extern long long int
llabs(__x)
	long long int	__x

__extension__ extern lldiv_t
lldiv(__numer, __denom)
	long long int	__numer
	long long int	__denom

long int
lrand48()

int
lrand48_r(__buffer, __result)
	struct drand48_data *	__buffer
	long int *	__result

void *
malloc(__size)
	size_t	__size

int
mblen(__s, __n)
	__const char *	__s
	size_t	__n

size_t
mbstowcs(__pwcs, __s, __n)
	wchar_t *	__pwcs
	__const char *	__s
	size_t	__n

int
mbtowc(__pwc, __s, __n)
	wchar_t *	__pwc
	__const char *	__s
	size_t	__n

char *
mkdtemp(__template)
	char *	__template

int
mkstemp(__template)
	char *	__template

int
mkstemp64(__template)
	char *	__template

char *
mktemp(__template)
	char *	__template

long int
mrand48()

int
mrand48_r(__buffer, __result)
	struct drand48_data *	__buffer
	long int *	__result

long int
nrand48(__xsubi)
	unsigned short int	__xsubi[3]

int
nrand48_r(__xsubi, __buffer, __result)
	unsigned short int	__xsubi[3]
	struct drand48_data *	__buffer
	long int *	__result

int
on_exit(arg0, __arg)
	void ( * __func ) ( int __status, void * __arg )	arg0
	void *	__arg

int
posix_memalign(__memptr, __alignment, __size)
	void **	__memptr
	size_t	__alignment
	size_t	__size

int
posix_openpt(__oflag)
	int	__oflag

int
pselect(__nfds, __readfds, __writefds, __exceptfds, __timeout, __sigmask)
	int	__nfds
	fd_set *	__readfds
	fd_set *	__writefds
	fd_set *	__exceptfds
	const struct timespec *	__timeout
	const __sigset_t *	__sigmask

char *
ptsname(__fd)
	int	__fd

int
ptsname_r(__fd, __buf, __buflen)
	int	__fd
	char *	__buf
	size_t	__buflen

int
putenv(__string)
	char *	__string

char *
qecvt(__value, __ndigit, __decpt, __sign)
	long double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign

int
qecvt_r(__value, __ndigit, __decpt, __sign, __buf, __len)
	long double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign
	char *	__buf
	size_t	__len

char *
qfcvt(__value, __ndigit, __decpt, __sign)
	long double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign

int
qfcvt_r(__value, __ndigit, __decpt, __sign, __buf, __len)
	long double	__value
	int	__ndigit
	int *	__decpt
	int *	__sign
	char *	__buf
	size_t	__len

char *
qgcvt(__value, __ndigit, __buf)
	long double	__value
	int	__ndigit
	char *	__buf

void
qsort(__base, __nmemb, __size, __compar)
	void *	__base
	size_t	__nmemb
	size_t	__size
	__compar_fn_t	__compar

int
rand()

int
rand_r(__seed)
	unsigned int *	__seed

long int
random()

int
random_r(__buf, __result)
	struct random_data *	__buf
	int32_t *	__result

void *
realloc(__ptr, __size)
	void *	__ptr
	size_t	__size

char *
realpath(__name, __resolved)
	__const char *	__name
	char *	__resolved

int
rpmatch(__response)
	__const char *	__response

unsigned short int *
seed48(__seed16v)
	unsigned short int	__seed16v[3]

int
seed48_r(__seed16v, __buffer)
	unsigned short int	__seed16v[3]
	struct drand48_data *	__buffer

int
select(__nfds, __readfds, __writefds, __exceptfds, __timeout)
	int	__nfds
	fd_set *	__readfds
	fd_set *	__writefds
	fd_set *	__exceptfds
	struct timeval *	__timeout

int
setenv(__name, __value, __replace)
	__const char *	__name
	__const char *	__value
	int	__replace

void
setkey(__key)
	__const char *	__key

char *
setstate(__statebuf)
	char *	__statebuf

int
setstate_r(__statebuf, __buf)
	char *	__statebuf
	struct random_data *	__buf

void
srand(__seed)
	unsigned int	__seed

void
srand48(__seedval)
	long int	__seedval

int
srand48_r(__seedval, __buffer)
	long int	__seedval
	struct drand48_data *	__buffer

void
srandom(__seed)
	unsigned int	__seed

int
srandom_r(__seed, __buf)
	unsigned int	__seed
	struct random_data *	__buf

double
strtod(__nptr, __endptr)
	__const char *	__nptr
	char **	__endptr

double
strtod_l(__nptr, __endptr, __loc)
	__const char *	__nptr
	char **	__endptr
	__locale_t	__loc

float
strtof(__nptr, __endptr)
	__const char *	__nptr
	char **	__endptr

float
strtof_l(__nptr, __endptr, __loc)
	__const char *	__nptr
	char **	__endptr
	__locale_t	__loc

long int
strtol(__nptr, __endptr, __base)
	__const char *	__nptr
	char **	__endptr
	int	__base

long int
strtol_l(__nptr, __endptr, __base, __loc)
	__const char *	__nptr
	char **	__endptr
	int	__base
	__locale_t	__loc

long double
strtold(__nptr, __endptr)
	__const char *	__nptr
	char **	__endptr

long double
strtold_l(__nptr, __endptr, __loc)
	__const char *	__nptr
	char **	__endptr
	__locale_t	__loc

__extension__ extern long long int
strtoll(__nptr, __endptr, __base)
	__const char *	__nptr
	char **	__endptr
	int	__base

__extension__ extern long long int
strtoll_l(__nptr, __endptr, __base, __loc)
	__const char *	__nptr
	char **	__endptr
	int	__base
	__locale_t	__loc

__extension__ extern long long int
strtoq(__nptr, __endptr, __base)
	__const char *	__nptr
	char **	__endptr
	int	__base

unsigned long int
strtoul(__nptr, __endptr, __base)
	__const char *	__nptr
	char **	__endptr
	int	__base

unsigned long int
strtoul_l(__nptr, __endptr, __base, __loc)
	__const char *	__nptr
	char **	__endptr
	int	__base
	__locale_t	__loc

__extension__ extern unsigned long long int
strtoull(__nptr, __endptr, __base)
	__const char *	__nptr
	char **	__endptr
	int	__base

__extension__ extern unsigned long long int
strtoull_l(__nptr, __endptr, __base, __loc)
	__const char *	__nptr
	char **	__endptr
	int	__base
	__locale_t	__loc

__extension__ extern unsigned long long int
strtouq(__nptr, __endptr, __base)
	__const char *	__nptr
	char **	__endptr
	int	__base

int
system(__command)
	__const char *	__command

int
unlockpt(__fd)
	int	__fd

int
unsetenv(__name)
	__const char *	__name

void *
valloc(__size)
	size_t	__size

size_t
wcstombs(__s, __pwcs, __n)
	char *	__s
	__const wchar_t *	__pwcs
	size_t	__n

int
wctomb(__s, __wchar)
	char *	__s
	wchar_t	__wchar
