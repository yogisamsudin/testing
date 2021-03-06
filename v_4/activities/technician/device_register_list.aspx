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
        SelectCommand="select device_register_id, sn,device,device_type,part_sts, case when part_sts=1 then 'checked' else '' end status from v_tec_device_register where sn like @sn">
        <SelectParameters>
            <asp:QueryStringParameter Name="sn" QueryStringField="sn" DefaultValue=" "/>            
        </SelectParameters>
    </asp:SqlDataSource>

    <asp:GridView runat="server" ID="gvdata" DataSourceID="sdsdata" 
        AllowPaging="True" AllowSorting="True" AutoGenerateColumns="False" 
        CellSpacing="1" CssClass="gridViewFrame" GridLines="None" PagerSettings-PageButtonCount="10">
        <Columns>
            <asp:TemplateField HeaderStyle-Width="25px">
                <ItemTemplate>
                    <div class="edit" title="edit" onclick="edit('<%# Eval("device_register_id") %>');"></div>
                </ItemTemplate>
                <HeaderTemplate>
                    <div class="tambah" title="tambah" onclick="tambah()"></div>
                </HeaderTemplate>
            </asp:TemplateField>
            <asp:BoundField DataField="sn" HeaderText="sn" ReadOnly="True" SortExpression="sn" HeaderStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="device" HeaderText="Device" ReadOnly="True" SortExpression="device" HeaderStyle-HorizontalAlign="Left" />
            <asp:BoundField DataField="device_type" HeaderText="Type" ReadOnly="True" SortExpression="device_type" HeaderStyle-HorizontalAlign="Left" />
            <asp:TemplateField HeaderStyle-Width="100px" HeaderText="Part Sts." SortExpression="part_sts" ItemStyle-HorizontalAlign="Center">
                <ItemTemplate>
                    <input type="checkbox" <%# Eval("status") %> disabled="disabled"/>
                </ItemTemplate>
            </asp:TemplateField>
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

