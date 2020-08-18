%{
/* Inclusao de arquivos da biblioteca de C */

#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Definicao dos atributos dos atomos operadores */

#define 	LT 		    1
#define 	LE 	    	2
#define		GT			3
#define		GE			4
#define		EQ			5
#define		NE			6
#define		MAIS        7
#define		MENOS       8
#define		MULT    	9
#define		DIV   	    10
#define		RESTO   	11

/*   Definicao dos tipos de identificadores   */

#define IDPROG		  1
#define IDVAR		  2
#define IDFUNC		  3
#define IDPROC		  4
#define IDGLOB		  5
#define IDPRINCIPAL   6

/*  Definicao dos tipos de variaveis   */

#define 	NOTVAR		0
#define 	INTEGER		1
#define 	LOGICAL		2
#define 	FLOAT		3
#define 	CHAR		4

/* Definicao de constantes para os operadores de quadruplas */

#define		OPOR			1
#define		OPAND	 		2
#define 	OPLT	 		3
#define 	OPLE	 		4
#define		OPGT		    5
#define		OPGE			6
#define		OPEQ			7
#define		OPNE			8
#define		OPMAIS		    9
#define		OPMENOS		   10
#define		OPMULTIP	   11
#define		OPDIV		   12
#define		OPRESTO		   13
#define		OPMENUN		   14
#define		OPNOT		   15
#define		OPATRIB		   16
#define		OPENMOD		   17
#define		NOP			   18
#define		OPJUMP		   19
#define		OPJF		   20
#define     PARAM          21
#define     OPREAD         22
#define     OPWRITE        23
#define		OPEXIT		   24
#define     OPCALL         25
#define     OPRETURN       26
#define     IND            27
#define     INDEX          28
#define     ATRIBPONT      29
#define     CONTAPONT      30

/* Definicao de constantes para os tipos de operandos de quadruplas */

#define		IDLEOPND		0
#define		VAROPND		    1
#define		INTOPND		    2
#define		REALOPND		3
#define		CHAROPND		4
#define		LOGICOPND	    5
#define		CADOPND		    6
#define		ROTOPND		    7
#define		MODOPND		    8
#define     FUNCOPND        9
#define     PROCOPND       10
#define     INDEXOPND      11


/*   Definicao de outras constantes   */

#define	NCLASSHASH	    23
#define	TRUE		     1
#define	FALSE		     0
#define MAXDIMS		    10

/*  Strings para nomes dos tipos de identificadores  */

char *nometipid[7] = {" ", "IDPROG", "IDVAR", "IDFUNC", "IDPROC", "IDGLOB", "IDPRINCIPAL"};

/*  Strings para nomes dos tipos de variaveis  */

char *nometipvar[5] = {"NOTVAR",
	"INTEGER", "LOGICAL", "FLOAT", "CHAR"
};

/* Strings para operadores de quadruplas */

char *nomeoperquad[31] = {"",
	"OR", "AND", "LT", "LE", "GT", "GE", "EQ", "NE", "MAIS",
	"MENOS", "MULT", "DIV", "RESTO", "MENUN", "NOT", "ATRIB",
	"OPENMOD", "NOP", "JUMP", "JF", "PARAM", "READ", "WRITE",
	"EXIT", "OPCALL", "OPRETURN", "IND", "INDEX", "ATRIBPONT", "CONTAPONT"
};

/*
	Strings para tipos de operandos de quadruplas
 */

char *nometipoopndquad[12] = {"IDLE",
	"VAR", "INT", "REAL", "CARAC", "LOGIC", "CADEIA", "ROTULO", "MODULO", "FUNCAO", "PROCEDIMENTO", "VAR"
};

/*    Declaracoes para a tabela de simbolos     */

typedef struct celsimb celsimb;
typedef celsimb *simbolo;
typedef struct elemlistsimb elemlistsimb;
typedef elemlistsimb *pontelemlistsimb;
typedef elemlistsimb *listsimb;
struct celsimb {
	char *cadeia;
	int tid, tvar, tparam, ndims, dims[MAXDIMS+1], nparams;
	char inic, ref, array, parametro;
    listsimb listparam;
	int *valint;
	float *valfloat;
  	char *valchar, *vallogic;
	simbolo escopo, prox;
};

/*  Listas de simbolos  */

struct elemlistsimb {
	simbolo simb;
	pontelemlistsimb prox;
};

/*  Variaveis globais para a tabela de simbolos e analise semantica */

simbolo tabsimb[NCLASSHASH];
simbolo simb, simb2;
int tipocorrente;
int nparams_dec;
simbolo escopo, escopoGlobal;
listsimb modParams;
listsimb listargs;
int indexada;
int inside;

/*
	Prototipos das funcoes para a tabela de simbolos
    	e analise semantica
 */

void InicTabSimb (void);
void ImprimeTabSimb (void);
simbolo InsereSimb (char *, int, int, simbolo);
int hash (char *);
simbolo ProcuraSimb (char *, simbolo);
void VerificaInicRef (void);
void DeclaracaoRepetida (char *, simbolo escopo);
void TipoInadequado (char *);
void NaoDeclarado (char *, simbolo escopo);
void Incompatibilidade (char *);
void Esperado (char *);
void NaoEsperado (char *);
void addToList(listsimb*, int, int);
void isParamsOk(listsimb, listsimb);

/* Declaracoes para a estrutura do codigo intermediario */

typedef union atribopnd atribopnd;
typedef struct operando operando;
typedef struct celquad celquad;
typedef celquad *quadrupla;
typedef struct celmodhead celmodhead;
typedef celmodhead *modhead;

union atribopnd {
	simbolo simb;
	int valint;
	float valfloat;
	char valchar;
	char vallogic;
	char *valcad;
	quadrupla rotulo;
	modhead modulo;
};

struct operando {
	int tipo;
	atribopnd atr;
};

struct celquad {
	int num, oper;
	operando opnd1, opnd2, result;
	quadrupla prox;
};

struct celmodhead {
	simbolo modname;
	modhead prox;
	quadrupla listquad;
};

/* Variaveis globais para o codigo intermediario */

quadrupla quadcorrente, quadaux, quadaux2;
modhead codintermed, modcorrente, modglobal, modaux;
int oper, numquadcorrente;
operando opnd1, opnd2, result, opndaux, opndaux2, opndaux3;
int numtemp;
const operando opndidle = {IDLEOPND, 0};

/* Prototipos das funcoes para o codigo intermediario */

void InicCodIntermed (void);
void InicCodIntermMod (simbolo);
void ImprimeQuadruplas (void);
quadrupla GeraQuadrupla (int, operando, operando, operando);
simbolo NovaTemp (int, simbolo);
void RenumQuadruplas (quadrupla, quadrupla);
void pointsToMod(simbolo);

/* Declaracoes para atributos das expressoes e variaveis */

typedef struct infoexpressao infoexpressao;
struct infoexpressao {
	int tipo;
	operando opnd;
};

typedef struct infovariavel infovariavel;
struct infovariavel {
	simbolo simb;
	operando opnd;
};


/* Variaveis e protótipos globais para variáveis indexadas */

struct nodeIndex {
    operando opnd1, result;
    struct nodeIndex* prox;
};

struct nodeIndex* listvarindex;

void addToListIndex(operando, operando);
void GeraQuadruplaIndex(void);

%}

/* Definicao do tipo de yylval e dos atributos dos nao terminais */

%union {
	char cadeia[50];
	int atr, valint;
	float valreal;
	char carac;
	simbolo simb;
	int tipoexpr;
	int nsubscr;
    listsimb listparam;
	infoexpressao infoexpr;
	infovariavel infovar;
	int nargs;
	quadrupla quad;
}

/* Declaracao dos atributos dos tokens e dos nao-terminais */

%type	    <infovar>	    Variavel   ChamadaFunc  ChamadaProc
%type 	    <infoexpr> 	    Expressao  ExprAux1  ExprAux2
                            ExprAux3   ExprAux4   Termo   Fator
                            ElemEscr
%type 		<nsubscr>		Subscritos 	ListSubscr
%type       <nargs>         ListLeit	ListEscr
%type       <params>        ListParam
%token		<cadeia>		ID
%token		<carac>		    CTCARAC
%token		<cadeia>		CADEIA
%token		<valint>		CTINT
%token		<valreal>	    CTREAL
%token		OR
%token		AND
%token		NOT
%token		<atr>			OPREL
%token		<atr>			OPAD
%token		<atr>			OPMULT
%token		NEG
%token		ABPAR
%token		FPAR
%token		ABCHAV
%token		FCHAV
%token		ABCOL
%token		FCOL
%token		ABTRIP
%token		FTRIP
%token		VIRG
%token		PVIRG
%token		ATRIB
%token		CARAC
%token		COMANDOS
%token		ENQUANTO
%token		ESCREVER
%token		FALSO
%token		INT
%token		LER
%token		LOGIC
%token		PROGRAMA
%token		REAL
%token		SE
%token      SENAO
%token      VAR
%token      VERDADE
%token      CHAMAR
%token      FUNCAO
%token      PARA
%token      PRINCIPAL
%token      PROCEDIMENTO
%token      REPETIR
%token      RETORNAR
%token		<carac>         INVAL
%%
/* Producoes da gramatica:

	Os terminais sao escritos e, depois de alguns,
	para alguma estetica, ha mudanca de linha       */

Prog			:	{InicTabSimb (); InicCodIntermed (); numtemp = 0; indexada = FALSE;}
                    PROGRAMA  ID
                    {escopo = escopoGlobal = InsereSimb ("##global", IDGLOB, NOTVAR, NULL);} ABTRIP
                    {
                        printf ("programa %s {{{\n", $3);
                        simb = InsereSimb ($3, IDPROG, NOTVAR, escopo);
                        InicCodIntermMod (simb);
                        opnd1.tipo = MODOPND;
                        opnd1.atr.modulo = modcorrente;
                        modglobal = modcorrente;
                        GeraQuadrupla(OPENMOD, opnd1, opndidle, opndidle);
                        opndaux.tipo = FUNCOPND;
                        modaux = malloc (sizeof(celmodhead));
                        simb = InsereSimb ("##principal", IDPRINCIPAL, tipocorrente, escopoGlobal);
                        modaux->modname = simb;
                        opndaux.atr.modulo = modaux;
                        strcpy(opndaux.atr.modulo->modname->cadeia, "##principal");
                        GeraQuadrupla(OPCALL, opndaux, opndidle, opndidle);
                        GeraQuadrupla(OPEXIT, opndidle, opndidle, opndidle);
                    }
                    Decls ListMod ModPrincipal FTRIP  {printf ("}}}\n");
                    VerificaInicRef ();
                    ImprimeTabSimb ();
                    ImprimeQuadruplas ();
                    }
                ;

Decls 		    :
                |   VAR  ABCHAV  {printf ("var {\n");}  ListDecl
                    FCHAV  {printf ("}\n");}
                ;

ListDecl		:	Declaracao  |  ListDecl  Declaracao
                ;

Declaracao 	    :	Tipo  ABPAR  {printf ("( ");}  ListElem
                    FPAR  {printf (")\n");}
                ;

Tipo			: 	INT  {printf ("int "); tipocorrente = INTEGER;}
                |   REAL  {printf ("real "); tipocorrente = FLOAT;}
                |   CARAC  {printf ("carac "); tipocorrente = CHAR;}
                |   LOGIC  {printf ("logic "); tipocorrente = LOGICAL;}
                ;

ListElem    	:	Elem  |  ListElem  VIRG  {printf (", ");}  Elem
                ;

Elem        	:	ID  {
                        printf ("%s ", $1);
                        if  (ProcuraSimb ($1, escopo)  !=  NULL)
                            DeclaracaoRepetida ($1,escopo);
                        else
                            simb = InsereSimb ($1,  IDVAR,  tipocorrente, escopo);
							simb->array = FALSE; simb->ndims = 0;
                    }  Dims
                ;

Dims            :
                |   ABCOL  {printf ("[ ");}  ListDim
                    FCOL  {
						printf ("] ");
						simb->array = TRUE;
					}
                ;

ListDim	        : 	CTINT   {printf ("%d ", $1);
							 if ($1 < 0) Esperado("Valor inteiro nao negativo");
							 simb->ndims++;
							 if(simb->ndims > MAXDIMS) Incompatibilidade ("Ultrapassou o maximo de dimensoes");
							 simb->dims[simb->ndims] = $1;
							}
                |   ListDim   VIRG   CTINT   {printf (", %d ", $3);
											  if($3 < 0) Esperado("Valor inteiro nao negativo");
											  simb->ndims++;
												if(simb->ndims > MAXDIMS) Incompatibilidade ("Ultrapassou o maximo de dimensoes");
											  simb->dims[simb->ndims] = $3;
											 }
                ;

ListMod 	    :
                |   ListMod  Modulo
                ;

Modulo        	:	Cabecalho  Corpo {
                        escopo = escopo->escopo;
                        if (inside)
                            GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
                        inside = FALSE;
                        }
                ;

Cabecalho     	:   CabFunc
                |   {inside = TRUE;} CabProc
                ;

CabFunc	    	:   FUNCAO {printf ("funcao ");} Tipo
                    ID
                    {
                        printf ("%s ", $4);
                        if ($4 == "principal")
                            NaoEsperado("Outro modulo de cabecalho principal");
                        else if  (ProcuraSimb ($4, escopo)  !=  NULL)
                            DeclaracaoRepetida ($4, escopo);
                        else {
                            escopo = InsereSimb ($4,  IDFUNC,  tipocorrente, escopo);
                            InicCodIntermMod (escopo);
                            opnd1.tipo = FUNCOPND;
                            opnd1.atr.modulo = modcorrente;
                            GeraQuadrupla(OPENMOD, opnd1, opndidle, opndidle);
                        }
                    }  ABPAR  {printf ("( "); nparams_dec = 0;}  ListParam
                    FPAR  {printf (")\n"); escopo->nparams = nparams_dec;}
                ;

CabProc	    	:   PROCEDIMENTO {printf ("procedimento ");}
                    ID
                    {
                        printf ("%s ", $3);
                        if ($3 == "principal")
                            NaoEsperado("Outro modulo de cabecalho principal");
                        else if  (ProcuraSimb ($3, escopo)  !=  NULL)
                            DeclaracaoRepetida ($3, escopo);
                        else {
                            escopo = InsereSimb ($3,  IDPROC,  tipocorrente, escopo);
                            InicCodIntermMod (escopo);
                            opnd1.tipo = PROCOPND;
                            opnd1.atr.modulo = modcorrente;
                            GeraQuadrupla(OPENMOD, opnd1, opndidle, opndidle);
                        }
                    }  ABPAR  {printf ("( "); nparams_dec = 0;}  ListParam
                    FPAR  {printf (")\n"); escopo->nparams = nparams_dec;}
                ;

ListParam   	: 	Parametro {nparams_dec +=1;}
                |   ListParam  VIRG {printf (", "); nparams_dec +=1;} Parametro

Parametro   	:
				|	Tipo
                    ID  {
                        printf ("%s ", $2);
                        simb = ProcuraSimb ($2, escopo->escopo);
                        if (simb != NULL && simb->tid != IDVAR)
                            NaoEsperado("Chamada de modulo externo como parametro");
                        if  (ProcuraSimb ($2, escopo)  !=  NULL)
                            DeclaracaoRepetida ($2, escopo);
                        else{
                            simb = InsereSimb ($2,  IDVAR,  tipocorrente, escopo);
                            simb->inic = TRUE;
                            simb->ref = TRUE;
                            addToList(&escopo->listparam,simb->tvar,simb->tid);
                        }
                    }
                ;
Corpo     	    :   Decls  Comandos
                ;
ModPrincipal  	:   PRINCIPAL {
                        escopo = ProcuraSimb("##principal", escopoGlobal);
                        InicCodIntermMod (escopo);
                        opnd1.tipo = FUNCOPND;
                        opnd1.atr.modulo = modcorrente;
                        GeraQuadrupla(OPENMOD, opnd1, opndidle, opndidle);
                        }
                        {printf ("principal\n");}  Corpo {GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);}
                ;
Comandos       	:   COMANDOS  {printf ("comandos ");}  CmdComp
                ;
CmdComp 		:   ABCHAV  {printf ("{\n");}  ListCmd  FCHAV
                    {
                        printf ("}\n");
                    }
                ;
ListCmd 		:
                |   ListCmd  Comando
                ;
Comando        	:   CmdComp  |  CmdSe  |  CmdEnquanto
                |   CmdRepetir  |  CmdPara
                |   CmdLer  |  CmdEscrever  |  CmdAtrib
                |   ChamadaProc  |  CmdRetornar  |  PVIRG  {printf ("; ");}
                ;
CmdSe		    :   SE    ABPAR  {printf ("se ( ");}  Expressao  {
                        if ($4.tipo != LOGICAL)
                            Incompatibilidade ("Expressao nao logica em comando se");
                        opndaux.tipo = ROTOPND;
                        if ($4.opnd.tipo == INDEXOPND)
                            $<quad>$ = GeraQuadrupla (OPJF, result, opndidle, opndaux);
                        else $<quad>$ = GeraQuadrupla (OPJF, $4.opnd, opndidle, opndaux);
                    }  FPAR  {printf (")\n");}  Comando  {
                        $<quad>$ = quadcorrente;
                        $<quad>5->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }  CmdSenao  {
                        if ($<quad>9->prox != quadcorrente) {
                            quadaux = $<quad>9->prox;
                        	$<quad>9->prox = quadaux->prox;
                        	quadaux->prox = $<quad>9->prox->prox;
                        	$<quad>9->prox->prox = quadaux;
                        	RenumQuadruplas ($<quad>9, quadcorrente);
                        }
                    }
                ;
CmdSenao		:
                |   SENAO  {
                        printf ("senao\n");
                        opndaux.tipo = ROTOPND;
                        $<quad>$ = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                    } Comando {
                        $<quad>2->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
                ;
CmdEnquanto   	:	ENQUANTO  ABPAR  {
                        printf ("enquanto ( ");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                        }  Expressao	{
                        if ($4.tipo != LOGICAL)
                            Incompatibilidade ("Expressao nao logica em comando enquanto");
                        opndaux.tipo = ROTOPND;
                        if ($4.opnd.tipo == INDEXOPND){
                            $<quad>$ = GeraQuadrupla (OPJF, result, opndidle, opndaux);
                        }
                        else $<quad>$ = GeraQuadrupla (OPJF, $4.opnd, opndidle, opndaux);
                    }  FPAR  {printf (")\n");}  Comando {
                        opndaux.tipo = ROTOPND;
                        opndaux.atr.rotulo = $<quad>3;
                        GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
                        $<quad>5->result.atr.rotulo = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    }
                ;
CmdRepetir  	:   REPETIR {
                        printf ("repetir ");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                    } Comando
                    ENQUANTO  ABPAR {printf ("enquanto ( ");}  Expressao  {
                        if ($7.tipo != LOGICAL)
                            Incompatibilidade ("Expressao nao logica em comando enquanto");
                        opndaux.tipo = ROTOPND;
                        opndaux.atr.rotulo = $<quad>2;
                        if ($7.opnd.tipo == INDEXOPND)
                            GeraQuadrupla (OPJF, result, opndidle, opndaux);
                        else GeraQuadrupla (OPJF, $7.opnd, opndidle, opndaux);
                    }
				    FPAR  PVIRG {printf (") ;\n");}
                ;
CmdPara	    	:   PARA  {printf ("para ");}  Variavel
                    {
                        if  ($3.simb != NULL){
                            $3.simb->inic = $3.simb->ref = TRUE;
                            if ($3.simb->tvar != INTEGER && $3.simb->tvar != CHAR)
                                Esperado ("Valor interiro ou caractere");
                        }
                    }
                    ABPAR {printf ("( ");} ExprAux4
                    {
                        GeraQuadrupla (PARAM, $7.opnd, opndidle, opndidle);
                        if ($7.tipo != INTEGER && $7.tipo != CHAR)
                            Incompatibilidade ("Expressao do tipo nao inteira e nao caractere em comando para");
                    }
                    PVIRG {
                            printf ("; ");
                            $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                        } Expressao
                    {
                        if ($11.tipo != LOGICAL)
                            Incompatibilidade ("Expressao do tipo nao logica em comando para");
                    	opndaux.tipo = ROTOPND;
                        if ($11.opnd.tipo == INDEXOPND)
                            $<quad>$ = GeraQuadrupla (OPJF, result, opndidle, opndaux);
            	        else $<quad>$ = GeraQuadrupla (OPJF, $11.opnd, opndidle, opndaux);
                    }  PVIRG {
                        printf ("; ");
                        $<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);
                        } ExprAux4
                    {
                        if ($15.tipo != INTEGER && $15.tipo != CHAR)
                            Incompatibilidade ("Expressao do tipo nao inteira e nao caractere em comando para");
                    }  FPAR {printf (") \n");}
                        {$<quad>$ = quadcorrente;}
                        {$<quad>$ = GeraQuadrupla (NOP, opndidle, opndidle, opndidle);}
                        Comando {
                            quadaux = quadcorrente;
	                        opndaux.tipo = ROTOPND;  opndaux.atr.rotulo = $<quad>10;
	                        quadaux2 = GeraQuadrupla (OPJUMP, opndidle, opndidle, opndaux);
	                        $<quad>12->result.atr.rotulo = GeraQuadrupla(NOP, opndidle, opndidle, opndidle);
                            $<quad>12->prox = $<quad>20;
                            quadaux->prox = $<quad>14;
                            $<quad>19->prox = quadaux2;
                            RenumQuadruplas ($<quad>12, quadcorrente);
                        }
                ;
CmdLer   	    :   LER  ABPAR  {printf ("ler ( ");}  {listvarindex = NULL;} ListLeit  {
                        opnd1.tipo = INTOPND;
                        opnd1.atr.valint = $5;
                        GeraQuadrupla (OPREAD, opnd1, opndidle, opndidle);
                        GeraQuadruplaIndex();
                        listvarindex = NULL;
                    } FPAR  PVIRG
                    {printf (") ;\n");}
                ;
ListLeit		:   Variavel {
                        if  ($1.simb != NULL)
                            $1.simb->inic = $1.simb->ref = TRUE;
                        $$ = 1;
                        if ($1.simb->ndims > 0){
                            $1.opnd.tipo = VAROPND;
                            $1.opnd.atr.simb = NovaTemp ($1.simb->tvar, escopo);
                            addToListIndex($1.opnd, result);
                        }
                        GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                    }
					|  ListLeit  VIRG  {printf (", ");} Variavel {
                        if  ($4.simb != NULL)
                            $4.simb->inic = $4.simb->ref = TRUE;
                        $$ = $1 + 1;
                        if ($4.simb->ndims > 0){
                            $4.opnd.tipo = VAROPND;
                            $4.opnd.atr.simb = NovaTemp ($4.simb->tvar, escopo);
                            addToListIndex($4.opnd, result);
                        }
                        GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                    }
                ;
CmdEscrever   	:	ESCREVER  ABPAR  {printf ("escrever ( ");}  ListEscr {
                        opnd1.tipo = INTOPND;
                        opnd1.atr.valint = $4;
                        GeraQuadrupla (OPWRITE, opnd1, opndidle, opndidle);
                    } FPAR
                    PVIRG  {printf (") ;\n");}
                ;
ListEscr		:	ElemEscr {
                        $$ = 1;
                        if ($1.opnd.tipo == INDEXOPND){
                            // opndaux = result;
                            // result.tipo = VAROPND;
                            // result.atr.simb = NovaTemp($1.tipo, escopo);
                            // GeraQuadrupla (CONTAPONT, opndaux, opndidle, result);                    
                            GeraQuadrupla (PARAM, result, opndidle, opndidle);
                        }
                        else GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                    }
				|  ListEscr  VIRG  {printf (", ");}  ElemEscr {
                        $$ = $1 + 1;
                        if ($4.opnd.tipo == INDEXOPND){
                            // opndaux = result;
                            // result.tipo = VAROPND;
                            // result.atr.simb = NovaTemp($4.tipo, escopo);
                            // GeraQuadrupla (CONTAPONT, opndaux, opndidle, result);                    
                            GeraQuadrupla (PARAM, result, opndidle, opndidle);
                        }
                        else GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                    }
                ;
ElemEscr		:   CADEIA  {
                        printf ("\"%s\" ", $1);
                        $$.opnd.tipo = CADOPND;
                        $$.opnd.atr.valcad = malloc (strlen($1) + 1);
                        strcpy ($$.opnd.atr.valcad, $1);
                    }
				|  Expressao
                ;
ChamadaProc   	:	CHAMAR  ID {printf ("chamar %s ", $2);}
                    {
                        modParams = NULL;
                        if (strcmp($2,escopo->cadeia) == 0)
                            NaoEsperado("Recursao nao e possivel nesta linguagem");
                        simb = ProcuraSimb ($2, escopoGlobal);
                        if (simb == NULL)   NaoDeclarado ($2, escopo);
                        else if (simb->tid != IDPROC)   TipoInadequado ($2);
                        else modParams = simb->listparam;
                        $<simb>$ = simb;
                    }
                    ABPAR  {printf ("(");} Argumentos FPAR  PVIRG  {
                        printf (") ;\n");
                        $$.simb = $<simb>4;

                        pointsToMod($<simb>4);

                        opnd1.tipo = PROCOPND;
                        opnd1.atr.modulo = modcorrente;

                        opnd2.tipo = INTOPND;
                        opnd2.atr.valint = $<simb>4->nparams;
                        if ($$.simb->tvar == NOTVAR) result = opndidle;
                        else {
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp ($$.simb->tvar, escopo);
                        }
                        GeraQuadrupla (OPCALL, opnd1, opnd2, result);
                        $$.opnd = result;

                        pointsToMod(escopo);    
                    }
                ;
Argumentos    	:  {listargs = NULL;}
                {
                    if (escopo != NULL && modParams != NULL)
                        isParamsOk(listargs,modParams);
                }
                |  {listargs = NULL;} ListExpr
                {
                    if (escopo != NULL && modParams != NULL)
                        isParamsOk(listargs, modParams);
                }
                ;
CmdRetornar  	:	RETORNAR  PVIRG {
                        printf ("retornar ; ");
                      	GeraQuadrupla (OPRETURN, opndidle, opndidle, opndidle);
                    }
                    {
                    if (escopo->tid == IDFUNC)
                        Esperado("Retorno de variavel para funcao");
                    }
				|   RETORNAR  {printf ("retornar ");}
                    Expressao
                    {
                        if (escopo->tid == IDPROC)
                            NaoEsperado("Retorno de variavel para procedimento");
                        if (escopo->tvar != $3.tipo && ($3.tipo >= 1 && $3.tipo <= 4))
                            Incompatibilidade("Tipo de valor retornado");
                        GeraQuadrupla (OPRETURN, $3.opnd, opndidle, opndidle);
                    }  PVIRG  {printf (";\n");}
                ;

CmdAtrib      	:   Variavel  {opndaux3 = result; if  ($1.simb != NULL) $1.simb->inic = $1.simb->ref = TRUE;}
                    ATRIB  {printf ("= "); indexada = FALSE;}  Expressao  {
                        if (indexada && $1.simb->ndims == 0) {
                            GeraQuadrupla (OPATRIB, result, opndidle, $1.opnd);
                        }
                    }
                    PVIRG
                    {
                        printf (";\n");
                        if ($1.simb != NULL){
                            if ((($1.simb->tvar == INTEGER || $1.simb->tvar == CHAR) &&
                                ($5.tipo == FLOAT || $5.tipo == LOGICAL)) ||
                                ($1.simb->tvar == FLOAT && $5.tipo == LOGICAL) ||
                                ($1.simb->tvar == LOGICAL && $5.tipo != LOGICAL))
                                Incompatibilidade ("Lado direito de comando de atribuicao improprio");
                                if ($1.simb->ndims > 0)
                                    GeraQuadrupla (ATRIBPONT, $5.opnd, opndidle, opndaux3);
                                else if (!indexada) 
                                    GeraQuadrupla (OPATRIB, $5.opnd, opndidle, $1.opnd);
                        }
                        indexada = FALSE;
                    }
                    
                ;
ListExpr		:  	Expressao {
                        GeraQuadrupla (PARAM, $1.opnd, opndidle, opndidle);
                    }
                |   ListExpr  VIRG  {printf (", ");}  Expressao {
                        GeraQuadrupla (PARAM, $4.opnd, opndidle, opndidle);
                    }
                ;
Expressao     	:   ExprAux1
				|   Expressao  OR  {
                        printf ("|| ");
                        opndaux2 = result;
                    }  ExprAux1  {
                        if ($1.tipo != LOGICAL || $4.tipo != LOGICAL)
                            Incompatibilidade ("Operando improprio para operador or");
                        $$.tipo = LOGICAL;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);

                        if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                            GeraQuadrupla (OPOR, opndaux2, result, $$.opnd);
                        }
                        else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                            GeraQuadrupla (OPOR, $1.opnd, result, $$.opnd);
                        }
                        else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                            GeraQuadrupla (OPOR, opndaux2, $4.opnd, $$.opnd);
                        }
                        else GeraQuadrupla (OPOR, $1.opnd, $4.opnd, $$.opnd);
                    }
                ;
ExprAux1    	:   ExprAux2
				|   ExprAux1  AND  {
                        printf ("&& ");
                        opndaux2 = result;
                    }  
                    ExprAux2  {
                        if ($1.tipo != LOGICAL || $4.tipo != LOGICAL)
                            Incompatibilidade ("Operando improprio para operador and");
                        $$.tipo = LOGICAL;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);

                        if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                            GeraQuadrupla (OPAND, opndaux2, result, $$.opnd);
                        }
                        else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                            GeraQuadrupla (OPAND, $1.opnd, result, $$.opnd);
                        }
                        else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                            GeraQuadrupla (OPAND, opndaux2, $4.opnd, $$.opnd);
                        }
                        else GeraQuadrupla (OPAND, $1.opnd, $4.opnd, $$.opnd);
                    }
                ;
ExprAux2    	:   ExprAux3
				|   NOT  {printf ("! ");}  ExprAux3  {
                        if ($3.tipo != LOGICAL)
                            Incompatibilidade ("Operando improprio para operador not");
                        $$.tipo = LOGICAL;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($3.tipo, escopo);
                        if ($3.opnd.tipo == INDEXOPND){
                            $3.opnd = result;
                        }
                        GeraQuadrupla (OPNOT, $3.opnd, opndidle, $$.opnd);
                    }
                ;
ExprAux3    	:   ExprAux4 {
                        if ($1.opnd.tipo == INDEXOPND){
                            opndaux = result;
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp($1.tipo, escopo);
                            GeraQuadrupla (CONTAPONT, opndaux, opndidle, result);    
                        }
                    }
                |   ExprAux4  OPREL  {
                        if ($1.opnd.tipo == INDEXOPND){
                            opndaux = result;
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp($1.tipo, escopo);
                            opndaux2 = result;
                            GeraQuadrupla (CONTAPONT, opndaux, opndidle, result);    
                        }

                        switch ($2) {
                            case LT: printf ("< "); break;
                            case LE: printf ("<= "); break;
                            case EQ: printf ("== "); break;
                            case NE: printf ("!= "); break;
                            case GT: printf ("> "); break;
                            case GE: printf (">= "); break;
                        }
                    }  ExprAux4  {
                        switch ($2) {
                            case LT: case LE: case GT: case GE:
                                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo != FLOAT && $4.tipo != CHAR)
                                    Incompatibilidade	("Operando improprio para operador relacional");
                                break;
                            case EQ: case NE:
                                if (($1.tipo == LOGICAL || $4.tipo == LOGICAL) && $1.tipo != $4.tipo)
                                    Incompatibilidade ("Operando improprio para operador relacional");
                                break;
                        }

                        if ($4.opnd.tipo == INDEXOPND){
                            opndaux = result;
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp($4.tipo, escopo);
                            GeraQuadrupla (CONTAPONT, opndaux, opndidle, result);    
                        }

                        $$.tipo = LOGICAL;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);

                        if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                            switch ($2) {
                                case LT:
                                    GeraQuadrupla (OPLT, opndaux2, result, $$.opnd);
                                    break;
                                case LE:
                                    GeraQuadrupla (OPLE, opndaux2, result, $$.opnd);
                                    break;
                                case GT:
                                    GeraQuadrupla (OPGT, opndaux2, result, $$.opnd);
                                    break;
                                case GE:
                                    GeraQuadrupla (OPGE, opndaux2, result, $$.opnd);
                                    break;
                                case EQ:
                                    GeraQuadrupla (OPEQ, opndaux2, result, $$.opnd);
                                    break;
                                case NE:
                                    GeraQuadrupla (OPNE, opndaux2, result, $$.opnd);
                                    break;
                            }
                        }
                        else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                            switch ($2) {
                                case LT:
                                    GeraQuadrupla (OPLT, $1.opnd, result, $$.opnd);
                                    break;
                                case LE:
                                    GeraQuadrupla (OPLE, $1.opnd, result, $$.opnd);
                                    break;
                                case GT:
                                    GeraQuadrupla (OPGT, $1.opnd, result, $$.opnd);
                                    break;
                                case GE:
                                    GeraQuadrupla (OPGE, $1.opnd, result, $$.opnd);
                                    break;
                                case EQ:
                                    GeraQuadrupla (OPEQ, $1.opnd, result, $$.opnd);
                                    break;
                                case NE:
                                    GeraQuadrupla (OPNE, $1.opnd, result, $$.opnd);
                                    break;
                            }
                        }
                        else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                            switch ($2) {
                                case LT:
                                    GeraQuadrupla (OPLT, opndaux2, $4.opnd, $$.opnd);
                                    break;
                                case LE:
                                    GeraQuadrupla (OPLE, opndaux2, $4.opnd, $$.opnd);
                                    break;
                                case GT:
                                    GeraQuadrupla (OPGT, opndaux2, $4.opnd, $$.opnd);
                                    break;
                                case GE:
                                    GeraQuadrupla (OPGE, opndaux2, $4.opnd, $$.opnd);
                                    break;
                                case EQ:
                                    GeraQuadrupla (OPEQ, opndaux2, $4.opnd, $$.opnd);
                                    break;
                                case NE:
                                    GeraQuadrupla (OPNE, opndaux2, $4.opnd, $$.opnd);
                                    break;
                            }
                        }
                        else {
                            switch ($2) {
                                case LT:
                                    GeraQuadrupla (OPLT, $1.opnd, $4.opnd, $$.opnd);
                                    break;
                                case LE:
                                    GeraQuadrupla (OPLE, $1.opnd, $4.opnd, $$.opnd);
                                    break;
                                case GT:
                                    GeraQuadrupla (OPGT, $1.opnd, $4.opnd, $$.opnd);
                                    break;
                                case GE:
                                    GeraQuadrupla (OPGE, $1.opnd, $4.opnd, $$.opnd);
                                    break;
                                case EQ:
                                    GeraQuadrupla (OPEQ, $1.opnd, $4.opnd, $$.opnd);
                                    break;
                                case NE:
                                    GeraQuadrupla (OPNE, $1.opnd, $4.opnd, $$.opnd);
                                    break;
                            }
                        }
                    }
                ;
ExprAux4    	:   Termo
                |   ExprAux4  OPAD  {
                        opndaux2 = result;
                        switch ($2) {
                            case MAIS: printf ("+ "); break;
                            case MENOS: printf ("- "); break;
                        }
                    }  Termo  {
                        if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR || $4.tipo != INTEGER && $4.tipo != FLOAT && $4.tipo != CHAR)
                            Incompatibilidade ("Operando improprio para operador aritmetico");
                        if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                        else $$.tipo = INTEGER;
                        $$.opnd.tipo = VAROPND;
                        $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);
                        if ($2 == MAIS){
                            if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                GeraQuadrupla (OPMAIS, opndaux2, result, $$.opnd);
                            }
                            else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                GeraQuadrupla (OPMAIS, $1.opnd, result, $$.opnd);
                            }
                            else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                                GeraQuadrupla (OPMAIS, opndaux2, $4.opnd, $$.opnd);
                            }
                            else GeraQuadrupla (OPMAIS, $1.opnd, $4.opnd, $$.opnd);
                        }    
                        else{
                            if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                GeraQuadrupla (OPMENOS, opndaux2, result, $$.opnd);
                            }
                            else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                GeraQuadrupla (OPMENOS, $1.opnd, result, $$.opnd);
                            }
                            else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                                GeraQuadrupla (OPMENOS, opndaux2, $4.opnd, $$.opnd);
                            }
                            else GeraQuadrupla (OPMENOS, $1.opnd, $4.opnd, $$.opnd);
                        }
                        result = $$.opnd;
                    }
                ;
Termo  	    	:   Fator
                |   Termo  OPMULT  {
                        opndaux2 = result;
                        switch ($2) {
                            case MULT: printf ("* "); break;
                            case DIV: printf ("/ "); break;
                            case RESTO: printf ("%% "); break;
                        }
                    }  Fator  {
                        switch ($2) {
                            case MULT: case DIV:
                                if ($1.tipo != INTEGER && $1.tipo != FLOAT && $1.tipo != CHAR
                                    || $4.tipo != INTEGER && $4.tipo != FLOAT && $4.tipo != CHAR)
                                    Incompatibilidade ("Operando improprio para operador aritmetico");
                                if ($1.tipo == FLOAT || $4.tipo == FLOAT) $$.tipo = FLOAT;
                                else $$.tipo = INTEGER;
                                $$.opnd.tipo = VAROPND;
                                $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);
                                if ($2 == MULT){
                                    if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                        GeraQuadrupla (OPMULTIP, opndaux2, result, $$.opnd);
                                    }
                                    else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                        GeraQuadrupla (OPMULTIP, $1.opnd, result, $$.opnd);
                                    }
                                    else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                                        GeraQuadrupla (OPMULTIP, opndaux2, $4.opnd, $$.opnd);
                                    }
                                    else GeraQuadrupla (OPMULTIP, $1.opnd, $4.opnd, $$.opnd);
                                }
                                else {
                                     if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                        GeraQuadrupla (OPDIV, opndaux2, result, $$.opnd);
                                    }
                                    else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                        GeraQuadrupla (OPDIV, $1.opnd, result, $$.opnd);
                                    }
                                    else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                                        GeraQuadrupla (OPDIV, opndaux2, $4.opnd, $$.opnd);
                                    }
                                    else GeraQuadrupla (OPDIV, $1.opnd, $4.opnd, $$.opnd);
                                } 
                                break;
                            case RESTO:
                                if ($1.tipo != INTEGER && $1.tipo != CHAR
                                    ||  $4.tipo != INTEGER && $4.tipo != CHAR)
                                    Incompatibilidade ("Operando improprio para operador resto");
                                $$.tipo = INTEGER;
                                $$.opnd.tipo = VAROPND;
                                $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);
                                if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                    GeraQuadrupla (OPRESTO, opndaux2, result, $$.opnd);
                                }
                                else if ($1.opnd.tipo != INDEXOPND && $4.opnd.tipo == INDEXOPND){
                                    GeraQuadrupla (OPRESTO, $1.opnd, result, $$.opnd);
                                }
                                else if ($1.opnd.tipo == INDEXOPND && $4.opnd.tipo != INDEXOPND){
                                    GeraQuadrupla (OPRESTO, opndaux2, $4.opnd, $$.opnd);
                                }
                                else GeraQuadrupla (OPRESTO, $1.opnd, $4.opnd, $$.opnd);
                                break;
                        }
                        result = $$.opnd;
                    }
                ;
Fator		    :   Variavel  {
                        if  ($1.simb != NULL) {
                            $1.simb->ref  =  TRUE;
                            $$.tipo = $1.simb->tvar;
                            $$.opnd = $1.opnd;
                        }
                    }
                |   CTINT  {printf ("%d ", $1); $$.tipo = INTEGER;
                                $$.opnd.tipo = INTOPND;
                                $$.opnd.atr.valint = $1;
 							    if(indexada == TRUE && $1 < 0){
                                    Esperado("Valor inteiro nao negativo");
                                }
                            }
                |   CTREAL  {
                                printf ("%g ", $1); $$.tipo = FLOAT;
                                $$.opnd.tipo = REALOPND;
                                $$.opnd.atr.valfloat = $1;
                            }
                |   CTCARAC {
                                printf ("\'%c\' ", $1); $$.tipo = CHAR;
                                $$.opnd.tipo = CHAROPND;
                                $$.opnd.atr.valchar = $1;
                            }
            	|   VERDADE {
                                printf ("verdade "); $$.tipo = LOGICAL;
                                $$.opnd.tipo = LOGICOPND;
                                $$.opnd.atr.vallogic = 1;
                            }
            	|   FALSO   {
                                printf ("falso "); $$.tipo = LOGICAL;
                                $$.opnd.tipo = LOGICOPND;
                                $$.opnd.atr.vallogic = 0;
                            }
            	|   NEG  {printf ("~ ");}  Fator  {
                        if ($3.tipo != INTEGER &&
                            $3.tipo != FLOAT && $3.tipo != CHAR)
                            Incompatibilidade  ("Operando improprio para menos unario");
                            if ($3.tipo == FLOAT) $$.tipo = FLOAT;
                            else $$.tipo = INTEGER;
                            $$.opnd.tipo = VAROPND;
                            $$.opnd.atr.simb = NovaTemp ($$.tipo, escopo);
                            GeraQuadrupla  (OPMENUN, $3.opnd, opndidle, $$.opnd);
                    }
            	|   ABPAR  {printf ("( ");}  Expressao  FPAR
                    {printf (") "); $$.tipo = $3.tipo; $$.opnd = $3.opnd;}
              |   ChamadaFunc {
                        if ($1.simb != NULL) {
                            $$.tipo = $1.simb->tvar;
                            $$.opnd = $1.opnd;
                        }
                    }

                ;

Variavel		:   ID  {
                        printf ("%s ", $1);
                        simb = ProcuraSimb ($1, escopo);
                        if (simb == NULL){
                            simb = ProcuraSimb ($1, escopoGlobal);
                            if (simb == NULL){
                                NaoDeclarado ($1, escopo);
                                NaoDeclarado ($1, escopoGlobal);
                                addToList(&listargs,0,IDVAR);
                            }
                            else addToList(&listargs,simb->tvar,simb->tid);
                        }
                        else if (simb->tid != IDVAR)   TipoInadequado ($1);
                        $<simb>$ = simb;
                        if (simb != NULL && simb->tid == IDVAR)
                            addToList(&listargs,simb->tvar,simb->tid);
                    }
					Subscritos  {
						$$.simb = $<simb>2;
                        if ($$.simb != NULL) {
                            if ($$.simb->array == FALSE && $3 > 0)
                                NaoEsperado ("Subscrito\(s)");
                            else if ($$.simb->array == TRUE && $3 == 0)
                                Esperado ("Subscrito\(s)");
                            else if ($$.simb->ndims != $3)
                                Incompatibilidade ("Numero de subscritos incompativel com declaracao");
                            $$.opnd.tipo = VAROPND;
                            if ($3 == 0)
                                $$.opnd.atr.simb = $$.simb;
                        }
                        if ($$.simb->ndims > 0) {
                            $$.opnd.atr.modulo = malloc (sizeof(celmodhead));
                            $$.opnd.atr.modulo->modname = $$.simb;
                            $$.opnd.tipo = INDEXOPND;
                            opnd2.tipo = INTOPND;
                            opnd2.atr.valint = $3;
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp ($$.simb->tvar, escopo);
                            GeraQuadrupla (INDEX, $$.opnd, opnd2, result);
                            indexada = TRUE;
                        }
					}
                ;
Subscritos      :	{$$ = 0;}
                |   ABCOL  {printf ("[ "); indexada = TRUE;}  ListSubscr
                    FCOL  {
						printf ("] ");
						indexada = FALSE;
						$$ = $3;
					}
                ;
ListSubscr  	:   ExprAux4
					{
						if ($1.tipo != INTEGER && $1.tipo != CHAR)
							Incompatibilidade ("Tipo inadequado para subscrito");
						$$ = 1;
                        GeraQuadrupla (IND, $1.opnd, opndidle, opndidle);
					}
                |   ListSubscr  VIRG  {printf (", ");}  ExprAux4
					{
						if ($4.tipo != INTEGER && $4.tipo != CHAR)
							Incompatibilidade ("Tipo inadequado para subscrito");
						$$ = $1 + 1;
						if($$ > MAXDIMS)
							Incompatibilidade ("Ultrapassou o maximo de dimensoes");
                        GeraQuadrupla (IND, $4.opnd, opndidle, opndidle);
					}
                ;
ChamadaFunc   :   ID  {
                        modParams = NULL;
                        printf ("%s ", $1);
                        if (strcmp($1,escopo->cadeia) == 0){
                            NaoEsperado("Recursao nao e possivel nesta linguagem");
                        }
                        simb = ProcuraSimb ($1, escopoGlobal);
                        if (simb == NULL){
                            NaoDeclarado ($1, escopo);
                        }
                        else if (simb->tid != IDFUNC){
                            TipoInadequado ($1);
                        }
                        else {
                            modParams = simb->listparam;
                        }
                        $<simb>$ = simb;
                    }  ABPAR  {printf ("(");} Argumentos FPAR {
                        printf (") ");
                        $$.simb = $<simb>2;

                        pointsToMod($<simb>2);

                        opnd1.tipo = FUNCOPND;
                        opnd1.atr.modulo = modcorrente;

                        opnd2.tipo = INTOPND;
                        opnd2.atr.valint = $<simb>2->nparams;
                        if ($$.simb->tvar == NOTVAR) result = opndidle;
                        else {
                            result.tipo = VAROPND;
                            result.atr.simb = NovaTemp ($$.simb->tvar, escopo);
                        }
                        GeraQuadrupla (OPCALL, opnd1, opnd2, result);
                        $$.opnd = result;

                        pointsToMod(escopo);
                    }

%%

/* Inclusao do analisador lexico  */

#include "lex.yy.c"

/*  InicTabSimb: Inicializa a tabela de simbolos   */

void InicTabSimb () {
	int i;
	for (i = 0; i < NCLASSHASH; i++)
		tabsimb[i] = NULL;
}

/*
	ProcuraSimb (cadeia): Procura cadeia na tabela de simbolos;
	Caso ela ali esteja, retorna um ponteiro para sua celula;
	Caso contrario, retorna NULL.
 */

simbolo ProcuraSimb (char *cadeia, simbolo escopo) {
	simbolo s; int i;
	i = hash (cadeia);
	for (s = tabsimb[i]; (s!=NULL);s = s->prox){
        if (strcmp(cadeia, s->cadeia) == 0 && s->escopo == escopo)
            return s;
    }
    return NULL;
}

/*
	InsereSimb (cadeia, tid, tvar): Insere cadeia na tabela de
	simbolos, com tid como tipo de identificador e com tvar como
	tipo de variavel; Retorna um ponteiro para a celula inserida
 */

simbolo InsereSimb (char *cadeia, int tid, int tvar, simbolo escopo) {
	int i; simbolo aux, s;
	i = hash (cadeia); aux = tabsimb[i];
	s = tabsimb[i] = (simbolo) malloc (sizeof (celsimb));
	s->cadeia = (char*) malloc ((strlen(cadeia)+1) * sizeof(char));
	strcpy (s->cadeia, cadeia);
    s->ndims = 0;
		s->nparams = 0;
    s->listparam = NULL;
	s->tid = tid;		s->tvar = tvar;
	s->inic = FALSE;	s->ref = FALSE;
	s->prox = aux;	    s->escopo = escopo;
    return s;
}

/*
	hash (cadeia): funcao que determina e retorna a classe
	de cadeia na tabela de simbolos implementada por hashing
 */

int hash (char *cadeia) {
	int i, h;
	for (h = i = 0; cadeia[i]; i++) {h += cadeia[i];}
	h = h % NCLASSHASH;
	return h;
}

/* ImprimeTabSimb: Imprime todo o conteudo da tabela de simbolos  */

void ImprimeTabSimb () {
	int i; simbolo s;
	printf ("\n\n   TABELA  DE  SIMBOLOS:\n\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i]) {
			printf ("Classe %d:\n", i);
			for (s = tabsimb[i]; s!=NULL; s = s->prox){
				printf ("  (%s, %s", s->cadeia,  nometipid[s->tid]);
				if (s->tid == IDVAR) {
					printf (", %s, %d, %d",
						nometipvar[s->tvar], s->inic, s->ref);
                    if (s->array == TRUE) {
                        int j;
                        printf (", EH ARRAY\n\tndims = %d, dimensoes:", s->ndims);
						for (j = 1; j <= s->ndims; j++)
                            printf ("  %d", s->dims[j]);
					}
                }

				if (s->tid == IDFUNC){
					printf(", %s", nometipvar[s->tvar]);
				}
				if (s->escopo != NULL){
					printf(", %s)\n", s->escopo->cadeia);
				}
				else printf(")\n");
			}
		}
}


void VerificaInicRef () {
	int i; simbolo s;

	printf ("\n");
	for (i = 0; i < NCLASSHASH; i++)
		if (tabsimb[i])
			for (s = tabsimb[i]; s!=NULL; s = s->prox)
				if (s->tid == IDVAR) {
					if (s->inic == FALSE)
						printf ("[%12s] %10s:   Nao Inicializada\n", s->escopo->cadeia, s->cadeia);
					if (s->ref == FALSE)
						printf ("[%12s] %10s:   Nao Referenciada\n", s->escopo->cadeia, s->cadeia);
				}
}

void addToList(listsimb* lista, int tvar, int tid){
    listsimb aux;
    if (*lista == NULL){
        *lista = (listsimb) malloc (sizeof (elemlistsimb));
        (*lista)->simb = (simbolo) NULL;
        (*lista)->simb = (simbolo) malloc (sizeof (celsimb));
        (*lista)->simb->tvar = tvar;
        (*lista)->simb->tid = tid;
        (*lista)->prox = NULL;
    }
    else {
        for (aux = *lista; aux->prox!=NULL; aux = aux->prox);
        aux->prox = (listsimb) malloc (sizeof (elemlistsimb));
        aux->prox->simb = (simbolo) malloc (sizeof (celsimb));
        aux->prox->simb->tvar = tvar;
        aux->prox->simb->tid = tid;
        aux->prox->prox = NULL;
    }
}

void isParamsOk(listsimb listargs, listsimb listparam){
    listsimb a = NULL;
    listsimb p = NULL;

    for (a=listargs,p=listparam; a!=NULL && p!=NULL; a=a->prox, p=p->prox){
        if (a->simb->tvar != p->simb->tvar){
            Incompatibilidade("Tipo do argumento e tipo do parmetro");
            break;
        }
    }
    if ((a && !p) || (!a && p))
        Incompatibilidade("Quantidade de argumentos e de parametros");
}

/*  Mensagens de erros semanticos  */

void DeclaracaoRepetida (char *s, simbolo escopo) {
	printf ("\n\n***** Declaracao Repetida: %s no escopo: %s*****\n\n", s, escopo->cadeia);
}

void NaoDeclarado (char *s, simbolo escopo) {
    printf ("\n\n***** Identificador Nao Declarado: %s no escopo: %s *****\n\n", s, escopo->cadeia);
}

void TipoInadequado (char *s) {
    printf ("\n\n***** Identificador de Tipo Inadequado: %s *****\n\n", s);
}

void Incompatibilidade (char *s) {
    printf ("\n\n***** Incompatibilidade: %s *****\n\n", s);
}

void Esperado (char *s) {
    printf ("\n\n***** Esperado: %s *****\n\n", s);
}

void NaoEsperado (char *s) {
	printf ("\n\n***** Nao Esperado: %s *****\n\n", s);
}

/* Funcoes para o codigo intermediario */

void InicCodIntermed () {
	modcorrente = codintermed = malloc (sizeof (celmodhead));
	modcorrente->listquad = NULL;
	modcorrente->prox = NULL;
}

void InicCodIntermMod (simbolo simb) {
	modcorrente->prox = malloc (sizeof (celmodhead));
	modcorrente = modcorrente->prox;
	modcorrente->prox = NULL;
	modcorrente->modname = simb;
	modcorrente->listquad = malloc (sizeof (celquad));
	quadcorrente = modcorrente->listquad;
	quadcorrente->prox = NULL;
	numquadcorrente = 0;
	quadcorrente->num = numquadcorrente;
}

quadrupla GeraQuadrupla (int oper, operando opnd1, operando opnd2, operando result) {
	quadcorrente->prox = malloc (sizeof (celquad));
	quadcorrente = quadcorrente->prox;
	quadcorrente->oper = oper;
	quadcorrente->opnd1 = opnd1;
	quadcorrente->opnd2 = opnd2;
	quadcorrente->result = result;
	quadcorrente->prox = NULL;
	numquadcorrente ++;
  quadcorrente->num = numquadcorrente;
  return quadcorrente;
}

simbolo NovaTemp (int tip, simbolo escopo) {
	simbolo simb; int temp, i, j;
	char nometemp[10] = "##", s[10] = {0};
	numtemp ++;
	temp = numtemp;
	for (i = 0; temp > 0; temp /= 10, i++){
		s[i] = temp % 10 + '0';
	}
	i --;
	for (j = 0; j <= i; j++){
		nometemp[2+i-j] = s[j];
	}
	simb = InsereSimb (nometemp, IDVAR, tip, escopo);
	simb->inic = simb->ref = TRUE;
    simb->array = FALSE;
	return simb;
}

void ImprimeQuadruplas () {
	modhead p;
	quadrupla q;
	for (p = codintermed->prox; p != NULL; p = p->prox) {
		printf ("\n\nQuadruplas do modulo %s:\n", p->modname->cadeia);
		for (q = p->listquad->prox; q != NULL; q = q->prox) {
			printf ("\n\t%4d) %s", q->num, nomeoperquad[q->oper]);
			printf (", (%s", nometipoopndquad[q->opnd1.tipo]);
			switch (q->opnd1.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd1.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd1.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd1.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd1.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd1.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd1.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd1.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia); break;
                case FUNCOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia); break;
                case PROCOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia); break;
                case INDEXOPND: printf(", %s", q->opnd1.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->opnd2.tipo]);
			switch (q->opnd2.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->opnd2.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->opnd2.atr.valint); break;
				case REALOPND: printf (", %g", q->opnd2.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->opnd2.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->opnd2.atr.vallogic); break;
				case CADOPND: printf (", %s", q->opnd2.atr.valcad); break;
				case ROTOPND: printf (", %d", q->opnd2.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->opnd2.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
			printf (", (%s", nometipoopndquad[q->result.tipo]);
			switch (q->result.tipo) {
				case IDLEOPND: break;
				case VAROPND: printf (", %s", q->result.atr.simb->cadeia); break;
				case INTOPND: printf (", %d", q->result.atr.valint); break;
				case REALOPND: printf (", %g", q->result.atr.valfloat); break;
				case CHAROPND: printf (", %c", q->result.atr.valchar); break;
				case LOGICOPND: printf (", %d", q->result.atr.vallogic); break;
				case CADOPND: printf (", %s", q->result.atr.valcad); break;
				case ROTOPND: printf (", %d", q->result.atr.rotulo->num); break;
				case MODOPND: printf(", %s", q->result.atr.modulo->modname->cadeia);
					break;
			}
			printf (")");
		}
	}
   printf ("\n");
}

void RenumQuadruplas (quadrupla quad1, quadrupla quad2) {
	quadrupla q; int nquad;
	for (q = quad1->prox, nquad = quad1->num; q != quad2; q = q->prox) {
  	nquad++;
		q->num = nquad;
	}
}

void pointsToMod(simbolo simb){
    modhead p;
    for (p = modglobal; p!=NULL; p = p->prox)
        if (strcmp(p->modname->cadeia, simb->cadeia) == 0)
            modcorrente = p;
}

void addToListIndex(operando opnd1, operando result){
    struct nodeIndex* lista = listvarindex;
    if (lista == NULL){
        lista = (struct nodeIndex*) malloc (sizeof (struct nodeIndex));
        lista->opnd1 = opnd1;
        lista->result = result;        
        lista->prox = NULL;
        listvarindex = lista;
    }
    else {
        for (lista = listvarindex; lista->prox!=NULL; lista = lista->prox);
        lista->prox = (struct nodeIndex*) malloc (sizeof (struct nodeIndex));
        lista = lista->prox;
        lista->opnd1 = opnd1;
        lista->result = result;        
        lista->prox = NULL;
    }
}

void GeraQuadruplaIndex(void){
    struct nodeIndex* lista;
    for (lista = listvarindex; lista!=NULL; lista = lista->prox){
        GeraQuadrupla(ATRIBPONT, lista->opnd1, opndidle, lista->result);
    }
}
