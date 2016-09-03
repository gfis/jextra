<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<mainScanner>
<sym id="29" cat="24">/*------------------------------------------------------*/</sym>
<sym id="30" cat="22">\n</sym>
<sym id="31" cat="26">EOF</sym>
<sym id="32" cat="23"> </sym>
<sym id="33" cat="26">IDENTIFIER</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="32" cat="23"> </sym>
<sym id="35" cat="26">STRING</sym>
<sym id="32" cat="23"> </sym>
<sym id="14" cat="14">;</sym>
<sym id="30" cat="22">\n</sym>
<sym id="36" cat="24">/* Meta Grammar for Parsing of Transformation Grammars  \n   Georg Fischer 1980-08-01                             */</sym>
<sym id="30" cat="22">\n</sym>
<sym id="37" cat="24">/*------------------------------------------------------*/</sym>
<sym id="30" cat="22">\n</sym>
<sym id="6" cat="6">[</sym>
<sym id="38" cat="26">AXIOM</sym>
<sym id="32" cat="23"> </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="39" cat="26">EXTRA_INPUT</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="39" cat="26">EXTRA_INPUT</sym>
<sym id="40" cat="23">    </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="41" cat="28">[</sym>
<sym id="32" cat="23"> </sym>
<sym id="42" cat="26">GRAMMAR</sym>
<sym id="32" cat="23"> </sym>
<sym id="43" cat="28">]</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="42" cat="26">GRAMMAR</sym>
<sym id="44" cat="23">        </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="45" cat="26">RULES</sym>
<sym id="46" cat="23">                         </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="47" cat="27">2</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="45" cat="26">RULES</sym>
<sym id="48" cat="23">          </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="49" cat="26">RULE</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="45" cat="26">RULES</sym>
<sym id="32" cat="23"> </sym>
<sym id="51" cat="28">.</sym>
<sym id="32" cat="23"> </sym>
<sym id="49" cat="26">RULE</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="49" cat="26">RULE</sym>
<sym id="52" cat="23">           </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="53" cat="26">LEFT_SIDE</sym>
<sym id="32" cat="23"> </sym>
<sym id="54" cat="28">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="55" cat="26">RIGHT_SIDES</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="53" cat="26">LEFT_SIDE</sym>
<sym id="56" cat="23">      </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="33" cat="26">IDENTIFIER</sym>
<sym id="57" cat="23">                    </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="58" cat="27">3</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="55" cat="26">RIGHT_SIDES</sym>
<sym id="40" cat="23">    </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="59" cat="26">RIGHT_SIDE</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="55" cat="26">RIGHT_SIDES</sym>
<sym id="32" cat="23"> </sym>
<sym id="60" cat="28">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="59" cat="26">RIGHT_SIDE</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="59" cat="26">RIGHT_SIDE</sym>
<sym id="61" cat="23">     </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="62" cat="26">SYNTAX_PART</sym>
<sym id="32" cat="23"> </sym>
<sym id="63" cat="26">SEMANTIC_PART</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="62" cat="26">SYNTAX_PART</sym>
<sym id="40" cat="23">    </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="64" cat="26">MEMBERETIES</sym>
<sym id="65" cat="23">                   </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="66" cat="27">6</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="64" cat="26">MEMBERETIES</sym>
<sym id="40" cat="23">    </sym>
<sym id="3" cat="3">=</sym>
<sym id="67" cat="23">                               </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="68" cat="27">7</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="64" cat="26">MEMBERETIES</sym>
<sym id="32" cat="23"> </sym>
<sym id="69" cat="26">MEMBER</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="69" cat="26">MEMBER</sym>
<sym id="70" cat="23">         </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="71" cat="26">PRIMARY</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="71" cat="26">PRIMARY</sym>
<sym id="44" cat="23">        </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="33" cat="26">IDENTIFIER</sym>
<sym id="57" cat="23">                    </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="72" cat="27">8</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="35" cat="26">STRING</sym>
<sym id="73" cat="23">                        </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="74" cat="27">9</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="73" cat="23">                        </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="72" cat="27">8</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="63" cat="26">SEMANTIC_PART</sym>
<sym id="75" cat="23">  </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="76" cat="26">TRANSFORMATIONS</sym>
<sym id="77" cat="23">               </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="78" cat="27">11</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="76" cat="26">TRANSFORMATIONS</sym>
<sym id="3" cat="3">=</sym>
<sym id="67" cat="23">                               </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="79" cat="27">12</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="80" cat="28">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="81" cat="26">TRANSFORMATION</sym>
<sym id="52" cat="23">           </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="82" cat="27">13</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="76" cat="26">TRANSFORMATIONS</sym>
<sym id="32" cat="23"> </sym>
<sym id="83" cat="28">-&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="81" cat="26">TRANSFORMATION</sym>
<sym id="30" cat="22">\n</sym>
<sym id="84" cat="23">                                                </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="85" cat="27">14</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="81" cat="26">TRANSFORMATION</sym>
<sym id="32" cat="23"> </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="86" cat="26">DESTINATION</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="81" cat="26">TRANSFORMATION</sym>
<sym id="32" cat="23"> </sym>
<sym id="87" cat="26">ELEMENT</sym>
<sym id="44" cat="23">        </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="88" cat="27">16</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="86" cat="26">DESTINATION</sym>
<sym id="40" cat="23">    </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="54" cat="28">=</sym>
<sym id="89" cat="23">                           </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="90" cat="27">17</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="87" cat="26">ELEMENT</sym>
<sym id="91" cat="23">                       </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="92" cat="27">18</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="93" cat="26">SYMBOL</sym>
<sym id="32" cat="23"> </sym>
<sym id="54" cat="28">=</sym>
<sym id="57" cat="23">                    </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="94" cat="27">19</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="87" cat="26">ELEMENT</sym>
<sym id="44" cat="23">        </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="93" cat="26">SYMBOL</sym>
<sym id="73" cat="23">                        </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="95" cat="27">20</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="96" cat="28">#</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="57" cat="23">                    </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="97" cat="27">21</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="73" cat="23">                        </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="98" cat="27">22</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="35" cat="26">STRING</sym>
<sym id="73" cat="23">                        </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="99" cat="27">23</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="100" cat="28">@</sym>
<sym id="89" cat="23">                           </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="101" cat="27">24</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="93" cat="26">SYMBOL</sym>
<sym id="32" cat="23"> </sym>
<sym id="102" cat="28">(</sym>
<sym id="32" cat="23"> </sym>
<sym id="103" cat="26">COMBINED_LIST</sym>
<sym id="32" cat="23"> </sym>
<sym id="104" cat="28">)</sym>
<sym id="75" cat="23">  </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="105" cat="27">25</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="93" cat="26">SYMBOL</sym>
<sym id="70" cat="23">         </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="106" cat="26">INCARNATION</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="106" cat="26">INCARNATION</sym>
<sym id="32" cat="23"> </sym>
<sym id="107" cat="28">$</sym>
<sym id="32" cat="23"> </sym>
<sym id="33" cat="26">IDENTIFIER</sym>
<sym id="40" cat="23">    </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="108" cat="27">27</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="106" cat="26">INCARNATION</sym>
<sym id="40" cat="23">    </sym>
<sym id="3" cat="3">=</sym>
<sym id="32" cat="23"> </sym>
<sym id="33" cat="26">IDENTIFIER</sym>
<sym id="57" cat="23">                    </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="109" cat="27">28</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="33" cat="26">IDENTIFIER</sym>
<sym id="32" cat="23"> </sym>
<sym id="110" cat="28">:</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="70" cat="23">         </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="111" cat="27">29</sym>
<sym id="30" cat="22">\n</sym>
<sym id="5" cat="5">.</sym>
<sym id="103" cat="26">COMBINED_LIST</sym>
<sym id="75" cat="23">  </sym>
<sym id="3" cat="3">=</sym>
<sym id="67" cat="23">                               </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="112" cat="27">30</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="103" cat="26">COMBINED_LIST</sym>
<sym id="32" cat="23"> </sym>
<sym id="93" cat="26">SYMBOL</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="103" cat="26">COMBINED_LIST</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="48" cat="23">          </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="113" cat="27">32</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="103" cat="26">COMBINED_LIST</sym>
<sym id="32" cat="23"> </sym>
<sym id="35" cat="26">STRING</sym>
<sym id="48" cat="23">          </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="114" cat="27">33</sym>
<sym id="30" cat="22">\n</sym>
<sym id="50" cat="23">                </sym>
<sym id="2" cat="2">|</sym>
<sym id="32" cat="23"> </sym>
<sym id="103" cat="26">COMBINED_LIST</sym>
<sym id="32" cat="23"> </sym>
<sym id="96" cat="28">#</sym>
<sym id="32" cat="23"> </sym>
<sym id="34" cat="26">NUMBER</sym>
<sym id="56" cat="23">      </sym>
<sym id="1" cat="1">=&gt;</sym>
<sym id="32" cat="23"> </sym>
<sym id="8" cat="8">#</sym>
<sym id="115" cat="27">34</sym>
<sym id="30" cat="22">\n</sym>
<sym id="7" cat="7">]</sym>
<sym id="30" cat="22">\n</sym>
<sym id="32" cat="23"> </sym>
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
  <sym id="29" cat="24" type="NESTCOM">/*------------------------------------------------------*/</sym>
  <sym id="30" cat="22" type="EOL">\n</sym>
  <sym id="31" cat="26" type="IDENTIFIER">EOF</sym>
  <sym id="32" cat="23" type="SPACE"> </sym>
  <sym id="33" cat="26" type="IDENTIFIER">IDENTIFIER</sym>
  <sym id="34" cat="26" type="IDENTIFIER">NUMBER</sym>
  <sym id="35" cat="26" type="IDENTIFIER">STRING</sym>
  <sym id="36" cat="24" type="NESTCOM">/* Meta Grammar for Parsing of Transformation Grammars  \n   Georg Fischer 1980-08-01                             */</sym>
  <sym id="37" cat="24" type="NESTCOM">/*------------------------------------------------------*/</sym>
  <sym id="38" cat="26" type="IDENTIFIER">AXIOM</sym>
  <sym id="39" cat="26" type="IDENTIFIER">EXTRA_INPUT</sym>
  <sym id="40" cat="23" type="SPACE">    </sym>
  <sym id="41" cat="28" type="STRING">[</sym>
  <sym id="42" cat="26" type="IDENTIFIER">GRAMMAR</sym>
  <sym id="43" cat="28" type="STRING">]</sym>
  <sym id="44" cat="23" type="SPACE">        </sym>
  <sym id="45" cat="26" type="IDENTIFIER">RULES</sym>
  <sym id="46" cat="23" type="SPACE">                         </sym>
  <sym id="47" cat="27" type="NUMBER">2</sym>
  <sym id="48" cat="23" type="SPACE">          </sym>
  <sym id="49" cat="26" type="IDENTIFIER">RULE</sym>
  <sym id="50" cat="23" type="SPACE">                </sym>
  <sym id="51" cat="28" type="STRING">.</sym>
  <sym id="52" cat="23" type="SPACE">           </sym>
  <sym id="53" cat="26" type="IDENTIFIER">LEFT_SIDE</sym>
  <sym id="54" cat="28" type="STRING">=</sym>
  <sym id="55" cat="26" type="IDENTIFIER">RIGHT_SIDES</sym>
  <sym id="56" cat="23" type="SPACE">      </sym>
  <sym id="57" cat="23" type="SPACE">                    </sym>
  <sym id="58" cat="27" type="NUMBER">3</sym>
  <sym id="59" cat="26" type="IDENTIFIER">RIGHT_SIDE</sym>
  <sym id="60" cat="28" type="STRING">|</sym>
  <sym id="61" cat="23" type="SPACE">     </sym>
  <sym id="62" cat="26" type="IDENTIFIER">SYNTAX_PART</sym>
  <sym id="63" cat="26" type="IDENTIFIER">SEMANTIC_PART</sym>
  <sym id="64" cat="26" type="IDENTIFIER">MEMBERETIES</sym>
  <sym id="65" cat="23" type="SPACE">                   </sym>
  <sym id="66" cat="27" type="NUMBER">6</sym>
  <sym id="67" cat="23" type="SPACE">                               </sym>
  <sym id="68" cat="27" type="NUMBER">7</sym>
  <sym id="69" cat="26" type="IDENTIFIER">MEMBER</sym>
  <sym id="70" cat="23" type="SPACE">         </sym>
  <sym id="71" cat="26" type="IDENTIFIER">PRIMARY</sym>
  <sym id="72" cat="27" type="NUMBER">8</sym>
  <sym id="73" cat="23" type="SPACE">                        </sym>
  <sym id="74" cat="27" type="NUMBER">9</sym>
  <sym id="75" cat="23" type="SPACE">  </sym>
  <sym id="76" cat="26" type="IDENTIFIER">TRANSFORMATIONS</sym>
  <sym id="77" cat="23" type="SPACE">               </sym>
  <sym id="78" cat="27" type="NUMBER">11</sym>
  <sym id="79" cat="27" type="NUMBER">12</sym>
  <sym id="80" cat="28" type="STRING">=&gt;</sym>
  <sym id="81" cat="26" type="IDENTIFIER">TRANSFORMATION</sym>
  <sym id="82" cat="27" type="NUMBER">13</sym>
  <sym id="83" cat="28" type="STRING">-&gt;</sym>
  <sym id="84" cat="23" type="SPACE">                                                </sym>
  <sym id="85" cat="27" type="NUMBER">14</sym>
  <sym id="86" cat="26" type="IDENTIFIER">DESTINATION</sym>
  <sym id="87" cat="26" type="IDENTIFIER">ELEMENT</sym>
  <sym id="88" cat="27" type="NUMBER">16</sym>
  <sym id="89" cat="23" type="SPACE">                           </sym>
  <sym id="90" cat="27" type="NUMBER">17</sym>
  <sym id="91" cat="23" type="SPACE">                       </sym>
  <sym id="92" cat="27" type="NUMBER">18</sym>
  <sym id="93" cat="26" type="IDENTIFIER">SYMBOL</sym>
  <sym id="94" cat="27" type="NUMBER">19</sym>
  <sym id="95" cat="27" type="NUMBER">20</sym>
  <sym id="96" cat="28" type="STRING">#</sym>
  <sym id="97" cat="27" type="NUMBER">21</sym>
  <sym id="98" cat="27" type="NUMBER">22</sym>
  <sym id="99" cat="27" type="NUMBER">23</sym>
  <sym id="100" cat="28" type="STRING">@</sym>
  <sym id="101" cat="27" type="NUMBER">24</sym>
  <sym id="102" cat="28" type="STRING">(</sym>
  <sym id="103" cat="26" type="IDENTIFIER">COMBINED_LIST</sym>
  <sym id="104" cat="28" type="STRING">)</sym>
  <sym id="105" cat="27" type="NUMBER">25</sym>
  <sym id="106" cat="26" type="IDENTIFIER">INCARNATION</sym>
  <sym id="107" cat="28" type="STRING">$</sym>
  <sym id="108" cat="27" type="NUMBER">27</sym>
  <sym id="109" cat="27" type="NUMBER">28</sym>
  <sym id="110" cat="28" type="STRING">:</sym>
  <sym id="111" cat="27" type="NUMBER">29</sym>
  <sym id="112" cat="27" type="NUMBER">30</sym>
  <sym id="113" cat="27" type="NUMBER">32</sym>
  <sym id="114" cat="27" type="NUMBER">33</sym>
  <sym id="115" cat="27" type="NUMBER">34</sym>
</symbolList>
</mainScanner>
