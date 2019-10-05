unit setdevice;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.ListBox;

type
  TFrameSetDevice = class(TFrame)
    LabelMac: TLabel;
    Label1: TLabel;
    ComboBoxMac: TComboBox;
    ComboBoxUser2: TComboBox;
    ButtonSetDevice: TButton;
    ButtonSetDeviceBack: TButton;
    CheckBoxArm: TCheckBox;
    CheckBoxDisarm: TCheckBox;
    CheckBoxLock: TCheckBox;
    CheckBoxUnlock: TCheckBox;
    CheckBoxHorn: TCheckBox;
    ButtonRemoveDevice: TButton;
    Label2: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
