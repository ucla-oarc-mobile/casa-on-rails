class CreateAppCompetencies < ActiveRecord::Migration
  def change
    # Add support for tag-like competencies.
    # The CASA Competency attribute has a more complex data structure that can be supported in the future if necessary.
    create_table :app_competencies do |t|

        t.references :app
        t.string :name
        t.timestamps

    end
  end
end
