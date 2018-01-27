%ECSE 436, Lab 1
%Group 7: Amanda Bianco and Luis Gallet
%January 25th, 2018

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
codebook = horzcat(message_bits, parity_bits);

% j = 1;
% for p_error = 0:0.05:1
%     
%     for iteration = 1:100000
%        
%         %Error Channel:
%         e = rand(1,8) < p_error;
%         y = mod(c + e, 2);
% 
%        
%         %Exhaustive Decoder:
%         v = (16);
%         for i = 1:16
%            v(i) = sum(abs(y - codebook(i,:))); 
%         end
%   
%         [minDiff, index] = min(v);
%         m_hat = codebook(index,1:4);
%         
%         difference(iteration) = sum(abs(m-m_hat)); %for error rate calculation
%     end
%     
%     error_rate(j) = sum(difference)/(length(m)*iteration);
%     j = j + 1;
%     
% end
[x_axis, error_rate] = ExhaustiveDecoder(c, codebook, m);

% x_axis = 0:0.05:1;
plot(x_axis, error_rate)
title('Error Rate Curve for Exhaustive Decoder')
xlabel('P_e_r_r_o_r')
ylabel('Error Rate')


