Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031111038.20570-1-amir73il@gmail.com> <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com>
 <20181031134723.GA20169@redhat.com> <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
 <20181031141752.GB20169@redhat.com> <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
 <20181031153944.GC20169@redhat.com> <CAOQ4uxjGWx02goXcBjqQAUv34N2QcnFLbDVaKykhYNhV71RNBQ@mail.gmail.com>
 <20181031163939.GD20169@redhat.com>
In-Reply-To: <20181031163939.GD20169@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 20:37:04 +0200
Message-ID: <CAOQ4uxgLWHHK3RLE_zKXkM_S5Lfc7Hn2rpKvOvJda5RtE97C3Q@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Oct 31, 2018 at 6:39 PM Vivek Goyal <vgoyal@redhat.com> wrote:
>
...
> >
> > Yes, but keep in mind that strict=off will NOT be applied to stable
> > v4.19.y *unless* a real user really reports a bug, a-priori, we assume
> > that implicit metacopy=on => redirect_dir=on,strict=on is sufficient
> > to solve the bug, so it is sufficient for stable.
>
> Did not understand this. So strict=on will be in stable or not? I mean,
> all the behavior strict=on enforces will be in 4.19 or not.
>
> If it is not, then it will become backward compatibility issue by the
> time 4.20 releases.
>
> If strict=on is not part of 4.19 stable, then you can't switch it
> on in 4.20.
>
> What am I missing.
>

I guess I haven't thought this through. Let's see:

1.a. In 4.19, specifying metacopy=on will result in metacopy=on
OR -EINVAL (a.k.a. "the bug fix") [*]

1.b. In 4.19, user will not be able to mount with metacopy=on with
an upper fs that does not support xattr/d_type/RENAME_WHITEOUT.

1.d. In 4.19, mount will fail if given mount option metacopy=on and
nfs_export is enabled (even if enabled by default) or if redirect_dir
is disabled (even if disabled by default).

1.d. In 4.19, mount will fail if given mount option metacopy=on,
index is enabled (even if enabled by default) and underlying fs does
not support file handles.

[*] I intentionally reduced the scope of the bug fix to not infer
     redirect_dir=on and the like, to keep the stable fix small and
     stay away from the discussion about conflicting explicit mount options.
     Kconfig already has the correct inter dependencies between
     metacopy, redirect_dir and nfs_export. mount options can implement
     those inter dependencies in 4.20 to reduce the cases of mount failure.

2.a. In 4.20, user will be able to configure strict=on by default
to always enforce xattr and RENAME_WHITEOUT support on upper fs

2.b. In 4.20, user will be able to use strict=off to mount metacopy=on
without RENAME_WHITEOUT/d_type requirements on upper fs

2.c. In 4.20, metacopy=on will set redirect_dir=on and nfs_export=off
unless otherwise specified explicitly by user, in which case mount will fail.

An alternative to 2.c. is what Miklos proposed - conflicting options are
allowed - last option among conflicting options is the effective one.

...
> >
> > +       /* We must honor user explicit request to enable metacopy */
> > +       if (config->metacopy && !ovl_metacopy_def)
> > +               config->strict = true;
> > +
>
> So if a user loads module with metacopy=on and also specifies metacopy=on
> mount option, then strict will not be enforced?
>

Mmm, right. I guess the previous version I posted was better:

@@ -548,6 +586,7 @@ static int ovl_parse_opt(char *opt, struct
ovl_config *config)

                case OPT_METACOPY_ON:
                        config->metacopy = true;
+                       config->strict = true;
                        break;

---

I was trying to avoid having to do:

@@@ -524,6 -519,6 +560,8 @@@ static int ovl_parse_opt(char *opt, str
                        continue;

                token = match_token(p, ovl_tokens, args);
+              if (token >= 0 && token < OPT_ERR)
+                      config->user_opts |= 1UL << token;
                switch (token) {
                case OPT_UPPERDIR:
---

At the moment, the only way I see to avoid it is by adopting Miklos'
concept of last option is effective one.

Seeing that it is getting late, I will try to post patch(es) for my 4.19
stable proposal and the 4.20 strict=on config patch.

I'll probably end up leaving the redirect_dir=on logic for you to
handle. It's up to you if you want to promote it as stable patch as
well - I don't see the point, because it is ok for something that didn't
work in 4.19 (redirect_dir_def=off,metacopy=on) to start working in 4.20.
and users of metacopy can always "work around" this behavior from
userspace by explicitly providing redirect_dir=on,metacopy=on.

Thanks,
Amir.
