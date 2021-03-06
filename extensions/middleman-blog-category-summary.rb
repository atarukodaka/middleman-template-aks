# -*- coding: utf-8 -*-
module Middleman
  module BlogCategorySummary
    ################################################################
    # additional helper methods to blog.*
    #
    module ResourceIncludedToBlogData
      def categories
        articles.group_by {|p| p.category }
      end
    end  
    ################################################################
    # additional helper methods to BlogArticle (blog.articles.*)
    module ResourceIncludedToBlogArticle
      def category
        return self.data.category || self.metadata[:page]["category"]
      end
    end
    ################
    module Helpers
      def category_summary_page_path(category)
        blog_category_summary_settings.outputpath_template % {category: h(category)}
      end
      def link_to_category_summary_page(category)
        link_to(h(category), category_summary_page(category))
      end
      def category_summary_page(category)
        sitemap.find_resource_by_path(category_summary_page_path(category))
      end
    end
    
    ################
    class Extension < Middleman::Extension
      Middleman::Blog::BlogData.class_eval do 
        include ResourceIncludedToBlogData
      end
      Middleman::Blog::BlogArticle.class_eval do
        include ResourceIncludedToBlogArticle
      end

      option :proxy_template, "/category_summary_template.html", "category summary template"
      option :outputpath_template, "/categories/%{category}.html"
      
      def initialize(app, options_hash = {}, &block)
        super
        app.set :blog_category_summary_settings, options
      end

      helpers do
        include Helpers
      end
      
      def after_configuration
        @app.ready do 
          blog.articles.group_by {|a| a.category}.each do |category, articles|
            next if category.nil?
            proxy(category_summary_page_path(category), blog_category_summary_settings.proxy_template,
                  :locals => { :category => category, :articles => articles, :ignore => true })
          end
          ignore blog_category_summary_settings.proxy_template
        end
      end

    end
  end
end

Middleman::BlogCategorySummary::Extension.register :blog_category_summary
