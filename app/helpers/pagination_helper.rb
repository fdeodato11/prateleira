module PaginationHelper
  def pagy_custom_nav(pagy)
    return "" if pagy.pages <= 1

    pages = pagy.series
    items = []

    items << pagy_prev_item(pagy)
    items += pagy_page_items(pagy, pages)
    items << pagy_next_item(pagy)

    tag.nav(aria: { label: t("labels.pagination") }, class: "pagination-wrapper") do
      tag.ul(class: "pagination", role: "navigation") do
        safe_join(items)
      end
    end
  end

  private

  def pagy_prev_item(pagy)
    tag.li(class: "page-item#{" disabled" unless pagy.prev}") do
      if pagy.prev
        link_to(pagy_url_for(pagy, pagy.prev),
                class: "page-link page-link--prev",
                aria: { label: t("labels.previous_page") },
                data: { turbo_action: "advance" }) do
          concat icon("chevron-left", size: 16)
          concat tag.span(t("labels.previous"), class: "page-link__label")
        end
      else
        tag.span(class: "page-link page-link--prev") do
          concat icon("chevron-left", size: 16)
          concat tag.span(t("labels.previous"), class: "page-link__label")
        end
      end
    end
  end

  def pagy_next_item(pagy)
    tag.li(class: "page-item#{" disabled" unless pagy.next}") do
      if pagy.next
        link_to(pagy_url_for(pagy, pagy.next),
                class: "page-link page-link--next",
                aria: { label: t("labels.next_page") },
                data: { turbo_action: "advance" }) do
          concat tag.span(t("labels.next"), class: "page-link__label")
          concat icon("chevron-right", size: 16)
        end
      else
        tag.span(class: "page-link page-link--next") do
          concat tag.span(t("labels.next"), class: "page-link__label")
          concat icon("chevron-right", size: 16)
        end
      end
    end
  end

  def pagy_page_items(pagy, pages)
    items = []
    pages.each do |page|
      case page
      when Integer
        items << if page == pagy.page
                   tag.li(class: "page-item active") do
                     tag.span(page, class: "page-link page-link--num")
                   end
                 else
                   tag.li(class: "page-item") do
                     link_to(page,
                             pagy_url_for(pagy, page),
                             class: "page-link page-link--num",
                             data: { turbo_action: "advance" })
                   end
                 end
      when String
        items << tag.li(class: "page-item gap") do
          tag.span("...", class: "page-link page-link--gap")
        end
      end
    end
    items
  end
end
