��    9      �  O   �      �  _   �  E   I  3   �  /   �  -   �  %   !  Q   G  0   �  .   �  E   �  8   ?  <   x  E   �  I   �  !   E  +   g  4   �     �  -   �  3   	  "   D	  $   g	     �	  #   �	  \   �	      "
  	   C
  *   M
  &   x
  #   �
  -   �
  (   �
          /     C  &   Z  0   �  )   �  "   �      �  (      "   I     l  "   �  !   �  ,   �     �  $     '   >     f  ,     '   �  ;   �          $     3  [  I  7   �  /   �  0     %   >  &   d  "   �  L   �  -   �  -   )  A   W  +   �  -   �  A   �  8   5     n     �  (   �     �     �  +   �     "     B     a     u  O   �     �     �  &   �  !      !   B  '   d     �     �     �     �     �     �          (     :     Q     f     }     �     �     �     �     �  #        9  &   L  &   s  6   �     �  	   �     �     (          7      .                    3      #          2      1   
      5   +                               ,      8                0                            -   %           	   )       !                  '   9      $             &      4   "                /           6   *    
If no data directory (DATADIR) is specified, the environment variable KINGBASE_DATA is used.

                       together with the physical file under dataDir 
         %s: read data file "%s" error: 
        %s
         file "%s" does not exist under DATADIR
     file: "%s" in sys_datafile doesn't exist
     file: "%s" in sys_datafile exist
     file: "%s" real size is %d(M), but its initial size is %d(M) in sys_datafile
   -?, --help          show this help, then exit
   -C                  check sys_datafile file
   -D filename.dbf     delete a data file info from sys_datafile file
   -L                  show system data file information
   -V, --version       output version information, then exit
   -d dbid,fileid      delete a data file info from sys_datafile file
 %s delete file info from, check and list the KingbaseES data desc file.

 %s: cannot be executed by "root"
 %s: could not change directory to "%s": %s
 %s: could not create temporary data desc file. : %s
 %s: could not open file " %s: could not open file "%s" for reading: %s
 %s: could not write temporary data desc file. : %s
 %s: error data desc file body in " %s: error data desc file header in " %s: fsync error: %s
 %s: invalid argument for option -d
 %s: lock file "%s" exists
Is a server running?  If not, delete the lock file and try again.
 %s: no data directory specified
 Options:
 Report bugs to <support@kingbase.com.cn>.
 Try "%s --help" for more information.
 Usage:
  %s [OPTION]... [DATADIR]

 You must run %s as the KingbaseES superuser.
 cannot delete physical file(%s) DATADIR
 check file body end
 check file body...
 check file header end
 child process exited with exit code %d child process exited with unrecognized status %d child process was terminated by signal %d could not change directory to "%s" could not find a "%s" to execute could not identify current directory: %s could not open directory "%s": %s
 could not read binary "%s" could not read directory "%s": %s
 could not read symbolic link "%s" could not remove file or directory "%s": %s
 could not rename file "%s" to " could not set junction for "%s": %s
 could not write to temporary desc file
 delete file(%s) success
 delete file(dbid = %d, fileid = %d) success
 file(%s) in sys_datafile doesn't exist
 file(dbid = %d, fileid = %d) in sys_datafile doesn't exist
 invalid binary "%s" out of memory
 read data desc file " Project-Id-Version: kingbaseES 6.1.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2016-08-23 16:19+0800
PO-Revision-Date: 2010-08-06 14:50+0800
Last-Translator: kingbase support <support@kingbase.com.cn>
Language-Team: kingbase support <support@kingbase.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8bit
 
���û��ָ��������Ŀ¼, �������� KINGBASE_DATA ʹ��.

                       ��ͬ����Ŀ¼�µ������ļ�
         %s: �Ķ������ļ� "%s" ����: 
        %s
         file "%s" ������Ŀ¼�²�����
     �ļ�: "%s" �� sys_datafile ������
 �ļ�: "%s" �� sys_datafile �д���
     �ļ�: "%s" ʵ�ʴ�С�� %d(M), ������sys_datafile�У����ĳ�ʼ��С�� %d(M)
   -?, --help          ��ʾ������Ϣ, Ȼ���˳�
   -C                  ��� sys_datafile �ļ�
   -D filename.dbf     �� sys_datafile �ļ���ɾ��һ�������ļ���Ϣ
   -L                  ��ʾϵͳ�����ļ���Ϣ
   -V, --version       ����汾��Ϣ��Ȼ���˳�
   -d dbid,fileid      �� sys_datafile �ļ���ɾ��һ�������ļ���Ϣ
 %s ���ļ���ɾ����Ϣ����鲢�г�KingbaseES���������ļ�.

 %s: �޷�ִ��"root"
 %s: �޷�����Ŀ¼"%s": %s
 %s: ���ܴ�����ʱ�ļ������������ļ�.: %s
 %s: �޷����ļ�" %s: �޷����ļ�"%s" �Ķ�: %s
 %s: �޷�д����ʱ�ļ������������ļ���. : %s
 %s: �ڴ�������������ļ�������" %s: �ڴ�������������ļ�ͷ�� " %s: fsync ����: %s
 %s: ��Ч�Ĳ���ѡ�� -d
 %s: �����ļ�"%s" ����
����������������?  ���û��, ɾ�������ļ���Ȼ������һ��.
 %s: ��ָ��������Ŀ¼
 ѡ��:
 ��������� <support@kingbase.com.cn>.
 ���� "%s --����" ���˽������Ϣ.
 �÷�:
  %s [ѡ��]... [����Ŀ¼]

 ��ΪKingbaseES �ĳ����û����������%s.
 ����ɾ������Ŀ¼�µ������ļ�%s
 ����ļ����Ľ���
 ����ļ�����...
 ����ļ�ͷ����
 �ӽ������˳�, �˳���Ϊ %d �ӽ������˳�, δ֪״̬ %d �ӽ��̱��ź� %d ��ֹ �޷�����Ŀ¼ "%s" �Ҳ����ļ� "%s" ��ִ�� �޷�ȷ�ϵ�ǰĿ¼: %s �޷���Ŀ¼ "%s": %s
 �޷���ȡ�������ļ� "%s" �޷���ȡĿ¼ "%s": %s
 �޷���ȡ�������� "%s" �޷�ɾ���ļ���Ŀ¼ "%s": %s
 �޷��������ļ� "%s" to " �޷����ûỰ�û�Ϊ "%s": %s
 �޷�д�뵽��ʱ�ļ������������ļ���
 ɾ���ļ�"%s" �ɹ�
 ɾ���ļ�(dbid = %d, fileid = %d) �ɹ�
     �ļ�: "%s" �� sys_datafile ������
 �ļ�(dbid = %d, fileid = %d) �� sys_datafile �в�����
 ��Ч�������ļ� "%s" �ڴ����
 ��ȡ���������ļ�" 