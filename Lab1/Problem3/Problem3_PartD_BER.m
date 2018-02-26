%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet

%Problem 3, part d)

clear;

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1;

%Encoder:
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
c = mod(m*G,2);

%Codebook:
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
 
%Exhaustive and Syndrome Decoders:
[Perror_exDec, errorRate_exDec] = ExhaustiveDecoder(c, codebook, m);
[Perror_syDec, errorRate_syDec] = SyndromeDecoder( c, H, s_syndromeTable, e_syndromeTable,m);
 
%Generating BER curves:
semilogy(Perror_exDec, errorRate_exDec, 'r')
hold on;
semilogy(Perror_syDec, errorRate_syDec, 'b')
hold off;
 
title('Error Rate Curves for Exhaustive vs Syndrome Decoder')
legend('Exhaustive Decoder', 'Syndrome Decoder');
xlabel('P_e_r_r_o_r')
ylabel('Error Rate') 
 