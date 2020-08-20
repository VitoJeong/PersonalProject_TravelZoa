package board;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;


public class BoardDAO { 
	
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
		DataSource ds = (DataSource)init.lookup("java:comp/env/jdbc/travelzoa");
		con= ds.getConnection();
		
		return con;
				
	} // getConnection()
	
	
	public void insertBoard(BoardBean bBean){ 
		
		int num = 0;
		
		try {
			con = getConnection();
			sql = "select max(num) from board";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				num = rs.getInt(1)+1;
			}else{
				num += 1;
			}
			// 6. insert SQL문 만들기
			sql = "insert into board"
					+ "(num,id,passwd,title,content, "
					+ "re_ref,re_lev,re_seq,count,date,ip) "
					+ "values(?,?,?,?,?,?,?,?,?,now(),?)";
			// 7. SQL문을 실행할 PreparedStatement실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			// 8. ?값(입력한 새 글 정보들) 설정
			pstmt.setInt(1, num);
			pstmt.setString(2, bBean.getId());
			pstmt.setString(3, bBean.getPasswd());
			pstmt.setString(4, bBean.getTitle());
			pstmt.setString(5, bBean.getContent());
			pstmt.setInt(6, num);
			// 주글(새글)과 답변글을 묶어서 나타내는 그룹번호
			// 여기서는 주글(새로 추가할 글)의 그룹번호
			pstmt.setInt(7, 0); // 주글(새로추가할 글)의 들여쓰기 정도 레벨값 0
			pstmt.setInt(8, 0); // 주글 순서
			pstmt.setInt(9, 0); // 주글(새로 추가할 글)의 주회수 0
			pstmt.setString(10, bBean.getIp());
			
			// Insert문 실행
			pstmt.executeUpdate();
					
		} catch (Exception e) {
			System.out.println("insertBoard메서드 내부에서 예외 발생 : " + e); 
		}finally {
			// 자원해제
			resourceClose();
		}
		
	} // insertBoard() 끝
	
	// board테이블에 저장된 전체 글 개수를 조회해서 제공하는 메서드
	
	public int getBoardCount(String search){
		// board테이블에 저장되어 있는 조회한 글 개수를 저장할 변수
		int count=0;
		
		try {
			
			// 커넥션풀로부터 커넥션 얻기
			con = getConnection();
			// SQL문 : 전체 글 개수 조회
			if(search == null || search.equals("")) {
				sql = "select count(*) from board";
				pstmt = con.prepareStatement(sql);
			}else{
				sql = "select count(*) from board where title like ?";   
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + search + "%");
			}
			
			/*sql = "select count(*) from board";*/
			/*pstmt = con.prepareStatement(sql);*/
			rs = pstmt.executeQuery(); // 전체 글 개수 조회후 반환
			
			// 글의 개수가 조회가 된다면
			if(rs.next()){
				// 조회된 글의 개수 저장
				count = rs.getInt(1);
			}
			
			
		} catch (Exception e) {
			System.out.println("getBoardCount()메서드 내부에서 예외발생 : " + e);
		} finally {
			// 자원해제
			resourceClose();
		}
		
		return count;
	} // getBoardCount
	
	// 글목록 검색해서 가져오는 메서드
	public List<BoardBean> getBoardList(String search, int startRow, int pageSize){
		// board테이블로 부터 검색한 글 정보들을
		// 각각 한줄 단위 BoardBean객체에 저장후~
		// BoardBean객체들을 각각 ArrayList배열에 추가로 저장하기 위한 용도
		List<BoardBean> boardList = new ArrayList<BoardBean>();
		
		try {
			// DB연결
			con = getConnection();
			// SQL문 만들기
			sql = "select * from board where title like ? order by re_ref desc, re_seq asc limit ?,?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, pageSize);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()){

				BoardBean bBean = new BoardBean();

				bBean.setContent(rs.getString("content"));
				bBean.setDate(rs.getTimestamp("date"));
				bBean.setIp(rs.getString("ip"));
				bBean.setId(rs.getString("id"));
				bBean.setNum(rs.getInt("num"));
				bBean.setPasswd(rs.getString("passwd"));
				bBean.setRe_lev(rs.getInt("re_lev"));
				bBean.setRe_seq(rs.getInt("re_seq"));
				bBean.setRe_ref(rs.getInt("re_ref"));
				bBean.setCount(rs.getInt("count"));
				bBean.setTitle(rs.getString("title"));
				// BoardBean 객체 => ArrayList배열에 추가
				boardList.add(bBean);
				
			}// while반복문 끝
			
			
		} catch (Exception e) {
			System.out.println("getBoardList()메서드 내부에서 예외발생 : " + e);
		} finally {
			resourceClose();
		}
		
		return boardList;
		// 검색한 글 정보들(BoardBean객체들)을 저장하고 있는 배열공간인
		// ArrayList를 notice.jsp로 반환
	} // getBoardList() 끝
	
	
	public void updateReadCount(int num){
		
		
		try {
			// DB연결
			con = getConnection();
			// SQL문 만들기
			sql = "update board set count = count + 1 where num = ?";
			// PreaparedStatement SQL문 실행객체 얻기
			pstmt= con.prepareStatement(sql);
			// ? 기호에 대응되는 글번호 num을 설정
			pstmt.setInt(1, num);
			// update sql문 실행
			pstmt.executeUpdate();
		} catch (Exception e) {
			System.out.println("updateReadCount()메서드 내부에서 예외발생 : " + e.toString());
		} finally {
			resourceClose();
		}
	} // updateReadCount()
	
	// 매개변수로 전달받는 글 num에 해당하는 글을 조회하여 반환하는 메서드
	public BoardBean getBoard(int num){
		BoardBean bBean = null;
		
		try {
			// DB연결
			con=getConnection();
			// SQL구문 만들기
			sql = "select * from board where num=?";
			// PreparedStatement실행객체 얻기
			pstmt = con.prepareStatement(sql);
			// ?에 대응되는 글 num설정
			pstmt.setInt(1, num);
			// SELECT문 실행 후 조회한 결과 레코드 얻기
			rs = pstmt.executeQuery();
			// rs -> BoardBean객체의 각 변수에 저장
			rs.next();
			bBean = new BoardBean();
			
			// DB로부터 검색한 하나의 글 정보들을
			// BoardBean객체의 content변수에 저장
			bBean.setContent(rs.getString("content"));
			bBean.setDate(rs.getTimestamp("date"));
			bBean.setId(rs.getString("id"));
			bBean.setNum(rs.getInt("num"));
			bBean.setPasswd(rs.getString("passwd"));
			bBean.setRe_lev(rs.getInt("re_lev"));
			bBean.setRe_seq(rs.getInt("re_seq"));
			bBean.setRe_ref(rs.getInt("re_ref"));
			bBean.setCount(rs.getInt("count"));
			bBean.setTitle(rs.getString("title"));
			
		} catch (Exception e) {
			System.out.println("getBoard()메서드 내부에서 예외발생 : " + e.toString());
		}finally {
			// 자원해제
			resourceClose();
		}
		
		
		
		return bBean;
	} // getBoard() 끝
	
	// deletePro.jsp로부터
	// 삭제할 글번호와 입력한 비밀번호를 매개변수로 전달받아 글 삭제시키는 메서드
	public int deleteBoard(int num, String passwd){
		
		int check = 0;
		
		try {
			// 커넥션풀로부터 커넥션객체 얻기(DB연결)
			con=getConnection();
			// SQL문 매개변수로 전달 받는 글 num에 해당하는 글의 비밀번호 검색
			sql="select passwd from board where num = ?";
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs = pstmt.executeQuery();
			
			if(rs.next()){ // 삭제할 글에 대한 비밀번호가 검색된다면?
				// 사용자가 입력한 비밀번호와 검색해 온 글의 비밀번호를 비교하여 동일하면?
				if(rs.getString("passwd").equals(passwd)){
					
					// SQL문 만들기 : 매개변수로 전달받은 글 번호에 해당하는 글을 삭제
					sql = "delete from board where num=?";
					pstmt = con.prepareStatement(sql);
					pstmt.setInt(1, num);
					check = pstmt.executeUpdate(); // delete실행
					
				}else{ // 사용자가 입력한 비밀번호와 DB에 저장된 비밀번호가 다르면
					check = -1;
				}
			}
		} catch (Exception e) {
			System.out.println("deleteBoard()메서드 내부에서 예외발생 : " + e);
		} finally {
			// 자원해제
			resourceClose();
		}
		
		return check;
		// 사용자가 입력한 비밀번호와 DB에 저장된 글의 비밀번호가 일치하면
		// check변수의 값을 1로 리턴
		// 일치하지않으면 check변수를 0으로 리턴
		
	} // deleteBoard() 끝
	
	public int updateBoard(BoardBean bBean){
		int check = 0;
			
		int num = bBean.getNum();
		String title = bBean.getTitle();
		String content = bBean.getContent();
		String passwd = bBean.getPasswd();
		
		
		try {
			con=getConnection();
			sql = "select passwd from board where num = ?";
			pstmt=con.prepareStatement(sql);
			pstmt.setInt(1, num);
			rs=pstmt.executeQuery();
			
			if(rs.next()){
				if(passwd.equals(rs.getString("passwd"))){
					check =1;
					
					sql ="update board set title = ?, content = ? where num=?";
					pstmt = con.prepareStatement(sql);
					pstmt.setString(1, title);
					pstmt.setString(2, content);
					pstmt.setInt(3, num);
					pstmt.executeUpdate();
				}else{
					check=0;
				}
			}
		} catch (Exception e) {
			System.out.println("updateBoard()메서드 내부에서 예외발생 : " + e);
		}finally {
			resourceClose();
		}
		
		return check;
	} // updateBoard()

	/*
 	답변 달기 필드 설명
 		re_ref     부모글과 그로부터 파생된 답변글(자식글)이 같은 값을 가지기 위한 그룹값
 		re_seq	     같은 그룹글들 내의 순서
 		re_lev	     같은 그룹내에서의 깊이(들여쓰기정도값)
 
 	답변 달기 규칙 설명
 	순서1) re_ref 그룹값은 부모글의 그룹번호(re_ref)값을 사용한다.
 	순서2) re_seq 값은 부모글의  re_seq에서  +1 증가 한 값을 사용한다.
 	순서3) re_lev 값은 부모글의 re_lev에서  +1 증가 한 값을 사용한다.
 
	 */
	
	public void reInsertBoard(BoardBean bBean){
		
		
		int num = 0;
		
		String id = bBean.getId();
		String title = bBean.getTitle();
		String content = bBean.getContent();
		String passwd = bBean.getPasswd();
		int re_ref = bBean.getRe_ref();
		int re_lev = bBean.getRe_lev();
		int re_seq = bBean.getRe_seq();
		
		try {
			con = getConnection();
			sql="select max(num) from board";
			pstmt= con.prepareStatement(sql);
			
			rs= pstmt.executeQuery();
			
			if(rs.next()){
				// 답변글 글번호를 검색된 최신글 번호의 +1한 값으로 저장
				num=rs.getInt(1) +1;
			}else{
				num=1;
			}
			
			// re_seq 답글 순서 재배치
			// 조건 : 부모글 그룹과 같은 그룹에서..
			// 		부모글의 seq값보다 큰 답별글들은? seq값을 증가시킨다.
			sql = "update board set re_seq=re_seq+1 "
					+ "where re_ref=? and re_seq>?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, re_ref);
			pstmt.setInt(2, re_seq);
			pstmt.executeUpdate();
			
			sql = "insert into board values(?,?,?,?,?,?,?,?,?,?,?)";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			pstmt.setString(2, id);
			pstmt.setString(3, passwd);
			pstmt.setString(4, title);
			pstmt.setString(5, content);
			pstmt.setInt(6, re_ref); // 답변글 INSERT시 부모글의 그룹값을 사용하여 INSERT
									// 이유 : 부모글의 답변글은 같은 그룹값을 가지기 위함
			pstmt.setInt(7, re_lev+1); // 부모글의 re_lev에  +1을 사용하여 답변글 INSERT
			pstmt.setInt(8, re_seq+1); // 부모글의 re_seq에  +1을 사용하여 답변글 INSERT
			pstmt.setInt(9, 0); //INSERT시 조회수 0
			pstmt.setTimestamp(10, bBean.getDate()); // 작성날짜
			pstmt.setString(11, bBean.getIp()); // 작성 IP주소
			
			pstmt.executeUpdate();
			
		} catch (Exception e) {
			System.out.println("reInsertBoard() 메서드 오류" + e);
		} finally {
			resourceClose();
		}
		
	} // reInsertBoard() 끝
	
	
} // BoardDAO class 끝









