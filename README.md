# lazy-json-scaffold

lazy-json-scaffold provides a simple syntax for a very simply CRUD JSON API

## Installation

``` ruby
gem "lazy-json-scaffold"
```

Include lazy-json-scaffold in your controller:

``` ruby
require 'lazy_json_scaffold'
class PostsController < ActionController::Base
  include LazyJsonScaffold

  define_actions :index, :show, :create, :update, :destroy
end
```


### Creating custom index filters


```ruby
class PostsController < ActionController::Base
  include LazyJsonScaffold

  define_actions :index, :show, :create, :update, :destroy
  custom_filter_params :title, :author
end

```

### Using a custom scope


```ruby
class PostsController < ActionController::Base
  include LazyJsonScaffold

  define_actions :index, :show, :create, :update, :destroy
  custom_scope :active
end

```

# License

Licensed under the MIT license.
