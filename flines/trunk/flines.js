/*
 *
 *  FLines. Just lines - "fnt0m32's lines"
 *  20.05.2006 by fnt0m32 'at' gmail.com
 *
 *  Tested on Firefox/1.5.0.3  (thank you, mozilla.org!)
 *
 */


//////////////////////////////////////////////////
// constants
//////////////////////////////////////////////////

var picExt = ".bmp";
var picEmpty = "pic/empty" + picExt;
var picEmptySel = "pic/empty_sel" + picExt;
var picBall = "pic/ball_";
var picBallSel = "pic/ball_sel_";
var aniExt = ".gif";
var aniForward = "pic/ball_anif_";
var aniBackward = "pic/ball_anib_";
var aniTime = 20*40;
var picXY = 34;

var bNone = -1;
var ballsCount = 8;
var lineSize = 5;
var ballPathStartLength = 1000;

var path = Array(Array(0,-1),Array(1,-1),Array(1,0),Array(1,1));

//////////////////////////////////////////////////
// globals
//////////////////////////////////////////////////

var fl;

//////////////////////////////////////////////////
// object 'FLines'
//////////////////////////////////////////////////

function FLines()
{
	// properties
	this.matrix = new Array();
	this.mask = new Array();
	this.sizeX = 9;
	this.sizeY = 9;
	this.selX = bNone;
	this.selY = bNone;
	this.freeCount = this.sizeX * this.sizeY;
	this.nextBalls = new Array(getNextBall(), getNextBall(), getNextBall());
	this.ballPath = new Array(new Array(),0,new Array());
	this.dx = bNone;
	this.dy = bNone;
	
	this.imgBall = new Array();
	this.imgBallSel = new Array();
	this.imgEmpty = new Array();
	
	this.aniDoing = false;
	this.aniTimer = 0;
	this.aniForward = new Array();
	this.aniBackward = new Array();
	
	this.score = 0;
	this.turns = 0;
	this.lines = 0;
	
	
	// methods
	this.init = init;
	this.newGame = newGame;
	this.nullMask = nullMask;
	this.drawBall = drawBall;
	this.getNextBall = getNextBall;
	this.nextStep = nextStep;
	this.checkLines = checkLines;
	this.showStatistics = showStatistics;
	this.aniTimerStart = aniTimerStart;
	this.aniTimerEnd = aniTimerEnd;
}

//////////////////////////////////////////////////
// implementation
//////////////////////////////////////////////////

function init()
{
	// remember self
	fl = this;
	
	with (document)
	{
		// draw body.header
		write(
			'<body bgcolor="black" marginheight="0" topmargin="0">' +
			'<p class="title">FLines. Just lines</p>' +
			'<center>'
		);
		
		// draw top
		write(
			'<table border="0" cellpadding="0" cellspacing="0">' +
				'<tr align="center" valign="middle">' +
					'<td>' +
						'<input type="button" value="Новая игра" class="push_button" onclick="newGame()">' +
					'</td>' +
					'<td class="like_body">' +
						'&nbsp;Следующие шары: ' +
					'</td>' +
					'<td>' +
						'<img src="' + picEmpty + '">' +
						'<img src="' + picEmpty + '">' +
						'<img src="' + picEmpty + '">' +
					'</td>' +
				'</tr>' +
			'</table>'
		);
		
		write('<br>');
		
		// draw grid
		write('<table border="1" cellpadding="0" cellspacing="0" class="fl_matrix">');
		for (var i=0; i<9; i++)
		{
			write('<tr align="center" valign="middle">');
			for (var j=0; j<9; j++)
				write(
					'<td class="fl_matrix" height="34" width="34">' +
					'<a onclick="click(' + j + ',' + i + ')" ' +
					'onmouseover="mouseOver(' + j + ',' + i + ')" ' +
					'onmouseout="mouseOut(' + j + ',' + i + ')">' +
					'<img src="'	+ picEmpty + '"></a></td>'
				);
			write('</tr>');
		}
		write('</table>');
		
		write('<br>');
		
		// draw bottom
		write(
			'<table border="0" cellpadding="0" cellspacing="0">' +
				'<tr align="center" valign="middle" class="like_body">' +
					'<td>' +
						'Очки:&nbsp;<input id="score" type="text" size="3" maxlength="4" class="edit_like_static">' +
					'</td>' +
					'<td>' +
						'&nbsp;Ходы:&nbsp;<input id="turns" type="text" size="3" maxlength="4" class="edit_like_static">' +
					'</td>' +
					'<td>' +
						'&nbsp;Линии:&nbsp;<input id="lines" type="text" size="3" maxlength="4" class="edit_like_static">' +
					'</td>' +
				'</tr>' +
			'</table>'
		);
		
		// help link
		write('<br><br><br><a onclick="showHelp()">Справка</a>');
		
		// draw body.footer
		write(
			'</center>' +
			'</body>'
		);
	}
	
	// prepare images
	for (var i=0; i<ballsCount; i++)
		{
			this.imgBall.push(new Image(picXY,picXY));
			this.imgBall[i].src = picBall + i + picExt;
			
			this.imgBallSel.push(new Image(picXY,picXY));
			this.imgBallSel[i].src = picBallSel + i + picExt;
			
			this.aniForward.push(new Image(picXY,picXY));
			this.aniForward[i].src = aniForward + i + aniExt;
			
			this.aniBackward.push(new Image(picXY,picXY));
			this.aniBackward[i].src = aniBackward + i + aniExt;
		}
	this.imgEmpty.push(new Image(picXY,picXY));
	this.imgEmpty.push(new Image(picXY,picXY));
	this.imgEmpty[0].src = picEmpty;
	this.imgEmpty[1].src = picEmptySel;
	
	// prepare matrix
	for (var i=0; i<this.sizeX; i++)
	{
		this.matrix.push(new Array());
		for (var j=0; j<this.sizeY; j++)
			this.matrix[i].push(bNone);
	}

	// prepare mask
	for (var i=0; i<fl.sizeX; i++)
	{
		fl.mask.push(new Array());
		for (var j=0; j<fl.sizeY; j++)
			fl.mask[i].push(0);
	}
	
	this.newGame();
}

function newGame()
{
	for (var i=0; i<fl.sizeY; i++)
		for (var j=0; j<fl.sizeX; j++)
			fl.drawBall(i,j,bNone,false,true);
	fl.score = 0;
	fl.turns = 0;
	fl.lines = 0;
	fl.selX = bNone;
	fl.selY = bNone;
	fl.freeCount = fl.sizeX * fl.sizeY;
	fl.nextBalls = Array(getNextBall(), getNextBall(), getNextBall());
	
	// do first step
	fl.nextStep();
}

function drawBall(x,y,aBall,isSelected,changeMatrix,doAni)
{
	if (aBall == bNone)
		if (isSelected)
			document.images[x+y*9+3].src = this.imgEmpty[1].src;
		else
		{
			if (doAni)
				document.images[x+y*9+3].src = this.aniBackward[this.matrix[x][y]].src;
			else
				document.images[x+y*9+3].src = this.imgEmpty[0].src;
		}
	else
		if (isSelected)
			document.images[x+y*9+3].src = this.imgBallSel[aBall].src;
		else
		{
			if (doAni)
				document.images[x+y*9+3].src = this.aniForward[aBall].src;
			else
				document.images[x+y*9+3].src = this.imgBall[aBall].src;
		}
	
	if (changeMatrix)
	{
		if (this.matrix[x][y] == bNone && aBall != bNone)
			this.freeCount--;
		if (this.matrix[x][y] != bNone && aBall == bNone)
			this.freeCount++;
		this.matrix[x][y] = aBall;
		if (aBall != bNone)
			return this.checkLines(x,y);
	}
	
	return false;
}

function getNextBall()
{
	return Math.round(Math.random() * (ballsCount-1));
}

function nextStep()
{
	// put next three balls
	this.aniTimerStart(aniTime);
	for (var i=0; i<3; i++)
		if (this.freeCount != 0)
		{
			var x,y;
			do
			{
				x = Math.round(Math.random() * (this.sizeX-1));
				y = Math.round(Math.random() * (this.sizeY-1));
			}
			while (this.matrix[x][y] != bNone);
			this.drawBall(x,y,this.nextBalls[i],false,true,true);
		}
		else
			break;
	if (this.freeCount == 0)
		alert("Игра закончена.");
	
	// generate next three balls	
	for (var j=0; j<3; j++)
	{
		this.nextBalls[j] = this.getNextBall();
		document.images[j].src = this.imgBall[this.nextBalls[j]].src;
	}
	
	// show statistics
	this.showStatistics();
}

function mouseOver(x,y)
{
	if (fl.aniDoing || (fl.selX == x && fl.selY == y))
		return;
	fl.drawBall(x,y,fl.matrix[x][y],true,false);
}

function mouseOut(x,y)
{
	if (fl.aniDoing || (fl.selX == x && fl.selY == y))
		return;
	fl.drawBall(x,y,fl.matrix[x][y],false,false);
}

function click(x,y)
{
	if (fl.aniDoing)
		return;
	if (fl.selX == x && fl.selY == y)
	{
		fl.selX = bNone;
		fl.selY = bNone;
	}
	else
	{
		if (fl.matrix[x][y] == bNone && fl.selX != bNone)
		{
			fl.dx = x;
			fl.dy = y;
			fl.ballPath[1] = ballPathStartLength;
			fl.nullMask();
			if (findPath(fl.selX,fl.selY,0))
			{
				var z = fl.matrix[fl.selX][fl.selY];
				fl.drawBall(fl.selX,fl.selY,bNone,false,true);
				fl.selX = bNone;
				fl.selY = bNone;
				if (!fl.drawBall(x,y,z,true,true))
				{
					fl.turns++;
					fl.nextStep();
				}
			}
		}
		else
		{
			if (fl.matrix[x][y] == bNone)
				return;
			else
			{
				if (fl.selX != bNone)
					fl.drawBall(fl.selX,fl.selY,fl.matrix[fl.selX][fl.selY],false,false);
				fl.selX = x;
				fl.selY = y;
			}
		}
	}
		
}

function checkLines(x,y)
{
	var checked = new Array();
	
	// check lines
	for (var i=0; i<4; i++)
	{
		var balls = 1;
		for (var j=-1; j<2; j+=2)
		{
			var cx = x + j*path[i][0], cy = y + j*path[i][1];	
			while (cx >=0 && cx < this.sizeX && cy >= 0 && cy < this.sizeY)
			{
				if (this.matrix[cx][cy] == this.matrix[x][y])
				{
					checked.push(new Array(cx,cy));
					balls++;
				}
				else
					break;
				cx += j*path[i][0];
				cy += j*path[i][1];				
			}
		}
		if (balls < lineSize)
		{
			for (var k=0; k<(balls-1); k++)
				checked.pop();
		}
		else
		{
			this.score += balls-1;
			this.lines++;
		}
	} 
	
	// kill lines
	if (checked.length > 0)
	{
		this.aniTimerStart(aniTime);
		for (var L=0; L < checked.length; L++)
			this.drawBall(checked[L][0],checked[L][1],bNone,false,true,true);
		this.score++;
		this.drawBall(x,y,bNone,false,true,true);
		this.showStatistics();
		return true;
	}
	else
		return false;
}

function nullMask()
{
	for (var i=0; i<fl.sizeX; i++)
		for (var j=0; j<fl.sizeY; j++)
			fl.mask[i][j] = 0;
}

function findPath(x,y,pathLength)
{
	if (!(x == fl.selX && y == fl.selY))
	{
		fl.ballPath[0].push(new Array(x,y));
		fl.mask[x][y] = 1;
		if (x == fl.dx && y == fl.dy)
			if (pathLength < fl.ballPath[1])
			{
				fl.ballPath[1] = pathLength;
				fl.ballPath[2] = fl.ballPath[0];	// save true path
				fl.ballPath[0].pop();
				fl.mask[x][y] = 0;
				return true;
			}
			else
				return false;
	}
	
	if (y-1 >= 0 && fl.matrix[x][y-1] == bNone && fl.mask[x][y-1] == 0)
		findPath(x,y-1,pathLength+1);
	if (x+1 < fl.sizeX && fl.matrix[x+1][y] == bNone && fl.mask[x+1][y] == 0)
		findPath(x+1,y,pathLength+1);
	if (y+1 < fl.sizeY && fl.matrix[x][y+1] == bNone && fl.mask[x][y+1] == 0)
		findPath(x,y+1,pathLength+1);
	if (x-1 >= 0 && fl.matrix[x-1][y] == bNone && fl.mask[x-1][y] == 0)
		findPath(x-1,y,pathLength+1);
		
	return (fl.ballPath[1] < ballPathStartLength) ? true : false;
}

function showStatistics()
{
	document.getElementById("score").value = this.score;
	document.getElementById("turns").value = this.turns;
	document.getElementById("lines").value = this.lines;
}

function showHelp()
{
	var wnd = window.open("","","width=400,height=300,left=20,top=200");
	with (wnd.document)
	{
		write(
			'<head>' +
			'<title>Справка</title>' +
			'<meta http-equiv="Content-Type" content="text/html; charset=windows-1251">' +
			'<link rel="stylesheet" type="text/css" href="styles.css">' +
			'</head>' +
			
			'<body bgcolor="black" marginheight="0" topmargin="0">' +
			'<p class="title">Справка</p>' +
			'Смысл игры - заработать как можно больше очков. ' +
			'Очки - это количество убраных с поля шаров. ' +
			'Шары исчезают, когда они собираются в линию из пяти или более шаров одного цвета. ' +
			'За один ход можно переместить один шар, при перемещении шар может двигаться в любом направлении, кроме диагоналей, причем путь не должен быть перекрыт другими шарами. ' +
			'Если собирается линия и шары исчезают, игроку дается дополнительный ход.' +
			'<br>' +
			'<br>' +
			'Игра проверена на базе Firefox/1.5.0.3. Не рекомендуется использование Internet Explorer.' +
			'</body>'
		);
	}
	wnd.document.close();
}

function aniTimerStart(aTime)
{
	if (fl.aniTimer == 0)
	{
		fl.aniDoing = true;
		fl.aniTimer = setInterval('aniTimerEnd()',aTime);
	}
}

function aniTimerEnd()
{
	fl.aniDoing = false;
	clearInterval(fl.aniTimer);
	fl.aniTimer = 0;
	for (var i=0; i<fl.sizeY; i++)
		for (var j=0; j<fl.sizeX; j++)
			if (fl.matrix[j][i] != bNone)
				document.images[j+i*9+3].src = fl.imgBall[fl.matrix[j][i]].src;
			else
				document.images[j+i*9+3].src = fl.imgEmpty[0].src;
}