/**
 *
 * @file   ngx_auth_saml2_module.c
 * @author Konstantin Matyukhin <kmatyukhin@gmail.com>
 *
 * @brief  SAML2 Authentication module for Nginx.
 *
 */
#include <ngx_config.h>
#include <ngx_core.h>
#include <ngx_http.h>

static char *ngx_auth_saml2(ngx_conf_t *cf, ngx_command_t *cmd, void *conf);

/**
 * Module directives
 *
 */
static ngx_command_t ngx_auth_saml2_commands[] = {

    { ngx_string("auth_saml2_idp_metadata"),
      NGX_HTTP_MAIN_CONF | NGX_HTTP_SRV_CONF | NGX_CONF_NOARGS,
      ngx_auth_saml2, /* configuration setup function */
      0, /* No offset. Only one context is supported. */
      0, /* No offset when storing the module configuration on struct. */
      NULL },

    ngx_null_command /* command termination */
};

/**
 * Module context
 *
 */
static ngx_http_module_t ngx_auth_saml2_module_ctx = {
    NULL, /* preconfiguration */
    NULL, /* postconfiguration */

    NULL, /* create main configuration */
    NULL, /* init main configuration */

    NULL, /* create server configuration */
    NULL, /* merge server configuration */

    NULL, /* create location configuration */
    NULL  /* merge location configuration */
};

/**
 * Module definition
 *
 */
ngx_module_t ngx_auth_saml2_module = {
    NGX_MODULE_V1,
    &ngx_auth_saml2_module_ctx, /* module context */
    ngx_auth_saml2_commands, /* module directives */
    NGX_HTTP_MODULE, /* module type */
    NULL, /* init master */
    NULL, /* init module */
    NULL, /* init process */
    NULL, /* init thread */
    NULL, /* exit thread */
    NULL, /* exit process */
    NULL, /* exit master */
    NGX_MODULE_V1_PADDING
};

static char *ngx_auth_saml2(ngx_conf_t *cf, ngx_command_t *cmd, void *conf)
{
    return NGX_CONF_OK;
}
