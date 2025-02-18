<%@ Page Language="C#" AutoEventWireup="true" EnableViewState="true" EnableEventValidation="false"
    CodeBehind="form.aspx.cs" Inherits="ATS_friendly_Resume_Maker.Resume_Maker" %>

    <!DOCTYPE html>
    <html xmlns="http://www.w3.org/1999/xhtml">

    <head runat="server">
        <title>ATS Resume Maker</title>
        <!-- Bootstrap CSS -->
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    </head>

    <body>
        <form id="form1" runat="server">

            <div class="container mt-5">
                <h1 class="text-center">ATS-Friendly Resume Maker</h1>

                <asp:ScriptManager ID="ScriptManager1" runat="server" />
<!-- Personal Info -->
                <div class="container mt-4">
                    <div class="card">
                        <div class="card-header bg-primary text-white">
                            <h4 class="mb-0">User Information</h4>
                        </div>
                        <div class="card-body">
                            <div class="mb-3">
                                <label class="form-label">First Name:</label>
                                <asp:TextBox ID="txtFirstName" runat="server" CssClass="form-control"
                                    placeholder="Enter first name"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Last Name:</label>
                                <asp:TextBox ID="txtLastName" runat="server" CssClass="form-control"
                                    placeholder="Enter last name"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Job Title:</label>
                                <asp:TextBox ID="txtJobTitle" runat="server" CssClass="form-control"
                                    placeholder="Enter job title"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Email:</label>
                                <asp:TextBox ID="txtEmail" runat="server" CssClass="form-control"
                                    placeholder="Enter email" TextMode="Email"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Phone Number:</label>
                                <asp:TextBox ID="txtPhone" runat="server" CssClass="form-control"
                                    placeholder="Enter phone number" TextMode="Phone"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">Country:</label>
                                <asp:TextBox ID="txtCountry" runat="server" CssClass="form-control"
                                    placeholder="Enter country"></asp:TextBox>
                            </div>

                            <div class="mb-3">
                                <label class="form-label">City:</label>
                                <asp:TextBox ID="txtCity" runat="server" CssClass="form-control"
                                    placeholder="Enter city"></asp:TextBox>
                            </div>

                            <asp:Button ID="btnSubmit" runat="server" Text="Submit" CssClass="btn btn-primary"
                                OnClick="btnSubmit_Click" />
                        </div>
                    </div>
                </div>

                <asp:UpdatePanel ID="UpdatePanel1" runat="server" UpdateMode="Conditional">
                    <ContentTemplate>
                        <!-- Action Buttons -->
                        <div class="d-flex flex-wrap gap-2 justify-content-center mb-3">
                            <asp:Button ID="btnAddEmployment" runat="server" Text="Add Employment"
                                OnClick="btnAddEmployment_Click" CssClass="btn btn-primary" />
                            <asp:Button ID="btnAddEducation" runat="server" Text="Add Education"
                                OnClick="btnAddEducation_Click" CssClass="btn btn-primary" />
                            <asp:Button ID="btnAddWebsite" runat="server" Text="Add Website"
                                OnClick="btnAddWebsite_Click" CssClass="btn btn-primary" />
                            <asp:Button ID="btnAddSkills" runat="server" Text="Add Skills" OnClick="btnAddSkills_Click"
                                CssClass="btn btn-primary" />
                        </div>

                        <asp:Panel ID="pnlForms" runat="server">

                            <!-- 🏢 Employment Section -->
                            <asp:Repeater ID="rptEmployment" runat="server" OnItemCommand="rptEmployment_ItemCommand">
                                <ItemTemplate>
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h3 class="card-title">Employment Information</h3>
                                            <div class="mb-2">
                                                <label class="form-label">Company Name:</label>
                                                <asp:TextBox ID="txtCompany" runat="server" CssClass="form-control"
                                                    placeholder="Enter company name"></asp:TextBox>
                                            </div>
                                            <div class="mb-2">
                                                <label class="form-label">Job Title:</label>
                                                <asp:TextBox ID="txtTitle" runat="server" CssClass="form-control"
                                                    placeholder="Enter job title"></asp:TextBox>
                                            </div>
                                            <asp:Button ID="btnRemove" runat="server" Text="Remove"
                                                CssClass="btn btn-danger mt-2" CommandName="Remove"
                                                CommandArgument="<%# Container.ItemIndex %>" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- 🎓 Education Section -->
                            <asp:Repeater ID="rptEducation" runat="server" OnItemCommand="rptEducation_ItemCommand">
                                <ItemTemplate>
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h3 class="card-title">Education</h3>
                                            <div class="mb-2">
                                                <label class="form-label">School/University:</label>
                                                <asp:TextBox ID="txtSchool" runat="server" CssClass="form-control"
                                                    placeholder="Enter school/university name"></asp:TextBox>
                                            </div>
                                            <div class="mb-2">
                                                <label class="form-label">Degree:</label>
                                                <asp:TextBox ID="txtDegree" runat="server" CssClass="form-control"
                                                    placeholder="Enter degree"></asp:TextBox>
                                            </div>
                                            <asp:Button ID="btnRemove" runat="server" Text="Remove"
                                                CssClass="btn btn-danger mt-2" CommandName="Remove"
                                                CommandArgument="<%# Container.ItemIndex %>" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- 🌐 Website Section -->
                            <asp:Repeater ID="rptWebsite" runat="server" OnItemCommand="rptWebsite_ItemCommand">
                                <ItemTemplate>
                                    <div class="card mb-3">
                                        <div class="card-body">
                                            <h3 class="card-title">Website</h3>
                                            <div class="mb-2">
                                                <label class="form-label">Website Name:</label>
                                                <asp:TextBox ID="txtWebsite" runat="server" CssClass="form-control"
                                                    placeholder="Enter website name"></asp:TextBox>
                                            </div>
                                            <div class="mb-2">
                                                <label class="form-label">URL:</label>
                                                <asp:TextBox ID="txtUrl" runat="server" CssClass="form-control"
                                                    placeholder="Enter website URL"></asp:TextBox>
                                            </div>
                                            <asp:Button ID="btnRemove" runat="server" Text="Remove"
                                                CssClass="btn btn-danger mt-2" CommandName="Remove"
                                                CommandArgument="<%# Container.ItemIndex %>" />
                                        </div>
                                    </div>
                                </ItemTemplate>
                            </asp:Repeater>

                            <!-- 🛠️ Skills Section -->
                            <!-- <asp:Repeater ID="rptSkills" runat="server" OnItemCommand="rptSkills_ItemCommand">
                            <ItemTemplate>
                                <div class="card mb-3">
                                    <div class="card-body">
                                        <h3 class="card-title">Skills</h3>
                                        <div class="mb-2">
                                            <label class="form-label">Skill:</label>
                                     …ntrol" placeholder="Enter skill"></asp:TextBox>
                                        </div>
                                        <asp:Button ID="btnRemove" runat="server" Text="Remove" CssClass="btn btn-danger mt-2"
                                            CommandName="Remove" CommandArgument="<%# Container.ItemIndex %>" />
                                    </div>
                                </div>
                            </ItemTemplate>
                        </asp:Repeater> -->

                        </asp:Panel>
                        <!-- 🛠️ Skills Section (Single Input) -->
                        <div class="card mb-3">
                            <div class="card-body">
                                <h3 class="card-title">Skills</h3>
                                <div class="mb-2">
                                    <label class="form-label">Enter Skills (Comma Separated):</label>
                                    <asp:TextBox ID="txtSkills" runat="server" CssClass="form-control"
                                        placeholder="E.g., Python, Java, AWS, Docker"></asp:TextBox>
                                </div>
                            </div>
                        </div>


                        <!-- Submit Button -->
                        <div class="text-center mt-3">
                            <asp:Button ID="btnSubmit" runat="server" Text="Generate Resume" OnClick="btnSubmit_Click"
                                CssClass="btn btn-success btn-lg" />
                        </div>

                    </ContentTemplate>
                </asp:UpdatePanel>
            </div>

            <!-- Bootstrap JS (for optional features like dropdowns, modals) -->
            <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
        </form>
    </body>

    </html>