using IBApi;
using IBApi.messages;
using System;
using System.Collections.Generic;
using System.ComponentModel.Design;
using System.IO.Pipes;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;


namespace MHA
{
    [Serializable]
    public class ExternalCondition
    {
        BasicLogger basicLogger = new BasicLogger();


        public event Updated updated;
        public delegate void Updated(object sender);

        public bool _satisfied = false;
        public enum ConditionType
        {
            LowerThan, //to ignore trade if daily high is more than entry anyway
            HigherThan,
            LowerThanOnce,
            HigherThanOnce,
            Count
        }

        public enum ComparisonType
        {
            Absolute,
            RelativeToFirst, //can expand to dicate taking averages later
            TickInfoVolume,
            TickInfoPrice,
            TickInfoRate,
            RelativeToFirstPercentage,
        }

        public enum IbField
        {
            BidPrice=1,
            AskPrice=2,
            LastPrice=4,
            High=6,
            Low=7,
            Volume=8,
            ClosePrice=9,
            OpenTick=14
        }

        public enum Action
        {
            PlaceOrder,
            CancelOrder
        }

        public enum Conjunction
        {
            And,
            Or,
            AndOpen,  //open paranthesis
            OrOpen,  // open paranthesis
            AndClose,
            OrClose
        }

        public enum ThresholdType
        {
            EntryStp,
            EntryLmt,
            StpLoss,
            Target1,
            Target2,
            Target,
            Vol,
            DiffVolMax,
            DiffVolAve,
            VolLinearMap,
            StpLmtDiffPerc,
            MAtr,
            TrailAmt,
            LmtOfStp,
            VolRate,
            Count
        }

        public IbField ibField;
        
        public double[] parameters;
        public ConditionType conditionType;
        public Action action;
        public Conjunction conjunction;
        public ThresholdType thresholdType;
        public ComparisonType comparisonType;
        public ContractDefinition contractDefinition; //
        public int satisfyTimes;
        private int _satisfiedTimes = 0;

        public ExternalCondition()
        {
            //parameters;
            comparisonType = ComparisonType.Absolute;
            satisfyTimes = 1; //default check only one time, but for volume check 2 times, because ib's volume is wrong sometimes
        }

      
        public bool IsSatisfied()
        {
            return _satisfied;
        }

        public bool CheckSatisfied(IBApi.messages.MarketDataMessage msg,int rid)
        {
            if (msg is TickPriceMessage)
            {
                return CheckSatisfied(msg as TickPriceMessage,rid);
            }
            if (msg is TickSizeMessage)
            {
                return CheckSatisfied(msg as TickSizeMessage,rid);
            }


            return false;
        }

        public bool CheckSatisfied(IBApi.messages.TickSizeMessage msg,int rid)
        {
            if (msg.Size <= 0) return _satisfied;
            //xxxx
            if (contractDefinition.reservedRequestId != rid)
                return IsSatisfied();

            bool tempsatisfied = _satisfied;

            if (msg.Field==(int)ibField)
            {
               
                long size = TradeExtension.getActualSize(contractDefinition, msg);
                contractDefinition.tickInfo.processTickInfo(size);

                long comval = size;
                if (comparisonType == ComparisonType.RelativeToFirst)
                {
                    long relative = 0;
                    if (contractDefinition.tickInfo.filled == true)
                    {
                       
                            relative = (long)contractDefinition.tickInfo.value;
                            //Console.WriteLine("relativeVol({0})={1}", ContractDefinition.Tools.getText(contractDefinition.contract), relative);
                     
                    }
                    else
                    {
                        return _satisfied;
                    }
                    comval = size - relative;
                }
                if (comparisonType == ComparisonType.RelativeToFirstPercentage)
                {
                    long relative = 0;
                    if (contractDefinition.tickInfo.filled == true)
                    {

                        relative = (long)contractDefinition.tickInfo.value;
                        //Console.WriteLine("relativeVol({0})={1}", ContractDefinition.Tools.getText(contractDefinition.contract), relative);
                        if (relative == 0) return _satisfied;
                    }
                    else
                    {
                        return _satisfied;
                    }
                    comval = (size - relative)/relative;
                }
                else if (comparisonType == ComparisonType.TickInfoVolume)
                {
                    if (contractDefinition.tickInfo.filled == true)
                    {
                        comval = (long)contractDefinition.tickInfo.value;
                    }
                    else
                    {
                        return _satisfied;
                    }
                }
                else if (comparisonType == ComparisonType.TickInfoPrice)
                {
                  
                        return _satisfied;
                    
                }
                else if (comparisonType == ComparisonType.TickInfoRate)
                {
                    if (parameters.Length != 2) return _satisfied;
                    comval =(long)contractDefinition.tickInfo.valueRate(parameters[1]);
                }

                string cstr = ContractDefinition.Tools.getLocalSymbol(contractDefinition.contract);

                basicLogger.WriteLine(String.Format("{0}\t{1}={2} proc={3}", cstr, TickType.getField(msg.Field), size,comval));

                switch (conditionType)
                {
                    case ConditionType.HigherThan:
                        if (comval > parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                        else
                        {
                            _satisfied = false;
                            _satisfiedTimes = 0;

                        }
                        break;
                    case ConditionType.LowerThan:
                        if (comval < parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                        else
                        {
                            _satisfied = false;
                            _satisfiedTimes = 0;
                        }
                        break;
                    case ConditionType.HigherThanOnce:
                        if (comval > parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                        
                        break;
                    case ConditionType.LowerThanOnce:
                        if (comval < parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                      
                        break;
                }
                basicLogger.WriteLine(String.Format("{0}\tec({2},{3},{4},{5})={1}", cstr, _satisfied,
                    this.thresholdType.ToString(),
                    this.conditionType.ToString(),
                    this.comparisonType.ToString(),
                    this.action.ToString()
                    ));

            }
            if (tempsatisfied != _satisfied)
            {
                updated?.Invoke(this);
            }

            return IsSatisfied();
        }

        public bool CheckSatisfied(IBApi.messages.TickPriceMessage msg,int rid)
        {
            if (msg.Price <= 0) return IsSatisfied();
            //xxxx
            if (contractDefinition.reservedRequestId != rid)
                return IsSatisfied();


            bool tempsatisfied = _satisfied;

            if (msg.Field == (int)ibField)
            {
                double price = msg.Price;

                contractDefinition.tickInfo.processTickInfo(price);

                double comval = price;
                if (comparisonType== ComparisonType.RelativeToFirst)
                {
                    double relative = 0;
                    if (contractDefinition.tickInfo.filled==true)
                    {

                        relative = contractDefinition.tickInfo.value ;
                        
                        comval = price - relative;
                    }
                    else
                    {
                        return _satisfied;
                    }
                }
                if (comparisonType == ComparisonType.RelativeToFirstPercentage)
                {
                    double relative = 0;
                    if (contractDefinition.tickInfo.filled == true)
                    {

                        relative = contractDefinition.tickInfo.value;
                        if (relative == 0) return _satisfied;
                        comval = (price - relative);
                    }
                    else
                    {
                        return _satisfied;
                    }
                }
                else if (comparisonType == ComparisonType.TickInfoVolume)
                {
                   
                        return _satisfied;
                    
                }
                else if (comparisonType == ComparisonType.TickInfoPrice)
                {
                    if (contractDefinition.tickInfo.filled == true)
                    {
                        comval = (double)contractDefinition.tickInfo.value;
                    }
                    else
                    {
                        return _satisfied;
                    }
                }
                else if (comparisonType == ComparisonType.TickInfoRate)
                {
                    if (parameters.Length != 2) return _satisfied;
                    comval = (long)contractDefinition.tickInfo.valueRate(parameters[1]);
                }

                string cstr = ContractDefinition.Tools.getLocalSymbol(contractDefinition.contract);

                basicLogger.WriteLine(String.Format("{0}\t{1}={2} proc={3}", cstr, TickType.getField(msg.Field), price, comval));


                switch (conditionType)
                {
                    case ConditionType.HigherThan:
                        if (comval >= parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                
                                _satisfied = true;
                            }
                        }
                        else
                        {
                            _satisfied = false;

                            _satisfiedTimes = 0;

                        }
                        break;
                    case ConditionType.LowerThan:
                        if (comval <= parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                        else
                        {
                            _satisfied = false;

                            _satisfiedTimes = 0;
                        }
                        break;
                    case ConditionType.HigherThanOnce:
                        if (comval >= parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                       
                        break;
                    case ConditionType.LowerThanOnce:
                        if (comval <= parameters[0])
                        {
                            _satisfiedTimes++;
                            if (_satisfiedTimes >= satisfyTimes)
                            {
                                _satisfied = true;
                            }
                        }
                        
                        break;
                }

                basicLogger.WriteLine(String.Format("{0}\tec({2},{3},{4},{5})={1}", cstr, _satisfied,
                   this.thresholdType.ToString(),
                   this.conditionType.ToString(),
                   this.comparisonType.ToString(),
                   this.action.ToString()
                   ));
            }
            if (tempsatisfied!=_satisfied)
            {
                updated?.Invoke(this);
            }

            return IsSatisfied();
        }
        
        /*
        //WARNING: THIS IS REALLY OLD AND OUTDATED
        public bool CheckSatisfied(IBApi.messages.HistoricalDataMessage msg, int rid)
        {
            if (msg.Close <= 0) return IsSatisfied();
            //xxxx
            if (contractDefinition.reservedRequestId != rid)
                return IsSatisfied();

            bool tempsatisfied = _satisfied;

            double price = 0;
            if ((int)ibField == IBApi.TickType.LAST)
            {
                price = msg.Close;

                contractDefinition.tickInfo.processTickInfo(msg.Close);
            }
            if ((int)ibField == IBApi.TickType.HIGH)
            {
                price = msg.High;

                contractDefinition.tickInfo.processTickInfo(msg.High);
            }
            if ((int)ibField == IBApi.TickType.LOW)
            {
                price = msg.Low;

                contractDefinition.tickInfo.processTickInfo(msg.Low);
            }
            if ((int)ibField == IBApi.TickType.VOLUME)
            {
                price = msg.Volume*100;

                contractDefinition.tickInfo.processTickInfo(msg.Volume*100);
            }

            double relative = 0;
            if (comparisonType == ComparisonType.RelativeToFirst)
            {
                if (contractDefinition.tickInfo.filled == true)
                {
                
                        relative = contractDefinition.tickInfo.value;
                    price
                }
                else
                {
                    return _satisfied;
                }
            }

            if (comparisonType == ComparisonType.RelativeToFirstPercentage)
            {
                if (contractDefinition.tickInfo.filled == true)
                {

                    relative = contractDefinition.tickInfo.value;
                }
                else
                {
                    return _satisfied;
                }
            }

            string cstr = ContractDefinition.Tools.getLocalSymbol(contractDefinition.contract);

            basicLogger.WriteLine(String.Format("{0}", cstr));


            if (price<=0)
            {
                return _satisfied;
            }

                switch (conditionType)
                {
                    case ConditionType.HigherThan:
                        if (price -relative>= parameters[0])
                        {
                        _satisfiedTimes++;
                        if (_satisfiedTimes >= satisfyTimes)
                            _satisfied = true;
                    }
                        else
                        {
                            _satisfied = false;

                        _satisfiedTimes = 0;

                    }
                        break;
                    case ConditionType.LowerThan:
                        if (price-relative <= parameters[0])
                        {
                        _satisfiedTimes++;
                        if (_satisfiedTimes >= satisfyTimes)
                            _satisfied = true;
                    }
                        else
                        {
                            _satisfied = false;

                        _satisfiedTimes = 0;
                    }
                        break;
                }

            basicLogger.WriteLine(String.Format("{0}\tec({2},{3},{4},{5})={1}", cstr, _satisfied,
                 this.thresholdType.ToString(),
                 this.conditionType.ToString(),
                 this.comparisonType.ToString(),
                 this.action.ToString()
                 ));

            if (tempsatisfied != _satisfied)
            {
                updated?.Invoke(this);
            }

            return IsSatisfied();
        }
        */

        /*
        public static Result EvaluateConditions(List<ExternalCondition> ecs)
        {
            Result result = new Result();
            if (ecs == null) return result;
            if (ecs.Count == 0) return result;

        
            int ne = ecs.Count();

            for(int i=0;i<ne;i++)
            {
                bool tempres = ecs[i].IsSatisfied();
                switch (ecs[i].action)
                {
                  

                    case Action.CancelOrder:
                        {
                            switch (ecs[i].conjunction)
                            {
                                case Conjunction.And:
                                    result.Cancel = result.Cancel & tempres;
                                    break;
                                case Conjunction.Or:
                                    result.Cancel = result.Cancel | tempres;
                                    break;
                               
                            }
                        }
                        break;

                    case Action.PlaceOrder:
                        {
                            switch (ecs[i].conjunction)
                            {
                                case Conjunction.And:
                                    result.Submit = result.Submit & tempres;
                                    break;
                                case Conjunction.Or:
                                    result.Submit = result.Submit | tempres;
                                    break;
                               
                            }
                        }
                        break;

                }
                
            }

            return result;
        }
        */

        public static bool EvaluateCondition(List<ExternalCondition> ecs, Action _action, ref bool _result,ref int i)
        {
            if (i == ecs.Count) return _result;

            bool result=_result;
            
            bool tempres = ecs[i].IsSatisfied();
            Action action = ecs[i].action;
            Conjunction cj = ecs[i].conjunction;
            i++;

            if (action == _action)
            {
                switch (cj)
                {
                    case Conjunction.And:
                        result = result & tempres;
                        return EvaluateCondition(ecs, _action, ref result, ref i);
                        break;
                    case Conjunction.Or:
                        result = result | tempres;
                        return EvaluateCondition(ecs, _action, ref result, ref i);
                        break;
                    case Conjunction.AndClose:
                        result = result & tempres;
                        return result;
                        break;
                    case Conjunction.OrClose:
                        result = result| tempres;
                        return result;
                        break;
                    case Conjunction.AndOpen:
                        {
                            bool result0 = tempres;
                            result0 = EvaluateCondition(ecs, _action, ref result0, ref i);
                            result = result & result0;
                            return EvaluateCondition(ecs, _action, ref result, ref i);
                        }
                        break;
                    case Conjunction.OrOpen:
                        {
                            bool result0 = tempres;
                            result0 = EvaluateCondition(ecs, _action, ref result0, ref i);
                            result = result | result0;
                            return EvaluateCondition(ecs, _action, ref result, ref i);
                        }
                        break;

                }
            }
            return EvaluateCondition(ecs, _action, ref result, ref i);

        }

        public static Dictionary<Action,bool> EvaluateConditions(List<ExternalCondition> ecs)
        {
            Dictionary<Action, bool> result = new Dictionary<Action, bool>();
            result.Add(Action.PlaceOrder, true);
            result.Add(Action.CancelOrder, false);
            bool ressubmit = true;
            bool rescancel = false;

            if (ecs == null) return result;
            if (ecs.Count == 0) return result;


            int ne = ecs.Count();

            int i = 0;

            result[Action.CancelOrder]=EvaluateCondition(ecs, Action.CancelOrder, ref rescancel, ref i);
            i = 0;
            result[Action.PlaceOrder] = EvaluateCondition(ecs, Action.PlaceOrder, ref ressubmit, ref i);
            
            return result;
        }
    }
}
