function randomOrder () {
  console.log('Random order')
  //Función para mostrar de manera aleatoria los item_box
  var finalResultsDiv = document.getElementById("final_results");
  var itemBoxes = finalResultsDiv.getElementsByClassName("item_box");

  // Convierte la colección de elementos en un array para poder mezclarlo
  var itemBoxesArray = Array.from(itemBoxes);

  // Mezcla el array de elementos aleatoriamente
  var shuffledItemBoxes = itemBoxesArray.sort(function() {
    return 0.5 - Math.random();
  });

  // Vacía el contenedor de resultados
  while (finalResultsDiv.firstChild) {
    finalResultsDiv.removeChild(finalResultsDiv.firstChild);
  }

  // Agrega los elementos mezclados al contenedor en el nuevo orden
  shuffledItemBoxes.forEach(function(itemBox) {
    finalResultsDiv.appendChild(itemBox);
  });
}