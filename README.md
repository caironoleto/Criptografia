# Cripto

Cripto é uma biblioteca produzida no Coding Dojo Piauí 008 em 2009. Entenda mais sobre em http://dojopi.wordpress.com/2009/11/28/coding-dojo-008-criptografia/

Hoje, no dia 22 de janeiro de 2011, resolvi fazer um refactoring neste código e explicar mais sobre uma dúvida que o [dannluciano](https://github.com/dannlucioano) me perguntou no twitter de como estavamos usando PORO em nossos projetos na [Nohup](https://github.com/nohupbrasil).

Para começarmos, PORO é um acrônimo para Pure Old Object Ruby, que é mais um movimento da comunidade Ruby em trazer de volta aquelas velhas classes puras do Ruby.

E como tudo na comunidade Ruby onde cada movimento vem com uma pitada de amadurecimento, com os POROs não podia ser diferente. Além de resgatar a utilização de classes puras do Ruby, sem ter que herdar (na sua grande maioria do ActiveRecord) de nenhuma outra classe, o uso dos POROs é para poder aplicar os conceitos de SOLID que o Uncle Bob introduziu no desenvolvimento de software e que o Lucas Húngaro explanou muito bem em uma série de blog posts que cobre os 5 princípios de SOLID e de como aplicá-los em Ruby.

O conceito de SOLID mais forte no uso de POROs é o de [Single Responsibility](http://blog.lucashungaro.com/2011/05/04/solid-ruby-single-responsibility-principle/), onde cada classe tem apenas uma única responsabilidade. Neste refactoring, a classe Cripto tinha a responsabilidade de criptografar e descriptografar um texto. Só que ele também tinha a responsabilidade de saber o dicionário de criptografia.

```ruby
class Cripto

  # Responsabilidade de criptografar  
  def cripto
    # …
  end

  # Responsabilidade de descriptografar
  def decript
    # …
  end

  # Responsabilidade de saber o dicionário
  def dicionario
    # …
  end
end
```

Fonte: https://github.com/caironoleto/Criptografia/blob/79236001445a2e04312825668f99114d80d849f1/lib/cripto.rb

Meu refactoring nesta classe foi em retirar o dicionário da classe Cripto e de usar outro princípio do SOLID, que é o de [Dependecy Inversion](http://blog.lucashungaro.com/2011/05/09/solid-ruby-dependency-inversion-principle/), para preparar a classe Cripto a aceitar qualquer objeto que respondam a `Object#[]` e `Object#key`.

Neste caso então eu posso utilizar a class Hash, que implementa esses métodos, ou qualquer outra classe que eu possa criar e no caso eu criei a classe Dictionary.

E a implementação final da classe Cripto ficou da sequinte forma:

```ruby
class Cripto
  attr_accessor :dictionary

  def initialize(dictionary)
    self.dictionary = dictionary
  end

  def encrypt(text)
    process(:[], text)
  end

  def decrypt(text)
    process(:key, text)
  end

  private
  
  def process(method, text)
    processed_text = ""
    text.each_char do |ch|
      processed_text << (dictionary.send(method, ch) || ch)
    end
    processed_text
  end
end
```
Fonte: https://github.com/caironoleto/Criptografia/blob/dfeecf4c00590b027017514723329562a46fa9d0/lib/cripto.rb

## Aplicando esses conceitos em uma aplicação Rails

Eu falei antes que na Nohup nós não estamos utilizando callbacks, assim como reuniões, callbacks são tóxicos! No lugar deles, estamos usando POROs com a responsabilidade de fazer o que seria feito pelo callback e chamando nas actions onde eles seriam executados.

Uma coisa bastante comum em aplicações Rails é a geração de slugs. A regra mais comum para geração do slug é de sempre que o nome do usuário for passado pelo formulário para ser alterado, ele deve gerar um novo slug. A implementação mais comum é:

```ruby
class User < ActiveRecord::Base
  before_save :slugify
  
  private
  
  def slugify
    self.slug = name.parameterize.to_s
  end
end 
```

Essa abordagem fere um dos princípios que comentei anteriormente. A classe User deixa de ter somente a responsabilidade de lidar com os dados e adiciona a responsabilidade de gerar o slug sempre que o usuário for salvo.

A primeira coisa que fazemos nesse caso é extrair nossa regra de negócio para um PORO. Poderíamos fazer da seguinte forma:

```ruby
class SlugGenerator
  attr_accessor :slug
  
  def initialize(slug)
    self.slug = slug
  end
  
  def slugify!
    slug.parameterize.to_s
  end
end
```

Então para finalizar, essa regra de negócio deve sempre ser executada quando o usuário for criado ou quando for atualizado, então nós alteramos o controller de `users`:

```ruby
class UsersController < ActionController::Base
  def create
    @user = User.new(params[:user])
    
    @user.slug = SlugGenerator.new(@user.name).slugify!
    
    # …
  end

  def update
    @user = User.find(params[:id])
    
    @user.slug = Slugify(@user.name)
    
    # …
  end
end
```

Em muitos lugares diferentes da aplicação nós podemos salvar esse objeto e não necessariamente nós precisamos aplicar a regra de gerar um novo slug. O que geralmente acontece é que no uso de callbacks, você acaba tendo comportamentos inesperados na hora de salvar um objeto.

Daí na Nohup nós acabamos criando uma convenção, onde uma regra de negócio não deve ficar no model e sim em um PORO e que só deve ser executado nas actions que tem necessidade.

E ficamos com uma estrutura de diretórios assim:

![app](https://img.skitch.com/20120123-n9ypqgy419ds8urqmj1ywgu6p6.png)

Obviamente, dentro do diretório `business` estão todos os POROs com todas as regras de negócio da aplicação. Nossos models são bem simples, contendo apenas a lógica para lidar com os dados (validações, escopos de busca, etc) e toda as regras de negócio ficam dentro de `business`.

Espero que isso ajude a você a repensar melhor no design da sua aplicação.