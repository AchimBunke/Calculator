%option noyywrap
%{
#include <stdio.h>
#include "y.tab.h"
%}



DIGIT		[0-9]
NONZERO	[1-9]
INTEGER	{ZERO}|{NONZERO}{DIGIT}*
FLOAT		{INTEGER}"."{DIGIT}{DIGIT}*
ZERO		[0]



%%

{FLOAT}		{
                                //printf("FLOAT: %s\n", yytext);   
                                yylval.fval=strtof(yytext,NULL);
                                return FLOAT;                        
                            }
{INTEGER}		{
                                //printf("INTEGER: %s\n", yytext);  
                                yylval.fval=strtof(yytext,NULL);   
                                return INTEGER;                        
                            }
"+"                         {
                                //printf("Plus operator: %s\n", yytext);
                                return PLUS;
                            }
"-"                       {
                                //printf("Minus operator: %s\n", yytext);
                                return MINUS;
                            }
"*"                         {
                                //printf("Multiplication operator: %s\n", yytext);
                                return MUL;
                            }
"/"                         {
                                //printf("Division operator: %s\n", yytext);
                                return DIV;
                            }
"%"                         {
                                //printf("Modulo operator: %s\n", yytext);
                                return MOD;
                            }
"("                         {
                                //printf("Opening bracket: %s\n", yytext);
                                return OPEN_BRACKET;
                            }
")"                         {
                                //printf("Closing bracket: %s\n", yytext);
                                return CLOSED_BRACKET;
                            }
"abs"                       {
                                //printf("Abs operator: %s\n", yytext);
                                return ABS;
                            }
"max"                       {
                                //printf("Maximum operator: %s\n", yytext);
                                return MAX;
                            }
"min"                       {
                                //printf("Minimum operator: %s\n", yytext);
                                return MIN;
                            }
"sum"                       {
                                //printf("Summation operator: %s\n", yytext);
                                return SUM;
                            }
"prod"                      {
                                //printf("Product operator: %s\n", yytext);
                                return PROD;
                            }
"sqrt"                      {
                                //printf("Root operator: %s\n", yytext);
                                return SQRT;
                            }
"pow"                       {
                                //printf("Power operator: %s\n", yytext);
                                return POW;
                            }
","                         {
                                //printf("comma: %s\n", yytext);
                                return COMMA;
                            }

[ \t\n]+	             { 
                                /* Do nothing at whitespace - eat it! */
                            } 
"="		     {
				//printf("Calculate:\n\n");
				return CALC;
			     }     
"E"                         {
                                printf("Exiting the calculator.\n"); 
                                return 0;    
                            }                               
.                           {
                                printf("Unrecognized token: %s, Exiting!\n", yytext);  /* Is there anything else? Fail on it! */
                                return 1;
                            }       
%%

