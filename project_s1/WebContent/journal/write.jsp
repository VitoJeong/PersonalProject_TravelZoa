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
	<h1 class="boardName">여행후기 작성</h1>
	<%-- 새글 정보를 입력한 후 writePro.jsp로 글쓰기 요청을 함 --%>
	<form action="writePro.jsp" method="post" enctype="multipart/form-data">
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
				<td id = "tContent"><textarea name="content" rows="13" cols="86" required ></textarea></td>
			</tr>
			
			<%-- 이미지 첨부 --%>
			<tr>
				<td class="twriter">이미지 첨부1</td>
					<td>
						<div class="custom-file">
							<input class="custom-file-input" type="file" name="boardFile1" 
								id="boardFile1" accept="image/*" onchange="chk_file_type(this)"/>
							<div class="image_container"></div>
						</div>
					</td>
			</tr>
			<tr>
				<td class="twriter">이미지 첨부2</td>
				<td>
					<div class="custom-file">
						<input class="custom-file-input" type="file" name="boardFile2" 
							id="boardFile2" accept="image/*" onchange="chk_file_type(this)"/>
						<div class="image_container"></div>
					</div>
				</td>
			</tr>
			<tr>
				<td class="twriter">이미지 첨부3</td>
				<td>
					<div class="custom-file">
						<input class="custom-file-input" type="file" name="boardFile3" 
							id="boardFile3" accept="image/*" onchange="chk_file_type(this)"/>
						<div class="image_container"></div>
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
function chk_file_type(obj) {
	 var file_kind = obj.value.lastIndexOf('.');
	 var file_name = obj.value.substring(file_kind+1,obj.length);
	 var file_type = file_name.toLowerCase();
	 
	 
	 var check_file_type=['jpg','gif','png','jpeg','bmp'];



	 if(check_file_type.indexOf(file_type)==-1){
	  alert('이미지 파일만 선택할 수 있습니다.');
	  var parent_Obj=obj.parentNode
	  var node=parent_Obj.replaceChild(obj.cloneNode(true),obj);
	  
	  return false;
	 }
	 
	 var reader = new FileReader(); 
		reader.onload = function(event) { 
			var img = document.createElement("img"); 
			img.setAttribute("src", event.target.result); 
			if( obj.parentNode.querySelector(".image_container").hasChildNodes() ){
				var image_container_ele = obj.parentNode.querySelector(".image_container");
				while ( image_container_ele.hasChildNodes() ) { 
					image_container_ele.removeChild( image_container_ele.firstChild ); 
				}
				obj.parentNode.querySelector(".image_container").appendChild(img); 

			}else{
				obj.parentNode.querySelector(".image_container").appendChild(img); 
			}
			
		}; 
		reader.readAsDataURL(event.target.files[0]); 
	}

	
</script>
