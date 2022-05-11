function getToken() {
  if (window.location.href.includes('#id_token=')) {
    var parts = window.location.href.split('#');
    var token_parts = parts[1].split('=');
    return token_parts[1];
  }
  return '';
}

function httpGetAsync(endpoint, callback) {
  var xmlHttp = new XMLHttpRequest();
  xmlHttp.onreadystatechange = function () {
    if (xmlHttp.readyState == 4 && xmlHttp.status == 200) {
      callback(xmlHttp.responseText);
    }
  }
  xmlHttp.open('GET', endpoint, true);
  xmlHttp.send(null);
}

function setCookies(responseText) {
  try {
    cookieObject = JSON.parse(responseText);
    expiration = '; Expires=' + new Date(cookieObject.Expiration*1000).toUTCString() + "; ";
    staticInfo = '; Path=/; Secure';

    document.cookie = 'CloudFront-Policy=' + cookieObject.Policy + expiration + staticInfo;
    document.cookie = 'CloudFront-Signature=' + cookieObject.Signature + expiration + staticInfo;
    document.cookie = 'CloudFront-Key-Pair-Id=' + cookieObject.Key + expiration + staticInfo;
  } catch (e) {
    alert("We're very sorry, but your token seems to be invalid.")
  } finally {
    window.location.href = '/';
  }
}

var APIURL = 'https://api.melvyn.dev/auth?id_token=' + getToken();
httpGetAsync(APIURL, setCookies);
