require "lazy_json_scaffold/version"
require "active_support/concern"

module LazyJsonScaffold
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :null_session
    before_action :find_model_instance, only: [:show, :update, :destroy]
  end

  module ClassMethods
    def define_actions(*actions)
      actions.each { |action_name| send "define_#{action_name}" }
    end

    def custom_scope(scope_name)
      @custom_scope_name = scope_name
    end

    def custom_filter_params(*attr_names)
      @custom_filter_params = []
      attr_names.each do |attr_name|
        @custom_filter_params << attr_name
      end
    end

    def filter_params
      @custom_filter_params ||= []
    end

    def default_sort(attr_sort_string, attr_sort_direction = :asc)
      @custom_sort_param = attr_sort_string
      @custom_sort_direction = attr_sort_direction
    end

    def custom_scope_name
      @custom_scope_name ||= :all
    end

    def custom_sort_param
      @custom_sort_param ||= nil
    end

    def custom_sort_direction
      @custom_sort_direction
    end

    def define_index
      define_method(:index) do
        @results = model_name.classify.constantize.send(self.class.custom_scope_name)

        self.class.filter_params.each do |filter_param|
          @results = @results.where("#{filter_param}" => params[filter_param]) if params[filter_param]
        end
        @results = @results.order(self.class.custom_sort_param => self.class.custom_sort_direction) unless self.class.custom_sort_param.blank?

        render json: @results
      end
    end

    def define_show
      define_method(:show) do
        render json: model_instance
      end
    end

    def define_create
      define_method(:create) do
        instance_variable_set("@" + model_name, model_name.classify.constantize.new(model_params))
        if model_instance.save
          render json: model_instance, status: :created
        else
          render json: model_instance.errors, status: :unprocessable_entity
        end
      end
    end

    def define_update
      define_method(:update) do
        if model_instance.update(model_params)
          render json: model_instance
        else
          render json: model_instance.errors, status: :unprocessable_entity
        end
      end
    end

    def define_destroy
      define_method(:destroy) do
        model_instance.destroy
        head :no_content
      end
    end
  end

  private

  # find the model_name that would be associated with a given controller name
  def model_name
    params[:controller].sub("Controller", "").underscore.split('/').last.singularize
  end

  def model_collection
    instance_variable_get("@" + model_name.pluralize)
  end

  def model_collection=(value)
    instance_variable_set("@" + model_name.pluralize, value)
  end

  def model_instance
    instance_variable_get("@" + model_name)
  end

  def find_model_instance
    instance_variable_set("@" + model_name, model_name.classify.constantize.send(self.class.custom_scope_name).find(params[:id]))
  end

  def attributes_names_for_model
    model_name.classify.constantize.columns.map { |c| c.name }
  end

  def model_params
    params.require(model_name.to_sym).permit(attributes_names_for_model)
  end
end
