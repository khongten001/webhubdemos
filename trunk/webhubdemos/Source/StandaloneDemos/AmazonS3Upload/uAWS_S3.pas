unit uAWS_S3;

interface

uses
  Data.Cloud.AmazonAPI;

function StrToRegion(const InRegion: string): TAmazonRegion;
function StrToS3Endpoint(const InRegion: string): string;

implementation

uses
  SysUtils;

function StrToRegion(const InRegion: string): TAmazonRegion;
begin
  if InRegion = 'us-east-1' then Result := amzrUSEast1
  else
  if InRegion = 'us-west-1' then Result := amzrUSWest1
  else
  if InRegion =  'us-west-2' then Result := amzrUSWest2
  else
  if InRegion =  'eu-west-1' then Result := amzrEUWest1
  else
  if InRegion =  'eu-central-1' then Result := amzrEUCentral1
  else
  if InRegion =  'ap-northeast-1' then Result := amzrAPNortheast1
  //else
  //if InRegion =  'ap-northeast-2' then Result := // unsupported
  else
  if InRegion =  'ap-southeast-1' then Result := amzrAPSoutheast1
  else
  if InRegion =  'ap-southeast-2' then Result := amzrAPSoutheast2
  else
  if InRegion =  'sa-east-1' then Result := amzrSAEast1
  else
    Result := amzrNotSpecified;
end;

function StrToS3Endpoint(const InRegion: string): string;
begin
  // http://docs.aws.amazon.com/general/latest/gr/rande.html#s3_region
  if InRegion = 'us-east-1' then
    Result := 's3.amazonaws.com' // or 's3-external-1.amazonaws.com'
  else
    Result := Format('s3-%s.amazonaws.com', [InRegion]);
end;

end.
