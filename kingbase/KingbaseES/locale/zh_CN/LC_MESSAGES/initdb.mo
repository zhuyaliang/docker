��    �      �  �         �     �  Y   �       
   +  +   6     b  H   ~  =   �  S     +  Y  A   �  )   �  @   �  6   2  J   i  6   �  J   �  j   6  T   �  )   �  T      A   u  /   �  a   �  W   I  8   �  6   �  =     <   O  S   �  2   �  �     =   �  &   �  3     $   9  :   ^     �  -   �  '   �  D   �     7     U     k  4   �     �  P   �  I   (  ]   r  4   �  L     �   R  /   �  >     +   B  /   n  :   �  <   �  4     4   K  6   �  )   �  �   �  =   �  �     7   �  :      +   H   .   t   �   �   �   6!  8   �!  3   �!  J   '"  Q   r"  �   �"     �#  D   �#  @   �#  4   :$  7   o$  (   �$  +   �$  3   �$  (   0%  9   Y%  $   �%  (   �%  =   �%     &  x   ?&  m   �&  -   &'  ^   T'  ^   �'     (  ,   ((  #   U(     y(     �(  A   �(  B   �(  4   +)     `)     q)     �)     �)     �)     �)     �)  ;   *  0   H*  .   y*  9   �*  �   �*  >   s+  ;   �+  0  �+  u   -  /   �-  &   �-     �-  �   �-     �.  &   �.  0   /  )   6/  #   `/  #   �/  "   �/      �/  (   �/  "   0     80  "   S0  !   v0  ,   �0  $   �0     �0  )   	1  "   31  !   V1  !   x1     �1     �1     �1      �1     2     %2     B2  +   ]2     �2  &   �2     �2  0   �2  *   3  "   >3     a3     �3     �3     �3  $   �3  #   �3     4  &   -4     T4  )   r4     �4     �4  !   �4     �4  +   �4  #   5  !   :5  [  \5     �6  3   �6     �6     7  '   
7     27  @   M7  ;   �7  7   �7    8  =   9  /   D9  =   t9  3   �9  C   �9  3   *:  C   ^:  _   �:  O   ;  5   R;  9   �;  5   �;  1   �;  P   *<  C   {<  5   �<  1   �<  5   '=  -   ]=  J   �=  1   �=  h   >  -   q>  +   �>  -   �>  &   �>  /    ?     P?      S?     t?  /   �?     �?     �?     �?  %   @     -@  4   C@  )   x@  U   �@  )   �@  -   "A  ]   PA  !   �A  (   �A     �A  !   B  &   6B  .   ]B  *   �B  *   �B  (   �B  !   C  �   -C  2   �C  �   'D      �D  %   �D     �D  !   E  ]   7E  V   �E  (   �E  /   F  .   EF  4   tF  f   �F     G  &   %G  7   LG  $   �G  -   �G  !   �G  &   �G  $    H     EH  +   dH     �H     �H  3   �H     �H  N   I  E   ]I  $   �I  D   �I  F   J     TJ     eJ     �J     �J     �J  *   �J  ,   �J  $   K     6K     CK     [K     sK     �K     �K     �K  '   �K  #   �K  !   L  "   8L  {   [L  #   �L  !   �L  �   M  D   �M     N     .N     LN  �   SN     'O     9O     NO     lO      �O      �O     �O     �O     �O      P     P     *P     AP     VP     sP     �P  %   �P     �P     �P     �P     Q     Q     )Q     :Q     LQ     \Q     kQ     }Q     �Q     �Q     �Q     �Q     �Q     R     0R     DR     UR     kR     �R     �R     �R     �R     �R     �R     S  	   S     %S     BS     VS     nS     �S               S   �   o   �   '             �           q       "              1                 #   �   E   @              R           �      �   r       G      i       
   b   u   k   F   Z   �   �          �   �       L   5   _       |   g       m   P   �   ?         -             �   /   %   n       a   �      �          j   c       x   .   `      �   �   ,   p   z                  7   >   &   f       �   �   X   T   =   s   :   $   ^   �   �   �       Y              e   �   J   )   h   �   I   \   �           9   ]      �                          �      8   �   A   �   �   y   �   �       �       �      6   �   �          ~           +       �   K   ;   }       �          �   v   W   �   3       �      B   �   �           M   D   V   2   l   t   d   {   �       U       !   �   0           	       [   Q   �          4   *   <       O          C   �   (   �   N   w   H               �    
 
If the data directory is not specified, the environment variable KINGBASE_DATA
is used.
 
Less commonly used options:
 
Options:
 
Report bugs to <support@kingbase.com.cn>.
   %s [OPTION]... [DATADIR]
   --case-insensitive		initialize database cluster with case-insensitive
   --database=DBNAME		the user database created during initdb
   --ignore-trailing-blanks	initialize database cluster with ignore-trailing-blanks
   --lc-collate, --lc-ctype, --lc-messages=LOCALE
  --lc-monetary, --lc-numeric, --lc-time=LOCALE
                                initialize database cluster with given locale
                                in the respective category (default taken from
                                environment)
   --locale=LOCALE		initialize database cluster with given locale
   --no-locale			equivalent to --locale=C
   --pwfile=FILE			read password for the new superuser from file
   --saopassword=SAOPASSWORD	database saouser password
   --saousername=SAOUSERNAME	database saouser name, default name is SYSSAO
   --ssopassword=SSOPASSWORD	database ssouser password
   --ssousername=SSOUSERNAME	database ssouser name, default name is SYSSSO
   --wal-dir= DIRECTORY 
                                location for redo log files created during initdb
   --wal-file-size=SIZE		size(in megabytes) for redo log files created during initdb
   -?, --help			show this help, then exit
   -A, --auth=METHOD             default authentication method for local connections
   -E, --encoding=ENCODING	set default encoding for new databases
   -L DIRECTORY			where to find the input files
   -T, --text-search-config=CFG
                                default text search configuration
   -U, --username=NAME           database superuser name, must be specified when initdb
   -V, --version			output version information, then exit
   -W, --password=PASSWORD	database superuser password
   -Z, --empty-password		database superuser password is empty
   -a, --alloc-space-for-null	allocate space for null values
   -b, --blocksize=SIZE		database block size(in kilobytes), might be 4, 8, 16 or 32
   -d, --debug			generate lots of debugging output
   -f                            if the new data directory is not empty
                                remove it and create a new database 
   -n, --noclean                 do not clean up after errors
   -s, --show			show internal settings
  --encrypt-device		specify the encrypt device name
  --mac-writedown		MAC use wirtedown
  [-D, --data=]DATADIR		location for this database cluster
 %s %s initializes a Kingbase database cluster.

 %s: could not execute command "%s": %s
 %s: could not find suitable text search configuration for locale %s
 %s: invalid locale name "%s"
 %s: pclose error: %s
 %s: pqGetpwuid failed
 %s: too many command-line arguments (first is "%s")
 %s: warning: encoding mismatch
 %s: warning: specified text search configuration "%s" might not match locale %s
 %s: warning: suitable text search configuration for locale %s is unknown
 DONE: Success. You can now start the database server using:

    %s%s%skingbase%s -D %s%s%s

 ERROR: %s: "%s" is not a valid server encoding name
 ERROR: %s: The password file was not generated. Please report this problem.
 ERROR: %s: cannot be run as root
Please log in (using, e.g., "su") as the (unprivileged) user that will
own the server process.
 ERROR: %s: could not access directory "%s": %s
 ERROR: %s: could not change permissions of directory "%s": %s
 ERROR: %s: could not create NULL directory
 ERROR: %s: could not create directory "%s": %s
 ERROR: %s: could not determine valid short version string
 ERROR: %s: could not find suitable encoding for locale "%s"
 ERROR: %s: could not open file "%s" for reading: %s
 ERROR: %s: could not open file "%s" for writing: %s
 ERROR: %s: could not read password from file "%s": %s
 ERROR: %s: could not write file "%s": %s
 ERROR: %s: data directory "%s" may be used now by other kingbase process
If you want to create a new database system, please 
stop the running kingbase process, or try again after deleting the 
"kingbase.pid" , or run %s with an argument other than "%s".
 ERROR: %s: data directory "%s" not removed at user's request
 ERROR: %s: directory "%s" exists but is not empty
If you want to create a new database system, either remove or empty
the directory "%s" or run %s
with an argument other than "%s".
 ERROR: %s: failed to remove contents of data directory
 ERROR: %s: failed to remove contents of redolog directory
 ERROR: %s: failed to remove data directory
 ERROR: %s: failed to remove redolog directory
 ERROR: %s: file "%s" does not exist
This means you have a corrupted installation or identified
the wrong directory with the invocation option -L.
 ERROR: %s: input file "%s" does not belong to Kingbase %s
Check your installation or specify the correct path using the option -L.
 ERROR: %s: input file location must be an absolute path
 ERROR: %s: must specify a %s name using %s option.
 ERROR: %s: must specify a password for the %s to enable %s authentication
 ERROR: %s: must specify a password for the superuser to enable %s authentication
 ERROR: %s: no data directory specified
You must identify the directory where the data for this database system
will reside.  Do this with either the invocation option -D or the
environment variable KINGBASE_DATA.
 ERROR: %s: out of memory
 ERROR: %s: password and password file may not be specified together
 ERROR: %s: redolog directory "%s" not removed at user's request
 ERROR: %s: removing contents of data directory "%s"
 ERROR: %s: removing contents of redolog directory "%s"
 ERROR: %s: removing data directory "%s"
 ERROR: %s: removing redolog directory "%s"
 ERROR: %s: unrecognized authentication method "%s"
 ERROR: %s: user name must less than %d.
 ERROR: %s: user name must not be kingbase reserved name.
 ERROR: %s: username must be unique.
 ERROR: Failed to get the absolute path.
 ERROR: Invalid BLCKSZ, try "%s --help" for more information.
 ERROR: Passwords didn't match.
 ERROR: The program "kingbase" is needed by %s but was not found in the
same directory as "%s".
Check your installation.
 ERROR: The program "kingbase" was found by "%s"
but was not the same version as %s.
Check your installation.
 ERROR: Try "%s --help" for more information.
 ERROR: backslasp(\), double quote("), and single quote(') cannot appear in kingbase password.
 ERROR: backslasp(\), double quote("), and single quote(') cannot appear in kingbase username.
 ERROR: caught signal
 ERROR: could not write to child process: %s
 ERROR: encrpt device name is valid
 ERROR: out of memory
 ERROR: out of memory.
 ERROR: redolog file initial size should be at least 16 Mega bytes ERROR: redolog file initial size should be at most 2048 Giga bytes ERROR: user defined database name must be specified
 Enter it again:  Enter new saouser password:  Enter new ssouser password:  Enter new superuser password:  PROGRESS:%d Rerun %s with the -E option.
 Running in debug mode.
 Running in noclean mode.  Mistakes will not be cleaned up.
 The comparision of strings is case-insensitive.
 The comparision of strings is case-sensitive.
 The database cluster will be initialized with locale %s.
 The database cluster will be initialized with locales
  COLLATE:  %s
  CTYPE:    %s
  MESSAGES: %s
  MONETARY: %s
  NUMERIC:  %s
  TIME:     %s
 The default database encoding has accordingly been set to %s.
 The default text search configuration will be set to "%s".
 The encoding you selected (%s) and the encoding that the selected
locale uses (%s) are not known to match.  This may lead to
misbehavior in various character string processing functions.  To fix
this situation, rerun %s and either do not specify an encoding
explicitly, or choose a matching combination.
 The files belonging to this database system will be owned by user "%s".
This user must also own the server process.

 The superuser of this database cluster is %s.

 Try "%s --help" for more information.
 Usage:
 VERSION=%s
KINGBASE_DATA=%s
share_path=%s
KINGBASE_PATH=%s
KINGBASE_SUPERUSERNAME=%s
KINGBASE_BKI=%s
KINGBASE_DESCR=%s
KINGBASE_SHDESCR=%s
KINGBASE_CONF_SAMPLE=%s
KINGBASE_HBA_SAMPLE=%s
KINGBASE_IDENT_SAMPLE=%s
 add dependencies ...  child process exited with exit code %d child process exited with unrecognized status %d child process was terminated by signal %d copying TEMPLATE1 to TEMPLATE0 ...  copying TEMPLATE1 to TEMPLATE2 ...  could not change directory to "%s" could not find a "%s" to execute could not identify current directory: %s could not open directory "%s": %s
 could not read binary "%s" could not read directory "%s": %s
 could not read symbolic link "%s" could not remove file or directory "%s": %s
 could not set junction for "%s": %s
 creating SAMPLES database ...  creating TEMPLATE1 database in %s/DB ...  creating audit template files ...  creating compatibility views ...  creating configuration files ...  creating conversions ...  creating dictionaries ...  creating directory %s ...  creating information schema ...  creating package: %s ...  creating subdirectories ...  creating system views ...  creating system_views_xingongsuo views ...  creating tsearch2 ...  creating user defined database %s ...  creating wmsys schema ...  fixing permissions on existing directory %s ...  incorrect license file or license expired
 initializing  PL/SQL debugger ...  initializing dependencies ...  initializing dual ...  initializing file_type ...  initializing sys_authid ...  initializing the encrypt device ...  initializing utl_file_internal ...  invalid binary "%s" loading Kingbase systools plugins ...  loading SAMPLES database ...  loading system objects' descriptions ...  ok
 out of memory
 saving database user/password ... setting %s password ...  setting privileges on built-in objects ...  setting user connect idle time ...  vacuuming database TEMPLATE1 ...  Project-Id-Version: kingbaseES 6.1.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2012-01-12 12:00+0800
PO-Revision-Date: 2010-08-06 14:50+0800
Last-Translator: kingbase support <support@kingbase.com.cn>
Language-Team: kingbase support <support@kingbase.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8bit
 
 
�����ָ������Ŀ¼����ʹ�û������� KINGBASE_DATA 
 
������ʹ�õ�ѡ��:
 
ѡ��:
 
��������� <support@kingbase.com.cn>.
   %s [ѡ��]... [�����б�]
   --case-insensitive          ָ�����ݿ⼯ȺΪ case-insensitive
   --database=DBNAME           ��ʼ�����ݿ�ʱ�����û����ݿ�
   --ignore-trailing-blanks    ��ʼ����ʱ����Կհ׺�׺
   --lc-collate, --lc-ctype, --lc-messages=LOCALE
  --lc-monetary, --lc-numeric, --lc-time=LOCALE
                              �ڸ��Ե�����У��ø������������ó�ʼ�����ݿ⼯Ⱥ
                             (Ĭ�ϴ�
                              ���������ж�ȡ)
   --locale=LOCALE             �ø����������ó�ʼ�����ݿ⼯Ⱥ
   --no-locale                 ��ͬ��--locale=C
   --pwfile=FILE               ���ļ���Ϊ�µĳ����û���ȡ����
   --saopassword=SAOPASSWORD   ���ݿ�ϵͳ���Ա����
   --saousername=SAOUSERNAME   ���ݿ�ϵͳ���Ա���֣�Ĭ������SYSSAO
 --ssopassword=SSOPASSWORD     ���ݿ�ϵͳ��ȫԱ����
   --ssousername=SSOUSERNAME   ���ݿ�ϵͳ��ȫԱ���֣�Ĭ������SYSSSO
   --wal-dir= DIRECTORY 
                              ��ʼ�����ݿ�ʱΪredo��־�ļ�����ָ��λ��
   --wal-file-size=SIZE        ��ʼ�����ݿ�ʱΪredo��־�ļ�������С(����Ϊ��λ)
  -?, --help                   ��ʾ����Ϣ����Ȼ���˳�
   -A, --auth=METHOD           ��Ա������ӵ�Ĭ����Ȩ����
   -E, --encoding=ENCODING     Ϊ�����ݿ�����ȱʡ����
  -L DIRECTORY                 ָ�������ļ���λ��
   -T, --text-search-config=CFG
                              Ĭ�ϵ��ı���ѯ����
   -U, --username=NAME         ���ݿⳬ���û����֣���ʼ��ʱ����ָ��
   -V, --version               ����汾��Ϣ��Ȼ���˳�
  -W, --password=PASSWORD      ���ݿⳬ���û�����
   -Z, --empty-password        ���ݿⳬ���û�����Ϊ��
   -a, --alloc-space-for-null  Ϊ��ֵ����ռ�
   -b, --blocksize=SIZE        ���ݿ��С(�� K Ϊ��λ������4,8, 16 ���� 32
   -d, --debug                 ���������ĵ������
   -f                          ���������Ŀ¼�ǿ�
                              ɾ��Ŀ¼�������µ����ݿ�
 -n, --noclean                 ������Ҫ����
  -s, --show                   ��ʾ�ڲ�����
 --encrypt-device              ָ�������豸��
  --mac-writedown              MAC��д
  [-D, --data=]DATADIR         ���ݿ⼯Ⱥ��λ��
 %s %s ��ʼ�� Kingbase ���ݿ⼯Ⱥ.

 %s: �޷�ִ������ "%s": %s
 %s: �޷�Ϊ�������� "%s" �ҵ����ʵ��ı���ѯ����
 %s: ��Ч�� locale ���� "%s"
 %s: ���̹رմ���: %s
 %s: pqGetpwuid ����
 %s: ̫��������в��� (��һ���� "%s")
 %s: ����: ���벻ƥ��
 %s: ����: ָ�����ı���ѯ���� "%s" ��ƥ���������� %s
 %s�����棺�������� %s ���ı���ѯ����δ֪
 DONE: �ɹ�. �����ڿ���������������������ݿ������:

    %s%s%skingbase%s -D %s%s%s

 ERROR: %s: "%s" ����һ����Ч�ķ���������
 ERROR: %s: �����ļ�û������. �뱨���������.
 ERROR: %s: ������root��������
����(����Ȩ) �û����ݵ�¼(����, "su") 
���û���ӵ�з���������.
 ERROR: %s: �޷�����Ŀ¼ "%s": %s
 ERROR: %s: �޷��ı�Ŀ¼ "%s" ��Ȩ��: %s
 ERROR: %s: �޷�������Ŀ¼
 ERROR: %s: �޷�����Ŀ¼ "%s": %s
 ERROR: %s: �޷�ȷ����Ч�Ķ̰汾�ַ���
 ERROR: %s: �޷�Ϊ�������� "%s" �ҵ����ʵı���
 ERROR: %s: �޷����ļ� "%s" ��ȡ��Ϣ: %s
 ERROR: %s: �޷����ļ� "%s" д����Ϣ: %s
 ERROR: %s: �޷����ļ� "%s" ��ȡ����: %s
 ERROR: %s: �޷�д���ļ� "%s": %s
 ERROR: %s: ����Ŀ¼ "%s" �������ڱ������� Kingbase ����ʹ��
������봴��һ���µ����ݿ�ϵͳ, ��
ֹͣ�������е� Kingbase ���̣�����ɾ��"kingbase.pid" ������, �������� %s ʱָ��һ����ͬ�� "%s" �Ĳ���.
 ERROR: %s: ���û���Ҫ��������Ŀ¼ "%s" ���ܱ�ɾ��
 ERROR: %s: Ŀ¼ "%s" �Ѵ���, ���Ҳ��ǿյ�
������봴��һ���µ����ݿ�ϵͳ, ��ɾ�������
Ŀ¼ "%s" �������� %s
ʱ��ָ����ͬ�� "%s" �Ĳ���.
 ERROR: %s: ɾ������Ŀ¼����ʧ��
 ERROR: %s: ɾ�� redolog Ŀ¼����ʧ��
 ERROR: %s: ɾ������Ŀ¼ʧ��
 ERROR: %s: ɾ�� redolog Ŀ¼ʧ��
 ERROR: %s: �ļ� "%s" ������
����ζ�����İ�װ����֤�������𻵻�
ʹ�� -L ѡ��ָ���˴����Ŀ¼.
 ERROR: %s: �����ļ� "%s" ������ Kingbase %s
�����İ�װ��ʹ�� -L ѡ��ָ����ȷ��·��.
 ERROR: %s: �����ļ���λ�ñ���Ϊ����·��
 ERROR: %s: ����ָ��һ�� %s ���֣�ʹ�� %s ѡ��.
 ERROR: %s: ����Ϊ %s ָ�����룬������ %s ��֤
 ERROR: %s: ����Ϊ�����û�ָ�����룬������ %s ��֤, 
 ERROR: %s: û��ָ������Ŀ¼
������Ϊ���ݿ�ϵͳ������ָ��Ŀ¼
ʹ�� -D ѡ�����
�������� KINGBASE_DATA.
 ERROR: %s: �ڴ治��
 ERROR: %s: ����������ļ�����ͬʱָ��
 ERROR: %s: ���û���Ҫ���� redolog Ŀ¼ "%s" ���ܱ�ɾ��
 ERROR: %s: ɾ������Ŀ¼ "%s" ������
 ERROR: %s: ����ɾ�� redolog Ŀ¼ "%s" ������
 ERROR: %s: ����ɾ������Ŀ¼ "%s"
 ERROR: %s: ����ɾ�� redolog Ŀ¼ "%s"
 ERROR: %s: �޷�ʶ�����֤���� "%s".
 ERROR: %s: �û����������� %d.
 ERROR: %s: �û��������� kingbase �ı�����.
 ERROR: %s: �û�������Ψһ.
 ����: �޷���ȡ����·����
 ERROR: ��Ч�� BLCKSZ, �� "%s --help" ��ȡ������Ϣ.
 ERROR: ���벻ƥ��.
 ERROR: ����"kingbase" ��%s����ģ�����ͬһĿ¼"%s"��û���ҵ�.
������İ�װ.
 ERROR: ����"kingbase" ��"%s"�ҵ�
����%s�İ汾��һ��.
������İ�װ.
 ERROR: �� "%s --help" ��ȡ������Ϣ.
 ERROR: ��б��(\), ˫����("), �͵�����(') ���ܳ�����kingbase ������.
 ERROR: ��б��(\), ˫����("), �͵�����(') ���ܳ�����kingbase �û�����.
 ERROR: �����ź�
 ERROR: �޷�д���ӽ���: %s
 ERROR: �����豸����Ч
 ����: �ڴ治��
 ����: �ڴ治�㡣
 ERROR: redolog �ļ��ĳ�ʼ����С��СΪ 16MB ERROR: redolog �ļ��ĳ�ʼ����С���Ϊ 2048GB ERROR: �û���������ݿ����ֱ���ָ��
 ������һ��:  ������ saouser ������:  ������ ssouser ������:  ������ superuser ������:  PROGRESS:%d ʹ�� -E ѡ���������� %s.
 ������ debug ģʽ��. 
 ������ noclean ģʽ��. ���󽫲�������.
 �ַ����Ƚ��� case-insensitive �ġ�
 �ַ����Ƚ��� case-sensitive �ġ�
 ���ݿ⼯Ⱥ������������ %s ��ʼ��.
 ���ݿ⼯Ⱥ���������������ó�ʼ��
  COLLATE:  %s
  CTYPE:    %s
  MESSAGES: %s
  MONETARY: %s
  NUMERIC:  %s
  TIME:     %s
 Ĭ�ϵ����ݿ��������Ӧ������Ϊ %s.
 Ĭ�ϵ��ı���ѯ���ý�����Ϊ "%s".
 ��ѡ��ı��� (%s) ��ѡ��� locale ʹ�õı��� (%s) �����Բ�ƥ���.
���������´�����ͬ�ַ����ĺ�����������.
Ҫ�޸�������, �������� %s ���Ҳ�Ҫ��ʾָ������, ����ѡ��ƥ������
 �����ݿ�ϵͳ���ļ�����Ϊ�û� "%s".
���û�Ҳ����Ϊ���������̵�����.

 ���ݿ⼯Ⱥ�ĳ����û��ǣ�%s.

 �� "%s --help" ��ȡ������Ϣ.
 ʹ��:
 VERSION=%s
KINGBASE_DATA=%s
share_path=%s
KINGBASE_PATH=%s
KINGBASE_SUPERUSERNAME=%s
KINGBASE_BKI=%s
KINGBASE_DESCR=%s
KINGBASE_SHDESCR=%s
KINGBASE_CONF_SAMPLE=%s
KINGBASE_HBA_SAMPLE=%s
KINGBASE_IDENT_SAMPLE=%s
 ���������ϵ ...  �ӽ����˳����˳���%d �ӽ������޷�ʶ���״̬�˳� %d �ӽ��̱���ֹ���ź� %d ���� TEMPLATE1 �� TEMPLATE0 ...  ���� TEMPLATE1 �� TEMPLATE2 ...  �޷��ı�Ŀ¼�� "%s" �Ҳ��� "%s" ȥִ�� �޷�ȷ�ϵ�ǰĿ¼: %s �޷���Ŀ¼"%s": %s
 �޷���ȡ������ "%s" �޷���ȡĿ¼ "%s": %s
 �޷���ȡ��������"%s" �޷��ƶ��ļ���Ŀ¼ "%s": %s
 ����Ϊ "%s": %s�������ӵ�
 ���� SAMPLES ���ݿ� ...  �� %s/DB �д��� TEMPLATE1 ���ݿ� ...  �������ģ���ļ� ...  ����������ͼ ...  ���������ļ� ...  �����ַ���ת�� ...  ����Ŀ¼ ...  ����Ŀ¼ %s ...  ������Ϣģʽ ...  ��������%s ...  ������Ŀ¼...  ����ϵͳ��ͼ ...  ���������ͼ ...  ���� tsearch2 ...  �����û���������ݿ� %s ...  ���� wmsys ģʽ ...  �޸��Ѵ���Ŀ¼ %s �ϵ�Ȩ�� ...  ����ȷ������֤�ļ�������֤����
 ��ʼ�� PL/SQL debugger ...  ��ʼ�������ϵ ...  ��ʼ�� dual ...  ��ʼ�� file_type ...  ��ʼ�� sys_authid ...  ��ʼ�������豸 ...  ��ʼ�� utl_file_internal ...  ��Ч�Ķ����� "%s" ���� Kingbase ϵͳ���߲�� ...  ���� SAMPLES ���ݿ� ...  ����ϵͳ�������� ...  �ɹ�
 �ڴ治��
 �������ݿ���û���/���� ...  ���� %s ������ ...  ���ڽ���������Ȩ�� ...  ѡ���û���������ʱ�� ...  �������ݿ� TEMPLATE1 ...  