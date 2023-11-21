function RecordFigure3BB
clc;
clear all;
Recordxls2 = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 2:2
            for ai = 18:-1:11
                recordC = [];
                for TestTime = 1:20                       
                    try
                    dircsv = sprintf('../InstanceAndresult/table5/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/split_list1or2.csv',tandR,N,ai,nmax,TestTime);
                    C=csvread(dircsv);                    
                    recordC = [recordC;C(1,3:end)];     
                    catch
                        dircsv
                    end
                end           
                Recordxls2 = [Recordxls2;tandR N ai nmax aa(ai-10) mean(recordC) mean(recordC(:,1))+mean(recordC(:,end))];
            end
        end
    end
end

csvwrite('RecordFigure3BB.csv',Recordxls2);  