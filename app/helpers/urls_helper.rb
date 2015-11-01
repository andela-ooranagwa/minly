module UrlsHelper
  def create_shortened_url (url_id)
      # host_url + "/" + url_id.to_s(32).reverse
      url_id.to_s(32).reverse
  end

  def host_url
    request.base_url + "/"
  end

  def sanitize_url(url)
    return if url.nil? || url.empty?
    url #add url sanitizer
  end

  def shorten_url_for_users(original, vanity_string)
    if vanity_string
      url = Url.find_or_initialize_by(shortened: vanity_string)
      url.original ||= original
    else
      url = shorten_url_for_default(original)
    end
    url.user_id ||= current_user.id
    url
  end

  def shorten_url_for_default(original)
    Url.find_or_initialize_by(original: original)
  end

  def manage_save
    if @url.save
      @url.save_shortened(create_shortened_url(@url.id)) if @url.shortened.nil?
      flash[:success] = "Url was shortened successfully."
    else
      flash[:error] = @url.errors[:original].join(", ")
    end
  end

  def show_in_list_format(urls)
    list = ''
    urls.each do |url|
      target = host_url + url.shortened
      list += "<li id='#{dom_id(url)}'><strong>Shortened: #{link_to(target, target)}</strong>&emsp;<strong>Views: #{url.views}</strong></li>"
    end
    "<section><ul>#{list}</ul></section>".html_safe
  end

  def display_notification(messages, class_tag)
    return unless messages
    notice = <<-EOS
    <div class="container">
      <div class="eight columns offset-by-two">
        <div class="notification">
          <ul #{class_tag}>
      EOS
        messages.each do |message|
          notice += "<li>#{message}</li>"
        end
    notice += <<-EOS
          </ul>
        </div>
      </div>
    </div>
    EOS
    notice.html_safe
  end

  def set_not_found_notification(url)
    "We can't find any record relating to #{url}. Please cross-check your entry and try again. "
  end

  def set_inactive_url_notification(url)
    "The url #{url} has been deactivated. You can try again later."
  end
end

  # @url = Url.new(url_params)
