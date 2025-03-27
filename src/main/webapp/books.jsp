<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>도서 관리</title>
</head>
<body>
    <h1>도서 관리</h1>
    
    <table>
        <thead>
            <tr><th>bookId</th><th>bookName</th><th>publisher</th><th>price</th></tr>
        </thead>
        <tbody id="bookTbody">              
        </tbody>
    </table>
    <hr>
    <form>
        <input type="text" name="bookId" id="bookId"></input><br>
        <input type="text" name="bookName" id="bookName"></input><br>
        <input type="text" name="publisher" id="publisher"></input><br>
        <input type="text" name="price" id="price"></input><br>
    </form>
    <hr>
    <button type="button" id="btnInsert">등록</button> <button type="button" id="btnUpdate">수정</button> <button type="button" id="btnDelete">삭제</button>
    
    <script>
        window.onload = function(){
            listBook();
            
            document.querySelector("#btnInsert").onclick = insertBook;
            document.querySelector("#btnUpdate").onclick = updateBook;
            document.querySelector("#btnDelete").onclick = deleteBook;
        }   
        
        async function listBook(){
            
            let url = '/BookManagerAjax/books/list';
            try{
                let response = await fetch(url); // get 요청 json 포함 응답
                let data = await response.json(); // response 에서 json 꺼내서 javascript 객체로 변환
                
                makeListHtml(data); // javascript 객체를 이용해서 table 에 목록 구성
                
            }catch(error){
                console.log(error);
                alert('도서 목록 처리 중 오류 발생!');
            }           
        }
        
        <%-- ${}  --%>
        // 백틱 (`) : 두 백틱 사이의 멀티라인의 문자열을 허락
        // \${el.bookId} : 문자열 사이에 자바스크립트 객체의 값을 전달 => 1, 2, 3, 
        // 위 2개 모두 문자열 연결 + 처리하는 불편 해소
        // \${} ?? <= // jsp el 충동 방지
        async function makeListHtml(list){
            console.log(list);
            
            let listHTML = ``;
            list.forEach( el => {
                
                listHTML +=
                    `<tr style="cursor:pointer" data-bookId=\${el.bookId}>
                        <td>\${el.bookId}</td>
                        <td>\${el.bookName}</td>
                        <td>\${el.publisher}</td>
                        <td>\${el.price}</td>
                    </tr>`;
                
            } );
            
            document.querySelector("#bookTbody").innerHTML = listHTML;
                        
            document.querySelectorAll("#bookTbody tr").forEach( el => {
                el.onclick = function(){
                    let bookId = this.getAttribute("data-bookId");    
                    detailBook(bookId);
                }
            });
        }   
        
        async function detailBook(bookId){
            let url = '/BookManagerAjax/books/detail?bookId=' + bookId;
            try{
                let response = await fetch(url);
                let data = await response.json();       
                console.log(data);
                
                document.querySelector("#bookId").value = data.bookId;
                document.querySelector("#bookName").value = data.bookName;
                document.querySelector("#publisher").value = data.publisher;
                document.querySelector("#price").value = data.price;
                
            }catch( error ){
                console.error( error );
                alert('도서 상세 처리 중 오류 발생!');
            }           
        }   
        
        async function insertBook(){
            let urlParams = new URLSearchParams({  // post 전송 방식 중 x-www-url-encoded 방식
                bookId: document.querySelector("#bookId").value,
                bookName: document.querySelector("#bookName").value,
                publisher: document.querySelector("#publisher").value,
                price: document.querySelector("#price").value,
            });
            
            let fetchOptions = {
                method: "POST",
                body: urlParams,
            }
            
            let url = '/BookManagerAjax/books/insert';
            
            try{
                let response = await fetch(url, fetchOptions );
                let data = await response.json();
                
                console.log(data);
                
                if( data.result == "success" ){
                    alert('도서 등록!');
                }else {
                    alert('도서 등록 실패!');
                }
                                
                listBook();
                
            }catch( error ){
                console.error( error );
                alert('도서 등록 처리 중 오류 발생!');
            }           
        }
        
        async function updateBook(){
            let urlParams = new URLSearchParams({
                bookId: document.querySelector("#bookId").value,
                bookName: document.querySelector("#bookName").value,
                publisher: document.querySelector("#publisher").value,
                price: document.querySelector("#price").value,
            });
            
            let fetchOptions = {
                method: "POST",
                body: urlParams,
            }
            
            let url = '/BookManagerAjax/books/update';
            
            try{
                let response = await fetch(url, fetchOptions );
                let data = await response.json();
                
                console.log(data);
                
                if( data.result == "success" ){
                    alert('도서 수정!');
                }else {
                    alert('도서 수정 실패!');
                }
                
                listBook();
                
            }catch( error ){
                console.error( error );
                alert('도서 수정 처리 중 오류 발생!');
            }               
        }
        
        async function deleteBook(){
            let bookId = document.querySelector("#bookId").value;
            let url = '/BookManagerAjax/books/delete?bookId=' + bookId;
            try{
                let response = await fetch(url);
                let data = await response.json();       
                console.log(data);
                
                if( data.result == "success" ){
                    alert('도서 삭제!');
                }else {
                    alert('도서 삭제 실패!');
                }
                
                listBook();
                
            }catch( error ){
                console.error( error );
                alert('도서 삭제 처리 중 오류 발생!');
            }               
        }
    </script>
</body>
</html>