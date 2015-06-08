require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/team"
require "lita/handlers/team"

Lita::Handlers::Team.template_root File.expand_path(
  File.join("..", "..", "templates"),
 __FILE__
)
