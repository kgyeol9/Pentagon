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

</style>
<meta charset="UTF-8">
<title>사이드 메뉴</title>
</head>
<body>
 	<%-- <c:choose>
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
	</c:choose> 
 --%>
</body>
</html>