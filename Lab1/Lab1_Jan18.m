%ECSE 436, Lab 1
%Amanda Bianco and Luis Gallet
%January 18th, 2018


clear;

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1;

%Encoder:
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
c = mod(m*G,2);

%Erasure Channel:
p_E = 0.1; %only 10% of the bits will be erased
E = (1/2)*(rand(1,8) < p_E);
y = abs(c-E)

%Decoder:
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

counter = 0;
for i = 1:16
    
    if (max(abs(y-codebook(i,:))) ~= 1)
        counter = counter + 1;
        match_index = i
    end
    
end

counter
codebook(match_index, :) 
















