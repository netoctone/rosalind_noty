require 'mechanize'

module NewsChecker
  URI = 'http://rosalind.info/'
  DOMAIN = 'rosalind.info'
  PATH = '/'

  LINK_NAMES = [
    'Bioinformatics Armory',
    'Bioinformatics Stronghold',
    'Python Village'
  ]

  class PageChecker
    TASK_TYPE_SELECTORS = {
      :new => '.accessible',
      :new_unreached => '.not-accessible',
      :old => '.solved'
    }

    def initialize(page)
      @page = page
    end

    def news?
      task_present?(:new)
    end

    def bad_cookies?
      !task_present?(:old)
    end

    private

    def task_present?(type)
      @page.search(TASK_TYPE_SELECTORS[type]).size > 0
    end
  end

  # returns { news: boolean, bad_cookies: boolean }
  def self.check(cookies)
    agent = Mechanize.new
    main_page = agent.get(URI)

    cookies.each do |k, v|
      cookie = Mechanize::Cookie.new(k, v)
      cookie.domain = DOMAIN
      cookie.path = PATH
      agent.cookie_jar.add(main_page.uri, cookie)
    end

    main_page = agent.get(URI)

    result = { news: false, bad_cookies: false }
    LINK_NAMES.each do |link_name|
      link = page_link_with(main_page, link_name)
      checker = PageChecker.new(agent.get(link.uri))

      result[:bad_cookies] ||= checker.bad_cookies?
      result[:news] ||= checker.news?
    end
    result
  end

  private

  def self.page_link_with(page, name)
    page.links.select { |l| l.uri && l.uri.to_s != '#' && l.text =~ /^\s*#{name}\s*$/}.first
  end
end
