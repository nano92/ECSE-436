%ECSE 436, Lab 1 
%Group 7: Amanda Bianco and Luis Gallet

%Problem 4, part h)
%Computing d(edge) for trellis of rate 1/2 convolutional code with G1=7 and G2=5

clear;

%Received  vector:
r = [ -0.1 0.4 0.9 0.45 0.5 1.3 -0.6 -1.3 0.2 0.4 0.5 0.7];


%------------------------------------------------------------------------------


%STAGE 1

edges_Stage1 = [0 0;   %codeword bits (coded symbol bits) on each edge in stage 1
                1 1];
            
[numberOfEdges_Stage1, ~] = size(edges_Stage1);  

d_edges_Stage1 = zeros(1,numberOfEdges_Stage1);           
for i = 1:numberOfEdges_Stage1 
    k = 1; 
    %d(edge) = (r_k - codedSymbol_k(edge))^2 + (r_k+1 - codedSymbol_k+1(edge))^2
    for j = 1:2
        d_edges_Stage1(i) = d_edges_Stage1(i) + (r(k)-edges_Stage1(i,j))^2;
        k = k + 1;
    end
end

d_edges_Stage1 = d_edges_Stage1'


%------------------------------------------------------------------------------


%STAGE 2

edges_Stage2 = [0 0;  %codeword bits (coded symbol bits) on each edge in stage 2
                1 1;
                1 0;
                0 1];

[numberOfEdges_Stage2, ~] = size(edges_Stage2);  

d_edges_Stage2 = zeros(1,numberOfEdges_Stage2);           
for i = 1:numberOfEdges_Stage2 
    k = 3;
    %d(edge) = (r_k - codedSymbol_k(edge))^2 + (r_k+1 - codedSymbol_k+1(edge))^2
    for j = 1:2
        d_edges_Stage2(i) = d_edges_Stage2(i) + (r(k)-edges_Stage2(i,j))^2;
        k = k + 1;
    end
end

d_edges_Stage2 = d_edges_Stage2'
 

%------------------------------------------------------------------------------


%STAGE 3

edges_Stages3 = [0 0;   %codeword bits (coded symbol bits) on each edge in stage 3
                  1 1;
                  1 1;
                  0 0;
                  1 0;
                  0 1;
                  0 1;
                  1 0];
              
[numberOfEdges_Stages3, ~] = size(edges_Stages3);  

d_edges_Stages3 = zeros(1,numberOfEdges_Stages3);           
for i = 1:numberOfEdges_Stages3 
    k = 5; 
    %d(edge) = (r_k - codedSymbol_k(edge))^2 + (r_k+1 - codedSymbol_k+1(edge))^2
    for j = 1:2
        d_edges_Stages3(i) = d_edges_Stages3(i) + (r(k)-edges_Stages3(i,j))^2;
        k = k + 1;
    end
end

d_edges_Stages3 = d_edges_Stages3'


%------------------------------------------------------------------------------


%STAGE 4

edges_Stage4 = [0 0;   %codeword bits (coded symbol bits) on each edge in stage 4
                  1 1;
                  1 1;
                  0 0;
                  1 0;
                  0 1;
                  0 1;
                  1 0];
              
[numberOfEdges_Stage4, ~] = size(edges_Stage4);  

d_edges_Stage4 = zeros(1,numberOfEdges_Stage4);           
for i = 1:numberOfEdges_Stage4 
    k = 7; 
    %d(edge) = (r_k - codedSymbol_k(edge))^2 + (r_k+1 - codedSymbol_k+1(edge))^2
    for j = 1:2
        d_edges_Stage4(i) = d_edges_Stage4(i) + (r(k)-edges_Stage4(i,j))^2;
        k = k + 1;
    end
end

d_edges_Stage4 = d_edges_Stage4'


%------------------------------------------------------------------------------


%STAGE 5

edges_Stage5 = [0 0;  %codeword bits (coded symbol bits) on each edge in stage 5
                1 1;
                1 0;
                0 1];

[numberOfEdges_Stage5, ~] = size(edges_Stage5);  

d_edges_Stage5 = zeros(1,numberOfEdges_Stage5);           
for i = 1:numberOfEdges_Stage5
    k = 9; 
    %d(edge) = (r_k - codedSymbol_k(edge))^2 + (r_k+1 - codedSymbol_k+1(edge))^2
    for j = 1:2
        d_edges_Stage5(i) = d_edges_Stage5(i) + (r(k)-edges_Stage5(i,j))^2;
        k = k + 1;
    end
end

d_edges_Stage5 = d_edges_Stage5'


%------------------------------------------------------------------------------

%STAGE 6

edges_Stage6 = [0 0;   %codeword bits (coded symbol bits) on each edge in stage 6
                1 1];
              
[numberOfEdges_Stage6, ~] = size(edges_Stage6);  

d_edges_Stage6 = zeros(1,numberOfEdges_Stage6);           
for i = 1:numberOfEdges_Stage6
    k = 11; 
    %d(edge) = (r_k - codedSymbol_k(edge))^2 + (r_k+1 - codedSymbol_k+1(edge))^2
    for j = 1:2
        d_edges_Stage6(i) = d_edges_Stage6(i) + (r(k)-edges_Stage6(i,j))^2;
        k = k + 1;
    end
end

d_edges_Stage6 = d_edges_Stage6'
