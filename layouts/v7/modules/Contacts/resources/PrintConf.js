jQuery(function () {
  jQuery("body").on("click", "#printConf", function (e) {
    var modal = document.getElementById("myModal");

    var selectedBank = jQuery(".selected-bank").length
      ? jQuery(".selected-bank").val()
      : null;

    if (selectedBank)
      jQuery("#bank_accounts").val(selectedBank).trigger("change");

    modal.style.display = "block";
  });

  jQuery("body").on("click", ".printConfClose", function (e) {
    var modal = document.getElementById("myModal");
    modal.style.display = "none";
  });

  jQuery("body").on("click", "#printConfSave", function (e) {
    var modal = document.getElementById("myModal");
    modal.style.display = "none";
  });

  jQuery("body").on("change", "#bank_accounts", function (e) {
    var element = jQuery(e.currentTarget);
    var bankId = Number(element.val());
    saveUrl = jQuery("#printConfSave").attr("href");

    splitSaveUrl = saveUrl.split("&bank");
    newSaveUrl =
      splitSaveUrl[0] +
      "&bank=" +
      bankId +
      splitSaveUrl?.[1]?.substr(splitSaveUrl[1]?.indexOf("&"));

    jQuery("#printConfSave").attr("href", newSaveUrl);
  });

  jQuery("body").on("change", "#hideCustomerInfo", function (e) {
    var hideCustomerInfo = jQuery(e.currentTarget).is(":checked") ? 1 : 0;

    var saveUrl = jQuery("#printConfSave").attr("href");

    saveUrl = saveUrl.replace(
      /([?&])hideCustomerInfo=[^&]*/,
      "$1hideCustomerInfo=" + hideCustomerInfo,
    );

    jQuery("#printConfSave").attr("href", saveUrl);
  });

  jQuery("body").on("change", "#hideSerials", function (e) {
    var hideSerials = jQuery(e.currentTarget).is(":checked") ? 1 : 0;

    console.log("hideSerials", hideSerials);

    var saveUrl = jQuery("#printConfSave").attr("href");

    saveUrl = saveUrl.replace(
      /([?&])hideSerials=[^&]*/,
      "$1hideSerials=" + hideSerials,
    );

    jQuery("#printConfSave").attr("href", saveUrl);
  });
});
