{*******************************************************************************

  Zydis Pascal API By Coldzer0

 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all
 * copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 * SOFTWARE.

*******************************************************************************}

unit Zydis;

{$IFDEF FPC}
  {$MODE DELPHI}
  {$PackRecords C}
{$ENDIF}

interface
   uses
     Zydis.enums,
     Zydis.Types,
     Zydis.Disassembler;


{.$DEFINE ZYDIS_DYNAMIC_LINK}
{$IFDEF ZYDIS_DYNAMIC_LINK}
const
  {$IFDEF CPUX86}
  ZYDIS_LIBRARY_NAME = 'Zydis32.dll';
  {$ENDIF}
  {$IFDEF CPUX64}
  ZYDIS_LIBRARY_NAME = 'Zydis64.dll';
  {$ENDIF}
  ZYDIS_SYMBOL_PREFIX = '';
{$ELSE}
const
  {$ifdef OSWINDOWS}
    {$ifdef CPU64}
      _PREFIX = '';
    {$else}
      _PREFIX = '_';
    {$endif CPU64}
  {$else}
    {$ifdef OSDARWIN}
      _PREFIX = '_';
    {$else}
      _PREFIX = ''; // other POSIX systems don't haveany trailing underscore
    {$endif OSDARWIN}
  {$endif OSWINDOWS}
{$IFDEF CPUX86}
const
  ZYDIS_SYMBOL_PREFIX = '_';
    {$L 'Bin32/Decoder.obj'}
    {$L 'Bin32/DecoderData.obj'}
    {$L 'Bin32/Formatter.obj'}
    {$L 'Bin32/MetaInfo.obj'}
    {$L 'Bin32/Mnemonic.obj'}
    {$L 'Bin32/Register.obj'}
    {$L 'Bin32/SharedData.obj'}
    {$L 'Bin32/String.obj'}
    {$L 'Bin32/Utils.obj'}
    {$L 'Bin32/Zydis.obj'}
  {$ENDIF}
  {$IFDEF CPUX64}
const
  ZYDIS_SYMBOL_PREFIX = '';
    {$IFDEF FPC}
      {$LinkLib libZydis.a}
    {$ELSE}
      {$L 'Bin64/Decoder.obj'}
      {$L 'Bin64/DecoderData.obj'}
      {$L 'Bin64/Formatter.obj'}
      {$L 'Bin64/MetaInfo.obj'}
      {$L 'Bin64/Mnemonic.obj'}
      {$L 'Bin64/Register.obj'}
      {$L 'Bin64/SharedData.obj'}
      {$L 'Bin64/String.obj'}
      {$L 'Bin64/Utils.obj'}
      {$L 'Bin64/Zydis.obj'}
    {$ENDIF}
  {$ENDIF}
{$ENDIF}



{* ============================================================================================== *}
{* Constants                                                                                      *}
{* ============================================================================================== *}
const
  ZYDIS_VERSION                = $0004000000000000;



{* ---------------------------------------------------------------------------------------------- *}
{* Zydis Disassembler                                                                                          *}
{* ---------------------------------------------------------------------------------------------- *}
function ZydisDisassembleIntel(machine_mode: TZydisMachineMode;
  runtime_address: ZyanU64; buffer: Pointer; length: ZyanUSize;
  var instruction: TZydisDisassembledInstruction): ZyanStatus; external
  {$IFDEF ZYDIS_DYNAMIC_LINK}ZYDIS_LIBRARY_NAME{$ENDIF}
  name ZYDIS_SYMBOL_PREFIX + 'ZydisDisassembleIntel';


{* ---------------------------------------------------------------------------------------------- *}
{* Zydis                                                                                          *}
{* ---------------------------------------------------------------------------------------------- *}

function ZydisGetVersion: ZyanU64; cdecl;
  external {$IFDEF ZYDIS_DYNAMIC_LINK}ZYDIS_LIBRARY_NAME{$ENDIF}
  name ZYDIS_SYMBOL_PREFIX + 'ZydisGetVersion';

function ZydisVersionMajor(Version: ZyanU64): ZyanU16; inline;
function ZydisVersionMinor(Version: ZyanU64): ZyanU16; inline;
function ZydisVersionPatch(Version: ZyanU64): ZyanU16; inline;
function ZydisVersionBuild(Version: ZyanU64): ZyanU16; inline;


implementation

function memset(dest: Pointer; val: Integer; count: PtrInt): Pointer; cdecl;
 {$ifdef FPC} public name _PREFIX + 'memset'; {$endif}
begin
  FillChar(dest^, count, val);
  result := dest;
end;

{* ---------------------------------------------------------------------------------------------- *}
{* Zydis                                                                                          *}
{* ---------------------------------------------------------------------------------------------- *}

function ZydisVersionMajor(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $FFFF000000000000) shr 48;
end;

function ZydisVersionMinor(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $0000FFFF00000000) shr 32;
end;

function ZydisVersionPatch(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $00000000FFFF0000) shr 16;
end;

function ZydisVersionBuild(Version: ZyanU64): ZyanU16;
begin
  Result := (Version and $000000000000FFFF);
end;

end.
