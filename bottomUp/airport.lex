%{

#include "flights.tab.h"

int line = 1;

%}

%option noyywrap


%%

"<departures>" { return DEPARTUERS; }

([A-Z]{2})([0-9]{1,4}) {  return FLIGHT_NUMBER;}

(0[0-9]|1[0-2])":"[0-5][0-9]"a.m." {  yylval.DAY_TIME = A_M; return TIME; }

(0[0-9]|1[0-2])":"[0-5][0-9]"p.m." { yylval.DAY_TIME = P_M; return TIME; }

\"([A-Za-z])([A-Za-z]|" ")*\" {  return AIRPORT;}

"cargo" {  return CARGO; }

"freight" {  return FREIGHT; }

\n { line++; }

[\r\t ]+  /* skip white space */

.          { fprintf (stderr, "\n\nunrecognized token %c in  %d Line !!!\n", yytext[0],line); return -1;}

%%


