# {
#   imports = [
#     # ./options
#     (import ./options).git
#     ./programs
#   ];
# }

{
  programs = import ./programs;
  options = import ./options;
  profiles = import ./profiles;
}
