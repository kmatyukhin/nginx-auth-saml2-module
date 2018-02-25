use Test::Nginx::Socket;

plan tests => 2 * repeat_each(1) * blocks();
run_tests();

__DATA__

=== TEST 1: sanity
--- main_config
load_module /tmp/nginx/modules/ngx_auth_saml2_module.so;
--- config
        auth_saml2_idp_metadata;
--- request
GET /
--- response_body_like chomp
It works!
