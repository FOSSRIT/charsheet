<html>
    <title>${username} Character Sheet</title>
	<head>
		<link href='http://fonts.googleapis.com/css?family=Press+Start+2P' rel='stylesheet' type='text/css'>
		<style>
			body {
			font-family: 'Press Start 2p';
			}
			progress {
			background-color:white
			}
			progress::-webkit-progress-bar-value, progress::-webkit-progress-value,
			progress::-moz-progress-bar {background-color:black}
		</style>
	</head>
    <body>
		<h2 class="title">Username: ${username}</h2>
		<strong>Foo</strong>
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_049_star.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_048_dislikes.png')}">
			<img width="1%" src="${request.static_url('charsheet:static/icons/glyphicons_048_dislikes.png')}"><br/><br/>
		<table>
		<tr>
			<td><img src="${request.static_url('charsheet:static/icons/glyphicons_274_beer.png')}"></td>
			<td><progress value="22" max="100">
			</progress></td>
		</tr>
		<tr>
			<td><img src="${request.static_url('charsheet:static/icons/glyphicons_241_flash.png')}"></td>
			<td><progress value="22" max="100">
			</progress></td>
		</tr>
		</table>
			<img src="${request.static_url('charsheet:static/icons/glyphicons_313_ax.png')}"><progress value="22" max="100">
		</progress><br/>
			<img src="${request.static_url('charsheet:static/icons/glyphicons_022_fire.png')}"><progress value="22" max="100">
		</progress><br/>
			<img src="${request.static_url('charsheet:static/icons/glyphicons_012_heart.png')}"><progress value="22" max="100">
		</progress><br/>
			<img src="${request.static_url('charsheet:static/icons/glyphicons_308_bomb.png')}"><progress value="22" max="100">
		</progress><br/>
			<img src="${request.static_url('charsheet:static/icons/glyphicons_037_credit.png')}"><progress value="22" max="100">
		</progress>
		<h2>From: ${cwc.location}</h2>
		<h2>Endorsements: ${cwc.endorsements}</h2>
		<ul style="list-style:none">
			% for badge in cwc.badges:
				<li><img height="10%" src="${badge.image_uri}"/> ${badge.name}<br/><br/> ${badge.description}</li>
			% endfor
   </body>
</html>
