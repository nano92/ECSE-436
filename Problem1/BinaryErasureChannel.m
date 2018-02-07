function [ y ] = BinaryErasureChannel( c, p_E )
%%Problem 2A: Binary erasure channel that takes as an input a binary 0/1 vector 
%and probability of erasure value p_E. The output of this function is the binary 
%vector corrupted with i.i.d. erasures represented by 1/2 values, which 
%occurred with the given probability p_E.  

%Erasure Channel:
E = (1/2)*(rand(1,8) < p_E);
y = abs(c-E);

end


