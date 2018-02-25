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

 %Syndrome Table:
 H = horzcat(P, eye(4));
 e_syndromeTable = vertcat(zeros(1,8), flip(eye(8)));
 
 s_syndromeTable = zeros(9,4);
 for i = 1:9
    s_syndromeTable(i,:) = H*(e_syndromeTable(i,:))';
 end
 
% j = 1;
% for p_error = 0:0.05:1
%     
%     for iteration = 1:10000
%        
%         %Error Channel:
%         e = rand(1,8) < p_error;
%         y = mod(c + e, 2);
% 
%        
%         %Syndrome Decoder:
%         s = (mod(H*y',2))';
%         [~ , index] = ismember(s, s_syndromeTable, 'rows');
%         
%         if (index == 0) %if s is not a member of s_syndromeTable
%             codeword = y;
%         else
%             error = e_syndromeTable(index, :);
%             codeword = mod(y - error, 2);
%         end
% 
%       
%         m_hat = codeword(1:4);
% 
%         difference(iteration) = sum(abs(m-m_hat)); %for error rate calculation
%     end
%     
%     error_rate(j) = sum(difference)/(length(m)*iteration);
%     j = j + 1;
%     
% end

[x_axis , error_rate] = SyndromeDecoder( c, H, s_syndromeTable,e_syndromeTable,m)
% x_axis = 0:0.05:1;
plot(x_axis, error_rate)
title('Error Rate Curve for Syndrome Decoder')
xlabel('P_e_r_r_o_r')
ylabel('Error Rate')

 
 

 
