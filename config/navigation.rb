# Configures your navigation
SimpleNavigation::Configuration.run do |navigation|
  navigation.items do |primary|
    primary.dom_class = 'navigation'
    primary.item :home, 'Home', root_path
    if signed_in?
      primary.item :dashboard, "Dashboard", dashboard_path do |dashboard|
        dashboard.dom_class = 'navigation sub'
        dashboard.item :active, "Active", dashboard_path
        dashboard.item :shelved, "Shelved", shelved_path
      end
      primary.item :profile, "Profile", user_path(current_user)
      primary.item :signout, "Sign out", signout_path
    else
      primary.item :signin, "Sign in", signin_path
    end
  end
end
