function [BlocksReturn,BlocksFromTime,BlocksSize] = ClassicalSplit(B0,t,P0,D0) 
% Function: [BlocksReturn,BlocksFromJob,BlocksSize] = ClassicalSplit(B0,t,P0,D0) 
% Description: calculate E and L of orders, and split all jobs into blocks
%
% Parameters:
%   B0 : initial sequence of jobs, usually 1,2,...,B.
%   t : the earlist start time of all jobs.
%   P0 : the processing time of job 1,2,...,B.
%   D0 : the due date of job 1,2,...,B.
%
% Return:
%   BlocksReturn : the blocks after Split.
%   BlocksFromTime : the start time of blocks of BlocksReturn.
%   BlocksSize : the total number of jobs of each block of BlocksReturn.
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************

B0 = sort(B0);
Pi = P0(B0);
Di = D0(B0);

PDi = Pi + Di;
N = size(Pi,2);
n = N;
P = sum(Pi);
Ei = Pi + t;
Li = P*ones(1,N) + t;

for j  = N:-1:1
    if j ~= N
        Pi = Pi(1,1:end-1);
        Di = Di(1,1:end-1);
        PDi = Pi + Di;
        n = size(Pi,2);
        P = sum(Pi);
    end
    
    [EDD1,EDD2] = sort(Di);
    J  = find(EDD2 == n);

    [PD1,PD2] = sort(PDi);

    %% Step1
    for i = 1 : J - 1 
        Ei(n) = Ei(n) + Pi(EDD2(i));
        Li(EDD2(i)) = Li(EDD2(i)) - Pi(n);
        BorA = 1;
    end

    %% Step2
    for i = J + 1 : n 
        if Ei(n) >= Di(EDD2(i))
            Ei(n) = Ei(n) + Pi(EDD2(i));
            Li(EDD2(i)) = Li(EDD2(i)) - Pi(n); 
        else
            break;
        end    
    end

    %% Step3
    for i = n : -1 : 1 
        if Li(n) <= Di(PD2(i)) + Pi(PD2(i))
            if Di(PD2(i)) > Ei(n) && Di(PD2(i)) > Di(n)
                Li(n) = Li(n) - Pi(PD2(i));
                Ei(PD2(i)) = Ei(PD2(i)) + Pi(n);
            end
        else
            break;
        end    
    end
end

[EDDEi,SplitEi] = sort(Ei);
    y1 = [];
    y2 = [];
    for x = 1:N
        if abs(Ei(x)-Li(x))< 0.00001
            y1 = [x y1];
            y2 = [find(SplitEi == x) y2];
        end
    end    
y2 = sort(y2);
m = size(y2,2);
if m ==0
    BlocksReturn = {B0};
    BlocksFromTime = t;
    BlocksSize = N;
    return;
end
B = {};
B_FromTime = [];
CUMS = cumsum(P0(B0(SplitEi)));
B_num = [];

for i = 1 : m
    if i ==1 && y2(1)==1
        B = [B B0(SplitEi(1,y2(1)))];
        B_FromTime = [B_FromTime t];
        B_num = [B_num 1];
    end
    if i ==1 && y2(1)~=1
        B = [B B0(SplitEi(1,1:y2(1)-1)) B0(SplitEi(1,y2(1)))];
        B_FromTime = [B_FromTime t CUMS(y2(1)-1)+t];
        B_num = [B_num y2(1)-1 1];
    end
    if i > 1 && y2(i)-y2(i-1)==1
        B = [B B0(SplitEi(1,y2(i)))];
        B_FromTime = [B_FromTime CUMS(y2(i)-1)+t];
        B_num = [B_num 1];
    end
    if i > 1 && y2(i)-y2(i-1)>1
        B = [B B0(SplitEi(1,y2(i-1)+1:y2(i)-1)) B0(SplitEi(1,y2(i)))];
        B_FromTime = [B_FromTime CUMS(y2(i-1))+t  CUMS(y2(i)-1)+t];
        B_num = [B_num y2(i)-y2(i-1)-1 1];
    end
    if m == i && y2(m) ~= N
        B = [B B0(SplitEi(1,y2(m)+1:N))];
        B_FromTime = [B_FromTime CUMS(y2(m))+t];
        B_num = [B_num N-y2(i)];
    end
end

BlocksReturn = B;
BlocksFromTime = B_FromTime;
BlocksSize = B_num;
return;