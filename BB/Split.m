function [BlocksReturn,BlocksFromJob,BlocksSize] = Split(B0,Epsilon,P0,D0) 
% Function: [BlocksReturn,BlocksFromJob,BlocksSize] = Split(B0,Epsilon,P0,D0) 
% Description: calculate E and L of orders, and split all orders into blocks
%
% Parameters:
%   B0 : initial sequence of orders, usually 1,2,...,B, B is the number of
%       orders.
%   Epsilon : the total job number of all orders that precede all orders of B0.
%   P0 : the job number of order 1,2,...,B.
%   D0 : the due date of order 1,2,...,B.
%
% Return:
%   BlocksReturn : the blocks after Split.
%   BlocksFromJob : the total number of jobs preceding each block of BlocksReturn.
%   BlocksSize : the total number of orders of each block of BlocksReturn.
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************

global split_list1or2;
global ai;
B0 = sort(B0);
Pi = P0(B0);
Di = D0(B0);

%% ComputeEL
n = size(Pi,2);
M = zeros(n,n);
N = sum(Pi)+Epsilon;
NL = N*ones(1,n);
NE = Pi+Epsilon;
ML = GetTimeLearning(N,1,0,ai);
L = ML*ones(1,n);
E = [];
for i = 1:n
    E = [E GetTimeLearning(NE(i),1,0,ai)];
end
% record
countall = 0;
count1 = 0;
count11 = 0;
count12 = 0;
count2 = 0;

mark = 1;
while mark == 1
    countall = countall + 1;
    mark = 0;
    for i = 1 : n
        for j = i+1 : n
            if M(i,j)==1
                continue;
            end
            if Di(i)<=Di(j) || E(j)>=Di(i)                
                count1 = count1 + 1;
                if Di(i)<=Di(j)
                    count11 = count11 + 1;
                end
                if E(j)>=Di(i)
                    count12 = count12 + 1;
                end
                M(i,j) = 1;
                NE(j) = NE(j) + Pi(i);
                NL(i) = NL(i) - Pi(j);
                mark = 1;
                E(j) = GetTimeLearning(NE(j),1,0,ai);
                L(i) = ML-GetTimeLearning(N-NL(i),1,NL(i),ai);
            end
            if Di(i)>Di(j) && L(j)<=Di(i)+GetTimeLearning(Pi(i),1,NL(j)-Pi(i),ai) && E(j)<Di(i)
                count2 = count2 + 1;
                M(i,j) = 1;
                NL(j) = NL(j) - Pi(i);
                NE(i) = NE(i) + Pi(j);
                mark = 1;
                E(i) = GetTimeLearning(NE(i),1,0,ai);
                L(j) = ML-GetTimeLearning(N-NL(j),1,NL(j),ai);
            end
        end
    end
end
%% 

split_list1or2 = [split_list1or2; size(B0,2) countall count1 count11 count12 count2];

[EDDEi,SplitEi] = sort(NE);
    y1 = [];
    y2 = [];
    for x = 1:n
        if abs(NE(x)-NL(x))< 0.00001
            y1 = [x y1];
            y2 = [find(SplitEi == x) y2];
        end
    end    
y2 = sort(y2);
m = size(y2,2);

%% B0 is the only block returned
if m ==0
    BlocksReturn = {B0};
    BlocksSize = n;
    BlocksFromJob = Epsilon;
    return;
end

B = {};
B_Size = [];
B_From = [];
for i = 1 : m
    if i ==1 && y2(1)==1
        B = [B B0(SplitEi(1,y2(1)))];
        B_Size = [B_Size 1];
        B_From = [B_From Epsilon];
    end
    if i ==1 && y2(1)~=1
        B = [B B0(SplitEi(1,1:y2(1)-1)) B0(SplitEi(1,y2(1)))];
        BeforeNum = SplitEi(1,y2(1));
        B_Size = [B_Size y2(1)-1 1];
        B_From = [B_From Epsilon NE(BeforeNum)-Pi(BeforeNum)];
    end
    if i > 1 && y2(i)-y2(i-1)==1
        B = [B B0(SplitEi(1,y2(i)))];
        BeforeNum = SplitEi(1,y2(i));
        B_Size = [B_Size 1];
        B_From = [B_From NE(BeforeNum)-Pi(BeforeNum)];
    end
    if i > 1 && y2(i)-y2(i-1)>1
        B = [B B0(SplitEi(1,y2(i-1)+1:y2(i)-1)) B0(SplitEi(1,y2(i)))];
        BeforeNum1 = SplitEi(1,y2(i-1));
        BeforeNum = SplitEi(1,y2(i));
        B_Size = [B_Size y2(i)-y2(i-1)-1 1];
        B_From = [B_From NE(BeforeNum1) NE(BeforeNum)-Pi(BeforeNum)];
    end
    if m == i && y2(m) ~= n
        B = [B B0(SplitEi(1,y2(m)+1:n))];
        BeforeNum = SplitEi(1,y2(m));
        B_Size = [B_Size n-y2(i)];
        B_From = [B_From NE(BeforeNum)];
    end
end

BlocksReturn = B;
BlocksSize = B_Size;
BlocksFromJob = B_From;
return;
