<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	request.setCharacterEncoding("UTF-8");

	String id = request.getParameter("id");
	String passwd = request.getParameter("passwd");
	
	MemberDAO memberdao = new MemberDAO();
	
		
				
	int check = memberdao.userCheck(id, passwd);

	if(check ==1){
		session.setAttribute("id", id);
		
		response.sendRedirect("../includes/index.jsp");
		
	}else if(check == 0){
		
%>		
		<script type="text/javascript">
			window.alert("비밀번호를 틀리셨습니다.");
			history.back();
		</script>	
<%		
	}else{ // check == -1 아이디 틀림
%>
		<script type="text/javascript">
			window.alert("존재하지 않는 아이디입니다!");
			history.go(-1);
		</script>		
<%		
	}
	

%>    
    
    
    
    