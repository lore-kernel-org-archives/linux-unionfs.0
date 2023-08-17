Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1BD83C30638
	for <linux-unionfs@archiver.kernel.org>; Thu, 17 Aug 2023 15:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241187AbjHQPCY (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 17 Aug 2023 11:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352703AbjHQPCO (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 17 Aug 2023 11:02:14 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A10E52D74
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 08:01:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692284479;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=32EXi7UIQ4TjT++F9WYynuJZpA0ugj7RKs9QxXOl6vg=;
        b=IuVf7/wp3jzSnfLXr4KumWdLLV5XvnHHhDnyZtyVGnr6xN5RcZBfBtx3wHIg3JJrrnmr4z
        Dy7rQhyLGlbh/oFAbopWtmX1CtZj7Kut4HtsFK0agjb8YqnpMiXMweP/HRawKx1oqpfHCc
        ZddbqdYeXd+dhFCkjEYQu4cKJDOisPA=
Received: from mail-io1-f71.google.com (mail-io1-f71.google.com
 [209.85.166.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-201-mH907jPbP7G6TOG40uRiOw-1; Thu, 17 Aug 2023 11:01:12 -0400
X-MC-Unique: mH907jPbP7G6TOG40uRiOw-1
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-791432e4245so796163739f.0
        for <linux-unionfs@vger.kernel.org>; Thu, 17 Aug 2023 08:01:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692284470; x=1692889270;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=32EXi7UIQ4TjT++F9WYynuJZpA0ugj7RKs9QxXOl6vg=;
        b=Cb6hmsWN0JmLeGnINh4LD2Jr4TjZlcRcDlyFVUMn6KX32WPMHzETEcxSkyp/jE4zni
         SYE7pVE1CnL6KjHfwocB6wp1xinTJA3NSlZZZ7zMVZLjcnrTy+ZtJyCvwBNkIBqcr6yv
         oIZV2iaarbk6/sRuWuqWrYFxHTGwS4D9FlhxDNARuMUilR7Q2Pq2G4Ary1q49jtlqAFo
         Gt6A9M8l1Cmtf6nMaqnhFoa4KH4g2KrnpV+FLrbxmhjZPNOe56p2O6APbquA3YAzVACh
         0DRzBr09OSwl7u0JC6KwGerNqsRyzelmMulA/l6qPnLTmMaAQBL2KmvPgibPmfUg/1kb
         dsLA==
X-Gm-Message-State: AOJu0YwQ5SylwfP3PC1uEZyZW9lLiO78zArHdeLA+ZnrT/ae7Fz0fFVJ
        DfvCLDObYlrC0jiowGk3cXBnlJ+QsW4VyiQ0GjWZlm+6udORBon7Rh4G7gEauz4CEIjpLIPuxm8
        WS6TXokbhQPaZWFAqkPQFG5soT7ZT5l2yecfpVGXSTPCWVNELyY5P
X-Received: by 2002:a05:6e02:ec5:b0:34a:bc00:e40f with SMTP id i5-20020a056e020ec500b0034abc00e40fmr5784196ilk.5.1692284470633;
        Thu, 17 Aug 2023 08:01:10 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEJAG7vzBwOpknhCj/HEBqbTyVssEgHc3U8tmkSv5kYr2tUp3EKVmPaQ8IT3MbAUsFfiLkfe5uN1HGk0K4BsRg=
X-Received: by 2002:a05:6e02:ec5:b0:34a:bc00:e40f with SMTP id
 i5-20020a056e020ec500b0034abc00e40fmr5784174ilk.5.1692284470310; Thu, 17 Aug
 2023 08:01:10 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1692270188.git.alexl@redhat.com> <c303fe8cdcafade9583b390d13b2a5d56e122d58.1692270188.git.alexl@redhat.com>
 <CAOQ4uxij9_F7MwK6d76mnNNZ-NqoQQ1T-DzDHjbHYpw6TYhULw@mail.gmail.com>
In-Reply-To: <CAOQ4uxij9_F7MwK6d76mnNNZ-NqoQQ1T-DzDHjbHYpw6TYhULw@mail.gmail.com>
From:   Alexander Larsson <alexl@redhat.com>
Date:   Thu, 17 Aug 2023 17:00:59 +0200
Message-ID: <CAL7ro1FT5X9jJt+zic6xZhkTqQufvN3AeL8DMKNxGf8TzgKaMA@mail.gmail.com>
Subject: Re: [PATCH v2 3/5] ovl: Support escaped overlay.* xattrs
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 17, 2023 at 4:32=E2=80=AFPM Amir Goldstein <amir73il@gmail.com>=
 wrote:
>
> On Thu, Aug 17, 2023 at 2:05=E2=80=AFPM Alexander Larsson <alexl@redhat.c=
om> wrote:
> >
> > There are cases where you want to use an overlayfs mount as a lowerdir
> > for another overlayfs mount. For example, if the system rootfs is on
> > overlayfs due to composefs, or to make it volatile (via tmps), then
> > you cannot currently store a lowerdir on the rootfs. This means you
> > can't e.g. store on the rootfs a prepared container image for use
> > using overlayfs.
> >
> > To work around this, we introduce an escapment mechanism for overlayfs
> > xattrs. Whenever the lower/upper dir has a xattr named
> > `overlay.overlay.XYZ`, we list it as overlay.XYZ in listxattrs, and
> > when the user calls getxattr or setxattr on `overlay.XYZ`, we apply to
> > `overlay.overlay.XYZ` in the backing directories.
> >
> > This allows storing any kind of overlay xattrs in a overlayfs mount
> > that can be used as a lowerdir in another mount. It is possible to
> > stack this mechanism multiple times, such that
> > overlay.overlay.overlay.XYZ will survive two levels of overlay mounts,
> > however this is not all that useful in practice because of stack depth
> > limitations of overlayfs mounts.
> >
>
> Please elaborate what happens when lower overlayfs is trusted.overlay
> and nested overlayfs is user.overlay or the other way around.
> Is it true that this patch would not be needed at all if this was the cas=
e?

For the xattrs it isn't really needed. For example, if the first
overlayfs mount is uses trusted.overlay mount and it has a directory
with a file that has a user.overlay xattr, then this file will be
correctly exposed in the first mount, and it will be usable by a
nested userxattr mount.

However, suppose the 2nd mount (the userxattr one) needs a whiteout
between its layers. It this is a plain whiteout file it will be
consumed by the first mount. For that to work you need the
trusted.overlay.nowhiteout xattr on the file. Same for the other way
around.

> In any case, I think that this case would not be uncommon, so it is worth
> adding it in the tests.

Yeah. Will look at adding this.

> Thanks,
> Amir.
>
> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
> > ---
> >  fs/overlayfs/overlayfs.h |  7 ++++
> >  fs/overlayfs/xattrs.c    | 78 +++++++++++++++++++++++++++++++++++++---
> >  2 files changed, 81 insertions(+), 4 deletions(-)
> >
> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
> > index ef993a543b2a..311e1f37ce84 100644
> > --- a/fs/overlayfs/overlayfs.h
> > +++ b/fs/overlayfs/overlayfs.h
> > @@ -32,6 +32,13 @@ enum ovl_path_type {
> >  #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
> >  #define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
> >
> > +#define OVL_XATTR_ESCAPE_PREFIX OVL_XATTR_NAMESPACE
> > +#define OVL_XATTR_ESCAPE_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_PREFIX) -=
 1)
> > +#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX OVL_XATTR_TRUSTED_PREFIX OVL_X=
ATTR_ESCAPE_PREFIX
> > +#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_T=
RUSTED_PREFIX) - 1)
> > +#define OVL_XATTR_ESCAPE_USER_PREFIX OVL_XATTR_USER_PREFIX OVL_XATTR_E=
SCAPE_PREFIX
> > +#define OVL_XATTR_ESCAPE_USER_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_USER=
_PREFIX) - 1)
> > +
> >  enum ovl_xattr {
> >         OVL_XATTR_OPAQUE,
> >         OVL_XATTR_REDIRECT,
> > diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
> > index b8ea96606ea8..27b31f812eb1 100644
> > --- a/fs/overlayfs/xattrs.c
> > +++ b/fs/overlayfs/xattrs.c
> > @@ -4,6 +4,18 @@
> >  #include <linux/xattr.h>
> >  #include "overlayfs.h"
> >
> > +bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
> > +{
> > +       struct ovl_fs *ofs =3D sb->s_fs_info;
> > +
> > +       if (ofs->config.userxattr)
> > +               return strncmp(name, OVL_XATTR_ESCAPE_USER_PREFIX,
> > +                              OVL_XATTR_ESCAPE_USER_PREFIX_LEN) =3D=3D=
 0;
> > +       else
> > +               return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
> > +                              OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1)=
 =3D=3D 0;
> > +}
> > +
> >  bool ovl_is_private_xattr(struct super_block *sb, const char *name)
> >  {
> >         struct ovl_fs *ofs =3D OVL_FS(sb);
> > @@ -82,8 +94,8 @@ static int ovl_xattr_get(struct dentry *dentry, struc=
t inode *inode, const char
> >
> >  static bool ovl_can_list(struct super_block *sb, const char *s)
> >  {
> > -       /* Never list private (.overlay) */
> > -       if (ovl_is_private_xattr(sb, s))
> > +       /* Never list non-escaped private (.overlay) */
> > +       if (ovl_is_private_xattr(sb, s) && !ovl_is_escaped_xattr(sb, s)=
)
> >                 return false;
> >
> >         /* List all non-trusted xattrs */
> > @@ -97,10 +109,12 @@ static bool ovl_can_list(struct super_block *sb, c=
onst char *s)
> >  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
> >  {
> >         struct dentry *realdentry =3D ovl_dentry_real(dentry);
> > +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
> >         ssize_t res;
> >         size_t len;
> >         char *s;
> >         const struct cred *old_cred;
> > +       size_t prefix_len;
> >
> >         old_cred =3D ovl_override_creds(dentry->d_sb);
> >         res =3D vfs_listxattr(realdentry, list, size);
> > @@ -108,6 +122,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char *=
list, size_t size)
> >         if (res <=3D 0 || size =3D=3D 0)
> >                 return res;
> >
> > +       prefix_len =3D ofs->config.userxattr ?
> > +               OVL_XATTR_USER_PREFIX_LEN : OVL_XATTR_TRUSTED_PREFIX_LE=
N;
> > +
> >         /* filter out private xattrs */
> >         for (s =3D list, len =3D res; len;) {
> >                 size_t slen =3D strnlen(s, len) + 1;
> > @@ -120,6 +137,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char =
*list, size_t size)
> >                 if (!ovl_can_list(dentry->d_sb, s)) {
> >                         res -=3D slen;
> >                         memmove(s, s + slen, len);
> > +               } else if (ovl_is_escaped_xattr(dentry->d_sb, s)) {
> > +                       memmove(s + prefix_len,
> > +                               s + prefix_len + OVL_XATTR_ESCAPE_PREFI=
X_LEN,
> > +                               slen - (prefix_len + OVL_XATTR_ESCAPE_P=
REFIX_LEN) + len);
> > +                       res -=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
> > +                       s +=3D slen - OVL_XATTR_ESCAPE_PREFIX_LEN;
> >                 } else {
> >                         s +=3D slen;
> >                 }
> > @@ -128,11 +151,47 @@ ssize_t ovl_listxattr(struct dentry *dentry, char=
 *list, size_t size)
> >         return res;
> >  }
> >
> > +static char *ovl_xattr_escape_name(const char *prefix, const char *nam=
e)
> > +{
> > +       size_t prefix_len =3D strlen(prefix);
> > +       size_t name_len =3D strlen(name);
> > +       size_t escaped_len;
> > +       char *escaped, *s;
> > +
> > +       escaped_len =3D prefix_len + OVL_XATTR_ESCAPE_PREFIX_LEN + name=
_len;
> > +       if (escaped_len > XATTR_NAME_MAX)
> > +               return ERR_PTR(-EOPNOTSUPP);
> > +
> > +       escaped =3D kmalloc(escaped_len + 1, GFP_KERNEL);
> > +       if (escaped =3D=3D NULL)
> > +               return ERR_PTR(-ENOMEM);
> > +
> > +       s =3D escaped;
> > +       memcpy(s, prefix, prefix_len);
> > +       s +=3D prefix_len;
> > +       memcpy(s, OVL_XATTR_ESCAPE_PREFIX, OVL_XATTR_ESCAPE_PREFIX_LEN)=
;
> > +       s +=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
> > +       memcpy(s, name, name_len + 1);
> > +
> > +       return escaped;
> > +}
> > +
> >  static int ovl_own_xattr_get(const struct xattr_handler *handler,
> >                              struct dentry *dentry, struct inode *inode=
,
> >                              const char *name, void *buffer, size_t siz=
e)
> >  {
> > -       return -EOPNOTSUPP;
> > +       char *escaped;
> > +       int r;
> > +
> > +       escaped =3D ovl_xattr_escape_name(handler->prefix, name);
> > +       if (IS_ERR(escaped))
> > +               return PTR_ERR(escaped);
> > +
> > +       r =3D ovl_xattr_get(dentry, inode, escaped, buffer, size);
> > +
> > +       kfree(escaped);
> > +
> > +       return r;
> >  }
> >
> >  static int ovl_own_xattr_set(const struct xattr_handler *handler,
> > @@ -141,7 +200,18 @@ static int ovl_own_xattr_set(const struct xattr_ha=
ndler *handler,
> >                              const char *name, const void *value,
> >                              size_t size, int flags)
> >  {
> > -       return -EOPNOTSUPP;
> > +       char *escaped;
> > +       int r;
> > +
> > +       escaped =3D ovl_xattr_escape_name(handler->prefix, name);
> > +       if (IS_ERR(escaped))
> > +               return PTR_ERR(escaped);
> > +
> > +       r =3D ovl_xattr_set(dentry, inode, escaped, value, size, flags)=
;
> > +
> > +       kfree(escaped);
> > +
> > +       return r;
> >  }
> >
> >  static int ovl_other_xattr_get(const struct xattr_handler *handler,
> > --
> > 2.41.0
> >
>


--=20
=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D=
-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D-=3D
 Alexander Larsson                                Red Hat, Inc
       alexl@redhat.com         alexander.larsson@gmail.com

