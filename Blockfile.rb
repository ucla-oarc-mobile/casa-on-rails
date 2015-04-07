require 'pathname'

# Paths used in this Blockfile implementation
ROOT_PATH =  Pathname.new(__FILE__).parent.realpath
BLOCKS_PATH = ROOT_PATH + 'blocks'
BUILD_PATH = ROOT_PATH + 'app/assets/blocks'

###################################################################################

# Define the directory where WebBlocks will place the final build products.
set :build_path, BUILD_PATH

# Include the opt site block, from whence all else should be included.
include 'casa-on-rails', 'site'

# This proc, which should be executed as "instance_exec(path, &autoload_files_as_blocks)" from within a block def,
# will load all files directly within the directory path, using the file name as the block name, and the extension to
# determine which type of file to implicitly load the file into the block as.
autoload_files_as_blocks = Proc.new do |path|
  Dir.entries(path).keep_if(){ |fp| File.file?(path + fp) }.each do |fp|
    case /\.[^\.]*$/.match(fp).to_s
      when '.js'
        block(fp.gsub(/\.[^\.]*$/, ''), required: true){ js_file fp }
      when '.scss'
        block(fp.gsub(/\.[^\.]*$/, ''), required: true){ scss_file fp }
    end
  end
end

###################################################################################



block 'casa-on-rails', :path => BLOCKS_PATH do |n|

  config = block 'config', :path => 'config' do |config|
    instance_exec(BLOCKS_PATH + 'config', &autoload_files_as_blocks)
  end

  components = block 'components', path: 'component' do |components|
    dependency framework.route 'WebBlocks-grid'
    dependency framework.route 'DataTables'
    dependency framework.route 'normalize.css'
    dependency framework.route 'WebBlocks-visibility', 'hide'
    dependency framework.route 'WebBlocks-visibility', 'accessible'
    dependency framework.route 'WebBlocks-visibility', 'breakpoint'
    instance_exec(BLOCKS_PATH + 'component', &autoload_files_as_blocks)
  end

  site = block 'site', :path => 'site' do |site|
    dependency config.route
    dependency components.route
    instance_exec(BLOCKS_PATH + 'site', &autoload_files_as_blocks)
  end

end