unit uCommon;

interface
uses
  SysUtils;
  
type
  ArrayOfUTF8String = class
  private
    m_data: array[0..99] of UTF8String;
    m_data_count: integer;
    function getData(Index: integer): UTF8String;
    procedure setData(Index: integer; data: UTF8String);
    function getCount(): integer;
  public
    constructor Create; overload;
    constructor Create(s0: UTF8String); overload;
    constructor Create(s0: UTF8String; s1: UTF8String); overload;
    constructor Create(s0, s1, s2: UTF8String); overload;
    constructor Create(s0, s1, s2, s3: UTF8String); overload;
    constructor Create(s0, s1, s2, s3, s4: UTF8String); overload;
    property Datas[Index: integer]: UTF8String read getData write setData; default;
    property Count: integer read getCount;
    procedure Add(data: UTF8String);
  end;

  ArrayOfDouble = class
  private
    m_data: array[0..99] of double;
    m_data_count: integer;
    function getData(Index: integer): double;
    procedure setData(Index: integer; data: double);
    function getCount(): integer;
  public
    constructor Create; overload;
    constructor Create(s0: double); overload;
    constructor Create(s0: double; s1: double); overload;
    constructor Create(s0: double; s1: double; s2: double); overload;
    constructor Create(s0: double; s1: double; s2: double; s3: double); overload;
    constructor Create(s0: double; s1: double; s2: double; s3: double; s4: double); overload;
    property Datas[Index: integer]: double read getData write setData; default;
    property Count: integer read getCount;
    procedure Add(data: double);
  end;

  ArrayOfBoolean = class
  private
    m_data: array[0..99] of boolean;
    m_data_count: integer;
    function getData(Index: integer): boolean;
    procedure setData(Index: integer; data: boolean);
    function getCount(): integer;
  public
    constructor Create; overload;
    constructor Create(s0: boolean); overload;
    constructor Create(s0: boolean; s1: boolean); overload;
    constructor Create(s0: boolean; s1: boolean; s2: boolean); overload;
    constructor Create(s0: boolean; s1: boolean; s2: boolean; s3: boolean); overload;
    constructor Create(s0: boolean; s1: boolean; s2: boolean; s3: boolean; s4: boolean); overload;
    property Datas[Index: integer]: boolean read getData write setData; default;
    property Count: integer read getCount;
    procedure Add(data: boolean);
  end;

function URLEncode(const S: UTF8String; const InQueryString: Boolean = true)
  : UTF8String;

implementation

function URLDecode(const S: UTF8String): UTF8String;
var
  Idx: Integer;   // loops thru chars in string
  Hex: string;    // string of hex characters
  Code: Integer;  // hex character code (-1 on error)
begin
  // Intialise result and string index
  Result := '';
  Idx := 1;
  // Loop thru string decoding each character
  while Idx <= Length(S) do
  begin
    case S[Idx] of
      '%':
      begin
        // % should be followed by two hex digits - exception otherwise
        if Idx <= Length(S) - 2 then
        begin
          // there are sufficient digits - try to decode hex digits
          Hex := S[Idx+1] + S[Idx+2];
          Code := SysUtils.StrToIntDef('$' + Hex, -1);
          Inc(Idx, 2);
        end
        else
          // insufficient digits - error
          Code := -1;
        // check for error and raise exception if found
        if Code = -1 then
          raise SysUtils.EConvertError.Create(
            'Invalid hex digit in URL'
          );
        // decoded OK - add character to result
        Result := Result + Chr(Code);
      end;
      '+':
        // + is decoded as a space
        Result := Result + ' '
      else
        // All other characters pass thru unchanged
        Result := Result + S[Idx];
    end;
    Inc(Idx);
  end;
end;


function URLEncode(const S: UTF8String; const InQueryString: Boolean = true)
  : UTF8String;
var
  Idx: Integer; // loops thru characters in string
begin
  Result := '';
  for Idx := 1 to Length(S) do
  begin
    case S[Idx] of
      'A'..'Z', 'a'..'z', '0'..'9', '-', '_', '.':
        Result := Result + S[Idx];
      ' ':
        if InQueryString then
          Result := Result + '+'
        else
          Result := Result + '%20';
      else
        Result := Result + '%' + SysUtils.IntToHex(Ord(S[Idx]), 2);
    end;
  end;
end;

//*****************************************************
//ArrayOfUTF8String
//*****************************************************
constructor ArrayOfUTF8String.Create();
begin
  m_data_count := 0;
end;

constructor ArrayOfUTF8String.Create(s0: UTF8String);
begin
  m_data_count := 1;
  m_data[0] := s0;
end;

constructor ArrayOfUTF8String.Create(s0: UTF8String; s1: UTF8String);
begin
  m_data_count := 2;
  m_data[0] := s0;
  m_data[1] := s1;
end;

constructor ArrayOfUTF8String.Create(s0, s1, s2: UTF8String);
begin
  m_data_count := 3;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
end;

constructor ArrayOfUTF8String.Create(s0, s1, s2, s3: UTF8String);
begin
  m_data_count := 4;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
end;

constructor ArrayOfUTF8String.Create(s0, s1, s2, s3, s4: UTF8String);
begin
  m_data_count := 5;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
  m_data[4] := s4;
end;

function ArrayOfUTF8String.getData(Index: integer): UTF8String;
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  result := m_data[Index];
end;

procedure ArrayOfUTF8String.setData(Index: integer; data: UTF8String);
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  m_data[Index] := data;
end;

function ArrayOfUTF8String.getCount(): integer;
begin
  result := m_data_count;
end;

procedure ArrayOfUTF8String.Add(data: UTF8String);
begin
  if (m_data_count > Length(m_data)) then
    raise Exception.Create('data buffer full!');
  m_data[m_data_count] := data;
  m_data_count := m_data_count + 1;
end;

//*****************************************************
//ArrayOfDouble
//*****************************************************
constructor ArrayOfDouble.Create();
begin
  m_data_count := 0;
end;

constructor ArrayOfDouble.Create(s0: double);
begin
  m_data_count := 1;
  m_data[0] := s0;
end;

constructor ArrayOfDouble.Create(s0: double; s1: double);
begin
  m_data_count := 2;
  m_data[0] := s0;
  m_data[1] := s1;
end;

constructor ArrayOfDouble.Create(s0: double; s1: double; s2: double);
begin
  m_data_count := 3;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
end;

constructor ArrayOfDouble.Create(s0: double; s1: double; s2: double; s3: double);
begin
  m_data_count := 4;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
end;

constructor ArrayOfDouble.Create(s0: double; s1: double; s2: double; s3: double; s4: double);
begin
  m_data_count := 5;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
  m_data[4] := s4;
end;

function ArrayOfDouble.getData(Index: integer): double;
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  result := m_data[Index];
end;

procedure ArrayOfDouble.setData(Index: integer; data: double);
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  m_data[Index] := data;
end;

function ArrayOfDouble.getCount(): integer;
begin
  result := m_data_count;
end;

procedure ArrayOfDouble.Add(data: double);
begin
  if (m_data_count > Length(m_data)) then
    raise Exception.Create('data buffer full!');
  m_data[m_data_count] := data;
  m_data_count := m_data_count + 1;
end;

//*****************************************************
//ArrayOfBoolean
//*****************************************************
constructor ArrayOfBoolean.Create();
begin
  m_data_count := 0;
end;

constructor ArrayOfBoolean.Create(s0: boolean);
begin
  m_data_count := 1;
  m_data[0] := s0;
end;

constructor ArrayOfBoolean.Create(s0: boolean; s1: boolean);
begin
  m_data_count := 2;
  m_data[0] := s0;
  m_data[1] := s1;
end;

constructor ArrayOfBoolean.Create(s0: boolean; s1: boolean; s2: boolean);
begin
  m_data_count := 3;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
end;

constructor ArrayOfBoolean.Create(s0: boolean; s1: boolean; s2: boolean; s3: boolean);
begin
  m_data_count := 4;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
end;

constructor ArrayOfBoolean.Create(s0: boolean; s1: boolean; s2: boolean; s3: boolean; s4: boolean);
begin
  m_data_count := 5;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
  m_data[4] := s4;
end;

function ArrayOfBoolean.getData(Index: integer): boolean;
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  result := m_data[Index];
end;

procedure ArrayOfBoolean.setData(Index: integer; data: boolean);
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  m_data[Index] := data;
end;

function ArrayOfBoolean.getCount(): integer;
begin
  result := m_data_count;
end;

procedure ArrayOfBoolean.Add(data: boolean);
begin
  if (m_data_count > Length(m_data)) then
    raise Exception.Create('data buffer full!');
  m_data[m_data_count] := data;
  m_data_count := m_data_count + 1;
end;

end.

