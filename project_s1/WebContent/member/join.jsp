<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<link href="../css/default.css" rel="stylesheet" type="text/css">
 <script language="javascript"
	src="https://ajax.aspnetcdn.com/ajax/jQuery/jquery-3.3.1.min.js">
 </script>
 <script src="https://code.jquery.com/jquery-3.3.1.js"></script>
 
 <%
 	String contextPath = request.getContextPath();
 %>
 	<script type="text/javascript">
 		// 아래의 화면에서 가입할 회원의 아이디를 입력하고 아이디 중복체크 버튼을 클릭했을때
 		// 1. 아이디를 이별했는지 판단
 		// 2. DB와 연동하여 입력 한 아이디가 DB에 존재하는지 판단
 		
 		window.onload = function() {
 			IDCheck();
 		}
 		function winopen() {
 		// 아이디를 입력하지 않았다면
 			if(document.fr.id.value == ""){
 				window.alert("아이디를 입력하세요!");
 				// 아이디 입력 <input>태그에 포커스 주기
 				document.fr.id.focus();
 				// 함수를 빠져나가는 return
 				return;
 			}
			// 아이디를 입력했다면
			// 입력한 아이디를 얻어 변수에 저장
			var fid = document.fr.id.value;
			// 새로운 팝업창을 띄우면서 입력한 아이디를 전송함.
			window.open("join_IDcheck.jsp?userid="+fid,"","width=400,height=200");
			
		}
		
 		function disdisabled(){
 			document.fr.id.removeAttribute("disabled");
 		}
 		
 		function checkz() {
 			var genderCheck = false;
 			var getMail = RegExp(/^[A-Za-z0-9_\.\-]+@[A-Za-z0-9\-]+\.[A-Za-z0-9\-]+/);
 			var getCheck = RegExp(/^[a-zA-Z0-9]{4,12}$/);
 			var getName = RegExp(/^[가-힣a-zA-Z]+$/);

 			//아이디 공백 확인
 			if ($("#id").val() == "") {
 				alert("아이디를 입력해주세요.");
 				$("#id").focus();
 				return false;
 			}

 			//아이디의 유효성 검사
 			if (!getCheck.test($("#id").val())) {
 				alert("4-12자 영대,소문자+숫자의 ID를 설정해주세요");
 				$("#id").val("");
 				$("#id").focus();
 				return false;
 			}
 			
 			// 비밀번호 공백 확인
 			if ($("#passwd").val() == "") {
 				alert("비밀번호를 입력해주세요.");
 				$("#passwd").focus();
 				return false;
 			}

 			//비밀번호
 			if (!getCheck.test($("#passwd").val())) {
 				alert("4-12자 영대,소문자+숫자의 비밀번호를 설정해주세요");
 				$("#passwd").val("");
 				$("#passwd").focus();
 				return false;
 			}

 			//아이디랑 비밀번호랑 같은지
 			if ($("#id").val() == ($("#passwd").val())) {
 				alert("비밀번호가 ID와 똑같으면 안됩니다.");
 				$("#passwd").val("");
 				$("#passwd").focus();
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
 				alert("이름을 입력해주세요.");
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
 			
 			//주소 공백 확인
 			if ($("#ample6_postcode").val() == "") {
 				alert("주소를 입력해주세요.");
 				$("#ample6_postcode").focus();
 				return false;
 			}

 			//성별
 			for (var i = 0; i < $(':radio[name="gender"]:checked').length; i++) {
 				if ($("input:radio[name='gender']").is(":checked")==true){
 					genderCheck = true;
 					break;
 				}
 			}

 			if (!genderCheck) {
 				alert("성별을 체크해 주세요.");
 				return false;
 			}


 			return true;
 		}
 		
 		function IDCheck(){
 			
 			var id = document.fr.id.value;
 			
 			if(id.length == 0){
 				document.getElementById("usableID").innerText="ID를 입력해주세요.";
 				document.getElementById("usableID").style.color="red";
 				
 			}	
 			else if(!RegExp(/^[a-zA-Z0-9]{4,12}$/).test($("#id").val())) {
 	 				document.getElementById("usableID").innerText="4-12자 영대,소문자+숫자의 ID를 설정해주세요.";
 	 				document.getElementById("usableID").style.color="red";
 			}
 			else{
				
 	 				var _checkId = '{"id":"'+id+'"}';
 	 	 			
 	 	 			$.ajax({
 	 	 				type : "post",
 	 	 				async : false,
 	 	 				url : "<%=contextPath%>/IDCheckServlet",
 	 	 				data : {checkId : _checkId},
 	 	 				success : function(data, status){
 	 	 				
 	 	 					console.log(data);
 	 	 	 				console.log(status);
 	 	 	 				
 	 	 	 				
 	 	 					if(data == "success"){
 	 	 						
 	 	 						var str = "";
 	 	 						
 	 	 						str += ' 사용가능한 ID입니다.';
 	 	 						$("#usableID").empty();
 	 	 						$("#usableID").append(str);
 	 	 						$("#usableID").css("color","green");
 	 	 						
 	 	 					}else{
 	 							var str = "";
 	 	 						
 	 	 						str += ' 이미 사용중인 ID입니다.';
 	 	 						$("#usableID").empty();
 	 	 						$("#usableID").append(str);
 	 	 						$("#usableID").css("color","red");

 	 	 					}
 	 	 				},
 	 					error : function(){
 	 						alert("통신에러가 발생했습니다.");	
 	 					}	
 	 	 				
 	 	 			})
 	 			
 			}	
 			
 			
 			
 		}
 		
 		function pwCheck(){
				if(!RegExp(/^[a-zA-Z0-9]{4,12}$/).test($("#passwd").val())) {
	 				document.getElementById("chkPw").innerText="4-12자 영대,소문자+숫자의 ID를 설정해주세요.";
	 				document.getElementById("chkPw").style.color="red";
				}else if(RegExp(/^[a-zA-Z0-9]{4,12}$/).test($("#passwd").val())){
					document.getElementById("chkPw").innerText="사용가능한 비밀번호입니다.";
	 				document.getElementById("chkPw").style.color="green";
				}
		}
 		
 		function pwCheck2(){
			if($("#passwd2").val() == $("#passwd").val()) {
 				document.getElementById("chkPw2").innerText="비밀번호가 일치합니다.";
 				document.getElementById("chkPw2").style.color="green";
			}else {
				document.getElementById("chkPw2").innerText="비밀번호가 일치하지않습니다.";
 				document.getElementById("chkPw2").style.color="red";
			}
	}
		</script>
		
</head>
<body>
<div id="wrap">
<!-- 헤더들어가는 곳 -->
<jsp:include page="../includes/header.jsp"/>
<!-- 헤더들어가는 곳 -->

<!-- 본문들어가는 곳 -->
<!-- 본문내용 -->
<article>
	<h1>회원가입</h1>
	
	<%-- 회원가입을 위해 아래의 디자인에서 가입할 회원정보를 입력받고 회원가입버튼을 클릭했을때
		 joinPro.jsp서버페이지로 회원가입 요청을한다.
	 --%>
	 
	<form onsubmit="return checkz();" action="joinPro.jsp" id="dForm" method="post" name="fr" onclick="disdisabled();">
		<fieldset>
			<legend>Basic Info</legend>
			<label>User ID</label>
			<input type="text" id="id" name="id" class="id" maxlength="12" placeholder="ID중복체크를 해주세요." onkeyup="IDCheck()">
			<!-- <input type="button" value="ID중복체크" class="btn" onclick="winopen();"> -->
			<div class="checkResult">
				<span id="usableID"></span>
			</div>
			<label>Password</label>
			<input type="password" id="passwd" name="passwd" onkeyup="pwCheck()" maxlength="12">
			<div class="checkResult">
				<span id="chkPw"></span>
			</div>
			<label>Retype Password</label>
			<input type="password" id="passwd2" onkeyup="pwCheck2()" maxlength="12">
			<div class="checkResult">
				<span id="chkPw2"></span>
			</div>
			<label>Name</label>
			<input type="text" id="name" name="name" maxlength="15"><br>
			<label>E-Mail</label>
			<input type="email" id="email" name="email"><br>
			<label>Gender</label>
			<input type="radio" name="gender" value="남자">남자
			<input type="radio" name="gender" value="여자">여자
		</fieldset>
		
		<fieldset>
			<legend>Optional</legend>
			<label class="address">Zip Code</label>
			<!-- <input type="text" name="address"><br> -->
			<input type="text" name="zipcode" id="sample6_postcode" placeholder="우편번호">
			<input type="button" class="btn" onclick="sample6_execDaumPostcode()" value="우편번호 찾기"><br>
			<label class="address">Address</label>
			<input type="text" name="address" id="sample6_address" placeholder="주소"><br>
			<label class="address">Detail Address</label>
			<input type="text" name="address2" id="sample6_detailAddress" placeholder="상세주소"><br>
			<label>Phone Number</label>
			<input type="text" id="tel" name="tel"><br>
		</fieldset>
		<div class="clear"></div>
		<div id="buttons">
			<input type="submit" value="회원가입" class="submit">
			<input type="reset" value="다시입력" class="cancel">
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