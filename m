Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 63B41C77B73
	for <linux-unionfs@archiver.kernel.org>; Sun, 21 May 2023 08:09:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229559AbjEUIJD (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 21 May 2023 04:09:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229649AbjEUIJB (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 21 May 2023 04:09:01 -0400
Received: from smtp-relay-internal-0.canonical.com (smtp-relay-internal-0.canonical.com [185.125.188.122])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F6E102
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:08:59 -0700 (PDT)
Received: from mail-ed1-f71.google.com (mail-ed1-f71.google.com [209.85.208.71])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by smtp-relay-internal-0.canonical.com (Postfix) with ESMTPS id E93173F458
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 08:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
        s=20210705; t=1684656536;
        bh=D4a7NFbYZdr4NKPTHaSPRKtANJCLNSohcV2A2Pqbz7w=;
        h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
         Content-Type:In-Reply-To;
        b=KBAHIypg0Q5P+G2Y42Q5ciMbvwNLlpOEYFHLY3+fTuiYBex6AXSr6Ma7w93KVE7Nl
         G5QhWMQBiRKcwijeLTdiLsKNyL4pwswhx/Rq7DzOloalzhLYv1Bp7BmJOez7G2FapX
         o1nhBkjoYYp0wZuvh2YNVo8lfzcDHHXC1Y+M6lJWZEFTNmNSNI5zJKcMZtBFg9Oe5F
         QNhimCQ1V/Zg8CDDGgVfiGZ3kWWKU81z/xne2GTJYeeF/TOXHGBmsjkDCMHUASFadN
         ApuzMnBUD/OB27FChW0afa6FzAwVkPWKmCMuv4CY/lu/IH99+FiUv0hwj1R+hRobMZ
         2HcoCVYo8h1TQ==
Received: by mail-ed1-f71.google.com with SMTP id 4fb4d7f45d1cf-50a16ab50e6so4670262a12.0
        for <linux-unionfs@vger.kernel.org>; Sun, 21 May 2023 01:08:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684656536; x=1687248536;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=D4a7NFbYZdr4NKPTHaSPRKtANJCLNSohcV2A2Pqbz7w=;
        b=W0qr+y0PiL6iTWH6whuZYRT3+8wUur3/9iXnXKmZenV77Veq5HwDQkToRNnDgcbrDa
         +woIokoell9d6O/0toAXTlN7VIfu4bJIYvHxrt7nujS2S6VQpClHfOSYunEJmZ+DtquO
         supf1vFy6ojpQOqpVIX18HZ3FTmR+P5JmbDUq+cgpNVpXjoLW3icCxyktQ7XQHk4L24L
         E6liTN5mKJiEfu6ICQm0XixmDKJ1IK9zzWItcDKavS4rAah6JLDTD1D/i34ZtxHFj2ml
         kPNJ80UsUas4M1HPhFv/z6Bpw6vUpBiFc1ercjHpzNxeqnWKBsbEr84zfCGDN6dLlFfx
         zr+A==
X-Gm-Message-State: AC+VfDwCIhWPt79VTUo4HgV04BwdtDttICQ/NULjKM2oW4zGIyldEOku
        DbHTDMix0gMI99DCrK0o/sglKSyDvh6T+WiNVuo5/rMNXI8DmSnGDxL9Hjoo9f5v40g0xhPZJ4P
        Zvi7vanvh3CKVDUnv25G4QboYEceKelBlpcGNJSbo+28=
X-Received: by 2002:aa7:d84d:0:b0:506:741e:5c14 with SMTP id f13-20020aa7d84d000000b00506741e5c14mr5521997eds.30.1684656536376;
        Sun, 21 May 2023 01:08:56 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ5mq7iVe/zedFU6nogB7eeLqebSUmtsgjf2jeLI2+cE1nsmndfX047ChOhrZo9/snVITMzH/g==
X-Received: by 2002:aa7:d84d:0:b0:506:741e:5c14 with SMTP id f13-20020aa7d84d000000b00506741e5c14mr5521988eds.30.1684656536045;
        Sun, 21 May 2023 01:08:56 -0700 (PDT)
Received: from localhost (host-87-10-127-160.retail.telecomitalia.it. [87.10.127.160])
        by smtp.gmail.com with ESMTPSA id l17-20020aa7d951000000b0050bc4600d38sm1607791eds.79.2023.05.21.01.08.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 21 May 2023 01:08:55 -0700 (PDT)
Date:   Sun, 21 May 2023 10:08:55 +0200
From:   Andrea Righi <andrea.righi@canonical.com>
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/2] ovl: make consistent use of OVL_FS()
Message-ID: <ZGnRl7gvto2KvpWr@righiandr-XPS-13-7390>
References: <20230520184114.77725-1-andrea.righi@canonical.com>
 <20230520184114.77725-3-andrea.righi@canonical.com>
 <CAOQ4uxh-ApuxzCG57BeSDveg34LQWD48xKHKO9vCX=5NTn647A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxh-ApuxzCG57BeSDveg34LQWD48xKHKO9vCX=5NTn647A@mail.gmail.com>
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, May 21, 2023 at 09:51:46AM +0300, Amir Goldstein wrote:
> On Sat, May 20, 2023 at 9:41 PM Andrea Righi <andrea.righi@canonical.com> wrote:
> >
> > Always use OVL_FS() to retrieve the corresponding struct ovl_fs from a
> > struct super_block.
> >
> > Moreover, make sure that it is exclusively used with an overlayfs
> > superblock when CONFIG_OVERLAY_FS_DEBUG is enabled (otherwise trigger a
> > WARN_ON_ONCE).
> 
> Seems that you do not mind learning how we usually do things...
> so "Moreover", "Also" is usually an indication that this change needs to be
> in a separate patch.
> I think this is one of those cases.

OK, I'll split the "moreover" part in a separate patch. :)

> 
> >
> > Signed-off-by: Andrea Righi <andrea.righi@canonical.com>
> > ---
> >  fs/overlayfs/copy_up.c   |  2 +-
> >  fs/overlayfs/export.c    | 10 +++++-----
> >  fs/overlayfs/inode.c     |  8 ++++----
> >  fs/overlayfs/namei.c     |  2 +-
> >  fs/overlayfs/ovl_entry.h | 16 ++++++++++++++++
> >  fs/overlayfs/super.c     | 12 ++++++------
> >  fs/overlayfs/util.c      | 18 +++++++++---------
> >  7 files changed, 42 insertions(+), 26 deletions(-)
> >
> > diff --git a/fs/overlayfs/copy_up.c b/fs/overlayfs/copy_up.c
> > index f658cc8ea492..60aa615820e7 100644
> > --- a/fs/overlayfs/copy_up.c
> > +++ b/fs/overlayfs/copy_up.c
> > @@ -905,7 +905,7 @@ static int ovl_do_copy_up(struct ovl_copy_up_ctx *c)
> >  static bool ovl_need_meta_copy_up(struct dentry *dentry, umode_t mode,
> >                                   int flags)
> >  {
> > -       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> >
> >         if (!ofs->config.metacopy)
> >                 return false;
> > diff --git a/fs/overlayfs/export.c b/fs/overlayfs/export.c
> > index defd4e231ad2..f5f0ef8e3ce8 100644
> > --- a/fs/overlayfs/export.c
> > +++ b/fs/overlayfs/export.c
> > @@ -182,7 +182,7 @@ static int ovl_connect_layer(struct dentry *dentry)
> >   */
> >  static int ovl_check_encode_origin(struct dentry *dentry)
> >  {
> > -       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> >
> >         /* Upper file handle for pure upper */
> >         if (!ovl_dentry_lower(dentry))
> > @@ -434,7 +434,7 @@ static struct dentry *ovl_lookup_real_inode(struct super_block *sb,
> >                                             struct dentry *real,
> >                                             const struct ovl_layer *layer)
> >  {
> > -       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(sb);
> >         struct dentry *index = NULL;
> >         struct dentry *this = NULL;
> >         struct inode *inode;
> > @@ -655,7 +655,7 @@ static struct dentry *ovl_get_dentry(struct super_block *sb,
> >                                      struct ovl_path *lowerpath,
> >                                      struct dentry *index)
> >  {
> > -       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(sb);
> >         const struct ovl_layer *layer = upper ? &ofs->layers[0] : lowerpath->layer;
> >         struct dentry *real = upper ?: (index ?: lowerpath->dentry);
> >
> > @@ -680,7 +680,7 @@ static struct dentry *ovl_get_dentry(struct super_block *sb,
> >  static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
> >                                         struct ovl_fh *fh)
> >  {
> > -       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(sb);
> >         struct dentry *dentry;
> >         struct dentry *upper;
> >
> > @@ -700,7 +700,7 @@ static struct dentry *ovl_upper_fh_to_d(struct super_block *sb,
> >  static struct dentry *ovl_lower_fh_to_d(struct super_block *sb,
> >                                         struct ovl_fh *fh)
> >  {
> > -       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(sb);
> >         struct ovl_path origin = { };
> >         struct ovl_path *stack = &origin;
> >         struct dentry *dentry = NULL;
> > diff --git a/fs/overlayfs/inode.c b/fs/overlayfs/inode.c
> > index 541cf3717fc2..c27823f6e7aa 100644
> > --- a/fs/overlayfs/inode.c
> > +++ b/fs/overlayfs/inode.c
> > @@ -334,7 +334,7 @@ static const char *ovl_get_link(struct dentry *dentry,
> >
> >  bool ovl_is_private_xattr(struct super_block *sb, const char *name)
> >  {
> > -       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(sb);
> >
> >         if (ofs->config.userxattr)
> >                 return strncmp(name, OVL_XATTR_USER_PREFIX,
> > @@ -689,7 +689,7 @@ int ovl_set_acl(struct mnt_idmap *idmap, struct dentry *dentry,
> >  int ovl_update_time(struct inode *inode, struct timespec64 *ts, int flags)
> >  {
> >         if (flags & S_ATIME) {
> > -               struct ovl_fs *ofs = inode->i_sb->s_fs_info;
> > +               struct ovl_fs *ofs = OVL_FS(inode->i_sb);
> >                 struct path upperpath = {
> >                         .mnt = ovl_upper_mnt(ofs),
> >                         .dentry = ovl_upperdentry_dereference(OVL_I(inode)),
> > @@ -952,7 +952,7 @@ static inline void ovl_lockdep_annotate_inode_mutex_key(struct inode *inode)
> >
> >  static void ovl_next_ino(struct inode *inode)
> >  {
> > -       struct ovl_fs *ofs = inode->i_sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(inode->i_sb);
> >
> >         inode->i_ino = atomic_long_inc_return(&ofs->last_ino);
> >         if (unlikely(!inode->i_ino))
> > @@ -1284,7 +1284,7 @@ struct inode *ovl_get_trap_inode(struct super_block *sb, struct dentry *dir)
> >  static bool ovl_hash_bylower(struct super_block *sb, struct dentry *upper,
> >                              struct dentry *lower, bool index)
> >  {
> > -       struct ovl_fs *ofs = sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(sb);
> >
> >         /* No, if pure upper */
> >         if (!lower)
> > diff --git a/fs/overlayfs/namei.c b/fs/overlayfs/namei.c
> > index cfb3420b7df0..d0f196b85541 100644
> > --- a/fs/overlayfs/namei.c
> > +++ b/fs/overlayfs/namei.c
> > @@ -832,7 +832,7 @@ struct dentry *ovl_lookup(struct inode *dir, struct dentry *dentry,
> >  {
> >         struct ovl_entry *oe;
> >         const struct cred *old_cred;
> > -       struct ovl_fs *ofs = dentry->d_sb->s_fs_info;
> > +       struct ovl_fs *ofs = OVL_FS(dentry->d_sb);
> >         struct ovl_entry *poe = dentry->d_parent->d_fsdata;
> >         struct ovl_entry *roe = dentry->d_sb->s_root->d_fsdata;
> >         struct ovl_path *stack = NULL, *origin_path = NULL;
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index fd11fe6d6d45..0b93b1d9ad79 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -95,8 +95,24 @@ static inline struct mnt_idmap *ovl_upper_mnt_idmap(struct ovl_fs *ofs)
> >         return mnt_idmap(ovl_upper_mnt(ofs));
> >  }
> >
> > +extern struct file_system_type ovl_fs_type;
> > +
> > +#ifdef CONFIG_OVERLAY_FS_DEBUG
> > +static inline bool is_ovl_fs_sb(struct super_block *sb)
> > +{
> > +       return sb->s_type == &ovl_fs_type;
> > +}
> > +#else
> > +static inline bool is_ovl_fs_sb(struct super_block *sb)
> > +{
> > +       return true;
> > +}
> > +#endif
> > +
> >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
> >  {
> > +       WARN_ON_ONCE(!is_ovl_fs_sb(sb));
> > +
> >         return (struct ovl_fs *)sb->s_fs_info;
> >  }
> >
> 
> IMO, is_ovl_fs_sb() is useful and no reason to hide it under
> CONFIG_OVERLAY_FS_DEBUG.
> IMO, only the fortification of OVL_FS() needs to be hidden inside
> CONFIG_OVERLAY_FS_DEBUG.
> 
> With those minor comments fixed you may add:
> 
> Reviewed-by: Amir Goldstein <amir73il@gmail.com>

Makes sense. Will send a v3 with your changes.

Thanks for the review!
-Andrea
