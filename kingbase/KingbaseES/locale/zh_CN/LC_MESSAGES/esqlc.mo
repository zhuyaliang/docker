��          �      \      �  ~   �  +   P  0   |  +   �  `   �     :  4   Z  7   �     �  .   G  G   v  4   �  )   �  M     +   k  4   �  >   �  	     !        7  /   8  &   h  ,   �  $   �  A   �     #  )   =  '   g  ,   �  !   �  /   �     	     -	  3   J	     ~	     �	  !   �	     �	     �	                      	                                                                  
           
If no output file is specified, the name is formed by adding .c to the
input file name, after stripping off .pgc if present.
 
Report bugs to <support@kingbase.com.cn>.
   --regression   run in regression testing mode
   -?, --help     show this help, then exit
   -C MODE        set compatibility mode; MODE may be one of "INFORMIX", "INFORMIX_SE", "ORACLE"
   -D SYMBOL      define SYMBOL
   -I DIRECTORY   search DIRECTORY for include files
   -V, --version  output version information, then exit
   -c             automatically generate C code from embedded SQL code;
                 currently this works for EXEC SQL TYPE
   -d             generate parser debug output
   -h             parse a header file, this option includes option "-c"
   -i             parse system include files as well
   -o OUTFILE     write result to OUTFILE
   -r OPTION      specify runtime behaviour;OPTION may only be "no_indicator"
   -s             precompile in simple mode
   -t             turn on autocommit of transactions
 %s is the Kingbase embedded SQL preprocessor for C programs.

 Options:
 Usage:
  %s [OPTION]... FILE...

 Project-Id-Version: KingbaseES V7.1.2
Report-Msgid-Bugs-To: 
POT-Creation-Date: 2012-09-19 16:51+0800
PO-Revision-Date: 2012-09-19 16:51+0800
Last-Translator: bejin
MIME-Version: 1.0
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8bit
 
�����ָ������ļ�,����ļ�����Ϊ�����ļ���.c
 
���������<support@kingbase.com.cn>.
   --regression	��regression testingģʽ����
   -?, --help	��ʾ������Ϣ, Ȼ���˳�
   -C MODE  	���ü���ģʽ;ģʽ������INFORMIX��INFORMIX_SE��ORACLE
   -D SYMBOL  	����SYMBOL
   -I DIRECTORY	����DIRECTORY�µ������ļ�
   -V, --version	����汾��Ϣ��Ȼ���˳�
   -c          	�Զ���Ƕ��ʽSQL��������C����
   -d, --debug	���������ĵ������
   -h         	����ͷ�ļ�����ѡ�������-cѡ����
   -i        	����ϵͳ�����ļ�
   -o OUTFILE	���������ļ�
   -r OPTION	ָ��������Ϊ��OPTIONֻ����no_indicator
   -s       	�Լ�ģʽ����
   -t       	���������Զ��ύ
 %s����Kingbase C����Ƕ��ʽԤ����
 ѡ��:
 �÷�:
  %s [OPTION]... FILE

 