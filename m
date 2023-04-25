Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FD6AC77B61
	for <linux-unionfs@archiver.kernel.org>; Tue, 25 Apr 2023 13:34:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234042AbjDYNeq (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Tue, 25 Apr 2023 09:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233539AbjDYNeo (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 25 Apr 2023 09:34:44 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F36349E2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Apr 2023 06:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1682429614;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=z7Dj3S8NvBEE90qucZ3YW+6jOQBh0fqkqFzsKLIOh3k=;
        b=Gmw8S7O8JKuhRIbEGWHiczjozLBBZKkmuxbYmyXZJYaHmnlvrmvUFc7BzCden5fOOMYotq
        e39uOq1oTEifYvRuBZWF5J1kHxud6eymHMnFL4zpA2z/h+8lZgK8jS/yuCnnyFy7fKN40B
        QzLj1TeE2JpwRtIBu3RQ57duyZKRDpw=
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com
 [209.85.166.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-81-S_mn-jjzP0KTGH47oxN9qw-1; Tue, 25 Apr 2023 09:33:30 -0400
X-MC-Unique: S_mn-jjzP0KTGH47oxN9qw-1
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-32ad2e6cf31so92930815ab.2
        for <linux-unionfs@vger.kernel.org>; Tue, 25 Apr 2023 06:33:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682429609; x=1685021609;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z7Dj3S8NvBEE90qucZ3YW+6jOQBh0fqkqFzsKLIOh3k=;
        b=YZNKqASFbLVzH+Ntu5k13EirCMbkPc93xj398vtvqU2MCQxRVzInmH8KkJcb/D+Okw
         mATyu0GT85jQB7HHSR0GWD3QXMlmxbRopGGp8Bolb50lYVDYjSIhZM0841QSdZy65srA
         RklzJnMAtl70ul4gxYgAp4RdJnYI+8jyAS+nMXsH1ErVBzxjUwwHR2yLLkKjcf3YaVEb
         bbuVcPs5MgGPWuXpU5jLrdA5Qj6wTxusaq3u35otBBBMsPZqqZN75SMakTcj/Q2D874W
         2ukv2/wOX4MtT7NPL+mGTBaURGUQwGOnfxJyKrEyF1bK4/XMHV/ygej15qVBPs2Joryv
         pviQ==
X-Gm-Message-State: AAQBX9ev6yw2RORv52DtWLiks67jSo5K/PtC5zi2jIIUJ7JSrsITbDZJ
        kwQXPv6PBUqUFWVsw41y6FpsB3szL9ag9HO9VgwKUG/F7JRTv9SoEd+vKmb+jAqxP+xCjKJVCNG
        /dXH+o/nh9Pqh/QvcOdjSGJSXjJtaMv6rQ1XrHBBJErqtY78ZYQ==
X-Received: by 2002:a92:cc4d:0:b0:328:7960:dac0 with SMTP id t13-20020a92cc4d000000b003287960dac0mr8412548ilq.0.1682429609052;
        Tue, 25 Apr 2023 06:33:29 -0700 (PDT)
X-Google-Smtp-Source: AKy350bsHe12ld20R6hs9nANf+XWnR8lqQT4R1DqYE3HxD10EStGdbtXeG3PVsyyePAenNhHJr5uDuS1a7Vp19ZZIDI=
X-Received: by 2002:a92:cc4d:0:b0:328:7960:dac0 with SMTP id
 t13-20020a92cc4d000000b003287960dac0mr8412534ilq.0.1682429608724; Tue, 25 Apr
 2023 06:33:28 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1681917551.git.alexl@redhat.com> <2b2c5ecaf80f810f46791a94d8638ec4027a3a0e.1681917551.git.alexl@redhat.com>
 <CAJfpegt_=nNne51Au0AvhVwBgHBesCQ9YCC6WMGVyN6nUA_B2A@mail.gmail.com>
In-Reply-To: <CAJfpegt_=nNne51Au0AvhVwBgHBesCQ9YCC6WMGVyN6nUA_B2A@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Tue, 25 Apr 2023 15:33:17 +0200
Message-ID: <CAL7ro1ErBN_VmTpe8EmDTVHBsQnZaMEhHKcbEtGy-ynkhzKcVA@mail.gmail.com>
Subject: Re: [PATCH 4/6] ovl: Add framework for verity support
To:     Miklos Szeredi <miklos@szeredi.hu>
Cc:     linux-unionfs@vger.kernel.org, amir73il@gmail.com,
        ebiggers@kernel.org, tytso@mit.edu, fsverity@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Tue, Apr 25, 2023 at 1:19=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu> =
wrote:
>
> On Thu, 20 Apr 2023 at 09:44, Alexander Larsson <alexl@redhat.com> wrote:
> >
> > This adds the scaffolding (docs, config, mount options) for supporting
> > for a new overlay xattr "overlay.verity", which contains a fs-verity
> > digest. This is used for metacopy files, and the actual fs-verity
> > digest of the lowerdata file needs to match it. The mount option
> > "verity" specifies how this xattrs is handled.
> >
> > Unless you explicitly disable it ("verity=3Doff") all existing xattrs
> > are validated before use. This is all that happens by default
> > ("verity=3Dvalidate"), but, if you turn on verity ("verity=3Don") then
> > during metacopy we generate verity xattr in the upper metacopy file if
> > the source file has verity enabled. This means later accesses can
> > guarantee that the correct data is used.
> >
> > Additionally you can use "verity=3Drequire". In this mode all metacopy
> > files must have a valid verity xattr. For this to work metadata
> > copy-up must be able to create a verity xattr (so that later accesses
> > are validated). Therefore, in this mode, if the lower data file
> > doesn't have fs-verity enabled we fall back to a full copy rather than
> > a metacopy.
>
> Maybe we can reduce the number of modes.  Which mode does your use case n=
eed?

For composefs I typically always create images with full verity info
so they *can* be used with verity, but I want to allow using these
even on systems that don't support verity. So, at the very minimum
composefs needs "verity=3Doff" (don't even try to verify anything) and
"verity=3Drequire" (ensure all redirects have a verity xattr and it is
valid).

These are kind of extremes though, and I think it makes sense to have
something in between where not everything has to be verified.
Currently we have both "validate" and "on". But maybe those could be
consolidated.

> >
> > Actual implementation follows in a separate commit.
> >
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > ---
> >  Documentation/filesystems/overlayfs.rst | 33 +++++++++++++++++
> >  fs/overlayfs/Kconfig                    | 14 +++++++
> >  fs/overlayfs/ovl_entry.h                |  4 ++
> >  fs/overlayfs/super.c                    | 49 +++++++++++++++++++++++++
> >  4 files changed, 100 insertions(+)
> >
> > diff --git a/Documentation/filesystems/overlayfs.rst b/Documentation/fi=
lesystems/overlayfs.rst
> > index c8e04a4f0e21..66895bf71cd1 100644
> > --- a/Documentation/filesystems/overlayfs.rst
> > +++ b/Documentation/filesystems/overlayfs.rst
> > @@ -403,6 +403,39 @@ when a "metacopy" file in one of the lower layers =
above it, has a "redirect"
> >  to the absolute path of the "lower data" file in the "data-only" lower=
 layer.
> >
> >
> > +fs-verity support
> > +----------------------
> > +
> > +When metadata copy up is used for a file, then the xattr
> > +"trusted.overlay.verity" may be set on the metacopy file. This
> > +specifies the expected fs-verity digest of the lowerdata file. This
> > +may then be used to verify the content of the source file at the time
> > +the file is opened. If enabled, overlayfs can also set this xattr
> > +during metadata copy up.
> > +
> > +This is controlled by the "verity" mount option, which supports
> > +these values:
> > +
> > +- "off":
> > +    The verity xattr is never used.
> > +- "validate":
> > +    Whenever a metacopy files specifies an expected digest, the
> > +    corresponding data file must match the specified digest.
> > +- "on":
> > +    Same as validate, but additionally, when generating a metacopy
> > +    file the verity xattr will be set from the source file fs-verity
> > +    digest (if it has one).
> > +- "require":
> > +    Same as "on", but additionally all metacopy files must specify a
> > +    verity xattr. Additionally metadata copy up will only be used if
> > +    the data file has fs-verity enabled, otherwise a full copy-up is
> > +    used.
> > +
> > +There are two ways to tune the default behaviour. The kernel config
> > +option OVERLAY_FS_VERITY, or the module option "verity=3DBOOL". If
> > +either of these are enabled, then verity mode is "on" by default,
> > +otherwise it is "validate".
>
> I'm not sure that enabling verity by default is safe.  E.g. a script
> mounts overalyfs but doesn't set the verity mount, since it's on by
> default.  Then the script is moved to a different system where the
> default is off, which will result in verity not being enabled, even
> though that was not intended.  Is there an advantage to allowing to
> change the default?  I know it's done for most of the overlayfs
> options, but I think this is different.

I sort of agree, in particular because many filesystems still don't
support verity, or need it to be specifically enabled.
So, what about dropping "validate" and go with modes: "off, on,
require", where "off" is the default?

> > +
> >  Sharing and copying layers
> >  --------------------------
> >
> > diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> > index 6708e54b0e30..98d6b1a7baf5 100644
> > --- a/fs/overlayfs/Kconfig
> > +++ b/fs/overlayfs/Kconfig
> > @@ -124,3 +124,17 @@ config OVERLAY_FS_METACOPY
> >           that doesn't support this feature will have unexpected result=
s.
> >
> >           If unsure, say N.
> > +
> > +config OVERLAY_FS_VERITY
> > +       bool "Overlayfs: turn on verity feature by default"
> > +       depends on OVERLAY_FS
> > +       depends on OVERLAY_FS_METACOPY
> > +       help
> > +         If this config option is enabled then overlay filesystems wil=
l
> > +         try to copy fs-verity digests from the lower file into the
> > +         metacopy file at metadata copy-up time. It is still possible
> > +         to turn off this feature globally with the "verity=3Doff"
> > +         module option or on a filesystem instance basis with the
> > +         "verity=3Doff" or "verity=3Dvalidate" mount option.
> > +
> > +         If unsure, say N.
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index a7b1006c5321..f759e476dfc7 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -13,6 +13,10 @@ struct ovl_config {
> >         bool redirect_dir;
> >         bool redirect_follow;
> >         const char *redirect_mode;
> > +       bool verity_validate;
> > +       bool verity_generate;
> > +       bool verity_require;
> > +       const char *verity_mode;
> >         bool index;
> >         bool uuid;
> >         bool nfs_export;
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index ef78abc21998..953d76f6a1e3 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -59,6 +59,11 @@ module_param_named(metacopy, ovl_metacopy_def, bool,=
 0644);
> >  MODULE_PARM_DESC(metacopy,
> >                  "Default to on or off for the metadata only copy up fe=
ature");
> >
> > +static bool ovl_verity_def =3D IS_ENABLED(CONFIG_OVERLAY_FS_VERITY);
> > +module_param_named(verity, ovl_verity_def, bool, 0644);
> > +MODULE_PARM_DESC(verity,
> > +                "Default to on or validate for the metadata only copy =
up feature");
> > +
> >  static struct dentry *ovl_d_real(struct dentry *dentry,
> >                                  const struct inode *inode)
> >  {
> > @@ -235,6 +240,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
> >         kfree(ofs->config.upperdir);
> >         kfree(ofs->config.workdir);
> >         kfree(ofs->config.redirect_mode);
> > +       kfree(ofs->config.verity_mode);
> >         if (ofs->creator_cred)
> >                 put_cred(ofs->creator_cred);
> >         kfree(ofs);
> > @@ -325,6 +331,11 @@ static const char *ovl_redirect_mode_def(void)
> >         return ovl_redirect_dir_def ? "on" : "off";
> >  }
> >
> > +static const char *ovl_verity_mode_def(void)
> > +{
> > +       return ovl_verity_def ? "on" : "validate";
> > +}
> > +
> >  static const char * const ovl_xino_str[] =3D {
> >         "off",
> >         "auto",
> > @@ -374,6 +385,8 @@ static int ovl_show_options(struct seq_file *m, str=
uct dentry *dentry)
> >                 seq_puts(m, ",volatile");
> >         if (ofs->config.userxattr)
> >                 seq_puts(m, ",userxattr");
> > +       if (strcmp(ofs->config.verity_mode, ovl_verity_mode_def()) !=3D=
 0)
> > +               seq_printf(m, ",verity=3D%s", ofs->config.verity_mode);
> >         return 0;
> >  }
> >
> > @@ -429,6 +442,7 @@ enum {
> >         OPT_METACOPY_ON,
> >         OPT_METACOPY_OFF,
> >         OPT_VOLATILE,
> > +       OPT_VERITY,
> >         OPT_ERR,
> >  };
> >
> > @@ -451,6 +465,7 @@ static const match_table_t ovl_tokens =3D {
> >         {OPT_METACOPY_ON,               "metacopy=3Don"},
> >         {OPT_METACOPY_OFF,              "metacopy=3Doff"},
> >         {OPT_VOLATILE,                  "volatile"},
> > +       {OPT_VERITY,                    "verity=3D%s"},
> >         {OPT_ERR,                       NULL}
> >  };
> >
> > @@ -500,6 +515,25 @@ static int ovl_parse_redirect_mode(struct ovl_conf=
ig *config, const char *mode)
> >         return 0;
> >  }
> >
> > +static int ovl_parse_verity_mode(struct ovl_config *config, const char=
 *mode)
> > +{
> > +       if (strcmp(mode, "validate") =3D=3D 0) {
> > +               config->verity_validate =3D true;
> > +       } else if (strcmp(mode, "on") =3D=3D 0) {
> > +               config->verity_validate =3D true;
> > +               config->verity_generate =3D true;
> > +       } else if (strcmp(mode, "require") =3D=3D 0) {
> > +               config->verity_validate =3D true;
> > +               config->verity_generate =3D true;
> > +               config->verity_require =3D true;
> > +       } else if (strcmp(mode, "off") !=3D 0) {
> > +               pr_err("bad mount option \"verity=3D%s\"\n", mode);
> > +               return -EINVAL;
> > +       }
> > +
> > +       return 0;
> > +}
> > +
> >  static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >  {
> >         char *p;
> > @@ -511,6 +545,10 @@ static int ovl_parse_opt(char *opt, struct ovl_con=
fig *config)
> >         if (!config->redirect_mode)
> >                 return -ENOMEM;
> >
> > +       config->verity_mode =3D kstrdup(ovl_verity_mode_def(), GFP_KERN=
EL);
> > +       if (!config->verity_mode)
> > +               return -ENOMEM;
> > +
> >         while ((p =3D ovl_next_opt(&opt)) !=3D NULL) {
> >                 int token;
> >                 substring_t args[MAX_OPT_ARGS];
> > @@ -611,6 +649,13 @@ static int ovl_parse_opt(char *opt, struct ovl_con=
fig *config)
> >                         config->userxattr =3D true;
> >                         break;
> >
> > +               case OPT_VERITY:
> > +                       kfree(config->verity_mode);
> > +                       config->verity_mode =3D match_strdup(&args[0]);
> > +                       if (!config->verity_mode)
> > +                               return -ENOMEM;
> > +                       break;
> > +
> >                 default:
> >                         pr_err("unrecognized mount option \"%s\" or mis=
sing value\n",
> >                                         p);
> > @@ -642,6 +687,10 @@ static int ovl_parse_opt(char *opt, struct ovl_con=
fig *config)
> >         if (err)
> >                 return err;
> >
> > +       err =3D ovl_parse_verity_mode(config, config->verity_mode);
> > +       if (err)
> > +               return err;
> > +
> >         /*
> >          * This is to make the logic below simpler.  It doesn't make an=
y other
> >          * difference, since config->redirect_dir is only used for uppe=
r.
> > --
> > 2.39.2
> >
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

