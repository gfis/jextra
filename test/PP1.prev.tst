<?xml version="1.0" encoding="ISO-8859-1"?>
<Parser>
  <scan fsaState="FINISH"><sym id="29" cat="23" ent="/*------------------------------------------------------*/" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="31" cat="25" ent="EOF" /></scan>
  <scan fsaState="FINISH"><sym id="32" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="33" cat="25" ent="IDENTIFIER" /></scan>
  <scan fsaState="FINISH"><sym id="32" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="34" cat="25" ent="NUMBER" /></scan>
  <scan fsaState="FINISH"><sym id="32" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="35" cat="25" ent="STRING" /></scan>
  <scan fsaState="FINISH"><sym id="32" cat="22" ent=" " /></scan>
  <scan fsaState="FINISH"><sym id="13" cat="13" ent=";" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="36" cat="23" ent="/* Meta Grammar for Parsing of Transformation Grammars  \n   Georg Fischer 1980-08-01                             */" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <scan fsaState="FINISH"><sym id="37" cat="23" ent="/*------------------------------------------------------*/" /></scan>
  <scan fsaState="FINISH"><sym id="30" cat="21" ent="\n" /></scan>
  <prod left="AXIOM" size="1">
    <sym id="39" cat="25" ent="EXTRA_INPUT" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="EXTRA_INPUT" size="3">
    <sym id="5" cat="5" ent="[" />
    <sym id="42" cat="25" ent="GRAMMAR" />
    <sym id="6" cat="6" ent="]" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="GRAMMAR" size="1">
    <sym id="45" cat="25" ent="RULES" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="2" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="RULES" size="1">
    <sym id="49" cat="25" ent="RULE" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="RULES" size="3">
    <sym id="45" cat="25" ent="RULES" />
    <sym id="4" cat="4" ent="." />
    <sym id="49" cat="25" ent="RULE" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="RULE" size="3">
    <sym id="53" cat="25" ent="LEFT_SIDE" />
    <sym id="2" cat="2" ent="=" />
    <sym id="55" cat="25" ent="RIGHT_SIDES" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="LEFT_SIDE" size="1">
    <sym id="33" cat="25" ent="IDENTIFIER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="3" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="RIGHT_SIDES" size="1">
    <sym id="59" cat="25" ent="RIGHT_SIDE" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="RIGHT_SIDES" size="3">
    <sym id="55" cat="25" ent="RIGHT_SIDES" />
    <sym id="1" cat="1" ent="|" />
    <sym id="59" cat="25" ent="RIGHT_SIDE" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="RIGHT_SIDE" size="2">
    <sym id="62" cat="25" ent="SYNTAX_PART" />
    <sym id="63" cat="25" ent="SEMANTIC_PART" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="SYNTAX_PART" size="1">
    <sym id="64" cat="25" ent="MEMBERETIES" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="6" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="MEMBERETIES" size="0">
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="7" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="MEMBERETIES" size="2">
    <sym id="64" cat="25" ent="MEMBERETIES" />
    <sym id="69" cat="25" ent="MEMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="MEMBER" size="1">
    <sym id="71" cat="25" ent="PRIMARY" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="PRIMARY" size="1">
    <sym id="33" cat="25" ent="IDENTIFIER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="8" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="PRIMARY" size="1">
    <sym id="35" cat="25" ent="STRING" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="9" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="PRIMARY" size="1">
    <sym id="34" cat="25" ent="NUMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="8" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="SEMANTIC_PART" size="1">
    <sym id="76" cat="25" ent="TRANSFORMATIONS" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="11" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="TRANSFORMATIONS" size="0">
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="12" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="TRANSFORMATIONS" size="2">
    <sym id="0" cat="0" ent="=>" />
    <sym id="81" cat="25" ent="TRANSFORMATION" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="13" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="TRANSFORMATIONS" size="3">
    <sym id="76" cat="25" ent="TRANSFORMATIONS" />
    <sym id="3" cat="3" ent="-" />
    <sym id="81" cat="25" ent="TRANSFORMATION" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="14" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="TRANSFORMATION" size="1">
    <sym id="86" cat="25" ent="DESTINATION" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="TRANSFORMATION" size="2">
    <sym id="81" cat="25" ent="TRANSFORMATION" />
    <sym id="87" cat="25" ent="ELEMENT" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="16" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="DESTINATION" size="1">
    <sym id="2" cat="2" ent="=" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="17" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="DESTINATION" size="1">
    <sym id="87" cat="25" ent="ELEMENT" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="18" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="DESTINATION" size="2">
    <sym id="93" cat="25" ent="SYMBOL" />
    <sym id="2" cat="2" ent="=" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="19" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="ELEMENT" size="1">
    <sym id="93" cat="25" ent="SYMBOL" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="20" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="ELEMENT" size="2">
    <sym id="7" cat="7" ent="#" />
    <sym id="34" cat="25" ent="NUMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="21" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="ELEMENT" size="1">
    <sym id="34" cat="25" ent="NUMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="22" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="ELEMENT" size="1">
    <sym id="35" cat="25" ent="STRING" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="23" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="ELEMENT" size="1">
    <sym id="14" cat="14" ent="@" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="24" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="ELEMENT" size="4">
    <sym id="93" cat="25" ent="SYMBOL" />
    <sym id="8" cat="8" ent="(" />
    <sym id="103" cat="25" ent="COMBINED_LIST" />
    <sym id="9" cat="9" ent=")" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="25" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="SYMBOL" size="1">
    <sym id="106" cat="25" ent="INCARNATION" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="SYMBOL" size="3">
    <sym id="106" cat="25" ent="INCARNATION" />
    <sym id="16" cat="16" ent="$" />
    <sym id="33" cat="25" ent="IDENTIFIER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="27" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="INCARNATION" size="1">
    <sym id="33" cat="25" ent="IDENTIFIER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="28" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="INCARNATION" size="3">
    <sym id="33" cat="25" ent="IDENTIFIER" />
    <sym id="15" cat="15" ent=":" />
    <sym id="34" cat="25" ent="NUMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="29" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="COMBINED_LIST" size="0">
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="30" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="COMBINED_LIST" size="2">
    <sym id="103" cat="25" ent="COMBINED_LIST" />
    <sym id="93" cat="25" ent="SYMBOL" />
    <sym id="0" cat="0" ent="" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="COMBINED_LIST" size="2">
    <sym id="103" cat="25" ent="COMBINED_LIST" />
    <sym id="34" cat="25" ent="NUMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="32" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="COMBINED_LIST" size="2">
    <sym id="103" cat="25" ent="COMBINED_LIST" />
    <sym id="35" cat="25" ent="STRING" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="33" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <prod left="COMBINED_LIST" size="3">
    <sym id="103" cat="25" ent="COMBINED_LIST" />
    <sym id="7" cat="7" ent="#" />
    <sym id="34" cat="25" ent="NUMBER" />
    <sym id="0" cat="0" ent="" />
    <sema act="16" inf="34" />
    <sema act="20" inf="0" />
  </prod>

  <store prev="0" />
  <grammar axiom="AXIOM">
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
      <sym id="29" cat="23" ent="/*------------------------------------------------------*/" />
      <sym id="30" cat="21" ent="\n" />
      <sym id="31" cat="25" ent="EOF" />
      <sym id="32" cat="22" ent=" " />
      <sym id="33" cat="25" ent="IDENTIFIER" />
      <sym id="34" cat="25" ent="NUMBER" />
      <sym id="35" cat="25" ent="STRING" />
      <sym id="36" cat="23" ent="/* Meta Grammar for Parsing of Transformation Grammars  \n   Georg Fischer 1980-08-01                             */" />
      <sym id="37" cat="23" ent="/*------------------------------------------------------*/" />
      <sym id="38" cat="25" ent="AXIOM" />
      <sym id="39" cat="25" ent="EXTRA_INPUT" />
      <sym id="40" cat="22" ent="    " />
      <sym id="41" cat="27" ent="[" />
      <sym id="42" cat="25" ent="GRAMMAR" />
      <sym id="43" cat="27" ent="]" />
      <sym id="44" cat="22" ent="        " />
      <sym id="45" cat="25" ent="RULES" />
      <sym id="46" cat="22" ent="                         " />
      <sym id="47" cat="26" ent="2" />
      <sym id="48" cat="22" ent="          " />
      <sym id="49" cat="25" ent="RULE" />
      <sym id="50" cat="22" ent="                " />
      <sym id="51" cat="27" ent="." />
      <sym id="52" cat="22" ent="           " />
      <sym id="53" cat="25" ent="LEFT_SIDE" />
      <sym id="54" cat="27" ent="=" />
      <sym id="55" cat="25" ent="RIGHT_SIDES" />
      <sym id="56" cat="22" ent="      " />
      <sym id="57" cat="22" ent="                    " />
      <sym id="58" cat="26" ent="3" />
      <sym id="59" cat="25" ent="RIGHT_SIDE" />
      <sym id="60" cat="27" ent="|" />
      <sym id="61" cat="22" ent="     " />
      <sym id="62" cat="25" ent="SYNTAX_PART" />
      <sym id="63" cat="25" ent="SEMANTIC_PART" />
      <sym id="64" cat="25" ent="MEMBERETIES" />
      <sym id="65" cat="22" ent="                   " />
      <sym id="66" cat="26" ent="6" />
      <sym id="67" cat="22" ent="                               " />
      <sym id="68" cat="26" ent="7" />
      <sym id="69" cat="25" ent="MEMBER" />
      <sym id="70" cat="22" ent="         " />
      <sym id="71" cat="25" ent="PRIMARY" />
      <sym id="72" cat="26" ent="8" />
      <sym id="73" cat="22" ent="                        " />
      <sym id="74" cat="26" ent="9" />
      <sym id="75" cat="22" ent="  " />
      <sym id="76" cat="25" ent="TRANSFORMATIONS" />
      <sym id="77" cat="22" ent="               " />
      <sym id="78" cat="26" ent="11" />
      <sym id="79" cat="26" ent="12" />
      <sym id="80" cat="27" ent="=>" />
      <sym id="81" cat="25" ent="TRANSFORMATION" />
      <sym id="82" cat="26" ent="13" />
      <sym id="83" cat="27" ent="->" />
      <sym id="84" cat="22" ent="                                                " />
      <sym id="85" cat="26" ent="14" />
      <sym id="86" cat="25" ent="DESTINATION" />
      <sym id="87" cat="25" ent="ELEMENT" />
      <sym id="88" cat="26" ent="16" />
      <sym id="89" cat="22" ent="                           " />
      <sym id="90" cat="26" ent="17" />
      <sym id="91" cat="22" ent="                       " />
      <sym id="92" cat="26" ent="18" />
      <sym id="93" cat="25" ent="SYMBOL" />
      <sym id="94" cat="26" ent="19" />
      <sym id="95" cat="26" ent="20" />
      <sym id="96" cat="27" ent="#" />
      <sym id="97" cat="26" ent="21" />
      <sym id="98" cat="26" ent="22" />
      <sym id="99" cat="26" ent="23" />
      <sym id="100" cat="27" ent="@" />
      <sym id="101" cat="26" ent="24" />
      <sym id="102" cat="27" ent="(" />
      <sym id="103" cat="25" ent="COMBINED_LIST" />
      <sym id="104" cat="27" ent=")" />
      <sym id="105" cat="26" ent="25" />
      <sym id="106" cat="25" ent="INCARNATION" />
      <sym id="107" cat="27" ent="$" />
      <sym id="108" cat="26" ent="27" />
      <sym id="109" cat="26" ent="28" />
      <sym id="110" cat="27" ent=":" />
      <sym id="111" cat="26" ent="29" />
      <sym id="112" cat="26" ent="30" />
      <sym id="113" cat="26" ent="32" />
      <sym id="114" cat="26" ent="33" />
      <sym id="115" cat="26" ent="34" />
    </symbolList>
    <rules>
      <rule left="EXTRA_INPUT">
        <prod left="EXTRA_INPUT" size="3">
          <sym id="5" cat="5" ent="[" />
          <sym id="42" cat="25" ent="GRAMMAR" />
          <sym id="6" cat="6" ent="]" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RIGHT_SIDES">
        <prod left="RIGHT_SIDES" size="1">
          <sym id="59" cat="25" ent="RIGHT_SIDE" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="RIGHT_SIDES" size="3">
          <sym id="55" cat="25" ent="RIGHT_SIDES" />
          <sym id="1" cat="1" ent="|" />
          <sym id="59" cat="25" ent="RIGHT_SIDE" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="PRIMARY">
        <prod left="PRIMARY" size="1">
          <sym id="33" cat="25" ent="IDENTIFIER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="8" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="PRIMARY" size="1">
          <sym id="35" cat="25" ent="STRING" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="9" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="PRIMARY" size="1">
          <sym id="34" cat="25" ent="NUMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="8" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="GRAMMAR">
        <prod left="GRAMMAR" size="1">
          <sym id="45" cat="25" ent="RULES" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="2" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="MEMBER">
        <prod left="MEMBER" size="1">
          <sym id="71" cat="25" ent="PRIMARY" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="SYMBOL">
        <prod left="SYMBOL" size="1">
          <sym id="106" cat="25" ent="INCARNATION" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="SYMBOL" size="3">
          <sym id="106" cat="25" ent="INCARNATION" />
          <sym id="16" cat="16" ent="$" />
          <sym id="33" cat="25" ent="IDENTIFIER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="27" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="COMBINED_LIST">
        <prod left="COMBINED_LIST" size="0">
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="30" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="2">
          <sym id="103" cat="25" ent="COMBINED_LIST" />
          <sym id="93" cat="25" ent="SYMBOL" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="2">
          <sym id="103" cat="25" ent="COMBINED_LIST" />
          <sym id="34" cat="25" ent="NUMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="32" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="2">
          <sym id="103" cat="25" ent="COMBINED_LIST" />
          <sym id="35" cat="25" ent="STRING" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="33" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="3">
          <sym id="103" cat="25" ent="COMBINED_LIST" />
          <sym id="7" cat="7" ent="#" />
          <sym id="34" cat="25" ent="NUMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="34" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="SEMANTIC_PART">
        <prod left="SEMANTIC_PART" size="1">
          <sym id="76" cat="25" ent="TRANSFORMATIONS" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="11" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="MEMBERETIES">
        <prod left="MEMBERETIES" size="0">
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="7" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="MEMBERETIES" size="2">
          <sym id="64" cat="25" ent="MEMBERETIES" />
          <sym id="69" cat="25" ent="MEMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="LEFT_SIDE">
        <prod left="LEFT_SIDE" size="1">
          <sym id="33" cat="25" ent="IDENTIFIER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="3" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RULE">
        <prod left="RULE" size="3">
          <sym id="53" cat="25" ent="LEFT_SIDE" />
          <sym id="2" cat="2" ent="=" />
          <sym id="55" cat="25" ent="RIGHT_SIDES" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="SYNTAX_PART">
        <prod left="SYNTAX_PART" size="1">
          <sym id="64" cat="25" ent="MEMBERETIES" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="6" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="HYPER_AXIOM">
        <prod left="HYPER_AXIOM" size="3">
          <sym id="20" cat="20" ent="EOF" />
          <sym id="38" cat="25" ent="AXIOM" />
          <sym id="20" cat="20" ent="EOF" />
          <sym id="0" cat="0" ent="" />
        </prod>
      </rule>
      <rule left="RULES">
        <prod left="RULES" size="1">
          <sym id="49" cat="25" ent="RULE" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="RULES" size="3">
          <sym id="45" cat="25" ent="RULES" />
          <sym id="4" cat="4" ent="." />
          <sym id="49" cat="25" ent="RULE" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="INCARNATION">
        <prod left="INCARNATION" size="1">
          <sym id="33" cat="25" ent="IDENTIFIER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="28" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="INCARNATION" size="3">
          <sym id="33" cat="25" ent="IDENTIFIER" />
          <sym id="15" cat="15" ent=":" />
          <sym id="34" cat="25" ent="NUMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="29" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="ELEMENT">
        <prod left="ELEMENT" size="1">
          <sym id="93" cat="25" ent="SYMBOL" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="20" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="2">
          <sym id="7" cat="7" ent="#" />
          <sym id="34" cat="25" ent="NUMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="21" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="1">
          <sym id="34" cat="25" ent="NUMBER" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="22" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="1">
          <sym id="35" cat="25" ent="STRING" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="23" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="1">
          <sym id="14" cat="14" ent="@" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="24" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="4">
          <sym id="93" cat="25" ent="SYMBOL" />
          <sym id="8" cat="8" ent="(" />
          <sym id="103" cat="25" ent="COMBINED_LIST" />
          <sym id="9" cat="9" ent=")" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="25" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RIGHT_SIDE">
        <prod left="RIGHT_SIDE" size="2">
          <sym id="62" cat="25" ent="SYNTAX_PART" />
          <sym id="63" cat="25" ent="SEMANTIC_PART" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="TRANSFORMATIONS">
        <prod left="TRANSFORMATIONS" size="0">
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="12" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="TRANSFORMATIONS" size="2">
          <sym id="0" cat="0" ent="=>" />
          <sym id="81" cat="25" ent="TRANSFORMATION" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="13" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="TRANSFORMATIONS" size="3">
          <sym id="76" cat="25" ent="TRANSFORMATIONS" />
          <sym id="3" cat="3" ent="-" />
          <sym id="81" cat="25" ent="TRANSFORMATION" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="14" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="DESTINATION">
        <prod left="DESTINATION" size="1">
          <sym id="2" cat="2" ent="=" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="17" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="DESTINATION" size="1">
          <sym id="87" cat="25" ent="ELEMENT" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="18" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="DESTINATION" size="2">
          <sym id="93" cat="25" ent="SYMBOL" />
          <sym id="2" cat="2" ent="=" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="19" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="AXIOM">
        <prod left="AXIOM" size="1">
          <sym id="39" cat="25" ent="EXTRA_INPUT" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="TRANSFORMATION">
        <prod left="TRANSFORMATION" size="1">
          <sym id="86" cat="25" ent="DESTINATION" />
          <sym id="0" cat="0" ent="" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="TRANSFORMATION" size="2">
          <sym id="81" cat="25" ent="TRANSFORMATION" />
          <sym id="87" cat="25" ent="ELEMENT" />
          <sym id="0" cat="0" ent="" />
          <sema act="16" inf="16" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
    <rules>
    <protos>
    </protos>
    <states>
    </states>
  </grammar>

</Parser>
[EXTRA_INPUT =EXTRA_INPUT = [ GRAMMAR ]
.RIGHT_SIDES =RIGHT_SIDES = RIGHT_SIDE
	| RIGHT_SIDES = RIGHT_SIDES | RIGHT_SIDE
.PRIMARY =PRIMARY = IDENTIFIER
	| PRIMARY = STRING
	| PRIMARY = NUMBER
.GRAMMAR =GRAMMAR = RULES
.MEMBER =MEMBER = PRIMARY
.SYMBOL =SYMBOL = INCARNATION
	| SYMBOL = INCARNATION $ IDENTIFIER
.COMBINED_LIST =COMBINED_LIST =
	| COMBINED_LIST = COMBINED_LIST SYMBOL
	| COMBINED_LIST = COMBINED_LIST NUMBER
	| COMBINED_LIST = COMBINED_LIST STRING
	| COMBINED_LIST = COMBINED_LIST # NUMBER
.SEMANTIC_PART =SEMANTIC_PART = TRANSFORMATIONS
.MEMBERETIES =MEMBERETIES =
	| MEMBERETIES = MEMBERETIES MEMBER
.LEFT_SIDE =LEFT_SIDE = IDENTIFIER
.RULE =RULE = LEFT_SIDE = RIGHT_SIDES
.SYNTAX_PART =SYNTAX_PART = MEMBERETIES
.HYPER_AXIOM =HYPER_AXIOM = EOF AXIOM EOF
.RULES =RULES = RULE
	| RULES = RULES . RULE
.INCARNATION =INCARNATION = IDENTIFIER
	| INCARNATION = IDENTIFIER : NUMBER
.ELEMENT =ELEMENT = SYMBOL
	| ELEMENT = # NUMBER
	| ELEMENT = NUMBER
	| ELEMENT = STRING
	| ELEMENT = @
	| ELEMENT = SYMBOL ( COMBINED_LIST )
.RIGHT_SIDE =RIGHT_SIDE = SYNTAX_PART SEMANTIC_PART
.TRANSFORMATIONS =TRANSFORMATIONS =
	| TRANSFORMATIONS = => TRANSFORMATION
	| TRANSFORMATIONS = TRANSFORMATIONS - TRANSFORMATION
.DESTINATION =DESTINATION = =
	| DESTINATION = ELEMENT
	| DESTINATION = SYMBOL =
.AXIOM =AXIOM = EXTRA_INPUT
.TRANSFORMATION =TRANSFORMATION = DESTINATION
	| TRANSFORMATION = TRANSFORMATION ELEMENT

]
10: 	@AXIOM -> 11 =: HYPER_AXIOM
11: 	@EOF -> 11 =: HYPER_AXIOM

