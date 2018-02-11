%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet
%Problem 1, second question of part b)

%Codebook generation
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

bitDiffList = [];
counter = 0;
for i = 1:15
    for j = (i+1):16
        %xor every pair of codewords to get the number of differences
        diff = xor(codebook(i, :), codebook(j, :));
        counter = counter + 1;
        %the number of 1's is counted, this will give the quantity of
        %bit differences. This number is then saved in a list
        bitDiffList(counter) = sum(diff(:) == 1);
    end      
end
%The minimum value in the list will be d_min
d_min = min(bitDiffList);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Code for Problem1B

%A temp list is generated with 1's and 0's. Wherever there is a 1 in
%temp_list, there is a d_min value in bitDiffList
temp_list = (bitDiffList == d_min);
%Counting the number of 1's gives the number of codeword pairs at a
%distance d_min
out = sum(temp_list(:));