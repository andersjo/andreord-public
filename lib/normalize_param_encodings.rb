# encoding: utf-8
module NormalizeParamEncodings
  def self.included(base)
    base.before_filter :normalize_param_encodings
  end

  # obtained from: http://gist.github.com/149473
  # blog: http://yob.id.au/blog/2009/07/19/rails_params_and_ruby_19/

  # On M17N aware VMs, ensure params from the user are marked with an appropriate encoding.
  #
  # As of Rails 2.3, Rack returns all params with an ASCII-8BIT encoding, which causes an
  # exception if a param is mixed with a UTF-8 string or ERB template. Hopefully that will be
  # fixed at some point and this won't be necessary any more.
  #
  # I've read in a few places that most browsers seem to submit data to the server in the same
  # encoding as the last page it received from that server. My brief testing on FF 3.0.x
  # confirmed this (for FF at least). FF also doesn't seem to explicitly specify the charset
  # on either GET or POST requests (unless they're via AJAX).
  #
  # Since we always serve UTF-8, I'm going to assume all data we get is the same. If it isn't,
  # I sanitise it.
  #
  # In *theory*, request.content_charset would contain the charset of the request, but it
  # never seems to.
  #
  # As well as marking the strings as UTF-8, I also ensure they contain valid utf-8 data. The
  # iconv technique for doing this is based on
  # http://po-ru.com/diary/fixing-invalid-utf-8-in-ruby-revisited/
  #
  private
  def normalize_param_encodings
    normalize_object_encoding(params) if String.method_defined?(:force_encoding)
  end

  def normalize_object_encoding(obj)
    case obj
    when String
      unless obj.frozen?
        obj.force_encoding(Encoding::UTF_8)
        ic = Iconv.new('UTF-8//IGNORE', 'UTF-8')
        obj.replace(ic.iconv(obj + ' ')[0..-2])
      end
    when Array
      obj.each { |o| normalize_object_encoding(o) }
    when Hash
      obj.each { |k,v| normalize_object_encoding(v) }
    end
  end

  def normalize_object_encoding_old(obj)
    case obj
    when String
      Iconv.conv('UTF-8//IGNORE', 'UTF-8', obj).force_encoding(Encoding::UTF_8)
    when Array
      obj.map { |o| normalize_object_encoding(o) }
    when Hash
      h = {}
      obj.each do |k,v|
        Rails.logger.info("#{k} = #{v}")
        h[normalize_object_encoding(k)] = normalize_object_encoding(v)
      end
      h
    end
  end


end
