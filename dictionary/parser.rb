require 'csv'

class String
  def downcase_cyrillic
    upper_case = 'АБВГДЕЁЖЗИЙКЛМНОПРСТУФХЦЧШЩЬЫЪЭЮЯ'
    lower_case = 'абвгдеёжзийклмнопрстуфхцчшщьыъэюя'
    downcase_hash = {}

    upper_case.each_char do |c|
      downcase_hash[c.to_sym] = lower_case[upper_case.index c]
    end

    self.each_char do |c|
      if upper_case.include? c
        self.gsub!(c, downcase_hash[c.to_sym])
      end
    end
  end

  def clean
    self.gsub('-', ' ').gsub(/[^A-Za-zА-Яа-я ]/, '')
  end

end

def get_hash(word, set=:qwerty)
  case set
    when :qwerty
      translate_hash = {a: 4, b: 8, c: 7, d: 4, e: 1, f: 5, g: 5, h: 5, i: 3, j: 6, k: 6, l: 6, m: 8, n: 8, o: 3, p: 3, q: 1, r: 2, s: 4, t: 2, u: 2, v: 8, w: 1, x: 7, y: 2, z: 7,
                        а: 4, б: 8, в: 4, г: 2, д: 6, е: 2, ё: 2, ж: 6, з: 3, и: 8, й: 1, к: 1, л: 6, м: 7, н: 2, о: 5, п: 5, р: 5, с: 7, т: 8, у: 1, ф: 4, х: 3, ц: 1, ч: 7, ш: 3, щ: 3, ъ: 3, ы: 4, ь: 8, э: 6, ю: 8, я: 7}
    when :abc
      translate_hash = {a: 1, b: 1, c: 1, d: 2, e: 2, f: 2, g: 3, h: 3, i: 3, j: 4, k: 4, l: 4, m: 5, n: 5, o: 5, p: 6, q: 6, r:6, s: 6, t: 7, u: 7, v: 7, w: 8, x: 8, y: 8, z: 8,
                        а: 1, б: 1, в: 1, г: 1, д: 2, е: 2, ё: 2, ж: 2, з: 2, и: 3, й: 3, к: 3, л: 3, м: 4, н: 4, о: 4, п: 4, р: 5, с: 5, т: 5, у: 5, ф: 6, х: 6, ц: 6, ч: 6, ш: 7, щ: 7, ъ: 7, ы: 7, ь: 8, э: 8, ю: 8, я: 8}
    else
  end

  qwerty_hash = ''
  word.each_char do |c|
    qwerty_hash += translate_hash[c.to_sym].to_s
  end
  qwerty_hash
end

def add_new_words(line, words_list)
  line_words = line.clean.downcase.downcase_cyrillic.split(' ')
  line_words.each do |word|
    if words_list.include?(word)
      words_list[word][:frequency] = words_list[word][:frequency] + 1
      next
    end
    words_list[word] = {frequency: 1, abc_hash: get_hash(word, :abc), qwerty_hash: get_hash(word, :qwerty)}
  end
end

def save_csv_file(file_name, words_list)
  CSV.open(file_name, 'w') do |csv|
    csv << ['Word', 'Frequency', 'Abc Hash', 'Qwerty Hash']
    words_list.sort.each do |word_hash|
      csv << [word_hash[0], word_hash[1][:frequency], word_hash[1][:abc_hash], word_hash[1][:qwerty_hash]] if word_hash[1][:frequency] > 1
    end
  end
end

words_list = Hash.new
Dir['*.txt'].each do |file_name|
  f = open file_name
  f.readlines.each do |line|
    add_new_words(line, words_list)
  end
end
# p words_list

save_csv_file('result.csv', words_list)

