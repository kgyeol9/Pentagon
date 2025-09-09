<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<link rel="stylesheet" href="${contextPath}/resources/board/style.css" />
<script defer src="${contextPath}/resources/board/app.js"></script>
<div class="board-wrap">
	<div class="container">
		<a class="logo" href="${contextPath}/board/list.do">Vaempir Board</a>
		<div class="actions">
			<a href="${contextPath}/board/write.do" class="primary">글쓰기</a> <a
				href="${contextPath}/board/list.do">목록</a>
		</div>


		<article class="article">
			<h1 id="title">-</h1>
			<div class="meta" id="meta">-</div>
			<div class="content" id="content">-</div>
		</article>

		<div class="actions" style="margin-top: 10px">
			<a class="btn" href="${contextPath}/board/list.do">목록</a> <a
				class="btn" id="editLink" href="#">수정</a>
			<button class="btn danger" id="deleteBtn">삭제</button>
		</div>
	</div>
</div>
<script src="app.js"></script>
<script>
  document.addEventListener('DOMContentLoaded', () => { renderShowPage(); });
</script>
