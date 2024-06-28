<%@ Page Title="" Language="C#" MasterPageFile="~/User/User.Master" AutoEventWireup="true" CodeBehind="About.aspx.cs" Inherits="Cloud_Restaurant.User.About" %>
<asp:Content ID="Content1" ContentPlaceHolderID="head" runat="server">
</asp:Content>
<asp:Content ID="Content2" ContentPlaceHolderID="ContentPlaceHolder1" runat="server">
      <!-- about section -->

  <section class="about_section layout_padding">
    <div class="container  ">

      <div class="row">
        <div class="col-md-6 ">
          <div class="img-box">
            <img src="../TemplateFiles/images/user-logo.png" alt="">
          </div>
        </div>
        <div class="col-md-6">
          <div class="detail-box">
            <div class="heading_container">
              <h2>
                We Are Cloud Restaurant
              </h2>
            </div>
            <p>
              Welcome to Cloud Restaurant!At Cloud Restaurant, we bring delicious meals straight to your 
                doorstep with just a few clicks.Explore our diverse menu featuring a variety of cuisines,
                place your order effortlessly,and enjoy fast and reliable delivery. Whether you're craving 
                a quick bite or a gourmet inner, we've got something for everyone. Our commitment to quality 
                and customer satisfaction ensures that every meal you receive is fresh, tasty, and prepared 
                with care.Join us and experience the convenience of online food ordering at its best!
            </p>
           
          </div>
        </div>
      </div>
    </div>
  </section>

  <!-- end about section -->
</asp:Content>
