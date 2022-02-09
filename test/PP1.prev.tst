<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<ProtoParser>
  <scan finState="FINISH"><sym id="30" cat="24">/*------------------------------------------------------*/</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="32" cat="26">EOF</sym></scan>
  <scan finState="FINISH"><sym id="33" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="34" cat="26">IDENTIFIER</sym></scan>
  <scan finState="FINISH"><sym id="33" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="35" cat="26">NUMBER</sym></scan>
  <scan finState="FINISH"><sym id="33" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="36" cat="26">STRING</sym></scan>
  <scan finState="FINISH"><sym id="33" cat="23"> </sym></scan>
  <scan finState="FINISH"><sym id="14" cat="14">;</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="37" cat="24">/* Meta Grammar for Parsing of Transformation Grammars  \n   Georg Fischer 1980-08-01                             */</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <scan finState="FINISH"><sym id="38" cat="24">/*------------------------------------------------------*/</sym></scan>
  <scan finState="FINISH"><sym id="31" cat="22">\n</sym></scan>
  <store>AXIOM = EXTRA_INPUT</store>
  <store>EXTRA_INPUT = '[' GRAMMAR ']'</store>
  <store>GRAMMAR = RULES</store>
  <store>RULES = RULE</store>
  <store>RULES = RULES '.' RULE</store>
  <store>RULE = LEFT_SIDE '=' RIGHT_SIDES</store>
  <store>LEFT_SIDE = IDENTIFIER</store>
  <store>RIGHT_SIDES = RIGHT_SIDE</store>
  <store>RIGHT_SIDES = RIGHT_SIDES '|' RIGHT_SIDE</store>
  <store>RIGHT_SIDE = SYNTAX_PART SEMANTIC_PART</store>
  <store>SYNTAX_PART = MEMBERETIES</store>
  <store>MEMBERETIES =</store>
  <store>MEMBERETIES = MEMBERETIES MEMBER</store>
  <store>MEMBER = PRIMARY</store>
  <store>PRIMARY = IDENTIFIER</store>
  <store>PRIMARY = STRING</store>
  <store>PRIMARY = NUMBER</store>
  <store>SEMANTIC_PART = TRANSFORMATIONS</store>
  <store>TRANSFORMATIONS =</store>
  <store>TRANSFORMATIONS = '=&gt;' TRANSFORMATION</store>
  <store>TRANSFORMATIONS = TRANSFORMATIONS '-' TRANSFORMATION</store>
  <store>TRANSFORMATION = DESTINATION</store>
  <store>TRANSFORMATION = TRANSFORMATION ELEMENT</store>
  <store>DESTINATION = '='</store>
  <store>DESTINATION = ELEMENT</store>
  <store>DESTINATION = SYMBOL '='</store>
  <store>ELEMENT = SYMBOL</store>
  <store>ELEMENT = '#' NUMBER</store>
  <store>ELEMENT = NUMBER</store>
  <store>ELEMENT = STRING</store>
  <store>ELEMENT = '@'</store>
  <store>ELEMENT = SYMBOL '(' COMBINED_LIST ')'</store>
  <store>SYMBOL = INCARNATION</store>
  <store>SYMBOL = INCARNATION '$' IDENTIFIER</store>
  <store>INCARNATION = IDENTIFIER</store>
  <store>INCARNATION = IDENTIFIER ':' NUMBER</store>
  <store>COMBINED_LIST =</store>
  <store>COMBINED_LIST = COMBINED_LIST SYMBOL</store>
  <store>COMBINED_LIST = COMBINED_LIST NUMBER</store>
  <store>COMBINED_LIST = COMBINED_LIST STRING</store>
  <store>COMBINED_LIST = COMBINED_LIST '#' NUMBER</store>
  <grammar axiom="AXIOM">
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
      <sym id="30" cat="24" type="NESTCOM">/*------------------------------------------------------*/</sym>
      <sym id="31" cat="22" type="EOL">\n</sym>
      <sym id="32" cat="26" type="IDENTIFIER">EOF</sym>
      <sym id="33" cat="23" type="SPACE"> </sym>
      <sym id="34" cat="26" type="IDENTIFIER">IDENTIFIER</sym>
      <sym id="35" cat="26" type="IDENTIFIER">NUMBER</sym>
      <sym id="36" cat="26" type="IDENTIFIER">STRING</sym>
      <sym id="37" cat="24" type="NESTCOM">/* Meta Grammar for Parsing of Transformation Grammars  \n   Georg Fischer 1980-08-01                             */</sym>
      <sym id="38" cat="24" type="NESTCOM">/*------------------------------------------------------*/</sym>
      <sym id="39" cat="26" type="IDENTIFIER">AXIOM</sym>
      <sym id="40" cat="26" type="IDENTIFIER">EXTRA_INPUT</sym>
      <sym id="41" cat="23" type="SPACE">    </sym>
      <sym id="42" cat="28" type="STRING">[</sym>
      <sym id="43" cat="26" type="IDENTIFIER">GRAMMAR</sym>
      <sym id="44" cat="28" type="STRING">]</sym>
      <sym id="45" cat="23" type="SPACE">        </sym>
      <sym id="46" cat="26" type="IDENTIFIER">RULES</sym>
      <sym id="47" cat="23" type="SPACE">                         </sym>
      <sym id="48" cat="27" type="NUMBER">2</sym>
      <sym id="49" cat="23" type="SPACE">          </sym>
      <sym id="50" cat="26" type="IDENTIFIER">RULE</sym>
      <sym id="51" cat="23" type="SPACE">                </sym>
      <sym id="52" cat="28" type="STRING">.</sym>
      <sym id="53" cat="23" type="SPACE">           </sym>
      <sym id="54" cat="26" type="IDENTIFIER">LEFT_SIDE</sym>
      <sym id="55" cat="28" type="STRING">=</sym>
      <sym id="56" cat="26" type="IDENTIFIER">RIGHT_SIDES</sym>
      <sym id="57" cat="23" type="SPACE">      </sym>
      <sym id="58" cat="23" type="SPACE">                    </sym>
      <sym id="59" cat="27" type="NUMBER">3</sym>
      <sym id="60" cat="26" type="IDENTIFIER">RIGHT_SIDE</sym>
      <sym id="61" cat="28" type="STRING">|</sym>
      <sym id="62" cat="23" type="SPACE">     </sym>
      <sym id="63" cat="26" type="IDENTIFIER">SYNTAX_PART</sym>
      <sym id="64" cat="26" type="IDENTIFIER">SEMANTIC_PART</sym>
      <sym id="65" cat="26" type="IDENTIFIER">MEMBERETIES</sym>
      <sym id="66" cat="23" type="SPACE">                   </sym>
      <sym id="67" cat="27" type="NUMBER">6</sym>
      <sym id="68" cat="23" type="SPACE">                               </sym>
      <sym id="69" cat="27" type="NUMBER">7</sym>
      <sym id="70" cat="26" type="IDENTIFIER">MEMBER</sym>
      <sym id="71" cat="23" type="SPACE">         </sym>
      <sym id="72" cat="26" type="IDENTIFIER">PRIMARY</sym>
      <sym id="73" cat="27" type="NUMBER">8</sym>
      <sym id="74" cat="23" type="SPACE">                        </sym>
      <sym id="75" cat="27" type="NUMBER">9</sym>
      <sym id="76" cat="23" type="SPACE">  </sym>
      <sym id="77" cat="26" type="IDENTIFIER">TRANSFORMATIONS</sym>
      <sym id="78" cat="23" type="SPACE">               </sym>
      <sym id="79" cat="27" type="NUMBER">11</sym>
      <sym id="80" cat="27" type="NUMBER">12</sym>
      <sym id="81" cat="28" type="STRING">=&gt;</sym>
      <sym id="82" cat="26" type="IDENTIFIER">TRANSFORMATION</sym>
      <sym id="83" cat="27" type="NUMBER">13</sym>
      <sym id="84" cat="28" type="STRING">-&gt;</sym>
      <sym id="85" cat="23" type="SPACE">                                                </sym>
      <sym id="86" cat="27" type="NUMBER">14</sym>
      <sym id="87" cat="26" type="IDENTIFIER">DESTINATION</sym>
      <sym id="88" cat="26" type="IDENTIFIER">ELEMENT</sym>
      <sym id="89" cat="27" type="NUMBER">16</sym>
      <sym id="90" cat="23" type="SPACE">                           </sym>
      <sym id="91" cat="27" type="NUMBER">17</sym>
      <sym id="92" cat="23" type="SPACE">                       </sym>
      <sym id="93" cat="27" type="NUMBER">18</sym>
      <sym id="94" cat="26" type="IDENTIFIER">SYMBOL</sym>
      <sym id="95" cat="27" type="NUMBER">19</sym>
      <sym id="96" cat="27" type="NUMBER">20</sym>
      <sym id="97" cat="28" type="STRING">#</sym>
      <sym id="98" cat="27" type="NUMBER">21</sym>
      <sym id="99" cat="27" type="NUMBER">22</sym>
      <sym id="100" cat="27" type="NUMBER">23</sym>
      <sym id="101" cat="28" type="STRING">@</sym>
      <sym id="102" cat="27" type="NUMBER">24</sym>
      <sym id="103" cat="28" type="STRING">(</sym>
      <sym id="104" cat="26" type="IDENTIFIER">COMBINED_LIST</sym>
      <sym id="105" cat="28" type="STRING">)</sym>
      <sym id="106" cat="27" type="NUMBER">25</sym>
      <sym id="107" cat="26" type="IDENTIFIER">INCARNATION</sym>
      <sym id="108" cat="28" type="STRING">$</sym>
      <sym id="109" cat="27" type="NUMBER">27</sym>
      <sym id="110" cat="27" type="NUMBER">28</sym>
      <sym id="111" cat="28" type="STRING">:</sym>
      <sym id="112" cat="27" type="NUMBER">29</sym>
      <sym id="113" cat="27" type="NUMBER">30</sym>
      <sym id="114" cat="27" type="NUMBER">32</sym>
      <sym id="115" cat="27" type="NUMBER">33</sym>
      <sym id="116" cat="27" type="NUMBER">34</sym>
    </symbolList>
    <rules>
      <rule left="AXIOM">
        <prod left="AXIOM" size="1">
          <sym id="40" cat="26">EXTRA_INPUT</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="COMBINED_LIST">
        <prod left="COMBINED_LIST" size="0">
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="30" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="2">
          <sym id="104" cat="26">COMBINED_LIST</sym>
          <sym id="94" cat="26">SYMBOL</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="2">
          <sym id="104" cat="26">COMBINED_LIST</sym>
          <sym id="35" cat="26">NUMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="32" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="2">
          <sym id="104" cat="26">COMBINED_LIST</sym>
          <sym id="36" cat="26">STRING</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="33" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="COMBINED_LIST" size="3">
          <sym id="104" cat="26">COMBINED_LIST</sym>
          <sym id="8" cat="8">#</sym>
          <sym id="35" cat="26">NUMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="34" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="DESTINATION">
        <prod left="DESTINATION" size="1">
          <sym id="3" cat="3">=</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="17" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="DESTINATION" size="1">
          <sym id="88" cat="26">ELEMENT</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="18" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="DESTINATION" size="2">
          <sym id="94" cat="26">SYMBOL</sym>
          <sym id="3" cat="3">=</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="19" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="ELEMENT">
        <prod left="ELEMENT" size="1">
          <sym id="94" cat="26">SYMBOL</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="20" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="2">
          <sym id="8" cat="8">#</sym>
          <sym id="35" cat="26">NUMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="21" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="1">
          <sym id="35" cat="26">NUMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="22" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="1">
          <sym id="36" cat="26">STRING</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="23" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="1">
          <sym id="15" cat="15">@</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="24" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="ELEMENT" size="4">
          <sym id="94" cat="26">SYMBOL</sym>
          <sym id="9" cat="9">(</sym>
          <sym id="104" cat="26">COMBINED_LIST</sym>
          <sym id="10" cat="10">)</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="25" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="EXTRA_INPUT">
        <prod left="EXTRA_INPUT" size="3">
          <sym id="6" cat="6">[</sym>
          <sym id="43" cat="26">GRAMMAR</sym>
          <sym id="7" cat="7">]</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="GRAMMAR">
        <prod left="GRAMMAR" size="1">
          <sym id="46" cat="26">RULES</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="2" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="INCARNATION">
        <prod left="INCARNATION" size="1">
          <sym id="34" cat="26">IDENTIFIER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="28" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="INCARNATION" size="3">
          <sym id="34" cat="26">IDENTIFIER</sym>
          <sym id="16" cat="16">:</sym>
          <sym id="35" cat="26">NUMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="29" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="LEFT_SIDE">
        <prod left="LEFT_SIDE" size="1">
          <sym id="34" cat="26">IDENTIFIER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="3" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="MEMBER">
        <prod left="MEMBER" size="1">
          <sym id="72" cat="26">PRIMARY</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="MEMBERETIES">
        <prod left="MEMBERETIES" size="0">
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="7" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="MEMBERETIES" size="2">
          <sym id="65" cat="26">MEMBERETIES</sym>
          <sym id="70" cat="26">MEMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="PRIMARY">
        <prod left="PRIMARY" size="1">
          <sym id="34" cat="26">IDENTIFIER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="8" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="PRIMARY" size="1">
          <sym id="36" cat="26">STRING</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="9" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="PRIMARY" size="1">
          <sym id="35" cat="26">NUMBER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="8" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RIGHT_SIDE">
        <prod left="RIGHT_SIDE" size="2">
          <sym id="63" cat="26">SYNTAX_PART</sym>
          <sym id="64" cat="26">SEMANTIC_PART</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RIGHT_SIDES">
        <prod left="RIGHT_SIDES" size="1">
          <sym id="60" cat="26">RIGHT_SIDE</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
        <prod left="RIGHT_SIDES" size="3">
          <sym id="56" cat="26">RIGHT_SIDES</sym>
          <sym id="2" cat="2">|</sym>
          <sym id="60" cat="26">RIGHT_SIDE</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RULE">
        <prod left="RULE" size="3">
          <sym id="54" cat="26">LEFT_SIDE</sym>
          <sym id="3" cat="3">=</sym>
          <sym id="56" cat="26">RIGHT_SIDES</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="RULES">
        <prod left="RULES" size="1">
          <sym id="50" cat="26">RULE</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
        <prod left="RULES" size="3">
          <sym id="46" cat="26">RULES</sym>
          <sym id="5" cat="5">.</sym>
          <sym id="50" cat="26">RULE</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="SEMANTIC_PART">
        <prod left="SEMANTIC_PART" size="1">
          <sym id="77" cat="26">TRANSFORMATIONS</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="11" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="SYMBOL">
        <prod left="SYMBOL" size="1">
          <sym id="107" cat="26">INCARNATION</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
        <prod left="SYMBOL" size="3">
          <sym id="107" cat="26">INCARNATION</sym>
          <sym id="17" cat="17">$</sym>
          <sym id="34" cat="26">IDENTIFIER</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="27" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="SYNTAX_PART">
        <prod left="SYNTAX_PART" size="1">
          <sym id="65" cat="26">MEMBERETIES</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="6" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="TRANSFORMATION">
        <prod left="TRANSFORMATION" size="1">
          <sym id="87" cat="26">DESTINATION</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="20" inf="0" />
        </prod>
        <prod left="TRANSFORMATION" size="2">
          <sym id="82" cat="26">TRANSFORMATION</sym>
          <sym id="88" cat="26">ELEMENT</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="16" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
      <rule left="TRANSFORMATIONS">
        <prod left="TRANSFORMATIONS" size="0">
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="12" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="TRANSFORMATIONS" size="2">
          <sym id="1" cat="1">=&gt;</sym>
          <sym id="82" cat="26">TRANSFORMATION</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="13" />
          <sema act="20" inf="0" />
        </prod>
        <prod left="TRANSFORMATIONS" size="3">
          <sym id="77" cat="26">TRANSFORMATIONS</sym>
          <sym id="4" cat="4">-</sym>
          <sym id="82" cat="26">TRANSFORMATION</sym>
          <sym id="0" cat="0">EOP</sym>
          <sema act="16" inf="14" />
          <sema act="20" inf="0" />
        </prod>
      </rule>
    </rules>
  </grammar>
  <legibleGrammar>
[AXIOM = EXTRA_INPUT
.EXTRA_INPUT = '[' GRAMMAR ']'
.GRAMMAR = RULES
.RULES = RULE
	| RULES '.' RULE
.RULE = LEFT_SIDE '=' RIGHT_SIDES
.LEFT_SIDE = IDENTIFIER
.RIGHT_SIDES = RIGHT_SIDE
	| RIGHT_SIDES '|' RIGHT_SIDE
.RIGHT_SIDE = SYNTAX_PART SEMANTIC_PART
.SYNTAX_PART = MEMBERETIES
.SEMANTIC_PART = TRANSFORMATIONS
.MEMBERETIES =
	| MEMBERETIES MEMBER
.MEMBER = PRIMARY
.PRIMARY = IDENTIFIER
	| STRING
	| NUMBER
.TRANSFORMATIONS =
	| '=&gt;' TRANSFORMATION
	| TRANSFORMATIONS '-' TRANSFORMATION
.TRANSFORMATION = DESTINATION
	| TRANSFORMATION ELEMENT
.DESTINATION = '='
	| ELEMENT
	| SYMBOL '='
.ELEMENT = SYMBOL
	| '#' NUMBER
	| NUMBER
	| STRING
	| '@'
	| SYMBOL '(' COMBINED_LIST ')'
.SYMBOL = INCARNATION
	| INCARNATION '$' IDENTIFIER
.COMBINED_LIST =
	| COMBINED_LIST SYMBOL
	| COMBINED_LIST NUMBER
	| COMBINED_LIST STRING
	| COMBINED_LIST '#' NUMBER
.INCARNATION = IDENTIFIER
	| IDENTIFIER ':' NUMBER
]
  </legibleGrammar>
  <legibleTable>

  </legibleTable>
</ProtoParser>
