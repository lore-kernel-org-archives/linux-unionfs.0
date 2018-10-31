Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031111038.20570-1-amir73il@gmail.com> <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <20181031121920.GF23439@veci.piliscsaba.redhat.com>
In-Reply-To: <20181031121920.GF23439@veci.piliscsaba.redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 14:26:53 +0200
Message-ID: <CAOQ4uxhNPFfytQtiQ3U394i_kj609of7sG_AN9nOyjkd4keKDg@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 2:19 PM Miklos Szeredi <miklos@szeredi.hu> wrote:
>
> On Wed, Oct 31, 2018 at 12:48:20PM +0100, Miklos Szeredi wrote:
>
> > Also my feeling is that the option dependency thing is still too
> > complicated.   Why can't we just implicitly enable redirects if
> > metacopy is enabled?  Example: foo=off option is conflicting with
> > foo=on, yet we just take the one which came later, don't warn or error
> > out.  Similarly metacopy=on should just imply redirect_dir=on and
> > redirect_dir=off should imply metacopy=off.  And document this
> > dependency, of course.
>

My 'strict' patch did not try to deal with implicitly enabling redirect_dir
Vivek posted a different patch to deal with that.

> Something like this?  Untested, and incomplete:
>
>  - show options needs to kill the implied ones
>
>  - what's with "metacopy=on,redirect=follow"?
>
> Thanks,
> Miklos
>
> ---
>  fs/overlayfs/super.c |   13 ++++++++++++-
>  1 file changed, 12 insertions(+), 1 deletion(-)
>
> --- a/fs/overlayfs/super.c
> +++ b/fs/overlayfs/super.c
> @@ -312,7 +312,7 @@ static bool ovl_force_readonly(struct ov
>
>  static const char *ovl_redirect_mode_def(void)
>  {
> -       return ovl_redirect_dir_def ? "on" : "off";
> +       return ovl_redirect_dir_def || ovl_metacopy_def ? "on" : "off";
>  }
>
>  enum {
> @@ -516,6 +516,11 @@ static int ovl_parse_opt(char *opt, stru
>                         config->redirect_mode = match_strdup(&args[0]);
>                         if (!config->redirect_mode)
>                                 return -ENOMEM;
> +
> +                       /* "redirect_dir=off" implies "metacopy=off" */
> +                       if (strcmp(config->redirect_mode, "off") == 0 ||
> +                           strcmp(config->redirect_mode, "nofollow") == 0)
> +                               config->metacopy = false;

This look completely counter to the 'strict' behavior definition.
If user specified metacopy=on, we are not allowed to end up with metacopy=off.

>                         break;
>
>                 case OPT_INDEX_ON:
> @@ -548,6 +553,12 @@ static int ovl_parse_opt(char *opt, stru
>
>                 case OPT_METACOPY_ON:
>                         config->metacopy = true;
> +
> +                       /* "metacopy=on" implies "redirect_dir=on" */
> +                       kfree(config->redirect_mode);
> +                       config->redirect_mode = kstrdup("on", GFP_KERNEL);
> +                       if (!config->redirect_mode)
> +                               return -ENOMEM;
>                         break;
>

Helper please. from my "deprecated upper fs" v1 patch:

+static int ovl_set_redirect_mode(struct ovl_config *config, const char *mode)
+{
+       kfree(config->redirect_mode);
+       config->redirect_mode = kstrdup(mode, GFP_KERNEL);
+       if (!config->redirect_mode)
+               return -ENOMEM;
+
+       return ovl_parse_redirect_mode(config, mode);
+}
+

Thanks,
Amir.
