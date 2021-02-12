module ApplicationHelper
  def current_year
    Time.now.year
  end

  def github_url(author, repo)
    link_to 'ibekirov', "https://github.com/#{author}/#{repo}", target: '_blank', class: 'text-white'
  end
end
