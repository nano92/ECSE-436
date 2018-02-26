function [ y ] = BinarySymmetricChannel( m,  p_error )
%Binary Symmetric Channel
%   Takes as input a binary 0/1 vector and propability of error value
%   p_error. The output of this function is the binary vector corrupted
%   with i.i.d. errors which occured with given probability p_error.

 %Encoder:
 P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1]; %right-half of generator matrix G (parity side)
 G = horzcat( eye(4), P); %generator matrix G
 c = mod(m*G,2); %codeword c, which is the output of the encoder
 
%Error Channel:
 e = rand(1,8) < p_error; %error vector e
 y = mod(c + e, 2); %corrupted binary vector y with i.i.d. errors which occured with given probability p_error
 
end

