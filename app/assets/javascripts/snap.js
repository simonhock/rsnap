var world;
window.addLoadEvent(function () {
  world = new WorldMorph(document.getElementById('world'));
  ide = new IDE_Morph();
  ide.openIn(world);
  ide.serializer.openProject(
    ide.serializer.loadProjectModel(
      ide.serializer.parse(
        getURL(document.querySelector('#world').dataset.file)))
    , ide
  );
  setInterval(function() {world.doOneCycle();}, 1);
});

function getURL(url) {
  try {
      var request = new XMLHttpRequest();
      request.open('GET', url, false);
      request.send();
      if (request.status === 200) {
          return request.responseText;
      }
      throw new Error('unable to retrieve ' + url);
  } catch (err) {
      return;
  }
}