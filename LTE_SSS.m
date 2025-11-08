%x(i+5) = (x(i+2) + x(i)) mod 2
%=> f(x) = x^5 + x^2 + 1
clear;
clc;
p = 2; %GF(2)
f = [1 0 1 0 0 1]; %f(x) = x^5 + x^2 + 1
L = gf(zeros(31, 5), 1); %GF(2)
for i = 0:30 
    g = [zeros(1, i) 1];
    [quot, remd] = gfdeconv(g, f, p);
    L(i+1,:) = [remd, zeros(1, 5 - length(remd))];
end

x = gf(zeros(1, 31), 1); %GF(2)
x(1:4) = 0;
x(5) = 1;
for i=1:26
    x(i+5) = x(i+2) + x(i);
end
M = gf(zeros(31, 31), 1); %GF(2)
for i = 1:31
    for j = 1:31
        M(i,j) = x(1,mod(i + j - 2 + 31, 31)+1);
    end
end
S = M(1:5,:);
N = L * S;
% M - N

L1 = gf(zeros(32, 5), 1); %GF(2)
L1(2:end,:) = L;
S1 = gf(zeros(5, 32), 1); %GF(2)
S1(:,2:end) = S;
M1 = L1 * S1;

B = gf(zeros(32, 5), 1); %GF(2)
for i = 0:31
    B(i+1,:) = de2bi(i, 5, 'left-msb');
end
B1 = B';

L2 = L1;
for i = 1:32
    for j = 1:32
        if B(i,:) == L1(j,:)
%             P_L(i) = j;
%             L2(i,:) = L1(P_L(i),:);
            P_L(j) = i;
            L2(P_L(j),:) = L1(i,:);
            break;
        end
    end
end
% L2 - B

S2 = S1;
for i = 1:32
    for j = 1:32
        if B1(:,i) == S1(:,j)
            P_S(i) = j;
%             P_S(j) = i;
            S2(:,i) = S1(:,P_S(i));
            break;
        end
    end
end
% S2 - B1

M2 = M1;
for i =1:32
%     M2(i,:) = M1(P_L(i),:);
    M2(P_L(i),:) = M1(i,:);
end
M1 = M2;
for i =1:32
    M2(:,i) = M1(:,P_S(i));
end
M2 - B*B'

% H = B*B';
% Hx = 1 - 2*double(H.x);
% M2 = double(M1.x);
% for i =1:128
%     temp_M = M1(P_L(i),:);
%     M2(i,:) = double(temp_M.x);
% %     temp_M = M1(i,:);
% %     M2(P_L(i),:) = double(temp_M.x);
% end
% M3 = Hx * M2'
% % M4 = M3;
% % for i =1:128
% %     M4(:,i) = M3(:,P_S(i));
% % end
% % M4
