��    �      <  �   \      (     )  9   +  +   e  "   �  &   �  (   �  *     1   /  2   a  7   �  1   �  .   �  +   -  G   Y  0   �  O   �      "  +   C     o  )   v  '   �  /   �     �  #     #   8  '   \  !   �  +   �  (   �  #   �  *     1   J  (   |     �  -   �  !   �  '     !   8  &   Z  5   �  '   �  "   �  "     (   %  +   N     z  S   �     �       #   !  #   E  #   i  #   �  #   �  #   �  \   �  +   V  0   �      �  A   �  E     &   \  -   �  3   �  3   �  )     7   C  3   {     �     �     �  +   �  )        :      Z     {  +   �  +   �  )   �  +     )   H  )   r     �  V   �  +     +   =  ;   i  +   �  )   �  ;   �  +   7  )   c  3   �  +   �  )   �  3     .   K  ,   z  +   �  )   �  %   �  +   #  +   O  +   {  +   �  	   �  �   �     |  &   �  !   �  +   �       +         L     Y  +   b  &   �  0   �  )   �  "         3  (   T     }  '   �  !   �     �     �  "         0   +   F   )   r   [  �      �!  '   �!  &   ""  "   I"     l"  %   �"  '   �"  +   �"  (   #  (   -#  /   V#  %   �#     �#  /   �#  '   �#  8   !$      Z$  $   {$     �$     �$     �$  ;   �$     %     3%     Q%  !   o%     �%     �%     �%     �%  "   �%  '   &     G&     f&     &     �&     �&     �&     �&  3   '     D'     _'     y'  !   �'     �'     �'  D   �'     ,(     H(     b(     x(     �(     �(     �(     �(  K   �(     2)     N)     j)  5   �)  5   �)     �)     *  (   &*  (   O*  #   x*  .   �*  )   �*     �*     �*     +  !   +     ?+     _+     y+     �+  $   �+  !   �+     �+  '   ,      ?,      `,     �,  B   �,  +   �,  +   -  2   3-  #   f-  !   �-  2   �-  #   �-  !   .  *   %.  #   P.  !   t.  +   �.  &   �.  $   �.  #   /  !   2/     T/  "   q/  !   �/     �/      �/     �/  \   �/     Z0     h0      �0  (   �0     �0  $   �0     1     1  +   1     F1     [1     z1     �1     �1     �1     �1      �1      2     2     2     ,2     E2  #   Y2      }2     %                         <   \          7   �   N   b   P   h   d   {   e                  f      :          K   0   D   *         Q   &           T      R       6   r   B   =   8   Y          i   �   W                     5   x       l   ^      $   S       3       ?   +   n   F           J              w   y       @   /         )       C       g   !   9   4   M      A           m   -                     [                E       z                  t   .   o   k   ~       }   ,   X       >   
   L   G       #      	           ;   ]   O      c   I       (   _           �      U          H   "   j   u   |   `   p   v   a   '   q       2   �             s   1       V   �   Z    
 
If these values seem acceptable, use -f to force reset.
 
Report bugs to <support@kingbase.com.cn>.
 
Warning: reset sys_control file.
 
Xlogid is %u, could not auto set it.
   -?, --help		show this help, then exit
   -C              	check sys_control file
   -L              	show sys_control file content
   -O OFFSET     	set next multitransaction offset
   -V, --version 	output version information, then exit
   -c              	create a new sys_control file
   -e XIDEPOCH 		set next transaction ID epoch
   -f              	force update to be done
   -l TLI,FILE     	force WAL starting location for new transaction log
   -m XID          	set next multitransaction ID
   -n              	no update, just show extracted control values (for testing)
   -o OID          	set next OID
   -x XID          	set next transaction ID
 ": %s
 %s resets the Kingbase transaction log.

 %s: Could not open redo log desc file " %s: Error reading redo log desc file header in  %s: OID (-o) must not be 0
 %s: Open redo log desc file error " %s: Read redo log desc file error " %s: Read redo log desc file error : %s
 %s: cannot be executed by "root"
 %s: could not change directory to "%s": %s
 %s: could not close redo log desc file " %s: could not create clog file: %s
 %s: could not create sys_control file: %s
 %s: could not find redo log file with logid "%u"
 %s: could not fsync redo log desc file " %s: could not malloc : %s
 %s: could not open file "%s" for reading: %s
 %s: could not open file "%s": %s
 %s: could not open redo log desc file " %s: could not read file "%s": %s
 %s: could not read log file "%s" : %s
 %s: could not seek in file "%s" to offset %u: %m: %s
 %s: could not stat directory "%s": %s.
 %s: could not write clog file: %s
 %s: could not write file "%s": %s
 %s: could not write pg_control file: %s
 %s: could not write to redo log desc file " %s: fsync error: %s
 %s: internal error -- sizeof(ControlFileData) is too large ... fix PG_CONTROL_SIZE
 %s: invalid LC_COLLATE setting
 %s: invalid LC_CTYPE setting
 %s: invalid argument for option -O
 %s: invalid argument for option -e
 %s: invalid argument for option -l
 %s: invalid argument for option -m
 %s: invalid argument for option -o
 %s: invalid argument for option -x
 %s: lock file "%s" exists
Is a server running?  If not, delete the lock file and try again.
 %s: multitransaction ID (-m) must not be 0
 %s: multitransaction offset (-O) must not be -1
 %s: no data directory specified
 %s: sys_control exists but has invalid CRC; proceed with caution
 %s: sys_control exists but is broken or unknown version; ignoring it
 %s: transaction ID (-x) must not be 0
 %s: transaction ID epoch (-e) must not be -1
 ---Catalog version number may be:               %u
 ---Database system identifier may be:           %s
 ---First log file can be set more than 0
 ---Latest checkpoint's TimeLineID can be set:       %u
 ---sys_control version number may be:           %u
 64-bit integers : %s
 Begin create sys_control file
 Catalog version number:                 %u
 Catalog version number:               %u
 Check sys_control file success
 Create sys_control file success
 Createing sys_control file...
 Database block size:                    %u
 Database system identifier:             %s
 Database system identifier:           %s
 Date/time type storage:                 %s
 Float4 argument passing:              %s
 Float8 argument passing:              %s
 Guessed sys_control values:

 If you are sure the data directory path is correct, execute
  touch %s
and try again.
 LC_COLLATE:                             %s
 LC_CTYPE:                               %s
 Latest checkpoint's NextMultiOffset can be set more than 0
 Latest checkpoint's NextMultiOffset:    %u
 Latest checkpoint's NextMultiOffset:  %u
 Latest checkpoint's NextMultiXactId can be set more than 0
 Latest checkpoint's NextMultiXactId:    %u
 Latest checkpoint's NextMultiXactId:  %u
 Latest checkpoint's NextOID can be set more than 0
 Latest checkpoint's NextOID:            %u
 Latest checkpoint's NextOID:          %u
 Latest checkpoint's NextXID can be set more than 0
 Latest checkpoint's NextXID:            %u/%u
 Latest checkpoint's NextXID:          %u/%u
 Latest checkpoint's TimeLineID:         %u
 Latest checkpoint's TimeLineID:       %u
 Latest checkpoint's redo logid/Offset Maximum columns in an index:            %u
 Maximum data alignment:                 %u
 Maximum length of identifiers:          %u
 Maximum length of locale name:          %u
 Options:
 The database server was not shut down cleanly.
Resetting the transaction log may cause data to be lost.
If you want to proceed anyway, use -f to force reset.
 Transaction log reset
 Try "%s --help" for more information.
 Usage:
  %s [OPTION]... DATADIR

 WAL block size:                         %u
 Write redo log file...
 You must run %s as the Kingbase superuser.
 by reference by value case_sensitive:                         %s
 child process exited with exit code %d child process exited with unrecognized status %d child process was terminated by signal %d could not change directory to "%s" could not find a "%s" to execute could not identify current directory: %s could not read binary "%s" could not read from log file "%s" : %s
 could not read symbolic link "%s" floating-point numbers invalid binary "%s" log file "%s" header is not right
 sys_control values:

 sys_control version number:             %u
 sys_control version number:           %u
 Project-Id-Version: kingbaseES 6.1.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2010-08-11 16:52+0800
PO-Revision-Date: 2010-08-06 14:50+0800
Last-Translator: kingbase support <support@kingbase.com.cn>
Language-Team: kingbase support <support@kingbase.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8bit
 
 
�����Щֵ���Խ���, ʹ�� -f ǿ������.
 
���������<support@kingbase.com.cn>.
 
����: �������� sys_control �ļ�.
 
Xlogid �� %u, �޷��Զ�����.
   -?, --help		��ʾ������Ϣ��Ȼ���˳�
   -C              	���sys_control�ļ�
   -L              	��ʾsys_control�ļ�����
   -O OFFSET     	������һ��������ƫ����
   -V, --version 	����汾��Ϣ��Ȼ���˳�
   -c              	����һ���µ�sys_control�ļ�
   -e XIDEPOCH 		������һ������IDʱ��
   -f              	ǿ�Ƹ���
   -l TLI,FILE     	ǿ����������־��WAL��ʼλ��
   -m XID          	�趨��һ�������� ID
   -n              	������, ������ʾ(δ����)��ȡ�Ŀ���ֵ
  -o OID          	������һ��OID
   -x XID          	������һ������ID
 ": %s
 %s ����Kingbase������־.

 %s: �޷���������־�����ļ� " %s: ��������־�����ļ��ж�ȡ�ļ�ͷ����������־�����ļ���  %s: OID (-o) ����Ϊ0
 %s: ��������־�����ļ�����" %s: ��ȡ������־�����ļ�����" %s: ��ȡ������־�����ļ�����: %s
 %s: ���ܱ�"root"ִ��
 %s: �޷��ı�Ŀ¼��"%s": %s
 %s: �޷��ر�������־�����ļ� " %s: �޷�����clog�ļ�: %s
 %s: �޷����� sys_control �ļ�: %s
 %s: �޷��ҵ�logidΪ "%u"��������־�ļ�
 %s: �޷�fsync������־�����ļ�" %s:�޷������ڴ����: %s
 %s: �޷����ļ�"%s" �Ķ�: %s
 %s: �޷����ļ�"%s": %s
 %s: �޷���������־�����ļ� " %s: �޷���ȡ�ļ�"%s": %s
 %s: �޷���ȡ��־�ļ�"%s" : %s
 %s: �޷����ļ�"%s"�н��ļ�ָ�붨λ��ƫ��%u: %m: %s
 %s: �޷�ͳ��Ŀ¼"%s": %s.
 %s: �޷�д��clog�ļ�: %s
 %s: �޷�д���ļ�"%s": %s
 %s: �޷�д�� pg_control �ļ�: %s
 %s: �޷�д��������־�����ļ�" %s: fsync ����: %s
 %s: �ڲ�����-- ControlFileData�ṹ�����... �޸�PG_CONTROL_SIZE��С
 %s: ��Ч�� LC_COLLATE ����
 %s: ��Ч�� LC_CTYPE ����
 %s: ������ѡ��-O��Ч
 %s: ������ѡ��-e��Ч
 %s: ������ѡ��-l��Ч
 %s: ������ѡ��-m��Ч
 %s: ������ѡ��-o��Ч
 %s: ������ѡ��-x��Ч
 %s: ���ļ�"%s" ����
����������������?  ���û�У�ɾ�����ļ���Ȼ������һ��.
 %s: ������ ID (-m) ����Ϊ0
 %s: ������ƫ��(-O)����Ϊ-1
 %s: û��ָ������Ŀ¼
 %s: sys_control ���ڣ���ѭ������У����Ч; ���������
 %s: sys_control ���ڣ������ƻ���汾����; ���ں�����
 %s: ���� ID (-x) ����Ϊ0
 %s: ���� ID ʱ�� (-e) ����Ϊ-1
 ---ϵͳ���汾�ſ�����:               %u
 ---���ݿ�ϵͳ��ʶ��������:           %s
 ---��һ����־�ļ��������ô���0��ֵ
 ---���¼����TimeLineID�ɱ�����Ϊ:       %u
 ---sys_control�汾�ſ�����:           %u
 64λ���� : %s
 ��ʼ����sys_control�ļ�
 ϵͳ���汾��:                 %u
 ϵͳ���汾��:               %u
 ��� sys_control�ļ��ɹ�
 ����sys_control�ļ��ɹ�
 ���ڴ��� sys_control �ļ�...
 ���ݿ���С:                    %u
 ���ݿ�ϵͳ��ʶ��:             %s
 ���ݿ�ϵͳ��ʶ��:           %s
 ����/ʱ�� �洢����:                 %s
 Float4��������:              %s
 Float8��������:              %s
 �Ʋ�sys_control��ֵ:

 ���ȷ�����ݿ�Ŀ¼��·������ȷ��, ��ִ��
  touch %s
Ȼ������һ��.
 LC_COLLATE:                             %s
 LC_CTYPE:                               %s
 ���¼����NextMultiOffset ���Ա�����Ϊ����0��ֵ
 ���¼����NextMultiOffset:    %u
 ���¼����NextMultiOffset:  %u
 ���¼����NextMultiXactId ���Ա�����Ϊ����0��ֵ
 ���¼����NextMultiXactId:    %u
 ���¼����NextMultiXactId:  %u
 ���¼����NextOID ���Ա�����Ϊ����0��ֵ
 ���¼����NextOID:            %u
 ���¼����NextOID:          %u
 ���¼���� NextXID ���Ա�����Ϊ����0��ֵ
 ���¼����NextXID:            %u/%u
 ���¼����NextXID:          %u/%u
 ���¼����TimeLineID:         %u
 ���¼����TimeLineID:       %u
 ���¼��������logid/Offset �������е��������:            %u
 ������ݶ���:                 %u
 ��ʶ������󳤶�:          %u
 �������Ƶ���󳤶�:          %u
 ѡ��:
 �����ݿ������û����ȫ�ر�.
����������־���ܻᵼ�����ݶ�ʧ.
�����Ҫ����, ʹ�� -f ǿ������.
 ����������־
 ���� "%s --help" �˽������Ϣ.
 Usage:
  %s [ѡ��]... ����Ŀ¼

 WAL�Ŀ��С:                         %u
 д��������־�ļ�...
 ��������Kingbase�����û���������%s.
 ֵ���� ֵ���� case_sensitive:                         %s
 �ӳ������˳���%d�˳� �ӳ������޷�ʶ���״̬ %d �˳� �ӳ����ź� %d ��ֹ �޷��ı�Ŀ¼�� "%s" �Ҳ��� "%s" ȥִ�� �޷�ȷ�ϵ�ǰĿ¼: %s �޷���ȡ������ "%s" �޷�����־�ļ� "%s" �ж�ȡ : %s
 �޷���ȡ��������"%s" ������ ��Ч������ "%s" ��־�ļ�"%s" ͷ������ȷ
 sys_control ��ֵ:

 sys_control �汾��:             %u
 sys_control�汾��:           %u
 