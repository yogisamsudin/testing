﻿<%@ Page Title="" Language="C#" MasterPageFile="~/page_list.master" theme="ListPage"%>

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
        SelectCommand="select branch_id, branch_name,location_address from v_par_branch where branch_name like @name">
        <SelectParameters>
            <asp:QueryStringParameter Name="name" QueryStringField="name" DefaultValue=""/>
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:GridView runat="server" ID="gvdata" DataSourceID="sdsdata" 
        AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" 
        CellSpacing="1" CssClass="gridViewFrame" GridLines="None" PagerSettings-PageButtonCount="10">
        <Columns>
            <asp:TemplateField HeaderStyle-Width="25px">
                <ItemTemplate>
                    <div class="edit" title="edit" onclick="edit('<%# Eval("branch_id") %>');"></div>
                </ItemTemplate>        
                <HeaderTemplate>
                    <div class="tambah" onclick="tambah();"></div>
                </HeaderTemplate>        
            </asp:TemplateField>
            <asp:BoundField DataField="branch_name" HeaderText="Cabang" ReadOnly="True" SortExpression="branch_name" HeaderStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="location_address" HeaderText="Alamat" ReadOnly="True" SortExpression="location_address" HeaderStyle-HorizontalAlign="Left" ItemStyle-Width="100px"/>            
        </Columns>
    </asp:GridView>
    <script type="text/javascript">
        document.edit = edit = function (id) {
            window.parent.document["<%= function_edit_name %>"](id);
        }
        document.tambah = tambah = function () {
            window.parent.document["<%= function_add_name %>"]();
        }

        document.refresh = function () { theForm.submit(); }
    </script>
</asp:Content>

