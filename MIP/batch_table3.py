# coding: utf-8

from gurobipy import *
import numpy as np

for TestTime in range(1, 21):
    for B in range(12,13,3):
        for X in range(19, 20, 3):
            for tandR in range(1, 10, 1):
                for ai in range(12, 13, 1):
                    filename = '../InstanceAndresult/table1/instances/Instance-tandR'+str(tandR)+'-N'+str(B)+'-ai'+str(ai)+'-nmax'+str(X)+'-TestTime'+str(TestTime)+'.csv'
                    sheet = np.genfromtxt(filename, delimiter=' ', dtype= str)
                    row1 = sheet[0].split(",")
                    row2 = sheet[1].split(",")
                    # Parameters
                    # job number and due date of orders
                    SNi = []
                    SDi = []
                    for i in range(B):
                        SNi.append(int(row1[i]))
                        SDi.append(int(row2[i]))

                    # learning effect index
                    learninglist = [0, -0.01, -0.02, -0.04, -0.08, -0.16, -0.32, -0.64]
                    a = learninglist[ai-11];

                    # The completion time of the job
                    sumN = sum(SNi);
                    nJob = len(SNi);

                    SPii = [1];
                    for j in range(1, sumN):
                        SPii.append((j+1)**a + SPii[j-1]);

                    # Creating Model
                    model = Model("MODEL")

                    # Decision variables
                    Z = {}
                    T = {}
                    C = {}
                    S = {}

                    for j in range(0, sumN):
                        for r in range(0, nJob):
                            Z[j, r] = model.addVar(vtype=GRB.BINARY, name="Z%s" % str([j, r]))

                    for r in range(0, nJob):
                        T[r] = model.addVar(name="T%s" % str([r]))
                    for r in range(0, nJob):
                        C[r] = model.addVar(name="C%s" % str([r]))

                    for r in range(0, nJob):
                        for j in range(0, sumN):
                            S[r, j] = model.addVar(vtype=GRB.BINARY, name="S%s" % str([r, j]))

                    model.update();

                    # objective functions
                    model.setObjective(quicksum(T[r] for r in range(0, nJob)), GRB.MINIMIZE)

                    # adding constriant
                    for r in range(0, nJob):
                        for j in range(0, sumN):
                            model.addConstr(C[r] >= Z[j, r] * SPii[j], "constriant0")

                    for r in range(0, nJob):
                        model.addConstr(C[r] >= 0, "constriant0")

                    for r in range(0, nJob):
                        model.addConstr(quicksum(Z[j, r] for j in range(0, sumN)) == SNi[r], "constriant2")

                    for j in range(0, sumN):
                        model.addConstr(quicksum(Z[j, r] for r in range(0, nJob)) == 1, "constriant3")

                    for r in range(0, nJob):
                        model.addConstr(Z[0, r] + Z[sumN - 1, r] <= 1, "constriant4")

                    for r in range(0, nJob):
                        model.addConstr(quicksum(S[r, j] for j in range(0, sumN)) == 2, "constriant5")

                    for r in range(0, nJob):
                        for j in range(0, sumN - 1):
                            model.addConstr(S[r, j] >= Z[j + 1, r] - Z[j, r], "constriant6")

                    for r in range(0, nJob):
                        for j in range(0, sumN - 1):
                            model.addConstr(S[r, j] >= Z[j, r] - Z[j + 1, r], "constriant7")

                    for r in range(0, nJob):
                        model.addConstr(S[r, sumN - 1] >= Z[0, r] - Z[sumN - 1, r], "constriant6")
                        model.addConstr(S[r, sumN - 1] >= Z[sumN - 1, r] - Z[0, r], "constriant7")

                    for r in range(0, nJob):
                        model.addConstr(T[r] >= C[r] - SDi[r], "constriant8")

                    for r in range(0, nJob):
                        model.addConstr(T[r] >= 0, "constriant9")

                    model.write("model.lp");
                    model.update();
                    model.setParam('TimeLimit', 3600);
                    model.optimize();
                    # output solution
                    obj = model.getObjective()
                    outfile = r'outputMIP-tandR'+str(tandR)+'-N'+str(B)+'-ai'+str(ai)+'-nmax'+str(X)+'-TestTime'+str(TestTime)
                    if os.path.exists(outfile) == False:
                        os.mkdir(outfile)
                    result = np.array([[obj.getValue(),model.MIPGap,model.Runtime,model.NumVars,model.NumIntVars,model.NumBinVars]])
                    np.savetxt(outfile+'/result.csv', result, delimiter=',')

                    temp = -1;
                    order = []
                    for j in range(0, sumN):
                        for r in range(0, nJob):
                            if abs(Z[j, r].X - 1) < 0.0001 and temp != r:
                                order.append(r + 1)
                                temp = r

                    np.savetxt(outfile+'/order.csv', np.array([order]), delimiter=',')




