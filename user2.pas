unit user2;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes, System.Variants, 
  FMX.Types, FMX.Graphics, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.StdCtrls,
  FMX.TabControl, FMX.Controls.Presentation, FMX.Edit, FMX.Layouts, FMX.ListBox,
  FMX.ListView.Types, FMX.ListView.Appearances, FMX.ListView.Adapters.Base,
  FMX.ListView;

type
  TFrameUser2Aks = class(TFrame)
    EditNameUser2Login: TEdit;
    Label1: TLabel;
    EditUser2FullName: TEdit;
    Label2: TLabel;
    ButtonCreateUser2: TButton;
    ButtonBack: TButton;
    ListViewUser2: TListView;
    Label3: TLabel;
    ButtonDeleteUser2: TButton;
  private
    { Private declarations }
  public
    { Public declarations }
  end;

implementation

{$R *.fmx}

end.
