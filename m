Return-Path: <vgoyal@redhat.com>
Date: Wed, 7 Mar 2018 10:43:28 -0500
From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [PATCH v12 02/17] ovl: Provide a mount option metacopy=on/off
 for metadata copyup
Message-ID: <20180307154328.GG5350@redhat.com>
References: <20180306205408.23383-1-vgoyal@redhat.com>
 <20180306205408.23383-3-vgoyal@redhat.com>
 <CAOQ4uxhCnS+T+8GX5RWHLLF5xUMc+v7uwpiMXnbCq+7Ez85cvQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhCnS+T+8GX5RWHLLF5xUMc+v7uwpiMXnbCq+7Ez85cvQ@mail.gmail.com>
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Mar 07, 2018 at 10:47:13AM +0200, Amir Goldstein wrote:
> On Tue, Mar 6, 2018 at 10:53 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> > By default metadata only copy up is disabled. Provide a mount option so
> > that users can choose one way or other.
> >
> > Also provide a kernel config and module option to enable/disable
> > metacopy feature.
> >
> > metacopy feature requires redirect_dir=on when upper is present. Otherwise,
> > it requires redirect_dir=follow atleast.
> >
> > Like index feature, we verify on mount that upper root is not being
> > reused with a different lower root. This hopes to get the configuration
> > right and detect the copied layers use case. But this does only so
> > much as we don't verify all the lowers. So it is possible that a lower is
> > missing and later data copy up fails.
> >
> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
> > Signed-off-by: Vivek Goyal <vgoyal@redhat.com>
> > ---
> >  Documentation/filesystems/overlayfs.txt | 30 ++++++++++++++++++++++++-
> >  fs/overlayfs/Kconfig                    | 17 ++++++++++++++
> >  fs/overlayfs/ovl_entry.h                |  1 +
> >  fs/overlayfs/super.c                    | 40 ++++++++++++++++++++++++++++++++-
> >  4 files changed, 86 insertions(+), 2 deletions(-)
> >
> > diff --git a/Documentation/filesystems/overlayfs.txt b/Documentation/filesystems/overlayfs.txt
> > index 6ea1e64d1464..b7720e61973c 100644
> > --- a/Documentation/filesystems/overlayfs.txt
> > +++ b/Documentation/filesystems/overlayfs.txt
> > @@ -249,6 +249,30 @@ rightmost one and going left.  In the above example lower1 will be the
> >  top, lower2 the middle and lower3 the bottom layer.
> >
> >
> > +Metadata only copyup
> > +--------------------
> > +
> > +When metadata only copy up feature is enabled, overlayfs will only copy
> > +up metadata (as opposed to whole file), when a metadata specific operation
> > +like chown/chmod is performed. Full file will be copied up later when
> > +file is opened for WRITE operation.
> > +
> > +IOW, this is delayed data copy up operation and data is copied up when
> > +there is a need to actually modify data.
> > +
> > +There are multiple ways to enable/disable this feature. A config option
> > +CONFIG_OVERLAY_FS_METACOPY can be set/unset to enable/disable this feature
> > +by default. Or one can enable/disable it at module load time with module
> > +parameter metacopy=on/off. Lastly, there is also a per mount option
> > +metacopy=on/off to enable/disable this feature per mount.
> > +
> > +Do not use metacopy=on with untrusted upper/lower directories. Otherwise
> > +it is possible that an attacker can create an handcrafted file with
> > +appropriate REDIRECT and METACOPY xattrs, and gain access to file on lower
> > +pointed by REDIRECT. This should not be possible on local system as setting
> > +"trusted." xattrs will require CAP_SYS_ADMIN. But it should be possible
> > +for untrusted layers like from a pen drive.
> > +
> >  Sharing and copying layers
> >  --------------------------
> >
> > @@ -267,7 +291,7 @@ though it will not result in a crash or deadlock.
> >  Mounting an overlay using an upper layer path, where the upper layer path
> >  was previously used by another mounted overlay in combination with a
> >  different lower layer path, is allowed, unless the "inodes index" feature
> > -is enabled.
> > +or "metadata only copyup" feature is enabled.
> >
> >  With the "inodes index" feature, on the first time mount, an NFS file
> >  handle of the lower layer root directory, along with the UUID of the lower
> > @@ -280,6 +304,10 @@ lower root origin, mount will fail with ESTALE.  An overlayfs mount with
> >  does not support NFS export, lower filesystem does not have a valid UUID or
> >  if the upper filesystem does not support extended attributes.
> >
> > +For "metadata only copyup" feature there is no verification mechanism at
> > +mount time. So if same upper is mouted with different set of lower, mount
> > +probably will succeed but expect the unexpected later on. So don't do it.
> > +
> >  It is quite a common practice to copy overlay layers to a different
> >  directory tree on the same or different underlying filesystem, and even
> >  to a different machine.  With the "inodes index" feature, trying to mount
> > diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
> > index 406e72de88f6..e1974db486a9 100644
> > --- a/fs/overlayfs/Kconfig
> > +++ b/fs/overlayfs/Kconfig
> > @@ -72,3 +72,20 @@ config OVERLAY_FS_NFS_EXPORT
> >           Note, that the NFS export feature is not backward compatible.
> >           That is, mounting an overlay which has a full index on a kernel
> >           that doesn't support this feature will have unexpected results.
> > +
> > +config OVERLAY_FS_METACOPY
> > +       bool "Overlayfs: turn on metadata only copy up feature by default"
> > +       depends on OVERLAY_FS
> > +       depends on !OVERLAY_FS_NFS_EXPORT
> > +       select OVERLAY_FS_REDIRECT_DIR
> > +       help
> > +         If this config option is enabled then overlay filesystems will
> > +         copy up only metadata where appropriate and data copy up will
> > +         happen when a file is opended for WRITE operation. It is still
> > +         possible to turn off this feature globally with the "metacopy=off"
> > +         module option or on a filesystem instance basis with the
> > +         "metacopy=off" mount option.
> > +
> > +         Note, that this feature is not backward compatible.  That is,
> > +         mounting an overlay which has metacopy only inodes on a kernel
> > +         that doesn't support this feature will have unexpected results.
> > diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
> > index bfef6edcc111..7dc55628080d 100644
> > --- a/fs/overlayfs/ovl_entry.h
> > +++ b/fs/overlayfs/ovl_entry.h
> > @@ -18,6 +18,7 @@ struct ovl_config {
> >         const char *redirect_mode;
> >         bool index;
> >         bool nfs_export;
> > +       bool metacopy;
> >  };
> >
> >  struct ovl_layer {
> > diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
> > index 9ee37c76091d..0e124b9d902d 100644
> > --- a/fs/overlayfs/super.c
> > +++ b/fs/overlayfs/super.c
> > @@ -58,6 +58,11 @@ static void ovl_entry_stack_free(struct ovl_entry *oe)
> >                 dput(oe->lowerstack[i].dentry);
> >  }
> >
> > +static bool ovl_metacopy_def = IS_ENABLED(CONFIG_OVERLAY_FS_METACOPY);
> > +module_param_named(metacopy, ovl_metacopy_def, bool, 0644);
> > +MODULE_PARM_DESC(ovl_metacopy_def,
> > +                "Default to on or off for the metadata only copy up feature");
> > +
> >  static void ovl_dentry_release(struct dentry *dentry)
> >  {
> >         struct ovl_entry *oe = dentry->d_fsdata;
> > @@ -350,6 +355,9 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
> >         if (ofs->config.nfs_export != ovl_nfs_export_def)
> >                 seq_printf(m, ",nfs_export=%s", ofs->config.nfs_export ?
> >                                                 "on" : "off");
> > +       if (ofs->config.metacopy != ovl_metacopy_def)
> > +               seq_printf(m, ",metacopy=%s",
> > +                          ofs->config.metacopy ? "on" : "off");
> >         return 0;
> >  }
> >
> > @@ -384,6 +392,8 @@ enum {
> >         OPT_INDEX_OFF,
> >         OPT_NFS_EXPORT_ON,
> >         OPT_NFS_EXPORT_OFF,
> > +       OPT_METACOPY_ON,
> > +       OPT_METACOPY_OFF,
> >         OPT_ERR,
> >  };
> >
> > @@ -397,6 +407,8 @@ static const match_table_t ovl_tokens = {
> >         {OPT_INDEX_OFF,                 "index=off"},
> >         {OPT_NFS_EXPORT_ON,             "nfs_export=on"},
> >         {OPT_NFS_EXPORT_OFF,            "nfs_export=off"},
> > +       {OPT_METACOPY_ON,               "metacopy=on"},
> > +       {OPT_METACOPY_OFF,              "metacopy=off"},
> >         {OPT_ERR,                       NULL}
> >  };
> >
> > @@ -511,6 +523,14 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
> >                         config->nfs_export = false;
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
> > @@ -993,7 +1013,8 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
> >         if (err) {
> >                 ofs->noxattr = true;
> >                 ofs->config.index = false;
> > -               pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off.\n");
> > +               ofs->config.metacopy = false;
> > +               pr_warn("overlayfs: upper fs does not support xattr, falling back to index=off and metacopy=off.\n");
> >                 err = 0;
> >         } else {
> >                 vfs_removexattr(ofs->workdir, OVL_XATTR_OPAQUE);
> > @@ -1012,6 +1033,11 @@ static int ovl_make_workdir(struct ovl_fs *ofs, struct path *workpath)
> >                 ofs->config.nfs_export = false;
> >         }
> >
> > +       /* metacopy feature with upper requires redirect_dir=on */
> > +       if (ofs->config.metacopy && !ofs->config.redirect_dir) {
> > +               pr_warn("overlayfs: metadata only copyup requires \"redirect_dir=on\", falling back to metacopy=off.\n");
> > +               ofs->config.metacopy = false;
> > +       }
> >  out:
> >         mnt_drop_write(mnt);
> >         return err;
> > @@ -1188,6 +1214,12 @@ static struct ovl_entry *ovl_get_lowerstack(struct super_block *sb,
> >                 ofs->config.nfs_export = false;
> >         }
> >
> > +       if (!ofs->config.upperdir && ofs->config.metacopy &&
> > +           !ofs->config.redirect_follow) {
> > +               ofs->config.metacopy = false;
> > +               pr_warn("overlayfs: metadata only copyup requires \"redirect_dir=follow\" on non-upper mount, falling back to metacopy=off.\n");
> > +       }
> > +
> >         err = -ENOMEM;
> >         stack = kcalloc(stacklen, sizeof(struct path), GFP_KERNEL);
> >         if (!stack)
> > @@ -1263,6 +1295,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >
> >         ofs->config.index = ovl_index_def;
> >         ofs->config.nfs_export = ovl_nfs_export_def;
> > +       ofs->config.metacopy = ovl_metacopy_def;
> >         err = ovl_parse_opt((char *) data, &ofs->config);
> >         if (err)
> >                 goto out_err;
> > @@ -1331,6 +1364,11 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
> >                 }
> >         }
> >
> > +       if (ofs->config.metacopy && ofs->config.nfs_export) {
> > +               pr_warn("overlayfs: Metadata copy up requires NFS export disabled, falling back to metacopy=off.\n");
> > +               ofs->config.metacopy = false;
> > +       }
> > +
> 
> Is should probably be the other way around - metacopy should prevail
> and we should fall back to nfs_export=off (just like non-upper mount
> with redirect_follow)
> it's rather user can access file data then export to NFS.
> 
> If user prefers to risk not being able to access file data in favor of
> NFS export, then
> user should opt-in with metacopy=off, just like user needs to opt-in
> to redirect_dir=nofollow
> in order to NFS export a non-upper overlayfs.

Ok, makes sense. I will change it. Fall back to nfs_export=off.

Vivek
