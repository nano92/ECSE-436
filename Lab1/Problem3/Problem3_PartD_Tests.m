%ECSE 436, Lab 1
%Group 7: Amanda Bianco and Luis Gallet

%Problem 3, part d)
%Testing the performance of both the exhaustive decoder and syndrome
%decoder

clear;
 
%Source:

p_1 = 1/2;
m = rand(1,4) < p_1


%Encoder:
 P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1]; 
 G = horzcat( eye(4), P); 
 c = mod(m*G,2); %codeword c, which is the output of the encoder
 
 %Error Channel (Binary Symmetric Channel):
 p_error = 0.1;
 e = rand(1,8) < p_error; %error vector e
 y = mod(c + e, 2); %corrupted binary vector y with i.i.d. errors which occured with given probability p_error
 
 totalErrors = numel(find(y~=c)) %count total number of errors
 

%Codebook
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1]; %right-half of generator matrix G (parity side)
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

%Syndrome Table:
H = horzcat(P, eye(4));
e_syndromeTable = vertcat(zeros(1,8), flip(eye(8)));
 
s_syndromeTable = zeros(9,4);
for i = 1:9
   s_syndromeTable(i,:) = H*(e_syndromeTable(i,:))';
end


%Exhaustive Decoder:
v = [];
for i = 1:16
    v(i) = sum(abs(y - codebook(i,:))); %counting number of bit flips
end

[minDiff, index] = min(v); %finding index with min number of bit flips

m_hat_ExhaustiveDecoder = codebook(index,1:4) %decoded message vector m_hat is bits 1 to 4 of codeword at index with min number of bit flips


%Syndrome Decoder:
s = (mod(H*y',2))';
[~ , index] = ismember(s, s_syndromeTable, 'rows');
        
if (index == 0) %if s is not a member of s_syndromeTable
   codeword = y;
else
   error = e_syndromeTable(index, :);
   codeword = mod(y - error, 2);
end

      
m_hat_SyndromeDecoder = codeword(1:4) %decoded message vector m_hat