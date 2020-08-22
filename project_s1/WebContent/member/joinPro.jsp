<%@page import="member.MemberDAO"%>
<%@page import="member.MemberBean"%>
<%@ page language="java" contentType="text/html; charset=utf-8"
    pageEncoding="utf-8"%>

<%
	// 1. join.jsp에서 입력한 회원내용중에서 한글이 존재하면
	// 	request객체 메모리에서 꺼내올때 한글이 깨지므로
	// 	인코딩 방식을 UTF-8로 설정하여 요청갑을 얻을때 한글이 깨지지 않도록 방지
	request.setCharacterEncoding("utf-8");
	
	// 2. 요청한 값 얻기 (join.jsp에서 입력한 회원정보를 request영역에서 꺼내오기)
	// 입력한 ID얻기
	String id = request.getParameter("id");
	// 입력한 비밀번호 얻기
	String passwd = request.getParameter("passwd");
	// 입력한 이름 얻기
	String name= request.getParameter("name");
	// 입력한 이메일 주소 얻기
	String email = request.getParameter("email");
	// 입력한 주소 얻기
	String strZipCode = request.getParameter("zipcode");
	
	int zipCode;
	if(strZipCode==null || strZipCode.equals("")){
		zipCode=0;
	}else{
		zipCode = Integer.parseInt(request.getParameter("zipcode"));
	}
	
	String address = request.getParameter("address");
	String address2 = request.getParameter("address2");
	// 입력한 전화번호 얻기
	String tel= request.getParameter("tel");
	
	
	
	String gender = request.getParameter("gender");
	
	// 3.입력한 회원정보들을 MemberBean객체를 생성해서 각각의 변수에 저장
	MemberBean m = new MemberBean();
	
	m.setId(id);
	m.setPasswd(passwd);
	m.setName(name);
	m.setEmail(email);
	m.setZipcode(zipCode);
	m.setAddress(address);
	m.setAddress2(address2);
	m.setTel(tel);
	m.setGender(gender);
	
	// 4. DB와 연동하여 입력한 회원정보를 DB의 테이블에 추가시키는 역할을 하는
	// 	  DAO객체를 생성 후메서드를 호출하여 INSERT작업을 실행.
	MemberDAO memberDAO = new MemberDAO();
			memberDAO.insertMember(m);
	
	// 5. 회원가입에 성공하면 login.jsp를 재요청(포워딩)하여 보여주기
	response.sendRedirect("welcome.jsp");
			
%>    
    
    
    
    
    
    
    