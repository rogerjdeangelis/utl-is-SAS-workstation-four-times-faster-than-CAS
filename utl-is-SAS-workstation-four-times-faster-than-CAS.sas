Is SAS workstation four times faster that CAS                                                                       
                                                                                                                    
    Benchmarks                    Seconds                                                                           
                                                                                                                    
        $800 SAS Workstation         1.78                                                                           
        Unknown (CAS see link)       7.38                                                                           
                                                                                                                    
GitHub                                                                                                              
https://tinyurl.com/yymqavxe                                                                                        
https://github.com/rogerjdeangelis/utl-is-SAS-workstation-four-times-faster-than-CAS                                
                                                                                                                    
https://tinyurl.com/v2ta3zy                                                                                         
https://communities.sas.com/t5/SAS-Communities-Library/CAS-is-Fast/ta-p/628282                                      
                                                                                                                    
 I don't know why you would run CAS on such a tiny dataset.                                                         
 CAS could be configured to beat my workstation with big data. Input table > 1TB.                                   
                                                                                                                    
 I could not find the CAS input SAS dataset so I created by own with 160 million observations.                      
 Would like to know th CAS hardware and server cost?                                                                
                                                                                                                    
 I could not run SAS CAS code because I got this error                                                              
                                                                                                                    
    ERROR: There is no server connection to execute the action 'simple.summary'.                                    
    ERROR: Execution halted                                                                                         
                                                                                                                    
/*                   _                                                                                              
(_)_ __  _ __  _   _| |_                                                                                            
| | `_ \| `_ \| | | | __|                                                                                           
| | | | | |_) | |_| | |_                                                                                            
|_|_| |_| .__/ \__,_|\__|                                                                                           
        |_|                                                                                                         
*/                                                                                                                  
                                                                                                                    
libname spd spde ('f:\spde_f' 'm:\spde_m');                                                                         
                                                                                                                    
data spd.mega_corp(index=(fp=(facility productline)));                                                              
  length expenses revenue 3.;                                                                                       
  call streaminit(4321);                                                                                            
  do facility="A","B","C","D";                                                                                      
    do productline="X", "Y";                                                                                        
      do rec=1 to 20000000;                                                                                         
         expenses=int(100*rand('uniform'));                                                                         
         revenue=int(100*rand('uniform'));                                                                          
         output;                                                                                                    
      end;                                                                                                          
    end;                                                                                                            
  end;                                                                                                              
  drop rec;                                                                                                         
  stop;                                                                                                             
run;quit;                                                                                                           
                                                                                                                    
NOTE: The data set SPD.MEGA_CORP has 160,000,000 observations and 4 variables.                                      
NOTE: Composite index FP has been defined.                                                                          
                                                                                                                    
 SPD.MEGA_CORP total obs=160,000,000                                                                                
                                                                                                                    
    EXPENSES    REVENUE    FACILITY    PRODUCTLINE                                                                  
                                                                                                                    
       79          37         A             X                                                                       
       92          20         A             X                                                                       
       21          69         A             X                                                                       
       45          27         A             X                                                                       
       46          37         A             X                                                                       
       87          21         A             X                                                                       
       74          22         A             X                                                                       
       24          67         A             X                                                                       
     ....                                                                                                           
                                                                                                                    
/*           _               _                                                                                      
  ___  _   _| |_ _ __  _   _| |_                                                                                    
 / _ \| | | | __| `_ \| | | | __|                                                                                   
| (_) | |_| | |_| |_) | |_| | |_                                                                                    
 \___/ \__,_|\__| .__/ \__,_|\__|                                                                                   
                |_|                                                                                                 
*/                                                                                                                  
                                                                                                                    
Up to 40 obs from WANT total obs=8                                                                                  
                                                                                                                    
      PAR         _FREQ_     SUMREVENUE    SUMEXPENSES                                                              
                                                                                                                    
   SD1.PAR_AX     20000000     989993999     990169765                                                              
   SD1.PAR_BX     20000000     989961911     990242762                                                              
   SD1.PAR_CX     20000000     989837985     989981784                                                              
   SD1.PAR_DX     20000000     990062116     989880778                                                              
   SD1.PAR_AY     20000000     989994959     989762926                                                              
   SD1.PAR_BY     20000000     990028328     989939030                                                              
   SD1.PAR_CY     20000000     990088089     989837104                                                              
   SD1.PAR_DY     20000000     989777040     990250868                                                              
                                                                                                                    
/*         _       _   _                                                                                            
 ___  ___ | |_   _| |_(_) ___  _ __                                                                                 
/ __|/ _ \| | | | | __| |/ _ \| `_ \                                                                                
\__ \ (_) | | |_| | |_| | (_) | | | |                                                                               
|___/\___/|_|\__,_|\__|_|\___/|_| |_|                                                                               
  ___ __ _ ___                                                                                                      
 / __/ _` / __|                                                                                                     
| (_| (_| \__ \                                                                                                     
 \___\__,_|___/                                                                                                     
                                                                                                                    
*/                                                                                                                  
*/                                                                                                                  
                                                                                                                    
proc cas ;                                                                                                          
   simple.summary result=r status=s /                                                                               
      inputs={"revenue","expenses"},                                                                                
      subSet={"SUM"},                                                                                               
      table={                                                                                                       
         name="spd.mega_corp"                                                                                       
         caslib="visual"                                                                                            
         groupBy={"facilityType","productline"}                                                                     
      },                                                                                                            
      casout={name="summaryMC", replace=True, replication=0} ;                                                      
quit ;                                                                                                              
                                                                                                                    
ERROR: There is no server connection to execute the action 'simple.summary'.                                        
ERROR: Execution halted                                                                                             
                                                                                                                    
/*                  _        _        _   _                                                                         
__      _____  _ __| | _____| |_ __ _| |_(_) ___  _ __                                                              
\ \ /\ / / _ \| `__| |/ / __| __/ _` | __| |/ _ \| `_ \                                                             
 \ V  V / (_) | |  |   <\__ \ || (_| | |_| | (_) | | | |                                                            
  \_/\_/ \___/|_|  |_|\_\___/\__\__,_|\__|_|\___/|_| |_|                                                            
                                                                                                                    
*/                                                                                                                  
                                                                                                                    
* Load macro into autocall library;                                                                                 
filename ft15f001 "c:\oto\spar.sas";                                                                                
parmcards4;                                                                                                         
%macro spar(f,p);                                                                                                   
                                                                                                                    
 /* For testing without macro call                                                                                  
   %let f=A;                                                                                                        
   %let p=X;                                                                                                        
 */                                                                                                                 
                                                                                                                    
libname spd spde ('f:\spde_f' 'm:\spde_m');                                                                         
libname sd1 "d:/sd1";                                                                                               
                                                                                                                    
proc summary data=spd.mega_corp(where=(facility="&f" and productline="&p")) noprint nway;                           
   var revenue expenses;                                                                                            
   output out= sd1.par&f.&p sum(revenue)=sumRevenue sum(expenses)=sumExpenses;                                      
run;                                                                                                                
                                                                                                                    
%mend spar;                                                                                                         
;;;;                                                                                                                
run;quit;                                                                                                           
                                                                                                                    
/* test interactively                                                                                               
%inc "c:/oto/spar.sas";                                                                                             
%spar(A,X);                                                                                                         
*/                                                                                                                  
                                                                                                                    
/*                     _ _      _ _                                                                                 
 _ __   __ _ _ __ __ _| | | ___| (_)_______                                                                         
| `_ \ / _` | `__/ _` | | |/ _ \ | |_  / _ \                                                                        
| |_) | (_| | | | (_| | | |  __/ | |/ /  __/                                                                        
| .__/ \__,_|_|  \__,_|_|_|\___|_|_/___\___|                                                                        
|_|                                                                                                                 
*/                                                                                                                  
                                                                                                                    
%let _s=%qsysfunc(compbl(&_r\PROGRA~1\SASHome\SASFoundation\9.4\sas.exe -sysin nul -log nul -work f\wrk             
        -rsasuser -nosplash -sasautos &_r\oto -config &_r\cfg\cfgsas94m6.cfg));                                     
                                                                                                                    
options noxwait noxsync;                                                                                            
%let tym=%sysfunc(time());                                                                                          
systask kill sys02 sys04 sys06 sys08 sys10 sys12 sys14 sys16 sys18 sys20 sys22 sys24 sys26                          
sys28 sys30 sys32 sys34 sys36 sys38 sys40 sys42 sys44 sys46 sys48 sys50;                                            
                                                                                                                    
systask command "&_s -termstmt %nrstr(%spar(A,X);) -log d:\log\a02.log" taskname=sys02;                             
systask command "&_s -termstmt %nrstr(%spar(B,X);) -log d:\log\a04.log" taskname=sys04;                             
systask command "&_s -termstmt %nrstr(%spar(C,X);) -log d:\log\a06.log" taskname=sys06;                             
systask command "&_s -termstmt %nrstr(%spar(D,X);) -log d:\log\a08.log" taskname=sys08;                             
systask command "&_s -termstmt %nrstr(%spar(A,Y);) -log d:\log\a10.log" taskname=sys10;                             
systask command "&_s -termstmt %nrstr(%spar(B,Y);) -log d:\log\a12.log" taskname=sys12;                             
systask command "&_s -termstmt %nrstr(%spar(C,Y);) -log d:\log\a14.log" taskname=sys14;                             
systask command "&_s -termstmt %nrstr(%spar(D,Y);) -log d:\log\a16.log" taskname=sys16;                             
                                                                                                                    
waitfor sys02 sys04 sys06 sys08 sys10 sys12 sys14 sys16 sys18 sys20 sys22 sys24 sys26                               
sys28 sys30 sys32 sys34 sys36 sys38 sys40 sys42 sys44 sys46 sys48 sys50;                                            
                                                                                                                    
%put %sysevalf( %sysfunc(time()) - &tym);                                                                           
                                                                                                                    
data want;                                                                                                          
retain par;                                                                                                         
set                                                                                                                 
  sd1.parAX                                                                                                         
  sd1.parBX                                                                                                         
  sd1.parCX                                                                                                         
  sd1.parDX                                                                                                         
  sd1.parAY                                                                                                         
  sd1.parBY                                                                                                         
  sd1.parCY                                                                                                         
  sd1.parDY indsname=nam                                                                                            
  ;                                                                                                                 
 par=nam;                                                                                                           
                                                                                                                    
run;quit;                                                                                                           
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                                                    
                                                                                                                    
