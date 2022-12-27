#include <stdio.h>
#include <stdlib.h> 
#include "flights.h"
#define NOTHING 0
#define COUNTERABLE_FLIGHT 1

extern enum eToken yylex (void);
enum eToken lookahead;


void input();
int list_of_flights();
int flight(); 
int cargo_spec(); 


void match(int expectedToken)
{
    if (lookahead == expectedToken)
        lookahead = yylex();
    else {
        char e[100]; 
        sprintf(e, "error: expected token %s, found token %s", 
                token_name(expectedToken), token_name(lookahead));
        errorMsg(e);
        exit(1);
    }
}

void parse()
{
    lookahead = yylex();
    input();
    if (lookahead != 0) {  
        errorMsg("EOF expected");
        exit(1);
    }
}

void 
input()
{
    match(DEPARTUERS);
    int am_pm_counter = list_of_flights();
    if (am_pm_counter < 0) 
        printf ("There were more flights before noon.\n");
    else if(am_pm_counter > 0)
        printf ("There were more flights after noon.\n");
}
   
int
list_of_flights()
{
    int am_pm_counter = 0;
    while (lookahead == FLIGHT_NUMBER) {
        am_pm_counter += flight();
    
    }
    return am_pm_counter;
}

int
flight() 
{
    int date_type=0;
    match(FLIGHT_NUMBER);
    match(TIME);
    date_type = lexicalValue.DAY_TIME;
    match(AIRPORT);

    if(cargo_spec() == NOTHING ){
	return NOTHING;
    }
    return date_type;


}
   
int cargo_spec(){
	if(lookahead == CARGO){
		match(CARGO);
		return NOTHING ;
	}
	else if(lookahead == FREIGHT){
		match(FREIGHT);
		return NOTHING ;
	}
	return COUNTERABLE_FLIGHT;
}

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
  
    parse();
  
    fclose (yyin);
    return 0;
}

void errorMsg(const char *s)
{
  extern int line;
  fprintf (stderr, "line %d: %s\n", line, s);
}





