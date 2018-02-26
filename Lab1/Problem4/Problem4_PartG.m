%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet

%Problem 4, part g)

clear;

%Generating the codebook:
m =  horzcat(de2bi((0:15) , 'left-msb'), zeros(16,2)); %message vector with two dummy zeros to flush shift registers
[~, m_Length] = size(m);

c1 = zeros(16,6); %1/2 of total codeword bits
c2 = zeros(16,6); %1/2 of total codeword bits
codebook = zeros(16,12);


%Generating c1 and c2:
for i = 1:16
    c1(i,:) = mod(m(i,:) +[0, m(i, 1:(m_Length-1))]+[0, 0 , m(i, 1:(m_Length-2))], 2); %c1[n] = m[n] + m[n-1] + m[n-2]
    c2(i,:) = mod(m(i,:) + [0, 0 , m(i,1:(m_Length-2))], 2); %c2[n] = m[n] + m[n-2]
end

%Generating the codebook by interweaving c1 and c2:
for i = 1:16
    for j = 1:6
        codebook(i, 2*j-1) = c1(i,j);
        codebook(i, 2*j) = c2(i,j);
    end
end

codebook


%Received  vector:
r = [ -0.1 0.4 0.9 0.45 0.5 1.3 -0.6 -1.3 0.2 0.4 0.5 0.7]';

%Using exhaustive decoding to determine codeword that is closest to r in
%terms of minimum square Euclidean distance:
for i = 1:16
    euclideanDistance(i) = (r-codebook(i,:)')'*(r-codebook(i,:)');
end

[~, index] = min(euclideanDistance);
codeword = codebook(index, :)

