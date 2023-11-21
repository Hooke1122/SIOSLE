All code, data and results have been uploaded to VM at ~/code_revised. code_revised, which includes four folders: MIP, BB, InstanceAndresult, TableAndfigure.

------------------------------------------------------------------------------

Folders MIP includes three batch files for MIP，you can run them by executing :  
$ python3 batch_tableX.py

tableX corresponds to experimental scenarios that can be easily obtained from the Table names in the paper.
The instance batch_tableX.py solves is in the path ../InstanceAndresult/tableX/instances.
After executing the code, they will generate a folder associated with the instance in the same folder, 'outputMIP-tandRX-NX-aiX-nmaxX-TestTimeX'. Each folder includes two files, 'order.csv' and 'result.csv'.

'order.csv' is the order sequence obtained;
'result.csv' includes:  
Column 1 : gap of MIP  
Column 2 : run time of MIP  
Column 3 : number of MIP variables  
Column 4 : number of MIP integer variables  
Column 5 : number of MIP binary variables

------------------------------------------------------------------------------

Folders BB includes the BB code，you can run them by executing :  
$ matlab  
\>\> batch_tableX

tableX corresponds to experimental scenarios that can be easily obtained from the Table names in the paper.
The instance batch_tableX.m solves is in the path ../InstanceAndresult/tableX/instances.
After executing the code, they will generate a folder associated with the instance in the same folder, 'outputBB-tandRX-NX-aiX-nmaxX-TestTimeX'. 
Each folder basically includes 7 files, 'order.csv', 'result.csv', 'split_list.csv', 'decom_list.csv', 'split_list1or2.csv', 'decom_listBA.csv', 'decom_listDetail.csv'.

Note that with the default parameters, matlab can only keep 5 significant digits.

'result.csv' has:  
Column 1-5 : tandR,N,a,nmax,TestTime (to search for a instance)  
Column 6 : total tardiness of the instance  
Column 7 : the algorithm running time (CPU time). 

'order.csv' records the result of the BB algorithm,  i.e. the sequence of orders.

'split_list.csv'  has:  
Column 1 : size of subproblem  
Column 2 : node (subproblem) level  
Column 3 : block number of each subproblem after split  
Column 4 : single-order block number of each subproblem after split  
Column 5-12 : number of blocks in diﬀerent block sizes after split  

'decom_list.csv' has:  
Column 1 : size of block  
Column 2 : the position of order B in the EDD sequence of all orders in the block, and order B is the order with the largest size in the block  
Column 3 : node number of the block cut by Elimination rules 1  
Column 4 : node number of the block cut by Elimination rules 2  
Column 5 : the number of remaining node after Elimination  

'split_list1or2.csv' has:  
Column 1 : size of subproblem  
Column 2 : cycle index  
Column 3 : the number of job pairs meeting Dominance rule 1  
Column 4 : the number of job pairs meeting condition 1 of Dominance rule 1  
Column 5 : the number of job pairs meeting condition 2 of Dominance rule 1  
Column 6 : the number of job pairs meeting Dominance rule 2

'decom_listBA.csv' has:  
Column 1 : size of block  
Column 2 : node (subproblem) level  
Column 3 : the number of remaining node after Elimination  
Column 4 : the number of nodes cut by Initial Bounding   

'decom_listDetail.csv' has:  
Column 1 : size of block  
Column 2 : node (subproblem) level  
Column 3 : the number of remaining node after Elimination  
Column 4 : the position of order B in the node, where order B is the order with the largest size in the block  
Column 5 : whether the node is cut by Initial Bounding  

Structure of procedure:  
&nbsp;──&nbsp;CreateOrder.m  
&nbsp;──&nbsp;batch_tableX.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──&nbsp;SOOSLEBB.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├──&nbsp;Split.m (including&nbsp;ComputeEL)  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├──&nbsp;newOMDD.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├──&nbsp;Decompose.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──&nbsp;GetLowerbound.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──&nbsp;ClassicalBBmain.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──&nbsp;ClassicalBB.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;├──&nbsp;ClassicalSplit.m  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;└──&nbsp;ClassicalDecompose.m

CreateOrder.m can be used to generate instances for different scenarios. 

batch_tableX.m is the batch file for the corresponding experimental scenario of tableX, which calls our proposed SOOSLEBB algorithm to solve each instance. SOOSLEBB.m is the main algorithm we proposed, which calls Split.m, newOMDD.m, Decompose.m, GetLowerbound .m to accomplish the corresponding functions, where GetLowerbound.m is derived from the classical BB algorithm for solving the scheduling problem of minimizing the total tardiness time without learning effect, so we add the prefix 'Classical' to the name of its corresponding algorithm.

GetTimeLearning.m calculates the processing time from the start of one job to the end of another, considering learning effects, and is the basic calculation. It is called by most functions, including CreateOrder.m, batch_tableX.m, SOOSLEBB.m, Split.m (including ComputeEL), newOMDD.m, Decompose.m, and GetLowerbound.m. Only ClassicalBBmain.m and its called subfunctions do not call GetTimeLearning.m.

ComputeEL is Algorithm 1 in the paper, but for ease of use we embedded it in the Split.m and did not make it a separate function, so we labeled it directly in the structure picture.

------------------------------------------------------------------------------

Folder InstanceAndresult includes all the instances of the experiments and the results we obtained, they are separated by folder tableX. Here, tableX correspond to experimental scenarios that can be obtained from the Table names in the paper.

The tableX folder contains folder 'instances' and folder 'tandRX-NX-aiX-nmaxX-TestTimeX', folder 'instances' includes all the instances of the scenario corresponding to tableX. 'tandRX-NX-aiX-nmaxX-TestTimeX' is the result of each instance, and contains the ouputBB folder and the ouputMIP folder, the ouputBB folder is the result of BB, including 'order.csv', 'result.csv', 'split_list.csv', 'decom_list.csv', 'split_list1or2.csv', 'decom_listBA.csv ', 'decom_listDetail.csv'. The ouputMIP folder is the result of the MIP run, including 'order.csv' and 'result.csv'.

table1, table2, and table3 include the small-sized instances, the results of these instances include ouputBB and ouputMIP.  
table4, table5, and table6 include the large-sized instances, the results of these instances only include ouputBB.  

------------------------------------------------------------------------------

Folder TableAndfigure includes the programs to calculate the data of tables and figures in the paper. The files are named as 'Record' + table or figure in the paper + the algorithm(BB or MIP), such as RecordTableXMIP.m or RecordFigureXBB.m. Executing them can generate '.csv' files with the same name.

------------------------------------------------------------------------------

Others

For all instances, we use tandR, N, ai, nmax, and TestTime to mark case instances. The meaning of the numbers behind tandR, N, ai, nmax, and TestTime in the name of the instance is as follows.

tandR - (τ, R), 1 to 9 represent (0.5 0.25), (0.5 0.5), (0.5 0.75), (0.25 0.25), (0.25 0.5), (0.25 0.75), (0.75 0.25), (0.75 0.5), (0.75 0.75), (0.75 0.75) , respectively;

N - the total number of orders;  
&nbsp;&nbsp;&nbsp;&nbsp;- To have the same notation as in the paper, we use B for the number of orders variable in the code.

ai - the learning index, 11 to 18 represent 0 -0.01 -0.02 -0.04 -0.08 -0.16 -0.32 -0.64, respectively;

nmax - the maximum order size, the number of jobs in each order was generated from a uniform distribution U(1, nmax);  
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;- To have the same notation as in the paper, we use X as the variable for nmax in the program.

TestTime - the index of instances for each scenario, we further randomly generated 20 instances for each scenario.



