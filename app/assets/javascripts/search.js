function ajaxRequest(url) {
  var theDiv = document.getElementById("search_results");
    if (theDiv) {
        theDiv.remove();
    }
  $.ajax({
    url: url,
    method: 'GET',
    success: function(response) {
      console.log(response)
      // Manejar la respuesta aquí
      $("#search_div").append(response);
    },
    error: function(error) {
      // Manejar el error aquí
      console.error(error);
    }
  });
}

function randomOrder () {
  console.log('Random order')
  //Función para mostrar de manera aleatoria los item_box
  var finalResultsDiv = document.getElementById("final_results");

  if (finalResultsDiv.firstElementChild.id == "link_to_user") {
    var itemBoxes = finalResultsDiv.getElementsByClassName("link_to_user");
  } else if (finalResultsDiv.firstElementChild) {
    var itemBoxes = finalResultsDiv.getElementsByClassName("item_box");
  }

  // Convierte la colección de elementos en un array para poder mezclarlo
  var itemBoxesArray = Array.from(itemBoxes);

  // Mezcla el array de elementos aleatoriamente
  var shuffledItemBoxes = itemBoxesArray.sort(function() {
    return 0.5 - Math.random();
  });

  // Agrega los elementos mezclados al contenedor en el nuevo orden
  shuffledItemBoxes.forEach(function(itemBox) {
    finalResultsDiv.appendChild(itemBox);
  });
}

function handleSortClick(sortByValue) {
  var url = window.location.href; // Obtener la URL actual
  var separator = url.includes('?') ? '&' : '?'; // Verificar si ya hay consultas en la URL

  if (url.includes('sort_by')) {
    if (url.includes(sortByValue)) {
      // Eliminar la consulta de la URL
      var newUrl = url.replace(url.includes('&sort_by') ? `&sort_by=${sortByValue}` : `?sort_by=${sortByValue}`, '');
      window.history.pushState("", "", newUrl);
    } else {
      var newUrl = url.replace(/sort_by=[^&?]*(?=[&?]|$)/, `sort_by=${sortByValue}`);
      console.log(newUrl)
      window.history.pushState("", "", newUrl);
    }
  } else {
    // Construir la nueva URL con la consulta añadida
    var newUrl = url + separator + `sort_by=${sortByValue}`;
    window.history.pushState("", "", newUrl);
  }

  // Realizar la petición AJAX
  ajaxRequest(newUrl);
}

function deleteSelections () {
  var ulElements = filtersDiv2.querySelectorAll('ul');

  ulElements.forEach(function(ul) {
    ul.querySelectorAll('div').forEach(function(div) {
      div.classList.remove('active-filter');
    });
  });
}

function deleteSearchQuery() {
  var url = window.location.href; // Obtener la URL actual

  // Eliminar la consulta de la URL
  var newUrl = url.replace(/\?.*/, '');
  window.history.pushState("", "", newUrl);

  // Realizar la petición AJAX
  ajaxRequest(newUrl);
  textSearch.style.display = "none";
}

function setTagsFilters() {
  var users = document.getElementById("ul-users");
  var presentations = document.getElementById("ul-presentations");
  var links = document.getElementById("ul-links");
  var filtersDiv2 = document.getElementById("filters2");
  var url = window.location.href; // Obtener la URL actual
  console.log(222, url)

  users.classList.remove("active-filter");
  presentations.classList.remove("active-filter");
  links.classList.remove("active-filter");

  filtersDiv2.classList.remove("filters-close");
  var divs = document.querySelectorAll('#filters2 div');
  console.log(divs);
  divs.forEach(function(div) {
    div.classList.remove('active-filter');
  });

  if (url.includes('type=user')) {
    users.classList.add("active-filter");
  } else if (url.includes('type=presentation')) {
    presentations.classList.add("active-filter");
  } else if (url.includes('type=link')) {
    links.classList.add("active-filter");
  }

  var queryString = window.location.search;
  queryString = queryString.substring(1);
  var decodedQueryString = decodeURIComponent(queryString);
  var queryParamsArray = decodedQueryString.split('&');
  var queryParams = {};
  queryParamsArray.forEach(function(param) {
    var keyValue = param.split('=');
    var key = keyValue[0];
    var value = keyValue[1] || '';
    queryParams[key] = decodeURIComponent(value);
  });
  var tagsArray = queryParams['tags'] ? queryParams['tags'].split(',') : [];
  for (var i = 0; i < tagsArray.length; i++) {
    var tag = tagsArray[i];
    if (tag !== '' && url.includes(tag)) {
      document.getElementById("ul-" + tag).classList.add("active-filter");
    }
  }
}