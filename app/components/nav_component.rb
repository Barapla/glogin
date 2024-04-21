# frozen_string_literal: true
class NavComponent < ViewComponent::Base
    def initialize(message:)
        @message = message
    end

    def call
        render template: "components/nav_component"
    end
end
