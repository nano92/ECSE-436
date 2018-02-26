%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet

%Problem 4, part f)
%Based on proof in part d) of problem 4

clear;

m =  de2bi((0:15) , 'left-msb');
[~, m_Length] = size(m);

c1 = zeros(16,4); %1/2 of total codeword bits
c2 = zeros(16,4); %1/2 of total codeword bits
codebook = zeros(16,8);

%Generating c1 and c2:
for i = 1:16
    c1(i,:) = mod(m(i,:) +[0, m(i, 1:(m_Length-1))]+[0, 0 , m(i, 1:(m_Length-2))], 2); %c1[n] = m[n] + m[n-1] + m[n-2]
    c2(i,:) = mod(m(i,:) + [0, 0 , m(i,1:(m_Length-2))], 2); %c2[n] = m[n] + m[n-2]
end

%Generating the codebook by interweaving c1 and c2:
for i = 1:16
    for j = 1:4
        codebook(i, 2*j-1) = c1(i,j);
        codebook(i, 2*j) = c2(i,j);
    end
end

codebook

%Finding dmin using the result dmin = min wt(c):
for i = 1:16
    weight(i) = sum(codebook(i, :) == 1);
end

[dmin, ~] = min(weight(2:16)) %exclude 1st entry in weight array from dmin search since it corresponds to 0 vector