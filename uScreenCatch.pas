//***************************************************************
//*����:��������
//*Email:yckxzjj@163.com
//*Ը�����໥��������ͬ����������
//*Delphi�����վ  http://yckxzjj.vip.sina.com 2003.07.06
//***************************************************************
unit uScreenCatch;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls, StdCtrls, ExtDlgs, Buttons, ComCtrls, Menus, JPEG ,Registry,
  WinSkinData, WinSkinStore, RzBHints, RzTray;

type
  TScreenCatchFrm = class(TForm)
    MainTimer: TTimer;
    ShowImage: TImage;
    SaveDialog: TSavePictureDialog;
    TopPanel: TPanel;
    StatusBar: TStatusBar;
    AllSreenPanel: TPanel;
    AllScreenSpeedBtn: TSpeedButton;
    QuYueSreenPanel: TPanel;
    QuYueSreenSpeedBtn: TSpeedButton;
    SavePanel: TPanel;
    SaveSpeedBtn: TSpeedButton;
    ExitPanel: TPanel;
    ExitSpeedBtn: TSpeedButton;
    OpenDialog: TOpenDialog;
    SystemTimer: TTimer;
    ScrollBox: TScrollBox;
    PopupMenu: TPopupMenu;
    N1: TMenuItem;
    N5: TMenuItem;
    N2: TMenuItem;
    N6: TMenuItem;
    N3: TMenuItem;
    N8: TMenuItem;
    N4: TMenuItem;
    N7: TMenuItem;
    pm_AutoScreen: TMenuItem;
    AutoScreenPanel: TPanel;
    AutoScreenSpeedBtn: TSpeedButton;
    SkinData: TSkinData;
    cstyle: TComboBox;
    RzTray1: TRzTrayIcon;
    RzBall1: TRzBalloonHints;
    Button1: TButton;
    procedure MainTimerTimer(Sender: TObject);
    procedure AllScreenSpeedBtnClick(Sender: TObject);
    procedure QuYueSreenSpeedBtnClick(Sender: TObject);
    procedure SaveSpeedBtnClick(Sender: TObject);
    procedure ExitSpeedBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure SystemTimerTimer(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure pm_AutoScreenClick(Sender: TObject);
    procedure AutoScreenSpeedBtnClick(Sender: TObject);
    procedure cstyleChange(Sender: TObject);
    procedure Button1Click(Sender: TObject);
  private
  public
    procedure BMPToJPG(BmpFileName:string);
    Procedure MsgBox;
  end;

var
  ScreenCatchFrm: TScreenCatchFrm;

implementation

uses uScreenCatchShow, uAutoScreen, Unit1;




{$R *.DFM}

//�Զ��庯��,���ȡ��4λa��z֮���ַ���,��ΪJPG��ʽͼ����ļ���
function RandomFileName():String;
var
  PicName : string;
  I : Integer;
begin
  Randomize;
  for I := 1 to 4 do
    PicName := PicName + Chr(97 + Random(26));
  RandomFileName := PicName;
end;

procedure TScreenCatchFrm.BMPToJPG(BmpFileName:string);
var
  Jpeg : TJPEGImage;
  Bmp : TBitmap;
begin
  Bmp := TBitmap.Create;
  try
    Bmp.LoadFromFile(BmpFileName);
    Jpeg := TJPEGImage.Create;
    try
      Jpeg.Assign(Bmp);
      Jpeg.Compress;
      //������ļ�����������EXE�ļ�ͬĿ¼��
      Jpeg.SaveToFile(ExtractFilePath(Application.ExeName) + RandomFileName + '.jpg');
    finally
      Jpeg.Free;
    end;
  finally
     Bmp.Free;
  end;
end;

procedure TScreenCatchFrm.MainTimerTimer(Sender: TObject); //ץȡ��Ļ�������浽Image�ؼ���
var
  Fullscreen : TBitmap;
  FullscreenCanvas : TCanvas;
  DC : HDC;
begin
  MainTimer.Enabled := False;//ȡ��ʱ��
  Fullscreen:=TBitmap.Create;//����һ��BITMAP�����ͼ��
  Fullscreen.Width := Screen.Width;
  Fullscreen.Height := Screen.Height;
  DC:=GetDC(0);//ȡ����Ļ��DC������0ָ������Ļ
  FullscreenCanvas := TCanvas.Create;//����һ��CANVAS����
  FullscreenCanvas.Handle := DC;

  Fullscreen.Canvas.CopyRect
  (Rect(0,0,Screen.Width,Screen.Height),FullScreenCanvas,
  Rect(0,0,Screen.Width,Screen.Height));
  //��������Ļ���Ƶ�BITMAP��
  FullScreenCanvas.Free;//�ͷ�CANVAS����
  ReleaseDC(0,DC);//�ͷ�DC
   //*******************************
  ShowImage.Picture.Bitmap := FullScreen;//�����µ�ͼ�󸳸�IMAGE����
  ShowImage.Width := FullScreen.Width;
  ShowImage.Height := FullScreen.Height;
  FullScreen.Free;//�ͷ�bitmap
  ScreenCatchFrm.WindowState := wsNormal;//��ԭ����״̬
  ScreenCatchFrm.Show;//��ʾ����
  MessageBeep(1);//BEEP��һ��������ͼ���Ѿ���ȡ���ˡ�
end;

procedure TScreenCatchFrm.AllScreenSpeedBtnClick(Sender: TObject);//ȫ��ץͼ
begin
  ScreenCatchFrm.WindowState := wsMinimized;//��С�����򴰿�
  ScreenCatchFrm.Hide;//�ѳ��������
  MainTimer.Enabled := True;//�򿪼�ʱ��
end;

procedure TScreenCatchFrm.QuYueSreenSpeedBtnClick(Sender: TObject);//����ץͼ
begin
  try
    begin
      ScreenCatchFrm.Hide;
      CatchScreenShowFrm := TCatchScreenShowFrm.Create(Application);
      CatchScreenShowFrm.Hide;
      CatchScreenShowFrm.ChildTimer.Enabled := True;
    end
  except
    MsgBox;
    Application.Terminate;
  end;
end;

procedure TScreenCatchFrm.SaveSpeedBtnClick(Sender: TObject);//����ͼƬ
begin
  SaveDialog.Title := 'bruce��ܰ��ʾ��ͼƬ����󽫱�ת��������ļ�';
  if SaveDialog.Execute then
  begin
    ScreenCatchFrm.ShowImage.Picture.SaveToFile(SaveDialog.FileName);
    BMPToJPG(SaveDialog.FileName);
    DeleteFile(SaveDialog.FileName);
  end;
end;

procedure TScreenCatchFrm.ExitSpeedBtnClick(Sender: TObject);
begin
  Close;
end;

procedure TScreenCatchFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  Action := caFree;
end;

procedure TScreenCatchFrm.MsgBox;
begin
  with Application do
    MessageBox('�����ڲ�����',PChar(Title),MB_OK+MB_ICONERROR);
end;

procedure TScreenCatchFrm.SystemTimerTimer(Sender: TObject);
var
  DateTime : TDateTime;
begin
  DateTime := Now;
  StatusBar.Panels[1].Text := DateTimeToStr(DateTime);
end;

procedure TScreenCatchFrm.FormCreate(Sender: TObject);
var
  RegF: TRegistry;
begin
cstyle.Clear;

   cstyle.Items.Add('��ɫ����')  ;
 cstyle.Items.Add('����ʱ��')  ;
 cstyle.Items.Add('��ɫ����') ;
 cstyle.Items.Add('�������');
 cstyle.Items.Add('����ݵ�' );
 cstyle.ItemIndex:=0;
    //��ȡע���,�����Ƿ������˿����Զ�����,������pm_AutoScreen��״̬
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run', True);
    if RegF.ValueExists('ScreenCapture') then
      pm_AutoScreen.Checked := True
    else
      pm_AutoScreen.Checked := False;
  except
    MsgBox;
  end;
   RegF.CloseKey;
   RegF.Free;
end;

procedure TScreenCatchFrm.pm_AutoScreenClick(Sender: TObject);
var RegF: TRegistry;
begin
  RegF := TRegistry.Create;
  RegF.RootKey := HKEY_LOCAL_MACHINE;
  try
    RegF.OpenKey('SOFTWARE\Microsoft\Windows\CurrentVersion\Run',True);
    //���ÿ����Ƿ��Զ�����
    if pm_AutoScreen.Checked then
    begin
      RegF.DeleteValue('ScreenCapture');
      RegF.WriteString('ScreenCapture', Application.ExeName);
    end
    else
      RegF.DeleteValue('ScreenCapture');
  except
    MsgBox;
  end;
   RegF.CloseKey;
   RegF.Free;
end;

procedure TScreenCatchFrm.AutoScreenSpeedBtnClick(Sender: TObject);
begin
  if AutoScreenSpeedBtn.Caption = 'ֹͣץͼ' then
  begin
    AutoScreenFrm.AutoScreenTimer.Enabled := False;
    AutoScreenSpeedBtn.Caption := '�Զ�ץͼ';
  end
  else
  begin
    AutoScreenFrm := TAutoScreenFrm.Create(Application);
    AutoScreenFrm.Show;
  end;
end;

procedure TScreenCatchFrm.cstyleChange(Sender: TObject);
begin
if cstyle.Text= '����ݵ�' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\����ݵ�.skn');
rztray1.ShowBalloonHint('Skin','����ݵ�',bhiinfo,10);
end
else if cstyle.Text= '����ʱ��' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\����ʱ��.skn');
rztray1.ShowBalloonHint('Skin','����ʱ��',bhiinfo,10);

end
else if cstyle.Text= '��ɫ����' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\��ɫ����.skn');
rztray1.ShowBalloonHint('Skin','��ɫ����',bhiinfo,10);
end
else if cstyle.Text= '��ɫ����' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\��ɫ����.skn');
rztray1.ShowBalloonHint('Skin','��ɫ����',bhiinfo,10);
end
else if cstyle.Text= '�������' then
begin
skindata.LoadFromFile(ExtractFilePath(ParamStr(0))+'Skins\�������.skn');
rztray1.ShowBalloonHint('Skin','�������',bhiinfo,10);
end;
end;

procedure TScreenCatchFrm.Button1Click(Sender: TObject);
begin
form1.show;
end;

end.
