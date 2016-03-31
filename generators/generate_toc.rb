require_relative 'structure_of_pragmatic_programming'

class TableOfContents

  def create

    readme = File.open("README.md", 'rb') { |f| f.read }

    start_split = "##### Existing Pages"
    end_split = "##### Generating the ebook"

    start = readme.split(start_split)[0]
    rest = readme.split(start_split)[1]
    finale = rest.split(end_split)[1]

    template = start_split + "\n\n| Topic | Last Updated | State | Length | \n| -------|------|---|-----|\n"

    template = add_markdown_files_to template
    estimates = rough_completion_estimate

    template += "\n\nOver 200 words: " + estimates[:covered] + "%"
    template += "\nOver 300 words: " + estimates[:solid] + "%"
    template += "\nTODOs: " + `grep -r TODO chapters/`.strip.lines.count.to_s
    template += "\nWords: " + estimates[:total]

    new_file = start + template + "\n\n\n" + end_split + finale
    File.open("README.md", 'w') { |f| f.write new_file }

  end

  def add_markdown_files_to template
    mdfiles = get_markdown_files

    left_overs = MARKDOWN_FILES - mdfiles

    (MARKDOWN_FILES + left_overs).each do |mdfile|
      title = mdfile[0..-4].gsub("_", " ")
                           .gsub(/\w+/) { |word| word.capitalize }
                           .gsub("Ios", "iOS")
                           .gsub("Chapters/", "")
                           .gsub("En-Uk/", "")
                           .gsub("Oss", "OSS")
                           .gsub("Xctest", "XCTest")

      last_updated = `git log -1  --date=short --pretty=format:"%ad" #{mdfile}`
      words = `wc -w #{mdfile}`.split(" ").first

      template += "|[#{title}](#{mdfile})|#{last_updated}|#{state(words.to_i)}|Words: #{words}|\n"
    end
    template
  end

  def state(words)
    if words < 100
      "✍🏾"
    elsif words < 200
      "📎"
    elsif words < 300
      "📋"
    else
      "💌"
    end
  end

  def rough_completion_estimate
    over_three_hundred = 0
    over_two_hundred = 0
    total = 0

    MARKDOWN_FILES.each do |mdfile|
      words = `wc -w #{mdfile}`.split(" ").first.to_i

      over_three_hundred += 1 if words > 300
      over_two_hundred += 1 if words > 200
      total += words
    end

    return {
      :solid => ((over_three_hundred / MARKDOWN_FILES.count.to_f) * 100).round(1).to_s,
      :covered => ((over_two_hundred / MARKDOWN_FILES.count.to_f) * 100).round(1).to_s,
      :total => total.to_s
    }
  end
end
