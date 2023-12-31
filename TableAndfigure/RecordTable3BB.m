function RecordTable3BB
clc;
clear all;
Recordxls = [];
tR = {[0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],[0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]};

for N = 12:20:12
    for nmax = 19:40:19
        for tandR = 1:9
            for ai = 12:12
                recordB = [];
                recordC = [];
                recordA = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table3/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/result.csv',tandR,N,ai,nmax,TestTime);
                        A=csvread(dircsv);  
                        dircsv = sprintf('../InstanceAndresult/table3/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/decom_list.csv',tandR,N,ai,nmax,TestTime);
                        B=csvread(dircsv);  
                        
                        
%                         xls = sprintf('../InstanceAndresult/table3/BB-tandR%d-N%d-nmax%d-ai%d-TestTime%d',tandR,N,nmax,ai,TestTime)
%                         A = xlsread(xls,'Sheet1');
%                         B = xlsread(xls,'decom_list');
                        recordA = [recordA;  sum(A(:,7))];
                        recordB = [recordB; sum(B(:,1)-B(:,2)+1) sum(B(:,end))];

                        mark = mark + 1;
                        if A(7)>=3600
                            markrate = markrate + 1;
                        end
                    catch e
                        continue;                      
                    end
                end
                num = 20;
                if mark == num
                    Recordxls = [Recordxls;N nmax -0.01 tR{tandR} 0 mean(recordA) 0 max(recordA) 1 mean(recordB) 2 max(recordB) markrate];
                else
                    Recordxls = [Recordxls;N nmax -0.01 tR{tandR} [0 0 0 0 0 0 0 0 0 0 0]];
                end
            end
        end
    end
end
csvwrite('RecordTable3BB.csv',Recordxls);  