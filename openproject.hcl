job "openproject" {
  datacenters = ["dc1"]
  type        = "service"
  

  group "openproject" {
    count = 1
  
    network {
      mode = "host"

      port "web" {
        to = 8080
      }
      
      port "memcache" {
        to = 11211
        static = 11211
      }
    }

    service {
      name = "openproject"
      port = "web"
      provider = "consul"
	  	tags = ["openproject"]
    }

    task "cache" {
      driver = "docker"

      config {
        image = "memcached:latest"
        ports = ["memcache"]
      }

      resources {
        cpu    = 100
        memory = 128
      }
    }

    task "web" {
      driver = "docker"
      user   = "root"
	  

      config {
        image = "openproject/openproject:16.2-slim"
        ports = ["web"]
    		command = "./docker/prod/web"
				volumes = ["/var/nomad/data/openproject:/var/openproject/assets"]
      }

      env {
        OPENPROJECT_HTTPS                     = "false"
        OPENPROJECT_HOST__NAME                = "localhost:8080"
        OPENPROJECT_HSTS                      = "true"
        RAILS_CACHE_STORE                    = "memcache"
        OPENPROJECT_CACHE__MEMCACHE__SERVER   = "localhost:11211"
        RUBY_DOWNLOAD_SHA256="f76d63efe9499dedd8526b74365c0c811af00dc9feb0bed7f5356488476e28f4"
        DATABASE_URL                          = "postgres://openproject:openproject@localhost/openproject?pool=20&encoding=unicode&reconnect=true&auth_method=scram-sha-256"
        RAILS_MIN_THREADS                    = "4"
        RAILS_MAX_THREADS                    = "16"
        IMAP_ENABLED                          = "false"
		OPENPROJECT_RAILS__RELATIVE__URL__ROOT="/"
        RUBY_DOWNLOAD_URL="https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.4.tar.xz"
		RUBY_VERSION="3.4.4"
		GEM_HOME="/usr/local/bundle"
        BUNDLE_SILENCE_ROOT_WARNING="1"
        BUNDLE_APP_CONFIG="/usr/local/bundle"
        USE_JEMALLOC="false"
        DEBIAN_FRONTEND="noninteractive"
        BUNDLE_JOBS="8"
        BUNDLE_RETRY="3"
        BUNDLE_WITHOUT="development:test"
        DOCKER="1"
        APP_USER="app"
        APP_PATH="/app"
        APP_DATA_PATH="/var/openproject/assets"
        PGVERSION="17"
        PGVERSION_CHOICES="13 15 17"
        PGBIN="/usr/lib/postgresql/17/bin"
        SECRET_KEY_BASE="OVERWRITE_ME"
        RAILS_ENV="production"
        RAILS_LOG_TO_STDOUT="1"
        RAILS_SERVE_STATIC_FILES="1"
        OPENPROJECT_EDITION="standard"
        OPENPROJECT_INSTALLATION__TYPE="docker"
        OPENPROJECT_ATTACHMENTS__STORAGE__PATH="/var/openproject/assets/files"
        OPENPROJECT_RAILS__CACHE__STORE="file_store"
        OPENPROJECT_ANGULAR_UGLIFY="true"
      }

      resources {
        cpu    = 100
        memory = 2048
      }
    }

    task "worker" {
      driver = "docker"
	  
      config {
        image = "openproject/openproject:16.2-slim"
    		command = "./docker/prod/worker"
				volumes = ["/var/nomad/data/openproject:/var/openproject/assets"]
      }

      env {
        OPENPROJECT_HTTPS                     = "false"
        OPENPROJECT_HOST__NAME                = "localhost:8080"
        OPENPROJECT_HSTS                      = "true"
        RAILS_CACHE_STORE                    = "memcache"
        OPENPROJECT_CACHE__MEMCACHE__SERVER  = "localhost:11211"
        DATABASE_URL                          = "postgres://openproject:openproject@localhost/openproject?pool=20&encoding=unicode&reconnect=true&auth_method=scram-sha-256"
        RAILS_MIN_THREADS                    = "4"
        RAILS_MAX_THREADS                    = "16"
        IMAP_ENABLED                          = "false"
		OPENPROJECT_RAILS__RELATIVE__URL__ROOT="/"
        RUBY_DOWNLOAD_URL="https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.4.tar.xz"
		RUBY_VERSION="3.4.4"
		GEM_HOME="/usr/local/bundle"
        BUNDLE_SILENCE_ROOT_WARNING="1"
        BUNDLE_APP_CONFIG="/usr/local/bundle"
        USE_JEMALLOC="false"
        DEBIAN_FRONTEND="noninteractive"
        BUNDLE_JOBS="8"
        BUNDLE_RETRY="3"
        BUNDLE_WITHOUT="development:test"
        DOCKER="1"
        APP_USER="app"
        APP_PATH="/app"
        APP_DATA_PATH="/var/openproject/assets"
        PGVERSION="17"
        PGVERSION_CHOICES="13 15 17"
        PGBIN="/usr/lib/postgresql/17/bin"
        SECRET_KEY_BASE="OVERWRITE_ME"
        RAILS_ENV="production"
        RAILS_LOG_TO_STDOUT="1"
        RAILS_SERVE_STATIC_FILES="1"
        OPENPROJECT_EDITION="standard"
        OPENPROJECT_INSTALLATION__TYPE="docker"
        OPENPROJECT_ATTACHMENTS__STORAGE__PATH="/var/openproject/assets/files"
        OPENPROJECT_RAILS__CACHE__STORE="file_store"
        OPENPROJECT_ANGULAR_UGLIFY="true"
      }

      resources {
        cpu    = 100
        memory = 1024
      }
    }

    task "cron" {
      driver = "docker"

      config {
        image = "openproject/openproject:16.2-slim"
    		command = "./docker/prod/cron"
				volumes = ["/var/nomad/data/openproject:/var/openproject/assets"]
      }

      env {
        OPENPROJECT_HTTPS                     = "false"
        OPENPROJECT_HOST__NAME                = "localhost:8080"
        OPENPROJECT_HSTS                      = "true"
        RAILS_CACHE_STORE                    = "memcache"
        OPENPROJECT_CACHE__MEMCACHE__SERVER  = "localhost:11211"
        DATABASE_URL                          = "postgres://openproject:openproject@localhost/openproject?pool=20&encoding=unicode&reconnect=true&auth_method=scram-sha-256"
        RAILS_MIN_THREADS                    = "4"
        RAILS_MAX_THREADS                    = "16"
        IMAP_ENABLED                          = "false"
		OPENPROJECT_RAILS__RELATIVE__URL__ROOT="/"
        RUBY_DOWNLOAD_URL="https://cache.ruby-lang.org/pub/ruby/3.4/ruby-3.4.4.tar.xz"
		RUBY_VERSION="3.4.4"
		GEM_HOME="/usr/local/bundle"
        BUNDLE_SILENCE_ROOT_WARNING="1"
        BUNDLE_APP_CONFIG="/usr/local/bundle"
        USE_JEMALLOC="false"
        DEBIAN_FRONTEND="noninteractive"
        BUNDLE_JOBS="8"
        BUNDLE_RETRY="3"
        BUNDLE_WITHOUT="development:test"
        DOCKER="1"
        APP_USER="app"
        APP_PATH="/app"
        APP_DATA_PATH="/var/openproject/assets"
        PGVERSION="17"
        PGVERSION_CHOICES="13 15 17"
        PGBIN="/usr/lib/postgresql/17/bin"
        SECRET_KEY_BASE="OVERWRITE_ME"
        RAILS_ENV="production"
        RAILS_LOG_TO_STDOUT="1"
        RAILS_SERVE_STATIC_FILES="1"
        OPENPROJECT_EDITION="standard"
        OPENPROJECT_INSTALLATION__TYPE="docker"
        OPENPROJECT_ATTACHMENTS__STORAGE__PATH="/var/openproject/assets/files"
        OPENPROJECT_RAILS__CACHE__STORE="file_store"
        OPENPROJECT_ANGULAR_UGLIFY="true"
      }

      resources {
        cpu    = 100
        memory = 1024
      }
    }
  }
}