module Admin
  class DashboardController < BaseController
    def show
      authorize :dashboard, :show?

      @total_products = Product.count
      @active_products = Product.kept.active.count
      @draft_products = Product.kept.draft.count
      @discarded_products = Product.discarded.count
      @total_categories = Category.kept.count
      @total_users = User.count

      @recent_products = Product.kept.ordered.limit(5)
      @low_stock_products = Product.kept.where("stock_quantity <= ?", 10).ordered

      @products_by_category = Category.kept
        .joins(:products)
        .where(products: { discarded_at: nil })
        .group(:name)
        .count(:id)

      @products_by_status = Product.statuses.keys.index_with do |status|
        Product.public_send(status).count
      end
    end
  end
end
