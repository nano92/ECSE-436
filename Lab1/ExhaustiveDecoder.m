function [ Perror_axis, errorRate_axis ] = ExhaustiveDecoder( c, codebook, m )
%Exhaustive decoder for Hamming code (8,4,4)
%It outputs a list of P_error (from 0 to 1, incrementing by 0.05) and a
%list of their corresponding error rates
j = 1;
for p_error = 0:0.05:1
    
    for iteration = 1:100000
       
        %Error Channel:
        e = rand(1,8) < p_error;
        y = mod(c + e, 2);

       
        %Exhaustive Decoder:
        v = (16);
        for i = 1:16
           v(i) = sum(abs(y - codebook(i,:))); 
        end
  
        [~, index] = min(v);
        m_hat = codebook(index,1:4);
        
        difference(iteration) = sum(abs(m-m_hat)); %for error rate calculation
    end
    
    error_rate(j) = sum(difference)/(length(m)*iteration);
    j = j + 1;
    
end

Perror_axis = 0:0.05:1;
errorRate_axis = error_rate;

end

