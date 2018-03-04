use Test::Nginx::Socket;

plan tests => 2 * repeat_each(1) * blocks();
$ENV{TEST_NGINX_SERVROOT} = server_root();
run_tests();

__DATA__

=== TEST 1: sanity
--- main_config
load_module /tmp/nginx/modules/ngx_auth_saml2_module.so;
--- config
        auth_saml2_idp_metadata $TEST_NGINX_SERVROOT/../metadata/idp_metadata.xml;
--- request
GET /
--- response_body_like chomp
It works!
