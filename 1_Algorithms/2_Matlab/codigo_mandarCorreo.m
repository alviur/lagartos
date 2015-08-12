%==================================================
% Codigo para mandar correo 
%
%
%=================================================



try
    a=[1 2 3;4 5 6];
    b=[1 2 3];
    C=a*b;
    mandarCorreo('alexander.gomezv@udea.edu.co','password','Acabo codigo','alviurlex@gmail.com');
    
catch theErrorInfo
    
    mandarCorreo('alexander.gomezv@udea.edu.co','qaviko73','Error en ejecucion',theErrorInfo.message,'alviurlex@gmail.com');
    
end