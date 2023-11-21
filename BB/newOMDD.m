function [OMDDorder,UpperBound,FromJob] = newOMDD(B0,Epsilon,P0,D0) 
% Function: [OMDDorder,UpperBound,FromTime] = newOMDD(B0,Epsilon,P0,D0) 
% Description: Get upper bound by the new OMDD method
%
% Parameters:
%   B0 : initial sequence of orders, usually 1,2,...,B, B is the number of
%       orders.
%   Epsilon : the total job number of all orders that precede all orders of B0.
%   P0 : the job number of order 1,2,...,B.
%   D0 : the due date of order 1,2,...,B.
%
% Return:
%   OMDDorder : the sequence of orders obtained by new OMDD method
%   UpperBound : the upper bound of orders
%   FromTime : the total number of jobs preceding each order in OMDDorder.
%
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************

global ai;
B0 = sort(B0);
Bi = B0;
Pi = P0(B0);
Di = D0(B0);
FromJob = [];
%% 
n = size(Pi,2);
t = Epsilon;     
lastTime = GetTimeLearning(Epsilon,1,0,ai);
sequence = [];
OMDDorder = [];
T  = [];
for i = 1 : n
    FindMax = [];
    P = [];
    for j = 1 : n + 1 - i
        Pj = GetTimeLearning(Pi(j),1,t,ai);
        FindMax = [FindMax Pj+lastTime];
        P = [P Pj];
    end
    FindMax = [FindMax;Di];
    [max_d,~]=max(FindMax);
    index = find(max_d==min(max_d));
    sequence = [sequence Pi(index(1))];
    t = sum(sequence(1,:)) + Epsilon;
    FromJob = [FromJob t - Pi(:,index(1))];
    OMDDorder = [OMDDorder Bi(index(1))];
    DueDate = Di(index(1));
    Pi(:,index(1))=[];
    Di(:,index(1))=[];
    Bi(:,index(1))=[];
    lastTime = lastTime + P(index(1));    
    T = [T max([0 (lastTime - DueDate)])];
end
UpperBound = sum(T);


