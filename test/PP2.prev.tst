<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ProtoParser>
  <scan finState="FINISH"><sym id="30" cat="24">/* Test grammar, example 2.5-5, page 39           */</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="32" cat="24">/* Show the abbreviated/linearized state diagram  */</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="33" cat="24">/* Dr. Georg Fischer 1980-08-01                   */</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="34" cat="24">/*------------------------------------------------*/</sym></scan>
  <scan finState="FINISH"><sym id="35" cat="23">  </sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="36" cat="26">EOF</sym></scan>
  <scan finState="FINISH"><sym id="37" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="38" cat="26">IDENTIFIER</sym></scan>
  <scan finState="FINISH"><sym id="37" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="39" cat="26">NUMBER</sym></scan>
  <scan finState="FINISH"><sym id="37" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="40" cat="26">STRING</sym></scan>
  <scan finState="FINISH"><sym id="37" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="14" cat="14">;</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <store>S = S a S b</store>
  <store>S =</store>
  <grammar axiom="S">
    <symbolList>
      <sym id="0" cat="0" type="EOP">EOP</sym>
      <sym id="1" cat="1">=&gt;</sym>
      <sym id="2" cat="2">|</sym>
      <sym id="3" cat="3">=</sym>
      <sym id="4" cat="4">-</sym>
      <sym id="5" cat="5">.</sym>
      <sym id="6" cat="6">[</sym>
      <sym id="7" cat="7">]</sym>
      <sym id="8" cat="8">#</sym>
      <sym id="9" cat="9">(</sym>
      <sym id="10" cat="10">)</sym>
      <sym id="11" cat="11">+</sym>
      <sym id="12" cat="12">*</sym>
      <sym id="13" cat="13">/</sym>
      <sym id="14" cat="14">;</sym>
      <sym id="15" cat="15">@</sym>
      <sym id="16" cat="16">:</sym>
      <sym id="17" cat="17">$</sym>
      <sym id="18" cat="18">/*</sym>
      <sym id="19" cat="19">*/</sym>
      <sym id="20" cat="20">//</sym>
      <sym id="21" cat="21" type="EOF">EOF</sym>
      <sym id="22" cat="22" type="EOL">EOL</sym>
      <sym id="23" cat="23" type="SPACE">SPACE</sym>
      <sym id="24" cat="24" type="NESTCOM">NESTCOM</sym>
      <sym id="25" cat="25" type="EOLCOM">EOLCOM</sym>
      <sym id="26" cat="26" type="IDENTIFIER">IDENTIFIER</sym>
      <sym id="27" cat="27" type="NUMBER">NUMBER</sym>
      <sym id="28" cat="28" type="STRING">STRING</sym>
      <sym id="29" cat="29" type="axiom">axiom</sym>
      <sym id="30" cat="24" type="NESTCOM">/* Test grammar, example 2.5-5, page 39           */</sym>
      <sym id="31" cat="22" type="EOL">\n</sym>
      <sym id="32" cat="24" type="NESTCOM">/* Show the abbreviated/linearized state diagram  */</sym>
      <sym id="33" cat="24" type="NESTCOM">/* Dr. Georg Fischer 1980-08-01                   */</sym>
      <sym id="34" cat="24" type="NESTCOM">/*------------------------------------------------*/</sym>
      <sym id="35" cat="23" type="SPACE">  </sym>
      <sym id="36" cat="26" type="IDENTIFIER">EOF</sym>
      <sym id="37" cat="23" type="SPACE"> </sym>
      <sym id="38" cat="26" type="IDENTIFIER">IDENTIFIER</sym>
      <sym id="39" cat="26" type="IDENTIFIER">NUMBER</sym>
      <sym id="40" cat="26" type="IDENTIFIER">STRING</sym>
      <sym id="41" cat="26" type="IDENTIFIER">S</sym>
      <sym id="42" cat="26" type="IDENTIFIER">a</sym>
      <sym id="43" cat="26" type="IDENTIFIER">b</sym>
      <sym id="44" cat="23" type="SPACE">   </sym>
    </symbolList>
    <rules>
      <rule left="S">
        <prod left="S" size="4">
          <sym id="41" cat="26">S</sym>
          <sym id="42" cat="26">a</sym>
          <sym id="41" cat="26">S</sym>
          <sym id="43" cat="26">b</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
        <prod left="S" size="0">
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
    </rules>
    <protos>
    </protos>
    <states>
    </states>
  </grammar>
  <legibleGrammar>
[S = S a S b
	|
]
  </legibleGrammar>
  <legibleTable>

  </legibleTable>
</ProtoParser>
