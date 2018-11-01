Return-Path: <vgoyal@redhat.com>
Date: Thu, 1 Nov 2018 09:03:22 -0400
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v2 1/5] ovl: return error on mount if metacopy cannot be
 enabled
Message-ID: <20181101130322.GA15140@redhat.com>
References: <20181101004813.31349-1-amir73il@gmail.com>
 <20181101004813.31349-2-amir73il@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20181101004813.31349-2-amir73il@gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org
List-ID: <linux-unionfs@vger.kernel.org>

On Thu, Nov 01, 2018 at 02:48:09AM +0200, Amir Goldstein wrote:

[..]
> + * Check dependencies between features.
> + *
> + * @enabled is a boolean variable that depends on the boolean @required
> + * variable.
> + *
> + * If !@config->strict, the feature is disabled when requirement is not met.
> + * If @config->strict, return error when requirement is not met.
> + *
> + * @feature is the name of the feature and @requirement is the description of
> + * the requirement for the error/warning message.
> + */
> +static int ovl_feature_check(struct ovl_config *config, bool *enabled,
> +			     bool required, const char *feature,
> +			     const char *requirement)
> +{
> +	/* If feature is enabled, required condition should be met */
> +	if (!*enabled || required)
> +		return 0;
> +
> +	*enabled = false;

So going forward, we will allow disabling a feature if strict is not
set? Even for new knobs? IOW, say I introduce a feature foo, it will
have two modes it will work in (strict=on, strict=off?)

Do we really need this for newer options. I thought we needed this
behavior only for older options due to backward compatibility issues.

> +
> +	return ovl_feature_requires(config, feature, requirement);
> +}
> +
>  static void ovl_entry_stack_free(struct ovl_entry *oe)
>  {
>  	unsigned int i;
> @@ -64,11 +108,6 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
>  		dput(oe->lowerstack[i].dentry);
>  }
>  
> -static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
> -module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
> -MODULE_PARM_DESC(ovl_metacopy_def,
> -		 "Default to on or off for the metadata only copy up feature");
> -
>  static void ovl_dentry_release(struct dentry *dentry)
>  {
>  	struct ovl_entry *oe = dentry->d_fsdata;

[..]
> @@ -548,6 +587,7 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>  
>  		case OPT_METACOPY_ON:
>  			config->metacopy = true;
> +			config->strict = true;

I think either ->strict should go in a separate patch or we should have
a good description in commit message, explaining why ->strict is there
and how it will impact behavior going forward.

Thanks
Vivek
