SET COMPATIBLE_LEVEL=MIXED;
CREATE SCHEMA wmsys;

CREATE AGGREGATE wmsys.wm_concat(text)
(
	SFUNC = wm_concat_transfn,
	STYPE = internal,
	FINALFUNC = string_agg_finalfn
);

