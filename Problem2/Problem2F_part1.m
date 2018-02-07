%Problem 2F

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1;

y = [];
matchedCodewords = [];
%Generator matrix for (8,4,4) hamming code
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
%Encoder:
c = mod(m*G,2);

%Codebook generation
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

%Exhaustive decoder
error_rate = [];
difference = [];
j = 1;
for p_erasure = 0:0.05:1
    for iteration = 1: 10000
        %Erasure channel
        %Since this is a (8, 4, 4) Hamming code, the exhaustive
        %decoder can only fix (d_min - 1) = 3 erasures, thus all codewords having 
        %3 or less bits erased out of 8. It is important to mention that it has been
        %observed that some codewords having d_min erasures are fixed
        y = BinaryErasureChannel(c, p_erasure);
        %Iterate through all the 16 codewords in the codebook
        for i = 1:16
            if (max(abs(y-codebook(i,:))) ~= 1)
                counter = counter + 1;
                m_hat = codebook(i, 1:4);
                difference(iteration) = sum(abs(m-m_hat));
            end
        end
    end
    error_rate(j) = sum(difference)/(length(m)*iteration);
    j = j + 1;
end
Perror_axis = 0:0.05:1;
errorRate_axis = error_rate;

plot(Perror_axis, errorRate_axis)
title('Error Rate Curve for Exhaustive Decoder')
xlabel('P_e_r_r_o_r')
ylabel('Error Rate')