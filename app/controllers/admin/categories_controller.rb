module Admin
  class CategoriesController < BaseController
    before_action :set_category, only: %i[show edit update destroy restore]

    def index
      @categories = Category.with_discarded.ordered
      authorize @categories
    end

    def show
      authorize @category
    end

    def new
      @category = Category.new
      authorize @category
    end

    def create
      @category = Category.new(category_params)
      authorize @category

      if @category.save
        redirect_to admin_categories_path, notice: "Category created successfully."
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      authorize @category
    end

    def update
      authorize @category

      if @category.update(category_params)
        redirect_to admin_categories_path, notice: "Category updated successfully."
      else
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      authorize @category
      @category.discard!
      redirect_to admin_categories_path, notice: "Category discarded successfully."
    end

    def restore
      authorize @category
      @category.undiscard!
      redirect_to admin_categories_path, notice: "Category restored successfully."
    end

    private

    def set_category
      @category = Category.with_discarded.find(params[:id])
    end

    def category_params
      params.require(:category).permit(:name, :description, :slug)
    end
  end
end
