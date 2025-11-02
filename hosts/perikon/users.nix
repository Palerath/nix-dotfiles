{ self, pkgs, ... }:

{
    # Import shared user from main repo
    perihelie = import (self + "/users/perihelie") { inherit pkgs; };

} 
