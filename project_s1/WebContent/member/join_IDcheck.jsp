<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
    
<script type="text/javascript"> 

	function result() {
		opener.document.fr.id.value = document.getElementById("finallyID").value;
		
		window.close();
	}

</script> 
<%
	request.setCharacterEncoding("utf-8");

	String id = request.getParameter("userid");
	
	MemberDAO mdao = new MemberDAO();
	
	int check = mdao.idCheck(id);
	
	if(check ==1){
		out.println("사용중인 아이디 입니다.");	
	}else{
		out.println("사용가능한 아이디 입니다.");
%>
		<%-- 사용가능한 ID이면  ID출력--%>
		<button type="button" onclick="result();">사용함</button>
	
<%	
	}

%>
	
	<form action="join_IDcheck.jsp">
	
	<%-- input에 출력 --%>
	아이디 : <input type="text" name="userid" value="<%= id %>" id = "finallyID"/>
			<input type="submit" value="중복확인"/>
			
	</form>



