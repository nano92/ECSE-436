%ECSE 436, Lab 1
%Group 7: Amanda Bianco and Luis Gallet

%Problem 3, part c)

clear;
 
%Source:
p_1 = 1/2;
m = rand(1,4) < p_1

%Binary Symmetric Channel:
p_error = 0.1;
[ y ] = BinarySymmetricChannel( m,  p_error );

%Syndrome Table:
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1]; %right-half of generator matrix G (parity side)
H = horzcat(P, eye(4));
e_syndromeTable = vertcat(zeros(1,8), flip(eye(8)));
 
s_syndromeTable = zeros(9,4);
for i = 1:9
   s_syndromeTable(i,:) = H*(e_syndromeTable(i,:))';
end
 
% syndromeTable = horzcat(e_syndromeTable, s_syndromeTable);
     
%Syndrome Decoder:
s = (mod(H*y',2))';
[~ , index] = ismember(s, s_syndromeTable, 'rows');
        
if (index == 0) %if s is not a member of s_syndromeTable
   codeword = y;
else
   error = e_syndromeTable(index, :);
   codeword = mod(y - error, 2);
end

      
m_hat = codeword(1:4) %decoded message vector m_hat

        