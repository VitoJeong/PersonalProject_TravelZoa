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
 	<script type="text/javascript">
 		function disdisabled(){
			document.fr.id.removeAttribute("disabled");
		}
 	
 		function checkz() {
 			var genderCheck = false;
 			var getMail = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
 			var getCheck = RegExp(/^[a-zA-Z0-9]{4,12}$/);
 			var getName = RegExp(/^[가-힣a-zA-Z]+$/);
 			// 비밀번호 공백 확인
 			if ($("#passwd").val() == "") {
 				alert("비밀번호를 입력해주세요.");
 				$("#passwd").focus();
 				return false;
 			}


 			//비밀번호 똑같은지
 			if ($("#passwd").val() != ($("#passwd2").val())) {
 				alert("비밀번호를 틀리셨습니다.");
 				$("#passwd").val("");
 				$("#passwd2").val("");
 				$("#passwd").focus();
 				return false;
 			}
			
 			//이름 공백 확인
 			if ($("#name").val() == "") {
 				alert("이름을 입력해주세요");
 				$("#name").focus();
 				return false;
 			}
 			
 			//이름 유효성
 			if (!getName.test($("#name").val())) {
 				alert("이름을 올바르게 작성해주세요.");
 				$("#name").val("");
 				$("#name").focus();
 				return false;
 			}
 			
 			//이메일 공백 확인
 			if ($("#email").val() == "") {
 				alert("이메일을 입력해주세요.");
 				$("#email").focus();
 				return false;
 			}
 			

 			return true;
 		}
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
	 
	<form onsubmit="return checkz();" action="modifyPro.jsp" id="modify" method="post" name="fr" onclick="disdisabled();">
		<fieldset>
			<legend>Basic Info</legend>
			<label>User ID</label>
			<input type="text" id="id" name="id" class="id" value="<%=id%>"  maxlength="12" readonly><br>
			<label>Password</label>
			<input type="password" id="passwd" name="passwd"  maxlength="12" autofocus><br>
			<label>Retype Password</label>
			<input type="password" id="passwd2" maxlength="12"><br>
			<label>Name</label>
			<input type="text" id="name" name="name" value="<%=name%>" maxlength="5"><br>
			<label>E-Mail</label>
			<input type="email" id="email" name="email" value="<%=email%>" readonly><br>
			<label>Gender</label>
			<span><%=gender%></span>
		</fieldset>
		
		<fieldset>
			<legend>Optional</legend>
			<label class="address">Zip Code</label>
			<!-- <input type="text" name="address"><br> -->
			<input type="text" name="zipcode" id="sample6_postcode" value="<%=zipcode%>" placeholder="우편번호">
			<input type="button" class="btn" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
			<label class="address">Address</label>
			<input type="text" name="address" id="sample6_address" value="<%=address%>" placeholder="주소"><br>
			<label class="address">Detail Address</label>
			<input type="text" name="address2" id="sample6_detailAddress" value="<%=address2%>" placeholder="상세주소"><br>
			<label>Phone Number</label>
			<input type="text" id="tel" name="tel" value="<%=tel%>" maxlength="13" placeholder="010-0000-0000"><br>
		</fieldset>
		<div class="clear"></div>
		<div id="buttons">
			<input type="submit" value="정보수정" class="submit">
			<input type="reset" value="다시입력" class="cancel">
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
<script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
<script>
    function sample6_execDaumPostcode() {
        new daum.Postcode({
            oncomplete: function(data) {
                // 팝업에서 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

                // 각 주소의 노출 규칙에 따라 주소를 조합한다.
                // 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                //사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
                if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                    addr = data.roadAddress;
                } else { // 사용자가 지번 주소를 선택했을 경우(J)
                    addr = data.jibunAddress;
                }

                // 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
                if(data.userSelectedType === 'R'){
                    // 법정동명이 있을 경우 추가한다. (법정리는 제외)
                    // 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
                    if(data.bname !== '' && /[동|로|가]$/g.test(data.bname)){
                        extraAddr += data.bname;
                    }
                    // 건물명이 있고, 공동주택일 경우 추가한다.
                    if(data.buildingName !== '' && data.apartment === 'Y'){
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    // 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
                    if(extraAddr !== ''){
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    // 조합된 참고항목을 해당 필드에 넣는다.
                    document.getElementById("sample6_address").value += extraAddr;
                }

                // 우편번호와 주소 정보를 해당 필드에 넣는다.
                document.getElementById('sample6_postcode').value = data.zonecode;
                document.getElementById("sample6_address").value = addr;
                // 커서를 상세주소 필드로 이동한다.
                document.getElementById("sample6_detailAddress").focus();
            }
        }).open();
    }
</script>
</body>
</html>