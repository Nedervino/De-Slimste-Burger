require_relative 'arango'

class QuestionGenerator
  def self.welfare_question
    body = {
      query: "FOR u IN uitkeringsontvangers LET r=DOCUMENT(regios, u._key) FILTER r SORT u.Werkloosheid DESC LIMIT 20 SORT u.Werkloosheid / r.aantal DESC RETURN { 'regio': u._key, 'werkloosheid': u.Werkloosheid, 'inwoners': r.aantal, 'percentage': (u.Werkloosheid / r.aantal) * 100}"
    }
    result = Arango.new.fetch(:post, '/_db/hackaton/_api/cursor', body)
    options = result.shuffle[0..2].map do |options|
      {
        label: options['regio'],
        value: "#{options['percentage'].round(2).to_s}%"
      }
    end
    {
      type: 'MultipleChoiceQuestion',
      title: 'Welke gemeente heeft het hoogste aantal uitkeringsontvangers?',
      body: {options: options, answer: max_answer(options)}
    }
  end

  def self.education_question
    body = {
      query: "FOR gem IN lasten16 LET regio = DOCUMENT(regios, gem.gemeente) FILTER regio LET ratio = (gem.onderwijs_cultuur_recreatie * 1000) / regio.aantal SORT regio.aantal DESC LIMIT 20 SORT ratio DESC RETURN { \"naam\": gem.gemeente, \"bedrag\": (gem.onderwijs_cultuur_recreatie * 1000), \"inwoners\": regio.aantal, \"ratio\": ratio }"
    }
    result = Arango.new.fetch(:post, '/_db/hackaton/_api/cursor', body)
    options = result.shuffle[0..2].map do |options|
      {
        label: options['naam'],
        value: "€#{options['ratio'].round(2)} per persoon"
      }
    end
    {
      type: 'MultipleChoiceQuestion',
      title: 'In welke gemeente zijn de kosten per burger voor Onderwijs, Cultuur & Recreatie het hoogste?',
      body: {options: options.shuffle, answer: max_answer(options)}
    }
  end

  def self.health_question
    body = {
      query: "FOR gem IN lasten16 LET regio = DOCUMENT(regios, gem.gemeente) FILTER regio LET ratio = (gem.volksgezondheid_milieu * 1000) / regio.aantal SORT regio.aantal DESC LIMIT 20 SORT ratio DESC RETURN { \"naam\": gem.gemeente, \"bedrag\": (gem.volksgezondheid_milieu * 1000), \"inwoners\": regio.aantal, \"ratio\": ratio }"
    }
    result = Arango.new.fetch(:post, '/_db/hackaton/_api/cursor', body)
    options = result.shuffle[0..2].map do |options|
      {
        label: options['naam'],
        value: "€#{options['ratio'].round(2)} per persoon"
      }
    end
    {
      type: 'MultipleChoiceQuestion',
      title: 'In welke gemeente zijn de kosten per burger voor het Volksgezondheid & Milieu het hoogste?',
      body: {options: options.shuffle, answer: max_answer(options)}
    }
  end

  def self.social_question
    body = {
      query: "FOR gem IN lasten16 LET regio = DOCUMENT(regios, gem.gemeente) FILTER regio LET ratio = (gem.sociale_voorzieningen_maatschappelijk_dienstverlening * 1000) / regio.aantal SORT regio.aantal DESC LIMIT 20 SORT ratio DESC RETURN { \"naam\": gem.gemeente, \"bedrag\": (gem.sociale_voorzieningen_maatschappelijk_dienstverlening * 1000), \"inwoners\": regio.aantal, \"ratio\": ratio }"
    }
    result = Arango.new.fetch(:post, '/_db/hackaton/_api/cursor', body)
    options = result.shuffle[0..2].map do |options|
      {
        label: options['naam'],
        value: "€#{options['ratio'].round(2)} per persoon"
      }
    end
    {
      type: 'MultipleChoiceQuestion',
      title: 'In welke gemeente zijn de kosten per burger voor het Sociale voorzieningen & Maatschappelijk dienstverlening het hoogste?',
      body: {options: options.shuffle, answer: max_answer(options)}
    }
  end

  def self.spacial_question
    body = {
      query: "FOR gem IN lasten16 LET regio = DOCUMENT(regios, gem.gemeente) FILTER regio LET ratio = (gem.ruimtelijk_ordening_huisvesting * 1000) / regio.aantal SORT regio.aantal DESC LIMIT 20 SORT ratio DESC RETURN { \"naam\": gem.gemeente, \"bedrag\": (gem.ruimtelijk_ordening_huisvesting * 1000), \"inwoners\": regio.aantal, \"ratio\": ratio }"
    }
    result = Arango.new.fetch(:post, '/_db/hackaton/_api/cursor', body)
    options = result.shuffle[0..2].map do |options|
      {
        label: options['naam'],
        value: "€#{options['ratio'].round(2)} per persoon"
      }
    end
    {
      type: 'MultipleChoiceQuestion',
      title: 'In welke gemeente zijn de kosten per burger voor het Ruimtelijke ordening & Huisvesting het hoogste?',
      body: {options: options.shuffle, answer: max_answer(options)}
    }
  end

  def self.national_budget_question
    body = {
      collection: 'rijksbegroting'
    }
    result = Arango.new.fetch(:put, '/_db/hackaton/_api/simple/all', body)
    options = result.shuffle[0..2].map do |options|
      {
        label: options['onderdeel'],
        value: "#{options['2017']} mln"
      }
    end
    {
      type: 'MultipleChoiceQuestion',
      title: 'Voor welke post is er in 2017 het meest inbegroot?',
      body: {options: options, answer: max_answer(options)}
    }
  end

  def self.king_budget_question
    body = {
      collection: 'rijksbegroting'
    }
    result = Arango.new.fetch(:put, '/_db/hackaton/_api/simple/all', body)
    budget = result.select {|v| v['2016'] > 100}.sample
    value = budget['2016']/41
    options = random_options(value, suffix: 'x', range: [*(10*value).to_i..(200*value).to_i], min_dif: 10, decimal: 0)

    {
      type: 'MultipleChoiceQuestion',
      title: "'Hoe vaak past in de Rijksbegroting van 2016 het budget voor de Koning in het budget voor #{budget['onderdeel']}?'",
      body: {options: options, answer: "#{value}x"}
    }
  end

  def self.national_budget_percentage_question
    body = {
      collection: 'rijksbegroting'
    }
    result = Arango.new.fetch(:put, '/_db/hackaton/_api/simple/all', body)
    budget = result.select {|v| v['2016'] > 5000}.sample
    value = ((budget['2016'].to_f/148716)*100).round(2)
    options = random_options(value, suffix: '%', range: [*(10*value).to_i..(200*value).to_i], min_dif: value/5, max_value: 90)
    {
      type: 'MultipleChoiceQuestion',
      title: "'Hoeveel procent van het rijksbudget van 2016 gaat naar #{budget['onderdeel']}?'",
      body: {options: options, answer: "#{value}%"}
    }
  end

  def self.cito_option(results, lowest, highest)
    value = results[lowest..highest].sample
    {
      label: value['gemeente'],
      value: value['gemiddelde'].round(2)
    }

  end

  def self.cito_question
    body = {
      query: "FOR school IN citoscores1415 FILTER school.cito_gemiddeld SORT school.cito_gemiddeld DESC LET product = school.cito_gemiddeld * school.aantal COLLECT g = school.gemeente INTO groups LET aantal = SUM(groups[*].school.aantal) LET gem = SUM(groups[*].product) / aantal SORT gem DESC RETURN { 'gemeente': g , 'gemiddelde': gem, 'scholieren': aantal }"
    }
    result = Arango.new.fetch(:post, '/_db/hackaton/_api/cursor', body)
    options = []
    options << cito_option(result, 0, 20)
    options << cito_option(result, result.count/2 - 10, result.count/2 + 10)
    options << cito_option(result, result.count-20, result.count)
    {
      type: 'MultipleChoiceQuestion',
      title: 'In welke gemeente werd in 2015 gemiddeld de hoogste CITO-score gehaald?',
      body: {options: options.shuffle, answer: max_answer(options)}
    }
  end

  def self.miljoenennota_question
    options = [
      {
        label: 'Volksgezondheid',
        value: '400 mln'
      },
      {
        label: 'Onderwijs',
        value: '200 mln'
      },
      {
        label: 'Veiligheid en justitie',
        value: '450 mln'
      },
      {
        label: 'Defensie',
        value: '300 mln'
      },
      {
        label: 'Arme kinderen',
        value: '100 mln'
      },
      {
        label: 'Partners chronisch zieken',
        value: '50 mln'
      }
    ].shuffle[0..2]
    {
      type: 'MultipleChoiceQuestion',
      title: 'Onlangs is de Miljoenennota 2016 gelekt. Welke post krijgt er het meeste bij?',
      body: {options: options, answer: max_answer(options)}
    }
  end

  private

  def self.max_answer(options)
    options.sort_by { |h| h[:value].to_f }.reverse[0][:value]
  end

  def self.random_options(value, opts={})
    opts = {
      suffix: '',
      decimal: 2,
      range: [*(50*value).to_i..(200*value).to_i],
      min_dif: 1,
      max_value: nil
    }.merge(opts)
    options = [
      {
        label: "#{value}#{opts[:suffix]}",
        value: value
      }
    ]
    2.times do
      random = value
      while options.detect { |v| (v[:value]-random).abs < opts[:min_dif] } || (opts[:max_value].present? && random > opts[:max_value]) do
        random = (opts[:range].sample.to_f/100).round(opts[:decimal])
      end
      options << {
        label: "#{random}#{opts[:suffix]}",
        value: random
      }
    end
    options.shuffle
  end
end
