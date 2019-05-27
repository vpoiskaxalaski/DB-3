<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Default.aspx.cs" Inherits="WebApplication1.Default" %>

<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8"/>
    <title></title>
</head>
<body>
     <form id="form1" runat="server">
        <p>
            <label>Города, в которых есть издательства:</label></p>
         <asp:BulletedList ID="BulletedList1" runat="server" Height="146px" Width="248px">
         </asp:BulletedList>
         <asp:TextBox ID="TextBox1" runat="server"></asp:TextBox>
         <asp:Button ID="Button1" runat="server" OnClick="Button1_Click" Text="Посчитать" />
         <br />
         Расстояние от Минска до издательста(введите ID издательства выше): <asp:Label ID="Label1" runat="server"></asp:Label>
         <br />
         <br />
         Изменить (уточнить) пространственный объект:<br />
         id:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
         <asp:TextBox ID="TextBoxId" runat="server"></asp:TextBox>
         <br />
         geogr:&nbsp;
         <asp:TextBox ID="TextBoxGeogr" runat="server"></asp:TextBox>
         <br />
         <asp:Button ID="Button2" runat="server" OnClick="Button2_Click" Text="Изменить" />
         <br />
         <br />
         <asp:Label ID="Result" runat="server"></asp:Label>
    </form>
</body>
</html>
