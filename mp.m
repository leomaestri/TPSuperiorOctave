global coefnum;
global coefden;
global polos;
global ceros;
global ganancia;
global ftran;
global opcion;
 
function funcion_transferencia (opcion)
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
 
function indicar_polos (opcion)
  if(opcion==1)
  elseif(opcion==2)
    global polos;
    msgbox(polos,"Polos");
  endif
endfunction

function indicar_ceros (opcion)
  if(opcion==1)
  %indicar ceros
  elseif(opcion==2)
    global ceros;
    msgbox(ceros,"Ceros");
  endif
endfunction

function indicar_ganancia (opcion)
  if(opcion==1)
  %indicar ganancia
  elseif(opcion==2)
    global ganancia;
    msgbox(ganancia,"Ganancia");
  endif
endfunction
 
eleccion_1=listdlg("Name","ASIC","ListSize", [300 300],"ListString",{"Ingresar grado y coeficientes", "Ingresar polos,ceros y ganancia"},"SelectionMode","Single","CancelString","Finalizar");
switch(eleccion_1)
  case 1
    global coefnum;
    global coefden;
    global opcion;
    opcion=1;
    coefnum=inputdlg("Ingresar coeficientes del numerador","ASIC");
    coefden=inputdlg("Ingresar coeficientes del denominador","ASIC");
  case 2
    disp("2");
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

eleccion_2=listdlg("Name","ASIC","ListSize", [300 300],"ListString",{"Seleccionar alguna caracteristica en particular", "Obtener todas las caracteristicas de la funcion"},"SelectionMode","Single");

switch(eleccion_2)
  case 1 %Seleccionar alguna caracteristica en particular
    eleccion_3=listdlg("Name","ASIC","ListSize", [300 300],"ListString",{"Obtener la expresion de la funcion transferencia", "Indicar polos","Indicar ceros","Marcar ganancia de la funcion","Obtener expresion con sus polos, ceros y ganancia","Mostrar graficamente la distribucion de polos y ceros.","Indicar estabilidad del sistema","Obtener todas las caracteristicas anteriores","Ingresar una nueva funcion"},"SelectionMode","Single","CancelString","Finalizar");   
     switch(eleccion_3)
        case 1 %Obtener la expresión de la función tranferencia  
          global opcion;
          funcion_transferencia(opcion);
        case 2 %Indicar polos
          global opcion;
          indicar_polos (opcion);
        case 3 %Indicar ceros
          global opcion;
          indicar_ceros (opcion);
        case 4 %Mostrar ganancia
          global opcion;
          indicar_ganancia (opcion);
        case 5 %Expresion con sus polos, ceros y ganancia
          funcion_transferencia(opcion);
          [C,P,G]=tf2zp(ftran);
          for i=1:rows(C)
            msgbox(num2str(C(i,1)),"Ceros");
          endfor
          for i=1:rows(P)
            msgbox(num2str(P(i,1)),"Polos");
          endfor
          msgbox(num2str(P));
          msgbox(num2str(G));
        case 6 %Grafico polos y ceros
          global ftran;
          global opcion;
          funcion_transferencia(opcion);
          pzmap(ftran);
        case 7 %Estabilidad del sistema
          global ftran;
           calcular_polos_ceros_ganancia;
          if(any(real(polosobtenidos) > 0))
            msgbox("Es un sistema inestable"); %hay polos con parte real positiva
          else
            msgbox("Es un sistema estable"); %No hay polos con parte real positiva
          endif 
           %con la condicion me devuelve una matriz con 1 y 0 reprencentando true y false, any testea matrizes de 0s y 1s y se fija si hay un uno       
           %si los polos son numeros complejos uso la funcion
           %Es sistema estable si: es polo real negativo, nulo, imaginario puro, polo conjugado con parte real negativa( es decir a+bj y a-bj  y a es negativo),
           %Es sistema inestable si: es polo real positivo, polo conjugado con parte real positiva
        case 8 %Todas las anteriores
        case 9 %Nueva funcion
        otherwise
          quit;  
      endswitch
  case 2 %mostrar todas (1,2,3,4,5,6)
  otherwise
    eleccion_1=listdlg("Name","ASIC","ListSize", [300 300],"ListString",{"Ingresar grado y coeficientes", "Ingresar polos,ceros y ganancia"},"SelectionMode","Single","CancelString","Finalizar");  
endswitch
