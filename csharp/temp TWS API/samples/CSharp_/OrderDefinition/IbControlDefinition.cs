using IBApi;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Xml.Serialization;
using System.IO;

namespace MHA
{
    [Serializable]
    public class IbControlDefinition
    {
        public int port;
        public string host;
        public int ClientId;
        public List<OrderDefinition> orderDefinitions=new List<OrderDefinition>();

        public void saveXML(string filename)
        {
            XmlSerializer ser = new XmlSerializer(typeof(IbControlDefinition));

            TextWriter writer = new StreamWriter(filename);
            ser.Serialize(writer, this);
            writer.Close();
        }
    }

    public class OrderDefinition
    {
        public Contract contract;
        public Order order;
    }
}
