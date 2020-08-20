<%@page import="member.MemberDAO"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String contextPath = request.getContextPath();
	request.setCharacterEncoding("UTF-8");
%>

<jsp:useBean id="memberBean" class="member.MemberBean" />
<jsp:setProperty property="*" name="memberBean" />

<%
	MemberDAO memberDAO = new MemberDAO();
	int result = memberDAO.updateMember(memberBean);

	if (result == 1) {
		String name = memberBean.getName();
		session.setAttribute("name", name);
%>
	<script>
		alert("회원정보가 수정되었습니다.");
		location.href = "<%=contextPath%>/includes/index.jsp";
	</script>
<%
	} else if (result == -1) {
%>
	<script>
		alert("비밀번호가 일치하지 않습니다.");
		history.back();
	</script>
<%
	}
%>