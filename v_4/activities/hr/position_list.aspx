﻿<%@ Page Title="" Language="C#" MasterPageFile="~/page_list.master" Theme="ListPage" %>

<script runat="server">
    public string function_edit_name = "list_edit", function_add_name = "list_add";

    void Page_Load(object o, EventArgs e)
    {
        if (Request.QueryString["add"] != null) function_add_name = Request.QueryString["add"].ToString();
        if (Request.QueryString["edit"] != null) function_edit_name = Request.QueryString["edit"].ToString();
        gvdata.DataBind();
    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="Body_Content" Runat="Server">
    <asp:SqlDataSource runat="server" ID="sdsdata" 
        ConnectionString="<%$ ConnectionStrings:csApp %>" 
        SelectCommand="select position_id, position_name from v_hr_position where position_name like @name">
        <SelectParameters>
            <asp:QueryStringParameter Name="name" QueryStringField="name" DefaultValue=" "/>
            
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:GridView runat="server" ID="gvdata" DataSourceID="sdsdata" 
        AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" 
        CellSpacing="1" CssClass="gridViewFrame" GridLines="None" PagerSettings-PageButtonCount="10">
        <Columns>
            <asp:TemplateField HeaderStyle-Width="25px">
                <ItemTemplate>
                    <div class="edit" title="edit" onclick="edit(<%# Eval("position_id") %>);" style="float:left"></div>                    
                </ItemTemplate>
                <HeaderTemplate>
                    <div class="tambah" title="tambah" onclick="tambah(0)"></div>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="position_name" HeaderText="Nama" ReadOnly="True" SortExpression="position_name" HeaderStyle-HorizontalAlign="Left" />
            
        </Columns>
    </asp:GridView>
    <script type="text/javascript">
        document.edit = edit = function (id) {
            window.parent.document["<%= function_edit_name %>"](id);
        }
        document.tambah = tambah = function (id) {
            window.parent.document["<%= function_add_name %>"](id);
        }

        document.refresh = function () { theForm.submit(); }
    </script>
</asp:Content>

