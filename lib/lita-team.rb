require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/team"
require "lita/handlers/create_team"
require "lita/handlers/delete_team"
require "lita/handlers/block_team"
require "lita/handlers/list_teams"
require "lita/handlers/clear_team"
require "lita/handlers/add_member_to_team"
require "lita/handlers/remove_member_from_team"
require "lita/handlers/confirm_member"
require "lita/handlers/list_team"
require "lita/handlers/update_team"

Lita::Handlers::Team.template_root(
  File.expand_path(File.join("..", "..", "templates"), __FILE__)
)
