%{
#include <stdio.h>
#include <stdlib.h>
%}

keyword (strict)|(STRICT)|(graph)|(GRAPH)|(digraph)|(DIGRAPH)|(subgraph)|(SUBGRAPH)|(node)|(NODE)|(edge)|(EDGE)|(label)|(LABEL)
entity ([a-zA-Z_][0-9a-zA-Z_]*)|((\")((.)*)(\"))|([1-9][0-9]*)
others (--)|(->)|(=)
separator (\;)|(\,)|(\{)|(\})|(\[)|(\])
space "\ "|"\t"|"\n"
notes (("//")(.)*)|(("/*")(.)*("*/"))|([#](.)*)

%%

{keyword} {
	printf("%s\n", yytext);
}

{separator} {
	printf("%s\n", yytext);
}

{entity} {
	printf("%s\n", yytext);
}

{others} {
	printf("%s\n", yytext);
}

{space} {
	// Ignore
}

{notes} {
	// Ignore
}

%%
