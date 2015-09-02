Template.GooglePickFile.helpers
  isSelected: ->
    !! @spreadsheet
  fileName: ->
    @spreadsheet.name
  fileUrl: ->
    @spreadsheet.url
  displayPickerSpinner: ->
    !! Session.get("pickerRequested") && ! Session.get("pickerCreated")

Template.GooglePickFile.created = ->
  Session.set "pickerRequested", 0
  Session.set "pickerLoaded", false
  Session.set "pickerCreated", false

  clientId = "333673621119-253q1or9jq941j5o27lqg59p0gocvhas.apps.googleusercontent.com"
  scope = "https://www.googleapis.com/auth/drive"
  picker = undefined
  instance = @data

  window.gapi.load('auth', {"callback" : ->
      cl "Auth has been loaded"
      window.gapi.auth.authorize(
          'client_id': clientId,
          'scope': scope,
          'immediate': false
        , (result) ->
          if result && ! result.error
            cl "Auth has been granted"
            Session.set "accessToken", result.access_token
          else
            cl "Auth error"
            cl result
      )
  })

  window.gapi.load('picker', {"callback" : ->
    cl "Picker has been loaded"
    Session.set "pickerLoaded", true
  })

  Tracker.autorun ->
    if Session.get("pickerLoaded") && Session.get("accessToken")
      cl "Create picker object"
      builder = new window.google.picker.PickerBuilder()
      builder.addView(window.google.picker.ViewId.SPREADSHEETS)
      builder.setOAuthToken(Session.get("accessToken"))
      builder.setCallback((result) ->
        if result && result.action == "picked"
          selected = result.docs[0]
          instance.setSpreadsheet
            id: selected.id
            name: selected.name
            url: selected.embedUrl
          cl "File has been picked"

      )

      picker = builder.build()
      Session.set "pickerCreated", true

  Tracker.autorun ->
    if Session.get("pickerCreated") && Session.get("pickerRequested")
      picker.setVisible(true)

Template.GooglePickFile.events
  "click .google-picker": ->
    cl "Picker has been requested"
    Session.set("pickerRequested", Session.get("pickerRequested") + 1)
