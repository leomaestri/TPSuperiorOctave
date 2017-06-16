global coefnum;
global coefden;
global polos;
global ceros;
global ganancia;
global ftran;
global opcion;
global cerosobtenidos;
global polosobtenidos;
global gananciaobtenida;
 
pkg load control;
pkg load signal;

i=0;
j=0;
z=0;

function funcion_transferencia  %terminada
  global opcion; 
  if(opcion==1)
    global ftran;
    global coefnum;
    global coefden;
    ftran= tf(str2num(cell2mat(coefnum)),str2num(cell2mat(coefden)));
  elseif(opcion==2)
    global ftran;
    global polos;
    global ceros;
    global ganancia;
    ftran=zpk(str2num(cell2mat(ceros)),str2num(cell2mat(polos)),str2num(cell2mat(ganancia)));
  endif
endfunction
 
function indicar_polos
    global opcion;
  if(opcion==1)  
    global ftran;
    global coefnum;
    global coefden;     
    ftran= tf(str2num(cell2mat(coefnum)),str2num(cell2mat(coefden)));
    [C,P,G]=tf2zp(ftran);
    for i=1:rows(P)
      msgbox(num2str(P(i,1)),"Polos");
    endfor
   
  elseif(opcion==2)
    global polos;
    msgbox(polos,"Polos");
  endif
endfunction

function calcular_polos_ceros_ganancia
  global ftran;
  global cerosobtenidos;
  global polosobtenidos;
  global gananciaobtenida;
  [cerosobtenidos,polosobtenidos,gananciaobtenida]=tf2zp(ftran);
endfunction

function indicar_ceros
  
  if(opcion==1)
  %indicar ceros
    global ftran;
    global coefnum;
    global coefden;
    
    ftran= tf(str2num(cell2mat(coefnum)),str2num(cell2mat(coefden)));
    [C,P,G]=tf2zp(ftran);
    for i=1:rows(C)
      msgbox(num2str(C(i,1)),"Ceros");
    endfor
  elseif(opcion==2)
    global ceros;
    msgbox(ceros,"Ceros");
  endif
endfunction

function indicar_ganancia %terminada
  global opcion;
  if(opcion==1)
  global gananciaobtenida;
  calcular_polos_ceros_ganancia;
  msgbox(strcat("La ganancia obtenida es: ",num2str(gananciaobtenida)),"Indicar ganancia");
  elseif(opcion==2)
    global ganancia;
    msgbox(strcat("La ganancia obtenida es: ",cell2mat(ceros)),"Indicar ganancia");
  endif
endfunction

function expresion_con_polos_ceros_ganancia %no la probe pero deberia funcionar bien cuando se complete lo que falta
  funcion_transferencia;
  indicar_polos;
  indicar_ceros;
  indicar_ganancia;
 endfunction

while z==0 || j==0
j=0;
z=0;
eleccion_1=listdlg("Name","ASIC","ListSize", [500 500],"ListString",{"Ingresar grado y coeficientes", "Ingresar polos,ceros y ganancia"},"SelectionMode","Single","CancelString","Finalizar");
switch(eleccion_1)
  case 1
    global coefnum;
    global coefden;
    global opcion;
    opcion=1;
    coefnum=inputdlg("Ingresar coeficientes del numerador","ASIC");
    coefden=inputdlg("Ingresar coeficientes del denominador","ASIC");
  case 2
    global polos;
    global ceros;
    global ganancia;
    global opcion;
    opcion=2;
    polos=inputdlg("Ingresar polos","ASIC");
    ceros=inputdlg("Ingresar ceros","ASIC");
    ganancia=inputdlg("Ingresar ganancia","ASIC");
    otherwise
    quit;
endswitch

funcion_transferencia;

eleccion_2=listdlg("Name","ASIC","ListSize", [500 500],"ListString",{"Seleccionar alguna caracteristica en particular", "Obtener todas las caracteristicas de la funcion"},"SelectionMode","Single");

switch(eleccion_2)
  case 1 %Seleccionar alguna caracteristica en particular
    while j==0
    eleccion_3=listdlg("Name","ASIC","ListSize", [500 500],"ListString",{"Obtener la expresion de la funcion transferencia", "Indicar polos","Indicar ceros","Marcar ganancia de la funcion","Obtener expresion con sus polos, ceros y ganancia","Mostrar graficamente la distribucion de polos y ceros.","Indicar estabilidad del sistema","Obtener todas las caracteristicas anteriores","Ingresar una nueva funcion"},"SelectionMode","Single","CancelString","Finalizar");   
     switch(eleccion_3)
        case 1 %muestra la funcion transferencia 
          global ftran;
          global opcion;
          msgbox(evalc ("ftran"),"Obtener la expresion de la funcion transferencia");
        case 2 %Indicar polos
          global opcion;
          indicar_polos;
        case 3 %Indicar ceros
          global opcion;
          indicar_ceros;
        case 4 %Mostrar ganancia 
          global opcion;
          indicar_ganancia;
        case 5 %Expresion con sus polos, ceros y ganancia
          expresion_con_polos_ceros_ganancia;
        case 6 %Grafico polos y ceros
          global opcion;
          global ftran;
          pzmap(ftran);
         case 7 %Estabilidad del sistema
           global ftran;
           calcular_polos_ceros_ganancia;
          if(any(real(polosobtenidos) > 0))
            msgbox("Es un sistema inestable"); %hay polos con parte real positiva
          else
            msgbox("Es un sistema estable"); %No hay polos con parte real positiva
          endif
        case 8 %Todas las anteriores
          global opcion;
          global ftran;
          msgbox(evalc ("ftran"),"Obtener la expresion de la funcion transferencia");
          indicar_polos;
          indicar_ceros;
          indicar_ganancia;
          expresion_con_polos_ceros_ganancia;
          pzmap(ftran);
          global ftran;
           calcular_polos_ceros_ganancia;
          if(any(real(polosobtenidos)) > 0)
            msgbox("Es un sistema inestable"); %hay polos con parte real positiva
          else
            msgbox("Es un sistema estable"); %No hay polos con parte real positiva
          endif 
        case 9 %Nueva funcion (falta)
          j=1;
        otherwise %!!
          j=1;
          z=1;
      endswitch
      endwhile
  case 2 %mostrar todas (1,2,3,4,5,6)
    disp("Sds");
  endswitch
 endwhile
