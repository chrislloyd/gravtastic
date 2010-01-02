# Gravtastic

<small>The super fantastic way of getting Gravatars. By [Chris](http://chrislloyd.com.au).</small>

In less than 5 minutes you can add Gravatars to your Ruby project. It works in Rails, Merb _and_ plain ol' Ruby.

The best way to learn more about Gravtastic is to [look at the source](http://github.com/chrislloyd/gravtastic/blob/master/lib/gravtastic.rb). It's one file, about 80 LOC and really pretty simple. If that isn't for you, then follow the instructions below!

## Install

    sudo gem install gravtastic

## Usage

Add this to your `environment.rb`:

    config.gem 'gravtastic', :version => '>= 2.1.0'

Next, say that you want a Gravatar for your model:

    class User < ActiveRecord::Base
      is_gravtastic!
    end

And you are done! In your views you can now use the `#gravatar_url` method:

    <%= image_tag @user.gravatar_url %>

If you want to change the image, you can do this:

    <%= image_tag @user.gravatar_url(:rating => 'R', :secure => true) %>

That will show R rated Gravatars over a secure connection. If you find yourself repeating that all around your app, you can set the Gravatar defaults. In your model, just change the `is_gravtastic!` line to something like this:

    is_gravtastic :author_email, :secure => true,
                                 :filetype => :gif,
                                 :size => 120

Now all your Gravatars will come from a secure connection, be a GIF and be 120x120px. The email will also come from the `author_email` field, not the default `email` field. Don't worry, you arn't locked into these defaults (you can override them by passing options to `#gravatar_url` like before).

_Note: You can use either `is_gravtastic!` or `is_gravtastic`, they both do the same thing._

### Plain Ruby

So you just have a regular ol' Ruby app? No Rails and ActiveRecord?

    require 'gravtastic'
    class BoringUser
      include Gravtastic
      is_gravtastic!
    end

And wallah! That works exactly the same as in Rails! Now all instances of the BoringUser class will have `#gravatar_url` methods.

_Note: the `#gravatar_url` methods don't get included until you specify the class `is_gravtastic!`_

### Complete List of Options

<table>
  <tr>
    <th>Option</th>
    <th>Description</th>
    <th>Default</th>
    <th>Values<th>
  </tr>
  <tr>
    <td><b>secure</b></td>
    <td>Gravatar transmitted with SSL</td>
    <td>false</td>
    <td>true/false</td>
  </tr>
  <tr>
    <td><b>size</b></td>
    <td>The size of the image</td>
    <td>80</td>
    <td>1..512</td>
  </tr>
  <tr>
    <td><b>default</b></td>
    <td>The default avatar image</td>
    <td><i>none</i></td>
    <td>Any URL, or "identicon", "monsterid", "wavatar"</td>
  </tr>
  <tr>
    <td><b>rating</b></td>
    <td>The lowest level of ratings you want to allow</td>
    <td>G</td>
    <td>G, PG, R or X</td>
  </tr>
  <tr>
    <td><b>filetype</b></td>
    <td>The filetype of the image</td>
    <td>png</td>
    <td>gif, jpg or png</td>
  </tr>
</table>

## Making Changes Yourself

Fork the project, submit a pull request and I'll get to it straight away. Or you can just view the source like:

    git clone git://github.com/chrislloyd/gravtastic.git

## Thanks

* [Xavier Shay](http://rhnh.net) and others for [Enki](http://enkiblog.com) (the reason this was originally written)
* [Matthew Moore](http://www.matthewpaulmoore.com)
* [Vincent Charles](http://vincentcharles.com)
* [Paul Farnell](http://litmusapp.com/blog)
* [Jeff Kreeftmeijer](http://jeffkreeftmeijer.nl/)

## License

Copyright (c) 2008 Chris Lloyd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
