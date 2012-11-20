$(document).ready($(function () {
    /*****************************************
    * Globals
    ******************************************/
    var placeholder = $("#year-graph");
    var base_power = gon.overall_power_for
    var flag = 0;

    //set it off
     main();

    /*****************************************
    * Main functions
    ******************************************/
    function main () {
        plot_graphs();
        //plot_google();
        real_time_update();
        initialize();
    }
     //start real time update of solar output

    /*****************************************
    * Graphing (Flot)
    ******************************************/

    function plot_graphs(){
      // draw canvas
      function doThis(flag, data) {
        if (flag) {
          $.plot(placeholder,[{label: "Solar output (Wh)", data: data}], options);
        }
        else{
          $.plot(placeholder,[{label: "Solar output (kWh)", data: data}], options);
        }
      } 

     var xyData = gon.monthTotals;

     var data = xyData;
     var options = {
          //lines: {show:true},
          points: {show:false},
          legend: {position: 'ne',
          },
          bars: {show:true,
            align: "center",
            barWidth: 21*(24 * 60 * 60 * 1000),
            lineWidth:0,
            fillColor: "rgba(68, 177, 217, 0.75)"}, //#*day
          xaxis: {
            mode: "time",
            timeformat: "%b",
            monthNames: ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"],
            tickLength:0,
          },
          grid: {hoverable:true, 
                clickable:true, 
                autohighlight:true},
          yaxis: {
            show:true,
            tickLength:0
          },
        };

        // first plot
        doThis(flag, data);

        //button listeners
      $('#day').click(function(){
        flag = 1; //to switch to Wh in label

        data = switchProf(0);

        console.log(data)

        options.lines = {show: false};
        options.bars.barWidth = 0.035*(24 * 60 * 60 * 1000);
        options.xaxis = {
          mode: "time", 
          twelveHourClock: true, 
          tickLength: 0};

        doThis(flag, data);
      });

      $('#month').click(function(){
        flag = 0;

        data = switchProf(1);
        options.bars.show = true;
        options.lines.show = false;
        options.bars.barWidth = 0.8*(24 * 60 * 60 * 1000);
        options.xaxis.timeformat = "%b-%d";
        options.xaxis.dayNames = ["Mon", "Tue", "Wed", "Thu", "Fri", "Sat", "Sun"];

        doThis(flag, data);
      });

      $('#year').click(function(){
        flag = 0;

        data = switchProf(2);
        options.bars.barWidth = 21*(24 * 60 * 60 * 1000);
        options.bars.show = true;
        options.lines.show = false;
        options.xaxis.timeformat = "%b";
        options.xaxis.monthNames = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"];

        doThis(flag, data);
      });

      //function to switch on button press
      function switchProf(timeGran) {
        var dataReturn = [];
          switch (timeGran) {
            case 0:    //day
              dataReturn = gon.dayTotals
              break;
            case 1:    //month
              dataReturn = gon.weekTotals
              break;
            case 2:    //year
              dataReturn = gon.monthTotals
              break;
          }

          return dataReturn;
      }
    }

   /*****************************************
    * Event listeners
    *****************************************/

  // hovering over the plot

    function showTooltip(x, y, contents) {
        $('<div id="tooltip">' + contents + '</div>').css( {
            position: 'absolute',
            display: 'none',
            top: y - 30,
            left: x + 5,
            border: '1px solid black',
            padding: '2px',
            'background-color': 'black',
            'color': 'white',
            opacity: 0.80
        }).appendTo("body").fadeIn(200);
    }

    placeholder.bind("plothover", function (event, pos, item) {
          if (item) {
              if (previousPoint != item.dataIndex) {
                  previousPoint = item.dataIndex;
                  
                  $("#tooltip").remove();
                  var x = item.datapoint[0].toFixed(2),
                      y = item.datapoint[1].toFixed(2);
                  
                  if (flag==0){
                    showTooltip(item.pageX, item.pageY,
                              y + " kWh");
                  }
                  else {
                    showTooltip(item.pageX, item.pageY,
                              y + " Wh");
                  }
              }
          }
          else {
              $("#tooltip").remove();
              previousPoint = null;            
          }
    });

    /*****************************************
    * Graphing (Google)
    ******************************************/
      google.setOnLoadCallback(drawChart);

      function drawChart(solar_output) {
        var data = google.visualization.arrayToDataTable([
          ['Label', 'Value'],
          ['Energy', solar_output],
        ]);

        var formatter = new google.visualization.NumberFormat(
        {fractionDigits:2, suffix: ' Wh'});
        formatter.format(data, 1); // Apply formatter to second column

        var options = {
          width: 200, height: 300,
          //redFrom: 90, redTo: 100,
          //yellowFrom:75, yellowTo: 90,
          minorTicks: 5,
          max: 220,
          animation: {
            duration: 400,
          }
        };

        var chart = new google.visualization.Gauge(document.getElementById('chart_div'));
        chart.draw(data, options);
      }

    /*****************************************
    * "Real time" updates
    *****************************************/

    function real_time_update(){
      setTimeout(real_time_update,5000);
      var time = Math.round(((new Date()).getTime())/1000);

      var targetURL = "get/user_data?time_now="+time+"&user_id="+gon.user.id+"&panel_id="+gon.panel;
      // first call to get data right now

      var power_before = 0;
      var power_after = 0;

      $.get(targetURL, function(data){
        power_before = data.before[0].power; 
        power_after = data.after[0].power;

        // after getting data before and after, find increment between them, delta-naught
        var delta = power_after - power_before;

        // scale before power by a percentage based on how much time has elapsed since last hour
        var current_time = new Date();
        var minutes_passed = (current_time.getMinutes())*60;
        var seconds_passed = minutes_passed + (current_time.getSeconds());
        var percent_hour = seconds_passed/3600;

        //calculate increment
        var delta_change = delta*percent_hour;

        console.log(time + "Before it was "+power_before+", now it is "+power_after+" with increments of "+delta_change)

        //add to power_before and update html component
        var power_update = power_before + delta_change;

        drawChart(power_update);

        //update other components
        var overall_power_increment = power_update*((5/60)/60); // P*delta_t = power_update * (5 seconds/60 seconds)/60 minutes (aka percentage of the hour)
        var overall_money_increment = (0.126/1000)*overall_power_increment;
        var overall_emissions_increment = 0.00069*overall_power_increment; 

        if (base_power != gon.overall_power_for) {
          base_power = gon.overall_power_for;
        }

        var overall_power = base_power + overall_power_increment;
        overall_power = overall_power/1000;

        var overall_money = base_power*(0.126/1000) + overall_money_increment;

        var overall_emissions = base_power*(0.00069) + overall_emissions_increment;

        $('.power-read').html(overall_power.toFixed(3)+" kWh");
        $('.money-read').html("$"+overall_money.toFixed(2));
        $('.emissions-read').html(overall_emissions.toFixed(3)+" kg");
      });
    };

    /*****************************************
    * Google maps
    *****************************************/
    function initialize() {
        var longi = 39.8282;
        var lati = -98.5795

        var mapOptions = {
          center: new google.maps.LatLng(gon.latitude, gon.longitude),
          zoom: 3,
          mapTypeId: google.maps.MapTypeId.ROADMAP,
          panControl: false,
          scaleControl: false,
          mapTypeControl: false,
          streetViewControl: false
        };
        var map = new google.maps.Map(document.getElementById("map_canvas"),
            mapOptions);

        var marker = new google.maps.Marker({
          map: map,
          position: new google.maps.LatLng(gon.latitude, gon.longitude),
          visible: true,
          title: 'What up!'
         });
    }

}));