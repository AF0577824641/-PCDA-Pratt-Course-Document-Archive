-- Drop tables in reverse order of dependencies to avoid constraint violations
DROP TABLE IF EXISTS documents_users CASCADE;
DROP TABLE IF EXISTS syllabi_documents CASCADE;
DROP TABLE IF EXISTS documents_authors CASCADE;
DROP TABLE IF EXISTS documents CASCADE;
DROP TABLE IF EXISTS syllabi CASCADE;
DROP TABLE IF EXISTS courses CASCADE;
DROP TABLE IF EXISTS authors CASCADE;
DROP TABLE IF EXISTS authors_books CASCADE;
DROP TABLE IF EXISTS tags CASCADE;
DROP TABLE IF EXISTS users CASCADE;

create table authors (
  id serial primary key,
  first_name text,
  last_name text
);

insert into authors (first_name, last_name) values ('Colleen', 'Hoover');
insert into authors (first_name, last_name) values ('John', 'Green');
insert into authors (first_name, last_name) values ('Stephenie', 'Meyer');
insert into authors (first_name, last_name) values ('Frank', 'Herbert');
insert into authors (first_name, last_name) values ('J.K.', 'Rowling');

create table tags (
  id serial primary key,
  name text
);

insert into tags (name) values ('Psychological Thriller');
insert into tags (name) values ('Romance');
insert into tags (name) values ('Fantasy');
insert into tags (name) values ('Science Fiction');
insert into tags (name) values ('Dystopian Fiction');

create table documents (
  id serial primary key,
  title text,
  publishing_year int,
  genre_id int references tags(id),
  filepath text, -- Changed file_path to filepath to match the database
  document_type text,
  created_at timestamp default current_timestamp,
  url text,
  description text,
  updated_at timestamp default current_timestamp
);

-- Sample documents with various document types
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('Verity', 2022, 1, '/documents/verity.pdf', 'PDF');
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('The Fault in Our Stars', 2012, 2, '/documents/tfios.epub', 'EPUB');
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('Twilight', 2005, 3, '/documents/twilight.mobi', 'MOBI');
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('Dune', 1965, 4, '/documents/dune.pdf', 'PDF');
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('Harry Potter and the Philosophers Stone', 1997, 3, '/documents/harry_potter.epub', 'EPUB');
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('Programming in Go', 2020, 4, '/documents/go_programming.docx', 'DOCX');
insert into documents (title, publishing_year, genre_id, file_path, document_type) values ('Web Development Basics', 2021, 4, '/documents/web_dev.txt', 'TXT');
create table documents_authors (
  document_id int references documents(id),
  author_id int references authors(id),
  primary key (document_id, author_id)
);

-- Verity by Colleen Hoover
insert into documents_authors (document_id, author_id) values (1, 1);

-- The Fault in Our Stars by John Green
insert into documents_authors (document_id, author_id) values (2, 2);

-- Twilight by Stephenie Meyer
insert into documents_authors (document_id, author_id) values (3, 3);

-- Dune by Frank Herbert
insert into documents_authors (document_id, author_id) values (4, 4);

-- Harry Potter by J.K. Rowling
insert into documents_authors (document_id, author_id) values (5, 5);


-- Create documents_users table for reading status
create table documents_users (
  id serial primary key,
  document_id int references documents(id),
  user_id text,
  read_status text
);

-- Create authors_books table (exists in the database)
create table authors_books (
  id serial primary key,
  author_id int,
  book_id int
);

-- Create courses table
create table courses (
  id serial primary key,
  code text not null,
  title text not null,
  description text,
  department text,
  credits int,
  created_at timestamp default current_timestamp
);

-- Insert sample courses
insert into courses (code, title, department, credits) values
  ('INFO 101', 'Introduction to Information Science', 'Information Science', 3),
  ('INFO 202', 'Web Development Fundamentals', 'Information Science', 4),
  ('INFO 303', 'Database Management Systems', 'Information Science', 4),
  ('INFO 405', 'Digital Libraries', 'Information Science', 3),
  ('INFO 287', 'Information Architecture', 'Information Science', 3);

  -- Create syllabi table
  create table syllabi (
    id serial primary key,
    semester varchar not null,
    year int not null,
    instructor varchar not null,
    course_id int references courses(id),
    url_link text,
    created_at timestamp default current_timestamp,
    updated_at timestamp default current_timestamp
  );

  -- Create syllabi_documents junction table
  create table syllabi_documents (
    id serial primary key,
    syllabus_id int references syllabi(id) on delete cascade,
    document_id int references documents(id) on delete cascade,
    created_at timestamp default current_timestamp,
    unique (syllabus_id, document_id)
  );

  -- Sample syllabi data
  insert into syllabi (
    course_id,
    semester,
    year,
    instructor,
    url_link
  ) values (
    1, -- course_id for 'INFO 101'
    'Fall',
    2025,
    'Dr. Jane Smith',
    '/documents/syllabi/info101_fall2025.pdf'
  );
  ```

insert into syllabi (
  course_id,
  semester,
  year,
  instructor,
  course_description,
  learning_objectives,
  required_materials,
  grading_policy,
  weekly_schedule,
  office_hours,
  file_path
) values (
  2, -- course_id for 'INFO 202'
  'Spring',
  2025,
  'Dr. John Doe',
  'Introduction to web development technologies including HTML, CSS, and JavaScript.',
  ARRAY['Create basic web pages using HTML/CSS', 'Implement interactive elements with JavaScript', 'Understand web accessibility principles'],
  'Web Development Essentials (2023), GitHub account, VS Code editor.',
  'Coding exercises: 45%, Midterm project: 20%, Final project: 35%',
  'Week 1-4: HTML/CSS basics, Week 5-8: JavaScript, Week 9-12: Frameworks and deployment...',
  'Tuesday/Thursday 1-3pm, online sessions by appointment',
  '/documents/syllabi/info202_spring2025.pdf'
);

-- Add more sample syllabi
insert into syllabi (
  course_id,
  semester,
  year,
  instructor,
  course_description,
  learning_objectives,
  required_materials,
  grading_policy,
  weekly_schedule,
  office_hours,
  file_path
) values (
  3, -- course_id for 'INFO 303'
  'Fall',
  2025,
  'Prof. Maria Garcia',
  'Advanced course covering database design, implementation, and management with focus on SQL and NoSQL systems.',
  ARRAY['Design normalized database schemas', 'Write complex SQL queries', 'Implement database security best practices', 'Work with NoSQL databases'],
  'Database Systems: Complete Guide (2024), PostgreSQL installed locally, MongoDB Atlas account',
  'Assignments: 30%, Database Project: 40%, Final Exam: 30%',
  'Week 1-3: Database Design
Week 4-6: Advanced SQL
Week 7-9: Database Administration
Week 10-12: NoSQL Systems
Week 13-15: Performance & Security',
  'Monday/Wednesday 10am-12pm, Virtual hours Friday 2-4pm',
  '/documents/syllabi/info303_fall2025.pdf'
);

insert into syllabi (
  course_id,
  semester,
  year,
  instructor,
  course_description,
  learning_objectives,
  required_materials,
  grading_policy,
  weekly_schedule,
  office_hours,
  file_path
) values (
  4, -- course_id for 'INFO 405'
  'Spring',
  2026,
  'Dr. Robert Chen',
  'Exploration of digital library systems, metadata standards, and digital preservation strategies.',
  ARRAY['Understand digital library architectures', 'Apply metadata standards', 'Implement digital preservation techniques', 'Evaluate digital library systems'],
  'Digital Libraries in the Information Age (2025), DSpace account, Metadata tools subscription',
  'Class Participation: 10%, Assignments: 40%, Team Project: 25%, Final Paper: 25%',
  'Week 1-2: Digital Library Foundations
Week 3-5: Metadata Standards
Week 6-8: Content Management Systems
Week 9-11: Digital Preservation
Week 12-14: Assessment and Evaluation',
  'Tuesday/Thursday 3-5pm, Extra help sessions scheduled as needed',
  '/documents/syllabi/info405_spring2026.pdf'
);

insert into syllabi (
  course_id,
  semester,
  year,
  instructor,
  course_description,
  learning_objectives,
  required_materials,
  grading_policy,
  weekly_schedule,
  office_hours,
  file_path
) values (
  5, -- course_id for 'INFO 287'
  'Summer',
  2025,
  'Dr. Sarah Johnson',
  'Study of organizing, structuring, and labeling information for improved findability and usability.',
  ARRAY['Create effective information hierarchies', 'Develop navigation systems', 'Conduct user research', 'Design taxonomies and controlled vocabularies'],
  'Information Architecture for the Web (2024), Optimal Workshop license, Figma account',
  'UX Research Project: 30%, Site Architecture: 30%, Final Portfolio: 40%',
  'Week 1-2: IA Principles and Methods
Week 3-4: User Research & Analysis
Week 5-6: Navigation & Wayfinding
Week 7-8: Taxonomy Design
Week 9-10: Testing & Implementation',
  'Monday/Wednesday 1-3pm, Online consultations available',
  '/documents/syllabi/info287_summer2025.pdf'
);

-- Create users table (exists in the database)
create table users (
  id serial primary key,
  name text,
  email text,
  password text,
  salt text
);

-- Add indexes for better performance
CREATE INDEX idx_documents_document_type ON documents(document_type);
CREATE INDEX idx_documents_title ON documents(title);
CREATE INDEX idx_documents_publishing_year ON documents(publishing_year);
CREATE INDEX idx_documents_genre_id ON documents(genre_id);
CREATE INDEX idx_documents_authors_document_id ON documents_authors(document_id);
CREATE INDEX idx_documents_authors_author_id ON documents_authors(author_id);
CREATE INDEX idx_documents_users_document_id ON documents_users(document_id);
CREATE INDEX idx_documents_users_user_id ON documents_users(user_id);
CREATE INDEX idx_documents_users_read_status ON documents_users(read_status);
CREATE INDEX idx_syllabi_course_id ON syllabi(course_id);
CREATE INDEX idx_syllabi_semester_year ON syllabi(semester, year);
CREATE INDEX idx_syllabi_instructor ON syllabi(instructor);
CREATE INDEX idx_courses_code ON courses(code);
CREATE INDEX idx_courses_department ON courses(department);
CREATE INDEX idx_documents_url ON documents(url);
