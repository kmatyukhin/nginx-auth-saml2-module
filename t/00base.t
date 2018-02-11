use Test::Nginx::Socket;

plan tests => 2 * repeat_each(1) * blocks();
run_tests();

__DATA__

=== TEST 1: sanity
--- config
--- request
GET /
--- response_body_like chomp
It works!
