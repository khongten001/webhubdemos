unit uAWS_S3;

(*
Permission is hereby granted, on 23-Jul-2017, free of charge, to any person
obtaining a copy of this file (the "Software"), to deal in the Software
without restriction, including without limitation the rights to use, copy,
modify, merge, publish, distribute, sublicense, and/or sell copies of the
Software, and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Author: Ann Lynnworth at HREF Tools Corp.
*)

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
