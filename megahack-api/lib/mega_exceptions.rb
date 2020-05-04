module MegaExceptions
    class MegaException < StandardError; end
    class InvalidPassword < MegaException; end
    class UnknowUser < MegaException; end    
    class ExistingRecord < MegaException; end
    class UnknowProduct < MegaException; end
    class BadParameters < MegaException; end
end