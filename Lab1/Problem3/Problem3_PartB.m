%ECSE 436, Lab 1
%Group 7: Amanda Bianco and Luis Gallet

%Problem 3, part b)

clear;
 
%Source:
p_1 = 1/2;
m = rand(1,4) < p_1

%Binary Symmetric Channel:
p_error = 0.1;
[ y ] = BinarySymmetricChannel( m,  p_error );

%Codebook
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1]; %right-half of generator matrix G (parity side)
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

%Exhaustive Decoder:
v = [];
for i = 1:16
    v(i) = sum(abs(y - codebook(i,:))); %counting number of bit flips
end
[minDiff, index] = min(v); %finding index with min number of bit flips

m_hat = codebook(index,1:4) %decoded message vector m_hat is bits 1 to 4 of codeword at index with min number of bit flips