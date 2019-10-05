unit jsonadapter;

interface
uses
  System.SysUtils,
  System.Classes,
  System.Json,
  Data.DB;

type
  EDataTypeCoersion = class(Exception); //- Can't alter data-type for existing field definition.
  EDataTypeUnsupported = class(Exception); //- Can't support data-type from json data. (objects and arrays)
  EUnknownDataType = class(Exception); //- Unable to determine data type from json data.

type
  TJSONDatasetAdapter = class(TComponent)
  private
    fJSON: TStrings;
    fDatasetRef: TDataset;
    procedure SetDatasetRef(const Value: TDataset);
    procedure setJSON(const Value: TStrings);
    procedure SetFieldDefs(a: TJSONArray);
    procedure InsertData(a: TJSONArray);
  public
    constructor Create( aOwner: TComponent ); override;
    destructor Destroy; override;
  public
    procedure UpdateDataset;
  published
    property JSON: TStrings read fJSON write setJSON;
    property Dataset: TDataset read fDatasetRef write SetDatasetRef;
  end;

procedure Register;

implementation

procedure Register;
begin
  RegisterComponents('REST Client', [TJSONDatasetAdapter]);
end;

{ TJSONDatasetAdapter }

constructor TJSONDatasetAdapter.Create(aOwner: TComponent);
begin
  inherited Create( aOwner );
  fJSON := TStringList.Create;
  fJSON.Text := '[]';
  fDatasetRef := nil;
end;

destructor TJSONDatasetAdapter.Destroy;
begin
  fJSON.DisposeOf;
  fDatasetRef := nil;
  inherited Destroy;
end;

procedure TJSONDatasetAdapter.SetDatasetRef(const Value: TDataset);
begin
  fDatasetRef := Value;
  UpdateDataset;
end;

procedure TJSONDatasetAdapter.setJSON(const Value: TStrings);
begin
  if not assigned(value) then begin
    fJSON.Clear;
    exit;
  end;
  fJSON.Assign(Value);
  UpdateDataset;
end;

procedure TJSONDatasetAdapter.SetFieldDefs( a: TJSONArray );
var
  o: TJSONObject;
  e: TJSONPairEnumerator;
  p: TJSONPair;
  v: TJSONValue;
  n: string;
  idx: uint32;
  FieldDef: TFieldDef;
begin
  if a.Count<1 then begin
    exit;
  end;
  //- Loop through data to determine data-types.
  for idx := 0 to pred(a.Count) do begin
    v := a.Items[idx];
    if not (v is TJSONObject) then begin
      exit;
    end;
    o := v as TJSONObject;
    try
      e := TJSONPairEnumerator(o.GetEnumerator);
      if not e.MoveNext then begin
        exit;
      end;
      repeat
        p := e.GetCurrent;
        if not assigned(p) then continue;
        //- Get the name of the field, and ensure we have a field def.
        n := Lowercase(Trim(p.JsonString.ToString));
        n := StringReplace(n,'"','',[rfReplaceAll]);
        FieldDef := nil;
        if fDatasetRef.FieldDefs.IndexOf(n)>=0 then begin
          FieldDef := fDatasetRef.FieldDefs.Find(n);
        end;
        if not assigned(FieldDef) then begin
          FieldDef := fDatasetRef.FieldDefs.AddFieldDef;
          FieldDef.Name := n;
        end;
        //- Determine the type of field.
        v := p.JsonValue;
        if v is TJSONString then begin
          if (FieldDef.DataType=TFieldType.ftUnknown) then begin
            FieldDef.DataType := TFieldType.ftString;
          end;
        end else if v is TJSONNumber then begin
          if (FieldDef.DataType=TFieldType.ftUnknown) then begin
            FieldDef.DataType := TFieldType.ftFloat;
          end else if (FieldDef.DataType <> TFieldType.ftFloat) then begin
            raise EDataTypeCoersion.Create('');
          end;
        end else if v is TJSONBool then begin
          if (FieldDef.DataType=TFieldType.ftUnknown) then begin
            FieldDef.DataType := TFieldType.ftBoolean;
          end else if (FieldDef.DataType<>ftBoolean) then begin
            raise EDataTypeCoersion.Create('');
          end;
        end else if v is TJSONNull then begin
          //- Do nothing, another record may indicate data type.
        end else if v is TJSONObject then begin
          raise EDataTypeUnsupported.Create('');
        end else if v is TJSONArray then begin
          raise EDataTypeUnsupported.Create('');
        end;
      until not e.MoveNext;
    finally
      o := nil;
    end;
  end;
 //- Ensure that all field defs have known data types.
 if fDatasetRef.FieldDefs.Count<1 then begin
   exit;
 end;
 for idx := 0 to pred(fDatasetRef.FieldDefs.Count) do begin
   if fDatasetRef.FieldDefs[idx].DataType=TFieldType.ftUnknown then begin
     raise EUnknownDataType.Create('field: '+fDatasetRef.FieldDefs[idx].Name);
   end;
 end;
end;

procedure TJSONDatasetAdapter.InsertData( a: TJSONArray );
var
  idx: uint32;
  idy: uint32;
  v: TJSONValue;
  o: TJSONObject;
  FieldName: string;
begin
  if fDatasetRef.FieldDefs.Count<1 then begin
    exit;
  end;
  if a.Count<1 then begin
    exit;
  end;
  for idx := 0 to pred(a.Count) do begin
    v := a.Items[idx];
    if not (v is TJSONObject) then continue; //[ Exception here? ]
    o := v as TJSONObject;
    fDatasetRef.Insert;
    for idy := 0 to pred(fDatasetRef.FieldDefs.Count) do begin
      FieldName := fDatasetRef.FieldDefs[idy].Name;
      v := o.GetValue(FieldName);
      if assigned(v) then begin
        if v is TJSONString then begin
          fDatasetRef.FieldByName(FieldName).AsString := TJSONString(v).Value;
        end else begin
          fDatasetRef.FieldByName(FieldName).AsString := v.ToJSON;
        end;
      end;
    end;
    fDatasetRef.Post;
  end;
end;

procedure TJSONDatasetAdapter.UpdateDataset;
var
  o: TJSONObject;
  a: TJSONArray;
  v: TJSONValue;
begin
  if not assigned(fDatasetRef) then begin
    exit;
  end;
  fDatasetRef.Active := False;
  fDatasetRef.FieldDefs.Clear;
  try
    o := TJSONObject.ParseJSONValue(TEncoding.ASCII.GetBytes('{ "data": '+fJSON.Text+'}'),0) as TJSONObject;
  except
    on E: Exception do begin
     exit;
    end;
  end;
  if not assigned(o) then begin
    exit;
  end;
  v := o.GetValue('data');
  if not assigned(v) then begin
    exit;
  end;
  if not (v is TJSONArray) then begin
    exit;
  end;
  a := v as TJSONArray;
  if a.Count=0 then begin
    exit;
  end;
  SetFieldDefs(a);
  fDatasetRef.Active := True;
  InsertData(a);
end;

end.
