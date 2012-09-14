#= require md5

# Private abbreviations
abbreviations =
  size:         's'
  default:      'd'
  rating:       'r'
  forcedefault: 'f'

window.Gravtastic = (email, options={}) ->
  id = MD5(email.toString().toLowerCase())

  process_options = (options) ->
    processed_options = {}
    for key, val of options
      switch key
        when "secure" then
        when "filetype" then
        when "forcedefault"
          if val
            processed_options[key] = 'y'
        else processed_options[key] = val
    processed_options

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
    for key, val of process_options(opts)
      "#{abbreviations[key] || key}=#{val}"
  ).join('&')

  host + path + params


# These are easily overridden in your own application
window.Gravtastic.defaults =
  rating:   'PG'
  secure:   true
  filetype: 'png'

