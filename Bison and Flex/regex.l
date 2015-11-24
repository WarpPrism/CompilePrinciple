%{
	#include <stdlib.h>
	#include <stdio.h>
	#include "regex.tab.h"	
%}

%%

[a-zA-Z]|\.|-|\\|\"|\ |\'|[\ ]*  {strcpy(yylval.leaf, yytext); return Leaf;}
"(?" {return Cap;}
"*?" {return NgStar;}
"+?" {return NgPlus;}
"??" {return NgQuest;}
"|" {return '|';}
"+" {return '+';}
"?" {return '?';}
"*" {return '*';}
"(" {return '(';}
")" {return ')';}
"\n" {return '\n';}
[\t]+ {}
(.) {/*yyerror("Unknown Error");*/}

%%
