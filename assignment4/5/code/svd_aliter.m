A = [1 2 3 4; 5 6 7 8; 9 10 11 12];
[U, S, V] = svd_eig(A, 1e-6);
A - U*S*V'
function [C, D] = sort_eig(A, B)
    [b, i] = sort(diag(B), 'descend');
    D = B(i,i);
    C = A(:,i);
end

function [U, S, V] = svd_eig(A, epsilon)
    s = size(A);
    m = s(1); n = s(2);
    ATA = A'*A;
    AAT = A*A';
    [V_1, D_1] = eig(ATA);
    [V, D_1] = sort_eig(V_1, D_1);
    [U_1, D_2] = eig(AAT);
    [U, D_2] = sort_eig(U_1, D_2);
    if n > m
        S = D_1;
    else
        S = D_2;
    end
    S = sqrt(S(1:m, 1:n));
    sign = ones(1,m);
    for i = 1:min(m,n)
        if S(i,i) > epsilon % else we assume the singular value is zero
            if norm(U(:,i) - A*V(:,i)/S(i,i)) > epsilon
                sign(i) = -1;
            end
        end
    end
    U = U.*sign;
end