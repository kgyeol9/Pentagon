<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" isELIgnored="false"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<c:set var="contextPath" value="${pageContext.request.contextPath}" />
<%@ page session="false"%>
<%
    request.setCharacterEncoding("UTF-8");
%>
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8" />
<title>아이템 DB</title>
<meta name="viewport" content="width=device-width, initial-scale=1" />
<style>
:root { --subrow-base:84px; --boost:40px; --gap:12px; --row-h:44px; }

/* ===== 공통/테마 ===== */
body{ margin:0; font-family:'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background:#121212; color:#eee; }
a{ text-decoration:none; color:inherit; }
.db-main{ max-width:1200px; margin:110px auto 24px; padding:0 16px; }
.card{ background:#1f1f1f; border:1px solid #333; border-radius:10px; }

/* 버튼/타이틀 */
.btn-primary{ background:#bb0000; color:#fff; border:none; border-radius:8px; font-weight:700; cursor:pointer; padding:10px 12px; }
.btn-primary:hover{ background:#ff4444; }
.page-title{ font-size:20px; margin:0 0 12px; padding-bottom:8px; border-bottom:2px solid #bb0000; color:#ffdddd; }

/* ===== 필터 ===== */
.filters{ padding:16px; }
.filters-grid{ display:grid; grid-template-columns:1fr 1fr; gap:16px; align-items:stretch; }
.filter-left{ display:block; }
.fbox{ background:#181818; border:1px solid #333; border-radius:10px; padding:0; overflow:hidden; display:grid; grid-template-rows:1fr 1fr 1fr auto; gap:0; }
.subrow{ min-height:var(--subrow-base); display:grid; grid-template-columns:72px 1fr; align-items:center; gap:12px; padding:14px 16px; box-sizing:border-box; }
.fbox .subrow:nth-child(-n+3){ min-height:calc(var(--subrow-base) + var(--boost)); }
.subrow + .subrow{ border-top:1px solid #333; }
.label{ color:#bbb; font-size:13px; }
.checks{ display:flex; flex-wrap:wrap; gap:10px 16px; align-items:center; align-content:center; min-height:100%; }
.checks .chk{ display:flex; align-items:center; gap:6px; font-size:14px; }
.checks input[type="checkbox"]{ width:16px; height:16px; }
.searchline{ display:grid; grid-template-columns:1fr 120px; gap:10px; align-items:center; }
.searchline input[type="text"]{ padding:12px; border-radius:8px; border:1px solid #333; background:#181818; color:#eee; }

/* 오른쪽 비교영역 */
.filter-right{ display:flex; flex-direction:column; gap:var(--gap); }
.sidebox-row{ display:grid; grid-template-columns:1fr 1fr; gap:var(--gap); }
.sidebox{ background:#181818; border:1px solid #333; border-radius:10px; padding:14px 16px; overflow:auto; box-sizing:border-box; min-height:60px; height:100%; transition:.15s border-color,.15s box-shadow; }
.sidebox.selectable{ cursor:pointer; }
.sidebox.selected{ border-color:#bb0000; box-shadow:0 0 0 1px #bb0000 inset; }
.sidebox .slot-head{ font-size:12px; color:#bbb; margin:-4px 0 8px; display:flex; align-items:center; gap:8px; }
.chip{ font-size:11px; padding:2px 8px; border:1px solid #444; border-radius:999px; color:#ccc; }

/* ===== 결과바: 총개수/정렬/뷰토글 ===== */
.result-bar{ display:flex; flex-wrap:wrap; align-items:center; justify-content:space-between; gap:10px; margin:14px 0 8px; }
.result-info{ color:#bbb; font-size:13px; }
.sort-group{ display:flex; gap:8px; align-items:center; }
.sort-group select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:8px; }
.right-controls{ display:flex; align-items:center; gap:12px; }
.page-size select{ background:#181818; color:#eee; border:1px solid #333; border-radius:8px; padding:6px 10px; }
.label-inline{ color:#bbb; font-size:13px; margin-right:6px; }

/* 뷰 토글 */
.view-toggle{ display:flex; gap:6px; }
.vt-btn{ background:#222; border:1px solid #333; color:#eee; padding:6px 10px; border-radius:6px; cursor:pointer; }
.vt-btn.active{ background:#bb0000; border-color:#bb0000; }

/* ===== 리스트뷰 ===== */
.list{ overflow:hidden; }
.thead, .r{ display:grid; grid-template-columns:1fr 1.2fr 44px; }
.thead{ background:#181818; color:#ddd; font-weight:700; user-select:none; }
.thead .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; gap:8px; min-height:var(--row-h); cursor:pointer; }
.thead .c.no-sort{ cursor:default; }
.r .c{ padding:10px 14px; border-bottom:1px solid #333; display:flex; align-items:center; min-height:var(--row-h); }
.r{ background:#151515; } .r:nth-child(even){ background:#171717; }
.thead .c .arrow{ font-size:11px; color:#aaa; opacity:.6; }
.name-cell{ display:flex; align-items:center; gap:10px; }
.thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.thumb--placeholder{ width:48px; height:48px; display:grid; place-items:center; background:#222; border:1px solid #333; border-radius:6px; color:#777; font-weight:700; }
.name-text{ display:inline-block; line-height:1.2; }
.plus-btn{ width:28px; height:28px; border-radius:6px; border:1px solid #444; background:#222; color:#fff; font-size:18px; line-height:26px; text-align:center; cursor:pointer; margin-left:auto; }
.plus-btn:hover{ background:#333; }

/* 상세슬라이드 */
.detail{ grid-column:1 / -1; overflow:hidden; max-height:0; transition:max-height .25s ease; }
.detail-inner{ padding:12px 14px; border-top:1px dashed #333; display:grid; grid-template-columns:1fr 1fr; gap:14px; background:#151515; }
.subsec h4{ margin:0 0 6px; font-size:13px; color:#ffdddd; }
.meta{ color:#bbb; font-size:13px; }
.open .detail{ max-height:240px; }

/* ===== 카드뷰 ===== */
.item-cards{ display:grid; grid-template-columns:repeat(3, 1fr); gap:12px; padding:12px; }
@media (max-width:1000px){ .item-cards{ grid-template-columns:repeat(2, 1fr);} }
@media (max-width:600px){ .item-cards{ grid-template-columns:1fr; } }
.item-card{ background:#181818; border:1px solid #2a2a2a; border-radius:10px; padding:12px; display:flex; flex-direction:column; gap:10px; }
.ic-head{ display:flex; align-items:center; justify-content:space-between; gap:10px; }
.ic-name{ display:flex; align-items:center; gap:10px; }
.ic-thumb{ width:48px; height:48px; object-fit:contain; border-radius:6px; display:block; }
.ic-thumb.ic-thumb--ph{ display:grid; place-items:center; background:#222; border:1px solid #333; color:#777; font-weight:700; }
.ic-title{ font-weight:700; }
.ic-meta{ display:flex; gap:6px; flex-wrap:wrap; color:#bbb; font-size:12px; }
.ic-body{ display:grid; gap:6px; }
.stat{ color:#ccc; font-size:13px; display:flex; gap:8px; align-items:center; }

/* ===== 하단 페이징/검색 ===== */
.footerbar{ padding:10px 12px; margin-top:10px; }
.footerline.footer-two{ display:grid; grid-template-columns:1fr max-content; align-items:center; column-gap:12px; }
.pager-center{ justify-self:center; display:flex; gap:8px; flex-wrap:wrap; padding:4px 0; }
.page-num{ background:#1b1b1b; border:1px solid #333; color:#eee; border-radius:8px; padding:6px 10px; min-width:36px; line-height:1; cursor:pointer; transition:background .12s, border-color .12s, transform .06s; }
.page-num:hover{ background:#242424; }
.page-num:active{ transform:translateY(1px); }
.page-num:focus-visible{ outline:2px solid #bb0000; outline-offset:2px; }
.page-num.active, .page-num[disabled]{ background:#bb0000; border-color:#bb0000; color:#fff; cursor:default; pointer-events:none; }
.page-ellipsis{ color:#888; padding:0 4px; user-select:none; }

/* 반응형 */
@media (max-width:900px){ .filters-grid{ grid-template-columns:1fr; } .sidebox-row{ height:auto!important; } .sidebox{ height:auto!important; } }

/* 검색바(하단) 폭 보정 */
.searchline.compact{
  display:grid; grid-template-columns: 220px max-content; gap:8px; align-items:center;
}
@media (max-width:600px){
  .searchline.compact{ grid-template-columns: 1fr max-content; }
}

</style>
</head>
<body>
<main class="db-main">
  <h2 class="page-title">아이템 DB</h2>

  <!-- ===== 필터 ===== -->
  <section class="card filters" aria-label="아이템 필터">
    <div class="filters-grid">
      <!-- 왼쪽: 필터 박스 -->
      <div class="filter-left">
        <div class="fbox" id="filterBox">
          <!-- 직업 -->
          <div class="subrow">
            <div class="label">직업</div>
            <div class="checks" id="jobs">
              <label class="chk"><input type="checkbox" name="job" value="전체" checked>전체</label>
              <label class="chk"><input type="checkbox" name="job" value="바이퍼">바이퍼</label>
              <label class="chk"><input type="checkbox" name="job" value="그림리퍼">그림리퍼</label>
              <label class="chk"><input type="checkbox" name="job" value="카니지">카니지</label>
              <label class="chk"><input type="checkbox" name="job" value="블러드스테인">블러드스테인</label>
            </div>
          </div>
          <!-- 분류 -->
          <div class="subrow">
            <div class="label">분류</div>
            <div class="checks" id="cats">
              <label class="chk"><input type="checkbox" name="cat" value="무기">무기</label>
              <label class="chk"><input type="checkbox" name="cat" value="방어구">방어구</label>
              <label class="chk"><input type="checkbox" name="cat" value="장신구">장신구</label>
              <label class="chk"><input type="checkbox" name="cat" value="부장품">부장품</label>
              <label class="chk"><input type="checkbox" name="cat" value="소모품">소모품</label>
              <label class="chk"><input type="checkbox" name="cat" value="스킬북">스킬북</label>
              <label class="chk"><input type="checkbox" name="cat" value="재표">재표</label>
            </div>
          </div>
          <!-- 등급 -->
          <div class="subrow">
            <div class="label">등급</div>
            <div class="checks" id="grades">
              <label class="chk"><input type="checkbox" name="grade" value="전체" checked>전체</label>
              <label class="chk"><input type="checkbox" name="grade" value="일반">일반</label>
              <label class="chk"><input type="checkbox" name="grade" value="고급">고급</label>
              <label class="chk"><input type="checkbox" name="grade" value="희귀">희귀</label>
              <label class="chk"><input type="checkbox" name="grade" value="영웅">영웅</label>
              <label class="chk"><input type="checkbox" name="grade" value="전설">전설</label>
              <label class="chk"><input type="checkbox" name="grade" value="신화">신화</label>
            </div>
          </div>
          <!-- 검색 -->
          <div class="subrow">
            <div class="label">검색</div>
            <div class="searchline">
              <input type="text" id="qTop" placeholder="아이템 이름으로 검색" />
              <button class="btn-primary" id="btnSearchTop">검색</button>
            </div>
          </div>
        </div>
      </div>

      <!-- 오른쪽: 선택/비교 -->
      <div class="filter-right" id="filterRight">
        <div class="sidebox-row" id="sideTopRow">
          <div class="sidebox selectable selected" id="sideTopA" data-slot="A" title="담을 위치 선택(A)">
            <div class="slot-head">
              <span class="chip">비교 A (기준)</span><span id="slotALabel" style="color:#aaa">비어 있음</span>
            </div>
            <div id="slotA"></div>
          </div>
          <div class="sidebox selectable" id="sideTopB" data-slot="B" title="담을 위치 선택(B)">
            <div class="slot-head">
              <span class="chip">비교 B</span><span id="slotBLabel" style="color:#aaa">비어 있음</span>
            </div>
            <div id="slotB"></div>
          </div>
        </div>
        <div class="sidebox" id="sideBottom" aria-label="스펙 비교 영역">
          <div class="slot-head"><span class="chip">스펙 비교 (A 기준)</span></div>
          <div id="cmpBox" style="color:#aaa; font-size:13px;">A와 B에 아이템을 담으면 비교가 표시됩니다.</div>
        </div>
      </div>
    </div>
  </section>

  <!-- ===== 결과/정렬 + 뷰 토글 ===== -->
  <div class="result-bar">
    <div class="result-info" id="resultInfo">총 0개</div>
    <div class="right-controls">
      <div class="page-size">
        <label for="pageSize" class="label-inline">표시</label>
        <select id="pageSize">
          <option value="5">5개</option>
          <option value="10" selected>10개</option>
          <option value="30">30개</option>
        </select>
      </div>
      <div class="sort-group">
        <span style="color:#bbb; font-size:13px">정렬:</span>
        <select id="sortKey">
          <option value="id">번호</option>
          <option value="name">이름</option>
          <option value="grade">등급</option>
          <option value="category">분류</option>
        </select>
      </div>
      <!-- 뷰 토글 -->
      <div class="view-toggle" role="tablist" aria-label="뷰 전환">
        <button id="btnViewList" class="vt-btn active" role="tab" aria-selected="true">리스트형</button>
        <button id="btnViewCard" class="vt-btn" role="tab" aria-selected="false">카드형</button>
      </div>
    </div>
  </div>

  <!-- ===== 리스트 뷰 ===== -->
  <section class="card list" id="listView" aria-label="아이템 목록">
    <div class="thead">
      <div class="c th" data-k="name">아이템 이름 <span class="arrow" id="ar-name">▲▼</span></div>
      <div class="c th" data-k="stats">아이템 능력치</div>
      <div class="c no-sort"></div>
    </div>
    <div id="itemBody">
      <c:if test="${empty itemsList}">
        <div class="r"><div class="c" style="grid-column:1 / -1; color:#aaa;">데이터가 없습니다.</div></div>
      </c:if>

      <c:forEach var="item" items="${itemsList}">
        <div class="r" onclick="toggleDetail(this)"
        	 data-name="${fn:escapeXml(item.name)}"
             data-minatk="${item.min_ATK}" data-maxatk="${item.max_ATK}"
             data-addatk="${item.add_ATK}" data-accuracy="${item.accuracy}"
             data-critical="${item.critical}">
          <!-- 이름 -->
          <div class="c name-cell">
            <c:choose>
              <c:when test="${not empty item.imgPath}">
                <img class="thumb"
                     src="${contextPath}/resources/image/weapon/${fn:escapeXml(item.imgPath)}"
                     alt="${fn:escapeXml(item.name)}" />
              </c:when>
              <c:otherwise><div class="thumb--placeholder">?</div></c:otherwise>
            </c:choose>
            <span class="name-text">${fn:escapeXml(item.name)}</span>
          </div>
          <!-- 능력치 -->
          <div class="c">
            <c:choose>
              <c:when test="${item.min_ATK != 0 || item.max_ATK != 0}">
                ATK ${item.min_ATK} ~ ${item.max_ATK}
                <c:if test="${item.add_ATK != 0}"> / +${item.add_ATK}</c:if>
              </c:when>
              <c:otherwise>-</c:otherwise>
            </c:choose>
          </div>
          <!-- + 버튼 -->
          <div class="c">
            <button class="plus-btn" onclick="addToCompare(event, this)">+</button>
          </div>
        </div>

        <!-- 상세 -->
        <div class="detail">
          <div class="detail-inner">
            <c:if test="${item.min_ATK != 0 || item.max_ATK != 0}">
              <div class="subsec"><h4>공격력</h4><div class="meta">${item.min_ATK} ~ ${item.max_ATK}</div></div>
            </c:if>
            <c:if test="${item.add_ATK != 0}">
              <div class="subsec"><h4>추가 공격력</h4><div class="meta">+${item.add_ATK}</div></div>
            </c:if>
            <c:if test="${item.accuracy != 0}">
              <div class="subsec"><h4>명중률</h4><div class="meta">${item.accuracy}</div></div>
            </c:if>
            <c:if test="${item.critical != 0}">
              <div class="subsec"><h4>치명타</h4><div class="meta">${item.critical}</div></div>
            </c:if>
            <c:if test="${not empty item.obtain_source}">
              <div class="subsec" style="display:flex; align-items:center; gap:10px;">
                <h4 style="margin:0; font-size:13px; color:#ffdddd;">획득처:</h4>
                <div class="meta" style="color:#bbb; font-size:13px;">${fn:escapeXml(item.obtain_source)}</div>
              </div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- ===== 카드 뷰 ===== -->
  <section class="card" id="cardView" aria-label="아이템 카드 목록" style="display:none;">
    <div id="cardGrid" class="item-cards">
      <c:forEach var="item" items="${itemsList}">
        <div class="item-card"
             data-name="${fn:escapeXml(item.name)}"
             data-minatk="${item.min_ATK}" data-maxatk="${item.max_ATK}"
             data-addatk="${item.add_ATK}" data-accuracy="${item.accuracy}"
             data-critical="${item.critical}">
          <div class="ic-head">
            <div class="ic-name">
              <c:choose>
                <c:when test="${not empty item.imgPath}">
                  <img class="ic-thumb"
                       src="${contextPath}/resources/image/weapon/${fn:escapeXml(item.imgPath)}"
                       alt="${fn:escapeXml(item.name)}" />
                </c:when>
                <c:otherwise><div class="ic-thumb ic-thumb--ph">?</div></c:otherwise>
              </c:choose>
              <div>
                <div class="ic-title">${fn:escapeXml(item.name)}</div>
                <div class="ic-meta">
                  <c:if test="${not empty item.quality}">
                    <span class="chip">${fn:escapeXml(item.quality)}</span>
                  </c:if>
                  <c:if test="${not empty item.category}">
                    <span class="chip">${fn:escapeXml(item.category)}</span>
                  </c:if>
                  <c:if test="${not empty item.job}">
                    <span class="chip">${fn:escapeXml(item.job)}</span>
                  </c:if>
                </div>
              </div>
            </div>
            <button class="plus-btn" onclick="addToCompare(event, this)">+</button>
          </div>

          <div class="ic-body">
            <div class="stat">
              <b>ATK</b>
              <c:choose>
                <c:when test="${item.min_ATK != 0 || item.max_ATK != 0}">
                  ${item.min_ATK} ~ ${item.max_ATK}<c:if test="${item.add_ATK != 0}"> / +${item.add_ATK}</c:if>
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </div>
            <c:if test="${item.accuracy != 0}">
              <div class="stat"><b>명중률</b> ${item.accuracy}</div>
            </c:if>
            <c:if test="${item.critical != 0}">
              <div class="stat"><b>치명타</b> ${item.critical}</div>
            </c:if>
            <c:if test="${not empty item.obtain_source}">
              <div class="stat"><b>획득처</b> ${fn:escapeXml(item.obtain_source)}</div>
            </c:if>
          </div>
        </div>
      </c:forEach>
    </div>
  </section>

  <!-- ===== 하단: 숫자 페이징 + 검색 ===== -->
  <section class="card footerbar" aria-label="페이징/검색">
    <div class="footerline footer-two">
      <div id="pageNums" class="pager-center"></div>
      <div class="searchline compact">
        <input type="text" id="qBottom" placeholder="아이템 이름으로 검색" />
        <button class="btn-primary" id="btnSearchBottom">검색</button>
      </div>
    </div>
  </section>
</main>

<!-- 외부 JS -->
<script src="${contextPath}/resources/js/itemDB.js"></script>
</body>
</html>
