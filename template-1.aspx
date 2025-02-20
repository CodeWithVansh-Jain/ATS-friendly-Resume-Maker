﻿<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="template-1.aspx.cs" Inherits="ATS_friendly_Resume_Maker.WebForm1" %>

<!DOCTYPE html>
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Professional Resume</title>
</head>
<body lang="en-IN" dir="ltr">
    <form id="form1" runat="server">
        <p align="left" style="margin-bottom: 0cm">
            &shy;
        </p>
        <table width="100%" cellpadding="7" cellspacing="0" style="page-break-before: always">
            <col width="256*" />
            <tr>
                <td width="100%" valign="top" style="border-top: none; border-bottom: 1.50pt solid #39a5b7; border-left: none; border-right: none; padding-top: 0cm; padding-bottom: 0.05cm; padding-left: 0cm; padding-right: 0cm">
                    <p align="left" style="orphans: 0; widows: 0">
                        <font color="#2a7b88"><font face="Cambria, serif"><font size="6" style="font-size: 28pt">
                            <asp:Literal ID="litName" runat="server" />
                        </font></font></font>
                    </p>
                </td>
            </tr>
        </table>

        <p align="left" style="margin-top: 0.21cm; margin-bottom: 0.42cm">
            <font color="#000000"><font face="Cambria, serif"><font size="3" style="font-size: 12pt">
                <asp:Literal ID="litContactInfo" runat="server" />
            </font></font></font>
        </p>

        <h1 align="left"><font color="#2a7b88"><font face="Cambria, serif"><font size="4" style="font-size: 14pt">Profile</font></font></font></h1>
        <p align="left" style="margin-bottom: 0cm">
            <font color="#000000"><font face="Cambria, serif"><font size="3" style="font-size: 12pt">
                <asp:Literal ID="litProfile" runat="server" />
            </font></font></font>
        </p>

        <h1 align="left"><font color="#2a7b88"><font face="Cambria, serif"><font size="4" style="font-size: 14pt"><b>Experience</b></font></font></font></h1>

        <div class="Experience">
            <asp:Repeater ID="rptExperience" runat="server">
                <ItemTemplate>
                    <h2 class="western" align="left"><%# Eval("JobTitle") %> | <%# Eval("CompanyName") %> | <%# GetFormattedDuration(Eval("StartMonth"), Eval("StartYear"), Eval("EndMonth"), Eval("EndYear")) %></h2>
                    <ul>
                        <li>
                            <p align="left" style="line-height: 120%; margin-bottom: 0.42cm">
                                <font color="#000000"><font face="Cambria, serif"><font size="3" style="font-size: 12pt">
                                    <%# Eval("Description") %>
                                </font></font></font>
                            </p>
                        </li>
                    </ul>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <h1 align="left"><font color="#2a7b88"><font face="Cambria, serif"><font size="4" style="font-size: 14pt"><b>Education</b></font></font></font></h1>

        <div class="Education">
            <asp:Repeater ID="rptEducation" runat="server">
                <ItemTemplate>
                    <h2 class="western" align="left"><font color="#000000"><font face="Cambria, serif"><font size="3" style="font-size: 12pt">
                        <%# Eval("Degree") %> | <%# GetFormattedEducationDuration(Eval("StartYear"), Eval("EndYear")) %> | <%# Eval("SchoolName") %>, <%# Eval("City") %>
                    </font></font></font></h2>
                </ItemTemplate>
            </asp:Repeater>
        </div>

        <h1 align="left"><font color="#2a7b88"><font face="Cambria, serif"><font size="4" style="font-size: 14pt"><b>Skills & Abilities</b></font></font></font></h1>

        <div class="Skills">
            <asp:Repeater ID="rptSkills" runat="server">
                <ItemTemplate>
                    <table width="100%" cellpadding="0" cellspacing="0">
                        <col width="137*" />
                        <col width="119*" />
                        <tr valign="top">
                            <td width="100%" style="border: none; padding: 0cm">
                                <ul>
                                    <li>
                                        <p align="left" style="orphans: 0; widows: 0; margin-bottom: 0.42cm">
                                            <font color="#000000"><font face="Cambria, serif"><font size="3" style="font-size: 12pt">
                                                <%# Eval("SkillsText") %>
                                            </font></font></font>
                                        </p>
                                    </li>
                                </ul>
                            </td>
                        </tr>
                    </table>
                </ItemTemplate>
            </asp:Repeater>
        </div>
    </form>
</body>
</html>
