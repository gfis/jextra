<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Parser>
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
      <sym id="0" cat="0">EOP</sym>
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
      <sym id="21" cat="21">EOF</sym>
      <sym id="22" cat="22">EOL</sym>
      <sym id="23" cat="23">SPACE</sym>
      <sym id="24" cat="24">NESTCOM</sym>
      <sym id="25" cat="25">EOLCOM</sym>
      <sym id="26" cat="26">IDENTIFIER</sym>
      <sym id="27" cat="27">NUMBER</sym>
      <sym id="28" cat="28">STRING</sym>
      <sym id="29" cat="29">axiom</sym>
      <sym id="30" cat="24">/* Test grammar, example 2.5-5, page 39           */</sym>
      <sym id="31" cat="22">\n</sym>
      <sym id="32" cat="24">/* Show the abbreviated/linearized state diagram  */</sym>
      <sym id="33" cat="24">/* Dr. Georg Fischer 1980-08-01                   */</sym>
      <sym id="34" cat="24">/*------------------------------------------------*/</sym>
      <sym id="35" cat="23">  </sym>
      <sym id="36" cat="26">EOF</sym>
      <sym id="37" cat="23"> </sym>
      <sym id="38" cat="26">IDENTIFIER</sym>
      <sym id="39" cat="26">NUMBER</sym>
      <sym id="40" cat="26">STRING</sym>
      <sym id="41" cat="26">S</sym>
      <sym id="42" cat="26">a</sym>
      <sym id="43" cat="26">b</sym>
      <sym id="44" cat="23">   </sym>
    </symbolList>
    <rules>
      <rule left="HYPER_AXIOM">
        <prod left="HYPER_AXIOM" size="3">
          <sym id="21" cat="21">EOF</sym>
          <sym id="41" cat="26">S</sym>
          <sym id="21" cat="21">EOF</sym>
          <sym id="0" cat="0">EOP</sym>
        </prod>
      </rule>
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
[HYPER_AXIOM = EOF S EOF
.S = S a S b
	| 
]
  </legibleGrammar>
  <legibleTable>
12: 	@S -> 13 =: HYPER_AXIOM
13: 	@EOF -> 13 =: HYPER_AXIOM
  </legibleTable>
</Parser>
