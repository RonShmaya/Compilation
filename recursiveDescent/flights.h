#ifndef FLIGHTS

enum eToken {
     DEPARTUERS =1, 
     FLIGHT_NUMBER,
     TIME,
     AIRPORT,
     CARGO,
     FREIGHT,    
};


char *token_name(enum eToken token);

enum eday_time {
A_M =-1,
P_M =1};

union _lexVal{
  int DAY_TIME;
};

extern union _lexVal lexicalValue;

void errorMsg(const char *s);

#endif
