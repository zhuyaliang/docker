
本目录提供了如何使用 KSYS 接口的示例。示例提供了不同编程语言的版本。

java/
	Sample1 - 在 Java 程序中直接调用 KSYS.DLL 来启停 KingbaseES 数据库服务器的
	          例子。注意文件 Sample1.java 必须在包 com.kingbase.ksys 内。因为
	          KSYS.DLL 中导出给 JNI 调用的函数假设调用者来自该包。
	Sample2 - 在 Java 程序中通过调用 JKSYS.jar 包来启停 KingbaseES 数据库服务器
	          的例子。注意本例依赖 KingbaseES 发布的 JKSYS.jar 和 JDBC 驱动程序
			  kingbasejdbc.jar。

win32/ - Delphi 中调用 KSYS.DLL 来启停 KingbaseES 数据库服务器的例子。
