function RecordFigure1BB
clc;
clear all;
Recordxls2 = [];
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
for N = 80:20:80
    for nmax = 100:40:100
        for tandR = 2:2 
            for ai = 18:-1:11
                Recordxls = [];
                for TestTime = 1:20
                    try
                        dircsv = sprintf('../InstanceAndresult/table5/tandR%d-N%d-ai%d-nmax%d-TestTime%d/outputBB/decom_listBA.csv',tandR,N,ai,nmax,TestTime);
                        B=csvread(dircsv);
                        DeepNumdecom = [];
		                DeepNumdecom(1) = -1;
                        for deep = 2:81 
                            DeepNumdecom(deep) = sum(B(find(B(:,2)==deep),3) - B(find(B(:,2)==deep),4));
                        end
                        Recordxls = [Recordxls;DeepNumdecom]; 
                    catch err
                        continue;                      
                    end
                end
                Recordxls2 = [Recordxls2;tandR N ai nmax aa(ai-10) mean(Recordxls)];
            end
        end
    end
end
csvwrite('RecordFigure1BB.csv',Recordxls2);  
