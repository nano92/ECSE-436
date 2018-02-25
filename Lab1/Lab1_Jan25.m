clear;

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1

%Encoder:
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
c = mod(m*G,2);

%Error channel:
p_error = 0,1; %make error prob. a function
e = rand(1,8) < p_1;
y = mod(c + e, 2)

%Decoder:
V = []
%%%Codebook generation part
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

for i = 1:16
   V(i) = sum(abs(y - codebook(i,:))); 
end
V
[minDiff, index] = min(V)
codebook(index, :)
originalMsg = codebook(index,1:4)
