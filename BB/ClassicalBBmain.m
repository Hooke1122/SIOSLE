function [ResultOrder,TT] = ClassicalBBmain(P,D,t)
% Function: [ResultOrder,TT] = ClassicalBBmain(P,D,t)
% Description: using classical BB algorithm for solving the scheduling
%   problem of minimizing the total tardiness time without learning effect.
%
% Parameters:
%   P : the processing time of order 1,2,...,B.
%   D : the due date of order 1,2,...,B.
%   t : the earlist start time of order 1,2,...,B.
% Return:
%   ResultOrder : optimal sequence of order 1,2,...,B.
%   TT : the total tardiness of the problem.
%
%         Jinchang
%   Revision: 1.0  Data: 2023-11-07
%*************************************************************************

[P,SPT] = sort(P);
D = D(SPT);

N = size(P,2);
B = 1:N;

[ResultOrder,ResultFromtime] = ClassicalBB(B,t,P,D);
cumsumTemp = ResultFromtime + P(ResultOrder) - D(ResultOrder);
TT = sum(cumsumTemp(find(cumsumTemp > 0)));