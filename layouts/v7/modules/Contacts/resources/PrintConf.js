jQuery(function () {
  function setUrlParam(url, key, value) {
    var pattern = new RegExp("([?&])" + key + "=[^&]*");
    if (pattern.test(url)) {
      return url.replace(pattern, "$1" + key + "=" + value);
    }
    return url + (url.indexOf("?") >= 0 ? "&" : "?") + key + "=" + value;
  }

  function removeUrlParam(url, key) {
    return url
      .replace(new RegExp("[?&]" + key + "=[^&]*"), function (match) {
        return match.charAt(0) === "?" ? "?" : "";
      })
      .replace(/\?&/, "?")
      .replace(/[?&]$/, "");
  }

  function syncPrintSettingLinks(key, value) {
    var links = jQuery("#printConfSave, #downloadPdfBtn");
    links.each(function () {
      var href = jQuery(this).attr("href");
      if (!href || href === "#") {
        return;
      }
      var newHref =
        value === "1" || value === 1
          ? setUrlParam(href, key, value)
          : removeUrlParam(href, key);
      jQuery(this).attr("href", newHref);
    });
  }

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
    var hideCustomerInfo = jQuery(e.currentTarget).is(":checked") ? "1" : "0";
    syncPrintSettingLinks("hideCustomerInfo", hideCustomerInfo);
  });

  jQuery("body").on("change", "#hideSerials", function (e) {
    var hideSerials = jQuery(e.currentTarget).is(":checked") ? "1" : "0";
    syncPrintSettingLinks("hideSerials", hideSerials);
  });
});
