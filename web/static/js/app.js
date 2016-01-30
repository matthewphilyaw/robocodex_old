import "deps/phoenix_html/web/static/js/phoenix_html"
import socket from "./socket"

function drawBot(ctx, p) {
  var radar_r = 100;

  var preLineWidth = ctx.lineWidth;
  var preStroke = ctx.strokeStyle;
  ctx.lineWidth = 2;
  ctx.strokeStyle = 'black';
  ctx.setLineDash([]);
  ctx.beginPath();
  ctx.arc(p.x, p.y, 20, 0, Math.PI * 2, true);
  ctx.stroke();

  var preText = ctx.textAlign;
  var preBase = ctx.textBaseline;
  ctx.lineWidth = 1;
  ctx.textAlign = 'center';
  ctx.textBaseline = 'middle';
  ctx.strokeText(p.name, p.x, p.y);
  ctx.textAlign = preText;
  ctx.textBaseline = ctx.textBaseline;
  ctx.lineWidth = preLineWidth;
  /*
  ctx.beginPath();
  ctx.strokeStyle = 'red';
  ctx.setLineDash([10]);
  ctx.arc(p.x, p.y, radar_r, 0, Math.PI * 2, true);
  ctx.stroke();
  ctx.strokeStyle = 'black'
  ctx.setLineDash([]);
  */
}

function draw(bots) {
  var canvas = document.getElementById('canvas');
  if (canvas.getContext) {
    var ctx = canvas.getContext('2d');

    ctx.clearRect(0,0,600,600);
    ctx.fillStyle = 'white';
    ctx.fillRect(0,0,600,600);
    ctx.fillStyle = 'black'
    ctx.strokeRect(0,0,600,600);


    for (var i = 0; i < bots.length; i++) {
      drawBot(ctx, bots[i]);
    }
  }
}

socket.on("frame", payload => {
  draw(payload.bots)
});
