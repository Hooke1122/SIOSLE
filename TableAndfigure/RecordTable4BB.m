function RecordTable4BB
clc;
clear all;
Recordxls = [];
for N = 60:20:140
    for nmax = 100:40:220
        for tandR = 2:2
            for ai = 15:15
                recordB = [];
                recordC = [];
                recordA = [];
                mark = 0;
                markrate = 0;
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table4/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/result.csv',tandR,N,ai,nmax,TestTime);
                        A=csvread(dircsv);   
                        
                        dircsv = sprintf('../InstanceAndresult/table4/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/decom_list.csv',tandR,N,ai,nmax,TestTime);
                        B=csvread(dircsv);     
                        
                        recordA = [recordA;  sum(A(:,7))];
                        recordB = [recordB; sum(B(:,1)-B(:,2)+1) sum(B(:,end))];
                        
                        dircsv = sprintf('../InstanceAndresult/table4/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/decom_listBA.csv',tandR,N,ai,nmax,TestTime);
                        C=csvread(dircsv);          
                  
                        recordC = [recordC; sum(C(:,3)) sum(C(:,4))];

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
                    Recordxls = [Recordxls;tandR N ai nmax TestTime 0 mean(recordA) 0 max(recordA) 1 mean(recordB) 2 max(recordB) 3 mean(recordC) 4 max(recordC) 5 markrate];
                else
                    Recordxls = [Recordxls;tandR N ai nmax TestTime zeros(1,18)];
                end
            end
        end
    end
end
csvwrite('RecordTable4BB.csv',Recordxls);  