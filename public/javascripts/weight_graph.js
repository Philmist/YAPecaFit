
$(document).ready(function () {
  var target_url = '/api/weight/' + $("#twitter_uid")[0].innerHTML;
  var uname = '' + $("#user_name")[0].innerHTML;
  
  // d3.js opts
  var margin = { top: 20, right: 80, bottom: 30, left: 50 };
  var width = 960 - margin.left - margin.right;
  var height = 700 - margin.top - margin.bottom;

  var x = d3.time.scale().range([0, width]);
  var y = d3.scale.linear().range([height, 0]);

  var color = d3.scale.category10();

  var xAxis = d3.svg.axis().scale(x).orient("bottom");
  var yAxis = d3.svg.axis().scale(y).orient("left");

  var svg = d3.select("#graph").append("svg")
    .attr("width", width + margin.left + margin.right)
    .attr("height", height + margin.top + margin.bottom)
    .append("g")
    .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

  d3.json(target_url, function(err, data) {

    y.domain([0, d3.max(data, function(d) { return d[1]; })]);  // weight
    x.domain(d3.extent(data, function(d) { return d[0]; }));  // date

    var line = d3.svg.line().x(function(d) {
      console.log("Plotting x: "+ d[0]);
      return x(d[0]);
    })
    .y(function(d) {
      console.log("Plotting y: "+ d[1]);
      return y(d[1]);
    }
    );

    // Render x axis
    svg.append("g").attr("class", "x axis").attr("transform", "translate(0,"+height+")").call(xAxis);

    // Render y axis
    svg.append("g")
    .attr("class", "y axis")
    .call(yAxis)
    .append("text")
    .attr("transform", "rotate(-90)")
    .attr("y", 6)
    .attr("dy", ".71em")
    .style("text-anchor", "end")
    .text("体重(kg)");

    // Render tooltip
    var tooltip = d3.select("#graph")
      .append("div")
      .attr("class", "tooltip")
      .style("position", "absolute")
      .style("z-index", "10")
      .style("visibility", "hidden")
      .text("tooltip");

    // Render data
    svg.append("path").attr("d", line(data));

  });

});
