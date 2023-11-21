%___________________________________________________________________%
%  Batch file for small-sized experiments corresponding to table 6  %
%  Setting:                                                         %
%  order number B = 80                                              %
%  upper limit X = 100                                              %
%  a = -0.08                                                        %
%  [tau, R] = [0.5 0.25],[0.5 0.5],[0.5 0.75],[0.25 0.25],          %
%       [0.25 0.5],[0.25 0.75],[0.75 0.25],[0.75 0.5],[0.75 0.75]   %
%                                                                   %
%  Source codes demo version 1.0                                    %
%                                                                   %
%  Developed in MATLAB R2019a(9.6.0)                                %
%                                                                   %
%  Author and programmer: jinchang                                  %
%                                                                   %
%         e-Mail: jinchang@sdnu.edu.cn                              %
%___________________________________________________________________%
clc;
clear all;
global ai;
global node_split;
global split_list;
global split_list1or2;
global decom_list;
global node_decom;
global cut_count;
global Limit;
global decom_listBA;
global decom_listDetail;

Limit = 3600;
aa = [0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64];

for B = 80:20:80
    for X = 100:40:100
        for tandR = 1:9
            for a = 15:15
            	for TestTime = 1:20    
                    Recordxls = [];
                    Recordxls2 = [];
                    csv = sprintf('Instance-tandR%d-N%d-ai%d-nmax%d-TestTime%d',tandR,B,a,X,TestTime);
                    dircsv = ['../InstanceAndresult/table6/instances/' csv];
                    bbfile = ['outputBB-' csv(10:end)];
                    mkdir(bbfile);
                    try
                        A=csvread([dircsv '.csv']);
                        P0 = A(1,:);
                        D0 = round(A(2,:));            

                        [D0,EDD] = sort(D0);
                        P0 = P0(EDD);
                        [P0,SPT] = sort(P0);
                        D0 = D0(SPT);

                        S = 1:B;
                        in_num = 0;
                        ai = aa(a-10);
                        node_split = 0;
                        node_decom = 0;
                        cut_count = 0;
                        split_list = [];
                        decom_list = [];
                        decom_listBA = [];
                        split_list1or2 = [];
                        decom_listDetail = [];
                        tic
                        [ResultOrder,ResultFromtime] = SOOSLEBB(S,in_num,P0,D0,1);
                        cumsumTemp = [];
                        for k = 1:size(ResultOrder,2)
                            cumsumTemp = [cumsumTemp GetTimeLearning(ResultFromtime(k) + P0(ResultOrder(k)),1,0,ai) - D0(ResultOrder(k))];
                        end
                        TT = sum(cumsumTemp(find(cumsumTemp > 0)));
                        Recordxls = [Recordxls;tandR B a X TestTime TT toc];  
                        excelname = csv;
                        try 
                            csvwrite([bbfile '/' 'result.csv'],Recordxls);  
                        catch e
                            [excelname ' result']
                        end
                        try 
                            csvwrite([bbfile '/' 'order.csv'],ResultOrder);  
                        catch e
                            [excelname ' ResultOrder']
                        end
                        try 
                            csvwrite([bbfile '/' 'split_list.csv'],split_list);  
                        catch e
                            [excelname ' split_list']
                        end        
                        try 
                            csvwrite([bbfile '/' 'decom_list.csv'],decom_list);  
                        catch e
                            [excelname ' decom_list']
                        end        
                        try 
                            csvwrite([bbfile '/' 'split_list1or2.csv'],split_list1or2);  
                        catch e
                            [excelname ' split_list1or2']
                        end        
                        try 
                            csvwrite([bbfile '/' 'decom_listBA.csv'],decom_listBA);   
                        catch e
                            [excelname ' decom_listBA']
                        end
                        try 
                            csvwrite([bbfile '/' 'decom_listDetail.csv'],decom_listDetail);  
                        catch e
                            [excelname ' decom_listDetail']
                        end
                    catch err                        
                        csvwrite([bbfile '/' 'error.csv'],[]);  
                    end
                end
            end
        end
    end
end