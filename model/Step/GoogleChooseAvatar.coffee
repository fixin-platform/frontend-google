class Steps.GoogleChooseAvatar extends Steps.ChooseOAuthAvatar
  i18nKey: "ChooseAvatar"
  _i18n: ->
    _i18n = super
    _i18n["icon"] = "google"
    _i18n
