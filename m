From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH 04/11] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Wed, 18 Oct 2017 09:03:43 -0400
Message-ID: <20171018130343.GC3445@redhat.com>
References: <1508274358-17456-1-git-send-email-vgoyal@redhat.com>
 <1508274358-17456-5-git-send-email-vgoyal@redhat.com>
 <CAOQ4uximnQT43BK3Ut82Vs0FMDi03cxAkyDK4LthkMiXHii-HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46060 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753070AbdJRNDo (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 18 Oct 2017 09:03:44 -0400
Content-Disposition: inline
In-Reply-To: <CAOQ4uximnQT43BK3Ut82Vs0FMDi03cxAkyDK4LthkMiXHii-HQ@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Wed, Oct 18, 2017 at 07:31:51AM +0300, Amir Goldstein wrote:
> On Wed, Oct 18, 2017 at 12:05 AM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > By default metadata only copy up is disabled. Provide a mount option so
> > that users can choose one way or other.
> >
> > Also provide a kernel config and module option to enable/disable
> > metacopy feature.
> >
> > Like index feature, when overlay is mounted, on root upper directory we
> > set ORIGIN which points to lower. And at later mount time it is verified
> > again. This hopes to get the configuration right. But this does only so
> > much as we don't verify all the lowers. So it is possible that a lower is
> > missing and later data copy up fails.
> 
> Like index feature, please error mount if ovl_inuse_trylock fails.
> As you know, this error is only conditional because of backward
> compatibility, so any new opt-in feature should enforce it.

Hi Amir,

I am not so sure about it. Avoiding leaking any mount point is really
really hard. And I don't think current container runtime have been
modified to make it fool proof.

IMHO, if we really want to enforce something like this, then we need
to have some sort of capability to find existing superblock and reuse it.
(Something like what happens with block devices).

I am afraid that if I start enforcing this, then this feature will not
be used at all because software has not been hardended enough to avoid
mount point leaks completely.

Vivek

> 
> >
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  fs/overlayfs/Kconfig     |  8 ++++++++
> >  fs/overlayfs/ovl_entry.h |  1 +
> >  fs/overlayfs/super.c     | 38 +++++++++++++++++++++++++++++++++++---
> >  3 files changed, 44 insertions(+), 3 deletions(-)
> >
> > diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> > index cbfc196e5dc5..17a0b17ad14c 100644
> > --- a/fs/overlayfs/Kconfig
> > +++ b/fs/overlayfs/Kconfig
> > @@ -43,3 +43,11 @@ config OVERLAY_FS_INDEX
> >           outcomes.  However, mounting the same overlay with an old kernel
> >           read-write and then mounting it again with a new kernel, will have
> >           unexpected results.
> > +
> > +config OVERLAY_FS_METACOPY
> > +       bool "Overlayfs: turn on metadata only copy up feature by default"
> > +       depends on OVERLAY_FS
> > +       help
> > +         If this config option is enabled then overlay filesystems will
> > +         copy up only metadata where appropriate and data copy up will
> > +         happen when a file is opended for WRITE operation.
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index 25d9b5adcd42..6806f0b0fbc2 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -15,6 +15,7 @@ struct ovl_config {
> >         bool default_permissions;
> >         bool redirect_dir;
> >         bool index;
> > +       bool metacopy;
> >  };
> >
> >  /* private information held for overlayfs's superblock */
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 092d150643c1..32e3d4be1a71 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -39,6 +39,11 @@ module_param_named(index, ovl_index_def, bool, 0644);
> >  MODULE_PARM_DESC(ovl_index_def,
> >                  "Default to on or off for the inodes index feature");
> >
> > +static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
> > +module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
> > +MODULE_PARM_DESC(ovl_metacopy_def,
> > +                "Default to on or off for the metadata only copy up feature");
> > +
> >  static void ovl_dentry_release(struct dentry *dentry)
> >  {
> >         struct ovl_entry *oe = dentry->d_fsdata;
> > @@ -303,6 +308,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
> >         if (ufs->config.index != ovl_index_def)
> >                 seq_printf(m, ",index=%s",
> >                            ufs->config.index ? "on" : "off");
> > +       if (ufs->config.metacopy != ovl_metacopy_def)
> > +               seq_printf(m, ",metacopy=%s",
> > +                          ufs->config.metacopy ? "on" : "off");
> >         return 0;
> >  }
> >
> > @@ -336,6 +344,8 @@ enum {
> >         OPT_REDIRECT_DIR_OFF,
> >         OPT_INDEX_ON,
> >         OPT_INDEX_OFF,
> > +       OPT_METACOPY_ON,
> > +       OPT_METACOPY_OFF,
> >         OPT_ERR,
> >  };
> >
> > @@ -348,6 +358,8 @@ static const match_table_t ovl_tokens = {
> >         {OPT_REDIRECT_DIR_OFF,          "redirect_dir=off"},
> >         {OPT_INDEX_ON,                  "index=on"},
> >         {OPT_INDEX_OFF,                 "index=off"},
> > +       {OPT_METACOPY_ON,               "metacopy=on"},
> > +       {OPT_METACOPY_OFF,              "metacopy=off"},
> >         {OPT_ERR,                       NULL}
> >  };
> >
> > @@ -428,6 +440,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >                         config->index = false;
> >                         break;
> >
> > +               case OPT_METACOPY_ON:
> > +                       config->metacopy = true;
> > +                       break;
> > +
> > +               case OPT_METACOPY_OFF:
> > +                       config->metacopy = false;
> > +                       break;
> > +
> >                 default:
> >                         pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
> >                         return -EINVAL;
> > @@ -644,9 +664,16 @@ static int ovl_lower_dir(const char *name, struct path *path,
> >          * The inodes index feature needs to encode and decode file
> >          * handles, so it requires that all layers support them.
> >          */
> > -       if (ofs->config.index && !ovl_can_decode_fh(path->dentry->d_sb)) {
> > +       if ((ofs->config.index || ofs->config.metacopy) &&
> > +            !ovl_can_decode_fh(path->dentry->d_sb)) {
> > +               if (ofs->config.index)
> > +                       pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
> > +
> > +               if (ofs->config.metacopy)
> > +                       pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to metacopy=off.\n", name);
> > +
> 
> In my verify_dir patches I used the following more compact warning
> style instead of granular warnings:
> 
>     pr_warn("overlayfs: fs on '%s' does not support file handles,
> falling back to index=off,metacopy=off.\n", name);
> 
> It is a bit less informative, but IMO the result in nicer to look at,
> both in the code and in dmesg.
> Others may have a different opinion. Please consider.
> For example, see how the following warning from my verify_dir patches
> has expanded and imagine how
> much more messier it would be if we broke it into separate warnings:
> 
>     pr_warn("overlayfs: upper fs does not support xattr, falling back
> to redirect_dir=off, index=off, no verify_dir and no opaque dir.\n");
> 
> 
> >                 ofs->config.index = false;
> > -               pr_warn("overlayfs: fs on '%s' does not support file handles, falling back to index=off.\n", name);
> > +               ofs->config.metacopy = false;
> >         }
> >
> >         return 0;
> > @@ -847,6 +874,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >
> >         ufs->config.redirect_dir = ovl_redirect_dir_def;
> >         ufs->config.index = ovl_index_def;
> > +       ufs->config.metacopy = ovl_metacopy_def;
> > +
> >         err = ovl_parse_opt((char *) data, &ufs->config);
> >         if (err)
> >                 goto out_free_config;
> > @@ -1057,7 +1086,8 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >         else if (ufs->upper_mnt->mnt_sb != ufs->same_sb)
> >                 ufs->same_sb = NULL;
> >
> > -       if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
> > +       if (!(ovl_force_readonly(ufs)) &&
> > +             (ufs->config.index || ufs->config.metacopy)) {
> >                 /* Verify lower root is upper root origin */
> >                 err = ovl_verify_origin(upperpath.dentry, ufs->lower_mnt[0],
> >                                         stack[0].dentry, false, true);
> > @@ -1065,7 +1095,9 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >                         pr_err("overlayfs: failed to verify upper root origin\n");
> >                         goto out_put_lower_mnt;
> >                 }
> > +       }
> >
> > +       if (!(ovl_force_readonly(ufs)) && ufs->config.index) {
> >                 ufs->indexdir = ovl_workdir_create(sb, ufs, workpath.dentry,
> >                                                    OVL_INDEXDIR_NAME, true);
> >                 if (ufs->indexdir) {
> > --
> > 2.13.5
> >
