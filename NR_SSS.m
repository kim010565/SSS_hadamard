%x1(i+7) = (x1(i+1) + x1(i)) mod 2
%=> f(x) = x^7 + x + 1
clear;
clc;
p = 2; %GF(2)
f = [1 1 0 0 0 0 0 1]; %f(x) = x^7 + x + 1
L = gf(zeros(127, 7), 1); %GF(2)
for i = 0:126
    g = [zeros(1, i) 1];
    [quot, remd] = gfdeconv(g, f, p);
    L(i+1,:) = [remd, zeros(1, 7 - length(remd))];
end

x = gf(zeros(1, 127), 1); %GF(2)
x(1:6) = 0;
x(7) = 1;
for i=1:120
    x(i+7) = x(i+1) + x(i);
end
M = gf(zeros(127, 127), 1); %GF(2)
for i = 1:127
    for j = 1:127
        M(i,j) = x(1,mod(i + j - 2 + 127, 127)+1);
    end
end
S = M(1:7,:);
N = L * S;
% M - N

L1 = gf(zeros(128, 7), 1); %GF(2)
L1(2:end,:) = L;
S1 = gf(zeros(7, 128), 1); %GF(2)
S1(:,2:end) = S;
M1 = L1 * S1;

B = gf(zeros(128, 7), 1); %GF(2)
for i = 0:127
    B(i+1,:) = de2bi(i, 7, 'left-msb');
end
B1 = B';

L2 = L1;
for i = 1:128
    for j = 1:128
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
for i = 1:128
    for j = 1:128
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
for i =1:128
%     M2(i,:) = M1(P_L(i),:);
    M2(P_L(i),:) = M1(i,:);
end
M1 = M2;
for i =1:128
    M2(:,i) = M1(:,P_S(i));
end
% M2 - B*B'

x_SSS = gf(zeros(1, 127), 1); %GF(2)
x_SSS(2:7) = 0;
x_SSS(1) = 1;
for i=1:120
    x_SSS(i+7) = x_SSS(i+1) + x_SSS(i);
end
M_SSS = gf(zeros(127, 127), 1); %GF(2)
for i = 1:127
    for j = 1:127
        M_SSS(i,j) = x_SSS(1,mod(i + j - 2 + 127, 127)+1);
    end
end
M_SSS(:,2:end) - M(:,1:126)
M_SSS(:,1) - M(:,127)



