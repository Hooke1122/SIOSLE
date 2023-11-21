function RecordTable6BB
clc;
clear all;
Recordxls2 = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
tR = {[0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],[0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]};

for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 9:-1:1
            for ai = 15:15
                recordA = [];
                recordB = [];
                recordD = [];
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table6/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/result.csv',tandR,N,ai,nmax,TestTime);
                        Sheet1=csvread(dircsv); 
                        dircsv = sprintf('../InstanceAndresult/table6/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/split_list.csv',tandR,N,ai,nmax,TestTime);
                        A=csvread(dircsv);      
                        recordA = [recordA;mean(A(:,3)) Sheet1(end)];
                        
                        dircsv = sprintf('../InstanceAndresult/table6/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/decom_list.csv',tandR,N,ai,nmax,TestTime);
                        B=csvread(dircsv); 
                        dircsv = sprintf('../InstanceAndresult/table6/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/decom_listBA.csv',tandR,N,ai,nmax,TestTime);
                        D=csvread(dircsv);     
                        

                        recordB = [recordB;sum(B(:,3))/sum(B(:,1)-B(:,2)+1)  sum(B(:,4))/sum(B(:,1)-B(:,2)+1) sum(B(:,1)-B(:,2)+1-B(:,5))/sum(B(:,1)-B(:,2)+1)];
                        recordD = [recordD;sum(D(:,3)-D(:,4)) sum(D(:,4))/sum(D(:,3))];
                    catch err
                        dircsv    
                        continue
                    end
                end
                if size(recordB,2) == 0
                    recordB = -1*ones(1,3);
                end
                if size(recordD,2) == 0
                    recordD = -1*ones(1,2);
                end
                Recordxls2 = [Recordxls2;tR{tandR} N ai nmax aa(ai-10) mean(recordA) mean(recordB,1) 0 mean(recordD,1)];
            end
        end
    end
end
csvwrite('RecordTable6BB.csv',Recordxls2);  