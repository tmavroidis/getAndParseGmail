**free
// replace <library> with your work library

ctl-opt dftactgrp(*no) optimize(*none);

dcl-ds WorkFile_ds extname('<Library>/TEMPSMS')
                     qualified ;
end-ds ;

dcl-s dtrcvd  char(30);
dcl-s phonein char(10);
dcl-s messid  char(70);
dcl-s foundit int(10:0);  

dcl-ds retsmsd dtaara;
       smsMessage char(2000);
end-ds;

Dcl-pr twiliopost Extpgm;
  *N char(12);
  *N char(1400);
END-PR;

Dcl-s twilio#       char(12);
Dcl-s twilioMessage char(1400);

In retsmsd;

exec sql declare c0 cursor for
              select * from <library>/tempsms ;

exec sql open c0 ;

dow (1 = 1) ;
    exec sql fetch next from c0 into :workfile_ds ;
    if (SQLCOD <> 0) ;
      leave ;
    endif ;

  if (%subst(WorkFile_ds.tempsms:1:5) = 'Date:') ;
      dtrcvd = %subst(WorkFile_ds.tempsms:6:20);
      messid = %subst(WorkFile_ds.tempsms:6:70);
  ENDIF;

  Foundit = %scan('You received a voicemail from':WorkFile_ds.tempsms) ;
  if (Foundit > 0) ;
     phonein = %subst(Workfile_ds.tempsms:(Foundit + 30):3) +
              %subst(Workfile_ds.tempsms:(Foundit + 34):3)  +
              %subst(Workfile_ds.tempsms:(Foundit + 38):4) ;
      exec sql insert into <library>.retsmsp
                    (messid,phonein,dtrcvd)
             values (:messid,:phonein,:dtrcvd) with nc;
      twilio# = '+1' + phonein;
      twilioMessage =  smsMessage;
      twiliopost(twilio#:twilioMessage);
  endif ;
enddo;

exec sql close c0;
*inlr = *on;
return;                  
