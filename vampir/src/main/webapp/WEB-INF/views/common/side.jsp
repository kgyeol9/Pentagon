<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
  request.setCharacterEncoding("UTF-8");
%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <title>도감 사이트</title>

<style>
  :root {
    --sidebar-bg: #1b1b1b;
    --border-color: #333;
    --text-color: #e0e0e0;
    --highlight: #bb2222;

    /* 스크롤 색상 */
    --scrollbar-bg: #1b1b1b;           /* 스크롤 바탕 */
    --scrollbar-thumb: #333;           /* 기본 손잡이: 거의 배경색에 묻힘 */
    --scrollbar-thumb-hover: #991f1f;  /* hover 시 빨간색 포인트 */
    --scrollbar-thumb-active: #b22222; /* 클릭 중엔 더 밝은 빨강 */
  }

  .sidebar {
    position: fixed;
    top: 80px; /* header 높이에 맞게 수정 */
    left: 0;
    width: 250px;
    height: calc(100vh - 80px);
    background: var(--sidebar-bg);
    border-right: 1px solid var(--border-color);
    overflow-y: auto;
    padding: 1em;
    box-sizing: border-box;
    z-index: 1000;
  }

  /* 크롬/엣지/사파리 전용 스크롤바 */
  .sidebar::-webkit-scrollbar {
    width: 8px;
  }
  .sidebar::-webkit-scrollbar-track {
    background: var(--scrollbar-bg);
  }
  .sidebar::-webkit-scrollbar-thumb {
    background: var(--scrollbar-thumb);
    border-radius: 4px;
    transition: background 0.2s ease;
  }
  .sidebar::-webkit-scrollbar-thumb:hover {
    background: var(--scrollbar-thumb-hover);
  }
  .sidebar::-webkit-scrollbar-thumb:active {
    background: var(--scrollbar-thumb-active);
  }


  .category-list {
    display: flex;
    flex-wrap: wrap;
    gap: 0.5em;
    margin-bottom: 1em;
  }

  .category-list button {
    border: none;
    background: var(--highlight);
    color: #fff;
    padding: 0.5em 1em;
    cursor: pointer;
    border-radius: 4px;
    font-weight: bold;
  }

  .category-list button:hover {
    opacity: 0.8;
  }

  .subcategory {
    margin-bottom: 2em;
  }

  .subcategory h3 {
    margin: 0.5em 0;
    border-bottom: 1px solid var(--border-color);
    color: var(--highlight);
  }

  .subcategory ul {
    list-style: none;
    padding: 0;
    margin: 0;
  }

  .subcategory li {
    margin: 0.5em 0;
  }

  .subcategory a {
    text-decoration: none;
    color: var(--text-color);
  }

  .subcategory a:hover {
    color: var(--highlight);
  }
</style>

<div class="sidebar">
  <div class="category-list">
    <button onclick="scrollToCategory('c1')">대분류 1</button>
    <button onclick="scrollToCategory('c2')">대분류 2</button>
    <button onclick="scrollToCategory('c3')">대분류 3</button>
	<button onclick="scrollToCategory('c4')">대분류 4</button>
    <button onclick="scrollToCategory('c5')">대분류 5 </button>
    <button onclick="scrollToCategory('c6')">대분류 6</button>
  </div>

  <div class="subcategory" id="c1">
    <h3>대분류 1</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>

  <div class="subcategory" id="c2">
    <h3>대분류 2</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>

  <div class="subcategory" id="c3">
    <h3>대분류 3</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>
  
  <div class="subcategory" id="c4">
    <h3>대분류 4</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>
  
  <div class="subcategory" id="c5">
    <h3>대분류 5</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>
  
  <div class="subcategory" id="c6">
    <h3>대분류 6</h3>
    <ul>
      <li><a href="#">소분류 1</a></li>
      <li><a href="#">소분류 2</a></li>
      <li><a href="#">소분류 3</a></li>
    </ul>
  </div>
</div>

<script>
  function scrollToCategory(id) {
    const el = document.getElementById(id);
    if (el) {
      el.scrollIntoView({ behavior: "smooth", block: "start" });
    }
  }
</script>
