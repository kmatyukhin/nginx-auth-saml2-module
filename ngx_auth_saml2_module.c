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
#include <lasso/lasso.h>


typedef struct {
    ngx_http_complex_value_t   idp_metadata;
} ngx_auth_saml2_loc_conf_t;


static void *ngx_auth_saml2_create_loc_conf(ngx_conf_t *cf);
static char *ngx_auth_saml2_merge_loc_conf(ngx_conf_t *cf,
    void *parent, void *child);
static ngx_int_t ngx_auth_saml2_worker_init(ngx_cycle_t *cycle);
static void ngx_auth_saml2_worker_exit(ngx_cycle_t *cycle);
static char *ngx_auth_saml2(ngx_conf_t *cf, ngx_command_t *cmd, void *conf);


static ngx_command_t  ngx_auth_saml2_commands[] = {

    { ngx_string("auth_saml2_idp_metadata"),
      NGX_HTTP_MAIN_CONF | NGX_HTTP_SRV_CONF | NGX_CONF_TAKE1,
      ngx_auth_saml2,
      NGX_HTTP_LOC_CONF_OFFSET,
      offsetof(ngx_auth_saml2_loc_conf_t, idp_metadata),
      NULL },

    ngx_null_command
};


static ngx_http_module_t  ngx_auth_saml2_module_ctx = {
    NULL,                            /* preconfiguration */
    NULL,                            /* postconfiguration */

    NULL,                            /* create main configuration */
    NULL,                            /* init main configuration */

    NULL,                            /* create server configuration */
    NULL,                            /* merge server configuration */

    ngx_auth_saml2_create_loc_conf,  /* create location configuration */
    ngx_auth_saml2_merge_loc_conf    /* merge location configuration */
};


ngx_module_t ngx_auth_saml2_module = {
    NGX_MODULE_V1,
    &ngx_auth_saml2_module_ctx,      /* module context */
    ngx_auth_saml2_commands,         /* module directives */
    NGX_HTTP_MODULE,                 /* module type */
    NULL,                            /* init master */
    NULL,                            /* init module */
    ngx_auth_saml2_worker_init,      /* init process */
    NULL,                            /* init thread */
    NULL,                            /* exit thread */
    ngx_auth_saml2_worker_exit,      /* exit process */
    NULL,                            /* exit master */
    NGX_MODULE_V1_PADDING
};


static void *
ngx_auth_saml2_create_loc_conf(ngx_conf_t *cf)
{
    ngx_auth_saml2_loc_conf_t  *conf;

    conf = ngx_pcalloc(cf->pool, sizeof(ngx_auth_saml2_loc_conf_t));
    if (conf == NULL) {
        return NULL;
    }

    return conf;
}


static char *
ngx_auth_saml2_merge_loc_conf(ngx_conf_t *cf, void *parent, void *child)
{
    ngx_auth_saml2_loc_conf_t  *prev = parent;
    ngx_auth_saml2_loc_conf_t  *conf = child;

    if (conf->idp_metadata.value.data == NULL) {
        conf->idp_metadata = prev->idp_metadata;
    }

    return NGX_CONF_OK;
}


static ngx_int_t
ngx_auth_saml2_worker_init(ngx_cycle_t *cycle)
{
    lasso_init();
    return NGX_OK;
}


static void
ngx_auth_saml2_worker_exit(ngx_cycle_t *cycle)
{
    lasso_shutdown();
    return;
}


static char *
ngx_auth_saml2(ngx_conf_t *cf, ngx_command_t *cmd, void *conf)
{
    return NGX_CONF_OK;
}
