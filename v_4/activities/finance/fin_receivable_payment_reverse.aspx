﻿<%@ Page Title="" Language="C#" MasterPageFile="~/page.master" Theme="Page" %>

<script runat="server">
    _test.App a;
    void page_load()
    {
        a = new _test.App(Request);


    }
</script>

<asp:Content ID="Content1" ContentPlaceHolderID="head" Runat="Server">
    <script type="text/javascript" src="../../js/Komponen.js"></script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="body" Runat="Server">
    <asp:ScriptManager runat="server" ID="sm">
        <Services>
            <asp:ServiceReference Path="../activities.asmx" />
        </Services>
    </asp:ScriptManager>  

    <table class="formview">
        <tr>
            <th>No.Invoice</th>
            <td><input type="text" id="cari_no" value="%"/></td>
        </tr>
        <tr>
            <th></th>
            <td><div class="buttonCari" onclick="cari.load();">Cari</div></td>
        </tr>
    </table>

    <iframe class="frameList" id="cari_fr"></iframe>

    <div id="mdl_sel" class="modal">
        <fieldset>
            <legend></legend>
            <table class="formview">
                <tr>
                    <th>No.Invoice</th>
                    <td><input type="text" size="50" id="mdl_sel_no"/></td>
                </tr>
                <tr>
                    <th></th>
                    <td><div class="buttonCari" onclick="mdl_sel.load();">Cari</div></td>
                </tr>
            </table>
            <iframe class="frameList" id="mdl_sel_fl" style="width:100%"></iframe>
            <div class="button_panel">
                <input type="button" value="Close" />
            </div>
        </fieldset>
    </div>

    <div id="mdl" class="modal">
        <fieldset>
            <legend></legend>
            <table class="formview">
                <tr>
                    <th>Tanggal</th>
                    <td><label id="mdl_date"></label></td>
                </tr>
                <tr>
                    <th>No.Invoice</th>
                    <td><label id="mdl_no"></label></td>
                </tr>
                <tr>
                    <th>Nama</th>
                    <td><label id="mdl_name"></label></td>
                </tr>
                <tr>
                    <th>Tipe</th>
                    <td><label id="mdl_type"></label></td>
                </tr>
                <tr>
                    <th>Pajak</th>
                    <td><input type="text" id="mdl_pph" disabled="disabled" size="15" style="text-align:right;"/></td>
                </tr>
                <tr>
                    <th>Nilai</th>
                    <td><input type="text" id="mdl_amount" disabled="disabled" size="15" style="text-align:right;"/></td>
                </tr>
                <tr>
                    <th>Jurnal Detail</th>
                    <td>
                        <table id="mdl_tbl" class="gridView">
                            <tr>
                                <th>Tipe COA</th>
                                <th>COA</th>
                                <th>DB/CR</th>
                                <th>Nilai</th>
                            </tr>
                        </table>
                    </td>
                </tr>                
            </table>
            <div class="button_panel">                
                <input type="button" value="Close" />
            </div>
        </fieldset>
    </div>

</asp:Content>
<asp:Content ID="Content3" ContentPlaceHolderID="script" Runat="Server">
    <script type="text/javascript">
        var cari = {
            tb_no: apl.func.get("cari_no"),
            fl: apl.func.get("cari_fr"),

            load: function () {
                var no = cari.tb_no.value;
                cari.fl.src = "fin_receivable_payment_reverse_list.aspx?edit=editan&no=" + no;
            },
            fl_refresh: function () {
                cari.fl.contentWindow.document.refresh();
            }
        }

        var mdl_sel = apl.createModal("mdl_sel",
            {
                tb_no: apl.func.get("mdl_sel_no"),
                fl: apl.func.get("mdl_sel_fl"),
                tambah: function () {
                    mdl_sel.tb_no.value = "";
                    mdl_sel.fl.src = "";
                    mdl_sel.load();
                    mdl_sel.showEdit("Pilih piutang yang akan dibayar");
                },
                load: function () {
                    var no = window.escape(mdl_sel.tb_no.value);
                    mdl_sel.fl.src = "fin_receivable_payment_reverse_ready_list.aspx?no=" + no;
                },
                select: function (id) {
                    if (confirm("Yakin akan di reverse?")) activities.fin_receivable_payment_reverse_add(id, function () { mdl_sel.hide(); cari.fl_refresh(); }, apl.func.showError, "");
                }
            }, undefined, undefined, undefined, "frm_page", "cover_content"
        );

        var mdl = apl.createModal("mdl",
            {
                fin_receivable_payment_reverse_id: 0,
                fin_receivable_payment_id: 0,
                journal_transaction_id: 0,
                lb_date: apl.func.get("mdl_date"),
                lb_no: apl.func.get("mdl_no"),
                lb_name: apl.func.get("mdl_name"),
                lb_type: apl.func.get("mdl_type"),
                tb_pph: apl.func.get("mdl_pph"),
                tb_amount: apl.func.get("mdl_amount"),                
                tbl: apl.createTableWS.init("mdl_tbl",
                    [
                        apl.createTableWS.column("coa_type_name"),
                        apl.createTableWS.column("coa_name"),
                        apl.createTableWS.column("dbcr_id"),
                        apl.createTableWS.column("amount", undefined, undefined, undefined, true)
                    ]
                ),
                tbl_load: function () {
                    activities.acc_journal_transaction_detail_list(mdl.journal_transaction_id, function (arrdata) { mdl.tbl.load(arrdata); }, apl.func.showError, "");
                },
                kosongkan: function () {
                    mdl.fin_receivable_payment_reverse_id = 0;
                    mdl.fin_receivable_payment_id = 0;
                    mdl.journal_transaction_id = 0;
                    mdl.lb_date.innerHTML = "";
                    mdl.lb_no.innerHTML = "";
                    mdl.lb_name.innerHTML = "";
                    mdl.lb_type.innerHTML = "";
                    mdl.tb_pph.value = "";
                    mdl.tb_amount.value = "";
                },
                edit: function (id) {                    
                    apl.func.showSinkMessage("Memuat data...");
                    mdl.fin_receivable_payment_reverse_id = id;

                    activities.fin_receivable_payment_reverse_data(id,
                        function (data) {                            
                            mdl.fin_receivable_payment_id = data.fin_receivable_payment_id;
                            mdl.journal_transaction_id = data.journal_transaction_id;
                            mdl.lb_date.innerHTML = data.reverse_date;
                            mdl.lb_no.innerHTML = data.invoice_no;
                            mdl.lb_name.innerHTML = data.customer_name;                            
                            mdl.tb_pph.value = apl.func.formatNumeric(data.pph_amount);
                            mdl.tb_amount.value = apl.func.formatNumeric(data.receivable_amount);
                            

                            mdl.tbl_load();

                            mdl.showEdit("Reverse Pembayaran Piutang");
                            apl.func.hideSinkMessage();
                        }, apl.func.showError, ""
                    );


                }
            }, undefined,undefined, undefined, "frm_page", "cover_content"
        );

        document.list_add = mdl_sel.tambah;
        document.list_edit = mdl_sel.select;
        document.editan = mdl.edit;
    </script>
</asp:Content>

