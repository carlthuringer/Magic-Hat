# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'navigation'
    primary.item :home, 'Home', root_path
    primary.item :dashboard, "Dashboard", dashboard_path, :if => Proc.new { signed_in? } do |dashboard|
      dashboard.dom_class = 'navigation sub'
      dashboard.item :active, "Active", dashboard_path
      dashboard.item :shelved, "Shelved", shelved_path
    end
    primary.item :profile, "Profile", current_user, :if => Proc.new { signed_in? }
    primary.item :signout, "Sign out", signout_path, :if => Proc.new { signed_in? }
    primary.item :signin, "Sign in", signin_path, :if => Proc.new { !signed_in? }
  end
end
