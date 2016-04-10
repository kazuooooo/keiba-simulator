!function(t,e){function i(t,e,i){this.init.call(this,t,e,i)}var a=t.arrayMin,n=t.arrayMax,o=t.each,r=t.extend,s=t.merge,l=t.map,h=t.pick,p=t.pInt,c=t.getOptions().plotOptions,d=t.seriesTypes,u=t.extendClass,g=t.splat,f=t.wrap,m=t.Axis,y=t.Tick,v=t.Point,b=t.Pointer,x=t.TrackerMixin,w=t.CenteredSeriesMixin,A=t.Series,P=Math,M=P.round,L=P.floor,k=P.max,S=t.Color,_=function(){};r(i.prototype,{init:function(t,e,i){var a=this,n=a.defaultOptions;a.chart=e,e.angular&&(n.background={}),a.options=t=s(n,t),(t=t.background)&&o([].concat(g(t)).reverse(),function(t){var e=t.backgroundColor,t=s(a.defaultBackgroundOptions,t);e&&(t.backgroundColor=e),t.color=t.backgroundColor,i.options.plotBands.unshift(t)})},defaultOptions:{center:["50%","50%"],size:"85%",startAngle:0},defaultBackgroundOptions:{shape:"circle",borderWidth:1,borderColor:"silver",backgroundColor:{linearGradient:{x1:0,y1:0,x2:0,y2:1},stops:[[0,"#FFF"],[1,"#DDD"]]},from:Number.MIN_VALUE,innerRadius:0,to:Number.MAX_VALUE,outerRadius:"105%"}});var C=m.prototype,y=y.prototype,T={getOffset:_,redraw:function(){this.isDirty=!1},render:function(){this.isDirty=!1},setScale:_,setCategories:_,setTitle:_},R={isRadial:!0,defaultRadialGaugeOptions:{labels:{align:"center",x:0,y:null},minorGridLineWidth:0,minorTickInterval:"auto",minorTickLength:10,minorTickPosition:"inside",minorTickWidth:1,tickLength:10,tickPosition:"inside",tickWidth:2,title:{rotation:0},zIndex:2},defaultRadialXOptions:{gridLineWidth:1,labels:{align:null,distance:15,x:0,y:null},maxPadding:0,minPadding:0,showLastLabel:!1,tickLength:0},defaultRadialYOptions:{gridLineInterpolation:"circle",labels:{align:"right",x:-3,y:-2},showLastLabel:!1,title:{x:4,text:null,rotation:90}},setOptions:function(t){t=this.options=s(this.defaultOptions,this.defaultRadialOptions,t),t.plotBands||(t.plotBands=[])},getOffset:function(){C.getOffset.call(this),this.chart.axisOffset[this.side]=0,this.center=this.pane.center=w.getCenter.call(this.pane)},getLinePath:function(t,e){var i=this.center,e=h(e,i[2]/2-this.offset);return this.chart.renderer.symbols.arc(this.left+i[0],this.top+i[1],e,e,{start:this.startAngleRad,end:this.endAngleRad,open:!0,innerR:0})},setAxisTranslation:function(){C.setAxisTranslation.call(this),this.center&&(this.transA=this.isCircular?(this.endAngleRad-this.startAngleRad)/(this.max-this.min||1):this.center[2]/2/(this.max-this.min||1),this.minPixelPadding=this.isXAxis?this.transA*this.minPointOffset:0)},beforeSetTickPositions:function(){this.autoConnect&&(this.max+=this.categories&&1||this.pointRange||this.closestPointRange||0)},setAxisSize:function(){C.setAxisSize.call(this),this.isRadial&&(this.center=this.pane.center=t.CenteredSeriesMixin.getCenter.call(this.pane),this.isCircular&&(this.sector=this.endAngleRad-this.startAngleRad),this.len=this.width=this.height=this.center[2]*h(this.sector,1)/2)},getPosition:function(t,e){return this.isCircular||(e=this.translate(t),t=this.min),this.postTranslate(this.translate(t),h(e,this.center[2]/2)-this.offset)},postTranslate:function(t,e){var i=this.chart,a=this.center,t=this.startAngleRad+t;return{x:i.plotLeft+a[0]+Math.cos(t)*e,y:i.plotTop+a[1]+Math.sin(t)*e}},getPlotBandPath:function(t,e,i){var a,n=this.center,o=this.startAngleRad,r=n[2]/2,s=[h(i.outerRadius,"100%"),i.innerRadius,h(i.thickness,10)],c=/%$/,d=this.isCircular;return"polygon"===this.options.gridLineInterpolation?n=this.getPlotLinePath(t).concat(this.getPlotLinePath(e,!0)):(d||(s[0]=this.translate(t),s[1]=this.translate(e)),s=l(s,function(t){return c.test(t)&&(t=p(t,10)*r/100),t}),"circle"!==i.shape&&d?(t=o+this.translate(t),e=o+this.translate(e)):(t=-Math.PI/2,e=1.5*Math.PI,a=!0),n=this.chart.renderer.symbols.arc(this.left+n[0],this.top+n[1],s[0],s[0],{start:t,end:e,innerR:h(s[1],s[0]-s[2]),open:a})),n},getPlotLinePath:function(t,e){var i,a,n,r=this.center,s=this.chart,l=this.getPosition(t);return this.isCircular?n=["M",r[0]+s.plotLeft,r[1]+s.plotTop,"L",l.x,l.y]:"circle"===this.options.gridLineInterpolation?(t=this.translate(t))&&(n=this.getLinePath(0,t)):(i=s.xAxis[0],n=[],t=this.translate(t),r=i.tickPositions,i.autoConnect&&(r=r.concat([r[0]])),e&&(r=[].concat(r).reverse()),o(r,function(e,o){a=i.getPosition(e,t),n.push(o?"L":"M",a.x,a.y)})),n},getTitlePosition:function(){var t=this.center,e=this.chart,i=this.options.title;return{x:e.plotLeft+t[0]+(i.x||0),y:e.plotTop+t[1]-{high:.5,middle:.25,low:0}[i.align]*t[2]+(i.y||0)}}};f(C,"init",function(t,a,n){var o,l,p,c=a.angular,d=a.polar,u=n.isX,f=c&&u;p=a.options;var m=n.pane||0;c?(r(this,f?T:R),(l=!u)&&(this.defaultRadialOptions=this.defaultRadialGaugeOptions)):d&&(r(this,R),this.defaultRadialOptions=(l=u)?this.defaultRadialXOptions:s(this.defaultYAxisOptions,this.defaultRadialYOptions)),t.call(this,a,n),f||!c&&!d||(t=this.options,a.panes||(a.panes=[]),this.pane=(o=a.panes[m]=a.panes[m]||new i(g(p.pane)[m],a,this),m=o),m=m.options,a.inverted=!1,p.chart.zoomType=null,this.startAngleRad=a=(m.startAngle-90)*Math.PI/180,this.endAngleRad=p=(h(m.endAngle,m.startAngle+360)-90)*Math.PI/180,this.offset=t.offset||0,(this.isCircular=l)&&n.max===e&&p-a===2*Math.PI&&(this.autoConnect=!0))}),f(y,"getPosition",function(t,e,i,a,n){var o=this.axis;return o.getPosition?o.getPosition(i):t.call(this,e,i,a,n)}),f(y,"getLabelPosition",function(t,e,i,a,n,o,r,s,l){var p=this.axis,c=o.y,d=o.align,u=(p.translate(this.pos)+p.startAngleRad+Math.PI/2)/Math.PI*180%360;return p.isRadial?(t=p.getPosition(this.pos,p.center[2]/2+h(o.distance,-25)),"auto"===o.rotation?a.attr({rotation:u}):null===c&&(c=p.chart.renderer.fontMetrics(a.styles.fontSize).b-a.getBBox().height/2),null===d&&(d=p.isCircular?u>20&&160>u?"left":u>200&&340>u?"right":"center":"center",a.attr({align:d})),t.x+=o.x,t.y+=c):t=t.call(this,e,i,a,n,o,r,s,l),t}),f(y,"getMarkPath",function(t,e,i,a,n,o,r){var s=this.axis;return s.isRadial?(t=s.getPosition(this.pos,s.center[2]/2+a),e=["M",e,i,"L",t.x,t.y]):e=t.call(this,e,i,a,n,o,r),e}),c.arearange=s(c.area,{lineWidth:1,marker:null,threshold:null,tooltip:{pointFormat:'<span style="color:{series.color}">{series.name}</span>: <b>{point.low}</b> - <b>{point.high}</b><br/>'},trackByArea:!0,dataLabels:{verticalAlign:null,xLow:0,xHigh:0,yLow:0,yHigh:0}}),d.arearange=u(d.area,{type:"arearange",pointArrayMap:["low","high"],toYData:function(t){return[t.low,t.high]},pointValKey:"low",getSegments:function(){var t=this;o(t.points,function(e){t.options.connectNulls||null!==e.low&&null!==e.high?null===e.low&&null!==e.high&&(e.y=e.high):e.y=null}),A.prototype.getSegments.call(this)},translate:function(){var t=this.yAxis;d.area.prototype.translate.apply(this),o(this.points,function(e){var i=e.low,a=e.high,n=e.plotY;null===a&&null===i?e.y=null:null===i?(e.plotLow=e.plotY=null,e.plotHigh=t.translate(a,0,1,0,1)):null===a?(e.plotLow=n,e.plotHigh=null):(e.plotLow=n,e.plotHigh=t.translate(a,0,1,0,1))})},getSegmentPath:function(t){var e,i,a,n=[],o=t.length,r=A.prototype.getSegmentPath;a=this.options;var s=a.step;for(e=HighchartsAdapter.grep(t,function(t){return null!==t.plotLow});o--;)i=t[o],null!==i.plotHigh&&n.push({plotX:i.plotX,plotY:i.plotHigh});return t=r.call(this,e),s&&(s===!0&&(s="left"),a.step={left:"right",center:"center",right:"left"}[s]),n=r.call(this,n),a.step=s,a=[].concat(t,n),n[0]="L",this.areaPath=this.areaPath.concat(t,n),a},drawDataLabels:function(){var t,e,i=this.data,a=i.length,n=[],o=A.prototype,r=this.options.dataLabels,s=this.chart.inverted;if(r.enabled||this._hasPointLabels){for(t=a;t--;)e=i[t],e.y=e.high,e._plotY=e.plotY,e.plotY=e.plotHigh,n[t]=e.dataLabel,e.dataLabel=e.dataLabelUpper,e.below=!1,s?(r.align="left",r.x=r.xHigh):r.y=r.yHigh;for(o.drawDataLabels&&o.drawDataLabels.apply(this,arguments),t=a;t--;)e=i[t],e.dataLabelUpper=e.dataLabel,e.dataLabel=n[t],e.y=e.low,e.plotY=e._plotY,e.below=!0,s?(r.align="right",r.x=r.xLow):r.y=r.yLow;o.drawDataLabels&&o.drawDataLabels.apply(this,arguments)}},alignDataLabel:function(){d.column.prototype.alignDataLabel.apply(this,arguments)},getSymbol:d.column.prototype.getSymbol,drawPoints:_}),c.areasplinerange=s(c.arearange),d.areasplinerange=u(d.arearange,{type:"areasplinerange",getPointSpline:d.spline.prototype.getPointSpline}),function(){var t=d.column.prototype;c.columnrange=s(c.column,c.arearange,{lineWidth:1,pointRange:null}),d.columnrange=u(d.arearange,{type:"columnrange",translate:function(){var e,i=this,a=i.yAxis;t.translate.apply(i),o(i.points,function(t){var n,o=t.shapeArgs,r=i.options.minPointLength;t.plotHigh=e=a.translate(t.high,0,1,0,1),t.plotLow=t.plotY,n=e,t=t.plotY-e,r>t&&(r-=t,t+=r,n-=r/2),o.height=t,o.y=n})},trackerGroups:["group","dataLabels"],drawGraph:_,pointAttrToOptions:t.pointAttrToOptions,drawPoints:t.drawPoints,drawTracker:t.drawTracker,animate:t.animate,getColumnMetrics:t.getColumnMetrics})}(),c.gauge=s(c.line,{dataLabels:{enabled:!0,y:15,borderWidth:1,borderColor:"silver",borderRadius:3,crop:!1,style:{fontWeight:"bold"},verticalAlign:"top",zIndex:2},dial:{},pivot:{},tooltip:{headerFormat:""},showInLegend:!1}),v={type:"gauge",pointClass:u(v,{setState:function(t){this.state=t}}),angular:!0,drawGraph:_,fixedBox:!0,forceDL:!0,trackerGroups:["group","dataLabels"],translate:function(){var t=this.yAxis,e=this.options,i=t.center;this.generatePoints(),o(this.points,function(a){var n=s(e.dial,a.dial),o=p(h(n.radius,80))*i[2]/200,r=p(h(n.baseLength,70))*o/100,l=p(h(n.rearLength,10))*o/100,c=n.baseWidth||3,d=n.topWidth||1,u=e.overshoot,g=t.startAngleRad+t.translate(a.y,null,null,null,!0);u&&"number"==typeof u?(u=u/180*Math.PI,g=Math.max(t.startAngleRad-u,Math.min(t.endAngleRad+u,g))):e.wrap===!1&&(g=Math.max(t.startAngleRad,Math.min(t.endAngleRad,g))),g=180*g/Math.PI,a.shapeType="path",a.shapeArgs={d:n.path||["M",-l,-c/2,"L",r,-c/2,o,-d/2,o,d/2,r,c/2,-l,c/2,"z"],translateX:i[0],translateY:i[1],rotation:g},a.plotX=i[0],a.plotY=i[1]})},drawPoints:function(){var t=this,e=t.yAxis.center,i=t.pivot,a=t.options,n=a.pivot,r=t.chart.renderer;o(t.points,function(e){var i=e.graphic,n=e.shapeArgs,o=n.d,l=s(a.dial,e.dial);i?(i.animate(n),n.d=o):e.graphic=r[e.shapeType](n).attr({stroke:l.borderColor||"none","stroke-width":l.borderWidth||0,fill:l.backgroundColor||"black",rotation:n.rotation}).add(t.group)}),i?i.animate({translateX:e[0],translateY:e[1]}):t.pivot=r.circle(0,0,h(n.radius,5)).attr({"stroke-width":n.borderWidth||0,stroke:n.borderColor||"silver",fill:n.backgroundColor||"black"}).translate(e[0],e[1]).add(t.group)},animate:function(t){var e=this;t||(o(e.points,function(t){var i=t.graphic;i&&(i.attr({rotation:180*e.yAxis.startAngleRad/Math.PI}),i.animate({rotation:t.shapeArgs.rotation},e.options.animation))}),e.animate=null)},render:function(){this.group=this.plotGroup("group","series",this.visible?"visible":"hidden",this.options.zIndex,this.chart.seriesGroup),A.prototype.render.call(this),this.group.clip(this.chart.clipRect)},setData:function(t,e){A.prototype.setData.call(this,t,!1),this.processData(),this.generatePoints(),h(e,!0)&&this.chart.redraw()},drawTracker:x.drawTrackerPoint},d.gauge=u(d.line,v),c.boxplot=s(c.column,{fillColor:"#FFFFFF",lineWidth:1,medianWidth:2,states:{hover:{brightness:-.3}},threshold:null,tooltip:{pointFormat:'<span style="color:{series.color};font-weight:bold">{series.name}</span><br/>Maximum: {point.high}<br/>Upper quartile: {point.q3}<br/>Median: {point.median}<br/>Lower quartile: {point.q1}<br/>Minimum: {point.low}<br/>'},whiskerLength:"50%",whiskerWidth:2}),d.boxplot=u(d.column,{type:"boxplot",pointArrayMap:["low","q1","median","q3","high"],toYData:function(t){return[t.low,t.q1,t.median,t.q3,t.high]},pointValKey:"high",pointAttrToOptions:{fill:"fillColor",stroke:"color","stroke-width":"lineWidth"},drawDataLabels:_,translate:function(){var t=this.yAxis,e=this.pointArrayMap;d.column.prototype.translate.apply(this),o(this.points,function(i){o(e,function(e){null!==i[e]&&(i[e+"Plot"]=t.translate(i[e],0,1,0,1))})})},drawPoints:function(){var t,i,a,n,r,s,l,p,c,d,u,g,f,m,y,v,b,x,w,A,P,k,S=this,_=S.points,C=S.options,T=S.chart.renderer,R=S.doQuartiles!==!1,Y=parseInt(S.options.whiskerLength,10)/100;o(_,function(o){c=o.graphic,P=o.shapeArgs,u={},m={},v={},k=o.color||S.color,o.plotY!==e&&(t=o.pointAttr[o.selected?"selected":""],b=P.width,x=L(P.x),w=x+b,A=M(b/2),i=L(R?o.q1Plot:o.lowPlot),a=L(R?o.q3Plot:o.lowPlot),n=L(o.highPlot),r=L(o.lowPlot),u.stroke=o.stemColor||C.stemColor||k,u["stroke-width"]=h(o.stemWidth,C.stemWidth,C.lineWidth),u.dashstyle=o.stemDashStyle||C.stemDashStyle,m.stroke=o.whiskerColor||C.whiskerColor||k,m["stroke-width"]=h(o.whiskerWidth,C.whiskerWidth,C.lineWidth),v.stroke=o.medianColor||C.medianColor||k,v["stroke-width"]=h(o.medianWidth,C.medianWidth,C.lineWidth),v["stroke-linecap"]="round",l=u["stroke-width"]%2/2,p=x+A+l,d=["M",p,a,"L",p,n,"M",p,i,"L",p,r,"z"],R&&(l=t["stroke-width"]%2/2,p=L(p)+l,i=L(i)+l,a=L(a)+l,x+=l,w+=l,g=["M",x,a,"L",x,i,"L",w,i,"L",w,a,"L",x,a,"z"]),Y&&(l=m["stroke-width"]%2/2,n+=l,r+=l,f=["M",p-A*Y,n,"L",p+A*Y,n,"M",p-A*Y,r,"L",p+A*Y,r]),l=v["stroke-width"]%2/2,s=M(o.medianPlot)+l,y=["M",x,s,"L",w,s,"z"],c?(o.stem.animate({d:d}),Y&&o.whiskers.animate({d:f}),R&&o.box.animate({d:g}),o.medianShape.animate({d:y})):(o.graphic=c=T.g().add(S.group),o.stem=T.path(d).attr(u).add(c),Y&&(o.whiskers=T.path(f).attr(m).add(c)),R&&(o.box=T.path(g).attr(t).add(c)),o.medianShape=T.path(y).attr(v).add(c)))})}}),c.errorbar=s(c.boxplot,{color:"#000000",grouping:!1,linkedTo:":previous",tooltip:{pointFormat:'<span style="color:{series.color}">{series.name}</span>: <b>{point.low}</b> - <b>{point.high}</b><br/>'},whiskerWidth:null}),d.errorbar=u(d.boxplot,{type:"errorbar",pointArrayMap:["low","high"],toYData:function(t){return[t.low,t.high]},pointValKey:"high",doQuartiles:!1,drawDataLabels:d.arearange?d.arearange.prototype.drawDataLabels:_,getColumnMetrics:function(){return this.linkedParent&&this.linkedParent.columnMetrics||d.column.prototype.getColumnMetrics.call(this)}}),c.waterfall=s(c.column,{lineWidth:1,lineColor:"#333",dashStyle:"dot",borderColor:"#333"}),d.waterfall=u(d.column,{type:"waterfall",upColorProp:"fill",pointArrayMap:["low","y"],pointValKey:"y",init:function(t,e){e.stacking=!0,d.column.prototype.init.call(this,t,e)},translate:function(){var t,e,i,a,n,o,r,s,l,h=this.options,p=this.yAxis;for(t=h.threshold,h=h.borderWidth%2/2,d.column.prototype.translate.apply(this),s=t,i=this.points,e=0,t=i.length;t>e;e++)a=i[e],n=a.shapeArgs,o=this.getStack(e),l=o.points[this.index],isNaN(a.y)&&(a.y=this.yData[e]),r=k(s,s+a.y)+l[0],n.y=p.translate(r,0,1),a.isSum||a.isIntermediateSum?(n.y=p.translate(l[1],0,1),n.height=p.translate(l[0],0,1)-n.y):s+=o.total,n.height<0&&(n.y+=n.height,n.height*=-1),a.plotY=n.y=M(n.y)-h,n.height=M(n.height),a.yBottom=n.y+n.height},processData:function(t){var e,i,a,n,o,r,s,l=this.yData,h=this.points,p=l.length,c=this.options.threshold||0;for(a=i=n=o=c,s=0;p>s;s++)r=l[s],e=h&&h[s]?h[s]:{},"sum"===r||e.isSum?l[s]=a:"intermediateSum"===r||e.isIntermediateSum?(l[s]=i,i=c):(a+=r,i+=r),n=Math.min(a,n),o=Math.max(a,o);A.prototype.processData.call(this,t),this.dataMin=n,this.dataMax=o},toYData:function(t){return t.isSum?"sum":t.isIntermediateSum?"intermediateSum":t.y},getAttribs:function(){d.column.prototype.getAttribs.apply(this,arguments);var e=this.options,i=e.states,a=e.upColor||this.color,e=t.Color(a).brighten(.1).get(),n=s(this.pointAttr),r=this.upColorProp;n[""][r]=a,n.hover[r]=i.hover.upColor||e,n.select[r]=i.select.upColor||a,o(this.points,function(t){t.y>0&&!t.color&&(t.pointAttr=n,t.color=a)})},getGraphPath:function(){var t,e,i,a=this.data,n=a.length,o=M(this.options.lineWidth+this.options.borderWidth)%2/2,r=[];for(i=1;n>i;i++)e=a[i].shapeArgs,t=a[i-1].shapeArgs,e=["M",t.x+t.width,t.y+o,"L",e.x,t.y+o],a[i-1].y<0&&(e[2]+=t.height,e[5]+=t.height),r=r.concat(e);return r},getExtremes:_,getStack:function(t){var e=this.yAxis.stacks,i=this.stackKey;return this.processedYData[t]<this.options.threshold&&(i="-"+i),e[i][t]},drawGraph:A.prototype.drawGraph}),c.bubble=s(c.scatter,{dataLabels:{inside:!0,style:{color:"white",textShadow:"0px 0px 3px black"},verticalAlign:"middle"},marker:{lineColor:null,lineWidth:1},minSize:8,maxSize:"20%",tooltip:{pointFormat:"({point.x}, {point.y}), Size: {point.z}"},turboThreshold:0,zThreshold:0}),d.bubble=u(d.scatter,{type:"bubble",pointArrayMap:["y","z"],parallelArrays:["x","y","z"],trackerGroups:["group","dataLabelsGroup"],bubblePadding:!0,pointAttrToOptions:{stroke:"lineColor","stroke-width":"lineWidth",fill:"fillColor"},applyOpacity:function(t){var e=this.options.marker,i=h(e.fillOpacity,.5),t=t||e.fillColor||this.color;return 1!==i&&(t=S(t).setOpacity(i).get("rgba")),t},convertAttribs:function(){var t=A.prototype.convertAttribs.apply(this,arguments);return t.fill=this.applyOpacity(t.fill),t},getRadii:function(t,e,i,a){var n,o,r,s=this.zData,l=[],h="width"!==this.options.sizeBy;for(o=0,n=s.length;n>o;o++)r=e-t,r=r>0?(s[o]-t)/(e-t):.5,h&&r>=0&&(r=Math.sqrt(r)),l.push(P.ceil(i+r*(a-i))/2);this.radii=l},animate:function(t){var e=this.options.animation;t||(o(this.points,function(t){var i=t.graphic,t=t.shapeArgs;i&&t&&(i.attr("r",1),i.animate({r:t.r},e))}),this.animate=null)},translate:function(){var t,i,a,n=this.data,o=this.radii;for(d.scatter.prototype.translate.call(this),t=n.length;t--;)i=n[t],a=o?o[t]:0,i.negative=i.z<(this.options.zThreshold||0),a>=this.minPxSize/2?(i.shapeType="circle",i.shapeArgs={x:i.plotX,y:i.plotY,r:a},i.dlBox={x:i.plotX-a,y:i.plotY-a,width:2*a,height:2*a}):i.shapeArgs=i.plotY=i.dlBox=e},drawLegendSymbol:function(t,e){var i=p(t.itemStyle.fontSize)/2;e.legendSymbol=this.chart.renderer.circle(i,t.baseline-i,i).attr({zIndex:3}).add(e.legendGroup),e.legendSymbol.isMarker=!0},drawPoints:d.column.prototype.drawPoints,alignDataLabel:d.column.prototype.alignDataLabel}),m.prototype.beforePadding=function(){var t=this,i=this.len,r=this.chart,s=0,l=i,c=this.isXAxis,d=c?"xData":"yData",u=this.min,g={},f=P.min(r.plotWidth,r.plotHeight),m=Number.MAX_VALUE,y=-Number.MAX_VALUE,v=this.max-u,b=i/v,x=[];this.tickPositions&&(o(this.series,function(e){var i=e.options;!e.bubblePadding||!e.visible&&r.options.chart.ignoreHiddenSeries||(t.allowZoomOutside=!0,x.push(e),c&&(o(["minSize","maxSize"],function(t){var e=i[t],a=/%$/.test(e),e=p(e);g[t]=a?f*e/100:e}),e.minPxSize=g.minSize,e=e.zData,e.length&&(m=P.min(m,P.max(a(e),i.displayNegative===!1?i.zThreshold:-Number.MAX_VALUE)),y=P.max(y,n(e)))))}),o(x,function(t){var e,i=t[d],a=i.length;if(c&&t.getRadii(m,y,g.minSize,g.maxSize),v>0)for(;a--;)"number"==typeof i[a]&&(e=t.radii[a],s=Math.min((i[a]-u)*b-e,s),l=Math.max((i[a]-u)*b+e,l))}),x.length&&v>0&&h(this.options.min,this.userMin)===e&&h(this.options.max,this.userMax)===e&&(l-=i,b*=(i+s-l)/i,this.min+=s/b,this.max+=l/b))},function(){function t(t,e,i){t.call(this,e,i),this.chart.polar&&(this.closeSegment=function(t){var e=this.xAxis.center;t.push("L",e[0],e[1])},this.closedStacks=!0)}function e(t,e){var i=this.chart,a=this.options.animation,n=this.group,o=this.markerGroup,r=this.xAxis.center,s=i.plotLeft,l=i.plotTop;i.polar?i.renderer.isSVG&&(a===!0&&(a={}),e?(i={translateX:r[0]+s,translateY:r[1]+l,scaleX:.001,scaleY:.001},n.attr(i),o&&(o.attrSetters=n.attrSetters,o.attr(i))):(i={translateX:s,translateY:l,scaleX:1,scaleY:1},n.animate(i,a),o&&o.animate(i,a),this.animate=null)):t.call(this,e)}var i,a=A.prototype,n=b.prototype;a.toXY=function(t){var e,i=this.chart,a=t.plotX;e=t.plotY,t.rectPlotX=a,t.rectPlotY=e,a=(a/Math.PI*180+this.xAxis.pane.options.startAngle)%360,0>a&&(a+=360),t.clientX=a,e=this.xAxis.postTranslate(t.plotX,this.yAxis.len-e),t.plotX=t.polarPlotX=e.x-i.plotLeft,t.plotY=t.polarPlotY=e.y-i.plotTop},a.orderTooltipPoints=function(t){this.chart.polar&&(t.sort(function(t,e){return t.clientX-e.clientX}),t[0])&&(t[0].wrappedClientX=t[0].clientX+360,t.push(t[0]))},d.area&&f(d.area.prototype,"init",t),d.areaspline&&f(d.areaspline.prototype,"init",t),d.spline&&f(d.spline.prototype,"getPointSpline",function(t,e,i,a){var n,o,r,s,l,h,p;return this.chart.polar?(n=i.plotX,o=i.plotY,t=e[a-1],r=e[a+1],this.connectEnds&&(t||(t=e[e.length-2]),r||(r=e[1])),t&&r&&(s=t.plotX,l=t.plotY,e=r.plotX,h=r.plotY,s=(1.5*n+s)/2.5,l=(1.5*o+l)/2.5,r=(1.5*n+e)/2.5,p=(1.5*o+h)/2.5,e=Math.sqrt(Math.pow(s-n,2)+Math.pow(l-o,2)),h=Math.sqrt(Math.pow(r-n,2)+Math.pow(p-o,2)),s=Math.atan2(l-o,s-n),l=Math.atan2(p-o,r-n),p=Math.PI/2+(s+l)/2,Math.abs(s-p)>Math.PI/2&&(p-=Math.PI),s=n+Math.cos(p)*e,l=o+Math.sin(p)*e,r=n+Math.cos(Math.PI+p)*h,p=o+Math.sin(Math.PI+p)*h,i.rightContX=r,i.rightContY=p),a?(i=["C",t.rightContX||t.plotX,t.rightContY||t.plotY,s||n,l||o,n,o],t.rightContX=t.rightContY=null):i=["M",n,o]):i=t.call(this,e,i,a),i}),f(a,"translate",function(t){if(t.call(this),this.chart.polar&&!this.preventPostTranslate)for(var t=this.points,e=t.length;e--;)this.toXY(t[e])}),f(a,"getSegmentPath",function(t,e){var i=this.points;return this.chart.polar&&this.options.connectEnds!==!1&&e[e.length-1]===i[i.length-1]&&null!==i[0].y&&(this.connectEnds=!0,e=[].concat(e,[i[0]])),t.call(this,e)}),f(a,"animate",e),f(a,"setTooltipPoints",function(t,e){return this.chart.polar&&r(this.xAxis,{tooltipLen:360}),t.call(this,e)}),d.column&&(i=d.column.prototype,f(i,"animate",e),f(i,"translate",function(t){var e,i,a=this.xAxis,n=this.yAxis.len,o=a.center,r=a.startAngleRad,s=this.chart.renderer;if(this.preventPostTranslate=!0,t.call(this),a.isRadial)for(a=this.points,i=a.length;i--;)e=a[i],t=e.barX+r,e.shapeType="path",e.shapeArgs={d:s.symbols.arc(o[0],o[1],n-e.plotY,null,{start:t,end:t+e.pointWidth,innerR:n-h(e.yBottom,n)})},this.toXY(e)}),f(i,"alignDataLabel",function(t,e,i,n,o,r){this.chart.polar?(t=e.rectPlotX/Math.PI*180,null===n.align&&(n.align=t>20&&160>t?"left":t>200&&340>t?"right":"center"),null===n.verticalAlign&&(n.verticalAlign=45>t||t>315?"bottom":t>135&&225>t?"top":"middle"),a.alignDataLabel.call(this,e,i,n,o,r)):t.call(this,e,i,n,o,r)})),f(n,"getIndex",function(t,e){var i,a,n=this.chart;return n.polar?(a=n.xAxis[0].center,i=e.chartX-a[0]-n.plotLeft,n=e.chartY-a[1]-n.plotTop,i=180-Math.round(Math.atan2(i,n)/Math.PI*180)):i=t.call(this,e),i}),f(n,"getCoordinates",function(t,e){var i=this.chart,a={xAxis:[],yAxis:[]};return i.polar?o(i.axes,function(t){var n=t.isXAxis,o=t.center,r=e.chartX-o[0]-i.plotLeft,o=e.chartY-o[1]-i.plotTop;a[n?"xAxis":"yAxis"].push({axis:t,value:t.translate(n?Math.PI-Math.atan2(r,o):Math.sqrt(Math.pow(r,2)+Math.pow(o,2)),!0)})}):a=t.call(this,e),a})}()}(Highcharts);