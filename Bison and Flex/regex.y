%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#include <math.h>
	void yyerror(char const *s);

	int ParenCount = 1;

	struct Node {
		char type[10];
		char* value;
		struct Node* child1;
		struct Node* child2;
	};

	struct Node* createLeaf(char* _value) {
		/*printf("%c\n", *_value);*/
		struct Node* node = (struct Node*)malloc(sizeof(struct Node));
		if (node == NULL) {
			printf("Out of memory!\n");
			exit(1);
		}
		if (*_value == '.') {
			char dot[] = {"Dot\0"};
			/*node->type = (char*)malloc(sizeof(dot));*/
			strcpy(node->type, dot);
		} else {
			char lit[] = {"Lit\0"};
			/*node->type = (char*)malloc(sizeof(lit));*/
			strcpy(node->type, lit);
		}
		node->value = (char*)malloc(sizeof(_value));
		strcpy(node->value, _value);
		node->child1 = node->child2 = NULL;
		return node;
	}

	struct Node* createNode1(char* _type, struct Node* child) {
		struct Node* node = (struct Node*)malloc(sizeof(struct Node));
		if (node == NULL) {
			printf("Out of memory!\n");
			exit(1);
		}
		/*node->type = (char*)malloc(sizeof(_type));*/
		strcpy(node->type, _type);
		/**(node->value) = '0';*/
		node->child1 = child;
		node->child2 = NULL;
		return node;
	}

	struct Node* createNode2(char* _type, struct Node* left, struct Node* right) {
		struct Node* node = (struct Node*)malloc(sizeof(struct Node));
		if (node == NULL) {
			printf("Out of memory!\n");
			exit(1);
		}
		/*node->type = (char*)malloc(sizeof(_type));*/
		strcpy(node->type, _type);
		/**(node->value) = '0';*/
		node->child1 = left;
		node->child2 = right;
		return node;
	}

	// First Order Print The Tree.
	void printTree(struct Node* root) {
		if (root == NULL) return;
		struct Node* p = (struct Node*)malloc(sizeof(struct Node));
		p = root;
		while (p != NULL) {
			if (strcmp(p->type, "Dot") == 0) {
				printf("Dot");
				free(p);
				return;
			} else if (strcmp(p->type, "Lit") == 0) {
				printf("Lit(");
				printf("%c)", *(p->value));
				free(p);
				return;
			} else if (strcmp(p->type, "Paren") == 0) {
				printf("%s(%d", p->type, ParenCount);
				ParenCount++;
				// Recursion Print
				printTree(p);
				printf(")");
			} else {
				printf("%s(", p->type);
				// Recursion Print
				printTree(p);
				printf(")");
			}
			if (p->child1 != NULL) {
				p = p->child1;
			} else {
				p = p->child2;
			}
		}
	}

	void  printT(struct Node* node) {
		if(node == NULL) return;
		/*首先判断是 Lit Dot Paren 还是 其他*/
		/*Lit*/
		if (strcmp(node->type,"Lit")==0) {printf("Lit(%c)", *(node->value)); free(node); return;}
		/*Dot*/
		if (strcmp(node->type,"Dot")==0) {printf("Dot"); free(node); return;}
		/*Paren*/
		if (strcmp(node->type,"Paren")==0)
		{
			/* code */
			printf("Paren(%d, ",ParenCount);
			ParenCount++;
			printT(node->child1);
			printf(")");
			/*结束的时候释放掉内存*/
			free(node);
			return;
		}
		/*else*/
			/* code */
			printf("%s(", node->type);
			printT(node->child1);
			if(node->child2 != NULL){
				printf(", ");
				printT(node->child2);
			} 
			printf(")");
			/*结束的时候释放掉内存*/
			free(node);
	}
%}

%union {
	char leaf[10];
	struct Node* n;
}

%token <leaf>Leaf Cap NgStar NgPlus NgQuest

%%

input:/*empty*/
	| input line
;
line: '\n'
	| exp1 '\n'				{ParenCount = 1; printT($<n>1); printf("\n");}
;
exp1: exp2					{$<n>$ = $<n>1;}
	| exp1 '|' exp2			{$<n>$ = createNode2("Alt", $<n>1, $<n>3);}
;
exp2: exp3					{$<n>$ = $<n>1;}
	| exp2 exp3				{$<n>$ = createNode2("Cat", $<n>1, $<n>2);}
; 
exp3: exp4					{$<n>$ = $<n>1;}
	| exp4 '*'				{$<n>$ = createNode1("Star", $<n>1);}
	| exp4 '+'				{$<n>$ = createNode1("Plus", $<n>1);}
	| exp4 '?'				{$<n>$ = createNode1("Quest", $<n>1);}
	| exp4 NgStar			{$<n>$ = createNode1("NgStar", $<n>1);}
	| exp4 NgPlus			{$<n>$ = createNode1("NgPlus", $<n>1);}
	| exp4 NgQuest			{$<n>$ = createNode1("NgQuest", $<n>1);}
;
exp4: Leaf 					{char* c = $<leaf>1; $<n>$ = createLeaf(c);}
	| '(' exp1 ')'			{$<n>$ = createNode1("Paren", $<n>2);}
	| Cap exp1 ')'			{$<n>$ = $<n>2;}
;

%%

int main() {
	return yyparse();
}

void yyerror(char const *s) {
	fprintf (stderr, "%s\n", s);
}