Return-Path: <SRS0=+0RS=6H=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 299AEC55186
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 01:18:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1CB12076C
	for <linux-unionfs@archiver.kernel.org>; Thu, 23 Apr 2020 01:18:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mykernel.net header.i=cgxu519@mykernel.net header.b="VOniuY70"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726398AbgDWBSc (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:18:32 -0400
Received: from [163.53.93.251] ([163.53.93.251]:25350 "EHLO
        sender2-pp-o92.zoho.com.cn" rhost-flags-FAIL-FAIL-OK-OK)
        by vger.kernel.org with ESMTP id S1726324AbgDWBSc (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 22 Apr 2020 21:18:32 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1587604665; cv=none; 
        d=zoho.com.cn; s=zohoarc; 
        b=qo29pjaE5/0juLHCeKpneFDGecMoPXJa0SZ0ai5MWgsPKvMDtP7Ij8l6PLT/gheWVMd8AVw3nJi4YCAMY2PY1Yh35UcoceK2Dw+gBTXCDPBTGjWcONOfXQlc6wigLhZizuQKbOnKQfdRYKbuVrDofpYNfgV0/pByhUPFVWr65Ts=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zoho.com.cn; s=zohoarc; 
        t=1587604665; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:References:Subject:To; 
        bh=l0smsCNXL/DlR+MfTkL9SiAqYMXALueXnri0zb89aKw=; 
        b=NqYZOO4ZdOhcGPpBtJeHeXdlon5MzA2YlIzzrfk+PA4JsqacS9LFiUqDg7wU12bHEquGgMZy+5/kUNcBJkRHV0x1JKUYkBdO979kenxY/+OUT7qGadCA51aaEKAHKu6zF5ewJqGq6TX6+4pViM68QDvfAkzxgHhXLro3rwSWzHg=
ARC-Authentication-Results: i=1; mx.zoho.com.cn;
        dkim=pass  header.i=mykernel.net;
        spf=pass  smtp.mailfrom=cgxu519@mykernel.net;
        dmarc=pass header.from=<cgxu519@mykernel.net> header.from=<cgxu519@mykernel.net>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1587604665;
        s=zohomail; d=mykernel.net; i=cgxu519@mykernel.net;
        h=Date:From:Reply-To:To:Cc:Message-ID:In-Reply-To:References:Subject:MIME-Version:Content-Type:Content-Transfer-Encoding;
        bh=l0smsCNXL/DlR+MfTkL9SiAqYMXALueXnri0zb89aKw=;
        b=VOniuY701fLNkoyeeww29jDGwek92sLxh106ZHDrUPXQY1P9P4clJ0eGRyeLkwS0
        OQ8A4RGx7nUSebbSVfSBHHz9SfN5cyU8XZSRCYZbieUxC50HLO9YzBuGThWk90/nlpm
        h9tgaVt3JMvS+NINUDfYBX8v8mu4Zy5+D0iCd8Gk=
Received: from mail.baihui.com by mx.zoho.com.cn
        with SMTP id 1587604664371225.39135912056224; Thu, 23 Apr 2020 09:17:44 +0800 (CST)
Date:   Thu, 23 Apr 2020 09:17:44 +0800
From:   Chengguang Xu <cgxu519@mykernel.net>
Reply-To: cgxu519@mykernel.net
To:     "Amir Goldstein" <amir73il@gmail.com>
Cc:     "Miklos Szeredi" <miklos@szeredi.hu>,
        "overlayfs" <linux-unionfs@vger.kernel.org>
Message-ID: <171a49cb02a.e6962d897896.4484083556616944063@mykernel.net>
In-Reply-To: <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
References: <20200422102740.6670-1-cgxu519@mykernel.net> <CAOQ4uxj5JsWOgQ8vHqTkAXx16Y9URTgNpALY5XO=VNUAMTkOMw@mail.gmail.com>
Subject: Re: [PATCH v4] ovl: whiteout inode sharing
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Importance: Medium
User-Agent: ZohoCN Mail
X-Mailer: ZohoCN Mail
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

 ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=B8=89, 2020-04-22 19:50:30 Amir Golds=
tein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
 > On Wed, Apr 22, 2020 at 1:28 PM Chengguang Xu <cgxu519@mykernel.net> wro=
te:
 > >
 > > Sharing inode with different whiteout files for saving
 > > inode and speeding up deleting operation.
 > >
 > > Signed-off-by: Chengguang Xu <cgxu519@mykernel.net>
 >=20
 > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
 >=20
 > Just one question...
 >=20
 > > ---
 > > v1->v2:
 > > - Address Amir's comments in v1.
 > >
 > > v2->v3:
 > > - Address Amir's comments in v2.
 > > - Rebase on Amir's "Overlayfs use index dir as work dir" patch set.
 > > - Keep at most one whiteout tmpfile in work dir.
 > >
 > > v3->v4:
 > > - Disable the feature after link failure.
 > > - Add mount option(whiteout link max) for overlayfs instance.
 > >
 > >  fs/overlayfs/dir.c       | 47 ++++++++++++++++++++++++++++++++++-----=
-
 > >  fs/overlayfs/overlayfs.h | 10 +++++++--
 > >  fs/overlayfs/ovl_entry.h |  5 +++++
 > >  fs/overlayfs/readdir.c   |  3 ++-
 > >  fs/overlayfs/super.c     | 24 ++++++++++++++++++++
 > >  fs/overlayfs/util.c      |  3 ++-
 > >  6 files changed, 81 insertions(+), 11 deletions(-)
 > >
 > > diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
 > > index 279009dee366..8b7d8854f31f 100644
 > > --- a/fs/overlayfs/dir.c
 > > +++ b/fs/overlayfs/dir.c
 > > @@ -62,35 +62,67 @@ struct dentry *ovl_lookup_temp(struct dentry *work=
dir)
 > >  }
 > >
 > >  /* caller holds i_mutex on workdir */
 > > -static struct dentry *ovl_whiteout(struct dentry *workdir)
 > > +static struct dentry *ovl_whiteout(struct ovl_fs *ofs, struct dentry =
*workdir)
 > >  {
 > >         int err;
 > > +       bool retried =3D false;
 > > +       bool should_link =3D (ofs->whiteout_link_max > 1);
 > >         struct dentry *whiteout;
 > >         struct inode *wdir =3D workdir->d_inode;
 > >
 > > +retry:
 > >         whiteout =3D ovl_lookup_temp(workdir);
 > >         if (IS_ERR(whiteout))
 > >                 return whiteout;
 > >
 > > +       err =3D 0;
 > > +       if (should_link) {
 > > +               if (ovl_whiteout_linkable(ofs)) {
 > > +                       err =3D ovl_do_link(ofs->whiteout, wdir, white=
out);
 > > +                       if (!err)
 > > +                               return whiteout;
 > > +               } else if (ofs->whiteout) {
 > > +                       dput(whiteout);
 > > +                       whiteout =3D ofs->whiteout;
 > > +                       ofs->whiteout =3D NULL;
 > > +                       return whiteout;
 > > +               }
 > > +
 > > +               if (err) {
 > > +                       pr_warn("Failed to link whiteout - disabling w=
hiteout inode sharing(nlink=3D%u, err=3D%i)\n",
 > > +                               ofs->whiteout->d_inode->i_nlink, err);
 > > +                       ofs->whiteout_link_max =3D 0;
 > > +                       should_link =3D false;
 > > +                       ovl_cleanup(wdir, ofs->whiteout);
 > > +                       dput(ofs->whiteout);
 > > +                       ofs->whiteout =3D NULL;
 > > +               }
 > > +       }
 > > +
 > >         err =3D ovl_do_whiteout(wdir, whiteout);
 > >         if (err) {
 > >                 dput(whiteout);
 > > -               whiteout =3D ERR_PTR(err);
 > > +               return ERR_PTR(err);
 > >         }
 > >
 > > -       return whiteout;
 > > +       if (!should_link || retried)
 > > +               return whiteout;
 > > +
 > > +       ofs->whiteout =3D whiteout;
 > > +       retried =3D true;
 > > +       goto retry;
 > >  }
 > >
 > >  /* Caller must hold i_mutex on both workdir and dir */
 > > -int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *di=
r,
 > > -                            struct dentry *dentry)
 > > +int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workd=
ir,
 > > +                            struct inode *dir, struct dentry *dentry)
 > >  {
 > >         struct inode *wdir =3D workdir->d_inode;
 > >         struct dentry *whiteout;
 > >         int err;
 > >         int flags =3D 0;
 > >
 > > -       whiteout =3D ovl_whiteout(workdir);
 > > +       whiteout =3D ovl_whiteout(ofs, workdir);
 > >         err =3D PTR_ERR(whiteout);
 > >         if (IS_ERR(whiteout))
 > >                 return err;
 > > @@ -715,6 +747,7 @@ static bool ovl_matches_upper(struct dentry *dentr=
y, struct dentry *upper)
 > >  static int ovl_remove_and_whiteout(struct dentry *dentry,
 > >                                    struct list_head *list)
 > >  {
 > > +       struct ovl_fs *ofs =3D dentry->d_sb->s_fs_info;
 > >         struct dentry *workdir =3D ovl_workdir(dentry);
 > >         struct dentry *upperdir =3D ovl_dentry_upper(dentry->d_parent)=
;
 > >         struct dentry *upper;
 > > @@ -748,7 +781,7 @@ static int ovl_remove_and_whiteout(struct dentry *=
dentry,
 > >                 goto out_dput_upper;
 > >         }
 > >
 > > -       err =3D ovl_cleanup_and_whiteout(workdir, d_inode(upperdir), u=
pper);
 > > +       err =3D ovl_cleanup_and_whiteout(ofs, workdir, d_inode(upperdi=
r), upper);
 > >         if (err)
 > >                 goto out_d_drop;
 > >
 > > diff --git a/fs/overlayfs/overlayfs.h b/fs/overlayfs/overlayfs.h
 > > index e00b1ff6dea9..3b127c997a6d 100644
 > > --- a/fs/overlayfs/overlayfs.h
 > > +++ b/fs/overlayfs/overlayfs.h
 > > @@ -225,6 +225,12 @@ static inline bool ovl_open_flags_need_copy_up(in=
t flags)
 > >         return ((OPEN_FMODE(flags) & FMODE_WRITE) || (flags & O_TRUNC)=
);
 > >  }
 > >
 > > +static inline bool ovl_whiteout_linkable(struct ovl_fs *ofs)
 > > +{
 > > +       return (ofs->whiteout &&
 > > +               ofs->whiteout->d_inode->i_nlink < ofs->whiteout_link_m=
ax);
 > > +}
 > > +
 > >  /* util.c */
 > >  int ovl_want_write(struct dentry *dentry);
 > >  void ovl_drop_write(struct dentry *dentry);
 > > @@ -455,8 +461,8 @@ static inline void ovl_copyflags(struct inode *fro=
m, struct inode *to)
 > >
 > >  /* dir.c */
 > >  extern const struct inode_operations ovl_dir_inode_operations;
 > > -int ovl_cleanup_and_whiteout(struct dentry *workdir, struct inode *di=
r,
 > > -                            struct dentry *dentry);
 > > +int ovl_cleanup_and_whiteout(struct ovl_fs *ofs, struct dentry *workd=
ir,
 > > +                            struct inode *dir, struct dentry *dentry)=
;
 > >  struct ovl_cattr {
 > >         dev_t rdev;
 > >         umode_t mode;
 > > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
 > > index 5762d802fe01..c805c35e0594 100644
 > > --- a/fs/overlayfs/ovl_entry.h
 > > +++ b/fs/overlayfs/ovl_entry.h
 > > @@ -17,6 +17,7 @@ struct ovl_config {
 > >         bool nfs_export;
 > >         int xino;
 > >         bool metacopy;
 > > +       unsigned int whiteout_link_max;
 > >  };
 > >
 > >  struct ovl_sb {
 > > @@ -77,6 +78,10 @@ struct ovl_fs {
 > >         int xino_mode;
 > >         /* For allocation of non-persistent inode numbers */
 > >         atomic_long_t last_ino;
 > > +       /* Whiteout dentry cache */
 > > +       struct dentry *whiteout;
 > > +       /* Whiteout max link count */
 > > +       unsigned int whiteout_link_max;
 > >  };
 > >
 > >  static inline struct ovl_fs *OVL_FS(struct super_block *sb)
 > > diff --git a/fs/overlayfs/readdir.c b/fs/overlayfs/readdir.c
 > > index 20f5310d3ee4..bf22fb7792c1 100644
 > > --- a/fs/overlayfs/readdir.c
 > > +++ b/fs/overlayfs/readdir.c
 > > @@ -1154,7 +1154,8 @@ int ovl_indexdir_cleanup(struct ovl_fs *ofs)
 > >                          * Whiteout orphan index to block future open =
by
 > >                          * handle after overlay nlink dropped to zero.
 > >                          */
 > > -                       err =3D ovl_cleanup_and_whiteout(indexdir, dir=
, index);
 > > +                       err =3D ovl_cleanup_and_whiteout(ofs, indexdir=
, dir,
 > > +                                                      index);
 > >                 } else {
 > >                         /* Cleanup orphan index entries */
 > >                         err =3D ovl_cleanup(dir, index);
 > > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
 > > index f57aa348dcd6..6bccab4d5596 100644
 > > --- a/fs/overlayfs/super.c
 > > +++ b/fs/overlayfs/super.c
 > > @@ -26,6 +26,10 @@ struct ovl_dir_cache;
 > >
 > >  #define OVL_MAX_STACK 500
 > >
 > > +static unsigned int ovl_whiteout_link_max_def =3D 60000;
 > > +module_param_named(whiteout_link_max, ovl_whiteout_link_max_def, uint=
, 0644);
 > > +MODULE_PARM_DESC(whiteout_link_max, "Maximum count of whiteout file l=
ink");
 > > +
 > >  static bool ovl_redirect_dir_def =3D IS_ENABLED(CONFIG_OVERLAY_FS_RED=
IRECT_DIR);
 > >  module_param_named(redirect_dir, ovl_redirect_dir_def, bool, 0644);
 > >  MODULE_PARM_DESC(redirect_dir,
 > > @@ -219,6 +223,7 @@ static void ovl_free_fs(struct ovl_fs *ofs)
 > >         iput(ofs->upperdir_trap);
 > >         dput(ofs->indexdir);
 > >         dput(ofs->workdir);
 > > +       dput(ofs->whiteout);
 > >         if (ofs->workdir_locked)
 > >                 ovl_inuse_unlock(ofs->workbasedir);
 > >         dput(ofs->workbasedir);
 > > @@ -358,6 +363,10 @@ static int ovl_show_options(struct seq_file *m, s=
truct dentry *dentry)
 > >         if (ofs->config.metacopy !=3D ovl_metacopy_def)
 > >                 seq_printf(m, ",metacopy=3D%s",
 > >                            ofs->config.metacopy ? "on" : "off");
 > > +       if (ofs->config.whiteout_link_max !=3D ovl_whiteout_link_max_d=
ef)
 > > +               seq_printf(m, ",whiteout_link_max=3D%u",
 > > +                          ofs->config.whiteout_link_max);
 > > +
 > >         return 0;
 > >  }
 > >
 > > @@ -398,6 +407,7 @@ enum {
 > >         OPT_XINO_AUTO,
 > >         OPT_METACOPY_ON,
 > >         OPT_METACOPY_OFF,
 > > +       OPT_WHITEOUT_LINK_MAX,
 > >         OPT_ERR,
 > >  };
 > >
 > > @@ -416,6 +426,7 @@ static const match_table_t ovl_tokens =3D {
 > >         {OPT_XINO_AUTO,                 "xino=3Dauto"},
 > >         {OPT_METACOPY_ON,               "metacopy=3Don"},
 > >         {OPT_METACOPY_OFF,              "metacopy=3Doff"},
 > > +       {OPT_WHITEOUT_LINK_MAX,         "whiteout_link_max=3D%u"},
 > >         {OPT_ERR,                       NULL}
 > >  };
 > >
 > > @@ -469,6 +480,7 @@ static int ovl_parse_opt(char *opt, struct ovl_con=
fig *config)
 > >  {
 > >         char *p;
 > >         int err;
 > > +       int link_max;
 > >         bool metacopy_opt =3D false, redirect_opt =3D false;
 > >         bool nfs_export_opt =3D false, index_opt =3D false;
 > >
 > > @@ -560,6 +572,13 @@ static int ovl_parse_opt(char *opt, struct ovl_co=
nfig *config)
 > >                         metacopy_opt =3D true;
 > >                         break;
 > >
 > > +               case OPT_WHITEOUT_LINK_MAX:
 > > +                       if (match_int(&args[0], &link_max))
 > > +                               return -EINVAL;
 > > +                       if (link_max < ovl_whiteout_link_max_def)
 > > +                               config->whiteout_link_max =3D link_max=
;
 >=20
 > Why not allow link_max > ovl_whiteout_link_max_def?
 > admin may want to disable ovl_whiteout_link_max_def by default
 > in module parameter, but allow it for specific overlay instances.
 >=20

In this use case, seems we don't need module param any more, we just need t=
o set  default value for option.

I would like to treate module param as a total switch, so that it could dis=
able the feathre for all instances at the same time.
I think sometimes it's helpful for lazy admin(like me).


 > In any case, if we do have a good reason to ignore user configurable
 > value we should pr_warn about it and explain to users what they
 > need to do to overcome the miss configuration issue.
 >=20

Agree, let me add a warn for this case.

Thanks,
cgxu
