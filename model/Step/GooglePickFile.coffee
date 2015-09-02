class Steps.GooglePickFile extends Steps.Step
  setSpreadsheet: (data) ->
    Steps.update({_id: @_id}, {$set: {spreadsheet: data}})
