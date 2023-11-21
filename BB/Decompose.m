function [Nodes,Bposition] = Decompose(B0,Epsilon,P0,D0)
% Function: [Nodes,Bposition] = Decompose(B0,Epsilon,P0,D0)
% Description: Decompose blocks to nodes by placing order B in position r
%   such that r ¡Ý s, where order B with the largest number of jobs among all orders
%   ,and prune some of the nodes by Elimination rules
%
% Parameters:
%   B0 : initial sequence of orders, usually 1,2,...,B, B is the number of
%       orders.
%   Epsilon : the total job number of all orders that precede all orders of B0.
%   P0 : the job number of order 1,2,...,B.
%   D0 : the due date of order 1,2,...,B.
%
% Return:
%   Nodes : remaining nodes after Elimination
%   Bposition : the position of order B.
%
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************
global ai;
global decom_list;

[~, B0order] = sort(D0(B0));
B =B0(B0order);

n = size(B,2);
s = find(B == max(B));
Bposition = [];
Nodes = [];
count1 = 0;
count2 = 0;
count3 = 0;
for i = s:n
    temp = B(s);
    tempB = B;
    tempB(s) = [];
    modifiedB = [tempB(1,1:i-1) temp tempB(1,i:end)];
	SumBeforei = sum(P0(modifiedB(1,1:i)));
    Ci = GetTimeLearning(SumBeforei + Epsilon,1,0,ai);
    isEliminate = false;
    %% Elimination rule1
    if i<=n-1 && i>=s &&  Ci>= D0(modifiedB(i+1))
        count1 = count1+1;
        isEliminate = true;
    end
    %% Elimination rule2
    for j = s+1:i
        if Ci< D0(modifiedB(j-1)) + GetTimeLearning(P0(modifiedB(j-1)),1,SumBeforei- P0(modifiedB(j-1))+Epsilon,ai)
            count3 = count3 + 1;
            isEliminate = true;
            break;
        end
    end
    if isEliminate
        continue;
    end    
    Bposition = [Bposition i];
    Nodes = [Nodes;modifiedB];    
end
decom_list = [decom_list;n s count1 count3 size(Bposition,2)];