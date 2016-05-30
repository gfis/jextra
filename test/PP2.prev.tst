<?xml version="1.0" encoding="ISO-8859-1"?>
<Parser>
  <scan fsaState="FINISH"><sym id="29" cat="23" ent="/* Test grammar, example 2.5-5, page 39           */" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="31" cat="23" ent="/* Show the abbreviated/linearized state diagram  */" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="32" cat="23" ent="/* Dr. Georg Fischer 1980-08-01                   */" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="33" cat="23" ent="/*------------------------------------------------*/" /></scan>
  <scan fsaState="FINISH"><sym id="34" cat="22" ent="  " /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="35" cat="25" ent="EOF" /></scan>
  <scan fsaState="FINISH"><sym id="36" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="37" cat="25" ent="IDENTIFIER" /></scan>
  <scan fsaState="FINISH"><sym id="36" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="38" cat="25" ent="NUMBER" /></scan>
  <scan fsaState="FINISH"><sym id="36" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="39" cat="25" ent="STRING" /></scan>
  <scan fsaState="FINISH"><sym id="36" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="13" cat="13" ent=";" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <prod left="S" size="4">
    <sym id="40" cat="25" ent="S" />
    <sym id="41" cat="25" ent="a" />
    <sym id="40" cat="25" ent="S" />
    <sym id="42" cat="25" ent="b" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="S" size="0">
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <grammar axiom="S">
    <symbolList>
      <sym id="0" cat="0" ent="=>" />
      <sym id="1" cat="1" ent="|" />
      <sym id="2" cat="2" ent="=" />
      <sym id="3" cat="3" ent="-" />
      <sym id="4" cat="4" ent="." />
      <sym id="5" cat="5" ent="[" />
      <sym id="6" cat="6" ent="]" />
      <sym id="7" cat="7" ent="#" />
      <sym id="8" cat="8" ent="(" />
      <sym id="9" cat="9" ent=")" />
      <sym id="10" cat="10" ent="+" />
      <sym id="11" cat="11" ent="*" />
      <sym id="12" cat="12" ent="/" />
      <sym id="13" cat="13" ent=";" />
      <sym id="14" cat="14" ent="@" />
      <sym id="15" cat="15" ent=":" />
      <sym id="16" cat="16" ent="$" />
      <sym id="17" cat="17" ent="/*" />
      <sym id="18" cat="18" ent="*/" />
      <sym id="19" cat="19" ent="//" />
      <sym id="20" cat="20" ent="EOF" />
      <sym id="21" cat="21" ent="EOL" />
      <sym id="22" cat="22" ent="SPACE" />
      <sym id="23" cat="23" ent="NESTCOM" />
      <sym id="24" cat="24" ent="EOLCOM" />
      <sym id="25" cat="25" ent="IDENTIFIER" />
      <sym id="26" cat="26" ent="NUMBER" />
      <sym id="27" cat="27" ent="STRING" />
      <sym id="28" cat="28" ent="axiom" />
      <sym id="29" cat="23" ent="/* Test grammar, example 2.5-5, page 39           */" />
      <sym id="30" cat="21" ent="\n" />
      <sym id="31" cat="23" ent="/* Show the abbreviated/linearized state diagram  */" />
      <sym id="32" cat="23" ent="/* Dr. Georg Fischer 1980-08-01                   */" />
      <sym id="33" cat="23" ent="/*------------------------------------------------*/" />
      <sym id="34" cat="22" ent="  " />
      <sym id="35" cat="25" ent="EOF" />
      <sym id="36" cat="22" ent=" " />
      <sym id="37" cat="25" ent="IDENTIFIER" />
      <sym id="38" cat="25" ent="NUMBER" />
      <sym id="39" cat="25" ent="STRING" />
      <sym id="40" cat="25" ent="S" />
      <sym id="41" cat="25" ent="a" />
      <sym id="42" cat="25" ent="b" />
      <sym id="43" cat="22" ent="   " />
    </symbolList>
    <rules>
      <rule left="S">
        <prod left="S" size="4">
          <sym id="40" cat="25" ent="S" />
          <sym id="41" cat="25" ent="a" />
          <sym id="40" cat="25" ent="S" />
          <sym id="42" cat="25" ent="b" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="S" size="0">
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="HYPER_AXIOM">
        <prod left="HYPER_AXIOM" size="3">
          <sym id="20" cat="20" ent="EOF" />
          <sym id="40" cat="25" ent="S" />
          <sym id="20" cat="20" ent="EOF" />
          <sym id="0" cat="0" ent="" />
        </prod>
      </rule>
    <rules>
    <protos>
    </protos>
    <states>
    </states>
  </grammar>

</Parser>
[S =S = S a S b
	| S =
.HYPER_AXIOM =HYPER_AXIOM = EOF S EOF

]
12: 	@S -> 13 =: HYPER_AXIOM
13: 	@EOF -> 13 =: HYPER_AXIOM

