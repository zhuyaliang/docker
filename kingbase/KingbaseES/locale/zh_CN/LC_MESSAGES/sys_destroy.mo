��    5      �  G   l      �  0   �  E   �  R      9   S  3   �  D   �  <     <   C  ,   �  1   �     �     �          .     G     Z  @   r  @   �  (   �  *        H  =   b  "   �     �     �  5   �     .	  !   G	  %   i	  .   �	  -   �	     �	  8    
     9
  "   Y
     |
     �
     �
  C   �
  	     *     %   B     h     �  *   �  0   �  X   �     U     c  =   |  D   �     �  [    -   y  -   �  7   �  )     '   7  5   _  -   �  &   �     �  #        *     <     N     \     j     x  '   �  &   �     �     �     	  1         R     m     �     �     �     �     �     �          7  +   G     s     �     �     �     �  /   �       %     #   D     h     �     �  +   �  0   �               1  '   G     o     /              &   (         $             3   0      ,                   )   .             #                   '       5   "      *      +   
          %                       2                      	      4   !       1          -                        -?, --help          show this help, then exit
   -D DATADIR          specify the database directory to be destroyed
   -F                  force destroy without user confirm and shield the interrupt
   -L1 | -L2           destroy level, default level is L2
   -P PASSWORD         specify the destroy password
   -R                  remove data, log, control files after destroy
   -V, --version       output version information, then exit
 %s destroy the Kingbase data file, log file, control file.

 %s: could not locate my own executable path
 Are you confirm destroy data and log files?[y/N]
 Destroy archive log start
 Destroy archive log successful
 Destroy data start
 Destroy data successful
 Destroy log start
 Destroy log successful
 ERROR: "%s"  has been corrupted, log files can not be destroyed
 ERROR: "%s" has been corrupted, data files can not be destroyed
 ERROR: "CTL/" directory not exist in %s
 ERROR: could not change directory to "%s"
 ERROR: fstat "%s" failed
 ERROR: illegal level, destroy level should be "-L1" or "-L2"
 ERROR: open directory "%s" failed
 ERROR: open file "%s" failed
 ERROR: password error
 ERROR: password length too long, should less than 64
 ERROR: read "%s" failed
 ERROR: read data desc file error
 ERROR: read redo log desc file error
 ERROR: thread failed to start destroying data
 ERROR: thread failed to start destroying log
 ERROR: usage error
 FATAL: Try do not add "-F" or contact technical support
 FATAL: control file is missing
 FATAL: destroy archive log failed
 FATAL: destroy data failed
 FATAL: destroy log failed
 FATAL: out of memory
 FATAL: system fault, please try again or contact technical support
 Options:
 Report bugs to <support@kingbase.com.cn>.
 Try "%s --help" for more information
 Usage:
  %s [OPTION]... 

 WARNING: remove "%s" failed
 WARNING: set the default block size is %d
 WARNING: sys_control exists but has invalid CRC
 WARNING: sys_destroy has not been opened
Please contact the security officer to open it
 input error!
 sys_destroy starting...
 the feature %s is not supported  by the current version type
 usage error! only one database directory can be destroyed each time
 user database does not exist
 Project-Id-Version: kingbaseES 6.1.3
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2011-01-25 13:53+0800
PO-Revision-Date: 2010-08-09 09:07+0800
Last-Translator: kingbase support <support@kingbase.com.cn>
Language-Team: kingbase support <support@kingbase.com.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=GBK
Content-Transfer-Encoding: 8bit
   -?, --help          ��ʾ������Ϣ, Ȼ���˳�
   -D DATADIR          ָ��Ҫ���ٵ����ݿ�Ŀ¼
   -F                  �����û�ȷ��ǿ�����������ж��ź�
   -L1 | -L2           ���ټ���Ĭ��ΪL2
   -P PASSWORD         ָ��������������
   -R                  ���ٺ�ɾ������, ��־, �����ļ�
   -V, --version       ����汾��Ϣ��Ȼ���˳�
 %s ����KingbaseES����,��־,�����ļ�.

 %s: �Ҳ�����ִ���ļ���·��
 ��ȷ��Ҫ�������ݺ���־�ļ���?[y/N]
 ���ٹ鵵��־��ʼ
 ���ٹ鵵��־�ɹ�
 �������ݿ�ʼ
 �������ݳɹ�
 ������־��ʼ
 ������־�ɹ�
 ����:  "%s" ����, ��־�ļ��޷�������
 ����: "%s" ����, �����ļ��޷�������
 ����: Ŀ¼"CTL/" �� %s ������
 �޷��л���Ŀ¼ "%s"
 ����: fstat "%s" ʧ��
 ����: ���ټ��𲻺Ϸ�, ���ټ���ӦΪ"-L1" �� "-L2"
 ERROR: ��Ŀ¼ "%s" ʧ��
 ����: ���ļ� "%s" ʧ��
 ����: �������
 ��������̫��, ӦС��64
 ���󣺶�ȡ "%s" ʧ��
 ����: ��ȡ���ݵݼ��ļ�����
 ����: ��ȡ��־�����ļ�ʧ��
 ����: �������������߳�ʧ��
 ����: ����������־�߳�ʧ��
 ����: �÷�����
 ���ش���: �볢��ȥ�� "-F" ������ϵ����֧��
 ���ش���: �����ļ���ȫ
 ���ش���: ���ٹ鵵��־ʧ��
 ���ش���: ��������ʧ��
 ���ش���: ������־ʧ��
 ����: �ڴ治��
 ���ش���: ϵͳ����, ������һ�λ�����ϵ����֧��
 ѡ��:
 ���������<support@kingbase.com.cn>.
 ���˽������Ϣ���볢�� "%s --help"
 ʹ��:
  %s [ѡ��]... 

 ����: ɾ�� "%s" ʧ��
 ����: ����Ĭ�Ͽ��СΪ %d
 ����: sys_control ���ڣ���ѭ������У����Ч
 ����: ����������δ������
����ϵ��ȫԱ�����˹���
 �������
 ������������������...
 ��ǰ�汾��֧������%s
 �÷�����! ÿ��ֻ��������һ�����ݿ�Ŀ¼
 �û����ݿⲻ����
 