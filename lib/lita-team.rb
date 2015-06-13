require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/store/team"
require "lita/store/member"
require "lita/team"
require "lita/member"
require "lita/handlers/team"

Lita::Handlers::Team.template_root File.expand_path(
  File.join("..", "..", "templates"),
  __FILE__
)
