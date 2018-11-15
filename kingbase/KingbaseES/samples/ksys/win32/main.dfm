object TestDLL: TTestDLL
  Left = 412
  Top = 213
  BorderStyle = bsSingle
  Caption = 'Test'
  ClientHeight = 342
  ClientWidth = 302
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poDesktopCenter
  OnClose = FormClose
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 24
    Top = 16
    Width = 48
    Height = 13
    Caption = #31471#21475#21495#65306
  end
  object Button1: TButton
    Left = 25
    Top = 255
    Width = 120
    Height = 30
    Caption = 'Startup'
    TabOrder = 0
    OnClick = Button1Click
  end
  object Button2: TButton
    Left = 25
    Top = 295
    Width = 120
    Height = 30
    Caption = 'Shutdown'
    TabOrder = 1
    OnClick = Button2Click
  end
  object Button3: TButton
    Left = 161
    Top = 255
    Width = 120
    Height = 30
    Caption = 'Ping_TCPIP'
    TabOrder = 2
    OnClick = Button3Click
  end
  object Button4: TButton
    Left = 161
    Top = 295
    Width = 120
    Height = 30
    Caption = 'Ping_ShareMemory'
    TabOrder = 3
    OnClick = Button4Click
  end
  object GroupBox1: TGroupBox
    Left = 24
    Top = 160
    Width = 257
    Height = 81
    Caption = #36830#25509#26041#24335
    TabOrder = 4
    object CheckBox1: TCheckBox
      Left = 16
      Top = 24
      Width = 137
      Height = 17
      Caption = 'TCPIP'
      Checked = True
      State = cbChecked
      TabOrder = 0
    end
    object CheckBox2: TCheckBox
      Left = 16
      Top = 48
      Width = 137
      Height = 17
      Caption = 'SHARED_MEMORY'
      TabOrder = 1
    end
  end
  object Edit1: TEdit
    Left = 88
    Top = 16
    Width = 193
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 5
  end
  object Button_bin: TButton
    Left = 24
    Top = 40
    Width = 145
    Height = 25
    Caption = #36873#25321#25968#25454#24211#23433#35013'bin'#30446#24405
    TabOrder = 6
    OnClick = Button_binClick
  end
  object Edit_bin: TEdit
    Left = 24
    Top = 69
    Width = 257
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 7
  end
  object Edit_data: TEdit
    Left = 24
    Top = 124
    Width = 257
    Height = 21
    ImeName = #20013#25991' ('#31616#20307') - '#35895#27468#25340#38899#36755#20837#27861
    TabOrder = 8
  end
  object Button_data: TButton
    Left = 24
    Top = 96
    Width = 153
    Height = 25
    Caption = #36873#25321#25968#25454#24211#23433#35013'data'#30446#24405
    TabOrder = 9
    OnClick = Button_dataClick
  end
end
