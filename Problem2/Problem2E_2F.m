%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet
%Problem 2, part f) and part e)

%Source:
p_1 = 1/2;
m = rand(1,4) < p_1;

%Generator matrix for (8,4,4) hamming code
P = [1 1 1 0; 1 1 0 1; 1 0 1 1; 0 1 1 1];
G = horzcat( eye(4), P);
%Encoder:
c = mod(m*G,2);

%Codebook generation
message_bits =  de2bi((0:15) , 'left-msb');
parity_bits = mod(message_bits * P, 2);
codebook = horzcat(message_bits, parity_bits);

y = [8];

%Exhaustive decoder
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
error_rate_Ex_dec = [];
difference_Ex_dec = [];
j = 1;
for p_erasure = 0:0.05:1
    for iteration = 1: 100000
        %Erasure channel
        %Since this is a (8, 4, 4) Hamming code, the exhaustive
        %decoder can only fix (d_min - 1) = 3 erasures, thus all codewords 
        %having 3 or less bits erased out of 8. It is important to mention that 
        %it has been observed that some codewords having d_min erasures are 
        %fixed
        y = BinaryErasureChannel(c, p_erasure);
        %Iterate through all the 16 codewords in the codebook
        for i = 1:16
            if (max(abs(y-codebook(i,:))) ~= 1)
                %counter = counter + 1;
                m_hat = codebook(i, 1:4);
                difference_Ex_dec(iteration) = sum(abs(m-m_hat));
            end
        end
    end
    error_rate_Ex_dec(j) = sum(difference_Ex_dec)/(length(m)*iteration);
    j = j + 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%Gaussian elimination method
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
msgIndexListOfErasures = [];
parityIndexListOfErasures = [];
error_rate_Gau_dec = [];
difference_Gau_dec = [];
j = 1;
for p_erasure = 0:0.05:1
    for iteration = 1: 100000
        y = BinaryErasureChannel(c, p_erasure);
        
        indexOfErasures = find(y == 0.5);
        numOfErasures = length(indexOfErasures);
        indexOfNotErasures = find(y ~= 0.5);
        
        %Different equations are used depending on the number of erasures
        switch numOfErasures
            %no erasures were generated, thus output = input
            case 0
                m_hat = y(1:4);
            case 1
                %1 erasur. It it happened in the parity bits, then they are
                %discarded. It it happened in the message bits, then the
                %equations are used
                switch indexOfErasures
                    case 1
                        y(1) = mod(y(5) - y(2) - y(3), 2);                            
                    case 2
                        y(2) = mod(y(5) - y(1) - y(3), 2);
                    case 3
                        y(3) = mod(y(5) - y(1) - y(2), 2);
                    case 4
                        y(4) = mod(y(6) - y(1) - y(2), 2);
                end

                m_hat = y(1:4);
                
            case 2
                %Here erasures can happen either in the message bits only,
                %in the parity bits only or in both. If erasures happened
                %in the parity bits part only, then they are just discared,
                %else the parity bits equations are used
                msgIndexListOfErasures = sort(indexOfErasures(indexOfErasures < 5));
                parityIndexListOfErasures = sort(indexOfErasures(indexOfErasures > 4));
                
                %Case where erasures happened only in the message bits. 
                if isempty(parityIndexListOfErasures)
                %list of indexes (of the encoded codeword "y") where there are 
                %erasures is created sorted from smallest to greatest. 
                %So we can safely check the first bit always.
                   switch msgIndexListOfErasures(1)
                    case 1
                        switch msgIndexListOfErasures(2)
                            case 2
                                y(1) = mod(y(7) - y(3) - y(4), 2);  
                                y(2) = mod(y(8) - y(3) - y(4), 2);
                            case 3
                                y(1) = mod(y(6) - y(2) - y(4), 2);  
                                y(3) = mod(y(8) - y(2) - y(4), 2);
                            case 4
                                y(1) = mod(y(5) - y(2) - y(3), 2);  
                                y(4) = mod(y(8) - y(2) - y(3), 2);
                        end                          
                    case 2
                        switch msgIndexListOfErasures(2)
                            case 3
                                y(2) = mod(y(6) - y(1) - y(4), 2);
                                y(3) = mod(y(7) - y(1) - y(4), 2);
                            case 4
                                y(2) = mod(y(5) - y(1) - y(3), 2);
                                y(4) = mod(y(7) - y(1) - y(3), 2);
                        end                        
                    case 3
                        y(3) = mod(y(5) - y(1) - y(2), 2);
                        y(4) = mod(y(6) - y(1) - y(2), 2);
                   end
                %Case where the erasures are in the message bit part and in
                %the parity bit part
                elseif ~isempty(msgIndexListOfErasures) && ~isempty(parityIndexListOfErasures)
                    switch parityIndexListOfErasures
                        case 5
                            switch msgIndexListOfErasures
                                case 1
                                    y(1) = mod(y(7) - y(3) - y(4), 2);  
                                case 2
                                    y(2) = mod(y(8) - y(3) - y(4), 2);
                                case 3
                                    y(3) = mod(y(6) - y(1) - y(4), 2);
                                case 4
                                    y(4) = mod(y(6) - y(1) - y(2), 2);
                            end
                        case 6
                            switch msgIndexListOfErasures
                                case 1
                                    y(1) = mod(y(7) - y(3) - y(4), 2);  
                                case 2
                                    y(2) = mod(y(8) - y(3) - y(4), 2);
                                case 3
                                    y(3) = mod(y(8) - y(2) - y(4), 2);
                                case 4
                                    y(4) = mod(y(8) - y(2) - y(3), 2);
                            end
                        case 7
                            switch msgIndexListOfErasures
                                case 1
                                    y(1) = mod(y(5) - y(2) - y(3), 2);  
                                case 2
                                    y(2) = mod(y(8) - y(3) - y(4), 2);
                                case 3
                                    y(3) = mod(y(6) - y(1) - y(4), 2);
                                case 4
                                    y(4) = mod(y(6) - y(1) - y(2), 2);
                            end
                        case 8
                            switch msgIndexListOfErasures
                                case 1
                                    y(1) = mod(y(7) - y(3) - y(4), 2);  
                                case 2
                                    y(2) = mod(y(6) - y(1) - y(4), 2);
                                case 3
                                    y(3) = mod(y(6) - y(1) - y(4), 2);
                                case 4
                                    y(4) = mod(y(6) - y(1) - y(2), 2);
                            end
                    end
                end
                
                m_hat = y(1:4);
            
            %Case where there are 3 erasures. If the erasures are only in
            %the parity bit part, they are discared. 
            case 3
                msgIndexListOfErasures = sort(indexOfErasures(indexOfErasures < 5));
                parityIndexListOfErasures = sort(indexOfErasures(indexOfErasures > 4));
                
                msgIndexListOfNotErasures = sort(indexOfNotErasures...
                                                (indexOfNotErasures < 5));
                
                %Case where erasures are in the message bit part only
                if isempty(parityIndexListOfErasures)
                   %Since there are 4 message bits and 3 erasures, a list
                   %with the index of the none erased bit was created
                    switch msgIndexListOfNotErasures
                    case 1
                        y(2) = mod(y(8) - (y(7) - y(1)), 2);
                        y(4) = mod(y(6) - y(1) - y(2), 2);
                        y(3) = mod(y(7) - y(1) - y(4), 2);
                    case 2
                        y(1) = mod(y(7) - (y(8) - y(2)), 2);
                        y(4) = mod(y(6) - y(1) - y(2), 2);
                        y(3) = mod(y(7) - y(1) - y(4), 2);                     
                    case 3
                        y(4) = mod(y(6) - (y(5) - y(3)), 2);
                        y(1) = mod(y(7) - y(3) - y(4), 2);
                        y(2) = mod(y(8) - y(3) - y(4), 2);
                    case 4
                        y(3) = mod(y(5) - (y(6) - y(4)), 2);
                        y(1) = mod(y(7) - y(3) - y(4), 2);
                        y(2) = mod(y(8) - y(3) - y(4), 2);
                    end
                    
                %Case where erasures are in the message bit part and in the
                %parity bit part
                elseif ~isempty(msgIndexListOfErasures) && ...
                                            ~isempty(parityIndexListOfErasures)
                    
                    %Case 2 erasures are in the parity bit part and 1 in
                    %the message bit part
                    if length(parityIndexListOfErasures) > ...
                                                   length(msgIndexListOfErasures)
                        switch parityIndexListOfErasures(1)
                            case 5
                                switch parityIndexListOfErasures(2)
                                    case 6
                                        switch msgIndexListOfErasures
                                            case 1
                                                y(1) = mod(y(7) - y(3) - y(4), 2);  
                                            case 2
                                                y(2) = mod(y(8) - y(3) - y(4), 2);
                                            case 3
                                                y(3) = mod(y(7) - y(1) - y(4), 2);
                                            case 4
                                                y(4) = mod(y(7) - y(1) - y(3), 2);
                                        end
                                    case 7
                                        switch msgIndexListOfErasures
                                            case 1
                                                y(1) = mod(y(6) - y(2) - y(4), 2);  
                                            case 2
                                                y(2) = mod(y(6) - y(1) - y(4), 2);
                                            case 3
                                                y(3) = mod(y(8) - y(2) - y(4), 2);
                                            case 4
                                                y(4) = mod(y(8) - y(2) - y(3), 2);
                                        end
                                    case 8
                                        switch msgIndexListOfErasures
                                            case 1
                                                y(1) = mod(y(6) - y(2) - y(4), 2);  
                                            case 2
                                                y(2) = mod(y(6) - y(1) - y(4), 2);
                                            case 3
                                                y(3) = mod(y(7) - y(1) - y(4), 2);
                                            case 4
                                                y(4) = mod(y(7) - y(1) - y(3), 2);
                                        end
                                end
                            case 6
                                switch parityIndexListOfErasures(2)
                                    case 7
                                        switch msgIndexListOfErasures
                                            case 1
                                                y(1) = mod(y(5) - y(2) - y(3), 2);  
                                            case 2
                                                y(2) = mod(y(5) - y(1) - y(3), 2);
                                            case 3
                                                y(3) = mod(y(5) - y(1) - y(2), 2);
                                            case 4
                                                y(4) = mod(y(8) - y(2) - y(3), 2);
                                        end
                                    case 8
                                        switch msgIndexListOfErasures
                                            case 1
                                                y(1) = mod(y(5) - y(2) - y(3), 2);  
                                            case 2
                                                y(2) = mod(y(5) - y(1) - y(3), 2);
                                            case 3
                                                y(3) = mod(y(5) - y(1) - y(2), 2);
                                            case 4
                                                y(4) = mod(y(7) - y(1) - y(3), 2);
                                        end                                    
                                end
                            case 7
                                switch parityIndexListOfErasures(2)
                                    case 8
                                        switch msgIndexListOfErasures
                                            case 1
                                                y(1) = mod(y(5) - y(2) - y(3), 2);  
                                            case 2
                                                y(2) = mod(y(5) - y(1) - y(3), 2);
                                            case 3
                                                y(3) = mod(y(5) - y(1) - y(2), 2);
                                            case 4
                                                y(4) = mod(y(6) - y(1) - y(2), 2);
                                        end                                  
                                end
                        end
                    
                    %Case where there are 2 erasures in the message bit
                    %part and 1 erasure in the parity bit part
                    else
                        switch parityIndexListOfErasures
                            case 5
                                switch msgIndexListOfErasures(1)
                                    case 1
                                        switch msgIndexListOfErasures(2)
                                            case 2
                                                y(1) = mod(y(7) - y(3) - y(4), 2);  
                                                y(2) = mod(y(8) - y(3) - y(4), 2);
                                            case 3
                                                y(1) = mod(y(6) - y(2) - y(4), 2);  
                                                y(3) = mod(y(8) - y(2) - y(4), 2);
                                            case 4
                                                y(4) = mod(y(8) - y(2) - y(3), 2);
                                                y(1) = mod(y(7) - y(3) - y(4), 2);                                                
                                        end                          
                                    case 2
                                        switch msgIndexListOfErasures(2)
                                            case 3
                                                y(2) = mod(y(6) - y(1) - y(4), 2);
                                                y(3) = mod(y(7) - y(1) - y(4), 2);
                                            case 4
                                                y(4) = mod(y(7) - y(1) - y(3), 2);
                                                y(2) = mod(y(8) - y(4) - y(3), 4);                                                
                                        end                        
                                    case 3
                                        y(4) = mod(y(6) - y(1) - y(2), 2);
                                        y(3) = mod(y(7) - y(1) - y(4), 2);                                        
                                end
                            case 6
                                switch msgIndexListOfErasures(1)
                                    case 1
                                        switch msgIndexListOfErasures(2)
                                            case 2
                                                y(1) = mod(y(7) - y(3) - y(4), 2);  
                                                y(2) = mod(y(8) - y(3) - y(4), 2);
                                            case 3
                                                y(3) = mod(y(8) - y(2) - y(4), 2);
                                                y(1) = mod(y(5) - y(1) - y(3), 2);                                                 
                                            case 4
                                                y(4) = mod(y(8) - y(2) - y(3), 2);
                                                y(1) = mod(y(7) - y(3) - y(4), 2);                                                
                                        end                          
                                    case 2
                                        switch msgIndexListOfErasures(2)
                                            case 3
                                                y(3) = mod(y(7) - y(1) - y(4), 2);
                                                y(2) = mod(y(8) - y(3) - y(4), 2);                                                
                                            case 4
                                                y(4) = mod(y(7) - y(1) - y(3), 2);
                                                y(2) = mod(y(8) - y(3) - y(4), 4);                                                
                                        end                        
                                    case 3
                                        y(3) = mod(y(5) - y(1) - y(2), 2); 
                                        y(4) = mod(y(7) - y(1) - y(3), 2);                                                                               
                                end
                            case 7
                                switch msgIndexListOfErasures(1)
                                    case 1
                                        switch msgIndexListOfErasures(2)
                                            case 2
                                                y(2) = mod(y(8) - y(3) - y(4), 2);
                                                y(1) = mod(y(5) - y(2) - y(3), 2);                                                
                                            case 3
                                                y(3) = mod(y(8) - y(2) - y(4), 2);
                                                y(1) = mod(y(5) - y(1) - y(3), 2);                                                 
                                            case 4
                                                y(4) = mod(y(8) - y(2) - y(3), 2);
                                                y(1) = mod(y(5) - y(2) - y(3), 2);                                                
                                        end                          
                                    case 2
                                        switch msgIndexListOfErasures(2)
                                            case 3
                                                y(2) = mod(y(6) - y(1) - y(4), 2);
                                                y(3) = mod(y(8) - y(2) - y(4), 2);                                                                                                
                                            case 4
                                                y(2) = mod(y(5) - y(1) - y(3), 2); 
                                                y(4) = mod(y(6) - y(1) - y(2), 2);                                                                                               
                                        end                        
                                    case 3
                                        y(3) = mod(y(5) - y(1) - y(2), 2); 
                                        y(4) = mod(y(6) - y(1) - y(2), 2);                                                                               
                                end
                            case 8
                                switch msgIndexListOfErasures(1)
                                    case 1
                                        switch msgIndexListOfErasures(2)
                                            case 2
                                                y(1) = mod(y(7) - y(3) - y(4), 2);
                                                y(2) = mod(y(5) - y(1) - y(3), 2);                                                                                                
                                            case 3
                                                y(1) = mod(y(6) - y(2) - y(4), 2);
                                                y(3) = mod(y(5) - y(1) - y(2), 2);                                                                                                 
                                            case 4
                                                y(1) = mod(y(5) - y(2) - y(3), 2);
                                                y(4) = mod(y(6) - y(1) - y(2), 2);                                                                                                
                                        end                          
                                    case 2
                                        switch msgIndexListOfErasures(2)
                                            case 3
                                                y(2) = mod(y(6) - y(1) - y(4), 2);
                                                y(3) = mod(y(5) - y(1) - y(2), 2);                                                                                                
                                            case 4
                                                y(4) = mod(y(7) - y(1) - y(3), 2);
                                                y(2) = mod(y(6) - y(1) - y(4), 4);                                                
                                        end                        
                                    case 3
                                        y(3) = mod(y(5) - y(1) - y(2), 2); 
                                        y(4) = mod(y(7) - y(1) - y(3), 2);                                                                               
                                end
                        end
                    end
                end
                m_hat = y(1:4);
            otherwise
                %Case where there are more than 3 erasures to fix, so we
                %just randomly choose an answer
                r = randi([1 16],1,1);
                m_hat = message_bits(r);               
        end
        difference_Gau_dec(iteration) = sum(abs(m-m_hat));
    end
    error_rate_Gau_dec(j) = sum(difference_Gau_dec)/(length(m)*iteration);
    j = j + 1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

Perror_axis = 0:0.05:1;

semilogy(Perror_axis, error_rate_Ex_dec, 'r')
hold on;
semilogy(Perror_axis, error_rate_Gau_dec, 'b')
hold off;

title('Error Rate Curve for Exhaustive vs Gaussian Decoder')
legend('Exahustive Decoder', 'Gaussian Decoder')
xlabel('P_e_r_r_o_r')
ylabel('Error Rate')