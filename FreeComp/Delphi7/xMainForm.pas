unit xMainForm;

interface

uses
  Windows, Messages, SysUtils, Variants, Classes, Graphics, Controls, Forms,
  Dialogs, ComCtrls, ShellCtrls, StdCtrls, FileCtrl, ExtCtrls, Buttons,
  ImgList;

type
  TMainForm = class(TForm)
    Panel2: TPanel;
    pnlFooter: TPanel;
    Label1: TLabel;
    DriveComboBox: TDriveComboBox;
    Label2: TLabel;
    Label3: TLabel;
    edFileName: TEdit;
    FilterComboBox: TFilterComboBox;
    pnlClient: TPanel;
    btnSave: TButton;
    btnCancel: TButton;
    sbBack: TSpeedButton;
    sbUp: TSpeedButton;
    sbNew: TSpeedButton;
    sbType: TSpeedButton;
    HiddenFileListBox: TFileListBox;
    HiddenDirectoryListBox: TDirectoryListBox;
    ListView: TListView;
    ImageList: TImageList;
    pnlCurrentFolder: TPanel;
    Shape1: TShape;
    Image1: TImage;
    lbCurrentFolder: TLabel;
    Bevel1: TBevel;
    Bevel2: TBevel;
    procedure DriveComboBoxChange(Sender: TObject);
    procedure btnCancelClick(Sender: TObject);
    procedure btnSaveClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure ListViewSelectItem(Sender: TObject; Item: TListItem;
      Selected: Boolean);
    procedure ListViewDblClick(Sender: TObject);
    procedure sbBackClick(Sender: TObject);
    procedure sbUpClick(Sender: TObject);
    procedure sbNewClick(Sender: TObject);
    procedure ListViewKeyPress(Sender: TObject; var Key: Char);
    procedure ListViewEdited(Sender: TObject; Item: TListItem;
      var S: String);
  private
    aItem: TListItem;
    SelectedFolder: String;
    PreviousLocationList: TStringList;
    procedure LoadListView(aDir: String; addPrevious: Boolean);
    procedure OpenFolder;
  public
    CurrentLocation: String;
  end;

var
  MainForm: TMainForm;

implementation

{$R *.dfm}

procedure TMainForm.DriveComboBoxChange(Sender: TObject);
begin
  LoadListView(DriveComboBox.Drive+':\', True);
end;

procedure TMainForm.btnCancelClick(Sender: TObject);
begin
  ModalResult := mrCancel;
end;

procedure TMainForm.btnSaveClick(Sender: TObject);
begin
  ModalResult := mrOK;
end;

procedure TMainForm.FormCreate(Sender: TObject);
begin
  PreviousLocationList := TStringList.Create;

  if DirectoryExists('c:\') then
  begin
    DriveComboBox.Drive := 'C';
    LoadListView('C:\', False);
  end else
    LoadListView(DriveComboBox.Drive+':\', False);

  PreviousLocationList.Clear;
  sbBack.Enabled := False;
end;

procedure TMainForm.LoadListView(aDir: String; addPrevious: Boolean);
var
  I, DirCount: Integer;
  vPos: Integer;
  vDir: String;
begin
  if UPPERCASE(CurrentLocation) = UPPERCASE(aDir) then exit;

  if addPrevious then
  begin
    PreviousLocationList.Add(CurrentLocation);
    sbBack.Enabled := True;
  end;
  CurrentLocation := aDir;

  if Copy(aDir,2,Length(aDir)) = ':\' then
  begin
    sbUp.Enabled := False;
    pnlCurrentFolder.Visible := False;
  end else
  begin
    sbUp.Enabled := True;
    I := Length(aDir) - 1;
    vDir := '';
    While I > 0 do
    begin
      if aDir[I] = '\' then
      begin
        vPos := I;
        vDir := IncludeTrailingBackslash(Copy(aDir,vPos+1,Length(aDir)));
        I := 0;
      end;
      I := I - 1;
    end;

    lbCurrentFolder.Caption := ExtractFileDir(vDir);
    pnlCurrentFolder.Visible := True;
  end;

  //Empty
  ListView.Items.Clear;
  //Load Folder Items
  HiddenDirectoryListBox.Directory := aDir;
  I := 0;
  DirCount := 0;
  While I < Length(aDir) + 1 do
  begin
    if aDir[I] = '\' then
      DirCount := DirCount + 1;
    I := I + 1;
  end;

  I := DirCount;
  While I < HiddenDirectoryListBox.Items.Count do
  begin
    aItem := ListView.Items.Add;
    aItem.Caption := HiddenDirectoryListBox.Items.Strings[I];
    aItem.ImageIndex := 0;
    I := I + 1;
  end;
  //Load File Items
  HiddenFileListBox.Directory := aDir;
  I := 0;
  While I < HiddenFileListBox.Items.Count do
  begin
    aItem := ListView.Items.Add;
    aItem.Caption := HiddenFileListBox.Items.Strings[I];
    aItem.ImageIndex := 1;
    I := I + 1;
  end;
end;

procedure TMainForm.FormDestroy(Sender: TObject);
begin
  PreviousLocationList.Free;
end;

procedure TMainForm.ListViewSelectItem(Sender: TObject; Item: TListItem;
  Selected: Boolean);
begin
  if Item.ImageIndex = 1 then
  begin
    edFileName.Text := Item.Caption;
    SelectedFolder := '';
  end else
    SelectedFolder := Item.Caption;
end;


procedure TMainForm.ListViewDblClick(Sender: TObject);
begin
  OpenFolder;
end;

procedure TMainForm.sbBackClick(Sender: TObject);
var
  aLocation: String;
begin
  aLocation := PreviousLocationList.Strings[PreviousLocationList.Count-1];
  PreviousLocationList.Delete(PreviousLocationList.Count-1);
  if PreviousLocationList.Count = 0 then
    sbBack.Enabled := False;
  LoadListView(aLocation, False);
end;

procedure TMainForm.sbUpClick(Sender: TObject);
var
  I: Integer;
  vPos: Integer;
  vDir: String;
begin
  I := Length(CurrentLocation) - 1;
  vDir := '';
  While I > 0 do
  begin
    if CurrentLocation[I] = '\' then
    begin
      vPos := I;
      vDir := IncludeTrailingBackslash(Copy(CurrentLocation,1,vPos));
      I := 0;
    end;
    I := I - 1;
  end;
  if DirectoryExists(vDir) then
  LoadListView(vDir, True);
end;

procedure TMainForm.OpenFolder;
begin
  if SelectedFolder <> '' then
    LoadListView(IncludeTrailingBackslash(IncludeTrailingBackslash(CurrentLocation) + SelectedFolder), True);

end;

procedure TMainForm.sbNewClick(Sender: TObject);
var
  I: Integer;
  vName, vDir, vFolder: string;
begin
  I := 1;
  vFolder := 'New Folder';
  While DirectoryExists(CurrentLocation+vFolder) do
  begin
    I := I + 1;
    vFolder := 'New Folder ('+Inttostr(I)+')';
  end;
  ForceDirectories(CurrentLocation+vFolder);
  aItem := ListView.Items.Add;
  aItem.Caption := vFolder;
  aItem.ImageIndex := 0;
  aItem.EditCaption;

end;

procedure TMainForm.ListViewKeyPress(Sender: TObject; var Key: Char);
begin
  if Key = #13 then
    OpenFolder;

end;

procedure TMainForm.ListViewEdited(Sender: TObject; Item: TListItem;
  var S: String);
var
  vDir: String;
begin
  if DirectoryExists(CurrentLocation+S) then
  begin
    ShowMessage('A file with the name you specified already exists. Specify a different file name.');
    S := Item.Caption;
  end else
  begin
    //rename the Directory
    RenameFile(CurrentLocation+Item.Caption,CurrentLocation+S);
  end;
end;

end.
