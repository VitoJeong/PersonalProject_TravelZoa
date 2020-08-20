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
	
	// 세션값 가져오기
	String id = (String)session.getAttribute("id");

	// 세션값이 존재하지 않으면 login.jsp로 가서 로그인하고 오세요.
	if(id==null){
		response.sendRedirect("../member/login.jsp");
	}
	
// content.jsp에서 글수정버튼을 클릭했을때 전달받는 num, pageNum, request영역에서 꺼내오기	
request.setCharacterEncoding("UTF-8");
int num = Integer.parseInt(request.getParameter("num"));
String pageNum = request.getParameter("pageNum");

//글을 수정하기 전에 하나의 글 정보를 검색해서 가져오기
BoardDAO dao = new BoardDAO();
BoardBean boardBean = dao.getBoard(num);

// 검색한 하나의 글 정보를 얻기
int DBnum = boardBean.getNum();
String DBId = boardBean.getId();
String DBTitle = boardBean.getTitle();
String DBContent = "";

if(boardBean.getContent() != null){
	
	DBContent = boardBean.getContent().replace("\r\n","<br>");
}



%>


<body>
<div id="wrap">
<jsp:include page="../includes/header.jsp"/>


<article>
	<h1 class="boardName">게시글 수정</h1>
	
<%-- 수정할 글 내용을 다시 입력 후 수정버튼을 클릭했을때 updatePro.jsp로 수정 요청 --%>	
<form action="updatePro.jsp?pageNum=<%=pageNum%>" method="post">
	<%-- 수정할 글번호 전달 --%>
	<input type="hidden" name="num" value="<%=num%>">
	
	<table id="notice">
		<tr>
		 <td class="tID">ID</td>
		 <td><input type="text" name="id" value="<%=DBId%>" readonly> </td>
		</tr>
		<tr>
		 <td class="tID">비밀번호</td>
		 <td><input type="password" name="passwd" required> </td>
		</tr>
		<tr>
		 <td class="tID">제목</td>
		 <td><input type="text" name="title" value="<%=DBTitle%>"> </td>
		</tr>
		<tr>
		 <td class="tID">내용</td>
		 <td><textarea name="content" id="tContent" rows="13" cols="40"><%=DBContent%></textarea>
		 </td>
		</tr>
	</table>
	
	<div id="table_search">
		<input type="submit" value="글수정" class="btn">
		<input type="reset" value="다시작성" class="btn">
		<input type="button" value="목록보기" class="btn" onclick="location.href=board.jsp">
	</div>
	</form>
	<div class="clear"></div>
	<div id="page_control"></div>
</article>
<div class="clear"></div>
<jsp:include page="../includes/footer.jsp"/>
</div>
</body>
</html>