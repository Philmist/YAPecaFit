// encoding:utf-8

Highcharts.setOptions({
  global: {
    useUTC: false
  }
});
$(document).ready(function () {
  var bmi_opts = {
    chart : {
      renderTo : 'graph_bmi',  // render element id
      type : 'spline',  // graph type
    },
    credits : {
      enabled : false,
    },
    legend : {
      layout : 'vertical',
    },
    title : {
      text : 'BMIの変化',
    },
    xAxis : {
      title : {
        text : '日付',
      },
      type : 'datetime',
    },
    yAxis : {
      title : {
        text : 'BMI'
      },
    },
    series : [
      {
        data: [[0,0]],
        name: 'BMI',
      },
    ],
  };
  var target_url = '/api/bmi/' + $("#twitter_uid")[0].innerHTML;
  var uname = '' + $("#user_name")[0].innerHTML;
  $.getJSON(target_url, function(data) {
    bmi_opts.series[0].data = data;
    bmi_opts.series[0].name = uname;
    var bmi_chart = new Highcharts.Chart(bmi_opts);
  });
});
