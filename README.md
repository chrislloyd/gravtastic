                  _____                 _            _   _
                 / ____|               | |          | | (_)
                | |  __ _ __ __ ___   _| |_ __ _ ___| |_ _  ___
                | | |_ | '__/ _` \ \ / / __/ _` / __| __| |/ __|
                | |__| | | | (_| |\ V /| || (_| \__ \ |_| | (__
                 \_____|_|  \__,_| \_/  \__\__,_|___/\__|_|\___|


<center><small>The super fantastic way of getting Gravatars. By [The Poacher](http://thelincolnshirepoacher.com).</small></center>

In less than a minute you can add Gravatars to your Ruby project. It works in Rails, Merb & Sinatra.

The best way to learn more about Gravtastic is to [look through the annotated source](http://chrislloyd.github.com/gravtastic). It's one file, about 80 LOC and really pretty simple. If that isn't for you, then follow the instructions below!


## Install

    sudo gem install gravtastic


## Usage

For this example I'm going to assume you are using Rails. Don't worry if you aren't, the concepts are still the same.

First off, add this to your `Gemfile`:

    gem 'gravtastic'

Next, in your model:

    class User < ActiveRecord::Base
      include Gravtastic
      gravtastic
    end

<small>_Note: You can use either `is_gravtastic!`, `is_gravtastic` or `has_gravatar`, they all do the same thing._</small>

And you are done! In your views you can now use the `#gravatar_url` method on instances of `User`:

    <%= image_tag @user.gravatar_url %>

Gravatar gives you some options. You can use them like this:

    <%= image_tag @user.gravatar_url(:rating => 'R', :secure => true) %>

That will show R rated Gravatars over a secure connection. If you find yourself using the same options over and over again, you can set the Gravatar defaults. In your model, just change the `is_gravtastic` line to something like this:

    gravtastic :secure => true,
                  :filetype => :gif,
                  :size => 120

Now all your Gravatars will come from a secure connection, be a GIF and be 120x120px.

Gravatar needs an email address to find the person's avatar. By default, Gravtastic calls the `#email` method to find this. You can customise this.

    gravtastic :author_email

### Defaults

A common question is "how do I detect wether the user has an avatar or not?" People usually write code to perform a HTTP request to Gravatar to see wether the gravatar exists. This is certainly a solution, but not a very good one. If you have page where you show 50 users, the client will have to wait for 50 HTTP requests before they even get the page. Slooww.

The best way to do this is to set the `:default` option when using `#gravatr_url`. If the user doesn't have an avatar, Gravatar essentially redirects to the "default" url you provide.

### Complete List of Options

<table width="100%">
  <thead>
    <th>Option</th>
    <th>Description</th>
    <th>Default</th>
    <th>Values<th>
  </tr>
  <tr>
    <td><b>secure</b></td>
    <td>Gravatar transmitted with SSL</td>
    <td>true</td>
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
    <td>"identicon", "monsterid", "wavatar" or an absolute URL.</td>
  </tr>
  <tr>
    <td><b>rating</b></td>
    <td>The highest level of ratings you want to allow</td>
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


### Other ORMs

Gravatar is really just simple Ruby. There is no special magic which ties it to one ORM (like ActiveRecord or MongoMapper). You can use the following pattern to include it anywhere:

    require 'gravtastic'
    class MyClass
      include Gravtastic
      is_gravtastic
    end

For instance, with the excellent [MongoMapper](http://github.com/jnunemaker/mongomapper) you can use do this:

    class Person
      include MongoMapper::Document
      include Gravtastic

      is_gravtastic

      key :email
    end

And wallah! It's exactly the same as with ActiveRecord! Now all instances of the `Person` class will have `#gravatar_url` methods.

_Note: the `#gravatar_url` methods don't get included until you specify the class `is_gravtastic!`_


## Javascript

_Note: this feature requires Rails 3.1 & CoffeeScript._

Web applications are increasingly performing client side rendering in Javascript. It's not always practical or clean to calculate the `gravatar_url` on the server. As of version 3.2, Gravtastic comes bundled with Javascript helpers.

If you are using Rails 3.1 you can simple require Gravtastic in your `Gemfile` and add

    //= require gravtastic

in your `application.js` file. This will include a function, `Gravtastic` which performs similarly to `gravtastic_url`.

    > Gravtastic('christopher.lloyd@gmail.com')
      "https://secure.gravatar.com/avatar/08f077ea061585744ee080824f5a8e65.png?r=PG"
    > Gravtastic('christopher.lloyd@gmail.com', {default: 'identicon', size: 64})
      "https://secure.gravatar.com/avatar/08f077ea061585744ee080824f5a8e65.png?r=PG&d=identicon&s=64"


## Making Changes Yourself

Gravtastic is a mature project. There isn't any active work which needs to be done on it, but I do continue to maintain it. Just don't expect same day fixes. If you find something that needs fixing, the best way to contribute is to fork the repo and submit a pull request.

    git clone git://github.com/chrislloyd/gravtastic.git


## Thanks

* [Xavier Shay](http://github.com/xaviershay) and others for [Enki](http://enkiblog.com) (the reason this was originally written)
* [Matthew Moore](http://github.com/moorage)
* [Galen O'Hanlon](http://github.com/gohanlon)
* [Jason Cheow](http://jasoncheow.com)
* [Paul Farnell](http://github.com/salted)
* [Jeff Kreeftmeijer](http://github.com/jeffkreeftmeijer)
* [Ryan Lewis](http://github.com/c00lryguy)
* [Arthur Chiu](http://github.com/achiu)
* [Paul Johnston](http://pajhome.org.uk/crypt/md5/) for his awesome MD5.js implementation.


## License

Copyright (c) 2008 Chris Lloyd.

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the 'Software'), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

--

md5.js Copyright (c) 1998 - 2009, Paul Johnston & Contributors
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.

Neither the name of the author nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
