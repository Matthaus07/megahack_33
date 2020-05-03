module MegaExceptions
    class MegaException < StandardError; end
    class InvalidPassword < MegaException; end
    class UnknowUser < MegaException; end    
    class ExistingRecord < MegaException; end
end