<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
</script>
<%
	// 세션영역에 저장된 값 얻어오기
	// 얻어오는 이유 : 글쓰기 화면에 글작성하는 사람의 id를 입력공간에 나타나게 하기위해
	String id = (String)session.getAttribute("id");
	String contextPath = request.getContextPath();

	// 세션영역에 값이 저장되어 있지않으면 login.jsp로 다시 이동
	if(id ==null){
		// 재요청(포워딩)
		response.sendRedirect("../member/login.jsp");
	}

%>
<jsp:include page="../includes/header.jsp"/>

<article>
	<h1 class="boardName">질문 작성</h1>
	<%-- 새글 정보를 입력한 후 writePro.jsp로 글쓰기 요청을 함 --%>
	<form action="writePro.jsp" method="post">
		<table id="notice">
			<tr>
				<td class="twriter">ID</td>
				<td><input type="text" name="id" value="<%=id%>" readonly/></td>
			</tr>
			<tr>
				<td class="twriter">비밀번호</td>
				<td><input type="password" name="passwd" required /></td>
			</tr>
			<tr>
				<td class="twriter">글제목</td>
				<td><input type="text" name="title" required /></td>
			</tr>
			<tr>
				<td class="twriter">글내용</td>
				<td id = "tcontent">
				<textarea name="content" id="content" rows="13" cols="86" ></textarea>
				</td>
			</tr>
		</table>
		<div id="table_search">
			<input type="submit" value="글쓰기" class="btn"/>
			<input type="reset" value="다시작성" class="btn"/>
			<input type="button" value="글목록" class="btn" onclick="location.href='board.jsp'"/>
		</div>
	
	</form>
	<div class="clear"></div>
	<div id="page_control"></div>
</article>

<jsp:include page="../includes/footer.jsp"/>



