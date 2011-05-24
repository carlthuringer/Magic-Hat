require 'fileutils'
FileUtils.mkdir_p(Rails.root.join('tmp', 'stylesheets'))

# a hackity way to get cache busting for stylesheets (rails_asset_id)
# try the original ("public/") path and if not found, try "tmp/".
module ActionView::Helpers::AssetTagHelper
  private
  def rails_asset_id_with_tmp_path(source)
    asset_id = rails_asset_id_without_tmp_path source
    if asset_id.blank?
      org_dir = config.assets_dir
      begin
        config.assets_dir = File.join(Rails.root, 'tmp')
        asset_id = rails_asset_id_without_tmp_path source
      ensure
        config.assets_dir = org_dir
      end
    end
    asset_id
  end
  alias_method_chain :rails_asset_id, :tmp_path
end

