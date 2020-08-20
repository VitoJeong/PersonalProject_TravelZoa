<%@page import="member.MemberDAO"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<h1>deletePro.jsp</h1>
<%
	request.setCharacterEncoding("UTF-8");
	String contextPath = request.getContextPath();
	
	String id = request.getParameter("id"); 
	String passwd = request.getParameter("passwd");
	
	MemberDAO memberDAO = new MemberDAO();
	int result = memberDAO.deleteMember(id, passwd);
	
	if(result ==1){ 
		session.setAttribute("id", null);
%>
		<script type="text/javascript">
			alert("회원탈퇴가 완료되었습니다.");
			location.href = "<%=contextPath%>/includes/index.jsp";
		</script>
<%		
	}else if (result == -1){ // check == 0 "비밀번호 틀림" 메세지 창을 띄워주고, delete.jsp로 이동
%>
			
			<script type="text/javascript">
				alert("비밀번호를 틀렸습니다.");
				history.back();
			</script>
<%			
	} else if (result == 0) {
%>
		<script>
			alert("회원이 존재하지 않습니다.");
			location.href = "<%=contextPath%>/includes/index.jsp";
		</script>
<%
	}
%>
