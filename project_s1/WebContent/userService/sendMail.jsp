<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<link href="../css/default.css" rel="stylesheet" type="text/css">
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Insert title here</title>
</head>
<body>
<%
	// 세션영역에 저장된 값 얻어오기
	// 얻어오는 이유 : 글쓰기 화면에 글작성하는 사람의 id를 입력공간에 나타나게 하기위해
	String id = (String)session.getAttribute("id");

	// 세션영역에 값이 저장되어 있지않으면 login.jsp로 다시 이동
	if(id ==null){
		// 재요청(포워딩)
		response.sendRedirect("../member/login.jsp");
	}

%>
<jsp:include page="../includes/header.jsp"/>

<article>
<h1>이메일 보내기</h1>
<form name="a" action="sendMailPro.jsp" method="post" id="dForm">
	<fieldset id="fieldsetMail">
	<legend>내용 작성</legend>
	<label>이름</label><input type="text" name="name" required><br>
	<label>연락처</label><input type="text" name="number" required><br>
	<label>이메일</label><input type="text" name="email" required><br>
	<label>제목</label><input type="text" name="subject" required><br>
	<label for="content" id="labelContent">내용</label><textarea id="content" name="content" rows="13" cols="60" required ></textarea><br>
	</fieldset>
	
	<div id="buttons">
	<input type="reset" value="다시작성" class="btn"/>
	<input type="button" value="메일발송" onclick="check()">
	</div>
	<input type="hidden" name="to" value="jeongvito@gmail.com"> 
	<input type="hidden" name="from" value="vitojeong@naver.com">
	
</form>
</article>

<jsp:include page="../includes/footer.jsp"/>
<script> 
 function check() {
    document.a.submit();
}
</script>




</body>
</html>