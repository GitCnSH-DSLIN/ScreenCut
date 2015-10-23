unit uAutoScreen;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, StdCtrls, Buttons, ExtCtrls, Spin;

type
  TAutoScreenFrm = class(TForm)
    SetSpinEdit: TSpinEdit;
    Label1: TLabel;
    Label2: TLabel;
    AutoScreenTimer: TTimer;
    AppBitBtn: TBitBtn;
    procedure AppBitBtnClick(Sender: TObject);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure AutoScreenTimerTimer(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  AutoScreenFrm: TAutoScreenFrm;

implementation

uses uScreenCatch;

{$R *.dfm}

procedure TAutoScreenFrm.AppBitBtnClick(Sender: TObject);
begin
  AutoScreenTimer.Enabled := True;
  AutoScreenTimer.Interval := StrToInt(SetSpinEdit.Text)*1000;
  AutoScreenFrm.Hide;
  if AutoScreenFrm.AutoScreenTimer.Enabled then
  begin
    SetWindowPos(AutoScreenFrm.Handle, HWND_TOPMOST, AutoScreenFrm.Left, AutoScreenFrm.Top, AutoScreenFrm.Width, AutoScreenFrm.Height,0);
    ScreenCatchFrm.AutoScreenSpeedBtn.Caption := 'ֹͣץͼ';
  end;
end;

procedure TAutoScreenFrm.FormClose(Sender: TObject;
  var Action: TCloseAction);
begin
  AutoScreenTimer.Enabled := False;
  Action:= caFree;
end;

procedure TAutoScreenFrm.AutoScreenTimerTimer(Sender: TObject);
var
  BuildBMP: TBitmap;
  c: TCanvas;
  r,t: TRect;
  h: THandle;
  ExeFilePath: string;
begin
  ExeFilePath := ExtractFilePath(Application.ExeName);
  c := TCanvas.Create;
  c.Handle := GetWindowDC(GetDesktopWindow);
  //��õ�ǰ����ڵľ��
  h := GetForeGroundWindow;
  BuildBMP := TBitmap.Create;
  if h <> 0 then
  //�ṹt����ô��ڵ����ϽǺ����½ǵ�����ֵ(�������Ļ���Ͻ�)
    GetWindowRect(h, t);
  try
    r := Rect(0, 0, t.Right-t.Left, t.Bottom-t.Top);
    BuildBMP.Width := t.Right-t.Left;
    BuildBMP.Height := t.Bottom-t.Top;
    BuildBMP.Canvas.CopyRect(r, c, t);
    //ץ�������������EXE��ͬĿ¼��
    BuildBMP.SaveToFile(ExeFilePath + 'AutoScreen.bmp');
  finally
    BuildBMP.Free;
  end;
  //���ļ�ת����JPG��ʽ,�Լ��ٴ��̿ռ��ռ��
  ScreenCatchFrm.BMPToJPG(ExeFilePath + 'AutoScreen.bmp');
end;


end.
