unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, Forms, Controls, Graphics, Dialogs, ExtCtrls, Buttons,
  StdCtrls;


type BarButton = record
  Align: TAlign;
  Caption: TCaption;
  ImageFileName: TFileName;
  OnClick: TNotifyEvent;
  GroupIndex: Integer;
  Tag: Integer;
end;

type

  { TForm1 }

  TForm1 = class(TForm)
    lblMain: TLabel;
    lblTitle: TLabel;
    pnlNavTop: TPanel;
    pnlSideNav: TPanel;
    pnlMain: TPanel;
    btnToggle: TSpeedButton;
    procedure btnClick(Sender: TObject);
    procedure btnToggleClick(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure setGroupIndex(Sender: TObject);


  private
    barButtons: array[0..9] of BarButton;
    btns: array of TSpeedButton;
    procedure init;
    procedure setButtonOptions(pnl: TPanel);
    procedure createBarButtons;
    procedure createBtns(pnl: TPanel);
    procedure fadeInPanel(pnl: TPanel; pnlWidth: integer);
    procedure fadeOutPanel(pnl: TPanel);


  public

  end;

const
  defaultSideNavWidth: integer = 300;
  defaultGlyphWidth: integer = 25;
  defaultButtonMargin: integer = 30;
  defaultButtonHeight: integer = 40;

var
  glyphContainerWidth: integer;
  activeGroupIndex: integer = 2;
  Form1: TForm1;

implementation

{$R *.lfm}

{ TForm1 }

procedure TForm1.btnClick(Sender: TObject);
var i: integer;
begin
  for i:= 0 to High(btns) do
    btns[i].Down:= btns[i]=(Sender as TSpeedButton);
  lblMain.Caption:= (Sender as TSpeedButton).Caption;
end;

procedure TForm1.btnToggleClick(Sender: TObject);
begin
  if (pnlSideNav.Width<>defaultSideNavWidth)
  then fadeInPanel(pnlSideNav, defaultSideNavWidth)
  else fadeOutPanel(pnlSideNav);
end;

procedure TForm1.btnExitClick(Sender: TObject);
begin
  close;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  init;
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  SetLength(btns,0);
end;

procedure TForm1.setGroupIndex(Sender: TObject);
begin
  // Toggle
  if (activeGroupIndex = (Sender as TSpeedButton).Tag)
  then activeGroupIndex:= 2
  else activeGroupIndex:= (Sender as TSpeedButton).Tag;
  setButtonOptions(pnlSideNav);
end;

procedure TForm1.init;
begin
  glyphContainerWidth:= defaultButtonMargin*2+defaultGlyphWidth;
  createBarButtons;
  createBtns(pnlSideNav);
  setButtonOptions(pnlSideNav);
end;

procedure TForm1.setButtonOptions(pnl: TPanel);
var i: integer;
begin
  for i:= 0 to High(btns) do
  begin
    btns[i].ShowCaption:= pnl.Width>defaultSideNavWidth div 2;
    btns[i].Visible:= (btns[i].GroupIndex = activeGroupIndex) or (btns[i].GroupIndex=1);
  end;
end;

procedure TForm1.createBarButtons;
begin
  // Home
  barButtons[0].Caption:= 'Home';
  barButtons[0].Align:= alTop;
  barButtons[0].ImageFileName:= 'resources/dashboard.bmp';
  barButtons[0].OnClick:= @btnClick;
  barButtons[0].GroupIndex:= 1;
  // Video
  barButtons[1].Caption:= 'Video';
  barButtons[1].Align:= alTop;
  barButtons[1].ImageFileName:= 'resources/video.bmp';
  barButtons[1].OnClick:= @btnClick;
  barButtons[1].GroupIndex:= 2;
  // Music
  barButtons[2].Caption:= 'Music';
  barButtons[2].Align:= alTop;
  barButtons[2].ImageFileName:= 'resources/music.bmp';
  barButtons[2].OnClick:= @btnClick;
  barButtons[2].GroupIndex:= 2;
  // Book
  barButtons[3].Caption:= 'Book';
  barButtons[3].Align:= alTop;
  barButtons[3].ImageFileName:= 'resources/book.bmp';
  barButtons[3].OnClick:= @btnClick;
  barButtons[3].GroupIndex:= 2;
  // FaceBook
  barButtons[4].Caption:= 'Facebook';
  barButtons[4].Align:= alTop;
  barButtons[4].ImageFileName:= 'resources/facebook.bmp';
  barButtons[4].OnClick:= @btnClick;
  barButtons[4].GroupIndex:= 3;
  // Google Plus
  barButtons[5].Caption:= 'Google';
  barButtons[5].Align:= alTop;
  barButtons[5].ImageFileName:= 'resources/google-plus.bmp';
  barButtons[5].OnClick:= @btnClick;
  barButtons[5].GroupIndex:= 3;
  // Twitter
  barButtons[6].Caption:= 'Twitter';
  barButtons[6].Align:= alTop;
  barButtons[6].ImageFileName:= 'resources/twitter.bmp';
  barButtons[6].OnClick:= @btnClick;
  barButtons[6].GroupIndex:= 3;
  // Media
  barButtons[7].Caption:= 'Media';
  barButtons[7].Align:= alBottom;
  barButtons[7].ImageFileName:= 'resources/compact-disc.bmp';
  barButtons[7].OnClick:= @setGroupIndex;
  barButtons[7].GroupIndex:= 1;
  barButtons[7].Tag:= 2;
  // Social
  barButtons[8].Caption:= 'Social';
  barButtons[8].Align:= alBottom;
  barButtons[8].ImageFileName:= 'resources/hashtag.bmp';
  barButtons[8].OnClick:= @setGroupIndex;
  barButtons[8].GroupIndex:= 1;
  barButtons[8].Tag:= 3;
  // Exit
  barButtons[9].Caption:= 'Exit';
  barButtons[9].Align:= alBottom;
  barButtons[9].ImageFileName:='resources/Exit.bmp';
  barButtons[9].OnClick:= @btnExitClick;
  barButtons[9].GroupIndex:= 1;
end;

procedure TForm1.createBtns(pnl: TPanel);
var
  i: integer=0;
  y:integer=1;
  btn: TSpeedButton;
  filePath: TFileName;
begin
  {*
    OSX/ Darwin disable:
    Use Application Bundle for running and debugging in Lazarus project options
  *}
  filePath:= IncludeTrailingBackslash(ExtractFilePath(ParamStr(0)));
  for i:= 0 to High(barButtons) do
  begin
    btn:= TSpeedButton.Create(pnl);
    btn.Parent:= pnl;
    with btn do
    begin
      AllowAllUp:= true;
      Height:= defaultButtonHeight;
      Align:= barButtons[i].Align;
      if (Align=alTop) then
      begin
        inc(y);
        Top:= pnlNavTop.Height+(defaultButtonHeight*y)+1;
        BorderSpacing.Top:= 15;
      end else
      if (Align=alBottom) then
      begin
        BorderSpacing.Bottom:= 15;
      end;
      Caption:= barButtons[i].Caption;
      Cursor:= crHandPoint;
      Flat:= true;
      Font.Color:= 16481792;
      Font.Size:= 14;
      Font.Style:= [fsBold];
      Margin:= defaultButtonMargin;
      Spacing:= -1;
      OnClick:= barButtons[i].OnClick;
      ParentFont:= False;
      GroupIndex:= barButtons[i].GroupIndex;
      Tag:= barButtons[i].Tag;
      Visible:= (GroupIndex=1);
      Glyph.LoadFromFile(filePath+barButtons[i].ImageFileName);
    end;
    SetLength(btns, Length(btns)+1);
    btns[High(btns)]:= btn;
  end;
end;

procedure TForm1.fadeInPanel(pnl: TPanel; pnlWidth: integer);
var i: integer;
begin
  i:= pnl.Width;
  while i < pnlWidth do
  begin
    inc(i);
    pnl.Width:= i;
    setButtonOptions(pnl);
    Application.ProcessMessages;
  end;
end;

procedure TForm1.fadeOutPanel(pnl: TPanel);
var i: integer;
begin
  i:= pnl.Width;
  while i > glyphContainerWidth do
  begin
    dec(i);
    pnl.Width:= i;
    setButtonOptions(pnl);
    Application.ProcessMessages;
  end;
end;

end.

