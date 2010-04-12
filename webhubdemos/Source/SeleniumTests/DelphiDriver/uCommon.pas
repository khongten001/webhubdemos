unit uCommon;

interface
uses
  SysUtils;
  
type
  ArrayOfString = class
  private
    m_data: array[0..99] of string;
    m_data_count: integer;
    function getData(Index: integer): string;
    procedure setData(Index: integer; data: string);
    function getCount(): integer;
  public
    constructor Create; overload;
    constructor Create(s0: string); overload;
    constructor Create(s0: string; s1: string); overload;
    constructor Create(s0: string; s1: string; s2: string); overload;
    constructor Create(s0: string; s1: string; s2: string; s3: string); overload;
    constructor Create(s0: string; s1: string; s2: string; s3: string; s4: string); overload;
    property Datas[Index: integer]: string read getData write setData; default;
    property Count: integer read getCount;
    procedure Add(data: string);
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

function URLEncode(const S: string; const InQueryString: Boolean = true): string;

implementation

function URLDecode(const S: string): string;
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


function URLEncode(const S: string; const InQueryString: Boolean = true): string;
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
//ArrayOfString
//*****************************************************
constructor ArrayOfString.Create();
begin
  m_data_count := 0;
end;

constructor ArrayOfString.Create(s0: string);
begin
  m_data_count := 1;
  m_data[0] := s0;
end;

constructor ArrayOfString.Create(s0: string; s1: string);
begin
  m_data_count := 2;
  m_data[0] := s0;
  m_data[1] := s1;
end;

constructor ArrayOfString.Create(s0: string; s1: string; s2: string);
begin
  m_data_count := 3;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
end;

constructor ArrayOfString.Create(s0: string; s1: string; s2: string; s3: string);
begin
  m_data_count := 4;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
end;

constructor ArrayOfString.Create(s0: string; s1: string; s2: string; s3: string; s4: string);
begin
  m_data_count := 5;
  m_data[0] := s0;
  m_data[1] := s1;
  m_data[2] := s2;
  m_data[3] := s3;
  m_data[4] := s4;
end;

function ArrayOfString.getData(Index: integer): string;
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  result := m_data[Index];
end;

procedure ArrayOfString.setData(Index: integer; data: string);
begin
  if (Index >= m_data_count) then
    raise Exception.Create('index out bound!');
  m_data[Index] := data;
end;

function ArrayOfString.getCount(): integer;
begin
  result := m_data_count;
end;

procedure ArrayOfString.Add(data: string);
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

