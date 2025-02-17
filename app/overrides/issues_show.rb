# frozen_string_literal: true

module IssuesShow
  Deface::Override.new virtual_path: 'issues/_action_menu',
                       name: 'show-issue-log-time',
                       replace: 'erb[loud]:contains("User.current.allowed_to?(:log_time, @project)")',
                       original: '4bbf065b9f960687e07f76e7232eb21bf183a981',
                       partial: 'issues/additionals_action_menu_log_time'

  Deface::Override.new virtual_path: 'issues/_action_menu',
                       name: 'show-issue-action-menu',
                       insert_after: 'erb[loud]:contains("watcher_link")',
                       original: 'a519feb931e157589bc506b2673abeef994aa96b',
                       partial: 'hooks/view_issue_action_menu'

  Deface::Override.new virtual_path: 'issues/_action_menu',
                       name: 'show-issue-action-dropdown',
                       insert_before: 'erb[loud]:contains("copy_object_url_link")',
                       original: 'cf959d0baa105476b364f7fe33b05516e27dda65',
                       partial: 'hooks/view_issue_action_dropdown'
end
