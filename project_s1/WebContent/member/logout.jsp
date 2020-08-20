<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<%
	// session내장ㅇ겍체 메모리에 접근하여
	// session내장객체 메모리에 저장돼있는 값들을 모두 제거
	session.invalidate();

	// index.jsp로 재요청(포워딩)
// 	response.sendRedirect("../index.jsp");


%>
	
	<script>
		alert("로그아웃!");
		// 자바스크립트의 재요청(포워딩)
		location.href="../includes/index.jsp";
		// location.href("../index.jsp");
	</script>












