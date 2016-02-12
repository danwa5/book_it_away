class SearchForm
  include ActiveModel::Model
  attr_accessor :author, :title, :isbn, :pages, :page_operator, :categories

  def self.model_name
    ActiveModel::Name.new(self, nil, 'SearchForm')
  end

  def self.search(params)
    new(params).search
  end

  def search
    results = []
    clean_attributes

    if author.present? || title.present? || isbn.present? || pages.present? || categories.present?
      if author.present?
        query = Book.author_search(author)
      else
        query = Book.where('1=1')
      end

      query = query.where("title ilike ?", "%#{title}%") if title.present?
      query = query.where("isbn = ?", "#{isbn}") if isbn.present?
      query = query.where("pages #{page_operator} ?", "#{pages}") if pages.present?

      if categories.present?
        categories.each do |category|
          query = query & Book.joins(:categories).where("name = ?", "#{category}")
        end
      end

      results = query.take(12)
    end

    results
  end

  def clean_attributes
    self.instance_variables.each do |var|
      value = instance_variable_get(var)
      value.strip! if value.kind_of?(String) && value.present?
    end
  end
end