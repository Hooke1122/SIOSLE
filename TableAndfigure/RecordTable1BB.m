function RecordTable1BB
clc;
clear all;
Recordxls = [];
for N = 9:3:18
    for nmax = 10:3:19
        for tandR = 2:2 
            for ai = 12:12
                recordB = [];
                recordC = [];
                recordA = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table1/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/result.csv',tandR,N,ai,nmax,TestTime);
                        A=csvread(dircsv);  
%                         xls = sprintf('../InstanceAndresult/table1/BB-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
%                         A = xlsread(xls,'Sheet1');
                        recordA = [recordA;  sum(A(:,7))];
                        mark = mark + 1;
                        if A(7)>=3600
                            markrate = markrate + 1;
                        end
                    catch e
                        dircsv
                    end
                end
                num = 20;
                if mark == num
                    Recordxls = [Recordxls;N nmax -0.01 0.5 0.5  mean(recordA) max(recordA) markrate];
                else
                    Recordxls = [Recordxls;N nmax -0.01 0.5 0.5  [0 0 0]];
                end
            end
        end
    end
end
csvwrite('RecordTable1BB.csv',Recordxls);  