close all
clc
clear all 
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];
tR = {[0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],[0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]};
for N = 80:80
    for nmax = 100:10:100
        for TestTime = 1:20
            for ai = 16:18
                for tandR = 2:2
                    a = aa(ai-10);
                    t=tR{tandR}(1);
                    R=tR{tandR}(2);                
                    SNi  = randi([1 nmax],1,N);
                    sumN = sum(SNi);
                    C = GetTimeLearning(sumN,1,0,a);
                    SDi =unifrnd (C*(1-t-R/2), C*(1-t+R/2), 1,N);
                    SDi = sort(SDi);
                    csvwrite(sprintf('Instance-tandR%d-N%d-ai%d-nmax%d-TestTime%d.csv',tandR,N,ai,nmax,TestTime),[SNi;SDi]); 
                end
            end
        end
    end
end