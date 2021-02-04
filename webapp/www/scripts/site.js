var pixelToInt = (str) => parseInt(str.match( /\d+/g )[0])

var getOffsetHeight = (el) => {
  var H = 0;
  var style = window.getComputedStyle(el);
  H += pixelToInt(style.marginTop);
  console.log("mgtop " + style.marginTop);
  H += pixelToInt(style.marginBottom);
  console.log("mgbot " + style.marginBottom);
  H += pixelToInt(style.paddingTop);
  console.log("pdbot " + style.paddingTop);
  H += pixelToInt(style.paddingBottom);
  console.log("pdbot " + style.paddingBottom);
  H += pixelToInt(style.borderTopWidth);
  console.log("brdtop " + style.borderTopWidth);
  H += pixelToInt(style.borderBottomWidth);
  console.log("brdbot " + style.borderBottomWidth);
  return H;
}

var setSize = () => {
  var navbarHeight = document.getElementsByClassName("navbar")[0].offsetHeight;
  var titleHeight = document.getElementsByClassName("title")[0].offsetHeight;
  var targetDiv = document.getElementsByClassName("main-container")[0];
  var offsetH = getOffsetHeight(targetDiv);
  console.log("TOTAL OFFSET :" + offsetH);
  targetDiv.style.height = (window.innerHeight - navbarHeight - titleHeight - offsetH).toString() +"px";
}

window.onload = setSize;

window.onresize = setSize;