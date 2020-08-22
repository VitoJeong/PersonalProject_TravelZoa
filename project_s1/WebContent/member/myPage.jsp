<%@page import="member.MemberDAO"%>
<%@page import="member.MemberBean"%>
<%@page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
	String pageName = "회원정보수정";
	request.setAttribute("pageName", pageName);

	request.setCharacterEncoding("UTF-8");
	String id = (String) session.getAttribute("id");

	MemberDAO memberDAO = new MemberDAO();
	MemberBean memberBean = memberDAO.getMember(id);

	String passwd = memberBean.getPasswd();
	String name = memberBean.getName();
	String email = memberBean.getEmail();
	String gender = memberBean.getGender();
	String zipcode = (memberBean.getZipcode() != 0) ? Integer.toString(memberBean.getZipcode()) : "";
	String address = (memberBean.getAddress() != null) ? memberBean.getAddress() : "";
	String address2 = (memberBean.getAddress2() != null) ? memberBean.getAddress2() : "";
	String tel = (memberBean.getTel() != null) ? memberBean.getTel() : "";
%>
<link href="../css/default.css" rel="stylesheet" type="text/css">
 <script language="javascript"
	src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js">
 </script>
 	
		
<body>
<div id="wrap">
<!-- 헤더들어가는 곳 -->
<jsp:include page="../includes/header.jsp"/>
<!-- 헤더들어가는 곳 -->

<!-- 본문들어가는 곳 -->
<!-- 본문내용 -->
<article>
	<h1>회원정보 수정</h1>
	
	<%-- 회원가입을 위해 아래의 디자인에서 가입할 회원정보를 입력받고 회원가입버튼을 클릭했을때
		 joinPro.jsp서버페이지로 회원가입 요청을한다.
	 --%>
	 
	<form  action="modify.jsp" id="modify" method="post" name="fr" >
		<fieldset>
			<legend>Basic Info</legend>
			<label>User ID</label>
			<span><%=id%></span><br>
			
			<label>Name</label>
			<span><%=name%></span><br>
			<label>E-Mail</label>
			<span><%=email%></span><br>
			<label>Gender</label>
			<span><%=gender%></span>
		</fieldset>
		
		<fieldset>
			<legend>Optional</legend>
			<label class="address">Zip Code</label>
			<!-- <input type="text" name="address"><br> -->
			<span><%=zipcode%></span><br>
			<label class="address">Address</label>
			<span><%=address%></span><br>
			<label class="address">Detail Address</label>
			<span><%=address2%></span><br>
			<label>Phone Number</label>
			<span><%=tel%></span><br>
		</fieldset>
		<div class="clear"></div>
		<div id="buttons">
			<input type="submit" value="정보수정" class="submit">
			<input type="button" value="회원탈퇴" id="delete" onclick="location.href='delete.jsp'">
		</div>
	</form>
</article>
<!-- 본문내용 -->
<!-- 본문들어가는 곳 -->

<div class="clear"></div>
<!-- 푸터들어가는 곳 -->
<jsp:include page="../includes/footer.jsp"/>
<!-- 푸터들어가는 곳 -->
</div>
</body>
</html>