function generateYTDReport(contactId) {
  AppConnector.request({
    module: "YTDReports",
    action: "Generate",
    contact_id: contactId,
  }).then(
    function (response) {
      console.log(response);

      if (response && response.result && response.result.message) {
        alert(response.result.message);
      } else {
        alert("YTD Report generated");
      }
    },
    function (error) {
      console.log(error);
      alert("Error generating YTD Report");
    },
  );
}
