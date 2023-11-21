function Lower = GetLowerbound(B0,Epsilon,P0,D0) 
% Function: Lower = GetLowerbound(B0,Epsilon,P0,D0) 
% Description: change the original problem to the modified problem, and get
%       Lower bound of the modified problem by ClassicalBB.
%
% Parameters:
%   B0 : initial sequence of orders, usually 1,2,...,B, B is the number of
%       orders.
%   Epsilon : the total job number of all orders that precede all orders of B0.
%   P0 : the job number of order 1,2,...,B.
%   D0 : the due date of order 1,2,...,B.
%
% Return:
%   Lower : the lower bound of orders
%
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************

global ai;
B0 = sort(B0);
Pi = P0(B0);
Di = D0(B0);
JobAll = sum(Pi);
P = GetTimeLearning(1,1,JobAll-1 + Epsilon,ai);
t = GetTimeLearning(Epsilon,1,0,ai);
Px = Pi*P;
%% Classical BB
[~,Lower] = ClassicalBBmain(Px,Di,t);


