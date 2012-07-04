<html>
 <head>
     <title>${username} Application</title>
 </head>
   <body>
   <h2 class="title">Username: <code>${username}</code></h2>
   <h2>From: ${cwc.location}</h2>
   <h2>Endorsements: ${cwc.endorsements}</h2>
   <ul style="list-style:none">
% for badge in cwc.badges:
	<li><img height="5%" src="${badge.image_uri}"/> ${badge.name}<br/> ${badge.description}</li>
% endfor
   </body>
 </html>
