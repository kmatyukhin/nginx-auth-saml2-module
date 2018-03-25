use Test::Nginx::Socket;

plan tests => 2 * repeat_each(1) * blocks();
$ENV{TEST_NGINX_SERVROOT} = server_root();
run_tests();

__DATA__

=== TEST 1: sanity
--- main_config
load_module /tmp/nginx/modules/ngx_auth_saml2_module.so;
--- config
--- request
GET /
--- response_body_like chomp
It works!
=== TEST 2: module directive
--- main_config
load_module /tmp/nginx/modules/ngx_auth_saml2_module.so;
--- config
        auth_saml2_idp_metadata $TEST_NGINX_SERVROOT/../metadata/idp_metadata.xml;
--- request
GET /
--- error_log eval
my $idp_metadata = "\Q$ENV{TEST_NGINX_SERVROOT}/../metadata/idp_metadata.xml";
qr/configured idp metadata $idp_metadata/
=== TEST 3: directive duplication
--- main_config
load_module /tmp/nginx/modules/ngx_auth_saml2_module.so;
--- config
        auth_saml2_idp_metadata $TEST_NGINX_SERVROOT/../metadata/idp_metadata.xml;
        auth_saml2_idp_metadata $TEST_NGINX_SERVROOT/../metadata/idp_metadata.xml;
--- request
GET /
--- must_die
--- error_log
"auth_saml2_idp_metadata" directive is duplicate
