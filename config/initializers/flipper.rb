# frozen_string_literal: true

# admin_user policy block
Flipper.register(:admin_user) do |actor, _context|
  actor.respond_to?(:admin?) && actor.admin?
end

# patron policy block
Flipper.register(:patron) do |actor, _context|
  actor.respond_to?(:patron?) && actor.patron?
end
