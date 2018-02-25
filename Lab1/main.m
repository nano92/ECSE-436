clear;

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1;

%Encoder:
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
c = mod(m*G,2);

%Codebook
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits)

 %Syndrome Table:
 H = horzcat(P, eye(4));
 e_syndromeTable = vertcat(zeros(1,8), flip(eye(8)));
 
 s_syndromeTable = zeros(9,4);
 for i = 1:9
    s_syndromeTable(i,:) = H*(e_syndromeTable(i,:))';
 end
 
 %Decoder parts
 
 %Get P_error list and error rates list for exhaustive decoder and syndrome
 %decoder
 [Perror_exDec, errorRate_exDec] = ExhaustiveDecoder(c, codebook, m);
 [Perror_syDec, errorRate_syDec] = SyndromeDecoder( c, H, s_syndromeTable, ...
                                                    e_syndromeTable,m);
 
 %Plot results
 figure
 
 subplot(2,1,1)
 plot(Perror_exDec, errorRate_exDec)
 title('Error Rate Curve for Exhaustive Decoder')
 xlabel('P_e_r_r_o_r')
 ylabel('Error Rate')
 
 subplot(2,1,2)
 plot(Perror_syDec, errorRate_syDec)
 title('Error Rate Curve for Syndrome Decoder')
 xlabel('P_e_r_r_o_r')
 ylabel('Error Rate') 