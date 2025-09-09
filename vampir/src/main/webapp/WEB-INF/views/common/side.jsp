<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
	request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>

<html>
<head>
<style>
/* 회원 정보 박스 (로그인 박스 크기 유지: width 280px) */
.logOn-box {
	position: absolute;
	top: 120px;
	left: 20px;
	background: #1f1f1f;
	padding: 1em;
	border-radius: 8px;
	box-shadow: 0 0 8px #bb000033;
	width: 280px;
	/* 비로그인 박스와 동일한 폭 유지 */
	z-index: 5;
}

/* 상단: 회원이름 + 로그아웃(우측 상단) */
.logOn-box .user-top {
	display: flex;
	align-items: center;
	justify-content: space-between;
	margin-bottom: 12px;
}

.logOn-box .user-name {
	margin: 0;
	font-size: 1.05em;
	color: #ff5555;
	font-weight: 700;
}

.logOn-box .logout-btn {
	background: #333;
	border: 1px solid #333;
	color: #eee;
	padding: 4px 10px;
	border-radius: 6px;
	cursor: pointer;
	font-size: 0.85em;
	font-weight: 700;
}

.logOn-box .logout-btn:hover {
	background: #bb0000;
	border-color: #bb0000;
}

/* 중단: 왼쪽 프로필 사진 + 오른쪽 텍스트 박스(New) */
.logOn-box .user-main {
	display: flex;
	align-items: stretch;
	/* 프로필 사진과 텍스트박스 높이 동일 */
	gap: 10px;
	margin-bottom: 1em;
}

.logOn-box .profile-pic {
	width: 80px;
	height: 80px;
	background: #333;
	border-radius: 8px;
	flex-shrink: 0;
}

.logOn-box .user-textbox {
	flex: 1;
	background: #2a2a2a;
	border-radius: 6px;
	padding: 8px;
	display: flex;
	align-items: center;
	justify-content: center;
	height: 64px;
	/* 프로필사진과 동일 높이 */
}

.logOn-box .user-textbox span {
	color: #aaa;
	font-size: 0.9em;
}

/* 하단: 쪽지함 / 마이페이지 (한 줄, 가로폭 나눠서 꽉 채우기) */
.logOn-box .user-bottom {
	display: flex;
	gap: 10px;
}

.logOn-box .user-bottom .btn {
	flex: 1 1 0;
	display: inline-flex;
	align-items: center;
	justify-content: center;
	padding: 10px 0;
	background: #333;
	color: #eee;
	border-radius: 6px;
	border: 1px solid #333;
	font-size: 0.95em;
	font-weight: 700;
	text-decoration: none;
}

.logOn-box .user-bottom .btn:hover {
	background: #bb0000;
	border-color: #bb0000;
}

/* 로그인 박스 위치 조정: 헤더 아래에 10px 간격 두기 */
.login-box {
	position: absolute;
	top: 120px;
	left: 20px;
	background: #1f1f1f;
	padding: 1em;
	border-radius: 8px;
	box-shadow: 0 0 8px #bb000033;
	width: 280px;
	z-index: 5;
}

.login-box h3 {
	margin-top: 0;
	color: #ff5555;
	font-size: 1.2em;
	margin-bottom: 0.8em;
}

/* 아이디와 비밀번호 입력 필드 레이블 추가 및 정렬 */
.login-box .input-group {
	display: flex;
	align-items: center;
	/* 수직 정렬 */
	margin-bottom: 0.8em;
	/* 각 입력 필드 간의 간격 */
}

.login-box label {
	color: #aaa;
	margin-right: 10px;
	/* 레이블과 입력 필드 사이 간격 */
	font-size: 0.9em;
	width: 60px;
	/* 레이블 너비 설정 */
}

.login-box input {
	width: 70%;
	padding: 8px;
	border: 1px solid #333;
	border-radius: 4px;
	background: #222;
	color: #eee;
	font-size: 0.9em;
}

.login-box button {
	width: 100%;
	padding: 8px;
	background: #bb0000;
	color: #fff;
	border: none;
	border-radius: 4px;
	cursor: pointer;
	font-weight: 600;
	margin-bottom: 10px;
	/* 로그인 버튼과 링크 사이의 간격 */
}

.login-box button:hover {
	background: #ff4444;
}

/* 회원가입/아이디 찾기 링크 한 줄로 배치 */
.login-links {
	margin-top: 0.8em;
	display: flex;
	justify-content: space-between;
	/* 가로로 배치 */
	font-size: 0.85em;
}

.login-links a {
	color: #aaa;
}

.login-links a:hover {
	color: #ff5555;
}
/* 에러 메시지 스타일 */
.login-error {
	background: #2a0000;
	color: #ff5555;
	border: 1px solid #bb0000;
	padding: 8px;
	border-radius: 4px;
	font-size: 0.9em;
	margin-bottom: 0.8em;
	text-align: center;
}
</style>
<meta charset="UTF-8">
<title>사이드 메뉴</title>
</head>
<body>
<%--  	<c:choose>
		<c:when test="${isLogOn == true  && member!= null}">
			<!-- 회원 정보 박스 -->
			<aside class="logOn-box">
				<!-- 상단 -->
				<div class="user-top">
					<h3 class="user-name">${member.name}님</h3>
					<a href="${contextPath}/member/logout.do" class="logout-btn">로그아웃</a>
				</div>

				<!-- 중단 -->
				<div class="user-main">
					<div class="profile-pic"></div>
					<div class="user-textbox">
						<span>회원 전용 텍스트 영역</span>
					</div>
				</div>

				<!-- 하단 -->
				<div class="user-bottom">
					<a href="#" class="btn inbox">쪽지함</a> <a
						href="${contextPath}/member/mypage.do" class="btn mypage">마이페이지</a>
				</div>
			</aside>
		</c:when>
		<c:otherwise>
			<!-- 로그인 박스 -->
			<aside class="login-box">
				<h3>로그인</h3>

				<!-- 로그인 실패 메시지 -->
				<c:if test="${param.result eq 'loginFailed'}">
					<div class="login-error">아이디 또는 비밀번호가 올바르지 않습니다.</div>
				</c:if>

				<form action="${contextPath}/member/login.do" method="post">
					<div class="input-group">
						<label for="username">아이디</label> <input type="text" id="username"
							name="id" required>
					</div>
					<div class="input-group">
						<label for="password">비밀번호</label> <input type="password"
							id="password" name="pwd" required>
					</div>
					<button type="submit">로그인</button>
				</form>
				<div class="login-links">
					<a href="${contextPath}/member/memberForm.do">회원가입</a> <a href="#">아이디/비밀번호
						찾기</a>
				</div>
			</aside>
		</c:otherwise>
	</c:choose>  --%>

</body>
</html>