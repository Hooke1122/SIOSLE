function [ResultOrder,ResultFromtime] = ClassicalBB(B0,t,P0,D0)
% Function: [ResultOrder,ResultFromtime] = ClassicalBB(B0,t,P0,D0)
% Description: The main flowchart of Classical branch-and-bound algorithm
%   to solve a single machine scheduling problem without learning effect to
%   minimize the total tardiness.
%
% Parameters:
%   B0 : initial sequence of jobs, usually 1,2,...,B, B is the number of
%       jobs.
%   t : the earlist start time of job 1,2,...,B.
%   P0 : the processing time of job 1,2,...,B.
%   D0 : the due date of job 1,2,...,B.
% Return:
%   ResultOrder : optimal sequence of job 1,2,...,B.
%   ResultFromtime : the start time of jobs in optimal sequence.
%------------------------------- Reference --------------------------------
% [1] Koulamas, C.: The single-machine total tardiness scheduling problem:
%   Review and extensions. Eur. J. Oper. Res. 202(1),1¨C7 (2010)
%
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************
%% ClassicalSplit 
[Blocks,BlockFromTime,BlocksSize] = ClassicalSplit(B0,t,P0,D0); 
Bsize = size(Blocks,2);
%% single-order block
if size(find(BlocksSize>1),2)==0
    ResultOrder = cell2mat(Blocks);
    ResultFromtime = BlockFromTime;
    return;
end

%% multi-order block
B_Sequence_return = [];
B_FromTime_return = [];
for i = 1 : Bsize
    BsizeSub = size(Blocks{1,i},2);
    if BsizeSub>1
       %% ClassicalDecompose
        [ResultDecomposed,DecomResult] = ClassicalDecompose(Blocks{1,i},BlockFromTime(1,i),P0,D0);
        T_comparision = [];
        B_temp_prime = [];
        B_FromTime_temp_prime = [];
        for j = 1:size(ResultDecomposed,1)    
            B_temp = [];
            B_FromTime_temp = [];           
          % Part1
            Part1 = ResultDecomposed(j,1:DecomResult(j)-1);
            if size(Part1,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)-1)];
                B_FromTime_temp = [B_FromTime_temp BlockFromTime(1,i)];               
            elseif size(Part1,2)>1
                [ResultOrderi,Resulti] = ClassicalBB(Part1,BlockFromTime(1,i),P0,D0);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end
            
          % Part2            
            B_temp = [B_temp ResultDecomposed(j,DecomResult(j))];
            if size(B_FromTime_temp,2) == 0
                B_FromTime_temp = [B_FromTime_temp BlockFromTime(1,i)];
            else
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))];
            end
            
          % Part3 
            Part3 = ResultDecomposed(j,DecomResult(j)+1:end);
            if size(Part3,2)==1
                B_temp = [B_temp ResultDecomposed(j,DecomResult(j)+1)];
                B_FromTime_temp = [B_FromTime_temp B_FromTime_temp(1,end)+P0(B_temp(1,end-1))]; 
            elseif size(Part3,2)>1
                [ResultOrderi,Resulti] = ClassicalBB(Part3,B_FromTime_temp(1,end)+P0(ResultDecomposed(j,DecomResult(j))),P0,D0);   
                B_temp = [B_temp ResultOrderi];
                B_FromTime_temp = [B_FromTime_temp Resulti];                
            end  
            cumsumTemp = B_FromTime_temp + P0(B_temp) - D0(B_temp);
            T_comparision = [T_comparision sum(cumsumTemp(find(cumsumTemp > 0)))];
            B_temp_prime = [B_temp_prime;B_temp];
            B_FromTime_temp_prime = [B_FromTime_temp_prime;B_FromTime_temp];
        end
        decide = find(T_comparision==min(T_comparision));     
        B_Sequence_return = [B_Sequence_return B_temp_prime(decide(1),1:end)];
        B_FromTime_return = [B_FromTime_return B_FromTime_temp_prime(decide(1),1:end)];
    else
        B_Sequence_return = [B_Sequence_return Blocks{1,i}];
        B_FromTime_return = [B_FromTime_return BlockFromTime(1,i)];
    end    
end
ResultOrder = B_Sequence_return;
ResultFromtime = B_FromTime_return;
