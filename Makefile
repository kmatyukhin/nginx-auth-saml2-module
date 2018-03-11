TMP_DIR       := /tmp/nginx
MOD_DIR       := $(shell pwd)

NGINX_VERSION := 1.10.3

COVERAGE      ?= 1

NGINX_OPTIONS  = "--prefix=$(TMP_DIR)"
NGINX_OPTIONS += "--conf-path=$(TMP_DIR)/nginx.conf"
NGINX_OPTIONS += "--with-select_module"
NGINX_OPTIONS += "--http-client-body-temp-path=$(TMP_DIR)/body/"
NGINX_OPTIONS += "--http-fastcgi-temp-path=$(TMP_DIR)/fastcgi/"
NGINX_OPTIONS += "--http-proxy-temp-path=$(TMP_DIR)/proxy/"
NGINX_OPTIONS += "--without-mail_pop3_module"
NGINX_OPTIONS += "--without-mail_smtp_module"
NGINX_OPTIONS += "--without-mail_imap_module"
NGINX_OPTIONS += "--without-http_rewrite_module"
NGINX_OPTIONS += "--without-http_gzip_module"
NGINX_OPTIONS += "--without-http_uwsgi_module"
NGINX_OPTIONS += "--without-http_scgi_module"
NGINX_OPTIONS += "--add-dynamic-module=$(MOD_DIR)"

CFLAGS := $(shell pkg-config lasso --cflags |tr '"' "")
LDLIBS := $(shell pkg-config lasso --libs)

.PHONY: all

all: nginx_download configure build install

nginx_download:
	wget --no-clobber "http://nginx.org/download/nginx-$(NGINX_VERSION).tar.gz" || exit 1
	wget --no-clobber "http://nginx.org/download/nginx-$(NGINX_VERSION).tar.gz.asc" || exit 1
#	gpg --keyserver pgp.key-server.io --recv-keys 0x251a28de2685aed4 0x520A9993A1C052F8
#	gpg --verify "nginx-"$(NGINX_VERSION)".tar.gz.asc" "nginx-"$(NGINX_VERSION)".tar.gz" || exit 1
	mkdir -p $(TMP_DIR)
	tar -C $(TMP_DIR) -xzf "nginx-$(NGINX_VERSION).tar.gz"  --strip-components=1

configure:
ifeq ($(COVERAGE),1)
	cd $(TMP_DIR) && ./configure --with-cc-opt="-O0 --coverage $(CFLAGS)" \
        --with-ld-opt="$(LDLIBS) -lgcov" $(NGINX_OPTIONS)
else
	cd $(TMP_DIR) && ./configure --with-cc-opt="-O3 $(CFLAGS)" \
        --with-ld-opt="$(LDLIBS)" $(NGINX_OPTIONS)
endif

build:
	make -C $(TMP_DIR)

install:
	make -C $(TMP_DIR) install

test: $(TMP_DIR)/sbin/nginx
	@lcov -q --directory $(TMP_DIR)/objs/addon/nginx-auth-saml2-module --zerocounters
	@if [ ! $(TEST) ] ; then TEST="*.t" ; fi
	@PATH="$(TMP_DIR)/sbin":$(PATH) \
	prove -r "t/$(TEST)"
ifeq ($(COVERAGE),1)
	@gcov --object-directory $(TMP_DIR)/objs/addon/nginx-auth-saml2-module *.c >/dev/null
endif

coverage:
	lcov --directory $(TMP_DIR)/objs/addon/nginx-auth-saml2-module \
     --capture --output-file coverage.info --base-directory $(TMP_DIR)
	genhtml -s -o $(TMP_DIR)/coverage coverage.info
