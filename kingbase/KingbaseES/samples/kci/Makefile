#
# Makefile for example programs
#



all: testlibkci

testlibkci: SelectATable.o binaryIO.o Lob.o MultipleConnections.o MultipleThread.o PreparedStatement.o
	gcc -Wall  -I../../include  SelectATable.o -D FRONTEND -L../../lib -lkci  -o SelectATable
	gcc -Wall  -I../../include  binaryIO.o -D FRONTEND -L../../lib -lkci  -o binaryIO
	gcc -Wall  -I../../include  Lob.o -D FRONTEND -L../../lib -lkci  -o Lob
	gcc -Wall  -I../../include  MultipleConnections.o -D FRONTEND -L../../lib -lkci  -o MultipleConnections
	gcc -Wall  -I../../include  MultipleThread.o -D FRONTEND -L../../lib -lkci  -o MultipleThread
	gcc -Wall  -I../../include  PreparedStatement.o -D FRONTEND -L../../lib -lkci  -o PreparedStatement
clean:
	rm -rf SelectATable binaryIO Lob MultipleConnections MultipleThread PreparedStatement *.o
