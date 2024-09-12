      * Code modified from a post by Scott Klement on Code 400
      * https://code400.com/forum/forum/iseries-programming-languages/rpg-rpgle/143023-help-calling-rest-api-twilio-using-httpapi-using-curl-syntax-as-reference

     H dftactgrp(*no) actgrp('HTTPTEST')
     H bnddir('HTTPAPI')

      /define WEBFORMS
      /copy qrpglesrc,httpapi_h

     Ftwilsetp  if   e             disk

     D rc              s             10i 0
     D form            s                   like(WEBFORM)
     D myMessage       s          10000a   varying
     D uri             s           5000a   varying
     D encodedData     s               *
     D encodedDataLen  s             10i 0

     C     *entry        plist
     C                   parm                    phonenum         12
     C                   parm                    phonemsg       1400

      /free

       read twilsetp;
       // Create a debug/trace log to help understand what's going
       //  on -- if HTTPAPI is failing, this is the first thing
       //  to look at (and is what Scott will ask for)
       //
       // Most likely you'll want to turn this off before
       // putting the program into production.
       http_debug(*on: '/tmp/twilio_trace.txt');

       // Make sure we're using UTF-8 encoding, which
       //  is the most common standard.
       http_setCCSIDs(1208: 0);

       // Build a URL-encoded "web form" containing the data
       // sent to Twilio
       myMessage = 'Add your own Text Msg ' + phonemsg;

       form = WEBFORM_open();
       WEBFORM_setVar( form: 'To': phonenum);
       WEBFORM_setVar( form: 'From': twphone);

       // This may be wrong, not sure what variable name to
       // use for the message (is there one?)
       //
       // NOTE: This works best with HTTPAPI 1.30 or newer.
       //       older versions imposed a 256 char limit on
       //       the message.
       WEBFORM_setVar( form: 'Body': myMessage );

       // This retrieves the encoded data from the 'form'
       // object so it can be pased to http_post, below.
       WEBFORM_postData( form: encodedData: encodedDataLen);

       // This sets the login credentials.
       http_setAuth( HTTP_AUTH_BASIC
                   : %trim(twsid)
                   : %trim(twtoken));


       // Now we'll put the URI together and actually
       //  run the POST request:
        uri = 'https://api.twilio.com/2010-04-01/Accounts/'
           +   %trim(twsid) + '/'
           +   'Messages.json';

       rc = http_post( uri
                     : encodedData
                     : encodedDataLen
                     : '/tmp/twilio.txt'
                     : 60
                     : *omit
                     : 'application/x-www-form-urlencoded');

       // This frees up the memory used by the encoded data
       //  which should be done whether the request succeeded
       //  or not.
       WEBFORM_close(form);

       // This might not be what you want?  But is a quickie
       //  thing for testing. If it fails, this just sends an
       //  *ESCAPE message that crashes the program.

       if rc < 1;
          http_crash();
       endif;

       http_debug(*off);

       *inlr = *on;
      /end-free                                                           
