<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<link href="../css/board.css" rel="stylesheet" type="text/css">
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
	<h1 class="boardName">갤러리 업로드</h1>
	<%-- 새글 정보를 입력한 후 writePro.jsp로 글쓰기 요청을 함 --%>
	<form action="writePro.jsp" method="post" enctype="multipart/form-data" onsubmit="return check(boardFile.value)">
		<table id="notice">
			<tr>
				<td class="twriter">ID</td>
				<td><input type="text" name="id" value="<%=id%>" readonly/></td>
			</tr>
			<tr>
				<td class="twriter">글제목</td>
				<td><input type="text" name="title" required /></td>
			</tr>
			
			<%-- 이미지 첨부 --%>
			<tr>
				<td class="twriter">이미지 첨부</td>
					<td>
						<div class="custom-file">
							<input class="custom-file-input" type="file" name="boardFile" 
								id="boardFile" accept="image/*" required/>
						</div>
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
</article>

<jsp:include page="../includes/footer.jsp"/>
<script src="<%=contextPath%>/js/bs-custom-file-input.js"></script>
<script>
	function check(file) {
		
		var reg= /(.*?)\.(jpg|jpeg|png|gif|bmp)$/;
	
		if(file == "" || file ==null){
			
			var msg = "이미지파일이 누락되었습니다. \n파일을 첨부해주세요.";
			alert(msg);
			
			return false;
			
		}else if(file != "" || file != null){
			/* 안쪽 if */
			if(file.match(reg)){
				alert("글 게시물이 등록되었습니다.");
			}else { 
				alert("해당 파일은 이미지 파일이 아닙니다. 이미지파일만 올려주세요.");
				
				return false;
			}
		}
		
	} // check() 끝
	
	
</script>
