#= require md5

# Private abbreviations
abbreviations =
  size:    's'
  default: 'd'
  rating:  'r'

window.Gravtastic = (email, options={}) ->
  id = MD5(email.toString().toLowerCase())

  # Initialize options
  opts = {}
  opts[key] = val for key, val of Gravtastic.defaults
  opts[key] = val for key, val of options

  host = if opts.secure
           "https://secure.gravatar.com/avatar"
         else
           "http://gravatar.com/avatar"

  path = "/#{id}.#{opts.filetype || 'png'}"

  params = "?" + (
    for key, val of opts when key isnt "secure" and key isnt "filetype"
      "#{abbreviations[key] || key}=#{val}"
  ).join('&')

  host + path + params


# These are easily overridden in your own application
window.Gravtastic.defaults =
  rating:   'PG'
  secure:   true
  filetype: 'png'

