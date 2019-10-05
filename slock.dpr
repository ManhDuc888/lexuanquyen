program slock;

uses
  System.StartUpCopy,
  System.SysUtils,
  FMX.Forms,
  FMX.Dialogs,
  Classes,
  System.Net.HttpClient,
  Main in 'Main.pas' {FormSlock},
  login in 'login.pas' {FrameLogin: TFrame},
  controldevice in 'controldevice.pas' {FrameControlDevice: TFrame},
  log in 'log.pas' {FrameLog: TFrame},
  settings in 'settings.pas' {FrameSettings: TFrame},
  ThreadUpdateAPI in 'ThreadUpdateAPI.pas',
  jsonadapter in 'jsonadapter.pas',
  plan in 'plan.pas' {FramePlan: TFrame},
  user2 in 'user2.pas' {FrameUser2Aks: TFrame},
  combinedlogin in 'combinedlogin.pas' {FrameCombinedLogin: TFrame},
  offline in 'offline.pas' {FormOffline},
  setdevice in 'setdevice.pas' {FrameSetDevice: TFrame};

{$R *.res}

function CheckInternetIosAks(): Boolean;
begin
  Result := false;
  with THTTPClient.Create do
    try
      try
        Result := Head('https://www.google.com/').StatusCode < 400;
      except
      end;
    finally
      Free;
    end;
end;

begin
  Application.Initialize;
  // ShowMessage(BoolToStr(CheckInternetIosAks()));
  if (BoolToStr(CheckInternetIosAks()) = '-1') then

    Application.CreateForm(TFormSlock, FormSlock)
  else
    Application.CreateForm(TFormOffline, FormOffline);
  // Application.CreateForm(InstanceClass, FormReference);
  Application.Run;

end.
Application.CreateForm(TFormSlock, FormSlock);

Application.CreateForm(TFormSlock, FormSlock);

Application.CreateForm(TFormSlock, FormSlock);

Application.CreateForm(TFormSlock, FormSlock);

Application.CreateForm(TFormSlock, FormSlock);

