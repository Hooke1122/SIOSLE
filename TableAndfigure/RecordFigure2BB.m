function RecordFigure2BB
clc;
clear all;
Recordxls = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 2:2 
            for ai = 18:-1:11
                MeanA = [];
                for TestTime = 1:20
                    try
%                         xls = sprintf('../InstanceAndresult/table5/BB-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
%                         A = xlsread(xls,'split_list');
                        
                        dircsv = sprintf('../InstanceAndresult/table5/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/split_list.csv',tandR,N,ai,nmax,TestTime)
                        A=csvread(dircsv);
                        MeanA = [MeanA;mean(A(:,3:end))];
                    catch err
                        continue;                      
                    end
                end
                Recordxls = [Recordxls;tandR N ai nmax aa(ai-10) mean(MeanA) mean(MeanA(:,2))/mean(MeanA(:,1))];                     
            end
        end
    end
end

csvwrite('RecordFigure2BB.csv',Recordxls);  