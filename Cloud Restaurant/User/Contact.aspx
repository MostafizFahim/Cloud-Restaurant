<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="Contact.aspx.cs" Inherits="Cloud_Restaurant.User.Contact" %>

<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
    <script>
        window.onload = function () {
            var seconds = 50;
            setTimeout(function () {
                document.getElementById("<%=lblMsg.ClientID %>").style.display = "none";
        }, seconds + 1000);
        };

    </script>
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
    <!-- book section -->
    <section class="book_section layout_padding" style="background-image: url('../Images/feedback-bg-1.jpg'); background-repeat: no-repeat; background-size: cover; background-attachment: fixed; background-position: center;">
        <div class="container">
            <div class="heading_container">
                <div class="align-self-end">
                    <asp:Label runat="server" ID="lblMsg"></asp:Label>
                </div>
                <h2>Send Your Query
                </h2>
            </div>
            <div class="row">
                <div class="col-md-8">
                    <div class="form_container">

                        <div>
                            <asp:RequiredFieldValidator ID="rfvName" runat="server" ErrorMessage="Name is required" ControlToValidate="txtName"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtName" runat="server" CssClass="form-control" placeholder="Your Name"></asp:TextBox>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvEmail" runat="server" ErrorMessage="Email is required" ControlToValidate="txtEmail"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control" placeholder="Your Email"></asp:TextBox>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvSubject" runat="server" ErrorMessage="Subject is required" ControlToValidate="txtSubject"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtSubject" runat="server" CssClass="form-control" placeholder="Subject"></asp:TextBox>
                        </div>
                        <div>
                            <asp:RequiredFieldValidator ID="rfvMassage" runat="server" ErrorMessage="Massage is required" ControlToValidate="txtMassage"
                                ForeColor="Red" Display="Dynamic" SetFocusOnError="true"></asp:RequiredFieldValidator>
                            <asp:TextBox ID="txtMassage" runat="server" CssClass="form-control" placeholder="Enter your Query or Feedback!"></asp:TextBox>
                        </div>

                        <div class="btn_box">
                            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-warning rouded-pill pl-4 pr-4 text-white"
                                OnClick="btnSubmit_Click" />
                        </div>

                    </div>
                </div>
                <%-- <div class="col-md-6">
          <div class="map_container ">
            <div id="googleMap"></div>
          </div>
        </div>--%>
            </div>
        </div>
    </section>
    <!-- end book section -->


</asp:Content>
