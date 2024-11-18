%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

int yylex();
void yyerror(char const *s);

extern FILE *yyin;

int node_count = 0;
int tree_count = 0;

typedef struct {
    int from;
    int to;
} Edge;

Edge edges[100];
int edge_count = 0;
char labels[100][50];  // labels de los nodos

char* newNode(char* label) {
    char* nodeId = (char*)malloc(20);
    sprintf(nodeId, "node%d", node_count);
    strcpy(labels[node_count], label);
    node_count++;
    return nodeId;
}

void writeEdge(char* from, char* to) {
    int fromNum, toNum;
    sscanf(from, "node%d", &fromNum);
    sscanf(to, "node%d", &toNum);
    edges[edge_count].from = fromNum;
    edges[edge_count].to = toNum;
    edge_count++;
}

void getNodeOrder(int currentNode, int* visited, int* order, int* orderIndex) {
    int i;
    if (visited[currentNode]) return;
    visited[currentNode] = 1;

    order[(*orderIndex)++] = currentNode;
    
    for (i = 0; i < edge_count; i++) {
        if (edges[i].from == currentNode) {
            getNodeOrder(edges[i].to, visited, order, orderIndex);
        }
    }
}

void startTree() {
    int i;
    int rootNode = -1;
    int isChild[100] = {0};
    int visited[100] = {0};
    int order[100];
    int orderIndex = 0;

    if (tree_count > 0) {
        for (i = 0; i < edge_count; i++) {
            isChild[edges[i].to] = 1;
        }
        for (i = 0; i < node_count; i++) {
            if (!isChild[i]) {
                rootNode = i;
                break;
            }
        }

        getNodeOrder(rootNode, visited, order, &orderIndex);

        printf("digraph Tree%d {\n  node [shape=box];\n", tree_count - 1);

        for (i = 0; i < orderIndex; i++) {
            printf("  node%d [label=\"%s\"];\n", order[i], labels[order[i]]);
        }

        for (i = 0; i < edge_count; i++) {
            printf("  node%d -> node%d;\n", edges[i].from, edges[i].to);
        }

        printf("}\n\n");
    }

    tree_count++;
    node_count = 0;
    edge_count = 0;
}

%}

%union {
    char* nodeId;
}

%left plus minus
%left multiply divide

%token COMMENT floatdcl intdcl print id inum fnum assign plus minus multiply divide
%type <nodeId> declaration instruction statement expression COMMENT floatdcl intdcl print id inum fnum

%%

program: 
    | program line
    ;

line: declaration '\n'    { startTree(); }
    | instruction '\n'    { startTree(); }
    | statement '\n'      { startTree(); }
    | '\n'               /* Ignorar líneas vacías */
    ;

declaration: 
      floatdcl id {
          char* declNode = newNode("declaration");
          char* floatNode = newNode("floatdcl");
          char* idNode = newNode("id");
          writeEdge(declNode, floatNode);
          writeEdge(declNode, idNode);
          $$ = declNode;
      }
    | intdcl id {
          char* declNode = newNode("declaration");
          char* intNode = newNode("intdcl");
          char* idNode = newNode("id");
          writeEdge(declNode, intNode);
          writeEdge(declNode, idNode);
          $$ = declNode;
      }
    | COMMENT {
          char* declNode = newNode("declaration");
          char* commentNode = newNode("comment");
          writeEdge(declNode, commentNode);
          $$ = declNode;
      }
    ;

instruction: print id {
          char* instrNode = newNode("instruction");
          char* printNode = newNode("print");
          char* idNode = newNode("id");
          writeEdge(instrNode, printNode);
          writeEdge(instrNode, idNode);
          $$ = instrNode;
      }
    ;

statement: id assign expression {
          char* stmtNode = newNode("statement");
          char* idNode = newNode("id");
          char* assignNode = newNode("assign");
          writeEdge(stmtNode, idNode);
          writeEdge(stmtNode, assignNode);
          writeEdge(stmtNode, $3);
          $$ = stmtNode;
      }
    ;

expression: 
      expression plus expression {
          char* exprNode = newNode("expression");
          char* opNode = newNode("plus");
          writeEdge(exprNode, $1);
          writeEdge(exprNode, opNode);
          writeEdge(exprNode, $3);
          $$ = exprNode;
      }
    | expression minus expression {
          char* exprNode = newNode("expression");
          char* opNode = newNode("minus");
          writeEdge(exprNode, $1);
          writeEdge(exprNode, opNode);
          writeEdge(exprNode, $3);
          $$ = exprNode;
      }
    | expression multiply expression {
          char* exprNode = newNode("expression");
          char* opNode = newNode("multiply");
          writeEdge(exprNode, $1);
          writeEdge(exprNode, opNode);
          writeEdge(exprNode, $3);
          $$ = exprNode;
      }
    | expression divide expression {
          char* exprNode = newNode("expression");
          char* opNode = newNode("divide");
          writeEdge(exprNode, $1);
          writeEdge(exprNode, opNode);
          writeEdge(exprNode, $3);
          $$ = exprNode;
      }
    | fnum {
          char* exprNode = newNode("expression");
          char* valNode = newNode("fnum");
          writeEdge(exprNode, valNode);
          $$ = exprNode;
      }
    | inum {
          char* exprNode = newNode("expression");
          char* valNode = newNode("inum");
          writeEdge(exprNode, valNode);
          $$ = exprNode;
      }
    | id {
          char* exprNode = newNode("expression");
          char* idNode = newNode("id");
          writeEdge(exprNode, idNode);
          $$ = exprNode;
      }
    ;

%%

void yyerror(char const *s) {
    fprintf(stderr, "%s\n", s);
}

int main(int argc, char **argv) {
    FILE *inputFile;
    int rootNode = -1;
    int isChild[100] = {0};
    int visited[100] = {0};
    int order[100];
    int orderIndex = 0;
    int i;

    if (argc < 2) {
        fprintf(stderr, "Uso: %s <archivo de entrada>\n", argv[0]);
        return 1;
    }

    inputFile = fopen(argv[1], "r");
    if (!inputFile) {
        perror("Error al abrir el archivo de entrada");
        return 1;
    }

    yyin = inputFile;

    startTree();
    yyparse();
    
    for (i = 0; i < edge_count; i++) {
        isChild[edges[i].to] = 1;
    }
    for (i = 0; i < node_count; i++) {
        if (!isChild[i]) {
            rootNode = i;
            break;
        }
    }

    getNodeOrder(rootNode, visited, order, &orderIndex);
    
    for (i = 0; i < orderIndex; i++) {
        printf("  node%d [label=\"%s\"];\n", order[i], labels[order[i]]);
    }
    
    for (i = 0; i < edge_count; i++) {
        printf("  node%d -> node%d;\n", edges[i].from, edges[i].to);
    }
    
    printf("}\n");
    fclose(inputFile);
    return 0;
}
