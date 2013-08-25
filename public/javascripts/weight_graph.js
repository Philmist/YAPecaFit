// encoding:utf-8

Highcharts.setOptions({
  global: {
    useUTC: false
  }
};

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
    series : [{}],
  };

  var url = '/api/weight/' + document.getElementById("twitter_uid");
  $.getJSON(url, function(data) {
    opts.series[0].data = data;
    var chart = new Highcharts.Chart(opts);
  });
});

