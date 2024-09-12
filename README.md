# getAndParseGmail
Fetch mail from a gmail account to process on the IBM i  
email has become increasingly difficult to use since the introduction of SPF, DKIM and DMARC records to DNS. 
Programs that worked for years all of a sudden stop working and you are left with the task of figuring out what went wrong.
I have used IONOS for a very long time, since they were 1and1, and while they are not the most helpful in troubleshooting problems, you could never argue about the price.
My application was based on incoming calls to Bell's Message centre when an order was placed. When a call would arrive it would send out an email to my email account at IONOS that I would then pickup and parse on the IBM i.
Once processed, it would automatically send out a note to the sender's phone using Twilio letting them know that the message was received and was being processed.
Bell decided to change the layout of the forwarding emails and I started receiving "The response from the remote server was:501 Syntax error - line too long"
I tried many different ways to correct the error, but to no avail. This was a problem only with the IONOS server.
I redirected the email to a gmail acount that received the mail correctly, but now I had to modify the routines to pickup the mail from gmail instead. 
Not a trivial task, but after much trial and error I was able to put together a script that works.
In order to automate gmail, the account has to have 2fa enabled and you need to create an app password.  https://support.google.com/mail/answer/185833?hl=en 
Once that is done use your app password to access the account.
