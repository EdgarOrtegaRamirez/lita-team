require "lita"

Lita.load_locales Dir[File.expand_path(
  File.join("..", "..", "locales", "*.yml"), __FILE__
)]

require "lita/handlers/team"
require "lita/actions/base"
require "lita/actions/create_team"
require "lita/actions/delete_team"
require "lita/actions/list_team"
require "lita/actions/clear_team"
require "lita/actions/list_teams"
require "lita/actions/add_member_to_team"
require "lita/actions/remove_member_from_team"
require "lita/store/team"
require "lita/store/member"
require "lita/team"
require "lita/member"

template_root = File.expand_path(
  File.join("..", "..", "templates"), __FILE__
)
Lita::Actions::Base.template_root template_root
Lita::Handlers::Team.template_root template_root
