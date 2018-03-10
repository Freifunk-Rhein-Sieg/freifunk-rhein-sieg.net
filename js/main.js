$(function () {
  $('.scrollspy').scrollSpy({
    getActiveElement:
      function (id) {
        $('.navitem').removeClass('active');
        $('#nav-' + id).addClass('active')
      }
  });
  $('.modal').modal();
})