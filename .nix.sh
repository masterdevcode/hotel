{ pkgs ? import <nixpkgs> {} }:

pkgs.mkShell {
  name = "laravel-env";

  buildInputs = [
    pkgs.php
    pkgs.composer
    pkgs.nodejs
    pkgs.npm
    pkgs.mysql
    pkgs.openssl
  ];

  shellHook = ''
    echo "Setting up Laravel environment..."

    # Install Laravel dependencies using Composer
    if [ -f composer.json ] && [ ! -d vendor ]; then
      composer install
    fi

    # Install Node.js dependencies using npm
    if [ -f package.json ] && [ ! -d node_modules ]; then
      npm install
    fi

    echo "Laravel environment ready."
  '';

  # Expose PHP and Node.js as environment variables
  PHP_PATH = "${pkgs.php}/bin/php";
  NODE_PATH = "${pkgs.nodejs}/bin/node";
}
