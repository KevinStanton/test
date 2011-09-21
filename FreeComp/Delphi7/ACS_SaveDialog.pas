//************************************************************************//
//   Created by: Kevin Stanton - Senior Programmer Analyst                //
//   Created on: 12/22/2006                                               //
//   Purpose: This component was created to work with IDS.                //
//     The standard save dialog does not work properly over IDS,          //
//     so this mimics the save dialog, while maintaining functionality.   //
//     Set the flag "UseStandard" to false to show my savedialog instead  //
//     of the standard save dialog.                                       //
//                                                                        //
//   Please do not change this file. If a change is need,                 //
//   let me know and I will update it.                                    //
//   Doing this will ensure consistency between projects.                 //
//************************************************************************//
unit ACS_SaveDialog;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls, Forms, ExtCtrls,
  xMainForm, Dialogs;

type
	TACS_SaveDialog = class(TComponent)
  protected
  private
    FUseStandard: Boolean;
    FFilterIndex: Integer;
    FFileName: String;
    FFilter: String;
    FInitialDir: String;
    procedure SetFileName(const Value: String);
    procedure SetFilter(const Value: String);
    procedure SetFilterIndex(const Value: Integer);
    procedure SetInitialDir(const Value: String);
    procedure SetUseStandard(const Value: Boolean);
  public
    function Execute: Boolean;
  published
    property FileName: String read FFileName write SetFileName;
    property Filter: String read FFilter write SetFilter;
    property FilterIndex: Integer read FFilterIndex write SetFilterIndex;
    property InitialDir: String read FInitialDir write SetInitialDir;
    property UseStandard: Boolean read FUseStandard write SetUseStandard default TRUE;
  end;

implementation

{ TACS_SaveDialog }

function TACS_SaveDialog.Execute: Boolean;
var
  aStandardDialog: TSaveDialog;
  aIDSDialog: TMainForm;
begin
  Result := False;
  if UseStandard then
  begin
    aStandardDialog := TSaveDialog.Create(nil);
    try
      if aStandardDialog.Execute then
      begin
        FileName := aStandardDialog.FileName;
      end;
    finally
      aStandardDialog.Free;
    end;
  end else
  begin
    aIDSDialog := TMainForm.Create(nil);
    try
      aIDSDialog.ShowModal;
      if aIDSDialog.ModalResult = mrOK then
      begin
        FileName := aIDSDialog.CurrentLocation + aIDSDialog.edFileName.Text;
        Result := True;
      end;
    finally
      aIDSDialog.Free;
    end;
  end;
end;

procedure TACS_SaveDialog.SetFileName(const Value: String);
begin
  FFileName := Value;
end;

procedure TACS_SaveDialog.SetFilter(const Value: String);
begin
  FFilter := Value;
end;

procedure TACS_SaveDialog.SetFilterIndex(const Value: Integer);
begin
  FFilterIndex := Value;
end;

procedure TACS_SaveDialog.SetInitialDir(const Value: String);
begin
  FInitialDir := Value;
end;

procedure TACS_SaveDialog.SetUseStandard(const Value: Boolean);
begin
  FUseStandard := Value;
end;

end.
