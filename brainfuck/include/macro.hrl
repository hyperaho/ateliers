-define(HEADER_C,      <<"#include <stdio.h>\nint main(){">> ).
-define(INIT_C,        <<"int p[3000]; int i; i=0; ">> ).
-define(FOOTER_C,      <<"return 0;}">>                      ).
-define(ADD_C(OFFSET), <<"i[p]+=",OFFSET/binary,";">>        ).
-define(MOV_C(OFFSET), <<"i+=",OFFSET/binary, ";">>          ).
-define(OUT_C,         <<"putchar(i[p]);">>                  ).
-define(INP_C,         <<"i[p]=getchar();">>                 ).
-define(LOOP_C(C),     <<"while(i[p] !=0){",C/binary,"}">>   ).
-define(TOZERO_C,      <<"i[p]=0;">>                         ).
