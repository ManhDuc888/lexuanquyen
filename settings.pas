unit settings;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, System.Actions, FMX.ActnList, FMX.TabControl,
  FMX.Objects, FMX.Layouts, FMX.Effects, FMX.Filter.Effects;

type
  TFrameSettings = class(TFrame)
    ButtonBack: TButton;
    ButtonLogout: TButton;
    ButtonUser2: TButton;
    ButtonPlan: TButton;
    ButtonChangePassword: TButton;
    ButtonSetDevice: TButton;
    Image2: TImage;
    Label2: TLabel;
    Image1: TImage;
    Label1: TLabel;
    Image3: TImage;
    Label3: TLabel;
    Image4: TImage;
    Label4: TLabel;
    Image5: TImage;
    Label5: TLabel;
    Rectangle1: TRectangle;
    FlowLayout1: TFlowLayout;
    FlowLayout2: TFlowLayout;
    Label6: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
