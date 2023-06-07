%ALGORÍTMOS GENÉTICOS
clear;
clc;
%-------------------------------------------------------------------------------------------------------------------------------
%REALES
    AA = input('Ingrese matriz de distancias:'); %[0 100 35 36 30 18;100 0 25 65 90 30;35 25 0 10 80 39;36 65 10 0 50 70;30 90 80 50 0 48;18 30 39 70 48 0]
    t_poblacion = input('Ingrese población total:');  % 10
    ta = size(AA);
    t_ciudades = ta(1);
    elitismo = 1; %input('Elitismo; Si = 1, No = 0 :');  %Confirmar si va haber elitismo
    generaciones = t_poblacion; %input('Ingrese número de generaciones:');        %10 numero de generaciones 
    por_cruce = input('Ingrese porcentaje de cruce:');               %1 porcentaje de cruce
    mutacion = 1; %input('Ingrese porcentaje de mutación:');         %1 porcentaje de mutacion
    auxiliar = t_poblacion; %input('Ingrese numero de repeticiones:');
    mx = input('Seleccione encontrar max = 1, o min = 0:');
    cont = 0;
    
    tic
    for aux = 1:1:auxiliar
        %POBLACIÓN INICIAL
        for i =1:t_poblacion
            per = randperm(t_ciudades);
            for j =1:t_ciudades
                alet(i,j) = per(j);
            end
        end
        for gz = 1:1:generaciones 
            
            for oi = 1:t_poblacion
              for ik =1:t_ciudades-1
                  x_p(oi,ik) = alet(oi,ik);
                  y_p(oi,ik) = alet(oi,ik+1);
                  ii_poblacion(oi,ik) = AA(x_p(oi,ik),y_p(oi,ik)); 
              end
              x_p(oi,t_ciudades) = alet(oi,1);
              y_p(oi,t_ciudades) = alet(oi,t_ciudades);
              ii_poblacion(oi,t_ciudades) = AA(alet(oi,1),alet(oi,t_ciudades));
            end
            i_x_pos = transpose(x_p);
            i_y_pos = transpose(y_p);
            i_poblacion = transpose(ii_poblacion);
            
            poblacion = i_poblacion;  %P_distancia
            x_pos = i_x_pos;
            y_pos = i_y_pos;
            dist_total = sum(poblacion);
            
            %Gráfico de los mejores por generacion
            if mx == 1
                [vg, ig] = max(dist_total);
            end
            if mx == 0
                [vg, ig] = min(dist_total);
            end
            for i = 1:t_ciudades
                gana(i,gz) = poblacion(i,ig);
                gana_rut(i,gz) = alet(ig,i);
                gana_x(i,gz) = x_pos(i,ig);
                gana_y(i,gz) = y_pos(i,ig);
            end
            vgm(gz,1) = vg; 

            %SELECCIÓN
            %Torneo
                %1. Grupos
                t_grupo = t_poblacion/2;        %Cantidad de individuos por grupo (Cantidad opcional)
                %Cantidad de grupos opcional
                while (1)
                    per_t = randperm(t_poblacion);
                    for i =1:t_grupo
                        ind_grupo1(i) = per_t(i);
                    end
                    for i = t_grupo+1:t_poblacion
                        ind_grupo2(i-t_grupo) = per_t(i);
                    end

                    for i = 1:t_grupo
                        grupo1(:,i) = poblacion(:,ind_grupo1(1,i));
                        grupo2(:,i) = poblacion(:,ind_grupo2(1,i));
                    end
                    grupo1_fitness = sum(grupo1);
                    grupo2_fitness = sum(grupo2);

                    if mx == 1
                        [ap1, pos1] = max(grupo1_fitness);
                        [ap2, pos2] = max(grupo2_fitness);
                    end
                    if mx == 0
                        [ap1, pos1] = min(grupo1_fitness);
                        [ap2, pos2] = min(grupo2_fitness);
                    end
                    for i = 1:t_ciudades
                        padre1_col(i,1) = grupo1(i,pos1);
                        padre2_col(i,1) = grupo2(i,pos2);
                    end
                    padre1_s = sum(padre1_col);
                    padre2_s = sum(padre2_col);
                    if padre1_s ~= padre2_s
                        break;
                    end
                 end
                %Encontrar a la ubicacion de los padres
                col1 = 0;
                col2 = 0;
                [row1,col1] = find(padre1_s == dist_total);   %Comando find, busca dentro de toda la población la ubicacion del padre
                [row2,col2] = find(padre2_s == dist_total);
                for i = 1:t_ciudades
                    padre1(1,i) = alet(col1(1),i);
                    padre2(1,i) = alet(col2(1),i);
                end
           

            %CRUCE
            posibilidad_cruce = rand();   
            if posibilidad_cruce <= por_cruce  
                ale_c = randi([1,t_ciudades-1],1);
                for i = 1:ale_c
                    hijo1(1,i) = padre1(1,i);
                    hijo2(1,i) = padre2(1,i);
                end
                for i = ale_c+1:t_ciudades
                    hijo1(1,i) = padre2(1,i);
                    hijo2(1,i) = padre1(1,i);
                end
                
                %HIJO 1
                igual1 = 0;
                des1 = 0;
                for i = 1:t_ciudades
                    for j = t_ciudades:-1:1
                        if hijo1(1,i) == hijo1(1,j)
                           igual1 = igual1 + 1;
                           if igual1 >= 2
                              des1(1,i) = i;
                           else
                              des1(1,i) = 0;
                           end
                        end
                    end
                    igual1 = 0;
                end
                jo1 = 0;
                cam1 = [0,0];
                for oo = 1:ale_c-jo1
                    if des1(1,oo) == 0
                        jo1 = jo1+1;
                    else
                        cam1(1,oo-jo1) = des1(1,oo);
                    end
                end
                if cam1(1) ~= 0
                    while (1)
                        sus1 = randi([1,t_ciudades],1);
                        nop = 0;
                        for i = 1:cam1(1)-1
                            if hijo1(1,i)== sus1
                                nop = nop + 1;
                            end
                        end
                        for j = cam1(1)+1:t_ciudades
                            if hijo1(1,j)== sus1
                                nop = nop + 1;
                            end
                        end
                        if nop == 0
                            break;
                        end
                    end
                    hijo1(1,cam1(1)) = sus1;
                else
                    cam1(2) = 0;
                end
                
                if cam1(2) ~= 0
                    while (1)
                        sus11 = randi([1,t_ciudades],1);
                        nop1 = 0;
                        for i = 1:cam1(2)-1
                            if hijo1(1,i)== sus11
                                nop1 = nop1 + 1;
                            end
                        end
                        for j = cam1(2)+1:t_ciudades
                            if hijo1(1,j)== sus11
                                nop1 = nop1 + 1;
                            end
                        end
                        if nop1 == 0
                            break;
                        end
                    end
                    hijo1(1,cam1(2)) = sus11;
                end
                %HIJO 2
                igual2 = 0;
                des2 = 0;
                for i = 1:t_ciudades
                    for j = t_ciudades:-1:1
                        if hijo2(1,i) == hijo2(1,j)
                           igual2 = igual2 + 1;
                           if igual2 >= 2
                              des2(1,i) = i;
                           else
                              des2(1,i) = 0;
                           end
                        end
                    end
                    igual2 = 0;
                end
                jo2 = 0;
                cam2 = [0,0];
                for oo = 1:ale_c-jo2
                    if des2(1,oo) == 0
                        jo2 = jo2+1;
                    else
                        cam2(1,oo-jo2) = des2(1,oo);
                    end
                end
                if cam2(1) ~= 0
                     while (1)
                        sus2 = randi([1,t_ciudades],1);
                        nop2 = 0;
                        for i = 1:cam2(1)-1
                            if hijo2(1,i)== sus2
                                nop2 = nop2 + 1;
                            end
                        end
                        for j = cam2(1)+1:t_ciudades
                            if hijo2(1,j)== sus2
                                nop2 = nop2 + 1;
                            end
                        end
                        if nop2 == 0
                            break;
                        end
                    end
                    hijo2(1,cam2(1)) = sus2;
                else
                    cam2(2) = 0;
                end
               
                if cam2(2) ~= 0
                    while (1)
                        sus22 = randi([1,t_ciudades],1);
                        nop22 = 0;
                        for i = 1:cam2(2)-1
                            if hijo2(1,i)== sus22
                                nop22 = nop22 + 1;
                            end
                        end
                        for j = cam2(2)+1:t_ciudades
                            if hijo2(1,j)== sus22
                                nop22 = nop22 + 1;
                            end
                        end
                        if nop22 == 0
                            break;
                        end
                     end
                    hijo2(1,cam2(2)) = sus22;
                end
                 
                posibilidad_mutacion = 0;
            else
                posibilidad_mutacion = 1;
                hijo1 = padre1;
                hijo2 = padre2;
            end

            %Hijos antes de la mutación
            Hijo1_AM = hijo1;
            Hijo2_AM = hijo2;

            %MUTACIÓN
            %Mutación un solo cambio
            if posibilidad_mutacion == 0  %Si existió cruce, entonces hay mutación de hijos
               
                mutar1 = randperm(t_ciudades,2);
                hijo1(1,mutar1(2))= Hijo1_AM(1,mutar1(1));
                hijo1(1,mutar1(1))= Hijo1_AM(1,mutar1(2));

                mutar2 = randi([1,t_ciudades-1],1,2);
                hijo2(1,mutar2(2))= Hijo2_AM(1,mutar2(1));
                hijo2(1,mutar2(1))= Hijo2_AM(1,mutar2(2));

            end
            hijo1_f = transpose(hijo1);
            hijo2_f = transpose(hijo2);
            %REEMPLAZO
            %Reemplazo de padres
            %Rutas antes
            alet_antes = alet;
            for i = 1:t_ciudades
                alet(col1(1),i) = hijo1_f(i); 
                alet(col2(1),i) = hijo2_f(i);
            end
            

            %ELITISMO
            if elitismo == 1
                for i=1:t_ciudades
                    alet(ig,i) = gana_rut(i,gz);
                end
            end
        end
    
    %Se acaba Generacioes
        ultimo(aux,1) = vgm(generaciones,1);
        for i = 1:t_ciudades
            ruff(aux,i) = gana_rut(i,ig); 
        end
    end
    
    for oi = 1:t_poblacion
        for ik =1:t_ciudades-1
            x_pf(oi,ik) = ruff(oi,ik);
            y_pf(oi,ik) = ruff(oi,ik+1);
            ii_poblacionf(oi,ik) = AA(x_pf(oi,ik),y_pf(oi,ik)); 
        end
        x_pf(oi,t_ciudades) = ruff(oi,1);
        y_pf(oi,t_ciudades) = ruff(oi,t_ciudades);
        ii_poblacionf(oi,t_ciudades) = AA(ruff(oi,1),ruff(oi,t_ciudades));
    end
    i_x_posf = transpose(x_pf);
    i_y_posf = transpose(y_pf);
    i_poblacionf = transpose(ii_poblacionf);
          
    poblacionf = i_poblacionf;  %P_distancia
    x_posf = i_x_posf;
    y_posf = i_y_posf;
    dist_totalf = sum(poblacionf);
    
    ull = min(ultimo);
    [rr,cc] = find(ull == dist_totalf);
    for i = 1:auxiliar
        if ull == ultimo(i,1)
            cont = cont + 1;
        end
    end
    for i = 1:t_ciudades
        Rt(1,i) = ruff(cc(1),i);
    end
    fprintf('Confiabilidad.Por: %3.3f \n',(cont*100)/auxiliar)
    fprintf('Mejor ruta = %d km\n',ull)
    disp('Ciudades:')
    disp(Rt)
    %Gráfico de iteraciones
    x = 1:1:auxiliar;
    figure('Name','Resultado de las generaciones','NumberTitle','off')
    plot(x,ultimo)
    xlabel('Resultado de N generaciones por iteracion') 
    ylabel('Valor Máximo de Ruta por iteración') 
    title('Gráfica de confiabilidad')
    grid on
    hold on
    toc


