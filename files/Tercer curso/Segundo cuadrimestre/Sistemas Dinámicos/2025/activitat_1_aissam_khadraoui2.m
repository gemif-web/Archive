
Nmax = 19;
N = Nmax + 1;
syms x;
f_expr = 0.5*x*(1 - x);
A = serieTaylor(f_expr, N);
B = conjugacio(A, N);
disp('Coefficients de Taylor de f(x):');
disp(A);
disp('Coefficients de la conjugació h(x):');
disp(B);
HF = composicio(B, A, N);
LHSeries = HF;
RHSeries = A(2) * B;
disp('Coefficients de h(f(x)):');
disp(LHSeries);
disp('Coefficients de f''(0)*h(x):');
disp(RHSeries);

function S = verificaVector(A, N)
    if length(A) < N
       error('Error: el vector té menys elements del necessari.');
    elseif length(A) > N
       warning('Avís: el vector té més elements del necessari; truncant.');
       S = A(1:N);
    else
       S = A;
    end
end

function S = serieTaylor(f, N)
    syms x;
    s_sym = taylor(f, x, 'Order', N);
    c_sym = coeffs(s_sym, x, 'All');
    S = double(fliplr(vpa(c_sym)));
    if length(S) < N
        S = [S, zeros(1, N - length(S))];
    end
end

function S = tallar_serie(A, N, a, b)
    if (a < 1 || b > N)
        error('Error: Índexs de tall incorrectes.');
    end
    S = zeros(1, N);
    S(a:b) = A(a:b);
end

function S = suma(A, B, N)
    S = A + B;
end

function S = multiplicar(A, B, N)
    S = zeros(1, N);
    for i = 1:N
        for j = 1:i
            S(i) = S(i) + A(j)*B(i-j+1);
        end
    end
end

function S = composicio(A, B, N)
    p_act = zeros(1, N);
    p_act(1) = 1;
    S = A(1)*p_act;
    for i = 2:N
        p_act = multiplicar(p_act, B, N);
        S = suma(S, A(i)*p_act, N);
    end
end

function B = conjugacio(A, N)
    lambda = A(2);
    B = zeros(1, N);
    B(1) = 0;
    B(2) = 1;
    
    for n = 2:(N-1)
        B_trunc = tallar_serie(B, N, 2, n);  
        A_trunc = tallar_serie(A, N, 2, n);
        sum_terms = composicio(B_trunc, A_trunc, N);
        
        num = A(n+1) + sum_terms(n+1);
        denom = lambda^n - lambda;
        
        if abs(denom) < 1e-12
            B(n+1) = 0;
        else
            B(n+1) = -num / denom;
        end
    end
end



function c = potencia(A, m, n)
    N_local = n + 1;
    if m == 1
        if (n+1) <= length(A)
            c = A(n+1);
        else
            c = 0;
        end
    else
        S = A;
        for j = 2:m
            S = multiplicar(S, A, N_local);
        end
        if length(S) >= n+1
            c = S(n+1);
        else
            c = 0;
        end
    end
end
