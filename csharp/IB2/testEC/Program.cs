using System;
using MHA;
using IBApi;
using System.Collections.Generic;

namespace testEC
{
    class Program
    {
        static void Main(string[] args)
        {
            List<ExternalCondition> ecs=new List<ExternalCondition>();

            ExternalCondition ec;
                ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.PlaceOrder;
            ec.conjunction = ExternalCondition.Conjunction.AndOpen;
            ec._satisfied = true;            
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.PlaceOrder;
            ec.conjunction = ExternalCondition.Conjunction.OrClose;
            ec._satisfied = true;
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.PlaceOrder;
            ec.conjunction = ExternalCondition.Conjunction.AndOpen;
            ec._satisfied = false;
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.PlaceOrder;
            ec.conjunction = ExternalCondition.Conjunction.OrClose;
            ec._satisfied = true;
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.CancelOrder;
            ec.conjunction = ExternalCondition.Conjunction.OrOpen;
            ec._satisfied = true;
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.CancelOrder;
            ec.conjunction = ExternalCondition.Conjunction.AndClose;
            ec._satisfied = true;
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.CancelOrder;
            ec.conjunction = ExternalCondition.Conjunction.OrOpen;
            ec._satisfied = false;
            ecs.Add(ec);

            ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.CancelOrder;
            ec.conjunction = ExternalCondition.Conjunction.AndClose;
            ec._satisfied = true;
            ecs.Add(ec);

            for (int i = 0; i < 2; i++)
                for (int j = 0; j < 2; j++)
                    for (int k = 0; k < 2; k++)
                        for (int l = 0; l < 2; l++)
                        {
                            ecs[0]._satisfied = i == 0;
                            ecs[1]._satisfied = j == 0;
                            ecs[2]._satisfied = k == 0;
                            ecs[3]._satisfied = l == 0;
                            ecs[4]._satisfied = i == 0;
                            ecs[5]._satisfied = j == 0;
                            ecs[6]._satisfied = k == 0;
                            ecs[7]._satisfied = l == 0;
                            Dictionary<ExternalCondition.Action, bool> result = ExternalCondition.EvaluateConditions(ecs);
                            Console.Write("({0}|{1})&({2}|{3})", ecs[0].IsSatisfied(), ecs[1].IsSatisfied(), ecs[2].IsSatisfied(), ecs[3].IsSatisfied());
                            Console.WriteLine("  sub={0},can={1}", result[ExternalCondition.Action.PlaceOrder], result[ExternalCondition.Action.CancelOrder]);
                        }
            Console.ReadKey();

        }
    }
}
