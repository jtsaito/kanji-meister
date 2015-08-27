class WelcomeController < AuthenticatedController
  def index
    render text: "welcome"
  end
end
