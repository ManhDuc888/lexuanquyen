unit ThreadUpdateAPI;

interface
uses System.Types, System.SysUtils, System.Classes,REST.Client,System.JSON,FMX.Dialogs;
type
 APIEngineEx = class(Exception);
 APIEngine = class
 private
      type
      TThreadAPI = class(TThread)
      aAPIEngine: APIEngine;
      status: UnicodeString;
       N: Integer;
      protected
        procedure UpdateGeneration;
        procedure Execute; override;
      public

        constructor Create(apiEngine: APIEngine);
      end;

private
  threadapi : TThreadAPI;
  FOnUpdate: TNotifyEvent;
  requestengine: TRESTRequest;
  responseengine:TRESTResponse;
  procedure DoUpdate;
  function GetRunning: Boolean;

public
  statuslabel : UnicodeString;
  jsonResponse: UnicodeString;
  constructor Create(request: TRESTRequest; response: TRESTResponse);
  destructor Destroy; override;
  procedure Clear;
  property OnUpdate: TNotifyEvent read FOnUpdate write FOnUpdate;
  procedure Start;
  procedure Stop;
  property Running: Boolean read GetRunning;

 end;
 implementation
   uses
    System.Threading;
constructor APIEngine.Create(request: TRESTRequest; response: TRESTResponse);
begin
  inherited Create;
  requestengine:= request;
  responseengine:=response;
  Clear;
end;
destructor APIEngine.Destroy;
begin

  inherited;
end;
procedure APIEngine.Clear;

begin
  if Running then
    raise APIEngineEx.Create('Cannot clear life board while running');

end;
procedure APIEngine.DoUpdate;
begin
  if Assigned(FOnUpdate) then
    FOnUpdate(Self);
end;
function APIEngine.GetRunning: Boolean;
begin
  Result := threadapi <> nil;
end;
procedure APIEngine.Start;
begin
  if not Running then
  begin
    threadapi := TThreadAPI.Create(Self);
    threadapi.Start;
  end else
    raise APIEngineEx.Create('Life Engine is already running');
end;
procedure APIEngine.Stop;
begin
  if Running then
    FreeAndNil(threadapi)
  else
    raise APIEngineEx.Create('Life Engine is not running');
end;

// phan thread
constructor APIEngine.TThreadAPI.Create(apiengine: APIEngine);
begin
  inherited Create(True);
  aAPIEngine := apiengine;
end;

procedure APIEngine.TThreadAPI.Execute;
begin
  NameThreadForDebugging('Life Thread');
  while not Terminated do
  begin
      N := N+1;
      aAPIEngine.requestengine.Execute();
      Sleep(1000);
      Synchronize(UpdateGeneration);
  end;
end;
procedure APIEngine.TThreadAPI.UpdateGeneration;
var
value: UnicodeString;
begin

  aAPIEngine.statuslabel := IntToStr(N);
  value:= aAPIEngine.responseengine.JSONText;
  //(value.ToString());
  aAPIEngine.jsonResponse:= value;
  //ShowMessage(value);
  aAPIEngine.DoUpdate();
end;
end.
