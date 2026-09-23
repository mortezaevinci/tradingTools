using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace MHA
{
    public class SelleniumDefinition
    {
        public class FindWebElementDefinition
        {

            public enum ByType
            {
                ClassName,
                CssSelector,
                Id,
                LinkText,
                Name,
                PartialLinkText,
                TagName,
                XPath,
                count
            }

            ByType bytype = ByType.Id;
            bool single = true;
            string findWhat;
        }

        public class ActionDefinition
        {
            public enum ActionType
            {
               click,

                count
            }
        }

    }
}
