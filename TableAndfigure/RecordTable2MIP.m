function RecordTable2MIP
Recordxls = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64 ];
for N = 12:20:12
    for nmax = 16:40:16
        for tandR = 2:2 
            for ai = 11:18
                sum1 = [];
                markrate = 0;
                mark = 0;
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table2/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputMIP/result.csv',tandR,N,ai,nmax,TestTime);
                        A=csvread(dircsv);  
%                         xls = sprintf('../InstanceAndresult/table2/0414tandR%d-N%d-ai%d-nmax%d-TestTime%d',tandR,N,ai,nmax,TestTime)
%                         A = xlsread(xls,num2str(N));
                        if A(1,3)>=3600
                            markrate = markrate+1;
                        end
                        mark = mark + 1;
                        sum1 = [sum1;A(1,2) A(1,3)];
                    catch e
                        continue;                      
                    end
                end
                num = 20;
                if mark == num
                    Recordxls = [Recordxls;N nmax 0.5 0.5 aa(ai-10) sum(sum1)/num max(sum1) markrate];
                else
                    Recordxls = [Recordxls;N nmax 0.5 0.5 aa(ai-10) [0 0 0]];
                end    
            end
        end
   end
end
csvwrite('RecordTable2MIP.csv',Recordxls);  