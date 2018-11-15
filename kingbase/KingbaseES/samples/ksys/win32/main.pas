unit main;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, ksys, Filectrl;

type
  TTestDLL = class(TForm)
    Button1: TButton;
    Button2: TButton;
    Button3: TButton;
    Button4: TButton;
    GroupBox1: TGroupBox;
    CheckBox1: TCheckBox;
    CheckBox2: TCheckBox;
    Edit1: TEdit;
    Label1: TLabel;
    Button_bin: TButton;
    Edit_bin: TEdit;
    Edit_data: TEdit;
    Button_data: TButton;
    procedure Button1Click(Sender: TObject);
    procedure Button2Click(Sender: TObject);
    procedure Button3Click(Sender: TObject);
    procedure Button4Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure Button_binClick(Sender: TObject);
    procedure Button_dataClick(Sender: TObject);
  private
    { Private declarations }
    pid: LongWord;
    bindir: string;
    datadir: string;
    cm_datadir: string;
    connmode: LongWord;
    port: string;
  public
    { Public declarations }
  end;

var
  TestDLL: TTestDLL;

implementation

{$R *.dfm}

procedure TTestDLL.Button1Click(Sender: TObject);
var rc: LongWord;
begin

  if CheckBox1.Checked then
    connmode := 1;

  if CheckBox2.Checked then
    connmode := 2;

  if CheckBox1.Checked and CheckBox2.Checked then
    connmode := 0;

  if Edit1.Text = '' then
    port := '54321'
  else
    port := Edit1.Text;

  rc := Startup(connmode, PChar(Edit_bin.text), PChar(edit_data.Text), PChar('kingbase.exe'), port);

  if rc > 0 then
    begin
      MessageBox(0, 'succeed', 'Startup', MB_OK);
      pid := rc;
    end
  else
    MessageBox(0, 'failed', 'Startup', MB_OK);

end;

procedure TTestDLL.Button2Click(Sender: TObject);

var ret: Integer;

begin

if pid > 0 then
begin

  ret := Shutdown(pid, PChar('SIGINT'));
  if ret = 0 then
    MessageBox(0, 'succeed', 'shutdown', MB_OK)
  else
    MessageBox(0, 'failed', 'shutdown', MB_OK);

end

end;

procedure TTestDLL.Button3Click(Sender: TObject);

var ret11: Integer;
var ret12: Integer;

begin

  ret11 := Check(pid, PChar(edit_data.Text), PChar('kingbase.exe'));
  ret12 := Ping(PChar('user=SYSTEM password=MANAGER port=' + port + ' host=localhost dbname=TEMPLATE1'));
  if (ret11 = 0) and (ret12 = 0) then
    MessageBox(0, 'alive', 'Ping', MB_OK)
  else
    MessageBox(0, 'stopped', 'Ping', MB_OK);

end;

procedure TTestDLL.Button4Click(Sender: TObject);
var
  ret21: Integer;
  ret22: Integer;
begin

  ret21 := Check(pid, PChar(edit_data.Text), PChar('kingbase.exe'));
  ret22 := Ping(PChar('user=SYSTEM password=MANAGER connmode=''shared_memory'' datadir=' + cm_datadir + ' dbname=TEMPLATE1'));
  if (ret21 = 0) and (ret22 = 0) then
    MessageBox(0, 'alive', 'Ping', MB_OK)
  else
    MessageBox(0, 'stopped', 'Ping', MB_OK);
end;

procedure TTestDLL.FormCreate(Sender: TObject);
begin
  connmode := 0;
  port := '';
  pid := 0;
end;

procedure TTestDLL.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if pid > 0 then
    begin
      Shutdown(pid, PChar('SIGINT'));
  end
end;

procedure TTestDLL.Button_binClick(Sender: TObject);
var
  s: string;
begin
  selectDirectory('The Caption', '', s);
  bindir := s;
  Edit_bin.text :=s;
end;

procedure TTestDLL.Button_dataClick(Sender: TObject);
var
  s : string;
begin
  selectDirectory('The Caption', '', s);
  datadir := s;
  cm_datadir := ''''+datadir+'''';
  edit_data.Text :=s;
end;

end.
