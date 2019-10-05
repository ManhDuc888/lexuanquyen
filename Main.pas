unit Main;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Classes,
  System.Variants, REST.Client, REST.Types, System.IOUtils,
  FMX.ListView.Appearances,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Graphics, System.Hash, System.JSON,
  FMX.Dialogs, login, controldevice, FMX.Controls.Presentation, FMX.StdCtrls,
  System.Math.Vectors, FMX.Layouts, FMX.Controls3D, FMX.Layers3D, log,
  ThreadUpdateAPI, settings, user2, FMX.ListBox, System.Rtti, combinedlogin,
  FMX.Edit, FMX.ComboEdit, System.IniFiles, setdevice, plan;

type
  APIInfoLogin = class(TFMXObject)
  public
    Token: UnicodeString;
    AllNameDevice: TStringList;
    ListMac: TStringList;
    NameListUser2: TStringList;
    MacName: TJSONObject;
    AuthorName: UnicodeString; // gia tri nay cos the la Customer, User2
    MacOnline: TJSONObject;
    NameActivateDevice, MacActivate: UnicodeString;
    // trang thai
    codereturn: UnicodeString;
    StatusARM: UnicodeString;
    StatusDISARM: UnicodeString;
    SatatusLOCK: UnicodeString;
    StatusUNLOCK: UnicodeString;
    StatusHORN: UnicodeString;
    StatusOnline: UnicodeString;
    NameLogin: UnicodeString;
    IsUser2: UnicodeString;
    User, Passmd5: UnicodeString;
  end;

  TFormSlock = class(TForm)
    TFrameLoginAks: TFrameLogin;
    TFrameControlDeviceAks: TFrameControlDevice;
    ButtonDevice1: TButton;
    ButtonDevice2: TButton;
    ButtonDevice3: TButton;
    LayoutListDevice: TLayout;
    TFrameSettingsAks: TFrameSettings;
    LayoutStatusDevice: TLayout;
    LabelLock: TLabel;
    LabelUnlock: TLabel;
    LabelHorn: TLabel;
    LabelDisarm: TLabel;
    LabelARM: TLabel;
    TFrameLogAks: TFrameLog;
    TFrameUser2AksCDConfig: TFrameUser2Aks;
    StyleBookAks: TStyleBook;
    TFrameCombinedLoginAks: TFrameCombinedLogin;
    TFrameSetDeviceAks: TFrameSetDevice;
    TFramePlanAks: TFramePlan;
    CopperDarkStyleBook: TStyleBook;

    procedure TFrameLogin1ButtonLoginClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonDevice1Click(Sender: TObject);
    procedure TFrameControlDeviceAksButtonLockClick(Sender: TObject);
    procedure TFrameControlDeviceAksButtonSecurityClick(Sender: TObject);
    procedure TFrameControlDeviceAksButtonUnlockClick(Sender: TObject);
    procedure TFrameControlDeviceAksButtonWhistleClick(Sender: TObject);
    procedure ButtonDevice2Click(Sender: TObject);
    procedure ButtonDevice3Click(Sender: TObject);
    procedure TFrameControlDeviceAksButtonHistoryClick(Sender: TObject);
    procedure TFrameControlDeviceAksButtonHomeClick(Sender: TObject);
    procedure TFrameControlDeviceAksButtonProfileClick(Sender: TObject);
    procedure TFrameControlDeviceAksButtonDISARMClick(Sender: TObject);
    procedure TFrameSettingsAksLabelLogoutClick(Sender: TObject);
    procedure TFrameSettingsAksButtonLogoutClick(Sender: TObject);
    procedure TFrameSettingsAksButtonUser2Click(Sender: TObject);
    procedure TFrameUser2AksCDConfigButtonCreateUser2Click(Sender: TObject);
    procedure LabelCombinedLoginClick(Sender: TObject);
    procedure CornerButtonCombinedLoginClick(Sender: TObject);
    procedure TFrameCombinedLoginAksButtonLoginClick(Sender: TObject);
    procedure TFrameCombinedLoginAksButtonOtherLoginClick(Sender: TObject);
    procedure TFrameUser2AksCDConfigButtonBackClick(Sender: TObject);
    procedure TFrameUser2AksCDConfigButtonDeleteUser2Click(Sender: TObject);
    procedure TFrameSettingsAksButtonBackClick(Sender: TObject);
    procedure TFrameLogAksButtonBackClick(Sender: TObject);
    procedure TFrameSetDeviceAksButtonSetDeviceBackClick(Sender: TObject);
    procedure TFrameSettingsAksButtonSetDeviceClick(Sender: TObject);
    procedure TFrameSetDeviceAksButtonSetDeviceClick(Sender: TObject);
    procedure TFrameControlDeviceAksButton1Click(Sender: TObject);
    procedure TFrameSetDeviceAksButtonRemoveDeviceClick(Sender: TObject);
    procedure TFrameSettingsAksButtonPlanClick(Sender: TObject);
    procedure TFramePlanAksButtonBackClick(Sender: TObject);
    procedure TFramePlanAksButtonSetupPlanClick(Sender: TObject);
    procedure TFramePlanAksComboBoxHTh8Change(Sender: TObject);

  private
    { Private declarations }
    aAPIInfoLogin: APIInfoLogin;
    // cap nhat trang thai
    aEngineAPI: APIEngine;
    statuslabeltest: UnicodeString;
    StatusResquest: TRESTRequest;
    StatusResponse: TRESTResponse;
    StatusClient: TRESTClient;
    DataFilePath: String;

    function AksLogin(User: UnicodeString; pass: UnicodeString): Boolean;
    procedure SetStage(Stage: Integer);
    procedure GetNameDeviceList();
    procedure ActionCommand(name: UnicodeString; command: UnicodeString);
    procedure UpDateStatusApp(response: UnicodeString;
      nameDeviceActivate: UnicodeString);
    procedure UpDateStatusAppAfterCommand(response: UnicodeString);
    function DeviceOnline(namedevice: UnicodeString): UnicodeString;
    procedure APIEngineUpdate(Sender: TObject);
    // procedure DoInfoClick(Sender: TObject);
    procedure DoVisibleChange(Sender: TObject);
    procedure AccountUser2();
    procedure RemoveAccountUser2(loginname: UnicodeString);
    procedure LoadSettings();
    procedure SaveSettings(User: UnicodeString; pass: UnicodeString);
    // procedure IsUser2();

  public
    { Public declarations }
    SettingsFilePath: UnicodeString;

  end;

const
  AKS_LOGIN = 0;
  AKS_MENU = 1;
  AKS_LOGIN_SUCCESS = 2;
  AKS_BUTTON_CONTROL = 3;
  AKS_BUTTON_HISTORY = 4;
  AKS_BUTTON_SETTINGS = 5;
  AKS_BUTTON_LOGOUT = 6;
  AKS_BUTTON_CREATE_DELETE_CONFIG = 7;
  AKS_BUTTON_BACK_CREATE_DELETE_CONFIG = 8;
  AKS_BUTTON_CREATE_SET_DEVICE = 9;
  AKS_BUTTON_BACK_CREATE_SET_DEVICE = 10;
  AKS_BUTTON_CREATE_PLAN = 11;
  AKS_BUTTON_BACK_PLAN = 12;

var
  FormSlock: TFormSlock;
  loginok: Boolean;
  // client: TRESTClient;
  // request: TRESTRequest;
  // response: TRESTResponse;

implementation

{$R *.fmx}
{$R *.iPhone4in.fmx IOS}

procedure TFormSlock.SetStage(Stage: Integer);
begin
  case Stage of
    AKS_LOGIN_SUCCESS:
      begin
        TFrameControlDeviceAks.Visible := True;
        LayoutStatusDevice.Visible := True;
        LayoutListDevice.Visible := True;
        TFrameControlDeviceAks.LayoutAction.Visible := True;
        TFrameLoginAks.Visible := False;
        TFrameLogAks.Visible := False;
        TFrameSettingsAks.Visible := False;

      end;
    AKS_LOGIN:
      begin
        TFrameControlDeviceAks.Visible := False;
        TFrameLoginAks.Visible := True;
        LayoutStatusDevice.Visible := False;
        TFrameSettingsAks.Visible := False;
        TFrameCombinedLoginAks.Visible := False;

      end;
    AKS_BUTTON_CONTROL:
      begin
        TFrameControlDeviceAks.Visible := False;
        TFrameLoginAks.Visible := False;
        LayoutStatusDevice.Visible := True;
        TFrameCombinedLoginAks.Visible := True;

      end;
    AKS_BUTTON_HISTORY:
      begin
        // TFrameControlDeviceAks.Visible := False;
        TFrameControlDeviceAks.LayoutAction.Visible := False;
        TFrameLogAks.Visible := True;
        TFrameSettingsAks.Visible := False;
        LayoutStatusDevice.Visible := False;
        TFrameControlDeviceAks.Visible := False;
        TFrameUser2AksCDConfig.Visible := False;
        TFrameCombinedLoginAks.Visible := False;
        // TFrameControlDeviceAks.

      end;
    AKS_BUTTON_SETTINGS:
      begin
        TFrameControlDeviceAks.Visible := False;
        TFrameLogAks.Visible := False;
        TFrameSettingsAks.Visible := True;
        LayoutStatusDevice.Visible := False;
        TFrameControlDeviceAks.Visible := False;
        LayoutListDevice.Visible := False;
        // TFrameUser2AksCDConfig.Visible := False;
      end;
    AKS_BUTTON_LOGOUT:
      begin
        TFrameControlDeviceAks.Visible := False;
        TFrameLoginAks.Visible := True;
        LayoutStatusDevice.Visible := False;
        TFrameSettingsAks.Visible := False;
        ButtonDevice1.Visible := False;
        ButtonDevice2.Visible := False;
        ButtonDevice3.Visible := False;
      end;
    AKS_BUTTON_CREATE_DELETE_CONFIG:
      begin
        TFrameControlDeviceAks.Visible := False;
        // TFrameLoginAks.Visible := True;
        LayoutStatusDevice.Visible := False;
        TFrameSettingsAks.Visible := False;
        TFrameUser2AksCDConfig.Visible := True;
        LayoutListDevice.Visible := False;
        // ButtonDevice1.Visible:=False;
        // ButtonDevice2.Visible:=False;
        // ButtonDevice3.Visible:=False;
      end;
    AKS_BUTTON_BACK_CREATE_DELETE_CONFIG:
      begin
        LayoutStatusDevice.Visible := True;

        TFrameUser2AksCDConfig.Visible := False;
        LayoutListDevice.Visible := True;
        TFrameControlDeviceAks.Visible := True;
        TFrameControlDeviceAks.LayoutAction.Visible := True;
        TFrameCombinedLoginAks.Visible := True;
        TFrameSettingsAks.Visible := False;
        TFrameLogAks.Visible := False;
      end;
    AKS_BUTTON_BACK_CREATE_SET_DEVICE:
      begin
        LayoutStatusDevice.Visible := True;

        TFrameUser2AksCDConfig.Visible := False;
        LayoutListDevice.Visible := True;
        TFrameControlDeviceAks.Visible := True;
        TFrameControlDeviceAks.LayoutAction.Visible := True;
        TFrameSettingsAks.Visible := False;
        TFrameLogAks.Visible := False;
        TFrameSetDeviceAks.Visible := False;
      end;
    AKS_BUTTON_CREATE_SET_DEVICE:
      begin
        TFrameSetDeviceAks.Visible := True;
        TFrameControlDeviceAks.Visible := False;
        // TFrameLoginAks.Visible := True;
        LayoutStatusDevice.Visible := False;
        TFrameSettingsAks.Visible := False;
        TFrameUser2AksCDConfig.Visible := False;
        LayoutListDevice.Visible := False;
      end;
    AKS_BUTTON_CREATE_PLAN:
      begin
        TFramePlanAks.Visible := True;
        TFrameSetDeviceAks.Visible := False;
        TFrameControlDeviceAks.Visible := False;
        // TFrameLoginAks.Visible := True;
        LayoutStatusDevice.Visible := False;
        TFrameSettingsAks.Visible := False;
        TFrameUser2AksCDConfig.Visible := False;
        LayoutListDevice.Visible := False;
      end;
    AKS_BUTTON_BACK_PLAN:
      begin
        LayoutStatusDevice.Visible := True;

        TFrameUser2AksCDConfig.Visible := False;
        LayoutListDevice.Visible := True;
        TFrameControlDeviceAks.Visible := True;
        TFrameControlDeviceAks.LayoutAction.Visible := True;
        TFrameSettingsAks.Visible := False;
        TFrameLogAks.Visible := False;
        TFrameSetDeviceAks.Visible := False;
        TFramePlanAks.Visible := False;
      end;
  end;
end;

procedure TFormSlock.APIEngineUpdate(Sender: TObject);
begin
  // cap nhat trang thai o day
  statuslabeltest := aEngineAPI.statuslabel;
  // ShowMessage(DeviceOnline(aAPIInfoLogin.NameActivateDevice));
  if DeviceOnline(aAPIInfoLogin.NameActivateDevice) = '"true"' then
  begin
    UpDateStatusApp(aEngineAPI.jsonResponse, aAPIInfoLogin.NameActivateDevice);
    // ShowMessage(aAPIInfoLogin.NameActivateDevice);
    TFrameLogAks.Label1.Text := statuslabeltest;
    if aAPIInfoLogin.SatatusLOCK = 'true' then
    begin
      LabelLock.Visible := True;
      LabelLock.Text := 'Khóa:Đóng';
      LabelUnlock.Visible := False
    end
    else
    begin
      LabelLock.Visible := False;
    end;

    if aAPIInfoLogin.StatusUNLOCK = 'true' then
    begin
      LabelUnlock.Visible := True;
      LabelUnlock.Text := 'Khóa:Mở';
      LabelLock.Visible := False;
    end
    else
    begin
      LabelUnlock.Visible := False;
    end;
    if aAPIInfoLogin.StatusDISARM = 'true' then
    begin
      LabelDisarm.Visible := True;
      LabelDisarm.Text := 'An Ninh:Tắt';
      LabelARM.Visible := False;
    end
    else
    begin
      LabelDisarm.Visible := False;
    end;

    if aAPIInfoLogin.StatusARM = 'true' then
    begin
      LabelARM.Visible := True;
      LabelARM.Text := 'An Ninh:Bật';
      LabelDisarm.Visible := False;
    end
    else
    begin
      LabelARM.Visible := False;
    end;

    if aAPIInfoLogin.StatusHORN = 'true' then
    begin
      LabelHorn.Visible := True;
      LabelHorn.Text := 'Còi:Bật';
    end
    else
    begin
      LabelHorn.Text := 'Còi:Tắt';
    end;
  end
  else
  begin
    // ShowMessage('Người dùng chưa được gán nút điều khiển');
    LayoutStatusDevice.Visible := False;

  end;
end;

procedure TFormSlock.UpDateStatusApp(response: UnicodeString;
  nameDeviceActivate: UnicodeString);
var
  res, partsspins, partspin, statusPins, jsonspin: TJSONObject;
  code, value: TJSONArray;
  i, j: Integer;
  spin, StatusOnline, mac: TJSONArray;
  name, arm, lock, unlock, horn, disarm: TJSONValue;
begin
  res := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(response), 0)
    as TJSONObject;

  try
    code := TJSONArray(res.Get('Code').JsonValue);

    if code.ToString() = '1' then
    begin
      aAPIInfoLogin.codereturn := '1';
      value := TJSONArray(res.Get('Value').JsonValue);
      // ShowMessage(value.ToString());
      for i := 0 to value.Size() - 1 do
      begin
        partsspins := TJSONObject(value.Get(i));
        partspin := TJSONObject.ParseJSONValue
          (TEncoding.ASCII.GetBytes(partsspins.ToString()), 0) as TJSONObject;
        spin := TJSONArray(partspin.Get('Pins').JsonValue);
        StatusOnline := TJSONArray(partspin.Get('Online').JsonValue);
        // ShowMessage(TJSONArray(partspin.Get('Name').JsonValue).ToString());
        // ShowMessage(nameDeviceActivate);
        if TJSONArray(partspin.Get('Name').JsonValue).ToString() = '"' +
          nameDeviceActivate + '"' then
        begin
          // aAPIInfoLogin.NameActivateDevice:= TJSONArray(partspin.Get('Name').JsonValue).ToString();
          // ShowMessage(aAPIInfoLogin.NameActivateDevice);
          mac := TJSONArray(partspin.Get('MAC').JsonValue);
          // ShowMessage(spin.ToString());

          for j := 0 to spin.Size - 1 do
          begin
            statusPins := TJSONObject(spin.Get(j));
            jsonspin := TJSONObject.ParseJSONValue
              (TEncoding.ASCII.GetBytes(statusPins.ToString()), 0)
              as TJSONObject;
            // arm := TJSONValue(res.Get('Name').JsonValue);

            name := TJSONArray(jsonspin.Get('Name').JsonValue);
            if name.ToString() = '"ARM"' then
            begin
              arm := TJSONArray(jsonspin.Get('IsHigh').JsonValue);
              aAPIInfoLogin.StatusARM := arm.ToString();
              // ShowMessage(UnicodeString(arm.ToString()));
            end;
            if name.ToString() = '"DISARM"' then
            begin
              disarm := TJSONArray(jsonspin.Get('IsHigh').JsonValue);
              aAPIInfoLogin.StatusDISARM := disarm.ToString();
            end;

            if name.ToString() = '"LOCK"' then
            begin
              lock := TJSONArray(jsonspin.Get('IsHigh').JsonValue);
              aAPIInfoLogin.SatatusLOCK := lock.ToString();
            end;
            if name.ToString() = '"UNLOCK"' then
            begin
              unlock := TJSONArray(jsonspin.Get('IsHigh').JsonValue);
              aAPIInfoLogin.StatusUNLOCK := unlock.ToString();
            end;
            if name.ToString() = '"HORN"' then
            begin
              horn := TJSONArray(jsonspin.Get('IsHigh').JsonValue);
              aAPIInfoLogin.StatusHORN := horn.ToString();
            end;
          end;
        end;
      end;
    end;

  finally
    res.Free();
  end;
  // ShowMessage(aAPIInfoLogin.StatusHORN);

end;

procedure TFormSlock.FormCreate(Sender: TObject);
begin
  // thread cap nhap
  StatusResquest := TRESTRequest.Create(nil);
  StatusResponse := TRESTResponse.Create(nil);
  StatusClient := TRESTClient.Create(nil);
  aEngineAPI := APIEngine.Create(StatusResquest, StatusResponse);
  aEngineAPI.OnUpdate := APIEngineUpdate;

  aAPIInfoLogin := APIInfoLogin.Create(Self);
  TFrameLoginAks.Visible := True;
  aAPIInfoLogin.AllNameDevice := TStringList.Create();
  aAPIInfoLogin.NameListUser2 := TStringList.Create();
  aAPIInfoLogin.ListMac := TStringList.Create();
  aAPIInfoLogin.MacName := TJSONObject.Create();
  aAPIInfoLogin.MacOnline := TJSONObject.Create();
  aAPIInfoLogin.NameActivateDevice := '';

  aAPIInfoLogin.codereturn := '';
  aAPIInfoLogin.StatusARM := '';
  aAPIInfoLogin.StatusDISARM := '';
  aAPIInfoLogin.SatatusLOCK := '';
  aAPIInfoLogin.StatusUNLOCK := '';
  aAPIInfoLogin.StatusHORN := '';
  aAPIInfoLogin.StatusOnline := '';

  DataFilePath := TPath.GetHomePath() + TPath.DirectorySeparatorChar;
  // ShowMessage(SettingsFilePath);
  // ShowMessage(DataFilePath);
end;

procedure TFormSlock.TFrameCombinedLoginAksButtonLoginClick(Sender: TObject);
var
  IniFile: TMemIniFile;
  User, pass: UnicodeString;
begin
  // doc du lieu setting.ini hien thi
  IniFile := TMemIniFile.Create(DataFilePath + 'Settings.ini');
  // dang online
  if aAPIInfoLogin.AuthorName = 'Customer' then
  begin
    User := IniFile.ReadString('User2', 'user', 'xx');
    pass := IniFile.ReadString('User2', 'pass', 'xx');
    // ShowMessage(User);
    if User <> 'xx' then
    begin
      FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Text :=
        'Chuyển: ' + User;
      FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Visible := True;
    end
    else
      FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Visible := False;

  end;
  if aAPIInfoLogin.AuthorName = 'User2' then
  begin
    User := IniFile.ReadString('Customer', 'user', 'xx');
    pass := IniFile.ReadString('Customer', 'pass', 'xx');
    if User <> 'xx' then
    begin
      FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Text :=
        'Chuyển: ' + User;
      FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Visible := True;
    end
    else
      FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Visible := False;
  end;
  //

end;

procedure TFormSlock.TFrameCombinedLoginAksButtonOtherLoginClick
  (Sender: TObject);
var
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  User, password, str, paramjson: UnicodeString;
  o: TJSONObject;
  a: TJSONArray;
  IniFile: TMemIniFile;
  userini, passini: UnicodeString;
  olderUser, olderPass: UnicodeString;
begin
  if loginok = True then
  begin
    // ShowMessage('dang login');
    Client := TRESTClient.Create(nil);
    request := TRESTRequest.Create(nil);
    response := TRESTResponse.Create(nil);
    request.Client := Client;
    Client.BaseURL := 'http://slock.aks.vn/api/account/logout';
    request.Method := TRESTRequestMethod.rmPOST;
    request.response := response;
    request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    request.AcceptCharset := 'utf-8, *;q=0.8';
    User := TFrameLoginAks.EditName.Text;
    password := THashMD5.GetHashString(User + TFrameLoginAks.EditPassword.Text);
    // ShowMessage(user);
    // ShowMessage(password);
    // paramjson := '{user:"' + user + '",password:"' + password + '"}';
    // request.AddBody(paramjson, ctAPPLICATION_JSON);
    request.AddParameter('token', aAPIInfoLogin.Token);
    // request.AddParameter('password', password);
    request.Execute();
    str := response.JSONText;
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;
    try
      a := TJSONArray(o.Get('Code').JsonValue);
      if a.ToString() = '1' then
      begin
        ShowMessage('Log out thanh cong de login lai !');
        aEngineAPI.Stop();
        IniFile := TMemIniFile.Create(DataFilePath + 'Settings.ini');

        if aAPIInfoLogin.AuthorName = 'Customer' then
        begin
          userini := IniFile.ReadString('User2', 'user', '');
          passini := IniFile.ReadString('User2', 'pass', '');

          if (userini <> '') and (passini <> '') then
            FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Text :=
              'Chuyển: ' + userini
          else
            Exit;
        end;
        if aAPIInfoLogin.AuthorName = 'User2' then
        begin
          userini := IniFile.ReadString('Customer', 'user', '');
          passini := IniFile.ReadString('Customer', 'pass', '');
          if (userini <> '') and (passini <> '') then
            FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Text :=
              'Chuyển: ' + userini
          else
            Exit;
          // lgoin bang tai khoan khác
        end;
        ShowMessage(userini);
        ShowMessage(passini);
        aAPIInfoLogin.ListMac.Clear;
        aAPIInfoLogin.AllNameDevice.Clear;
        aAPIInfoLogin.NameListUser2.Clear;
        aAPIInfoLogin.MacName := TJSONObject.Create();
        aAPIInfoLogin.MacOnline := TJSONObject.Create();
        if FormSlock.aEngineAPI.Running then
          FormSlock.aEngineAPI.Stop();

        if AksLogin(userini, passini) then
        begin
          loginok := True;
          SetStage(AKS_LOGIN_SUCCESS);
          FormSlock.aEngineAPI.Start();
          FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Visible := False;
          FormSlock.TFrameCombinedLoginAks.ButtonLogin.Text :=
            aAPIInfoLogin.NameLogin;
        end
        else
        begin
          aAPIInfoLogin.ListMac.Clear;
          aAPIInfoLogin.AllNameDevice.Clear;
          aAPIInfoLogin.NameListUser2.Clear;
          aAPIInfoLogin.MacName := TJSONObject.Create();
          aAPIInfoLogin.MacOnline := TJSONObject.Create();
          olderUser := TFrameLoginAks.EditName.Text;
          olderPass := TFrameLoginAks.EditPassword.Text;
          // ShowMessage(user);
          // ShowMessage(pass);
          if FormSlock.aEngineAPI.Running then
            FormSlock.aEngineAPI.Stop();

          if AksLogin(olderUser, olderPass) then
          begin
            loginok := True;
            SetStage(AKS_LOGIN_SUCCESS);
            FormSlock.aEngineAPI.Start();
            ShowMessage('Login lai tai khoan cu');
            FormSlock.TFrameCombinedLoginAks.ButtonOtherLogin.Visible := False;
          end
          else
            SetStage(AKS_LOGIN);
        end;
        // loginok:=False;
        // SetStage(AKS_BUTTON_LOGOUT);
      end
      else
        ShowMessage('Khong the log out de login');

    finally
      o.Free;
    end;
    // ShowMessage(str);

  end
  else
  begin
    ShowMessage('Chưa chuyen login');
    Exit;
  end;
  // aAPIInfoLogin.AllNameDevice.Clear;
  // FormSlock.aEngineAPI.Stop();
  // aAPIInfoLogin.Free;
  // loginok := False;

end;

procedure TFormSlock.TFrameControlDeviceAksButton1Click(Sender: TObject);
var
  command: UnicodeString;
begin
  command := '#FA1;#AL+CLEAR;#AL+ARM=0;#FA0;#AL+OUTPUT=1,1;';
  ActionCommand(aAPIInfoLogin.NameActivateDevice, command);
  // TFrameControlDeviceAks.ButtonLock;
  // ShowMessage('Hoạt động thành công!');

end;

procedure TFormSlock.TFrameControlDeviceAksButtonDISARMClick(Sender: TObject);
var
  command: UnicodeString;
begin
  command := '#FA1;#AL+CLEAR;#AL+ARM=0;#FA0;#AL+OUTPUT=1,1;';
  ActionCommand(aAPIInfoLogin.NameActivateDevice, command);
  // TFrameControlDeviceAks.ButtonLock;
  // ShowMessage('Hoạt động thành công!');

end;

procedure TFormSlock.TFrameControlDeviceAksButtonHistoryClick(Sender: TObject);
var
  aTString: TStrings;
  str: UnicodeString;
  o: TJSONObject;
  a, value, name, logs, online: TJSONArray;
  ovalue, timelog, jNameMac: TJSONObject;
  jValue, jName: TJSONValue;
  idx: Integer;
  idy: Integer;
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  url: UnicodeString;
  i, j: Integer;
  test: TJSONArray;

begin
  aTString := TStringList.Create();
  Client := TRESTClient.Create(nil);
  request := TRESTRequest.Create(nil);
  response := TRESTResponse.Create(nil);
  request.Client := Client;
  Client.BaseURL := 'http://slock.aks.vn/api/customer/log';
  request.Method := TRESTRequestMethod.rmPOST;
  request.response := response;
  request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  request.AcceptCharset := 'utf-8, *;q=0.8';
  // ShowMessage(aAPIInfoLogin.Token);
  request.AddParameter('token', aAPIInfoLogin.Token);
  request.Execute();
  str := response.JSONText;
  // ShowMessage(str);
  o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
    as TJSONObject;
  // ShowMessage(str);
  try
    value := TJSONArray(o.Get('Value').JsonValue);
    if (value.ToString() <> '{}') and (value.ToString() <> 'null') then
    begin
      jNameMac := TJSONObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(value.ToString()), 0) as TJSONObject;
      // ShowMessage(aAPIInfoLogin.MacActivate);
      jName := TJSONArray(jNameMac.Get(aAPIInfoLogin.MacActivate.Substring(1,
        aAPIInfoLogin.MacActivate.Length - 2)).JsonValue);
      ovalue := TJSONObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(jName.ToString()), 0) as TJSONObject;
      logs := TJSONArray(ovalue.Get('Logs').JsonValue);
      for j := 0 to logs.Size - 1 do
      begin
        timelog := TJSONObject(logs.Get(j));
        if j = 0 then
          aTString.Add('[' + LowerCase(timelog.ToString()))
        else if j = (logs.Size - 1) then
          aTString.Add(',' + LowerCase(timelog.ToString()) + ']')
        else
          aTString.Add(',' + LowerCase(timelog.ToString()));
      end;
    end
    else
    begin
      ShowMessage('Không có log');
      Exit;
    end;
  finally
    value.Free;
  end;
  // ShowMessage(aTString.Text);
  // viet su kien hien log o day
  // aTString := TStringList.Create();

  // aTString.Add
  // ('[{"time": "2019-09-21T21:03:28.706+07:00","action": "khoa","actor": "Quyen"}]');
  // TFrameLogAks.Memo1.Text:=aTString.Text;
  TFrameLogAks.JSONDatasetAdapter1.JSON := aTString;
  SetStage(AKS_BUTTON_HISTORY);

end;

procedure TFormSlock.TFrameControlDeviceAksButtonHomeClick(Sender: TObject);
begin
  // tro ve trang thai luc dau
  SetStage(AKS_LOGIN_SUCCESS);
end;

procedure TFormSlock.TFrameControlDeviceAksButtonLockClick(Sender: TObject);
var
  command: UnicodeString;
begin
  command := '#AL+OUTPUT=1,0;';
  ActionCommand(aAPIInfoLogin.NameActivateDevice, command);
  // TFrameControlDeviceAks.ButtonLock;
  // ShowMessage('Hoạt động thành công!');

end;

procedure TFormSlock.TFrameControlDeviceAksButtonProfileClick(Sender: TObject);
begin
  // hien thi Frame cai dat o day.
  SetStage(AKS_BUTTON_SETTINGS);
end;

procedure TFormSlock.TFrameControlDeviceAksButtonSecurityClick(Sender: TObject);
var
  command: UnicodeString;
begin
  command := '#AL+ARM=1;';
  ActionCommand(aAPIInfoLogin.NameActivateDevice, command);
  // ShowMessage('Hoạt động thành công!');
end;

procedure TFormSlock.TFrameControlDeviceAksButtonUnlockClick(Sender: TObject);
var
  command: UnicodeString;
begin
  command := '#AL+OUTPUT=1,1;';
  ActionCommand(aAPIInfoLogin.NameActivateDevice, command);
  // ShowMessage('Hoạt động thành công!');
end;

procedure TFormSlock.TFrameControlDeviceAksButtonWhistleClick(Sender: TObject);
var
  command: UnicodeString;
begin
  command := '#AL+OUTPUT=4,T;';
  ActionCommand(aAPIInfoLogin.NameActivateDevice, command);
  // ShowMessage('Hoạt động thành công!');
end;

procedure TFormSlock.TFrameLogAksButtonBackClick(Sender: TObject);
begin
  SetStage(AKS_BUTTON_BACK_CREATE_DELETE_CONFIG);

end;

procedure TFormSlock.TFrameLogin1ButtonLoginClick(Sender: TObject);
var
  User: UnicodeString;
  pass: UnicodeString;
  success: Boolean;
begin
  SetStage(AKS_LOGIN);
  User := TFrameLoginAks.EditName.Text;
  pass := TFrameLoginAks.EditPassword.Text;
  // ShowMessage(user);
  // ShowMessage(pass);
  if AksLogin(User, pass) then
  // ShowMessage(' Đăng nhập thành công !')

  begin
    SetStage(AKS_LOGIN_SUCCESS);
    loginok := True;
    StatusResquest.Client := StatusClient;
    StatusClient.BaseURL := 'http://slock.aks.vn/api/' +
      aAPIInfoLogin.AuthorName + '/GetAllDevices';
    StatusResquest.Method := TRESTRequestMethod.rmPOST;
    StatusResquest.response := StatusResponse;
    StatusResquest.Accept :=
      'application/json, text/plain; q=0.9, text/html;q=0.8,';
    StatusResquest.AcceptCharset := 'utf-8, *;q=0.8';
    // ShowMessage(aAPIInfoLogin.Token);
    StatusResquest.AddParameter('token', aAPIInfoLogin.Token);
    // ShowMessage('Token de updae ' + aAPIInfoLogin.Token);
    StatusResquest.AddParameter('stringData', 'false');
    aEngineAPI.Start;
    SetStage(AKS_BUTTON_CONTROL);
    FormSlock.TFrameCombinedLoginAks.ButtonLogin.Text :=
      aAPIInfoLogin.NameLogin;
    aAPIInfoLogin.NameActivateDevice := aAPIInfoLogin.AllNameDevice[0];

    if DeviceOnline(aAPIInfoLogin.NameActivateDevice) <> '"true"' then
      LayoutStatusDevice.Visible := False;

  end
  else
  begin
    ShowMessage('Đăng nhập không thành công');
    SetStage(AKS_LOGIN);
  end;

end;

procedure TFormSlock.TFramePlanAksButtonBackClick(Sender: TObject);
begin
  SetStage(AKS_BUTTON_BACK_PLAN);
end;

procedure TFormSlock.TFramePlanAksButtonSetupPlanClick(Sender: TObject);
var
  mac, str, paramjson, username: UnicodeString;
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  a: TJSONArray;
  o: TJSONObject;
  loginname, plan: UnicodeString;
  scn, st2, st3, st4, st5, st6, st7: UnicodeString;

  scn2, st22, st32, st42, st52, st62, st72: UnicodeString;

begin
  // thiet lap plan.
  if loginok = True then
  begin
    loginname := TFramePlanAks.ComboBoxListUser2.Selected.Text;
    plan := '';
    if (TFramePlanAks.ComboBoxHTh8.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh8.Selected.Text <> '-2') then
    begin
      scn := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh8.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh8.Selected.Text));

    end
    else
    begin
      scn := TFramePlanAks.ComboBoxHTh8.Selected.Text;

    end;

    if (TFramePlanAks.ComboBoxHTh8Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh8Stop.Selected.Text <> '-2') then
      scn2 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh8Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh8Stop.Selected.Text))
    else
      scn2 := TFramePlanAks.ComboBoxHTh8Stop.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh2.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh2.Selected.Text <> '-2') then
      st2 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh2.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh2.Selected.Text))
    else
      st2 := TFramePlanAks.ComboBoxHTh2.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh2Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh2Stop.Selected.Text <> '-2') then
      st22 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh2Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh2Stop.Selected.Text))
    else
      st22 := TFramePlanAks.ComboBoxHTh2Stop.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh3.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh3.Selected.Text <> '-2') then
      st3 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh3.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh3.Selected.Text))
    else
      st3 := TFramePlanAks.ComboBoxHTh3.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh3Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh3Stop.Selected.Text <> '-2') then
      st32 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh3Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh3Stop.Selected.Text))
    else
      st32 := TFramePlanAks.ComboBoxHTh2Stop.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh4.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh4.Selected.Text <> '-2') then
      st4 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh4.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh4.Selected.Text))
    else
      st4 := TFramePlanAks.ComboBoxHTh4.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh4Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh4Stop.Selected.Text <> '-2') then
      st42 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh4Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh4Stop.Selected.Text))
    else
      st42 := TFramePlanAks.ComboBoxHTh4Stop.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh5.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh5.Selected.Text <> '-2') then
      st5 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh5.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh5.Selected.Text))
    else
      st5 := TFramePlanAks.ComboBoxHTh5.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh5Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh5Stop.Selected.Text <> '-2') then
      st52 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh5Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh5Stop.Selected.Text))
    else
      st52 := TFramePlanAks.ComboBoxHTh5Stop.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh6.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh6.Selected.Text <> '-2') then
      st6 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh6.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh6.Selected.Text))
    else
      st6 := TFramePlanAks.ComboBoxHTh6.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh6Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh6Stop.Selected.Text <> '-2') then
      st62 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh6Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh6Stop.Selected.Text))
    else
      st62 := TFramePlanAks.ComboBoxHTh6Stop.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh7.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh7.Selected.Text <> '-2') then
      st7 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh7.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh7.Selected.Text))
    else
      st7 := TFramePlanAks.ComboBoxHTh7.Selected.Text;

    if (TFramePlanAks.ComboBoxHTh7Stop.Selected.Text <> '-1') AND
      (TFramePlanAks.ComboBoxHTh7Stop.Selected.Text <> '-2') then
      st72 := System.SysUtils.IntToStr
        (StrToInt(TFramePlanAks.ComboBoxHTh7Stop.Selected.Text) * 100 +
        StrToInt(TFramePlanAks.ComboBoxMTh7Stop.Selected.Text))
    else
      st72 := TFramePlanAks.ComboBoxHTh7Stop.Selected.Text;

    plan := scn + ',' + scn2 + ',' + st2 + ',' + st22 + ',' + st3 + ',' + st32 +
      ',' + st4 + ',' + st42 + ',' + st5 + ',' + st52 + ',' + st6 + ',' + st62 +
      ',' + st7 + ',' + st72;

    Client := TRESTClient.Create(nil);
    request := TRESTRequest.Create(nil);
    response := TRESTResponse.Create(nil);
    request.Client := Client;
    Client.BaseURL := 'http://slock.aks.vn/api/account/setPlan';
    request.Method := TRESTRequestMethod.rmPOST;
    request.response := response;
    request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    request.AcceptCharset := 'utf-8, *;q=0.8';
    paramjson := '{token:"' + aAPIInfoLogin.Token + '",value:{loginName:"' +
      loginname + '",plan:"' + plan + '" }}';
    ShowMessage(paramjson);
    request.AddBody(paramjson, ctAPPLICATION_JSON);
    request.Execute();
    str := response.JSONText;
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;
    ShowMessage(str);
    try
      a := TJSONArray(o.Get('Code').JsonValue);
      if a.ToString() = '1' then
      begin
        ShowMessage('thành cong !');
      end
      else
        ShowMessage('không thành cong ');
    finally
      o.Free;
    end;
  end;
end;

procedure TFormSlock.TFramePlanAksComboBoxHTh8Change(Sender: TObject);
begin
  if (TFramePlanAks.ComboBoxHTh8.Selected.Text <> '-1') and
    (TFramePlanAks.ComboBoxHTh8.Selected.Text <> '-2') then
    TFramePlanAks.ComboBoxMTh8.Visible := False;

end;

procedure TFormSlock.TFrameSetDeviceAksButtonRemoveDeviceClick(Sender: TObject);
var
  mac, str, paramjson, username: UnicodeString;
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  a: TJSONArray;
  o: TJSONObject;

begin
  // ph
  if loginok = True then
  begin
    mac := TFrameSetDeviceAks.ComboBoxMac.Selected.Text;
    username := TFrameSetDeviceAks.ComboBoxUser2.Selected.Text;
    Client := TRESTClient.Create(nil);
    request := TRESTRequest.Create(nil);
    response := TRESTResponse.Create(nil);
    request.Client := Client;
    Client.BaseURL := 'http://slock.aks.vn/api/user2/removeDevice';
    request.Method := TRESTRequestMethod.rmPOST;
    request.response := response;
    request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    request.AcceptCharset := 'utf-8, *;q=0.8';
    paramjson := '{token:"' + aAPIInfoLogin.Token + '",value:{userName:"' +
      username + '",mac:"' + mac + '" }}';
    // ShowMessage(paramjson);
    request.AddBody(paramjson, ctAPPLICATION_JSON);
    request.Execute();
    str := response.JSONText;
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;
    // ShowMessage(str);
    try
      a := TJSONArray(o.Get('Code').JsonValue);
      if a.ToString() = '1' then
      begin
        ShowMessage('Hủy bỏ thiết lập thiết bị thành cong !');
      end
      else
        ShowMessage('Hủy bỏ thiết lập thiết bị không thành cong ');
    finally
      o.Free;
    end;
  end;
end;

procedure TFormSlock.TFrameSetDeviceAksButtonSetDeviceBackClick
  (Sender: TObject);
begin
  SetStage(AKS_BUTTON_BACK_CREATE_SET_DEVICE);
end;

procedure TFormSlock.TFrameSetDeviceAksButtonSetDeviceClick(Sender: TObject);
var
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  User, password, str, paramjson: UnicodeString;
  o: TJSONObject;
  a: TJSONArray;
  username, mac, pinNames: UnicodeString;
begin
  if loginok = True then
  begin
    pinNames := '';
    if TFrameSetDeviceAks.CheckBoxArm.IsChecked then
      pinNames := pinNames + 'ARM';
    if TFrameSetDeviceAks.CheckBoxDisarm.IsChecked then
      pinNames := pinNames + ',DISARM';
    if TFrameSetDeviceAks.CheckBoxLock.IsChecked then
      pinNames := pinNames + ',LOCK';
    if TFrameSetDeviceAks.CheckBoxUnlock.IsChecked then
      pinNames := pinNames + ',UNLOCK';
    if TFrameSetDeviceAks.CheckBoxHorn.IsChecked then
      pinNames := pinNames + ',HORN';

    mac := TFrameSetDeviceAks.ComboBoxMac.Selected.Text;
    username := TFrameSetDeviceAks.ComboBoxUser2.Selected.Text;
    Client := TRESTClient.Create(nil);
    request := TRESTRequest.Create(nil);
    response := TRESTResponse.Create(nil);
    request.Client := Client;
    Client.BaseURL := 'http://slock.aks.vn/api/user2/setDevice';
    request.Method := TRESTRequestMethod.rmPOST;
    request.response := response;
    request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    request.AcceptCharset := 'utf-8, *;q=0.8';
    paramjson := '{token:"' + aAPIInfoLogin.Token + '",value:{userName:"' +
      username + '",mac:"' + mac + '",pinNames:"' + pinNames + '" }}';
    // ShowMessage(paramjson);
    request.AddBody(paramjson, ctAPPLICATION_JSON);
    request.Execute();
    str := response.JSONText;
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;
    // ShowMessage(str);
    try
      a := TJSONArray(o.Get('Code').JsonValue);
      if a.ToString() = '1' then
      begin
        ShowMessage('lenh thiet lap thiet bi thanh cong !');
      end
      else
        ShowMessage('lenh thiet lap thiet bi khong thanh cong ');
    finally
      o.Free;
    end;
  end
  else
  begin
    ShowMessage('Chưa login');
    Exit;
  end;
  // ShowMessage(TFrameSetDeviceAks.ComboBoxMac.Selected.Text);
end;

procedure TFormSlock.TFrameSettingsAksButtonBackClick(Sender: TObject);
begin
  SetStage(AKS_BUTTON_BACK_CREATE_DELETE_CONFIG);
end;

procedure TFormSlock.TFrameSettingsAksButtonLogoutClick(Sender: TObject);
var
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  User, password, str, paramjson: UnicodeString;
  o: TJSONObject;
  a: TJSONArray;

begin
  if loginok = True then
  begin
    // ShowMessage('dang login');
    Client := TRESTClient.Create(nil);
    request := TRESTRequest.Create(nil);
    response := TRESTResponse.Create(nil);
    request.Client := Client;
    Client.BaseURL := 'http://slock.aks.vn/api/account/logout';
    request.Method := TRESTRequestMethod.rmPOST;
    request.response := response;
    request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    request.AcceptCharset := 'utf-8, *;q=0.8';
    User := TFrameLoginAks.EditName.Text;
    password := THashMD5.GetHashString(User + TFrameLoginAks.EditPassword.Text);
    // ShowMessage(user);
    // ShowMessage(password);
    // paramjson := '{user:"' + user + '",password:"' + password + '"}';
    // request.AddBody(paramjson, ctAPPLICATION_JSON);
    request.AddParameter('token', aAPIInfoLogin.Token);
    // request.AddParameter('password', password);
    request.Execute();
    str := response.JSONText;
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;
    try
      a := TJSONArray(o.Get('Code').JsonValue);
      if a.ToString() = '1' then
      begin
        ShowMessage('Log out thanh cong !');
        aEngineAPI.Stop();
        // loginok:=False;
        SetStage(AKS_BUTTON_LOGOUT);
      end
      else
        ShowMessage('Khong the log out');

    finally
      o.Free;
    end;
    // ShowMessage(str);

  end
  else
  begin
    ShowMessage('Chưa login');
    Exit;
  end;
  aAPIInfoLogin.AllNameDevice.Clear;
  aAPIInfoLogin.ListMac.Clear;
  // FormSlock.aEngineAPI.Stop();
  // aAPIInfoLogin.Free;
  loginok := False;
end;

procedure TFormSlock.TFrameSettingsAksButtonPlanClick(Sender: TObject);
var
  i, k, j: Integer;
begin
  // demo
  FormSlock.TFramePlanAks.ComboBoxMTh8.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh8.Items.Clear;

  FormSlock.TFramePlanAks.ComboBoxMTh2.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh2.Items.Clear;

  FormSlock.TFramePlanAks.ComboBoxMTh3.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh3.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxMTh4.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh4.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxMTh5.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh5.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxMTh6.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh6.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxMTh7.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh7.Items.Clear;

  FormSlock.TFramePlanAks.ComboBoxHTh8Stop.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh2Stop.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh3Stop.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh4Stop.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh5Stop.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh6Stop.Items.Clear;
  FormSlock.TFramePlanAks.ComboBoxHTh7Stop.Items.Clear;

  FormSlock.TFramePlanAks.ComboBoxHTh8.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh2.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh3.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh4.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh5.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh6.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh7.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh8.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh2.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh3.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh4.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh5.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh6.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh7.ItemIndex := 0;

  FormSlock.TFramePlanAks.ComboBoxHTh8Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh2Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh3Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh4Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh5Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh6Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxHTh7Stop.ItemIndex := 0;

  FormSlock.TFramePlanAks.ComboBoxMTh8Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh2Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh3Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh4Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh5Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh6Stop.ItemIndex := 0;
  FormSlock.TFramePlanAks.ComboBoxMTh7Stop.ItemIndex := 0;

  // FormSlock.TFramePlanAks.ComboBoxHTh8.Items.Add('-1');
  // FormSlock.TFramePlanAks.ComboBoxHTh8.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh8.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh2.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh3.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh4.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh5.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh6.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh7.Items.Add('-1');

  FormSlock.TFramePlanAks.ComboBoxHTh8.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh2.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh3.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh4.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh5.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh6.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh7.Items.Add('-2');

  FormSlock.TFramePlanAks.ComboBoxHTh8Stop.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh2Stop.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh3Stop.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh4Stop.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh5Stop.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh6Stop.Items.Add('-1');
  FormSlock.TFramePlanAks.ComboBoxHTh7Stop.Items.Add('-1');

  FormSlock.TFramePlanAks.ComboBoxHTh8Stop.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh2Stop.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh3Stop.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh4Stop.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh5Stop.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh6Stop.Items.Add('-2');
  FormSlock.TFramePlanAks.ComboBoxHTh7Stop.Items.Add('-2');

  for i := 0 to 23 do
  begin
    FormSlock.TFramePlanAks.ComboBoxHTh8.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh2.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh3.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh4.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh5.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh6.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh7.Items.Add(IntToStr(i));

    FormSlock.TFramePlanAks.ComboBoxHTh8Stop.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh2Stop.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh3Stop.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh4Stop.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh5Stop.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh6Stop.Items.Add(IntToStr(i));
    FormSlock.TFramePlanAks.ComboBoxHTh7Stop.Items.Add(IntToStr(i));

  end;
  for j := 0 to 60 do
  begin
    FormSlock.TFramePlanAks.ComboBoxMTh8.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh2.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh3.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh4.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh5.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh6.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh7.Items.Add(IntToStr(j));

    FormSlock.TFramePlanAks.ComboBoxMTh8Stop.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh2Stop.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh3Stop.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh4Stop.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh5Stop.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh6Stop.Items.Add(IntToStr(j));
    FormSlock.TFramePlanAks.ComboBoxMTh7Stop.Items.Add(IntToStr(j));

  end;
  FormSlock.TFramePlanAks.ComboBoxListUser2.Items.Clear;
  AccountUser2();
  FormSlock.TFramePlanAks.ComboBoxListUser2.ItemIndex := 0;
  for k := 0 to aAPIInfoLogin.NameListUser2.Count - 1 do
  begin
    FormSlock.TFramePlanAks.ComboBoxListUser2.Items.Add
      (aAPIInfoLogin.NameListUser2[k])
  end;

  SetStage(AKS_BUTTON_CREATE_PLAN);
end;

procedure TFormSlock.TFrameSettingsAksButtonSetDeviceClick(Sender: TObject);
var
  i, j: Integer;
begin
  if aAPIInfoLogin.AuthorName = 'Customer' then
  begin
    TFrameSetDeviceAks.ComboBoxMac.Clear;
    TFrameSetDeviceAks.ComboBoxUser2.Clear;
    TFrameUser2AksCDConfig.ListViewUser2.Items.Clear;
    AccountUser2();
    TFrameSetDeviceAks.ComboBoxMac.ItemIndex := 0;
    TFrameSetDeviceAks.ComboBoxUser2.ItemIndex := 0;
    for i := 0 to aAPIInfoLogin.ListMac.Count - 1 do
    begin
      TFrameSetDeviceAks.ComboBoxMac.Items.Add(aAPIInfoLogin.ListMac[i]);
    end;
    for j := 0 to aAPIInfoLogin.NameListUser2.Count - 1 do
    begin
      TFrameSetDeviceAks.ComboBoxUser2.Items.Add
        (aAPIInfoLogin.NameListUser2[j]);
    end;

    SetStage(AKS_BUTTON_CREATE_SET_DEVICE);
  end
  else
    ShowMessage('Không có quyền thực hiện');
end;

function FindItemParent(Obj: TFMXObject; ParentClass: TClass): TFMXObject;
begin
  Result := nil;
  if Assigned(Obj.Parent) then
    if Obj.Parent.ClassType = ParentClass then
      Result := Obj.Parent
    else
      Result := FindItemParent(Obj.Parent, ParentClass);
end;

procedure TFormSlock.DoVisibleChange(Sender: TObject);
var
  Item: TListBoxItem;
begin
  Item := TListBoxItem(FindItemParent(Sender as TFMXObject, TListBoxItem));
  if Assigned(Item) then
    ShowMessage('demo ');
  // InfoLabel.Text := 'Checkbox changed ' + IntToStr(Item.Index) + ' listbox item to ' + BoolToStr(Item.StylesData['visible'].AsBoolean, true);
end;

procedure TFormSlock.AccountUser2();
var
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  User, password, str, paramjson: UnicodeString;
  o, OAuser2, odevicemap: TJSONObject;
  a, code, fullname, devicemap, plan, Auser2, amac, loginname: TJSONArray;
  namemac: TJSONPair;
  i, j: Integer;
  Item: TListViewItem;
begin
  // lay ve user cap 2
  if loginok = True then

  begin
    TFramePlanAks.ComboBoxListUser2.Items.Clear;
    SetStage(AKS_BUTTON_CREATE_DELETE_CONFIG);

    Client := TRESTClient.Create(nil);
    request := TRESTRequest.Create(nil);
    response := TRESTResponse.Create(nil);
    request.Client := Client;
    Client.BaseURL := 'http://slock.aks.vn/api/customer/user2';
    request.Method := TRESTRequestMethod.rmPOST;
    request.response := response;
    request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
    request.AcceptCharset := 'utf-8, *;q=0.8';

    paramjson := '{token:"' + aAPIInfoLogin.Token + '"}';
    // ShowMessage(paramjson);
    request.AddBody(paramjson, ctAPPLICATION_JSON);
    // request.AddParameter('user', user);
    // request.AddParameter('password', password);
    request.Execute();
    str := response.JSONText;
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
      as TJSONObject;

    try
      code := TJSONArray(o.Get('Code').JsonValue);
      if code.ToString() <> '-1' then
      begin
        a := TJSONArray(o.Get('Value').JsonValue);
        // ShowMessage(a.ToString());
        for i := 0 to a.Size - 1 do
        begin
          Auser2 := TJSONArray(a.Get(i));
          OAuser2 := TJSONObject.ParseJSONValue
            (TEncoding.ASCII.GetBytes(Auser2.ToString()), 0) as TJSONObject;
          // ok cho nay de do
          fullname := TJSONArray(OAuser2.Get('FullName').JsonValue);
          loginname := TJSONArray(OAuser2.Get('LoginName').JsonValue);
          Item := TFrameUser2AksCDConfig.ListViewUser2.Items.Add;
          aAPIInfoLogin.NameListUser2.Add(loginname.ToString().Substring(1,
            loginname.ToString().Length - 2));
          Item.Text := loginname.ToString()
            .Substring(1, loginname.ToString().Length - 2);

          devicemap := TJSONArray(OAuser2.Get('DeviceMap').JsonValue);
          if devicemap.ToString() <> 'null' then
          begin
            odevicemap := TJSONObject.ParseJSONValue
              (TEncoding.ASCII.GetBytes(devicemap.ToString()), 0)
              as TJSONObject;
            amac := TJSONArray(odevicemap);
            for j := 0 to amac.Size - 1 do
            begin
              namemac := TJSONPair(amac.Get(j));
              // Dia chi mac
              // ShowMessage(namemac.JsonString.ToString());
              // ShowMessage(namemac.JsonValue.ToString());
            end;
            // ShowMessage(devicemap.ToString());
          end
          // else
          // ShowMessage('Người dùng: ' + fullname.ToString() + ' chưa được  gán quyền các nút khóa' );

        end;

      end;
    finally
      o.Free;
    end;
    // ShowMessage(str);
  end
  else
    ShowMessage('Cần login để lấy về danh sách user2');

end;

procedure TFormSlock.TFrameSettingsAksButtonUser2Click(Sender: TObject);
var
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  User, password, str, paramjson: UnicodeString;
  o, OAuser2, odevicemap: TJSONObject;
  a, code, fullname, devicemap, plan, Auser2, amac, loginname: TJSONArray;
  namemac: TJSONPair;
  i, j: Integer;
  Item: TListBoxItem;
begin
  // lay ve user cap 2
  if loginok = True and (aAPIInfoLogin.AuthorName = 'Customer') then
  begin
    TFrameUser2AksCDConfig.ListViewUser2.Items.Clear;
    AccountUser2();
    SetStage(AKS_BUTTON_CREATE_DELETE_CONFIG);
  end
  else
    ShowMessage('Không có quyền thực hiện');

end;

procedure TFormSlock.TFrameSettingsAksLabelLogoutClick(Sender: TObject);
begin
  // thiet lap logout.
  if loginok = True then
  begin
    ShowMessage('dang login');
  end
  else
  begin
    ShowMessage('Chưa login');
    Exit;
  end;
  ShowMessage('12 dang login');

end;

procedure TFormSlock.TFrameUser2AksCDConfigButtonBackClick(Sender: TObject);
begin
  SetStage(AKS_BUTTON_BACK_CREATE_DELETE_CONFIG);
end;

procedure TFormSlock.TFrameUser2AksCDConfigButtonCreateUser2Click
  (Sender: TObject);
var
  str: UnicodeString;
  o: TJSONObject;
  a, value, account, name, mac, online: TJSONArray;
  ovalue, jNameMac: TJSONObject;
  jValue, jName: TJSONValue;
  idx: Integer;
  idy: Integer;
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  paramjson: UnicodeString;
  i: Integer;
  test: TJSONArray;
  loginname, fullname: UnicodeString;
begin
  Client := TRESTClient.Create(nil);
  request := TRESTRequest.Create(nil);
  response := TRESTResponse.Create(nil);
  request.Client := Client;
  Client.BaseURL := 'http://slock.aks.vn/api/user2/create';
  request.Method := TRESTRequestMethod.rmPOST;
  request.response := response;
  request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  request.AcceptCharset := 'utf-8, *;q=0.8';
  // ShowMessage(aAPIInfoLogin.Token);
  loginname := TFrameUser2AksCDConfig.EditNameUser2Login.Text;
  fullname := TFrameUser2AksCDConfig.EditUser2FullName.Text;
  if (loginname = '') or (fullname = '') then
  begin
    ShowMessage('Không để tên trống');
    Exit;
  end;
  paramjson := '{token:"' + aAPIInfoLogin.Token + '",value:{loginName:"' +
    loginname + '",fullName:"' + fullname + '"}}';
  request.AddBody(paramjson, ctAPPLICATION_JSON);
  request.Execute();
  str := response.JSONText;
  // ShowMessage(jValue.ToString());
  ovalue := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
    as TJSONObject;
  try
    a := TJSONArray(ovalue.Get('Code').JsonValue);
    if a.ToString() <> '1' then
      ShowMessage('Không tạo được user')
    else
    begin
      TFrameUser2AksCDConfig.EditNameUser2Login.Text := '';
      TFrameUser2AksCDConfig.EditUser2FullName.Text := '';
      TFrameUser2AksCDConfig.ListViewUser2.Items.Clear;
      AccountUser2();
      ShowMessage('Tạo Thành Công !');

    end;
  finally
    ovalue.Free;
  end;

end;

procedure TFormSlock.RemoveAccountUser2(loginname: UnicodeString);
var
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  paramjson, str: UnicodeString;
  o: TJSONObject;
  code: TJSONArray;
begin
  Client := TRESTClient.Create(nil);
  request := TRESTRequest.Create(nil);
  response := TRESTResponse.Create(nil);
  request.Client := Client;
  Client.BaseURL := 'http://slock.aks.vn/api/user2/remove';
  request.Method := TRESTRequestMethod.rmPOST;
  request.response := response;
  request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  request.AcceptCharset := 'utf-8, *;q=0.8';

  paramjson := '{token:"' + aAPIInfoLogin.Token + '",value:{loginName:"' +
    loginname + '"}}';
  // ShowMessage(paramjson);
  request.AddBody(paramjson, ctAPPLICATION_JSON);
  // request.AddParameter('user', user);
  // request.AddParameter('password', password);
  request.Execute();
  str := response.JSONText;
  o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
    as TJSONObject;
  try

    code := TJSONArray(o.Get('Code').JsonValue);
    ShowMessage(code.ToString());
    if code.ToString() = '-1' then
    begin
      ShowMessage('Xóa không thành công!');

    end
    else
    begin
      // TFrameUser2AksCDConfig.ListViewUser2.Items.Clear;
      // AccountUser2();
      ShowMessage('Xóa thành Công!');
    end;

  finally
    o.Free;
    Client.Free;
    request.Free;
    response.Free;
  end;
end;

procedure TFormSlock.TFrameUser2AksCDConfigButtonDeleteUser2Click
  (Sender: TObject);
var
  i: Integer;
  del: Boolean;
  Item: TListViewItem;
begin
  TFrameUser2AksCDConfig.ListViewUser2.EditMode := True;
  TFrameUser2AksCDConfig.ListViewUser2.BeginUpdate;
  try
    for i in TFrameUser2AksCDConfig.ListViewUser2.Items.CheckedIndexes(True) do
    begin
      Item := TFrameUser2AksCDConfig.ListViewUser2.Items[i];
      ShowMessage(Item.Text);
      RemoveAccountUser2(Item.Text);
      TFrameUser2AksCDConfig.ListViewUser2.Items.Delete(i);

      del := True;
    end;
    if del = True then
      TFrameUser2AksCDConfig.ListViewUser2.EditMode := False;
  finally
    TFrameUser2AksCDConfig.ListViewUser2.EndUpdate;
  end;

end;

function TFormSlock.AksLogin(User: string; pass: string): Boolean;
var
  md5pass: UnicodeString;
  str: UnicodeString;
  o: TJSONObject;
  a, code, value, account: TJSONArray;
  ovalue: TJSONObject;
  idx: Integer;
  idy: Integer;
  Token: TJSONPair;
  comparsion: Integer;
  resultlogin: Boolean;
  NameLogin: TJSONArray;
begin
  md5pass := THashMD5.GetHashString(User + pass);

  // ShowMessage(md5pass);
  TFrameLoginAks.RESTRequest1.ClearBody;
  TFrameLoginAks.RESTClient1.BaseURL := 'http://slock.aks.vn/api/account/login';
  TFrameLoginAks.RESTRequest1.AddParameter('username', User);
  TFrameLoginAks.RESTRequest1.AddParameter('password', md5pass);
  TFrameLoginAks.RESTRequest1.Execute();
  str := TFrameLoginAks.RESTResponse1.JSONText;
  // ShowMessage(str);

  o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
    as TJSONObject;

  try
    code := TJSONArray(o.Get('Code').JsonValue);
    if code.ToString() = '1' then
      a := TJSONArray(o.Get('Message').JsonValue);
    if (code.ToString() = '-1') or (code.ToString() = '-2') then
    begin
      ShowMessage('Login không thành công');
      Exit
    end;
    if code.ToString() = '-3' then
    begin
      ShowMessage('Không trong kế hoạch làm việc');
      Exit
    end;

    // ShowMessage(a.ToString());
    if CompareStr(a.ToString(), 'null') = 0 then
    begin

      value := TJSONArray(o.Get('Value').JsonValue);
      ovalue := TJSONObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(value.ToString), 0) as TJSONObject;
      try
        NameLogin := TJSONArray(ovalue.Get('ObjectId').JsonValue);
        aAPIInfoLogin.NameLogin := NameLogin.ToString()
          .Substring(1, NameLogin.ToString().Length - 2);
        // ShowMessage(namelogin.ToString());
        account := TJSONArray(ovalue.Get('Account').JsonValue);
        for idx := 0 to account.Size() - 1 do
        begin
          Token := TJSONPair(account.Get(idx));
          if CompareStr(Token.JsonString.value(), 'AuthorName') = 0 then
          begin
            aAPIInfoLogin.AuthorName := Token.JsonValue.value();

            // ShowMessage(' gia tri author : ' + aAPIInfoLogin.AuthorName);
          end;
          // ShowMessage(token.JsonString.ToString());
          // ShowMessage(token.JsonValue.ToString());
          comparsion := CompareStr(Token.JsonString.value(), 'Token');
          if comparsion = 0 then
          begin
            // ShowMessage(token.JsonValue.Value());
            // ShowMessage();
            aAPIInfoLogin.Token := Token.JsonValue.value();
            SaveSettings(User, pass);
            resultlogin := True;
          end;
        end;

      finally
        ovalue.Free;
      end;
    end
    else
    begin
      ShowMessage('Sai Ten hoac mat khau');
      Exit;
      resultlogin := False;
    end;
  finally
    o.Free;
  end;
  GetNameDeviceList();

  Result := resultlogin;

end;

function TFormSlock.DeviceOnline(namedevice: UnicodeString): UnicodeString;
var
  jsonmac, jsononline: TJSONArray;
  i, j: Integer;
  MacName, DeviceOnline: UnicodeString;
  mac: UnicodeString;
begin
  // aAPIInfoLogin.NameActivateDevice := ButtonDevice1.Text;
  jsonmac := TJSONArray(aAPIInfoLogin.MacName);
  // ShowMessage(jsonmac.ToString());
  for i := 0 to jsonmac.Size - 1 do
  begin
    MacName := aAPIInfoLogin.MacName.Pairs[i].JsonString.ToString();
    MacName := MacName.Substring(1, MacName.Length - 2);
    if MacName = namedevice then
    begin
      mac := aAPIInfoLogin.MacName.Pairs[i].JsonValue.ToString;
      mac := mac.Substring(2, mac.Length - 5) + '"';

    end;

  end;
  DeviceOnline := 'False';
  jsononline := TJSONArray(aAPIInfoLogin.MacOnline);
  for j := 0 to jsononline.Size - 1 do
  begin
    // ShowMessage(aAPIInfoLogin.MacOnline.Pairs[j].JsonString.ToString().Substring(2,mac.Length-1) +'"');
    // ShowMessage(mac);
    if aAPIInfoLogin.MacOnline.Pairs[j].JsonString.ToString()
      .Substring(2, mac.Length - 1) + '"' = mac then
    begin
      DeviceOnline := aAPIInfoLogin.MacOnline.Pairs[j].JsonValue.ToString();

      // ShowMessage(deviceonline);
    end;
  end;
  Result := DeviceOnline;
end;

procedure TFormSlock.SaveSettings(User: UnicodeString; pass: UnicodeString);
var
  IniFile: TMemIniFile;
begin
  aAPIInfoLogin.User := User;
  aAPIInfoLogin.Passmd5 := pass;
  IniFile := TMemIniFile.Create(DataFilePath + 'Settings.ini');

  // ShowMessage(DataFilePath);
  // ShowMessage(pass);
  // ShowMessage(User);
  // ShowMessage(aAPIInfoLogin.AuthorName);
  if aAPIInfoLogin.AuthorName = 'Customer' then
  begin
    IniFile.WriteString('Customer', 'user', User);
    IniFile.WriteString('Customer', 'pass', pass);
  end;
  if aAPIInfoLogin.AuthorName = 'User2' then
  begin
    IniFile.WriteString('User2', 'user', User);
    IniFile.WriteString('User2', 'pass', pass);
  end;
  IniFile.UpdateFile;
  IniFile.Free;

end;

procedure TFormSlock.LoadSettings();
var
  IniFile: TMemIniFile;
begin
  IniFile := TMemIniFile.Create(DataFilePath + 'Settings.ini');
  if aAPIInfoLogin.AuthorName = 'Customer' then
    ShowMessage('user cap 1');
  if aAPIInfoLogin.AuthorName = 'User2' then
    ShowMessage('User cap 2');
  // IniFile.WriteString('');
end;

procedure TFormSlock.ButtonDevice1Click(Sender: TObject);
var
  StausOnline: UnicodeString;
  jsonmac: TJSONArray;
  i: Integer;
  MacName, mac: UnicodeString;
begin

  aAPIInfoLogin.NameActivateDevice := ButtonDevice1.Text;
  // ShowMessage(aAPIInfoLogin.NameActivateDevice);
  StausOnline := DeviceOnline(aAPIInfoLogin.NameActivateDevice);
  // DeviceOnline := DeviceOnline();
  if StausOnline <> '"true"' then
  begin
    TFrameControlDeviceAks.Visible := False;
    LayoutStatusDevice.Visible := False;
    ShowMessage('Thiết bị không online');

  end
  else
  begin
    jsonmac := TJSONArray(aAPIInfoLogin.MacName);
    // ShowMessage(jsonmac.ToString());
    for i := 0 to jsonmac.Size - 1 do
    begin
      MacName := aAPIInfoLogin.MacName.Pairs[i].JsonString.ToString();
      MacName := MacName.Substring(1, MacName.Length - 2);
      // ShowMessage(MacName);
      // ShowMessage(aAPIInfoLogin.NameActivateDevice);
      if MacName = aAPIInfoLogin.NameActivateDevice then
      begin
        mac := aAPIInfoLogin.MacName.Pairs[i].JsonValue.ToString;
        mac := mac.Substring(2, mac.Length - 5) + '"';
        aAPIInfoLogin.MacActivate := mac;
        // ShowMessage(mac);
      end;

    end;
    SetStage(AKS_LOGIN_SUCCESS);
  end;

end;

procedure TFormSlock.ButtonDevice2Click(Sender: TObject);
var
  StausOnline: UnicodeString;
  jsonmac: TJSONArray;
  i: Integer;
  MacName, mac: UnicodeString;
begin
  aAPIInfoLogin.NameActivateDevice := ButtonDevice2.Text;
  // ShowMessage(aAPIInfoLogin.NameActivateDevice);
  StausOnline := DeviceOnline(aAPIInfoLogin.NameActivateDevice);
  // DeviceOnline := DeviceOnline();
  if StausOnline <> '"true"' then
  begin
    TFrameControlDeviceAks.Visible := False;
    LayoutStatusDevice.Visible := False;
    ShowMessage('Thiet bi khong online');

    // LayoutStatusDevice.Visible := False;
  end
  else
  begin
    jsonmac := TJSONArray(aAPIInfoLogin.MacName);
    // ShowMessage(jsonmac.ToString());
    for i := 0 to jsonmac.Size - 1 do
    begin
      MacName := aAPIInfoLogin.MacName.Pairs[i].JsonString.ToString();
      MacName := MacName.Substring(1, MacName.Length - 2);
      // ShowMessage(MacName);
      // ShowMessage(aAPIInfoLogin.NameActivateDevice);
      if MacName = aAPIInfoLogin.NameActivateDevice then
      begin
        mac := aAPIInfoLogin.MacName.Pairs[i].JsonValue.ToString;
        mac := mac.Substring(2, mac.Length - 5) + '"';
        aAPIInfoLogin.MacActivate := mac;
        // ShowMessage(mac);
      end;

    end;
    SetStage(AKS_LOGIN_SUCCESS);
  end;
end;

procedure TFormSlock.ButtonDevice3Click(Sender: TObject);
var
  StausOnline: UnicodeString;
begin
  aAPIInfoLogin.NameActivateDevice := ButtonDevice3.Text;
  // ShowMessage(aAPIInfoLogin.NameActivateDevice);
  StausOnline := DeviceOnline(aAPIInfoLogin.NameActivateDevice);
  // DeviceOnline := DeviceOnline();
  if StausOnline <> '"true"' then
  begin
    TFrameControlDeviceAks.Visible := False;
    ShowMessage('Thiet bi khong online');
    LayoutStatusDevice.Visible := False;
  end
  else
    SetStage(AKS_LOGIN_SUCCESS);

end;

procedure TFormSlock.CornerButtonCombinedLoginClick(Sender: TObject);

begin
  FormSlock.TFrameCombinedLoginAks.Visible := True;

  // gsg

end;

procedure TFormSlock.GetNameDeviceList();
var
  str: UnicodeString;
  o: TJSONObject;
  a, value, account, name, mac, online: TJSONArray;
  ovalue, jNameMac: TJSONObject;
  jValue, jName: TJSONValue;
  idx: Integer;
  idy: Integer;
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  url: UnicodeString;
  i: Integer;
  test: TJSONArray;

begin
  Client := TRESTClient.Create(nil);
  request := TRESTRequest.Create(nil);
  response := TRESTResponse.Create(nil);
  request.Client := Client;
  Client.BaseURL := 'http://slock.aks.vn/api/' + aAPIInfoLogin.AuthorName +
    '/GetAllDevices';
  request.Method := TRESTRequestMethod.rmPOST;
  request.response := response;
  request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  request.AcceptCharset := 'utf-8, *;q=0.8';
  // ShowMessage(aAPIInfoLogin.Token);
  request.AddParameter('token', aAPIInfoLogin.Token);
  request.AddParameter('stringData', 'false');
  request.Execute();
  str := response.JSONText;
  // ShowMessage(str);
  ovalue := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(str), 0)
    as TJSONObject;
  try
    a := TJSONArray(ovalue.Get('Value').JsonValue);
    // ShowMessage(a.ToString());
    for idx := 0 to a.Size - 1 do

    begin
      jValue := TJSONObject(a.Get(idx));
      jNameMac := TJSONObject.ParseJSONValue
        (TEncoding.ASCII.GetBytes(jValue.ToString()), 0) as TJSONObject;
      name := TJSONArray(jNameMac.Get('Name').JsonValue);
      // ShowMessage(name.ToString());
      mac := TJSONArray(jNameMac.Get('MAC').JsonValue);
      online := TJSONArray(jNameMac.Get('Online').JsonValue);
      // ShowMessage(mac.ToString().Substring(1, mac.ToString().Length - 2));
      aAPIInfoLogin.ListMac.Add(mac.ToString().Substring(1,
        mac.ToString().Length - 2));
      aAPIInfoLogin.AllNameDevice.Add(name.ToString().Substring(1,
        name.ToString().Length - 2));
      aAPIInfoLogin.NameActivateDevice := name.ToString()
        .Substring(1, name.ToString().Length - 2);
      aAPIInfoLogin.MacName.AddPair(name.ToString().Substring(1,
        name.ToString().Length - 2), mac.ToString());
      aAPIInfoLogin.MacOnline.AddPair(mac.ToString(), online.ToString());

    end;

  finally
    ovalue.Free();
  end;

  // for i := 0 to aAPIInfoLogin.AllNameDevice.Count -1 do
  // begin
  // ShowMessage(aAPIInfoLogin.AllNameDevice[i]);
  // end;
  // test := TJSONArray(aAPIInfoLogin.MacName);
  // for I := 0 to test.Size -1 do
  // begin
  // ShowMessage(aAPIInfoLogin.MacName.Pairs[I].JsonString.ToString());
  // ShowMessage(aAPIInfoLogin.MacName.Pairs[I].JsonValue.ToString);
  // end;
  if aAPIInfoLogin.AllNameDevice.Count = 1 then
  begin
    ButtonDevice1.Visible := True;
    ButtonDevice1.Text := aAPIInfoLogin.AllNameDevice[0];
    ButtonDevice2.Visible := False;
    ButtonDevice3.Visible := False;
    // ShowMessage('Vao trong co 1 nut');

  end;
  if aAPIInfoLogin.AllNameDevice.Count = 2 then
  begin
    ButtonDevice1.Text := aAPIInfoLogin.AllNameDevice[0];
    ButtonDevice2.Text := aAPIInfoLogin.AllNameDevice[1];
    ButtonDevice1.Visible := True;
    ButtonDevice2.Visible := True;
    ButtonDevice3.Visible := False;
    // ShowMessage('Vao trong co 2 nut');
  end;
  if aAPIInfoLogin.AllNameDevice.Count = 3 then
  begin
    ButtonDevice1.Text := aAPIInfoLogin.AllNameDevice[0];
    ButtonDevice2.Text := aAPIInfoLogin.AllNameDevice[1];
    ButtonDevice3.Text := aAPIInfoLogin.AllNameDevice[2];
    ButtonDevice1.Visible := True;
    ButtonDevice2.Visible := True;
    ButtonDevice3.Visible := True;
  end;

end;

procedure TFormSlock.LabelCombinedLoginClick(Sender: TObject);
var
  combinedlogin: TFrameCombinedLogin;
begin
  combinedlogin := TFrameCombinedLogin(Self);
  combinedlogin.Visible := True;
  ///
end;

procedure TFormSlock.UpDateStatusAppAfterCommand(response: UnicodeString);
var
  res, partsspins, partspin, jsonspin: TJSONObject;
  code, value: TJSONArray;
  i: Integer;
  spin, StatusOnline, mac: TJSONArray;
  arm, lock, unlock, horn, disarm: TJSONPair;
begin
  res := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes(response), 0)
    as TJSONObject;
  try
    code := TJSONArray(res.Get('Code').JsonValue);
    if code.ToString() = '1' then
    begin
      value := TJSONArray(res.Get('Value').JsonValue);
      // ShowMessage(value.ToString());
      for i := 0 to value.Size() - 1 do
      begin
        partsspins := TJSONObject(value.Get(i));
        partspin := TJSONObject.ParseJSONValue
          (TEncoding.ASCII.GetBytes(partsspins.ToString()), 0) as TJSONObject;
        spin := TJSONArray(partspin.Get('Pins').JsonValue);
        StatusOnline := TJSONArray(partspin.Get('Online').JsonValue);

        mac := TJSONArray(partspin.Get('MAC').JsonValue);
        jsonspin := TJSONObject.ParseJSONValue
          (TEncoding.ASCII.GetBytes(spin.ToString()), 0) as TJSONObject;
        arm := TJSONPair(jsonspin.Get('ARM'));
        lock := TJSONPair(jsonspin.Get('LOCK'));
        unlock := TJSONPair(jsonspin.Get('UNLOCK'));
        horn := TJSONPair(jsonspin.Get('HORN'));
        disarm := TJSONPair(jsonspin.Get('DISARM'));

        // ShowMessage(arm.JsonValue.ToString);
        // ShowMessage(lock.JsonValue.ToString);
        // ShowMessage(unlock.JsonValue.ToString);
        // ShowMessage(horn.JsonValue.ToString);
        // ShowMessage(disarm.JsonValue.ToString);
        aAPIInfoLogin.codereturn := '1';
        aAPIInfoLogin.StatusARM := arm.JsonValue.ToString;
        aAPIInfoLogin.StatusDISARM := disarm.JsonValue.ToString;
        aAPIInfoLogin.SatatusLOCK := lock.JsonValue.ToString;
        aAPIInfoLogin.StatusUNLOCK := unlock.JsonValue.ToString;
        aAPIInfoLogin.StatusHORN := horn.JsonValue.ToString;
        aAPIInfoLogin.StatusOnline := StatusOnline.ToString;


        // ShowMessage(spin.ToString());
        // ShowMessage(partsspins.ToString());

      end;
      ShowMessage('Lệnh Thành Công!');
    end
    else
    begin
      ShowMessage('Lệnh Không Thành Công!');
    end;

  finally
    res.Free();
  end;

end;

procedure TFormSlock.ActionCommand(name: UnicodeString; command: UnicodeString);
var
  mac: UnicodeString;
  jsonmac: TJSONArray;
  i, j: Integer;
  MacName: UnicodeString;
  Client: TRESTClient;
  request: TRESTRequest;
  response: TRESTResponse;
  AddBody: UnicodeString;
  strResponse: UnicodeString;
  DeviceOnline: UnicodeString;
  jsononline: TJSONArray;
begin
  jsonmac := TJSONArray(aAPIInfoLogin.MacName);
  for i := 0 to jsonmac.Size - 1 do
  begin
    MacName := aAPIInfoLogin.MacName.Pairs[i].JsonString.ToString();
    MacName := MacName.Substring(1, MacName.Length - 2);
    if MacName = name then
    begin
      mac := aAPIInfoLogin.MacName.Pairs[i].JsonValue.ToString;
      mac := mac.Substring(2, mac.Length - 5) + '"';
      // ShowMessage(mac);
    end;

  end;
  DeviceOnline := 'False';
  jsononline := TJSONArray(aAPIInfoLogin.MacOnline);
  for j := 0 to jsononline.Size - 1 do
  begin
    // ShowMessage(aAPIInfoLogin.MacOnline.Pairs[j].JsonString.ToString().Substring(2,mac.Length-1) +'"');
    // ShowMessage(mac);
    if aAPIInfoLogin.MacOnline.Pairs[j].JsonString.ToString()
      .Substring(2, mac.Length - 1) + '"' = mac then
    begin
      DeviceOnline := aAPIInfoLogin.MacOnline.Pairs[j].JsonValue.ToString();

      // ShowMessage(deviceonline);
    end;
  end;
  if DeviceOnline <> '"true"' then
    ShowMessage('Thiet bi khong online');

  Client := TRESTClient.Create(nil);
  request := TRESTRequest.Create(nil);
  response := TRESTResponse.Create(nil);
  request.Client := Client;
  Client.BaseURL := 'http://slock.aks.vn/api/device/write';
  request.Method := TRESTRequestMethod.rmPOST;
  request.response := response;
  request.Accept := 'application/json, text/plain; q=0.9, text/html;q=0.8,';
  request.AcceptCharset := 'utf-8, *;q=0.8';
  AddBody := '{token:"' + aAPIInfoLogin.Token + '",value:{mac:' + mac +
    ',command:"' + command + '"}}';
  // ShowMessage(addBody);
  request.AddBody(AddBody, ctAPPLICATION_JSON);
  request.Execute();
  strResponse := response.JSONText;
  // ShowMessage(strResponse);
  UpDateStatusAppAfterCommand(strResponse);
  // ShowMessage(strResponse);
end;

end.
