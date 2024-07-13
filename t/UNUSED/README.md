There are, or were, 22 test scripts in the ZOOM-Perl distribution: two parallel sets of 11 tests, one written using the low-level `Net::Z3950::ZOOM` API (which maps pretty much directly to the underlying ZOOM-C library of YAZ) and the higher-level `ZOOM` API, which allows idiomatic Perl to be written. (The principal and maybe only purpose of the former is to provide the low-level functions with which to implement the former. It is doubtful whether anyone uses it directly.)

Of those tests, the low-level scripts `10-options.t`, `11-option-callback.t`, `17-logging.t` and `18-charset.t` work correctly in the absence of the old z3950.indexdata.com server, which has died – as do the corresponding high-level scripts `20-options.t`, `21-option-callback.t`, `27-logging.t` and `28-charset.t`.

The remaining 14 scripts (seven for the low-level API, and seven more corresponding scripts for the high-level API) do not work due to their dependence on a reliable Z39.50 server. For [ZOOM-28](https://index-data.atlassian.net/browse/ZOOM-28) I need to make the test suite work in the absence of that old server.

So I have halved my work on this by moving these `1*.t` scripts down into this `UNUSED` directory. These are the ones that use the low-level API, which in any case exercised by the high-level tests (`2*.t`) which will be updated.
