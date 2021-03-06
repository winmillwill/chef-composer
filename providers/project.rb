#
# Cookbook Name:: composer
# Resource:: project
#
# Copyright 2012-2014, Escape Studios
#

use_inline_resources if defined?(use_inline_resources)

def whyrun_supported?
  true
end

action :install do
  make_execute 'install'
  new_resource.updated_by_last_action(true)
end

action :update do
  make_execute 'update'
  new_resource.updated_by_last_action(true)
end

action :dump_autoload do
  make_execute 'dump-autoload'
  new_resource.updated_by_last_action(true)
end

def make_execute(op)
  dev = new_resource.dev ? '--dev' : '--no-dev'
  quiet = new_resource.quiet ? '--quiet' : ''
  optimize = new_resource.optimize_autoloader ? '--optimize' : ''
  return execute "#{op}-composer-for-project" do
    cwd new_resource.project_dir
    command "#{node['composer']['bin']} #{op} --no-interaction --no-ansi #{quiet} #{dev} #{optimize}"
    action :run
    only_if 'which composer'
    user new_resource.user
    group new_resource.group
    umask new_resource.umask
  end
end
