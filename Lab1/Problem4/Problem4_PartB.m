%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet

%Problem 4, part b)

clear;

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1

%Encoder:
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
c = mod(m*G,2);

%Codebook:
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);


for SNR = -10:10;
        
        SNR
        
        %Additive Gaussian Noise Channel:
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
        
        m_hat = codebook(index,1:4) %message bits at output of decoder
end
    

