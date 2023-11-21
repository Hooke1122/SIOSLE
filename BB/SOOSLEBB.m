function [ResultOrder,ResultFromtime] = SOOSLEBB(B0,Epsilon,P0,D0,Level)
% Function: [ResultOrder,ResultFromtime] = SOOSLEBB(B0,Epsilon,P0,D0,Level)
% Description: The main flowchart of branch-and-bound algorithm for
%   SOOSLE(SOOSLEBB) including Split, Elimination, Decomposition and bounding.
%   SOOSLEBB can solve a single machine identical-jobs order scheduling
%   problem with a position-dependent learning effect (SOOSLE) to minimize the total tardiness.
%
% Parameters:
%   B0 : initial sequence of orders, usually 1,2,...,B, B is the number of
%       orders.
%   Epsilon : the total job number of all orders that precede all orders of B0.
%   P0 : the job number of order 1,2,...,B.
%   D0 : the due date of order 1,2,...,B.
%   Level : the level of a node is defined by the number of decompositions
%       by which the node is obtained.
% Return:
%   ResultOrder : optimal sequence of order 1,2,...,B.
%   ResultFromtime : the start time of orders in optimal sequence.
%
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************

global ai;
global Limit
global split_list;
global decom_listBA;
global decom_listDetail;
Level = Level + 1;

%% Split 
[Blocks,BlocksFromJob,BlocksSize] = Split(B0,Epsilon,P0,D0); 
Bsize = size(Blocks,2);
split_list = [split_list;size(B0,2) Level Bsize size(find(BlocksSize==1),2) size(find(BlocksSize>1 & BlocksSize<=11),2)...
    size(find(BlocksSize>11 & BlocksSize<=21),2) size(find(BlocksSize>21 & BlocksSize<=31),2) size(find(BlocksSize>31 & BlocksSize<=41),2) size(find(BlocksSize>41 & BlocksSize<=51),2)...
    size(find(BlocksSize>51 & BlocksSize<=61),2) size(find(BlocksSize>61 & BlocksSize<=71),2) size(find(BlocksSize>71 & BlocksSize<=81),2)];
%% single-order block
if size(find(BlocksSize>1),2)==0
    ResultOrder = cell2mat(Blocks);
    ResultFromtime = BlocksFromJob;
    return;
end
%% multi-order block
B_Sequence_return = [];
B_FromTime_return = [];
for i = 1 : Bsize
    BsizeSub = size(Blocks{1,i},2);
    if BsizeSub>1
       %% Decompose 
        [ResultDecomposed, DecomResult] = Decompose(Blocks{1,i},BlocksFromJob(1,i),P0,D0);    
       %% Get upper bound
        [OMDDorder,UB,FromJob] = newOMDD(Blocks{1,i},BlocksFromJob(1,i),P0,D0);
       %% Time limit
        if toc > Limit
            B_Sequence_return = [B_Sequence_return OMDDorder];
            B_FromTime_return = [B_FromTime_return FromJob];
            continue;
        end
       %% initial bounding for each node
        nodeNum = size(ResultDecomposed,1);    
        Elimite = [];
        for j = 1:nodeNum
            T_Lower = 0; % lower bound
          % Part1 (alpha in paper)
            Part1 = ResultDecomposed(j,1:DecomResult(j)-1);
            if size(Part1,2)==1
                Lower1 = max([GetTimeLearning(BlocksFromJob(1,i)+P0(Part1),1,0,ai)-D0(Part1) 0]);     
                T_Lower = T_Lower + Lower1;
            elseif size(Part1,2)>1
                Lower1 = GetLowerbound(Part1,BlocksFromJob(1,i),P0,D0);  
                T_Lower = T_Lower + Lower1;
            end            
          % Part 2 (B in paper)    
            Lower2 = max([GetTimeLearning(BlocksFromJob(1,i)+sum(P0(ResultDecomposed(j,1:DecomResult(j)))),1,0,ai)-D0(ResultDecomposed(j,DecomResult(j))) 0]);    
            T_Lower = T_Lower + Lower2;
            
          % Part 3 (beta in paper)
            Part3 = ResultDecomposed(j,DecomResult(j)+1:end);
            if size(Part3,2)==1
                Lower3 = max([GetTimeLearning(BlocksFromJob(1,i)+sum(P0(ResultDecomposed(j,:)),1,0,ai))-D0(Part3) 0]);  
                T_Lower = T_Lower + Lower3;
            elseif size(Part3,2)>1
                Lower3 = GetLowerbound(Part3,BlocksFromJob(1,i) + sum(P0(ResultDecomposed(j,1:DecomResult(j)))),P0,D0);   
                T_Lower = T_Lower + Lower3;
            end
            isInitial = 0;
            if T_Lower > UB
                isInitial = 1;
                Elimite = [Elimite j];                
            end
            decom_listDetail = [decom_listDetail;BsizeSub Level nodeNum DecomResult(j) isInitial];
        end         
        decom_listBA = [decom_listBA;BsizeSub Level nodeNum size(Elimite,2)]; %
       %% Remaining nodes after Elimination and initial bounding
        nodeNum = size(ResultDecomposed,1);    
        T_comparision = [];
        B_temp_prime = [];
        B_FromTime_temp_prime = [];
        for j = 1:nodeNum
            if size(find(Elimite==j),2)>0 
                continue;
            end
            B_temp = [];
            B_FromTime_temp = [];           
          % Part1(alpha in paper)
            Part1 = ResultDecomposed(j,1:DecomResult(j)-1);
            if size(Part1,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)-1)];
                B_FromTime_temp = [B_FromTime_temp BlocksFromJob(1,i)];               
            elseif size(Part1,2)>1
                [ResultOrderi,Resulti] = SOOSLEBB(Part1,BlocksFromJob(1,i),P0,D0,Level);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end   
            
          % Part2 (B in paper)              
            B_temp = [B_temp ResultDecomposed(j,DecomResult(j))];
            if size(B_FromTime_temp,2) == 0
                B_FromTime_temp = [B_FromTime_temp BlocksFromJob(1,i)];
            else
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))];
            end    
            
          % Part3  (beta in paper)
            Part3 = ResultDecomposed(j,DecomResult(j)+1:end);
            if size(Part3,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)+1)];
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))]; 
            elseif size(Part3,2)>1
                [ResultOrderi,Resulti] = SOOSLEBB(Part3,B_FromTime_temp(1,end)+P0(ResultDecomposed(j,DecomResult(j))),P0,D0,Level);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end  
            cumsumTemp = [];
            for k = 1:size(B_FromTime_temp,2)
                cumsumTemp = [cumsumTemp GetTimeLearning(B_FromTime_temp(k) + P0(B_temp(k)),1,0,ai) - D0(B_temp(k))];
            end
            T_comparision = [T_comparision sum(cumsumTemp(find(cumsumTemp > 0)))];
            B_temp_prime = [B_temp_prime;B_temp];
            B_FromTime_temp_prime = [B_FromTime_temp_prime;B_FromTime_temp];
        end
       %% get optimal node of a block
        decide = find(T_comparision==min(T_comparision));     
        B_Sequence_return = [B_Sequence_return B_temp_prime(decide(1),1:end)];
        B_FromTime_return = [B_FromTime_return B_FromTime_temp_prime(decide(1),1:end)];
    else
        B_Sequence_return = [B_Sequence_return Blocks{1,i}];
        B_FromTime_return = [B_FromTime_return BlocksFromJob(1,i)];
    end    
end
ResultOrder = B_Sequence_return;
ResultFromtime = B_FromTime_return;
