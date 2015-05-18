unit Unit1;

{$mode objfpc}{$H+}

interface

uses
  Classes, SysUtils, FileUtil, Forms, Controls, Graphics, Dialogs, DbCtrls,
  DBGrids, Menus, ExtCtrls, ComCtrls, StdCtrls, sqlite3conn, sqldb, db,
  LResources, Messages, Windows, ActnList, Variants, LCLType, maskedit, types,
  Clipbrd;

type

  { TForm1 }

  TForm1 = class(TForm)
    Done: TButton;
    ComboBox1: TComboBox;
    DataSource1: TDataSource;
    DBGrid1: TDBGrid;
    DBNavigator1: TDBNavigator;
    Edit1: TEdit;
    Label1: TLabel;
    Label2: TLabel;
    MainMenu1: TMainMenu;
    MenuItem1: TMenuItem;
    Commit: TMenuItem;
    Cancel: TMenuItem;
    Panel1: TPanel;
    SelectAll: TMenuItem;
    Quit: TMenuItem;
    SQLite3Connection1: TSQLite3Connection;
    SQLQuery1: TSQLQuery;
    SQLQuery1Address: TStringField;
    SQLQuery1Email: TStringField;
    SQLQuery1ID: TLongintField;
    SQLQuery1Name: TStringField;
    SQLQuery1Other: TStringField;
    SQLQuery1Phone: TLargeintField;
    SQLTransaction1: TSQLTransaction;
    Undo: TMenuItem;
    Cut: TMenuItem;
    Cpy: TMenuItem;
    Paste: TMenuItem;
    Delete: TMenuItem;
    Time: TMenuItem;
    StatusBar: TMenuItem;
    MenuItem2: TMenuItem;
    About: TMenuItem;
    Find: TMenuItem;
    MenuItem3: TMenuItem;
    MenuItem4: TMenuItem;
    MenuItem5: TMenuItem;
    StatusBar1: TStatusBar;
    procedure DBGrid1DblClick(Sender: TObject);
    procedure DoneClick(Sender: TObject);
    procedure DBGrid1ColEnter(Sender: TObject);
    procedure DBGrid1KeyPress(Sender: TObject; var Key: char);
    procedure DBNavigator1BeforeAction(Sender: TObject; Button: TDBNavButtonType
      );
    procedure CutClick(Sender: TObject);
    procedure CpyClick(Sender: TObject);
    procedure DeleteClick(Sender: TObject);
    procedure Edit1Change(Sender: TObject);
    procedure FindClick(Sender: TObject);
    procedure FindNextClick(Sender: TObject);
    //procedure FormClose(Sender: TObject; var CloseAction: TCloseAction);
    procedure FormCloseQuery(Sender: TObject; var CanClose: boolean);
    procedure FormCreate(Sender: TObject);
    procedure HelpClick(Sender: TObject);
    procedure AboutClick(Sender: TObject);
    procedure CommitClick(Sender: TObject);
    procedure CancelClick(Sender: TObject);
    procedure ReplaceClick(Sender: TObject);
    procedure SelectAllClick(Sender: TObject);
    procedure TimeClick(Sender: TObject);
    procedure PasteClick(Sender: TObject);
    procedure UndoClick(Sender: TObject);
    procedure QuitClick(Sender: TObject);
    procedure MenuItem18Click(Sender: TObject);
    procedure StatusBarClick(Sender: TObject);
    procedure MenuItem1Click(Sender: TObject);
    procedure MenuItem2Click(Sender: TObject);
    procedure MenuItem3Click(Sender: TObject);
    procedure MenuItem4Click(Sender: TObject);
    procedure MenuItem5Click(Sender: TObject);
    procedure OpenClick(Sender: TObject);
    procedure NwClick(Sender: TObject);
    procedure SaveClick(Sender: TObject);
    procedure SaveAsClick(Sender: TObject);
    procedure FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
    procedure CloseMessageBox(Sender: TObject);
    procedure Terminator(Sender: TObject);
    procedure SearchUpdate(Sender: TObject);
  private
    { private declarations }
    Committed:Boolean;
    Terminate:Boolean;
    SearchColumn:String;
  public
    { public declarations }
  end;

var
  Form1: TForm1;

implementation
uses Unit2;
{$R *.lfm}

{ TForm1 }
procedure TForm1.SearchUpdate(Sender: TObject);
begin
  SearchColumn:='All';
  case ComboBox1.ItemIndex of
    0: SearchColumn:='All';
    1: SearchColumn:='Name';
    2: SearchColumn:='Phone';
    3: SearchColumn:='Address';
    4: SearchColumn:='Email';
    5: SearchColumn:='Other';
  end;
end;

procedure TForm1.FormKeyDown(Sender: TObject; var Key: Word;
  Shift: TShiftState);
begin
  if (Key = VK_F4) and (ssAlt in Shift) then
  begin
  Key := 0;
  QuitClick(Self);
  end;
end;

procedure TForm1.CancelClick(Sender: TObject);
begin
  SQLQuery1.CancelUpdates;
end;

procedure TForm1.DoneClick(Sender: TObject);
begin
  if Committed = false then
  begin
    case MessageBox(0,'Do you want to commit changes?','MyContact',
    +MB_YESNOCANCEL) of
    IDYES:
      begin
        CommitClick(Self);
      end;
    IDCANCEL:
      begin
        Abort;
      end;
    end;
  end;

  SQLQuery1.Close;
  SQLQuery1.SQL.Text:='SELECT * FROM MyContact';
  SQLQuery1.Open;
  Panel1.Visible:=False;
end;

procedure TForm1.DBGrid1DblClick(Sender: TObject);
begin
  Form1.DBNavigator1.BtnClick(nbEdit);
end;

procedure TForm1.DBGrid1ColEnter(Sender: TObject);
begin
  StatusBar1.Panels[0].Text := 'Column - '+IntToStr(DBGrid1.SelectedIndex);
  StatusBar1.Panels[1].Text:= 'Record - '+IntToStr(SQLQuery1.RecNo);
end;

procedure TForm1.DBGrid1KeyPress(Sender: TObject; var Key: char);
begin
  Committed := False;
end;
//DBNavigator.BtnClick(nbRefresh);
procedure TForm1.DBNavigator1BeforeAction(Sender: TObject;
  Button: TDBNavButtonType);
begin
  if (Button = nbInsert) or (button = nbEdit) or (button = nbDelete) then
    begin
      Committed := False;
    end;
  if Committed = False then
    if Button=nbRefresh then
    begin
      Abort;
    end;
  if Button=nbEdit then
  begin
    SQLQuery1.Edit;
    Form2.DBMemo1.DataField:=DBGrid1.Columns[1].FieldName;
    Form2.DBMemo2.DataField:=DBGrid1.Columns[2].FieldName;
    Form2.DBMemo3.DataField:=DBGrid1.Columns[3].FieldName;
    Form2.DBMemo4.DataField:=DBGrid1.Columns[4].FieldName;
    Form2.DBMemo5.DataField:=DBGrid1.Columns[5].FieldName;
    TForm2.Create(nil);
    Form2.ShowModal;
    Abort;
  end;
end;

procedure TForm1.CutClick(Sender: TObject);
begin
  SQLQuery1.Edit;
  Clipboard.AsText := DBGrid1.SelectedField.AsString;
  DBGrid1.SelectedField.AsString:= '';
end;

procedure TForm1.CpyClick(Sender: TObject);
begin
  SQLQuery1.Edit;
  Clipboard.AsText := DBGrid1.SelectedField.AsString;
end;

procedure TForm1.DeleteClick(Sender: TObject);
begin
  DBGrid1.SelectedField.AsString:= '';
end;

procedure TForm1.Edit1Change(Sender: TObject);
var
  SQLText:String;
begin
  SearchUpdate(self);
  SQLQuery1.Close;
  if SearchColumn = 'All' then
    begin
      SQLText:='SELECT * FROM MyContact WHERE Name LIKE "%' +
      Edit1.Text +'%" or Phone LIKE "%' +
      Edit1.Text +'%" or Address LIKE "%' +
      Edit1.Text +'%" or Email LIKE "%' +
      Edit1.Text +'%" or Other LIKE "%' +
      Edit1.Text +'%"'
    end
  else
    begin
       SQLText:='SELECT * FROM MyContact WHERE ' + SearchColumn + ' LIKE "%' +
       Edit1.Text +'%"';
    end;
  writeln(SQLText);
  SQLQuery1.SQL.Text:=SQLText;
  SQLQuery1.Open;
end;

procedure TForm1.FindClick(Sender: TObject);
begin
  if StatusBar1.Visible = false then
    begin
      Panel1.Align:=alBottom;
      Panel1.Anchors:=[akLeft,akRight,akBottom];
    end
  else
    begin
      Panel1.Align:=alNone;
      with panel1 do
      begin
        AnchorSideBottom.Control := StatusBar1;
        Anchors := [akLeft, akRight, akBottom];
      end;
    end;
  Panel1.Visible:= true;
end;

procedure TForm1.FindNextClick(Sender: TObject);
begin

end;

{procedure TForm1.FormClose(Sender: TObject; var CloseAction: TCloseAction);
begin
if Committed = False then
  begin
    CloseAction:= TCloseAction.caNone;
    CloseMessageBox(Self);
  end
else
  begin
    Terminate := True;
  end;
if Terminate = True then
  Terminator(Self);
end;} //WTF DOESNT WORK NOW?

procedure TForm1.FormCloseQuery(Sender: TObject; var CanClose: boolean);
begin
if Committed = False then
  begin
    CanClose := False;
    CloseMessageBox(Self);
  end
else
  begin
    Terminate := True;
  end;
if Terminate = True then
  CanClose := True;
  Terminator(Self);
end;

procedure TForm1.FormCreate(Sender: TObject);
var
  f: TField;
begin
  SQLite3Connection1.DatabaseName:='MyContact.db';
  SQLite3Connection1.Connected:=True;

  SQLTransaction1.Database:=SQLite3Connection1;

  SQLQuery1.Database:=SQLite3Connection1;
  SQLQuery1.SQL.text:='Select * FROM MyContact';
  SQLQuery1.open;
  f := SQLQuery1.FindField('phone');
  if f <> nil then
    f.ValidChars:=f.ValidChars + [#8]
  else
    showmessage('field phone not found');

  DataSource1.DataSet:=SQLQuery1;

  DBGrid1.DataSource:=DataSource1;
  DBGrid1.Columns[0].Visible:=false;

  DBNavigator1.DataSource:=DataSource1;
  Committed := True
end;

procedure TForm1.HelpClick(Sender: TObject);
begin

end;

procedure TForm1.AboutClick(Sender: TObject);
begin
  MessageBox(0, 'MyContact Version 1.0'+#13#10+'by Alex Zhang', 'About MyContact', MB_OK);
end;

procedure TForm1.CommitClick(Sender: TObject);
begin
  SQLQuery1.Edit;
  SQLQuery1.UpdateMode:=UpWhereAll;
  SQLQuery1.ApplyUpdates;
  SQLTransaction1.Commit;
  SQLQuery1.Close;
  //SQL property changes
  SQLQuery1.Open;
  Committed := True;
end;

procedure TForm1.ReplaceClick(Sender: TObject);
begin

end;

procedure TForm1.SelectAllClick(Sender: TObject);
begin
  SQLQuery1.Edit;
  DBGrid1.SelectedField.FocusControl;
end;

procedure TForm1.TimeClick(Sender: TObject);
begin
  SQLQuery1.Edit;
  DBGrid1.SelectedField.AsString := TimeToStr(Now) + ' ' + DateToStr(Now);
end;


procedure TForm1.PasteClick(Sender: TObject);
begin
  SQLQuery1.Edit;
  DBGrid1.SelectedField.AsString := Clipboard.AsText;
end;

procedure TForm1.UndoClick(Sender: TObject);
begin
  SQLQuery1.Cancel;
end;

procedure TForm1.CloseMessageBox(Sender: TObject);
begin
  case MessageBox(0,'Do you want to commit changes?','MyContact',
    +MB_YESNOCANCEL) of
    IDYES:
      begin
        CommitClick(Self);
        if Committed = True then
          Terminate := True;
      end;
    IDNO:
      begin
        Terminate := True;
      end;
    IDCANCEL:
      begin
        Abort;
      end;
    end;
end;

procedure TForm1.Terminator(Sender: TObject);
begin

  SQLQuery1.close;
  SQLTransaction1.Active:=False;
  SQLite3Connection1.Connected:=False;
  Application.Terminate;
end;

procedure TForm1.QuitClick(Sender: TObject);
begin
if Committed = False then
  CloseMessageBox(Self)
else
  begin
    Terminate := True;
  end;
if Terminate = True then
  Terminator(Self);
end;

procedure TForm1.MenuItem18Click(Sender: TObject);
begin

end;

procedure TForm1.StatusBarClick(Sender: TObject);
begin
  StatusBar1.Visible:= not(StatusBar1.Visible);
  if StatusBar1.Visible = false then
    begin
      Panel1.Align:=alBottom;
      Panel1.Anchors:=[akLeft,akRight,akBottom];
    end
  else
    begin
      Panel1.Align:=alNone;
      with panel1 do
      begin
        AnchorSideBottom.Control := StatusBar1;
        Anchors := [akLeft, akRight, akBottom];
      end;
    end;
end;

procedure TForm1.MenuItem1Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem2Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem3Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem4Click(Sender: TObject);
begin

end;

procedure TForm1.MenuItem5Click(Sender: TObject);
begin

end;

procedure TForm1.OpenClick(Sender: TObject);
begin

end;

procedure TForm1.NwClick(Sender: TObject);
begin

end;

procedure TForm1.SaveClick(Sender: TObject);
begin

end;

procedure TForm1.SaveAsClick(Sender: TObject);
begin

end;

end.

initialization
  {$I unit1.lrs}

