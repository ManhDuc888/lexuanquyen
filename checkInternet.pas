unit checkInternet;

interface

implementation

uses
  System.Net.HttpClient;
{$R *.fmx}
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
end.
