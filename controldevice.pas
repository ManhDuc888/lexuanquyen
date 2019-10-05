unit controldevice;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.Controls.Presentation, FMX.Layouts, FMX.Objects;

type
  TFrameControlDevice = class(TFrame)
    ButtonLock: TButton;
    ButtonUnlock: TButton;
    ButtonSecurity: TButton;
    ButtonWhistle: TButton;
    ButtonProfile: TButton;
    ButtonHistory: TButton;
    ButtonHome: TButton;
    LayoutAction: TLayout;
    ButtonDisArm: TButton;
    Image1: TImage;
    Label1: TLabel;
    Image2: TImage;
    Label2: TLabel;
    Image3: TImage;
    Label3: TLabel;
    FlowLayout1: TFlowLayout;
    Image4: TImage;
    Label4: TLabel;
    Image5: TImage;
    Label5: TLabel;
    Image6: TImage;
    Label6: TLabel;
    Image7: TImage;
    Label7: TLabel;
    Image8: TImage;
    Label8: TLabel;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
