Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A12EE57E0
	for <linux-unionfs@archiver.kernel.org>; Fri,  8 Sep 2023 07:52:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231163AbjIHHwa (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 8 Sep 2023 03:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjIHHw3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 8 Sep 2023 03:52:29 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC5A51997
        for <linux-unionfs@vger.kernel.org>; Fri,  8 Sep 2023 00:52:23 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a1e0cc1a2514c-79414715edeso593443241.0
        for <linux-unionfs@vger.kernel.org>; Fri, 08 Sep 2023 00:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694159543; x=1694764343; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=W5ZGn1/0c3hoUg8h29QBlP96ZwfOaCixJfSQ3LhbSNk=;
        b=FKNGkxUezDAoGsI23wVJZ6xgrFqIVSa2ILNxA5Fh0TghxJqWF+vseGWVR5NZUZG57K
         v/uPqew05NR6oHCCgEadm7/Ex+sFSqrX4HjFRtcXUveXUALpGQPLIj8QJUPf2UFq0ONz
         jBK1hCo5tKotFAR3qN9Ab8MsPjG+DL52k9qL4sPBjZ/21F+VIOwutAgzccext4DEebmC
         s2Xj/xXnptcKUTYBCD21IUGUHEbwCVCFFzp5S9TyNp1rRPZViPjJjmO4YvIxVofMw9C/
         OejoBQfB/h7Jv3Gq5plvrxQ1O8VUHWJcr2NPvcZ2rGvWOPqBnWQ3L+vPBGxb4AugZnIT
         UWOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694159543; x=1694764343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=W5ZGn1/0c3hoUg8h29QBlP96ZwfOaCixJfSQ3LhbSNk=;
        b=wUKET3T/fQFzdNTXe5G6lrJcKdWGpqeijqBIg5YfWN8zlexpyMlH+IZpb+HFFaSw1q
         ewcYymcZ5tJhSBrjXvBoO6bIAOONood5BEl+qRDvtmpgWN9/1RFejpyPue3tH8kepLZj
         2l0WQYCglt5PQpWBLgO8AGdq0vCCabWSsK+Z+UkXph7LxlaBsM9/QPoi0hn/8ABHXvCI
         d6BGNAx4a1/BYu66ImORVFUE+vG8HYoFw9Mc5E0tnfkNbeiG+FhVtwE+bNrvienCEq/6
         QXJnMuaxMAV4iogpoOM9GxTZW7AIh4QEJImDi9ugSRYbo8f/r9FnID0Hh4TzItVygIWA
         RLyA==
X-Gm-Message-State: AOJu0YyeTVy+f3g2z0SQMWlvye/jPfO8jOmtqfeINt2pfzo6BsB6ofsB
        etPphKwXmWx+dffkGRUb+lLVMRtd19u1wVvmCjXbNTXc
X-Google-Smtp-Source: AGHT+IHphr7+/qpfF1l49t9JGyHhfkAMViWsp+7boQY1jFK54QplHfQXYARPF8qewmwj12vdgdvn5I+E2V/LM02ETGM=
X-Received: by 2002:a67:f810:0:b0:44e:b11a:8b16 with SMTP id
 l16-20020a67f810000000b0044eb11a8b16mr1779989vso.13.1694159542813; Fri, 08
 Sep 2023 00:52:22 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1694075674.git.alexl@redhat.com> <5c18d058e189f488ff87b7fdba231cf356e91789.1694075674.git.alexl@redhat.com>
 <CAOQ4uxgujnxEugNqbd-BwH1GuH+HeiNf5ZUsTSnPqy163MaQsg@mail.gmail.com> <CAL7ro1FMVdFPu5WqxHCoGTcpt8P532z02sx1Ngtf6BW61WPDGg@mail.gmail.com>
In-Reply-To: <CAL7ro1FMVdFPu5WqxHCoGTcpt8P532z02sx1Ngtf6BW61WPDGg@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Fri, 8 Sep 2023 10:52:11 +0300
Message-ID: <CAOQ4uxjJfOwdoo6ZzBXNQBWYKVm5o8foRkzMcwq4FttB_NMrJg@mail.gmail.com>
Subject: Re: [PATCH v3 3/6] ovl: Support escaped overlay.* xattrs
To:     Alexander Larsson <alexl@redhat.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Fri, Sep 8, 2023 at 10:43=E2=80=AFAM Alexander Larsson <alexl@redhat.com=
> wrote:
>
>
>
> On Thu, Sep 7, 2023 at 1:25=E2=80=AFPM Amir Goldstein <amir73il@gmail.com=
> wrote:
>>
>> On Thu, Sep 7, 2023 at 11:44=E2=80=AFAM Alexander Larsson <alexl@redhat.=
com> wrote:
>> >
>> > There are cases where you want to use an overlayfs mount as a lowerdir
>> > for another overlayfs mount. For example, if the system rootfs is on
>> > overlayfs due to composefs, or to make it volatile (via tmps), then
>> > you cannot currently store a lowerdir on the rootfs. This means you
>> > can't e.g. store on the rootfs a prepared container image for use
>> > using overlayfs.
>> >
>> > To work around this, we introduce an escapment mechanism for overlayfs
>> > xattrs. Whenever the lower/upper dir has a xattr named
>> > `overlay.overlay.XYZ`, we list it as overlay.XYZ in listxattrs, and
>> > when the user calls getxattr or setxattr on `overlay.XYZ`, we apply to
>> > `overlay.overlay.XYZ` in the backing directories.
>>
>> Please use ""
>
>
> I like backquotes, because the github/gitlab UIs show commit messages as =
markdown, and
> there it renders the quoted part monospace, whereas " is just a regular c=
haracter with no special rendering.
> But I changed it.
>

Well. It's not critical to me. just thought it would be more consistent wit=
h
comment and doc style.

>>
>> >
>> > This allows storing any kind of overlay xattrs in a overlayfs mount
>> > that can be used as a lowerdir in another mount. It is possible to
>> > stack this mechanism multiple times, such that
>> > overlay.overlay.overlay.XYZ will survive two levels of overlay mounts,
>> > however this is not all that useful in practice because of stack depth
>> > limitations of overlayfs mounts.
>> >
>> > Signed-off-by: Alexander Larsson <alexl@redhat.com>
>>
>> With comment in ovl_listxattr() below fixed you may add:
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>>
>> > ---
>> >  fs/overlayfs/overlayfs.h |  7 ++++
>> >  fs/overlayfs/xattrs.c    | 78 +++++++++++++++++++++++++++++++++++++--=
-
>> >  2 files changed, 81 insertions(+), 4 deletions(-)
>> >
>> > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
>> > index dff7232b7bf5..736d7f952a8e 100644
>> > --- a/fs/overlayfs/overlayfs.h
>> > +++ b/fs/overlayfs/overlayfs.h
>> > @@ -32,6 +32,13 @@ enum ovl_path_type {
>> >  #define OVL_XATTR_USER_PREFIX XATTR_USER_PREFIX OVL_XATTR_NAMESPACE
>> >  #define OVL_XATTR_USER_PREFIX_LEN (sizeof(OVL_XATTR_USER_PREFIX) - 1)
>> >
>> > +#define OVL_XATTR_ESCAPE_PREFIX OVL_XATTR_NAMESPACE
>> > +#define OVL_XATTR_ESCAPE_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_PREFIX) =
- 1)
>> > +#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX OVL_XATTR_TRUSTED_PREFIX OVL_=
XATTR_ESCAPE_PREFIX
>> > +#define OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_=
TRUSTED_PREFIX) - 1)
>> > +#define OVL_XATTR_ESCAPE_USER_PREFIX OVL_XATTR_USER_PREFIX OVL_XATTR_=
ESCAPE_PREFIX
>> > +#define OVL_XATTR_ESCAPE_USER_PREFIX_LEN (sizeof(OVL_XATTR_ESCAPE_USE=
R_PREFIX) - 1)
>> > +
>> >  enum ovl_xattr {
>> >         OVL_XATTR_OPAQUE,
>> >         OVL_XATTR_REDIRECT,
>> > diff --git a/fs/overlayfs/xattrs.c b/fs/overlayfs/xattrs.c
>> > index b8ea96606ea8..27b31f812eb1 100644
>> > --- a/fs/overlayfs/xattrs.c
>> > +++ b/fs/overlayfs/xattrs.c
>> > @@ -4,6 +4,18 @@
>> >  #include <linux/xattr.h>
>> >  #include "overlayfs.h"
>> >
>> > +bool ovl_is_escaped_xattr(struct super_block *sb, const char *name)
>> > +{
>> > +       struct ovl_fs *ofs =3D sb->s_fs_info;
>> > +
>> > +       if (ofs->config.userxattr)
>> > +               return strncmp(name, OVL_XATTR_ESCAPE_USER_PREFIX,
>> > +                              OVL_XATTR_ESCAPE_USER_PREFIX_LEN) =3D=
=3D 0;
>> > +       else
>> > +               return strncmp(name, OVL_XATTR_ESCAPE_TRUSTED_PREFIX,
>> > +                              OVL_XATTR_ESCAPE_TRUSTED_PREFIX_LEN - 1=
) =3D=3D 0;
>> > +}
>> > +
>> >  bool ovl_is_private_xattr(struct super_block *sb, const char *name)
>> >  {
>> >         struct ovl_fs *ofs =3D OVL_FS(sb);
>> > @@ -82,8 +94,8 @@ static int ovl_xattr_get(struct dentry *dentry, stru=
ct inode *inode, const char
>> >
>> >  static bool ovl_can_list(struct super_block *sb, const char *s)
>> >  {
>> > -       /* Never list private (.overlay) */
>> > -       if (ovl_is_private_xattr(sb, s))
>> > +       /* Never list non-escaped private (.overlay) */
>> > +       if (ovl_is_private_xattr(sb, s) && !ovl_is_escaped_xattr(sb, s=
))
>> >                 return false;
>> >
>> >         /* List all non-trusted xattrs */
>> > @@ -97,10 +109,12 @@ static bool ovl_can_list(struct super_block *sb, =
const char *s)
>> >  ssize_t ovl_listxattr(struct dentry *dentry, char *list, size_t size)
>> >  {
>> >         struct dentry *realdentry =3D ovl_dentry_real(dentry);
>> > +       struct ovl_fs *ofs =3D OVL_FS(dentry->d_sb);
>> >         ssize_t res;
>> >         size_t len;
>> >         char *s;
>> >         const struct cred *old_cred;
>> > +       size_t prefix_len;
>> >
>> >         old_cred =3D ovl_override_creds(dentry->d_sb);
>> >         res =3D vfs_listxattr(realdentry, list, size);
>> > @@ -108,6 +122,9 @@ ssize_t ovl_listxattr(struct dentry *dentry, char =
*list, size_t size)
>> >         if (res <=3D 0 || size =3D=3D 0)
>> >                 return res;
>> >
>> > +       prefix_len =3D ofs->config.userxattr ?
>> > +               OVL_XATTR_USER_PREFIX_LEN : OVL_XATTR_TRUSTED_PREFIX_L=
EN;
>> > +
>> >         /* filter out private xattrs */
>> >         for (s =3D list, len =3D res; len;) {
>> >                 size_t slen =3D strnlen(s, len) + 1;
>> > @@ -120,6 +137,12 @@ ssize_t ovl_listxattr(struct dentry *dentry, char=
 *list, size_t size)
>> >                 if (!ovl_can_list(dentry->d_sb, s)) {
>> >                         res -=3D slen;
>> >                         memmove(s, s + slen, len);
>> > +               } else if (ovl_is_escaped_xattr(dentry->d_sb, s)) {
>> > +                       memmove(s + prefix_len,
>> > +                               s + prefix_len + OVL_XATTR_ESCAPE_PREF=
IX_LEN,
>> > +                               slen - (prefix_len + OVL_XATTR_ESCAPE_=
PREFIX_LEN) + len);
>> > +                       res -=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
>> > +                       s +=3D slen - OVL_XATTR_ESCAPE_PREFIX_LEN;
>>
>> It's a bit hard to follow. how about:
>>
>> res -=3D OVL_XATTR_ESCAPE_PREFIX_LEN;
>> name_len =3D slen - prefix_len - OVL_XATTR_ESCAPE_PREFIX_LEN;
>> s +=3D prefix_len;
>> memmove(s, s + OVL_XATTR_ESCAPE_PREFIX_LEN, name_len + len);
>> s +=3D OVL_XATTR_ESCAPE_PREFIX_LEN + name_len;
>>
>
> The last line needs to be just s+=3D name_len, but yeah, this looks nicer=
.
>

Cool. no need to post v4 just for this.
You can push to your branch and once we have feedback from Miklos
we can take it from there.

Thanks,
Amir.
