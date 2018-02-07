%Problem 2B and 2C

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
answ = [];
index = 0;
for p_erasure = 0:0.05:1
    %Erasure channel
    %For performance testing purposes, it generates 20 codewords with
    %erasures. Since this is a (8, 4, 4) Hamming code, the exhaustive
    %decoder can only fix (d_min - 1) = 3 erasures, thus all codewords having 
    %3 or less bits erased out of 8.  It is important to mention that it has been
	%observed that some codewords having d_min erasures are fixed
    y = BinaryErasureChannel(c, p_erasure);
    numOfErasures = sum(y(:) == 0.5);
    counter = 0;
    %Iterate through all the 16 codewords in the codebook
    for i = 1:16
        if (max(abs(y-codebook(i,:))) ~= 1)
            counter = counter + 1;
            match_index = i;
        end
    end
    if counter == 1
        index = index + 1;
        fprintf('%d) %.1f %.1f %.1f %.1f %.1f %.1f %.1f %.1f decoded to %d %d %d %d %d %d %d %d\nnumber of erasures was: %d\n',...
                index, y, codebook(match_index, :), numOfErasures);
    end
end