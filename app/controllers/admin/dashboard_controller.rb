module Admin
  class DashboardController < BaseController
    def show
      authorize :dashboard, :show?

      @total_products = Product.count
      @active_products = Product.kept.active.count
      @discarded_products = Product.discarded.count
      @total_categories = Category.kept.count
      @recent_products = Product.kept.ordered.limit(5)
      @low_stock_products = Product.kept.where("stock_quantity <= ?", 10).ordered
    end
  end
end
