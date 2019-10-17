require 'pry'

class Student

    attr_accessor :name, :grade
    attr_reader :id

    @@all = []

    def initialize(name, grade, id = nil)

        @id = id
        @name = name
        @grade = grade

        self.class.all << self
        
    end

    def self.all

        @@all

    end

    def self.create_table

        sql = <<~SQL

            CREATE TABLE IF NOT EXISTS students (

                id INTEGER PRIMARY KEY,
                name TEXT,
                grade TEXT
            
            );
        
        SQL

        DB[:conn].execute(sql)
        
    end

    def self.drop_table

        sql = <<~SQL

            DROP TABLE IF EXISTS students;
        
        SQL

        DB[:conn].execute(sql)

    end

    def save

        sql = <<~SQL

            INSERT INTO students (name, grade) VALUES (?, ?)
        
        SQL

        DB[:conn].execute(sql, self.name, self.grade)

        @id = DB[:conn].execute("SELECT last_insert_rowid() FROM students").flatten.first
        
    end

    def self.create(data)

        student = Student.new(data[:name], data[:grade])
        student.save
        student
        
    end
  
end
