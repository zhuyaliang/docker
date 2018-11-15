-- SQL_ASCII --> MULE_INTERNAL
DROP CONVERSION sys_catalog.ascii_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.ascii_to_mic FOR 'SQL_ASCII' TO 'MULE_INTERNAL' FROM ascii_to_mic;
-- MULE_INTERNAL --> SQL_ASCII
DROP CONVERSION sys_catalog.mic_to_ascii;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_ascii FOR 'MULE_INTERNAL' TO 'SQL_ASCII' FROM mic_to_ascii;
-- KOI8R --> MULE_INTERNAL
DROP CONVERSION sys_catalog.koi8_r_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.koi8_r_to_mic FOR 'KOI8R' TO 'MULE_INTERNAL' FROM koi8r_to_mic;
-- MULE_INTERNAL --> KOI8R
DROP CONVERSION sys_catalog.mic_to_koi8_r;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_koi8_r FOR 'MULE_INTERNAL' TO 'KOI8R' FROM mic_to_koi8r;
-- ISO-8859-5 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.iso_8859_5_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_5_to_mic FOR 'ISO-8859-5' TO 'MULE_INTERNAL' FROM iso_to_mic;
-- MULE_INTERNAL --> ISO-8859-5
DROP CONVERSION sys_catalog.mic_to_iso_8859_5;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_iso_8859_5 FOR 'MULE_INTERNAL' TO 'ISO-8859-5' FROM mic_to_iso;
-- WIN1251 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.windows_1251_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.windows_1251_to_mic FOR 'WIN1251' TO 'MULE_INTERNAL' FROM win1251_to_mic;
-- MULE_INTERNAL --> WIN1251
DROP CONVERSION sys_catalog.mic_to_windows_1251;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_windows_1251 FOR 'MULE_INTERNAL' TO 'WIN1251' FROM mic_to_win1251;
-- WIN866 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.windows_866_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.windows_866_to_mic FOR 'WIN866' TO 'MULE_INTERNAL' FROM win866_to_mic;
-- MULE_INTERNAL --> WIN866
DROP CONVERSION sys_catalog.mic_to_windows_866;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_windows_866 FOR 'MULE_INTERNAL' TO 'WIN866' FROM mic_to_win866;
-- KOI8R --> WIN1251
DROP CONVERSION sys_catalog.koi8_r_to_windows_1251;
CREATE DEFAULT CONVERSION sys_catalog.koi8_r_to_windows_1251 FOR 'KOI8R' TO 'WIN1251' FROM koi8r_to_win1251;
-- WIN1251 --> KOI8R
DROP CONVERSION sys_catalog.windows_1251_to_koi8_r;
CREATE DEFAULT CONVERSION sys_catalog.windows_1251_to_koi8_r FOR 'WIN1251' TO 'KOI8R' FROM win1251_to_koi8r;
-- KOI8R --> WIN866
DROP CONVERSION sys_catalog.koi8_r_to_windows_866;
CREATE DEFAULT CONVERSION sys_catalog.koi8_r_to_windows_866 FOR 'KOI8R' TO 'WIN866' FROM koi8r_to_win866;
-- WIN866 --> KOI8R
DROP CONVERSION sys_catalog.windows_866_to_koi8_r;
CREATE DEFAULT CONVERSION sys_catalog.windows_866_to_koi8_r FOR 'WIN866' TO 'KOI8R' FROM win866_to_koi8r;
-- WIN866 --> WIN1251
DROP CONVERSION sys_catalog.windows_866_to_windows_1251;
CREATE DEFAULT CONVERSION sys_catalog.windows_866_to_windows_1251 FOR 'WIN866' TO 'WIN1251' FROM win866_to_win1251;
-- WIN1251 --> WIN866
DROP CONVERSION sys_catalog.windows_1251_to_windows_866;
CREATE DEFAULT CONVERSION sys_catalog.windows_1251_to_windows_866 FOR 'WIN1251' TO 'WIN866' FROM win1251_to_win866;
-- ISO-8859-5 --> KOI8R
DROP CONVERSION sys_catalog.iso_8859_5_to_koi8_r;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_5_to_koi8_r FOR 'ISO-8859-5' TO 'KOI8R' FROM iso_to_koi8r;
-- KOI8R --> ISO-8859-5
DROP CONVERSION sys_catalog.koi8_r_to_iso_8859_5;
CREATE DEFAULT CONVERSION sys_catalog.koi8_r_to_iso_8859_5 FOR 'KOI8R' TO 'ISO-8859-5' FROM koi8r_to_iso;
-- ISO-8859-5 --> WIN1251
DROP CONVERSION sys_catalog.iso_8859_5_to_windows_1251;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_5_to_windows_1251 FOR 'ISO-8859-5' TO 'WIN1251' FROM iso_to_win1251;
-- WIN1251 --> ISO-8859-5
DROP CONVERSION sys_catalog.windows_1251_to_iso_8859_5;
CREATE DEFAULT CONVERSION sys_catalog.windows_1251_to_iso_8859_5 FOR 'WIN1251' TO 'ISO-8859-5' FROM win1251_to_iso;
-- ISO-8859-5 --> WIN866
DROP CONVERSION sys_catalog.iso_8859_5_to_windows_866;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_5_to_windows_866 FOR 'ISO-8859-5' TO 'WIN866' FROM iso_to_win866;
-- WIN866 --> ISO-8859-5
DROP CONVERSION sys_catalog.windows_866_to_iso_8859_5;
CREATE DEFAULT CONVERSION sys_catalog.windows_866_to_iso_8859_5 FOR 'WIN866' TO 'ISO-8859-5' FROM win866_to_iso;
-- EUC_CN --> MULE_INTERNAL
DROP CONVERSION sys_catalog.euc_cn_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.euc_cn_to_mic FOR 'EUC_CN' TO 'MULE_INTERNAL' FROM euc_cn_to_mic;
-- MULE_INTERNAL --> EUC_CN
DROP CONVERSION sys_catalog.mic_to_euc_cn;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_euc_cn FOR 'MULE_INTERNAL' TO 'EUC_CN' FROM mic_to_euc_cn;
-- EUC_JP --> SJIS
DROP CONVERSION sys_catalog.euc_jp_to_sjis;
CREATE DEFAULT CONVERSION sys_catalog.euc_jp_to_sjis FOR 'EUC_JP' TO 'SJIS' FROM euc_jp_to_sjis;
-- SJIS --> EUC_JP
DROP CONVERSION sys_catalog.sjis_to_euc_jp;
CREATE DEFAULT CONVERSION sys_catalog.sjis_to_euc_jp FOR 'SJIS' TO 'EUC_JP' FROM sjis_to_euc_jp;
-- EUC_JP --> MULE_INTERNAL
DROP CONVERSION sys_catalog.euc_jp_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.euc_jp_to_mic FOR 'EUC_JP' TO 'MULE_INTERNAL' FROM euc_jp_to_mic;
-- SJIS --> MULE_INTERNAL
DROP CONVERSION sys_catalog.sjis_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.sjis_to_mic FOR 'SJIS' TO 'MULE_INTERNAL' FROM sjis_to_mic;
-- MULE_INTERNAL --> EUC_JP
DROP CONVERSION sys_catalog.mic_to_euc_jp;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_euc_jp FOR 'MULE_INTERNAL' TO 'EUC_JP' FROM mic_to_euc_jp;
-- MULE_INTERNAL --> SJIS
DROP CONVERSION sys_catalog.mic_to_sjis;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_sjis FOR 'MULE_INTERNAL' TO 'SJIS' FROM mic_to_sjis;
-- EUC_KR --> MULE_INTERNAL
DROP CONVERSION sys_catalog.euc_kr_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.euc_kr_to_mic FOR 'EUC_KR' TO 'MULE_INTERNAL' FROM euc_kr_to_mic;
-- MULE_INTERNAL --> EUC_KR
DROP CONVERSION sys_catalog.mic_to_euc_kr;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_euc_kr FOR 'MULE_INTERNAL' TO 'EUC_KR' FROM mic_to_euc_kr;
-- EUC_TW --> BIG5
DROP CONVERSION sys_catalog.euc_tw_to_big5;
CREATE DEFAULT CONVERSION sys_catalog.euc_tw_to_big5 FOR 'EUC_TW' TO 'BIG5' FROM euc_tw_to_big5;
-- BIG5 --> EUC_TW
DROP CONVERSION sys_catalog.big5_to_euc_tw;
CREATE DEFAULT CONVERSION sys_catalog.big5_to_euc_tw FOR 'BIG5' TO 'EUC_TW' FROM big5_to_euc_tw;
-- EUC_TW --> MULE_INTERNAL
DROP CONVERSION sys_catalog.euc_tw_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.euc_tw_to_mic FOR 'EUC_TW' TO 'MULE_INTERNAL' FROM euc_tw_to_mic;
-- BIG5 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.big5_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.big5_to_mic FOR 'BIG5' TO 'MULE_INTERNAL' FROM big5_to_mic;
-- MULE_INTERNAL --> EUC_TW
DROP CONVERSION sys_catalog.mic_to_euc_tw;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_euc_tw FOR 'MULE_INTERNAL' TO 'EUC_TW' FROM mic_to_euc_tw;
-- MULE_INTERNAL --> BIG5
DROP CONVERSION sys_catalog.mic_to_big5;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_big5 FOR 'MULE_INTERNAL' TO 'BIG5' FROM mic_to_big5;
-- LATIN2 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.iso_8859_2_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_2_to_mic FOR 'LATIN2' TO 'MULE_INTERNAL' FROM latin2_to_mic;
-- MULE_INTERNAL --> LATIN2
DROP CONVERSION sys_catalog.mic_to_iso_8859_2;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_iso_8859_2 FOR 'MULE_INTERNAL' TO 'LATIN2' FROM mic_to_latin2;
-- WIN1250 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.windows_1250_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.windows_1250_to_mic FOR 'WIN1250' TO 'MULE_INTERNAL' FROM win1250_to_mic;
-- MULE_INTERNAL --> WIN1250
DROP CONVERSION sys_catalog.mic_to_windows_1250;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_windows_1250 FOR 'MULE_INTERNAL' TO 'WIN1250' FROM mic_to_win1250;
-- LATIN2 --> WIN1250
DROP CONVERSION sys_catalog.iso_8859_2_to_windows_1250;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_2_to_windows_1250 FOR 'LATIN2' TO 'WIN1250' FROM latin2_to_win1250;
-- WIN1250 --> LATIN2
DROP CONVERSION sys_catalog.windows_1250_to_iso_8859_2;
CREATE DEFAULT CONVERSION sys_catalog.windows_1250_to_iso_8859_2 FOR 'WIN1250' TO 'LATIN2' FROM win1250_to_latin2;
-- LATIN1 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.iso_8859_1_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_1_to_mic FOR 'LATIN1' TO 'MULE_INTERNAL' FROM latin1_to_mic;
-- MULE_INTERNAL --> LATIN1
DROP CONVERSION sys_catalog.mic_to_iso_8859_1;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_iso_8859_1 FOR 'MULE_INTERNAL' TO 'LATIN1' FROM mic_to_latin1;
-- LATIN3 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.iso_8859_3_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_3_to_mic FOR 'LATIN3' TO 'MULE_INTERNAL' FROM latin3_to_mic;
-- MULE_INTERNAL --> LATIN3
DROP CONVERSION sys_catalog.mic_to_iso_8859_3;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_iso_8859_3 FOR 'MULE_INTERNAL' TO 'LATIN3' FROM mic_to_latin3;
-- LATIN4 --> MULE_INTERNAL
DROP CONVERSION sys_catalog.iso_8859_4_to_mic;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_4_to_mic FOR 'LATIN4' TO 'MULE_INTERNAL' FROM latin4_to_mic;
-- MULE_INTERNAL --> LATIN4
DROP CONVERSION sys_catalog.mic_to_iso_8859_4;
CREATE DEFAULT CONVERSION sys_catalog.mic_to_iso_8859_4 FOR 'MULE_INTERNAL' TO 'LATIN4' FROM mic_to_latin4;
-- SQL_ASCII --> UTF8
DROP CONVERSION sys_catalog.ascii_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.ascii_to_utf8 FOR 'SQL_ASCII' TO 'UTF8' FROM ascii_to_utf8;
-- UTF8 --> SQL_ASCII
DROP CONVERSION sys_catalog.utf8_to_ascii;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_ascii FOR 'UTF8' TO 'SQL_ASCII' FROM utf8_to_ascii;
-- BIG5 --> UTF8
DROP CONVERSION sys_catalog.big5_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.big5_to_utf8 FOR 'BIG5' TO 'UTF8' FROM big5_to_utf8;
-- UTF8 --> BIG5
DROP CONVERSION sys_catalog.utf8_to_big5;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_big5 FOR 'UTF8' TO 'BIG5' FROM utf8_to_big5;
-- UTF8 --> KOI8R
DROP CONVERSION sys_catalog.utf8_to_koi8_r;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_koi8_r FOR 'UTF8' TO 'KOI8R' FROM utf8_to_koi8r;
-- KOI8R --> UTF8
DROP CONVERSION sys_catalog.koi8_r_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.koi8_r_to_utf8 FOR 'KOI8R' TO 'UTF8' FROM koi8r_to_utf8;
-- UTF8 --> WIN866
DROP CONVERSION sys_catalog.utf8_to_windows_866;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_866 FOR 'UTF8' TO 'WIN866' FROM utf8_to_win;
-- WIN866 --> UTF8
DROP CONVERSION sys_catalog.windows_866_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_866_to_utf8 FOR 'WIN866' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN874
DROP CONVERSION sys_catalog.utf8_to_windows_874;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_874 FOR 'UTF8' TO 'WIN874' FROM utf8_to_win;
-- WIN874 --> UTF8
DROP CONVERSION sys_catalog.windows_874_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_874_to_utf8 FOR 'WIN874' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1250
DROP CONVERSION sys_catalog.utf8_to_windows_1250;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1250 FOR 'UTF8' TO 'WIN1250' FROM utf8_to_win;
-- WIN1250 --> UTF8
DROP CONVERSION sys_catalog.windows_1250_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1250_to_utf8 FOR 'WIN1250' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1251
DROP CONVERSION sys_catalog.utf8_to_windows_1251;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1251 FOR 'UTF8' TO 'WIN1251' FROM utf8_to_win;
-- WIN1251 --> UTF8
DROP CONVERSION sys_catalog.windows_1251_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1251_to_utf8 FOR 'WIN1251' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1252
DROP CONVERSION sys_catalog.utf8_to_windows_1252;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1252 FOR 'UTF8' TO 'WIN1252' FROM utf8_to_win;
-- WIN1252 --> UTF8
DROP CONVERSION sys_catalog.windows_1252_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1252_to_utf8 FOR 'WIN1252' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1253
DROP CONVERSION sys_catalog.utf8_to_windows_1253;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1253 FOR 'UTF8' TO 'WIN1253' FROM utf8_to_win;
-- WIN1253 --> UTF8
DROP CONVERSION sys_catalog.windows_1253_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1253_to_utf8 FOR 'WIN1253' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1254
DROP CONVERSION sys_catalog.utf8_to_windows_1254;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1254 FOR 'UTF8' TO 'WIN1254' FROM utf8_to_win;
-- WIN1254 --> UTF8
DROP CONVERSION sys_catalog.windows_1254_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1254_to_utf8 FOR 'WIN1254' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1255
DROP CONVERSION sys_catalog.utf8_to_windows_1255;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1255 FOR 'UTF8' TO 'WIN1255' FROM utf8_to_win;
-- WIN1255 --> UTF8
DROP CONVERSION sys_catalog.windows_1255_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1255_to_utf8 FOR 'WIN1255' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1256
DROP CONVERSION sys_catalog.utf8_to_windows_1256;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1256 FOR 'UTF8' TO 'WIN1256' FROM utf8_to_win;
-- WIN1256 --> UTF8
DROP CONVERSION sys_catalog.windows_1256_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1256_to_utf8 FOR 'WIN1256' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1257
DROP CONVERSION sys_catalog.utf8_to_windows_1257;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1257 FOR 'UTF8' TO 'WIN1257' FROM utf8_to_win;
-- WIN1257 --> UTF8
DROP CONVERSION sys_catalog.windows_1257_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1257_to_utf8 FOR 'WIN1257' TO 'UTF8' FROM win_to_utf8;
-- UTF8 --> WIN1258
DROP CONVERSION sys_catalog.utf8_to_windows_1258;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_windows_1258 FOR 'UTF8' TO 'WIN1258' FROM utf8_to_win;
-- WIN1258 --> UTF8
DROP CONVERSION sys_catalog.windows_1258_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.windows_1258_to_utf8 FOR 'WIN1258' TO 'UTF8' FROM win_to_utf8;
-- EUC_CN --> UTF8
DROP CONVERSION sys_catalog.euc_cn_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.euc_cn_to_utf8 FOR 'EUC_CN' TO 'UTF8' FROM euc_cn_to_utf8;
-- UTF8 --> EUC_CN
DROP CONVERSION sys_catalog.utf8_to_euc_cn;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_euc_cn FOR 'UTF8' TO 'EUC_CN' FROM utf8_to_euc_cn;
-- EUC_JP --> UTF8
DROP CONVERSION sys_catalog.euc_jp_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.euc_jp_to_utf8 FOR 'EUC_JP' TO 'UTF8' FROM euc_jp_to_utf8;
-- UTF8 --> EUC_JP
DROP CONVERSION sys_catalog.utf8_to_euc_jp;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_euc_jp FOR 'UTF8' TO 'EUC_JP' FROM utf8_to_euc_jp;
-- EUC_KR --> UTF8
DROP CONVERSION sys_catalog.euc_kr_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.euc_kr_to_utf8 FOR 'EUC_KR' TO 'UTF8' FROM euc_kr_to_utf8;
-- UTF8 --> EUC_KR
DROP CONVERSION sys_catalog.utf8_to_euc_kr;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_euc_kr FOR 'UTF8' TO 'EUC_KR' FROM utf8_to_euc_kr;
-- EUC_TW --> UTF8
DROP CONVERSION sys_catalog.euc_tw_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.euc_tw_to_utf8 FOR 'EUC_TW' TO 'UTF8' FROM euc_tw_to_utf8;
-- UTF8 --> EUC_TW
DROP CONVERSION sys_catalog.utf8_to_euc_tw;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_euc_tw FOR 'UTF8' TO 'EUC_TW' FROM utf8_to_euc_tw;
-- GB18030 --> UTF8
DROP CONVERSION sys_catalog.gb18030_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.gb18030_to_utf8 FOR 'GB18030' TO 'UTF8' FROM gb18030_to_utf8;
-- UTF8 --> GB18030
DROP CONVERSION sys_catalog.utf8_to_gb18030;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_gb18030 FOR 'UTF8' TO 'GB18030' FROM utf8_to_gb18030;
-- GBK --> UTF8
DROP CONVERSION sys_catalog.gbk_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.gbk_to_utf8 FOR 'GBK' TO 'UTF8' FROM gbk_to_utf8;
-- UTF8 --> GBK
DROP CONVERSION sys_catalog.utf8_to_gbk;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_gbk FOR 'UTF8' TO 'GBK' FROM utf8_to_gbk;
-- UTF8 --> LATIN2
DROP CONVERSION sys_catalog.utf8_to_iso_8859_2;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_2 FOR 'UTF8' TO 'LATIN2' FROM utf8_to_iso8859;
-- LATIN2 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_2_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_2_to_utf8 FOR 'LATIN2' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN3
DROP CONVERSION sys_catalog.utf8_to_iso_8859_3;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_3 FOR 'UTF8' TO 'LATIN3' FROM utf8_to_iso8859;
-- LATIN3 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_3_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_3_to_utf8 FOR 'LATIN3' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN4
DROP CONVERSION sys_catalog.utf8_to_iso_8859_4;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_4 FOR 'UTF8' TO 'LATIN4' FROM utf8_to_iso8859;
-- LATIN4 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_4_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_4_to_utf8 FOR 'LATIN4' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN5
DROP CONVERSION sys_catalog.utf8_to_iso_8859_9;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_9 FOR 'UTF8' TO 'LATIN5' FROM utf8_to_iso8859;
-- LATIN5 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_9_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_9_to_utf8 FOR 'LATIN5' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN6
DROP CONVERSION sys_catalog.utf8_to_iso_8859_10;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_10 FOR 'UTF8' TO 'LATIN6' FROM utf8_to_iso8859;
-- LATIN6 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_10_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_10_to_utf8 FOR 'LATIN6' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN7
DROP CONVERSION sys_catalog.utf8_to_iso_8859_13;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_13 FOR 'UTF8' TO 'LATIN7' FROM utf8_to_iso8859;
-- LATIN7 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_13_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_13_to_utf8 FOR 'LATIN7' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN8
DROP CONVERSION sys_catalog.utf8_to_iso_8859_14;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_14 FOR 'UTF8' TO 'LATIN8' FROM utf8_to_iso8859;
-- LATIN8 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_14_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_14_to_utf8 FOR 'LATIN8' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN9
DROP CONVERSION sys_catalog.utf8_to_iso_8859_15;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_15 FOR 'UTF8' TO 'LATIN9' FROM utf8_to_iso8859;
-- LATIN9 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_15_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_15_to_utf8 FOR 'LATIN9' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> LATIN10
DROP CONVERSION sys_catalog.utf8_to_iso_8859_16;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_16 FOR 'UTF8' TO 'LATIN10' FROM utf8_to_iso8859;
-- LATIN10 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_16_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_16_to_utf8 FOR 'LATIN10' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> ISO-8859-5
DROP CONVERSION sys_catalog.utf8_to_iso_8859_5;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_5 FOR 'UTF8' TO 'ISO-8859-5' FROM utf8_to_iso8859;
-- ISO-8859-5 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_5_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_5_to_utf8 FOR 'ISO-8859-5' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> ISO-8859-6
DROP CONVERSION sys_catalog.utf8_to_iso_8859_6;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_6 FOR 'UTF8' TO 'ISO-8859-6' FROM utf8_to_iso8859;
-- ISO-8859-6 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_6_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_6_to_utf8 FOR 'ISO-8859-6' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> ISO-8859-7
DROP CONVERSION sys_catalog.utf8_to_iso_8859_7;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_7 FOR 'UTF8' TO 'ISO-8859-7' FROM utf8_to_iso8859;
-- ISO-8859-7 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_7_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_7_to_utf8 FOR 'ISO-8859-7' TO 'UTF8' FROM iso8859_to_utf8;
-- UTF8 --> ISO-8859-8
DROP CONVERSION sys_catalog.utf8_to_iso_8859_8;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_8 FOR 'UTF8' TO 'ISO-8859-8' FROM utf8_to_iso8859;
-- ISO-8859-8 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_8_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_8_to_utf8 FOR 'ISO-8859-8' TO 'UTF8' FROM iso8859_to_utf8;
-- LATIN1 --> UTF8
DROP CONVERSION sys_catalog.iso_8859_1_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.iso_8859_1_to_utf8 FOR 'LATIN1' TO 'UTF8' FROM iso8859_1_to_utf8;
-- UTF8 --> LATIN1
DROP CONVERSION sys_catalog.utf8_to_iso_8859_1;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_iso_8859_1 FOR 'UTF8' TO 'LATIN1' FROM utf8_to_iso8859_1;
-- JOHAB --> UTF8
DROP CONVERSION sys_catalog.johab_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.johab_to_utf8 FOR 'JOHAB' TO 'UTF8' FROM johab_to_utf8;
-- UTF8 --> JOHAB
DROP CONVERSION sys_catalog.utf8_to_johab;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_johab FOR 'UTF8' TO 'JOHAB' FROM utf8_to_johab;
-- SJIS --> UTF8
DROP CONVERSION sys_catalog.sjis_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.sjis_to_utf8 FOR 'SJIS' TO 'UTF8' FROM sjis_to_utf8;
-- UTF8 --> SJIS
DROP CONVERSION sys_catalog.utf8_to_sjis;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_sjis FOR 'UTF8' TO 'SJIS' FROM utf8_to_sjis;
-- UHC --> UTF8
DROP CONVERSION sys_catalog.uhc_to_utf8;
CREATE DEFAULT CONVERSION sys_catalog.uhc_to_utf8 FOR 'UHC' TO 'UTF8' FROM uhc_to_utf8;
-- UTF8 --> UHC
DROP CONVERSION sys_catalog.utf8_to_uhc;
CREATE DEFAULT CONVERSION sys_catalog.utf8_to_uhc FOR 'UTF8' TO 'UHC' FROM utf8_to_uhc;
-- GBK --> GB18030
DROP CONVERSION sys_catalog.gbk_to_gb18030;
CREATE DEFAULT CONVERSION sys_catalog.gbk_to_gb18030 FOR 'GBK' TO 'GB18030' FROM gbk_to_gb18030;
-- GB18030 --> GBK
DROP CONVERSION sys_catalog.gb18030_to_gbk;
CREATE DEFAULT CONVERSION sys_catalog.gb18030_to_gbk FOR 'GB18030' TO 'GBK' FROM gb18030_to_gbk;
