using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using MHA;
using IBApi;
namespace ConsoleAppAddEc
{
    class Program
    {
        

        static void Main(string[] args)
        {
            IBControlDefinition IBCD;
            IBCD = new IBControlDefinition();
            IBCD.loadXML(@"Z:\My files\Project Trading\repo\csharp\files\auto swing order lmt template 3.xml");
            OrderDefinition pod = IBCD.orderWatchlists[0].orderDefinitions[0];

            MHA.ExternalCondition ec = new ExternalCondition();
            ec.action = ExternalCondition.Action.PlaceOrder;
            ec.conditionType = ExternalCondition.ConditionType.LowerThan;
            ec.conjunction = ExternalCondition.Conjunction.And;
            ec.contractDefinition = new ContractDefinition();
            ec.ibField = ExternalCondition.IbField.High;
            ec.parameters = new double[] { 0.01 };
            ec.thresholdType = ExternalCondition.ThresholdType.EntryStp;
            pod.externalConditions.Add(ec);

            MHA.ExternalCondition ec2 = new ExternalCondition();
            ec2.action = ExternalCondition.Action.CancelOrder;
            ec2.conditionType = ExternalCondition.ConditionType.HigherThan;
            ec2.conjunction = ExternalCondition.Conjunction.And;
            ec2.contractDefinition = new ContractDefinition();
            ec2.ibField = ExternalCondition.IbField.High;
            ec2.parameters = new double[] { 9999.99 };
            ec2.thresholdType = ExternalCondition.ThresholdType.EntryLmt;
            pod.externalConditions.Add(ec2);

            IBCD.saveXML(@"Z:\My files\Project Trading\repo\csharp\files\auto swing order lmt template 4.xml");
         
        }
    }
}
