require 'rubygems'
require 'sitemap_generator'

SitemapGenerator::Sitemap.default_host = 'https://uulanba.com'
SitemapGenerator::Sitemap.create do
  add '/', :changefreq => 'daily', :priority => 0.9
  add '/Manila', :changefreq => 'daily'
  add '/Taguig', :changefreq => 'daily'
  add '/Makati', :changefreq => 'daily'
  add '/Pasig', :changefreq => 'daily'
  add '/Pasay', :changefreq => 'daily'
  add '/Paranaque', :changefreq => 'daily'
  add '/Mandaluyong', :changefreq => 'daily'
  add '/Muntinlupa', :changefreq => 'daily'
end
SitemapGenerator::Sitemap.ping_search_engines # Not needed if you use the rake tasks