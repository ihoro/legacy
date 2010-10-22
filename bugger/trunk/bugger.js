function Bugger() {
  this.main;
  this.id_input;
  this.status_input;
  this.logbox = null;
  this.isAnyRequestSent = false;

  this.init = function() {
    if (document.getElementById("bugger") != null)
      return false;

    main = document.createElement("div");
    main.appendChild(document.createTextNode("BuggeR version -0.6"));
    main.id = "bugger";

    var e;
    e = document.createElement("style");
    var style = document.createTextNode("#bugger{background-color:white;border:1px dotted #1781ed;padding:4px;text-align:center;width:256px;position:absolute;left:0px;top:10px;}#bugger,#bugger *{color:#1781ed;font-family:Arial;font-size:11px;}#bugger #bugger_id_input{margin-top:4px;width:100%;border:1px solid #1781ed;}#bugger #bugger_status_input{margin-top:4px;width:auto;border:1px solid #1781ed;}#bugger #control{margin-top:8px;margin-bottom:4px;}#bugger a{padding:2px 4px;margin:0px 16px;color:white;background:#1781ed;text-decoration:none;}#bugger #log{margin-top:8px;padding-left:8px;}#bugger #log div{text-align:left;color:green;}#bugger #log div.error{color:red;}");
    e.appendChild(style);
    main.appendChild(e);
    main.style.left = (document.body.clientWidth / 2 - 256 / 2) + "px";

    input = document.createElement("input");
    input.type = "text";
    input.id = "bugger_id_input";
    input.title = "Specify issue ID(s) separated by space";
    main.appendChild(input);

    e = document.getElementsByName("new_status");
    if (e.length == 0) {
      alert('You should first open details of any Zeusdesk issue.');
      return false;
    }
    status_input = e[0].cloneNode(true);
    status_input.id = "bugger_status_input";
    status_input.title = "Choose new status for specified issue(s)";
    status_input.selectedIndex = 7;
    main.appendChild(status_input);

    var control = document.createElement("div");
    control.id = "control";
    main.appendChild(control);

    e = document.createElement("a");
    e.appendChild(document.createTextNode("change"));
    e.setAttribute("href", "#");
    e.addEventListener("click", this.change, false);
    control.appendChild(e);

    e = document.createElement("a");
    e.appendChild(document.createTextNode("close"));
    e.setAttribute("href", "#");
    e.addEventListener("click", this.hide, false);
    control.appendChild(e);

    return true;
  };

  this.show = function() {
    if (this.init())
      document.body.appendChild(main);
  };

  this.hide = function() {
    document.body.removeChild(main);
  };

  this.createLogBox = function() {
    try{main.removeChild(logbox)} catch(e){}
    logbox = document.createElement("div");
    logbox.id = "log";
    main.appendChild(logbox);
  };

  this.change = function() {
    bugger.createLogBox();
    if (input.value.trim().length == 0) {
      bugger.error("Issue ID is not specified");
      return;
    }
    var idList = input.value.split(" ");
    var id;
    bugger.log("Processing...");
    bugger.count = idList.length;
    bugger.isAnyRequestSent = false;
    for (var i = 0; i < idList.length; ++i) {
      id = idList[i].trim();
      if (id.length > 0)
        bugger.changeStatus(id);
      else
        bugger.count--;
    }
    if (! bugger.isAnyRequestSent)
      bugger.log("Done.");
  };

  this.changeStatus = function(id) {
    if (isNaN(id)) {
      bugger.error(id + ": must be a number");
      bugger.count--;
      return;
    }
    var request = new XMLHttpRequest();
    bugger.isAnyRequestSent = true;
    request.onreadystatechange = function() {
      if (request.readyState != 4)
        return;
      if (request.status != 200)
        bugger.error(id + ": " + request.status + " " + request.statusText);
      else
        bugger.log(id + ": " + request.statusText);
      bugger.count--;
      if (0 == bugger.count)
        bugger.log("Done.");
    };
    var status_id = status_input.options[status_input.selectedIndex].value;
    var url = "http://opentopit.com/eventum/popup.php?cat=new_status";
    url += "&iss_id=" + id;
    url += "&new_sta_id=" + status_id;
    request.open("GET", url, true);
    request.send(null);
  };

  this.log = function(text) {
    var e = document.createElement("div");
    e.appendChild(document.createTextNode(text));
    logbox.appendChild(e);
  };

  this.error = function(text) {
    var e = document.createElement("div");
    e.className = "error";
    e.appendChild(document.createTextNode(text));
    logbox.appendChild(e);
  };
};
var bugger = new Bugger;
bugger.show();
