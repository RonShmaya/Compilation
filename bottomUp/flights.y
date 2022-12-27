%code {

#include <stdio.h>

extern int yylex (void);
void yyerror (const char *s);



}
%code requires {
	enum eday_time {
	    A_M =-1,
	    P_M =1};
}

%union {
  int DAY_TIME;
}

%token <DAY_TIME> TIME 
%token DEPARTUERS FLIGHT_NUMBER AIRPORT CARGO FREIGHT

%nterm input
%nterm <DAY_TIME> list_of_flights flight cargo_spec

%define parse.error verbose


%%

input: DEPARTUERS list_of_flights 
       { if ($2 < 0 ) 
             printf ("There were more flights before noon.\n");
         else if($2 > 0)
             printf ("There were more flights after noon.\n");
       };
       
list_of_flights: %empty        { $$ = 0;};
                        
list_of_flights: list_of_flights flight { $$ = ($1 + $2); };
       
flight: FLIGHT_NUMBER TIME AIRPORT cargo_spec
       { $$=0;
       if($4 != 0){
       	 $$=$2;	
       	} 
       };

cargo_spec: CARGO { $$ = 0; }
           | FREIGHT { $$ = 0; };
           
cargo_spec: %empty { $$ = 1; }; 

%%

int
main (int argc, char **argv)
{
  extern FILE *yyin;
  if (argc != 2) {
     fprintf (stderr, "Usage: %s input.txt\n", argv[0]);
	 return 1;
  }
  yyin = fopen (argv [1], "r");
  if (yyin == NULL) {
       fprintf (stderr, "failed to open %s\n", argv[1]);
	   return 2;
  }
  
  yyparse();
  
  fclose (yyin);
  return 0;
}

void yyerror (const char *s)
{
  extern int line;
  fprintf (stderr, "line %d: %s\n", line, s);
}



