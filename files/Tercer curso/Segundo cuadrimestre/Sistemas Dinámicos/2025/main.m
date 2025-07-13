%{
####################################################################
##    ACTIVITAT CÀLCUL DE CONJUGACIÓ TEOREMA HARTMAN-GROBMAN      ##
##                     AISSAM KHADRAOUI                           ##
##                       MARÇ DE 2025                             ##
####################################################################
%}

% Programa principal que pregunta si vols executar els tests predefinits
% o bé entrar una funció personalitzada, i llavors crida la funció
% 'executaConjugacio' per calcular la conjugació.

% Assegura't que la classe Serie.m estigui al path de MATLAB o que aquest
% codi es trobi a la mateixa carpeta que Serie.m
import Serie.*

% Demana a l'usuari que indiqui l'opció:
fprintf('-------------------------------------------\n');
fprintf('Programa per calcular conjugacions de Hartman-Grobman\n');
fprintf('-------------------------------------------\n');
opcio = input('Vols executar els tests predefinits (1) o una funció personalitzada (2)? ');

if opcio == 1
    % Seleccionar el/els test a calcular
    fprintf('Selecciona quin test vols executar:\n');
    fprintf('0: Tots\n');
    fprintf('1: r*x*(1-x) per r = [0.5, 1.5] i punt fix 0\n');
    fprintf('2: x^2 + r, amb r = -1 i punts fixos (1+sqrt(5))/2 i (1-sqrt(5))/2\n');
    fprintf('3: r*sin(x) amb r = 0.5 i punt fix 0\n');
    fprintf('4: r*x - x^3 per r = [0.5, 5] i punt fix 0\n');
    fprintf('5: r*x*exp(-x) amb r = -0.5 i punt fix 0\n');
    test = input('Introdueix el número de l''opció (per defecte tots): ', 's');
    
    % Verificar una entrada correcta
    if isempty(test)
        test = 0;
    else
        % Converteix la cadena a nombre
        test = str2double(test);
        % Comprova que sigui un escalar numèric i entre 0 i 5
        if isnan(test) || (~isscalar(test) && ~isnumeric(test)) || test < 0 || test > 5 ||  mod(test, 1) ~= 0
            error('Test introduit no vàlid');
        end
    end

    N = input('Introdueix l''ordre N de la sèrie (per defecte 10): ', 's');
    % Si no s'ha introduït res, s'usa el valor per defecte 10
    if isempty(N)
        N = 10;
    else
        % Converteix la cadena a nombre
        N = str2double(N);
        % Comprova que sigui un escalar numèric i major o igual a 1
        if isnan(N) || (~isscalar(N) && ~isnumeric(N)) || N < 1 ||  mod(N, 1) ~= 0
            error('Nombre de termes introduit no vàlid');
        end
    end
    
    % Demanem a l'usuari per escollir entre conjugate i conjugate_fast
    fprintf('\nEscull el mètode de conjugació:\n');
    fprintf('1: conjugate\n');
    fprintf('2: conjugate_fast\n');
    metode = input('Introdueix 1 o 2: ');
    
    % Verifiquem l'entrada
    if metode == 1
        metodeConjugacio = 'conjugate';
    elseif metode == 2
        metodeConjugacio = 'conjugate_fast';
    else
        error('Opcio no vàlida. Si us plau, introdueix 1 o 2.');
    end

    % Crida la funció de tests predefinits
    [resultatTest1, resultatTest2, resultatTest3, resultatTest4, resultatTest5] = provaConjugacions(N, test, metodeConjugacio);
elseif opcio == 2
    % Funció personalitzada
    % Demana l'expressió de la funció (en termes de x i r)
    customFuncStr = input('Introdueix l''expressió de la funció (ex: r*x*sin(x)): ', 's');
    % Converteix la cadena a una expressió simbòlica
    customExpr = str2sym(customFuncStr);
    
    % Demana el valor del paràmetre r
    r_val = input('Introdueix el valor de r: ', 's');
    % Converteix la cadena a nombre
    r_val = str2double(r_val);
    % Comprova que sigui un escalar numèric
    if isnan(r_val) || (~isscalar(r_val) && ~isnumeric(r_val))
        error('Paràmetre r introduit no vàlid');
    end
    % Demana el valor del punt fix
    fixedPoint = input('Introdueix el punt fix (per defecte 0): ', 's');
    % Si no s'ha introduït res, s'usa el valor per defecte 0
    if isempty(fixedPoint)
        fixedPoint = 0;
    else
        % Converteix la cadena a nombre
        fixedPoint = str2double(fixedPoint);
        % Comprova que sigui un escalar numèric
        if isnan(fixedPoint) || (~isscalar(fixedPoint) && ~isnumeric(fixedPoint))
            error('Punt fix introduit no vàlid');
        end
    end
    % Demana l'ordre de la sèrie (N)
    N = input('Introdueix l''ordre N de la sèrie (per defecte 10): ', 's');
    % Si no s'ha introduït res, s'usa el valor per defecte 10
    if isempty(N)
        N = 10;
    else
        % Converteix la cadena a nombre
        N = str2double(N);
        % Comprova que sigui un escalar numèric i major o igual a 1
        if isnan(N) || (~isscalar(N) && ~isnumeric(N)) || N < 1 ||  mod(N, 1) ~= 0
            error('Nombre de termes introduit no vàlid');
        end
    end
    
    % Demanem a l'usuari per escollir entre conjugate i conjugate_fast
    fprintf('\nEscull el mètode de conjugació:\n');
    fprintf('1: conjugate\n');
    fprintf('2: conjugate_fast\n');
    metode = input('Introdueix 1 o 2: ');
    
    % Verifiquem l'entrada
    if metode == 1
        metodeConjugacio = 'conjugate';
    elseif metode == 2
        metodeConjugacio = 'conjugate_fast';
    else
        error('Opcio no vàlida. Si us plau, introdueix 1 o 2.');
    end
    
    % Passem el mètode escollit a la funció
    resultat = executaConjugacio(customExpr, r_val, N, fixedPoint, '', metodeConjugacio);
else
    fprintf('Opció no vàlida.\n');
end




function [resultats1, resultats2, resultats3, resultats4, resultats5] = provaConjugacions(N, test, metodeConjugacio)
    % Aquesta funció executa diferents tests de conjugació utilitzant la classe Serie.
    % Es defineixen els diferents casos de test i es crida la funció executaConjugacio.  
    
    syms x r;  % Declarem r per a la substitució si cal

    resultats1 = zeros(1,N);
    resultats2 = zeros(1,N);
    resultats3 = zeros(1,N);
    resultats4 = zeros(1,N);
    resultats5 = zeros(1,N);

    if (test == 1 || test == 0)
        %----------------------------------------------------------------------
        % Test 1: f_r(x) = r*x*(1-x) per r = [0.5, 1.5] i punt fix 0
        %----------------------------------------------------------------------
        disp('========================================');
        disp('Test 1: f_r(x) = r*x*(1-x)');
        f_expr = r*x*(1 - x); % Expressió en funció de x i r
        r_vals = [0.5, 1.5];
        puntsFix = 0;
        resultats1 = executaConjugacio(f_expr, r_vals, N, puntsFix, 'f_r(x)=r*x*(1-x)', metodeConjugacio);
    end
    if (test == 2 || test == 0)
        %----------------------------------------------------------------------
        % Test 2: Q_r(x) = x^2 + r, amb r = -1
        % Utilitzem punts fix pre-calculats: (1+sqrt(5))/2 i (1-sqrt(5))/2
        %----------------------------------------------------------------------
        disp('========================================');
        disp('Test 2: Q_r(x) = x^2 + r');
        f_expr = x^2 + r;
        r_vals = -1;
        puntsFix = [(1+sqrt(5))/2, (1-sqrt(5))/2];
        resultats2 = executaConjugacio(f_expr, r_vals, N, puntsFix, 'Q_r(x)=x^2+r', metodeConjugacio);
    end
    if (test == 3 || test == 0)
        %----------------------------------------------------------------------
        % Test 3: S_r(x) = r*sin(x) amb r = 0.5 i punt fix 0
        %----------------------------------------------------------------------
        disp('========================================');
        disp('Test 3: S_r(x) = r*sin(x)');
        f_expr = r*sin(x);
        r_vals = 0.5;
        puntsFix = 0;
        resultats3 = executaConjugacio(f_expr, r_vals, N, puntsFix, 'S_r(x)=r*sin(x)', metodeConjugacio);
    end
    if (test == 4 || test == 0)
        %----------------------------------------------------------------------
        % Test 4: p_r(x) = r*x - x^3 per r = [0.5, 5] i punt fix 0
        %----------------------------------------------------------------------
        disp('========================================');
        disp('Test 4: p_r(x) = r*x - x^3');
        f_expr = r*x - x^3;
        r_vals = [0.5, 5];
        puntsFix = 0;
        resultats4 = executaConjugacio(f_expr, r_vals, N, puntsFix, 'p_r(x)=r*x-x^3', metodeConjugacio);
    end
    if (test == 5 || test == 0)
        %----------------------------------------------------------------------
        % Test 5: f(x) = r*x*exp(-x) amb r = -0.5 i punt fix 0
        %----------------------------------------------------------------------
        disp('========================================');
        disp('Test 5: f(x) = r*x*exp(-x)');
        f_expr = r*x*exp(-x);
        r_vals = -0.5;
        puntsFix = 0;
        resultats5 = executaConjugacio(f_expr, r_vals, N, puntsFix, 'f(x)=r*x*exp(-x)', metodeConjugacio);
    end

    disp('========================================');
    disp('Final de la prova de conjugacions!');
end







function resultats = executaConjugacio(f_expr, r_vals, N, puntsFix, testName, method)
    % executaConjugacio calcula la conjugació d'una funció per totes les combinacions
    % de paràmetres r i punts fix, imprimeix els resultats en català i retorna un vector
    % d'estructures amb els resultats.
    %
    % Entrades:
    %   f_expr   - Expressió simbòlica de la funció (pot dependre de x i r)
    %   r_vals   - Vector (o escalar) de paràmetres r
    %   N        - Ordre de la sèrie
    %   puntsFix - Vector (o escalar) de punts fix on calcular la conjugació
    %   testName - Títol del test (si és buit, no s'imprimeix cap títol)
    %   method   - Mètode per conjugar
    %
    % Sortides:
    %   resultats - Vector d'estructures amb els camps:
    %         .r         -> Valor del paràmetre r
    %         .p         -> Punt fix
    %         .B         -> Objecte Serie de la conjugació
    %         .num_coinc -> Nombre de coincidències
    %         .t         -> Temps que ha trigat el càlcul de conjugació

    syms x r;  % Variable simbòlica per l'expansió
    idx = 1;  % Índex per al vector de resultats
    resultats = [];
    
    % Itera sobre cada valor de r
    for current_r = r_vals
        % Substitueix el paràmetre r en l'expressió (si cal)
        f_expr_r = subs(f_expr, r, current_r);
        % Itera sobre cada punt fix
        for current_p = puntsFix(:)'  % Assegura que puntsFix és un vector fila
            % Imprimeix la capçalera només si testName no és buit
            if ~isempty(testName)
                fprintf('\n----- Test %s: r = %.4f, punt fix p = %.4f -----\n', testName, current_r, current_p);
            else
                fprintf('\n----- r = %.4f, punt fix p = %.4f -----\n', current_r, current_p);
            end
            
            % Realitza el canvi de variable: x → (x + current_p)
            f_expr_p = subs(f_expr_r, x, x + current_p);
            
            % Crea l'objecte Serie a partir de la funció modificada
            A = Serie.fromFunction(f_expr_p, N, current_p);
            
            % Crida la funció escollida per l'usuari
            if (strcmp(method,'conjugate'))
                [B, num_coinc, t] = A.conjugate();
            elseif (strcmp(method,'conjugate_fast'))
                [B, num_coinc, t] = A.conjugate_fast();
            else
                error("Mètode de conjugació no esperat");
            end
            
            % Format compactat dels coeficients amb 3 decimals
            coef_str = sprintf('%.3f ', B.Coeffs);
            coef_str = strtrim(coef_str);
            
            % Imprimeix els resultats en català
            fprintf('Conjugació simbòlica: %s\n', char(B.SymbolicExpr));
            fprintf('Coeficients de la conjugació: [%s]\n', coef_str);
            fprintf('Nombre de coincidències entre termes de f(h(x)) i h(L(x)): %d\n', num_coinc);
            fprintf('Temps trigat: %fs\n', t);
            
            % Desa els resultats en una estructura
            resultats(idx).r = current_r;
            resultats(idx).p = current_p;
            resultats(idx).B = B;
            resultats(idx).num_coinc = num_coinc;
            resultats(idx).t = t;
            idx = idx + 1;
        end
    end
end
