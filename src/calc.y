%{
  #include<stdio.h>
  #include <stdlib.h>
  extern FILE * yyin;
  void yyerror (char const *s);
  #include <math.h>

/*
	The following variables are used to collect all values from the maximum | minimum | summation | product
	rules that allow any amount of expressions seperated by the character ','
*/

//	This multidimensional array allows the use of 100 max, min, sum, prod functions with 50 variables each
  float arr[100][50];
  
//	The count of variables in each function
  int len[100]={[0 ... 99]=0};
  
//	Index to the current position in arr
  int index = 0;

/*	
summary:	Traverse an array and apply the given function in each iteration
param (*f):	A pointer to a function which should be used
param a:	The index to the array in arr
*/
  float traverse(void (*f)(float*,float),int a){
  	float *ret = (float *)malloc(sizeof(float));
  	*ret = arr[a][0];
  	for(int i=1;i<len[a];i++){
  		(*f)(ret,arr[a][i]);
  	}
  	return *ret;
  }
  
/*	
summary:	Finds the minimum of two values
param curr:	A pointer to the previous minimum
param x:	The value which should be compared to the current minimum
*/
  void min(float* curr, float x){
  	if(*curr>x){*curr = x;}
  }
  
/*	
summary:	Finds the maximum of two values
param curr:	A pointer to the previous maximum
param x:	The value which should be compared to the current maximum
*/
  void max(float* curr,float x){
  	if(*curr<x){*curr = x;}
  }
  
/*	
summary:	Calculates the sum of two values
param curr:	A pointer to the current sum
param x:	The value which should be added to the current sum
*/
 void sum(float* curr,float x){
  	*curr += x;
  }
  
/*	
summary:	Calculates the product of two values
param curr:	A pointer to the current product
param x:	The value which should be multiplied to the current product
*/
  void prod(float* curr,float x){
  	*curr *= x;
  }
  
%} 

//	We only use float values so there is no need to worry about type conversions (except at the modulo operator)
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
		result expr CALC	{printf("Result:  %g\n",$2);}
	|
	;
	
expr:	
	 	expr PLUS term		{$$ = $1 + $3;}
	|	expr MINUS term	{$$ = $1 - $3;}
	|	term
	;
	
term:
		term MUL factor	{$$ = $1 * $3;}
	|	term DIV factor	{$$ = $1 / $3;}
	|	term MOD factor	{$$ = (int)$1 % (int)$3;}
	|	factor
	;

factor:
		OPEN_BRACKET expr CLOSED_BRACKET	{$$ = $2;}
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
		ABS OPEN_BRACKET expr CLOSED_BRACKET	{$$ = fabs($3);}
	;
	
maximum:
		MAX OPEN_BRACKET expr CLOSED_BRACKET		{$$ = $3;}
	|	MAX OPEN_BRACKET expr exprrec CLOSED_BRACKET	{
								//	Add the value of expr to the current array
								arr[index][len[index]++]=$3;
								//	Calculate the maximum of the current array
								$$ = traverse(max,index);
								
								index++;
								}
	;
	
minimum:
		MIN OPEN_BRACKET expr CLOSED_BRACKET		{$$ = $3;}
	|	MIN OPEN_BRACKET expr exprrec CLOSED_BRACKET	{
								//	Add the value of expr to the current array
								arr[index][len[index]++]=$3;
								//	Calculate the minimum of the current array
								$$ = traverse(min,index);
								
								index++;
								}
	;
	
summation:
		SUM OPEN_BRACKET expr CLOSED_BRACKET		{$$ = $3;}
	|	SUM OPEN_BRACKET expr exprrec CLOSED_BRACKET	{
								//	Add the value of expr to the current array
								arr[index][len[index]++]=$3;
								//	Calculate the sum of the current array
								$$ = traverse(sum,index);

								index++;
								}
	;
	
product:
		PROD OPEN_BRACKET expr CLOSED_BRACKET		{$$ = $3;}
	|	PROD OPEN_BRACKET expr exprrec CLOSED_BRACKET	{
								//	Add the value of expr to the current array
								arr[index][len[index]++]=$3;
								//	Calculate the product of the current array
								$$ = traverse(prod,index);

								index++;
								}
	;
	
root:
		SQRT OPEN_BRACKET expr CLOSED_BRACKET	{$$ = sqrt($3);}
	;
	
power:
		POW OPEN_BRACKET expr COMMA expr CLOSED_BRACKET	{$$ = pow($3,$5);}
	;
	
number:
		INTEGER					{$$ = $1;}
	|	FLOAT						{$$ = $1;}
	|	OPEN_BRACKET MINUS INTEGER CLOSED_BRACKET 	{$$ = $3*-1;}
	|	OPEN_BRACKET MINUS FLOAT CLOSED_BRACKET	{$$ = $3*-1;}
	;
	
	
exprrec:
		COMMA expr exprrec	{
					//	Add the value from expr to the array of the current function
					arr[index][len[index]]=$2;
					//	Update length of the array
					len[index]++;
					}
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
