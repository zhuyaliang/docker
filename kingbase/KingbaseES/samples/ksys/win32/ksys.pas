unit ksys;

interface
function Startup(connMode: LongWord;binDir: string; dataDir: string; progname: string; port: string): LongWord; cdecl;
function Shutdown(pid: LongWord; mode: string): Integer; cdecl;
function Ping(connectString: string): Integer; cdecl;
function Check(pid: LongWord; dataDir: string; progname: string): Integer; cdecl;

implementation
function Startup; external 'ksys.dll' name 'Startup';
function Shutdown; external 'ksys.dll' name 'Shutdown';
function Ping; external 'ksys.dll' name 'Ping';
function Check; external 'ksys.dll' name 'Check';

end.
