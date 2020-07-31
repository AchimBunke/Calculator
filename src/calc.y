%{
  #include<stdio.h>
  #include <stdlib.h>
  extern FILE * yyin;
  void yyerror (char const *s);
  #include <math.h>
  
  float arr[100][50];
  int len[100]={[0 ... 99]=0};
  int index = 0;
  
  float traverse(void (*f)(float*,float),int a){
  	float *ret = (float *)malloc(sizeof(float));
  	*ret = arr[a][0];
  	for(int i=1;i<len[a];i++){
  		(*f)(ret,arr[a][i]);
  	}
  	return *ret;
  }
  void min(float* curr, float x){
  	if(*curr>x){*curr = x;}
  }
  void max(float* curr,float x){
  	if(*curr<x){*curr = x;}
  }
 void sum(float* curr,float x){
  	*curr += x;
  }
  void prod(float* curr,float x){
  	*curr *= x;
  }
  
  
%} 

%union{
	float fval;
}

%token	INTEGER 
%token	FLOAT
%token	PLUS MINUS
%token	MUL DIV MOD
%token	ABS MAX MIN SUM PROD SQRT POW
%token	OPEN_BRACKET CLOSED_BRACKET COMMA CALC


%left	PLUS MINUS
%left	MUL DIV MOD

%type <fval> expr term factor absolute maximum minimum summation product root power number INTEGER FLOAT

%start result

%%

result:
		result expr CALC	{printf("Result:  %g\n",$2);};
	|
	;
	
expr:	
	 	expr PLUS term	{$$ = $1 + $3;};
	|	expr MINUS term	{$$ = $1 - $3;};
	|	term
	;
	
term:
		term MUL factor	{$$ = $1 * $3;};
	|	term DIV factor	{$$ = $1 / $3;};
	|	term MOD factor	{$$ = (int)$1 % (int)$3;};
	|	factor
	;

factor:
		OPEN_BRACKET expr CLOSED_BRACKET	{$$ = $2;};
	|	number
	|	absolute
	|	maximum
	|	minimum
	|	summation
	|	product
	|	root
	|	power
	;
	
absolute:
		ABS OPEN_BRACKET expr CLOSED_BRACKET	{$$ = fabs($3);};
	;
	
maximum:
		MAX OPEN_BRACKET expr CLOSED_BRACKET	{$$ = $3;};
	|	MAX OPEN_BRACKET expr exprrec CLOSED_BRACKET	{arr[index][len[index]++]=$3;
								$$ = traverse(max,index);
								len[index]=0;
								index++;}
	;
	
minimum:
		MIN OPEN_BRACKET expr CLOSED_BRACKET	{$$ = $3;};
	|	MIN OPEN_BRACKET expr exprrec CLOSED_BRACKET	{arr[index][len[index]++]=$3;
								$$ = traverse(min,index);
								len[index]=0;
								index++;}
	;
	
summation:
		SUM OPEN_BRACKET expr CLOSED_BRACKET	{$$ = $3;};
	|	SUM OPEN_BRACKET expr exprrec CLOSED_BRACKET	{arr[index][len[index]++]=$3;
								$$ = traverse(sum,index);
								len[index]=0;
								index++;}
	;
	
product:
		PROD OPEN_BRACKET expr CLOSED_BRACKET	{$$ = $3;};
	|	PROD OPEN_BRACKET expr exprrec CLOSED_BRACKET	{arr[index][len[index]++]=$3;
								$$ = traverse(prod,index);
								len[index]=0;
								index++;}
	;
	
root:
		SQRT OPEN_BRACKET expr CLOSED_BRACKET	{$$ = sqrt($3);};
	;
	
power:
		POW OPEN_BRACKET expr COMMA expr CLOSED_BRACKET	{$$ = pow($3,$5);}
	;
	
number:
		INTEGER	{$$ = $1;};
	|	FLOAT	{$$ = $1;}
	|	OPEN_BRACKET MINUS INTEGER CLOSED_BRACKET {$$ = $3*-1;};
	|	OPEN_BRACKET MINUS FLOAT CLOSED_BRACKET	{$$ = $3*-1;};
	;
	
	
exprrec:
		COMMA expr exprrec	{arr[index][len[index]]=$2;len[index]++;}
	|	
	;
	
%%

void  yyerror(char const *s) {
  printf("\n%s\n", s);
  exit(100);
}

int main(int argc, char** argv)
  {
    ++argv, --argc;
    if(argc > 0){

      if( !(yyin = fopen(argv[0],"r")) ){
       exit(255);
     }
    }else{
    yyin=stdin;
    }
    
    char Expr[200];
    yyparse();

    return 0;
  }
