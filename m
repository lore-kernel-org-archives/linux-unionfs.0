Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
References: <20181031111038.20570-1-amir73il@gmail.com> <CAJfpegvfRu3qFCnjho0aDEL22Fs6dHAK7p9FU9n=puQ1FbGjTQ@mail.gmail.com>
 <CAOQ4uxi12LPAWdsc0zuDroRs2bx1WsRYsP3dMzv-5NOCcAYhoQ@mail.gmail.com>
 <20181031134723.GA20169@redhat.com> <CAOQ4uxgKDi7U1-z_KMB++WqagshEtcd0W-Q2kCAG3cXjsJNKzw@mail.gmail.com>
 <20181031141752.GB20169@redhat.com> <CAOQ4uxg9vFqM3G5aV456foRFSm9NpjkZoR6CddbTTdcWTN5Quw@mail.gmail.com>
 <20181031153944.GC20169@redhat.com>
In-Reply-To: <20181031153944.GC20169@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 31 Oct 2018 18:04:36 +0200
Message-ID: <CAOQ4uxjGWx02goXcBjqQAUv34N2QcnFLbDVaKykhYNhV71RNBQ@mail.gmail.com>
Subject: Re: [PATCH v2] ovl: return error on mount if metacopy cannot be enabled
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

> Ok. So basically strict and metacopy has no connection but we want to
> take this opportunity to enable more sane overlayfs behavior by default
> without breaking backward compatibility.
>
> And if a corner case user does not like implicit strict=on, they can
> specifically do "metacopy=on,strict=off".
>

Yes, but keep in mind that strict=off will NOT be applied to stable
v4.19.y *unless* a real user really reports a bug, a-priori, we assume
that implicit metacopy=on => redirect_dir=on,strict=on is sufficient
to solve the bug, so it is sufficient for stable.

> I am fine with this. Thanks.
>
> So every new mount option now will enable strict=on implicitly?
>

Correct. For example:


@@ -109,6 +109,7 @@ config OVERLAY_FS_METACOPY
        bool "Overlayfs: turn on metadata only copy up feature by default"
        depends on OVERLAY_FS
        select OVERLAY_FS_REDIRECT_DIR
+       select OVERLAY_FS_STRICT
        help
          If this config option is enabled then overlay filesystems will
          copy up only metadata where appropriate and data copy up will

...

@@ -560,6 +599,10 @@ static int ovl_parse_opt(char *opt, struct
ovl_config *config)
                }
        }

+       /* We must honor user explicit request to enable metacopy */
+       if (config->metacopy && !ovl_metacopy_def)
+               config->strict = true;
+
        /* Workdir is useless in non-upper mount */
        if (!config->upperdir && config->workdir) {

---

Thanks,
Amir.
