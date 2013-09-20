// encoding:utf-8

Highcharts.setOptions({
  global: {
    useUTC: false
  }
});
$(document).ready(function () {
  var opts = {
    chart : {
      renderTo : 'graph',  // render element id
      type : 'spline',  // graph type
    },
    credits : {
      enabled : false,
    },
    legend : {
      layout : 'vertical',
    },
    title : {
      text : '体重の変化',
    },
    xAxis : {
      title : {
        text : '日付',
      },
      type : 'datetime',
    },
    yAxis : {
      title : {
        text : '体重'
      },
    },
    series : [
      {
      },
    ],
  };
  var target_url = '/api/weight/' + $("#twitter_uid")[0].innerHTML;
  var uname = $("#name")[0].innerHTML;
  $.getJSON(target_url, function(data) {
    opts.series[0].data = data;
    opts.series[0].name = uname;
    var chart = new Highcharts.Chart(opts);
  });
});
