# frozen_string_literal: true

module Additionals
  module WikiMacros
    module LastUpdatedAtMacro
      Redmine::WikiFormatting::Macros.register do
        desc <<-DESCRIPTION
    Displays date of last update of a wiki page.

    Syntax:

    {{last_updated_at([<project_name or project_identifier>, wiki_page])}}

    Scope:

    This macro only works in wiki page contexts.
        DESCRIPTION

        macro :last_updated_at do |obj, args|
          return '' unless @project

          if args.empty?
            page = obj
          else
            raise '{{last_updated_at(project_identifier, wiki_page)}}' if args.length < 2

            project_name = args[0].strip
            page_name = args[1].strip
            project = Project.find_by name: project_name
            project ||= Project.find_by identifier: project_name
            return unless project

            wiki = Wiki.find_by project_id: project.id
            return unless wiki

            page = wiki.find_page page_name
          end

          return unless page

          # TODO: find solution for time_tag without to use html_safe
          tag.span(l(:label_updated_time, time_tag(page.updated_on)).html_safe, # rubocop:disable Rails/OutputSafety
                   class: 'last-updated-at')
        end
      end
    end
  end
end
