package gallery;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;
import javax.swing.text.AbstractDocument.Content;


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
			sql = "select max(num) from gallery";
			pstmt = con.prepareStatement(sql);
			rs = pstmt.executeQuery();
			if(rs.next()){
				num = rs.getInt(1)+1;
			}else{
				num += 1;
			}
			// 6. insert SQL문 만들기
			sql = "insert into gallery"
					+ "(num,id,title,file,date) "
					+ "values(?,?,?,?,now())";
			// 7. SQL문을 실행할 PreparedStatement실행 객체 얻기
			pstmt = con.prepareStatement(sql);
			// 8. ?값(입력한 새 글 정보들) 설정
			pstmt.setInt(1, num);
			pstmt.setString(2, bBean.getId());
			pstmt.setString(3, bBean.getTitle());
			pstmt.setString(4, bBean.getFile());
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
				sql = "select count(*) from gallery";
				pstmt = con.prepareStatement(sql);
			}else{
				sql = "select count(*) from gallery where title like ?";   
				pstmt = con.prepareStatement(sql);
				pstmt.setString(1, "%" + search + "%");
			}
			
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
			sql = "select * from gallery where title like ? order by num desc limit ?,?";
			pstmt = con.prepareStatement(sql);
			pstmt.setString(1, "%" + search + "%");
			pstmt.setInt(2, startRow);
			pstmt.setInt(3, pageSize);
			rs = pstmt.executeQuery();
			
			
			while(rs.next()){

				BoardBean bBean = new BoardBean();

				bBean.setNum(rs.getInt("num"));
				bBean.setId(rs.getString("id"));
				bBean.setDate(rs.getTimestamp("date"));
				bBean.setFile(rs.getString("file"));
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
	
	// 매개변수로 전달받는 글 num에 해당하는 글을 조회하여 반환하는 메서드
	public BoardBean getBoard(int num){
		BoardBean bBean = null;
		
		try {
			// DB연결
			con=getConnection();
			// SQL구문 만들기
			sql = "select * from gallery where num=?";
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
			bBean.setNum(rs.getInt("num"));
			bBean.setId(rs.getString("id"));
			bBean.setFile(rs.getString("file"));
			bBean.setTitle(rs.getString("title"));
			bBean.setDate(rs.getTimestamp("date"));
			
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
	public int deleteBoard(int num){
		
		int check=0;
		
		try {
			// 커넥션풀로부터 커넥션객체 얻기(DB연결)
			con=getConnection();
					
			sql = "delete from gallery where num=?";
			pstmt = con.prepareStatement(sql);
			pstmt.setInt(1, num);
			check= pstmt.executeUpdate(); // delete실행
					
		} catch (Exception e) {
			System.out.println("deleteBoard()메서드 내부에서 예외발생 : " + e);
		} finally {
			// 자원해제
			resourceClose();
		}
		
		return check;
	} // deleteBoard() 끝
	

} // BoardDAO class 끝









