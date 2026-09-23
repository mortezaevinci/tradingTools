using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using System.Reflection;
using ProtoBuf;
using System.IO;

namespace MHA
{
    [Serializable(), ProtoContract]
    public class floatComplex
    {
        [ProtoMember(1, IsRequired = true)]
        public float[] Value;

        public void Init()
        {
            Value = new float[2];
        }

        public static floatComplex operator+(floatComplex y0, floatComplex input)
        {
            floatComplex val=new floatComplex();
            val.Init(y0.Value[0] + input.Value[0], y0.Value[1] + input.Value[1]);
            return val;
        }

        public void Init(float r,float i)
        {
            Init();
            Value[0] = r;
            Value[1] = i;
        }

        public void Init(double magnitude, double phaseDegrees, double w1)
        {
            Init();
            float ws = (float)(phaseDegrees * 3.14 / 180);
            Value[0] = (float)magnitude * (float)Math.Cos(ws);
            Value[1] = (float)magnitude * (float)Math.Sin(ws);
        }

        public float Imag()
        {
            return Value[1];
        }

        public float Real()
        {
            return Value[0];
        }

        public void GetfromIString(string istring)
        {
            bool signispos = true;
            string[] realimag = istring.Split(new string[] { "+i" }, StringSplitOptions.None);
            if (realimag.Count() != 2)
            {
                signispos = false;
                realimag = istring.Split(new string[] { "-i" }, StringSplitOptions.None);
                if (realimag.Count() != 2) return;
            }
            if (Value == null) Init();

            Value[0] = Convert.ToSingle(realimag[0]);
            Value[1] = Convert.ToSingle(realimag[1]);

            if (signispos == false) Value[1] = -Value[1];
        }

        public override string ToString()
        {
            string vcomplex = "";
            if (Value[1] > 0)
                vcomplex = String.Format("{0:0.#}{1}{2:0.#}", Value[0], "+i", Value[1]);
            else
                vcomplex = String.Format("{0:0.#}{1}{2:0.#}", Value[0], "-i", -Value[1]);
            return vcomplex;
        }
    }


    public static class SystemCoreExpansion
    {

#if DEBUG_CUSTOMIZE
        public static bool debugCustomize = true;
#else
        public static bool debugCustomize = false;
#endif

        public static string GetDescription(this Enum value)
        {
            try
            {
                FieldInfo field = value.GetType().GetField(value.ToString());
                if (field == null) return null;
                object[] attribs = field.GetCustomAttributes(typeof(DescriptionAttribute), true);
                if (attribs.Length > 0)
                {
                    return ((DescriptionAttribute)attribs[0]).Description;
                }
                return String.Empty;
            }
            catch //(Exception ex)
            {
                return null;
            }
            //return null;
        }

     

        public class AsyncMethod<TEMPLATE>
        {
            private TEMPLATE _returnvalue;
            public TEMPLATE ReturnValue
            {
                get
                {
                    return _returnvalue;
                }
                private set
                {
                    _returnvalue = value;
                }
            }

            public AsyncMethod()
            {

            }

            public void Execute(Func<TEMPLATE> func)
            {
                ReturnValue = func.Invoke();
            }


        }
        public static MemoryStream ResourceToMemoryStream(byte[] resource)
        {
            // byte[] adv6_1measurements_protobuf = global::SciSense.Properties.Resources.ADV6_1_SciMea;
            MemoryStream memstream = new MemoryStream();
            memstream.Write(resource, 0, resource.Length);
            memstream.Seek(0, SeekOrigin.Begin);
            return memstream;
        }

        public static Type GetEnumType(string name)
        {
            return (from assembly in AppDomain.CurrentDomain.GetAssemblies()
                    let type = assembly.GetType(name)
                    where type != null && type.IsEnum
                    select type).FirstOrDefault();
        }

        public static T ByteArrayToVal<T>(byte[] val)
        {
            if (typeof(T) == typeof(float))
            {
                return (T)(object)System.BitConverter.ToSingle(val, 0);
            }
            if (typeof(T) == typeof(byte))
            {
                return (T)(object)val[0];
            }
            return (T)(object)null;
        }
    }

       

    [ProtoContract]
    public class MyArray<T>
    {
        [ProtoMember(1,IsRequired=true)]
        public T[] _array;
        
        public MyArray()
        {

        }
        public MyArray(T[] array)
        {
            _array = array;
        }
    }
}

