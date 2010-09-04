unit uTranslations;  {Translations used within Delphi for the Fish Store demo}
(*
Copyright (c) 2010 HREF Tools Corp.
Author: Ann Lynnworth

Permission is hereby granted, on 14-Feb-2010, free of charge, to any person
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
*)

interface

type
  TStoreLingvo = ( lingvoUnknown, lingvoEng, lingvoDeu, lingvoFra, lingvoChi,
    lingvoRus );  // human languages supported by WebHub demos

type
  TStorePhrase = (
    lgvBitmapImageConverted,
    lgvFileGraphicStored,
    lgvFishesUnlimited,
    lgvFishNumber
  );

type
  TStoreTranslation = record
    idx: TStorePhrase;
    eng: string;
    deu: string;
    fra: string;
  end;

var
  StorePhrases: array[lgvBitmapImageConverted .. lgvFishNumber]
    of TStoreTranslation = (

      (idx: lgvBitmapImageConverted;
       eng: 'BMP image converted to JPEG file named %0s';
       deu: 'Bmp-Bild wandelte in JPEG Akte genannte %0s um';
       fra: 'L''image de BMP a converti en JPEG %0s appelée par dossier'),

       {Chinese and Russian text could be included here if Delphi 2009 were the
        minimum compiler; we are still supporting Delphi 7.}

      (idx: lgvFileGraphicStored;
       eng: 'File graphic (BMP format) from database has been stored in %0s ' +
        '(JPEG format)';
       deu: 'Aktengraphik (BMP-Format) von der Datenbank ist in %0s ' +
        'gespeichert worden (JPEG-Format)';
       fra: 'Classez le graphique (format de BMP) de la base de données ' +
        'stockée en %0s (le format de JPEG)'),

      (idx: lgvFishesUnlimited;
       eng: 'Fishes Unlimited, Direct to You.';
       deu: 'Fische unbegrenzt, direkt zu Ihnen';
       fra: 'Poisson Unlimited, Direct tonne You'),

      (idx: lgvFishNumber;
       eng: 'Fish #';
       deu: 'Fische-Zahl';
       fra: 'Poisson nombres')

      );

function FishTraduko(const InPhrase: TStorePhrase): string;

implementation

uses
  webApp,
  tfish;

function FishTraduko(const InPhrase: TStorePhrase): string;
begin
  Assert(StorePhrases[InPhrase].idx = InPhrase);
  if Assigned(pWebApp) then
  begin
    case TFishSessionVars(TFishApp(pWebApp).Session.Vars).MyLingvo of
      lingvoEng: Result := StorePhrases[InPhrase].eng;
      lingvoDeu: Result := StorePhrases[InPhrase].deu;
      lingvoFra: Result := StorePhrases[InPhrase].fra;
      else       Result := StorePhrases[InPhrase].eng;
    end;
  end
  else
    Result := '';
end;

end.
