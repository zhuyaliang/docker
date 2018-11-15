create  or replace package dbms_obfuscation_toolkit 
    as 
    
    function DESEncrypt(
     input_string      IN    text,
     key_string        IN    text )
    returns   text;  
   
    procedure DESEncrypt(
     input_string      IN    text,
     key_string        IN    text,
     encrypted_string  OUT   text );
 
    function DESDecrypt(
     input_string      IN    text,
     key_string        IN    text )
    returns text; 
   
    procedure DESDecrypt(
     input_string      IN    text,
     key_string        IN    text,
     decrypted_string  OUT   text );
   
end dbms_obfuscation_toolkit; 
