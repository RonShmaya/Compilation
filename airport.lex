%{
#define DEPARTUERS 100
#define FLIGHT_NUMBER 101
#define TIME 102
#define AIRPORT 103
#define CARGO 104
#define FREIGHT 105

int line = 1;

union {
  int is_am;
} semantic_vals;

union {
  char name[30];
} yylval;

#include <stdlib.h> 
#include <string.h> 

%}

%option noyywrap


%%

"<departures>" { strcpy(yylval.name,yytext); return DEPARTUERS; }

([A-Z]{2})([0-9]{1,4}) { strcpy(yylval.name,yytext); return FLIGHT_NUMBER;}

(0[0-9]|1[0-2])":"[0-5][0-9]"a.m." { strcpy(yylval.name,yytext); semantic_vals.is_am = 1; return TIME; }

(0[0-9]|1[0-2])":"[0-5][0-9]"p.m." { strcpy(yylval.name,yytext); semantic_vals.is_am = 0; return TIME; }

\"([A-Za-z])([A-Za-z]|" ")*\" { strcpy(yylval.name,yytext); return AIRPORT;}

"cargo" { strcpy(yylval.name,yytext); return CARGO; }

"freight" { strcpy(yylval.name,yytext); return FREIGHT; }

\n { line++; }

[\r\t ]+  /* skip white space */

.          { fprintf (stderr, "\n\nunrecognized token %c in  %d Line !!!\n", yytext[0],line); return -1;}

%%

void main (int argc, char **argv)
{
   int token;

   if (argc != 2) {
      fprintf(stderr, "The program must to get a input.txt file\n");
      exit (1);
   }

   yyin = fopen (argv[1], "r");
   if(yyin == NULL){  fprintf (stderr, "Failed to open %s file\n",argv[1]); exit (1);  }
   
   printf("\nTOKEN\t\t\tLEXME\t\t\tSEMANTIC VALUE\n---------------------------------------------------------------\n");

   while ((token = yylex ()) != 0)
     switch (token) {
	 case DEPARTUERS:    printf("DEPARTUERS\t\t%s\n",yylval.name);
	              break;
         case FLIGHT_NUMBER: printf ("FLIGHT_NUMBER\t\t%s\n",yylval.name);
	              break;
	 case TIME:          printf ("TIME\t\t\t%s\t\t\t%d\n",yylval.name,semantic_vals.is_am);
	              break;
	 case AIRPORT: 	     printf ("AIRPORT\t\t\t%s\n",yylval.name);
	              break;
	 case CARGO: 	     printf ("CARGO\t\t\t%s\n",yylval.name);
	              break;
	 case FREIGHT:       printf ("FREIGHT\t\t\t%s\n",yylval.name);
	              break;		              		              	              
         default: /*error Token defined in yylex */ exit (1);
     } 
   fclose (yyin);
   exit (0);

}

