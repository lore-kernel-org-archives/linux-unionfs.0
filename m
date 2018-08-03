Return-Path: <linux-unionfs-owner@vger.kernel.org>
Received: from szxga04-in.huawei.com ([45.249.212.190]:10627 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727299AbeHCNVn (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 3 Aug 2018 09:21:43 -0400
Subject: Re: [RFC PATCH v2 8/9] ovl: force mount underlying layers which have
 feature sets
References: <20180731093727.26855-1-yi.zhang@huawei.com>
 <20180731093727.26855-9-yi.zhang@huawei.com>
 <CAOQ4uxgZcwxENyf5STfNgL6juLoHvOBnWkORpifp0pv04oi8Ww@mail.gmail.com>
From: "zhangyi (F)" <yi.zhang@huawei.com>
Message-ID: <0b7e233d-2557-5391-3331-186e97ee2120@huawei.com>
Date: Fri, 3 Aug 2018 19:25:37 +0800
MIME-Version: 1.0
In-Reply-To: <CAOQ4uxgZcwxENyf5STfNgL6juLoHvOBnWkORpifp0pv04oi8Ww@mail.gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: linux-unionfs-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

Hi Amir and Vivek, thanks for your comments for all patches in this patche set.

On 2018/8/3 6:20, Amir Goldstein Wrote:
> Zhangyi,
> 
> I am not able to provide detailed review right now, but I agree with vivek that we should start with a write up of problem and solution before presenting the implementation.
> Perhaps a patch to Documentation/filesystems/overlayfs.txt
> About v2 ondisk format.
> 

Yes, I will supplement description about the problem and solution to
Documentation/filesystems/overlayfs.txt and patch [0/n] in next iteration.

> In a gist, I believe the rules should be:
> Kconfig/module/mount options determine if kernel is allowed to mount lower/upper v1.

Yes.

> We will probably need to allow kernel to initiate v2 on an empty upper, so mkfs.overlay is not a requirement for mounting v2 upper.

I think it is only for the case of mounting with OVERLAY_FS_V1 option firstly.
If we want to mount with OVERLAY_FS_UPPER_V2 directly, we still need mkfs.overlay
because kernel will refuse to mount directly if the upper layer is v1.

> In any case, new kernel is never allowed to ignore existing v2 features on layers regardless of config/module/mount options.
> 

Yes.


Now, I think it's better to show the background and summarize all the 5 introductions,
9 situations and the corresponding process logic, please give a quick look and comment
if something is not fine.

0. Background:
Current overlayfs cannot detect unknown incompatible features. It is dangerous if we
mount an overlay image which contains such features on the old kernel and then mount on
the new kernel again, because the old kernel may corrupt the incompatible feature objects.
At the same time, the fsck.overlay program also cannot detect unknown features, it is
dangerous too if we use old fsck.overlay to check and repair the overlayfs which contains
unkown features.

Now, we know two incompatible features (redirect dir and metadata copyup) and two read-only
compatible features (index and nfs_export), and there may be more incompatible features
in the future. So, in order to do compatibility checking accurately, we it's better to
introduce feature set as many other disk filesystems. But the overlayfs doesn't has
superblock, so we plan to save feature bitset as "trusted.overlay.feature" xattr valued
a feature structure, which use _be64 to present each layer's feature set.

BTW, In order to let the feature set xattr backward compatible, we cannot require the
feature set directly, so we refer the old layer on-disk format v1 and new layer contains
fature set xattr on-disk format v2, and introduce two Kconfig options and the counterpart
module & mount options to handle this, see below for detail.

1. Introductions:
1) Two on-disk formats.
- Format v1: the layer of overlayfs which doesn't has feature set xattr,
- Format v2: the layer of overlayfs which has feature set xattr.

Note both on-disk format v1 & v2 indicate the layer's format, not the whole overlay image.

2) Three options indicated by Kconfig/module/mount options.
- OVERLAY_FS_V1: all layers can be either on-disk format v1 or v2.
- OVERLAY_FS_UPPER_V2: the upper layer should be v2 and the lower layers can be either v1 or v2.
- OVERLAY_FS_V2: all layers should be on-disk format v2.


2. Situations: ("-" means this layer doesn't has feature xattr, "+" means has feature xattr)

                   lowers(-),upper(-）  lowers(-),upper (+)   lowers(+),upper(+)
OVERLAYFS_V1               (1)                 (2)                   (3)
OVERLAYFS_UPPER_V2         (4)                 (5)                   (6)
OVERLAYFS_V2               (7)                 (8)                   (9)

(1) Allow to mount, do all things as current kernel, besides initiate feature set
    xattr when redirect dir xattr was set, index dir exists, nfs_export enabled and
    metadata xattr was set or redirect xattr was set to file. But I think create an
    empty feature xattr (or only have compatible "feature set" feature bit) is not
    necessary(*).
(2) The same as (1) above, but also check features bitset in the upper is compatible
    for mounting operation, will refuse to mount if not.
(3) The same as (2) above, but also check feature bitset in lower layers.
(4) Refuse to mount, mkfs.overlay is required for the new underlying layers and
    fsck.overlay is required for the layers which had already been mounted, to initiate
    feature set xattr. fsck.overlay can also use to set feature xattr for the new
    underlying layers, but mkfs.overlay is recommend because it can aviod unnecessary
    consistency check.
(5) Allow to mount, and will check feature bitset in the upper layer and add feature
    bit as (1) does.
(6) The same as (5) above, and also check feature bitset in lower layers.
(7) Refuse to mount, need mkfs.overlay and fsck.overlay to initiate feature set xattr
    for all layers, if lower layer is real read-only and cannot change to format v2,
    suggest to mount with OVERLAY_FS_UPPER_V2.
(8) Refuse to mount too, the same as (7) does.
(9) Allow to mount, the same as (6) does.

Do you think these implementations is OK, any suggestions?

(*) Two reasons: 1) an "empty" feature xattr is useless for compatibility checking when
    OVERLAY_FS_V1, 2) user need to run fsck.overlay before change to OVERLAY_FS_*_v2
    form OVERLAY_FS_V1 becasue the feature set xattr created by OVERLAYFS_V1 may be
    inconsistent, fsck will create an consistent feature set xattr. So I think doesn't
    need to create an "empty" feature xattr.

Thanks,
Yi.

> Thanks,
> Amir.
> 
> On Tue, Jul 31, 2018, 11:25 AM zhangyi (F) <yi.zhang@huawei.com <mailto:yi.zhang@huawei.com>> wrote:
> 
>     Now, overlay try its best to add feature bitset to the upper layer's
>     root directory, but it still cannot guarantee the feature set are
>     consistent for compatibility check.
> 
>      - Some features in the feature set xattr or the whole xattr may be
>        missing if some features have already been set by the old kernel.
>      - Although we don't set lower layer's feature set xattr directly
>        (it inherit from previous mount when it was upper layer), but the
>        whole feature set xattr may be lost or corrupt when user change the
>        underlying layers.
> 
>     So, feature set xattr are optionally for overlayfs now, but we should
>     be able to ensure the consistency of feature set for backward
>     compatibility check accurately.
> 
>     After we introduce mkfs.overlay and fsck.overlay tools, we can use
>     these tools to add, check and fix feature set xattr. So it's time to
>     add options to enforce kernel to mount overlayfs with the base on the
>     layers that must have feature set xattr, even if it is empty.
> 
>     After this patch, we refer the underlying layer which have feature set
>     xattr as on-disk format v2, and the layer that don't have as on-disk
>     format v1. We introduce two Kconfig options: OVERLAY_FS_V2 and
>     OVERLAY_FS_UPPER_V2, and the counterpart module and mount options
>     "overlayfs_v2=<off/on/upper>".
> 
>     If "OVERLAY_FS_V2=n" or "-o overlayfs_v2=off", feature set xattr is not
>     required, the underlying layers can be either on-disk format v1 or v2.
>     If "OVERLAY_FS_V2=y" or "-o overlayfs_v2=on", all underlying layers of
>     overlayfs must be on-disk format v2, kernel will refuse to mount if
>     not. If "OVELRAY_FS_UPPER_V2=y" or "-o overlayfs=upper", relax the
>     requirement for declaring lower layers feature set, only the upper
>     layer have feature set is enough (this is useful for the case of lower
>     layer is read-only).
> 
>     Note that the feature set xattr create by old kernel before this patch
>     or if "OVERLAY_FS_V2=n" may inconsistent, fsck.overlay is required
>     before mount with "OVERLAY_FS_V2=y" or "OVERLAY_FS_UPPER_V2=y" next
>     time.
> 
>     Signed-off-by: zhangyi (F) <yi.zhang@huawei.com <mailto:yi.zhang@huawei.com>>
>     Suggested-by: Amir Goldstein <amir73il@gmail.com <mailto:amir73il@gmail.com>>
>     ---
>      fs/overlayfs/Kconfig     | 40 ++++++++++++++++++++++++++++++++++++++++
>      fs/overlayfs/feature.c   | 20 +++++++++++++++++++-
>      fs/overlayfs/ovl_entry.h |  7 +++++++
>      fs/overlayfs/super.c     | 43 +++++++++++++++++++++++++++++++++++++++++++
>      4 files changed, 109 insertions(+), 1 deletion(-)
> 
>     diff --git a/fs/overlayfs/Kconfig b/fs/overlayfs/Kconfig
>     index 9384164253ac..1d7f7bfa5165 100644
>     --- a/fs/overlayfs/Kconfig
>     +++ b/fs/overlayfs/Kconfig
>     @@ -103,3 +103,43 @@ config OVERLAY_FS_XINO_AUTO
>               For more information, see Documentation/filesystems/overlayfs.txt
> 
>               If unsure, say N.
>     +
>     +config OVERLAY_FS_V2
>     +       bool "Overlayfs: overlayfs v2 (force all layers have feature sets)"
>     +       default n
>     +       depends on OVERLAY_FS
>     +       help
>     +         If this config option is enabled then overlay feature sets are
>     +         necessary for each underlying layer, which is created by mkfs.overlay
>     +         or fsck.overlay. In this case it is still possible to turn off with
>     +         the "overlayfs_v2=off" module option or on a filesystem instance
>     +         basis with the "overlayfs_v2=off" mount option.
>     +
>     +         Note, kernel will refuse to mount overlayfs without feature set in
>     +         any one of the underlying layers, so must run mkfs.overlay before
>     +         the first mount or run fsck.overlay to tune overlayfs image form v1
>     +         to v2 (init feature sets).
>     +
>     +         For more information, see Documentation/filesystems/overlayfs.txt
>     +
>     +         If unsure or don't have the mkfs.overlay and mkfs.overlay tools,
>     +         say N.
>     +
>     +config OVERLAY_FS_UPPER_V2
>     +       bool "Overlayfs: upper v2 only (release requirement of the lower layers)"
>     +       default n
>     +       depends on OVERLAY_FS_V2
>     +       help
>     +         If this config option is enabled then overlay feature sets are
>     +         necessary for the upper layer only, feature sets are optional for
>     +         each lower layer. This option is useful for read-only lower layer
>     +         which cannot init feature set by mkfs.overlay and fsck.overlay.
>     +
>     +         Note, the lower layers may contain unmarked incompatible features,
>     +         mounting an overlay with these lower layers on a kernel that doesn't
>     +         support these features will have unexpected results.
>     +
>     +         For more information, see Documentation/filesystems/overlayfs.txt
>     +
>     +         If unsure or don't have the mkfs.overlay and mkfs.overlay tools,
>     +         say N.
>     diff --git a/fs/overlayfs/feature.c b/fs/overlayfs/feature.c
>     index 7c66e71bdd98..fffa79ee9b15 100644
>     --- a/fs/overlayfs/feature.c
>     +++ b/fs/overlayfs/feature.c
>     @@ -117,6 +117,10 @@ int ovl_set_upper_feature(struct ovl_fs *ofs,
>             if (!upper_layer)
>                     return -EINVAL;
> 
>     +       if (WARN_ON_ONCE((ofs->config.format != OVL_FS_V1) &&
>     +                        !(upper_layer->feature)))
>     +               return -ESTALE;
>     +
>             switch (type) {
>             case OVL_FEATURE_COMPAT:
>                     features = &upper_layer->compat;
>     @@ -148,7 +152,9 @@ int ovl_set_upper_feature(struct ovl_fs *ofs,
>      }
> 
>      /*
>     - * Get features from each underlying root dir.
>     + * Get features from each underlying root dir. Feature set is not
>     + * necessary for v1 underlying layers, but is necessary for v2
>     + * underlying layers.
>       *
>       * @ofs: overlay filesystem information
>       * @oe: overlay lower stack
>     @@ -175,6 +181,12 @@ int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
>                             upper_layer->feature = true;
>                             kfree(odf);
>                     } else {
>     +                       /* Force upper on-disk format v2 */
>     +                       if (ofs->config.format != OVL_FS_V1) {
>     +                               pr_warn("overlayfs: upper layer feature set missing, "
>     +                                       "running fsck.overlay is recommended\n");
>     +                               return -ESTALE;
>     +                       }
>                             upper_layer->feature = false;
>                     }
>             }
>     @@ -189,6 +201,12 @@ int ovl_init_feature_set(struct ovl_fs *ofs, struct ovl_entry *oe)
>                             return PTR_ERR(odf);
> 
>                     if (!odf) {
>     +                       /* Force lower on-disk format v2 */
>     +                       if (ofs->config.format == OVL_FS_V2) {
>     +                               pr_warn("overlayfs: lower layer %i feature set missing, "
>     +                                       "running fsck.overlay is recommended\n", i);
>     +                               return -ESTALE;
>     +                       }
>                             lower_layer->feature = false;
>                             continue;
>                     }
>     diff --git a/fs/overlayfs/ovl_entry.h b/fs/overlayfs/ovl_entry.h
>     index 8a28e24dd149..19885be7705c 100644
>     --- a/fs/overlayfs/ovl_entry.h
>     +++ b/fs/overlayfs/ovl_entry.h
>     @@ -8,6 +8,12 @@
>       * the Free Software Foundation.
>       */
> 
>     +enum ovl_format {
>     +       OVL_FS_V1,
>     +       OVL_FS_UPPER_V2,
>     +       OVL_FS_V2,
>     +};
>     +
>      struct ovl_config {
>             char *lowerdir;
>             char *upperdir;
>     @@ -19,6 +25,7 @@ struct ovl_config {
>             bool index;
>             bool nfs_export;
>             int xino;
>     +       enum ovl_format format;
>      };
> 
>      struct ovl_sb {
>     diff --git a/fs/overlayfs/super.c b/fs/overlayfs/super.c
>     index 860a533ae5a9..1e81d2c6766a 100644
>     --- a/fs/overlayfs/super.c
>     +++ b/fs/overlayfs/super.c
>     @@ -56,6 +56,16 @@ module_param_named(xino_auto, ovl_xino_auto_def, bool, 0644);
>      MODULE_PARM_DESC(ovl_xino_auto_def,
>                      "Auto enable xino feature");
> 
>     +static bool ovl_ovlfs_v2_def = IS_ENABLED(CONFIG_OVERLAY_FS_V2);
>     +module_param_named(ovl_ovlfs_v2, ovl_ovlfs_v2_def, bool, 0644);
>     +MODULE_PARM_DESC(ovl_ovlfs_v2_def,
>     +                "Default to on or off to force mount overlay v2 layers");
>     +
>     +static bool ovl_ovlfs_upper_v2_def = IS_ENABLED(CONFIG_OVERLAY_FS_UPPER_V2);
>     +module_param_named(ovl_ovlfs_upper_v2, ovl_ovlfs_upper_v2_def, bool, 0644);
>     +MODULE_PARM_DESC(ovl_ovlfs_upper_v2_def,
>     +                "Force mount overlay v2 upper layer only");
>     +
>      static void ovl_entry_stack_free(struct ovl_entry *oe)
>      {
>             unsigned int i;
>     @@ -351,6 +361,18 @@ static inline int ovl_xino_def(void)
>             return ovl_xino_auto_def ? OVL_XINO_AUTO : OVL_XINO_OFF;
>      }
> 
>     +static const char * const ovl_format_str[] = {
>     +       "off",          /* OVL_FS_V1 */
>     +       "upper",        /* OVL_FS_UPPER_V2 */
>     +       "on",           /* OVL_FS_V2 */
>     +};
>     +
>     +static inline int ovl_format_def(void)
>     +{
>     +       return !ovl_ovlfs_v2_def ? OVL_FS_V1 :
>     +               (ovl_ovlfs_upper_v2_def ? OVL_FS_UPPER_V2 : OVL_FS_V2);
>     +}
>     +
>      /**
>       * ovl_show_options
>       *
>     @@ -378,6 +400,8 @@ static int ovl_show_options(struct seq_file *m, struct dentry *dentry)
>                                                     "on" : "off");
>             if (ofs->config.xino != ovl_xino_def())
>                     seq_printf(m, ",xino=%s", ovl_xino_str[ofs->config.xino]);
>     +       if (ofs->config.format != ovl_format_def())
>     +               seq_printf(m, ",overlayfs_v2=%s", ovl_format_str[ofs->config.format]);
>             return 0;
>      }
> 
>     @@ -416,6 +440,9 @@ enum {
>             OPT_XINO_ON,
>             OPT_XINO_OFF,
>             OPT_XINO_AUTO,
>     +       OPT_OVERLAYFS_V2_ON,
>     +       OPT_OVERLAYFS_V2_UPPER,
>     +       OPT_OVERLAYFS_V2_OFF,
>             OPT_ERR,
>      };
> 
>     @@ -432,6 +459,9 @@ static const match_table_t ovl_tokens = {
>             {OPT_XINO_ON,                   "xino=on"},
>             {OPT_XINO_OFF,                  "xino=off"},
>             {OPT_XINO_AUTO,                 "xino=auto"},
>     +       {OPT_OVERLAYFS_V2_ON,           "overlayfs_v2=on"},
>     +       {OPT_OVERLAYFS_V2_UPPER,        "overlayfs_v2=upper"},
>     +       {OPT_OVERLAYFS_V2_OFF,          "overlayfs_v2=off"},
>             {OPT_ERR,                       NULL}
>      };
> 
>     @@ -558,6 +588,18 @@ static int ovl_parse_opt(char *opt, struct ovl_config *config)
>                             config->xino = OVL_XINO_AUTO;
>                             break;
> 
>     +               case OPT_OVERLAYFS_V2_ON:
>     +                       config->format = OVL_FS_V2;
>     +                       break;
>     +
>     +               case OPT_OVERLAYFS_V2_UPPER:
>     +                       config->format = OVL_FS_UPPER_V2;
>     +                       break;
>     +
>     +               case OPT_OVERLAYFS_V2_OFF:
>     +                       config->format = OVL_FS_V1;
>     +                       break;
>     +
>                     default:
>                             pr_err("overlayfs: unrecognized mount option \"%s\" or missing value\n", p);
>                             return -EINVAL;
>     @@ -1386,6 +1428,7 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>             ofs->config.index = ovl_index_def;
>             ofs->config.nfs_export = ovl_nfs_export_def;
>             ofs->config.xino = ovl_xino_def();
>     +       ofs->config.format = ovl_format_def();
>             err = ovl_parse_opt((char *) data, &ofs->config);
>             if (err)
>                     goto out_err;
>     -- 
>     2.13.6
> 

