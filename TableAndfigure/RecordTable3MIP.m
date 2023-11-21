function RecordTable3MIP
Recordxls = [];
tR = {[0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],[0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]};

for N = 12:20:12
    for nmax = 19:40:19
        for tandR = 1:9
            for ai = 12:12
                sum1 = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table3/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputMIP/result.csv',tandR,N,ai,nmax,TestTime);
                        A=csvread(dircsv);  
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
                    Recordxls = [Recordxls;N nmax -0.01 tR{tandR} sum(sum1)/num max(sum1) markrate];
                else
                    Recordxls = [Recordxls;N nmax -0.01 tR{tandR} [0 0 0 0 0 0 0 0 0]];
                end    
            end
        end
    end
end
csvwrite('RecordTable3MIP.csv',Recordxls);  