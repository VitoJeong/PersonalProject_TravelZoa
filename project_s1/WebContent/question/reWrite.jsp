<%@page import="java.sql.Timestamp"%>
<%@page import="java.text.SimpleDateFormat"%>
<%@page import="java.util.List"%>
<%@page import="board.BoardBean"%>
<%@page import="board.BoardDAO"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
</head>
<%


	// 글 수정을 위한 글 상제보기 화면
	String pageNum = request.getParameter("pageNum");
	// 세션값 가져오기
	String id = (String)session.getAttribute("id");

	// 세션값이 존재하지 않으면 login.jsp로 가서 로그인하고 오세요.
	if(id==null){
		response.sendRedirect("../member/login.jsp");
	}
	
	// content.jsp에서 글수정버튼을 클릭했을때 전달받는 num, pageNum, request영역에서 꺼내오기	
	request.setCharacterEncoding("UTF-8");
	int num = Integer.parseInt(request.getParameter("num"));
	int re_ref = Integer.parseInt(request.getParameter("re_ref")); // 글의 그룹번호
	int re_lev = Integer.parseInt(request.getParameter("re_lev")); // 글의 들여쓰기 값
	int re_seq = Integer.parseInt(request.getParameter("re_seq")); // 글의 순서 값

%>


<body>
<div id="wrap">
<!-- 헤더들어가는 곳 -->
<jsp:include page="../includes/header.jsp"/>
<article>
	<h1 class="boardName">질문 답변작성</h1>
	
<%--아래 디자인 화면에서 답글 내용을 입력후 reWritePro.jsp로 요청 --%>
<form action="reWritePro.jsp" method="post">

	<%-- 수정할 글번호 전달 --%>
	<input type="hidden" name="num" value="<%=num%>">
	<input type="hidden" name="re_ref" value="<%=re_ref%>">
	<input type="hidden" name="re_lev" value="<%=re_lev%>">
	<input type="hidden" name="re_seq" value="<%=re_seq%>">
	
	<table id="notice">
		<tr>
		 <td class="tID">작성자명</td>
		 <td><input type="text" name="id" value="<%=id%>" readonly> </td>
		</tr>
		<tr>
		 <td class="tID">비밀번호</td>
		 <td><input type="password" name="passwd"> </td>
		</tr>
		<tr>
		 <td class="tID">제목</td>
		 <td><input type="text" name="title" value="[답글]"> </td>
		</tr>
		<tr>
		 <td class="tID">내용</td>
		 <td><textarea name="content" id="tContent" rows="13" cols="40"></textarea>
		 </td>
		</tr>
	</table>
	
	<div id="table_search">
		<input type="submit" value="답글작성" class="btn">
		<input type="reset" value="다시작성" class="btn">
		<input type="button" value="목록보기" class="btn" onclick="location.href='board.jsp?pageNum=<%=pageNum%>'">
	</div>
	</form>
	<div class="clear"></div>
	<div id="page_control"></div>
</article>
<!-- 게시판 -->
<!-- 본문들어가는 곳 -->
<div class="clear"></div>
<!-- 푸터들어가는 곳 -->
<jsp:include page="../includes/footer.jsp"/>
<!-- 푸터들어가는 곳 -->
</div>
</body>
</html>