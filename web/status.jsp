<%@ page import="java.sql.*;" %>
<%@ page import="java.util.*;"%>
<%@ page import="java.text.*;" %>
<html>
    <head>
        <script type="text/javascript">
            function comment(id)
	{
        
            var str=document.getElementById(id).value;
      
            var xmlhttp=null;
            try
		  {
                     // Firefox, Opera 8.0+, Safari
                     xmlhttp=new XMLHttpRequest();
		  }
		catch (e)
		  {
                     // Internet Explorer
		  try
		    {
                          xmlhttp=new ActiveXObject("Msxml2.XMLHTTP");
		    }
		  catch (e)
		    {
                          xmlhttp=new ActiveXObject("Microsoft.XMLHTTP");
		    }
		  }
	
         if (xmlhttp==null)
	 {
            alert ("Your browser does not support AJAX!");
            return;
	 } 
         
         xmlhttp.onreadystatechange=function()
         {
            if (xmlhttp.readyState==4 && xmlhttp.status==200)
            {
                document.getElementById("comments").innerHTML=xmlhttp.responseText;
            }
        }
        xmlhttp.open("GET","commentajax.jsp?c="+str+"&id="+id,true);
        xmlhttp.send();

        }

            
        </script>
    </head>
    <body>
        <%
        
        if(session.getAttribute("Username")==null)
            {
response.sendRedirect("firstPage.jsp"); // GO TO LOGIN PAGE
            }

                java.util.Date dt1= new java.util.Date();
        String DATE_FORMAT = "yyyy-MM-dd-H-m-s";
        SimpleDateFormat sdf=new SimpleDateFormat(DATE_FORMAT);
        String dt=sdf.format(dt1);

        Connection con=null;
        Statement stmt=null;
        Statement stmt1,stmt3,stmt8=null;
        Statement stmt2=null;
        ResultSet rs,rs1=null;
        ResultSet rs2,rs8=null;
        String status=request.getParameter("status");
        session.setAttribute("status",status);
        String user_id=(String)session.getAttribute("loginName");
        session.setAttribute("user_id",user_id);
        Class.forName("com.mysql.jdbc.Driver");
        con=DriverManager.getConnection("jdbc:mysql://localhost:3306/praful","root","");
        stmt=con.createStatement();        
        stmt1=con.createStatement(); 
        stmt8=con.createStatement(); 
        stmt2=con.createStatement(); 
        String fname=null;
        String lname=null;
        String from=null;
        rs=stmt.executeQuery("SELECT * FROM status_table ORDER BY id DESC");
        int id=0;;
        if(rs!=null)
        {
            while(rs.next())
            {
               id=rs.getInt("id");
               break;
            }
        }
        id+=1;
        
        stmt.execute("INSERT INTO status_table (`user_id`,`status`,`Date`,`id`) VALUE('"+user_id+"','"+status+"','"+dt+"','"+id+"')");
        rs1=stmt1.executeQuery("SELECT * FROM status_table WHERE user_id='"+user_id+"' AND status='"+status+"'");
        rs2=stmt2.executeQuery("SELECT * FROM login_table WHERE email_id='"+user_id+"'");
            
        if (rs2!=null)
        {
            while(rs2.next())
            {
                fname=rs2.getString("first_name");
                lname=rs2.getString("last_name");
                if(rs1!=null)
                    {
                        while(rs1.next())
                        {
                            out.println("<br><b  style=color:#00008B;>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;<a href=unique_profile_page.jsp?search="+user_id+" > "+fname+" "+lname+"<br><img src=photo_view.jsp?name="+user_id+" height=50 width=50/></a></b>");
                            out.println(rs1.getString("status"));
                            id =rs1.getInt("id");
                            out.println("<b><br><br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Comments</b><br>");
                                                    
                                                    
                        %>
                        <div id=comments></div>
                        <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                        <textarea rows="1" cols="25" id="<%=id%>"></textarea>
                        <%
                            out.println("<input type=button value=Post id="+id+" onclick=comment(this.id) ><br><br><hr>");
                            break;
                         }
                      }            
              }   
        }
                        %>
    </body>
</html>