%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet

%Problem 4, parts a) and b)

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

j = 1;
for SNR = -10:10;
    
    for iteration = 1:100000

        %Gaussian Noise Channel:
        Psig = 1/2; %signal power
        Pn = Psig/(10^(SNR/10)); %noise power
        sigma = sqrt(Pn);
        n = (sigma*randn(1, 8)); %Gaussian noise
        y = (c + n)';

        %Exhaustive Decoding Algorithm for (8,4,4) Hamming Code on the additive Gaussian Noise Channel:
        for i = 1:16
            euclideanDistance(i) = (y-codebook(i,:)')'*(y-codebook(i,:)');
        end
        [~, index] = min(euclideanDistance);
        
        m_hat = codebook(index,1:4); %message bits at output of decoder
        
        difference(iteration) = sum(abs(m-m_hat)); %for error rate calculation
    
    end
    
    %Error Rate Calculation:
    error_rate(j) = sum(difference)/(length(m)*iteration);
    
    j = j + 1;
    
end

%Generating BER curve as a function of channel SNR:
x_axis = -10:10;
semilogy(x_axis, error_rate)
title('BER Curve of Exhaustive Decoding Algorithm for (8,4,4) Hamming Code')
xlabel('SNR')
ylabel('Error Rate')