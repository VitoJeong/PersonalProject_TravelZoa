package member;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class MemberDAO { // DB작업하는  passwd;클래스
	
	// 전역변수 선언
	Connection con = null;
	ResultSet rs = null;
	PreparedStatement pstmt = null;
	String sql ="";
	
	// 자원 해제 메서드
	public void resourceClose(){
		
		try{
			if(pstmt != null) pstmt.close();
			if(rs != null) rs.close();
			if(con != null) con.close();
		}catch(Exception e){
			System.out.println("자원해제 실패 : "+e);
		}
		
	} // resourceClose()

	private Connection getConnection() throws Exception{
		
		Connection con = null;
		Context init = new InitialContext();
		// 커넥션풀 얻기
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/travelzoa");
		// 커넥션풀로부터 커넥션 객체 빌려와서 얻기
		con= ds.getConnection();
		
		// 커넥션 반환
		return con;
				
	} // getConnection()
	
	// join.jsp에서 회원정보 입력 -> MemberBean객체의 각 변수에 저장
	// -> MemberDAO의 insertMember메서드의 매개변수로 전달받음
	// 입력받은 회원정보들을 DB에 insert시키는 메서드
	public void insertMember(MemberBean memberBean){

	
	try{
		// 1. DB접속(연결) : 커넥션풀 DataSource로부터 커넥션 Connection객체 빌려오기
		con = getConnection();
		
		// 2. SQL구문 만들기(INSERT)
		sql = "insert into member(id,passwd,name,email,reg_date,zipcode,address,address2,tel,gender) "
				+ "values(?,?,?,?,now(),?,?,?,?,?)";
		
		// 3. 위 INSERT문자열 중에서 ?기호에 대응되는 설정값을 제외한 전체 구문을
		pstmt = con.prepareStatement(sql);
		
		// 4. ?기호에 대응되는 값들을 설정
		pstmt.setString(1, memberBean.getId());
		pstmt.setString(2, memberBean.getPasswd());
		pstmt.setString(3, memberBean.getName());
		pstmt.setString(4, memberBean.getEmail());
		pstmt.setInt(5, memberBean.getZipcode());
		pstmt.setString(6, memberBean.getAddress());
		pstmt.setString(7, memberBean.getAddress2());
		pstmt.setString(8, memberBean.getTel());
		pstmt.setString(9, memberBean.getGender());
		
		// 5. insert 문장을 DB에 전송하여 실행
		pstmt.executeUpdate();
	}catch(Exception e){
		System.out.println("insertMember메서드 내부에서 SQL실행예외 : " + e.toString());
	}finally{ // 무조건 한 번 실행해야할 구문이 있을때 사용하는 영역
		// 6.자원해제
		resourceClose();
		
	}
	
	
	}// insertMember()
	
	
	// 아이디 중복 체크하는 메서드
	public int idCheck(String id){ // 입력한 아이디를 매개변수로 전달받는다.
		
		int check = 0; // ID 중복여부를 판단하는 값을 저장
		
		try{
			// 1. 커넥션풀로부터 커넥션 객체 얻기(DB연결)
			con = getConnection();
			// 2. SQL문 만들기 : 사용자가 입력한 아이디에 해당하는 레코드 검색
			sql = "select * from member where id=?";
			// 3. SQL문을 실행항 PreparedStatement객체 얻기
			pstmt = con.prepareStatement(sql);
			// 4. ?기호에 대응되는 입력한 아이디 값 결정
			pstmt.setString(1, id);
			// 5. select 실행 후 검색한 결과데이터 얻기
			rs = pstmt.executeQuery();
			// 6. ResultSet객체 메모리에 이벽한 아이디에 해당하는 회원정보가 검색되어 저장되어 있으면
			if(rs.next()){
				check=1; // 아이디 중복
			}else{
				check=0; // 아이디 중복아님
			}
		
			
		}catch(Exception e){
			System.out.println("idCheck메서드 내부에서 예외 발생 : "+ e);
		}finally {
			// 자원해제
			resourceClose();
		}
		
		return check;
	}// idCheck()
	
	
	// 로그인 처리시 사용하는 메서드
	// 입력받은 id, passwd값과 DB에 저장되어있는 id, passwd값을 비교하여
	// 로그인처리하는 메서드
	public int userCheck(String id, String passwd){ // 사용자가 입력한 아이디, 비밀번호 전달받음
		
		int check = -1; // 1 -> 아이디 맞음, 비밀번호 맞음
						// 0 -> 아이디 맞음, 비밀번호 틀림
						// -1 -> 아이디 틀림
		
		try {
			
			// 1. 커넥션풀로부터 커넥션 얻기
			con=getConnection();
			
			// 2. SQL문 만들기 : 사용자가 입력한 아이디에 해당하는 레코드 검색
			sql = "select * from member where id=?";
			
			// 3. SQL문을 실행항 PreparedStatement객체 얻기
			pstmt = con.prepareStatement(sql);
			
			// 4. ?기호에 대응되는 입력한 아이디값을 설정
			pstmt.setString(1, id);
			
			// 5. 입력한 아이디에 해당하는 레코드 검색실행
			rs = pstmt.executeQuery();
			
			// 6. 입력한 아이디에 해당하는 레코드가 ResultSet에 저장되어 있따면
			if(rs.next()){
				// 입력한 아이디가 DB에 저장되어 있다면
				// 로그인시 사용자가 입력한 비밀번호와 dB에 저장되어 있던 비밀번호를 비교하여 동일하면
				if(passwd.equals(rs.getString("passwd"))){
					check = 1; // 아이디 맞음, 비밀번호 맞음
				}else{
					check = 0; // 아이디 맞음, 비밀번호 틀림
				}
			}else {
				// 입력한 아이디에 해당하는 레코드가 검색되지 않는다면
				// 
				check = -1;
			}
			
		} catch (Exception e) {
			System.out.println("userCheck메서드 내부에서 예외 발생 : " + e);
		} finally {
			// 자원해제
			resourceClose();
		}
		
		return check; // loginPro.jsp로 반환
		
	} // userCheck()
	
	// 회원정보반환
	public MemberBean getMember(String id) {
		
		String sql = "";
		
		MemberBean memberBean = new MemberBean();
		
		try {
			
			con = getConnection();
			sql = "select * from member where id = ?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			while(rs.next()) {
				memberBean.setId(rs.getString("id"));
				memberBean.setPasswd(rs.getString("passwd"));
				memberBean.setName(rs.getString("name"));
				memberBean.setReg_date(rs.getTimestamp("reg_date"));
				memberBean.setGender(rs.getString("gender"));
				memberBean.setEmail(rs.getString("email"));
				memberBean.setZipcode(rs.getInt("zipcode"));
				memberBean.setAddress(rs.getString("address"));
				memberBean.setAddress2(rs.getString("address2"));
				memberBean.setTel(rs.getString("tel"));
				
			}
			
		}catch(Exception e) {
			System.out.println("getMember()메소드 내부에서 예외발생 : " + e.toString());
		} finally {
			// 자원해제
			resourceClose();	
		}
		
		return memberBean;
		
	} //getMember()
	
	// 회원정보수정
	public int updateMember(MemberBean memberBean) {
	
		String sql = "select * from member where id = ?";
		
		try {
			
			con = getConnection();
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, memberBean.getId());
			rs = pstmt.executeQuery();
	
			if (rs.next()) {
				if (memberBean.getPasswd().equals(rs.getString("passwd"))) {
	
					sql = "update member set name=?, zipcode=?, address=?, address2=?, tel=? where id=?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, memberBean.getName());
					pstmt.setInt(2, memberBean.getZipcode());
					pstmt.setString(3, memberBean.getAddress());
					pstmt.setString(4, memberBean.getAddress2());
					pstmt.setString(5, memberBean.getTel());
					pstmt.setString(6, memberBean.getId());
					
					return pstmt.executeUpdate(); 
				}else {
					return -1;
				}
			}
	
		} catch (Exception e) {
			System.out.println("updateMember()메소드 내부에서 예외발생 : " + e.toString());
		} finally {
			resourceClose();
		}
		
		return 0;
	
	}//updateMember
	
	// 회원탈퇴
	public int deleteMember(String id,String passwd){
		
		int result=0;
		
		try {
			con=getConnection();
			sql = "select passwd from member where id=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, id);
			rs = pstmt.executeQuery();
			
			if(rs.next()){
				if(passwd.equals(rs.getString(1))){
					sql="delete from member where id =?";
					pstmt=con.prepareStatement(sql);
					pstmt.setString(1, id);
					result=pstmt.executeUpdate();
				}else {
					result=-1;
				}
			}
		} catch (Exception e) {
			System.out.println("deleteMember()메서드 내부에서 예외발생 : " + e);
		} finally {
			resourceClose();
		}
		
		return result;
	} // deleteMember() 끝
	
	
} // MemberDAO









