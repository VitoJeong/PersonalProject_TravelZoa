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
	// 세션영역에 저장된 값 얻어오기
	// 얻어오는 이유 : 글쓰기 화면에 글작성하는 사람의 id를 입력공간에 나타나게 하기위해
	String id = (String)session.getAttribute("id");

	// 세션영역에 값이 저장되어 있지않으면 login.jsp로 다시 이동
	if(id ==null){
		// 재요청(포워딩)
		response.sendRedirect("../member/login.jsp");
	}
	
	// content.jsp(글상세보기화면)에서 삭제할 글 번호, 삭제할 글이 속해있는 페이지 넘버얻기
	int num = Integer.parseInt(request.getParameter("num"));
	
	String pageNum = request.getParameter("pageNum");

%>
<body>
<div id="wrap">
<jsp:include page="../includes/header.jsp"/>
<!-- 게시판 -->
<article>
	<h1>게시글 삭제</h1>
	<%-- 글을 삭제하기 위해 비밀번호를 입력하여 글삭제 요청을 deletePro.jsp로 요청 --%>
	
	
	<form action="deletePro.jsp?pageNum=<%=pageNum%>" method="post" onsubmit="return deleteSubmit()">
		
		<input type="hidden" name="num" value="<%=num %>">
		
		<table id="notice">
			<tr>
			 	<td>비밀번호</td>
			 	<td><input type="password" name="passwd"></td>
			</tr>
		</table>
		<div id="table_search">
			<input type="submit" value="글삭제" class="btn" >
			<input type="reset" value="다시입력" class="btn">
			<input type="button" value="글목록요청" 
			class="btn" onclick="location.href='board.jsp?pageNum=<%=pageNum%>'">
		</div>
	</form>

	<div class="clear"></div>
	<div id="page_control"></div>
</article>
<div class="clear"></div>
<jsp:include page="../includes/footer.jsp"/>
</div>
	<script>
		function deleteSubmit() {
			return confirm("정말로 삭제하시겠습니까?");
		}
	</script>
</body>
</html>