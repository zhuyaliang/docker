��    f      L  �   |      �      �     �  &   �     �     	  +   :	     f	     |	  u   �	     
  S   /
  N   �
     �
  D   �
  !   2  3   T  ?   �  M   �  I     J   `  ?   �  T   �  >   @  9     B   �  @   �  x   =  0   �  F   �  >   .  J   m  =   �  Z   �  B   Q     �     �  �   �  !   1  A   S  y   �  C     D   S  4   �  A   �  /     *   ?  %   j  /   �  #   �     �  3     0   6  ,   g  .   �  3   �  -   �  0   %  5   V  "   �  $   �  Q   �     &     B  3   Y  0   �     �     �  !   �  $         7  -   X  4   �  %   �  $   �  "     F   )  M   p     �  7   �  q   
  f   |  &   �     
  &     0   9  )   j  "   �      �  (   �       !        >     V     j     �     �     �     �     �  "   �     �  [       x     �     �     �     �  '   �     �       u   #     �  S   �  N        \  D   w  !   �  0   �  *      ;   :   8   v   :   �   0   �   =   !  4   Y!  ,   �!  =   �!  @   �!  a   :"  $   �"  0   �"  8   �"  <   +#     h#  '   �#  #   �#     �#     �#  j   �#     F$  /   `$  [   �$  3   �$  2    %  $   S%  3   x%     �%     �%     �%  "   &     &&     @&  "   U&  #   x&  #   �&  #   �&  !   �&  "   '  !   )'  !   K'     m'     �'  4   �'     �'     �'  ,   �'  "   *(     M(     [(     o(     �(     �(  #   �(  !   �(     )     )     9)  )   Q)  3   {)     �)      �)  G   �)  >   +*      j*     �*     �*     �*     �*     �*     �*     +     +     -+     B+     R+     b+     p+     �+     �+     �+     �+     �+     �+        V       S         4   <   M       *             O       	   U         C       '   f   G                    ;   "                  E   N      0   X   ,                   5   H   3      @      6   a       #   ^   $       P       J   R   b   7   T           Q           [      .   Z      (           /   
   L   !   Y          `   c   I                   B   ]       :   >   ?   K      +       =           \       %          8      D   1   d       A       9   W   -          e         )   2       _          F   &    
Allowed signal names for kill:
 
Common options:
 
Options for register and unregister:
 
Options for start or restart:
 
Options for stop or restart:
 
Report bugs to <support@kingbase.com.cn>.
 
Shutdown modes are:
   %s kill    SIGNALNAME PID
   %s register   [-N SERVICENAME] [-U USERNAME] [-P PASSWORD] [-D DATADIR]
                    [-w|-W] [-o "OPTIONS"]
   %s reload  [-D DATADIR] [-s]
   %s restart [-w|-W] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE] [-o "OPTIONS"]
   %s start   [-w|-W] [-t SECS] [-D DATADIR] [-s] [-l FILENAME] [-o "OPTIONS"]
   %s status  [-D DATADIR]
   %s stop    [-w|-W] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE]
   %s unregister [-N SERVICENAME]
   -?, --help             show this help, then exit
   -D, --data DATADIR     location of the database storage area
   -N SERVICENAME         service name with which to register Kingbase server
   -P PASSWORD            password of account to register Kingbase server
   -U USERNAME            user name of account to register Kingbase server
   -V, --version          output version information, then exit
   -W                     do not wait until operation completes(conflict with -w -t)
   -c, --core-files       allow kingbase to produce core files
   -c, --core-files       not applicable on this platform
   -l, --log FILENAME     write (or append) server log to FILENAME
   -m SHUTDOWN-MODE       may be "smart", "fast", or "immediate"
   -o OPTIONS             command line options to pass to kingbase
                         (Kingbase server executable)
   -p PATH-TO-KINGBASE    normally not necessary
   -s, --silent           only print errors, no informational messages
   -t SECS                seconds to wait when using -w option
   -w                     wait until operation completes(conflict with -W)
   fast                   quit directly, with proper shutdown
   immediate              quit without complete shutdown; will lead to recovery on restart
   smart                  quit after all clients have disconnected
  done
  failed
 %s is a utility to start, stop, restart, reload configuration files,
report the status of a Kingbase server, or signal a Kingbase process.

 %s: PID file "%s" does not exist
 %s: another server may be running; trying to start server anyway
 %s: cannot be run as root
Please log in (using, e.g., "su") as the (unprivileged) user that will
own the server process.
 %s: cannot reload server; single-user server is running (PID: %ld)
 %s: cannot restart server; single-user server is running (PID: %ld)
 %s: cannot set core size, disallowed by hard limit.
 %s: cannot stop server; single-user server is running (PID: %ld)
 %s: could not find kingbase program executable
 %s: could not find own program executable
 %s: could not open PID file "%s": %s
 %s: could not open service "%s": error code %d
 %s: could not open service manager
 %s: could not read file "%s"
 %s: could not register service "%s": error code %d
 %s: could not send reload signal (PID: %ld): %s
 %s: could not send signal %d (PID: %ld): %s
 %s: could not send stop signal (PID: %ld): %s
 %s: could not start server
Examine the log output.
 %s: could not start server: exit code was %d
 %s: could not start service "%s": error code %d
 %s: could not unregister service "%s": error code %d
 %s: invalid data in PID file "%s"
 %s: missing arguments for kill mode
 %s: no database directory specified and environment variable KINGBASE_DATA unset
 %s: no operation specified
 %s: no server running
 %s: old server process (PID: %ld) seems to be gone
 %s: option file "%s" must have exactly one line
 %s: out of memory
 %s: server does not shut down
 %s: server is running (PID: %ld)
 %s: service "%s" already registered
 %s: service "%s" not registered
 %s: single-user server is running (PID: %ld)
 %s: too many command-line arguments (first is "%s")
 %s: unrecognized operation mode "%s"
 %s: unrecognized shutdown mode "%s"
 %s: unrecognized signal name "%s"
 (The default is to wait for shutdown, but not for start or restart.)

 If the -D option is omitted, the environment variable KINGBASE_DATA is used.
 Is server running?
 Please terminate the single-user server and try again.
 The program "kingbase" is needed by %s but was not found in the
same directory as "%s".
Check your installation.
 The program "kingbase" was found by "%s"
but was not the same version as %s.
Check your installation.
 Try "%s --help" for more information.
 Usage:
 child process exited with exit code %d child process exited with unrecognized status %d child process was terminated by signal %d could not change directory to "%s" could not find a "%s" to execute could not identify current directory: %s could not read binary "%s" could not read symbolic link "%s" could not start server
 invalid binary "%s" server shutting down
 server signaled
 server started
 server starting
 server stopped
 starting server anyway
 waiting for server to shut down... waiting for server to start... Project-Id-Version: kingbaseES 6.1.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2010-08-11 03:37+0800
PO-Revision-Date: 2010-08-06 14:50+0800
Last-Translator: kingbase support <support@kingbase.com.cn>
Language-Team: kingbase support <support@kingbase.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8bit
 
�������ź���ɱ��:
 
��ͨѡ��:
 
��½��δ��½ѡ��:
 
����������ѡ��:
 
ֹͣ������ѡ��:
 
��������� <support@kingbase.com.cn>.
 
�ر�ģʽ��:
   %s kill    SIGNALNAME PID
   %s register   [-N SERVICENAME] [-U USERNAME] [-P PASSWORD] [-D DATADIR]
                    [-w|-W] [-o "OPTIONS"]
   %s reload  [-D DATADIR] [-s]
   %s restart [-w|-W] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE] [-o "OPTIONS"]
   %s start   [-w|-W] [-t SECS] [-D DATADIR] [-s] [-l FILENAME] [-o "OPTIONS"]
   %s status  [-D DATADIR]
   %s stop    [-w|-W] [-t SECS] [-D DATADIR] [-s] [-m SHUTDOWN-MODE]
   %s unregister [-N SERVICENAME]
   -?, --help             ��ʾ������Ϣ, Ȼ���˳�
   -D, --data DATADIR     ���ݿ�洢��λ��
   -N SERVICENAME          ����������Kingbase��������ע����
   -P PASSWORD             ��½Kingbase �������������˺�
   -U USERNAME             ��½Kingbase ���������û����˺�
   -V, --version          ����汾��Ϣ��Ȼ���˳�
   -W                     ���صȴ���������(�� -w -t ѡ���ͻ)
   -c, --core-files       ���� kingbase ���ɺ����ļ�
   -c, --core-files       �����ƽ̨�ϲ�����
   -l, --log FILENAME     д (��������) ��������־�� FILENAME
   -m SHUTDOWN-MODE       ���� "smart", "fast", ���� "immediate"
   -o OPTIONS             ������ѡ���kingbase
                         (Kingbase ��������ִ��)
   -p PATH-TO-KINGBASE    һ�㲻��Ҫ
   -s, --silent           ����ӡ�����ޱ�����Ϣ
   -t SECS                ��ʹ�� -w ѡ��ʱ��Ҫ�ȴ�������
   -w                     �ȴ���ֱ����������(�� -W ѡ���ͻ)
   ����ֱ��ֹͣ, �����ػ�
   ����ֹͣ��û�йػ�; ����ִ�лָ�����
   �����пͻ��˶Ͽ����Ӻ�����ֹͣ
 ִ��
  ʧ��
 %s ��һ��������ֹͣ�����������������ļ��Ĺ���,
�㱨Kingbase ��������״̬, �������ź�֪ͨKingbase �Ľ���.

 %s: PID �ļ� "%s" ������
 %s: ���������������������У�����ǿ������������
 %s: �����ڸ�Ŀ¼������
����(����Ȩ) �û����ݵ�½ (using, e.g., "su") ���⽫ӵ�з���������.
 %s: �޷����ط�����; ���û���������������(PID: %ld)
 %s: �޷�����������;���û���������������(PID: %ld)
 %s: �޷������ں˴�С, ������Դ����.
 %s: �޷�ֹͣ������; ���û���������������(PID: %ld)
 %s: �޷��ҵ�kingbaseִ�г���
 %s: �޷��ҵ��Դ�ִ�г���
 %s: �޷���PID �ļ� "%s": %s
 %s: �޷��򿪷���"%s": ������� %d
 %s: �޷��򿪷�����������
 %s: �޷����ļ� "%s"
 %s: �޷�ע�����"%s": ������� %d
 %s: �޷����������ź�(PID: %ld): %s
 %s: �޷������ź� %d (PID: %ld): %s
 %s: �޷�����ֹͣ�ź�(PID: %ld): %s
 %s: �޷�����������
�����־���.
 %s: �޷�����������: �˳�����Ϊ %d
 %s: �޷���������"%s": �������%d
 %s: �޷�ע������"%s": �������%d
 %s: ��Ч������PID �ļ��� "%s"
 %s: ɱ��ģʽ�Ĺ��ϲ���
 %s: û��ָ�����ݿ�Ŀ¼���һ�������KINGBASE_DATA��λ
 %s: ��ָ������
 %s: û�з���������
 %s: �ɵķ���������(PID: %ld)�����Ѿ���ȥ�� 
 %s: ��ѡ�ļ�"%s" ��������ȷ��һ��
 %s: �ڴ治��
 %s: ������û�йر�
 %s: ��������������(PID: %ld)
 %s: ���� "%s" �Ѿ�ע��
 %s: ���� "%s" û�б�ע��
 %s: ���û���������������(PID: %ld)
 %s: ����������в���(������"%s")
 %s: δʶ��Ĳ���ģʽ"%s"
 %s: δʶ��Ĺػ�ģʽ"%s"
 %s: δʶ����ź���"%s"
 (ȱʡֵ�ǵȴ��ر�, ������������������.)

 ��� -D ѡ�����, �������� KINGBASE_DATA ��ʹ��.
 �������Ƿ�������?
 ����ֹͣ���û�������������һ��.
 ����"kingbase" ��%s��Ҫ�ģ���"%s"�޷���ͬһĿ¼���ҵ�.
������İ�װ.
 ����"kingbase" ��"%s"�ҵ�
����%s�İ汾��һ��.
������İ�װ.
 ������"%s --help" �õ�������Ϣ.
 ʹ��:
 �����˳�����ʹ�ӳ����˳�%d �޷�ʶ���ӳ����˳�״̬ %d �ӳ�����ֹ���ź� %d �޷��ı�Ŀ¼�� "%s" �Ҳ��� "%s" ȥִ�� �޷�ȷ�ϵ�ǰĿ¼: %s �޷���ȡ������ "%s" �޷���ȡ��������"%s" �޷�����������
 ��Ч������ "%s" �������ر���
 �������������ź�
 ������������
 ������������
 ��������ֹͣ
 ǿ������������
 ��ȴ��������ر�... �����������У���ȴ� 