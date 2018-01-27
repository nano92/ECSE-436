function [ Perror_axis, errorRate_axis ] = SyndromeDecoder( c, H, ...
                                                            s_syndromeTable, ...
                                                            e_syndromeTable,m )
%Syndrome decoder for Hamming code (8,4,4)
%It outputs a list of P_error (from 0 to 1, incrementing by 0.05) and a
%list of their corresponding error rates

j = 1;
for p_error = 0:0.05:1
    
    for iteration = 1:10000
       
        %Error Channel:
        e = rand(1,8) < p_error;
        y = mod(c + e, 2);

       
        %Syndrome Decoder:
        s = (mod(H*y',2))';
        [~ , index] = ismember(s, s_syndromeTable, 'rows');
        
        if (index == 0) %if s is not a member of s_syndromeTable
            codeword = y;
        else
            error = e_syndromeTable(index, :);
            codeword = mod(y - error, 2);
        end

      
        m_hat = codeword(1:4);

        difference(iteration) = sum(abs(m-m_hat)); %for error rate calculation
    end
    
    error_rate(j) = sum(difference)/(length(m)*iteration);
    j = j + 1;
    
end

Perror_axis = 0:0.05:1;
errorRate_axis = error_rate;

end

