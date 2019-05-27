using Microsoft.SqlServer.Server;
using System;
using System.Data;
using System.Data.Sql;
using System.Data.SqlTypes;
using System.IO;
using System.Runtime.InteropServices;
using System.Text;
using System.Text.RegularExpressions;

namespace LPLab03
{
    [Serializable]
    [SqlUserDefinedType(Format.UserDefined, MaxByteSize = 8000)]
    public struct MyType : INullable, IBinarySerialize
    {
        private SqlString value;
        private bool isNull;

        public MyType(bool isNull)
        {
            this.isNull = isNull;
            value = null;
        }

        public MyType(string value)
        {
            isNull = false;
            this.value = value;
        }

        public override string ToString()
        {
            return isNull ? null : value.ToString();
        }

        public bool IsNull
        {
            get
            {
                return isNull;
            }
        }

        public static MyType Null
        {
            get
            {
                MyType type = new MyType();
                type.isNull = true;
                return type;
            }
        }

        public static MyType Parse(SqlString s)
        {
            string value = s.Value.ToString();

            if (s.IsNull)
            {
                return Null;
            }

            MyType type = new MyType(null);

            string regex = @"^[А-Я]{2}[0-9]{6}"; 
            if (Regex.IsMatch(value, regex))
            {
                type = new MyType(value);
            }                  

            return type;
        }

        public void Read(BinaryReader r)
        {
            value = r.ReadString();
        }

        public void Write(BinaryWriter w)
        {
            w.Write(value.ToString());
        }
    }
}
