From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests PATCH v3 6/6] overlay: correct test mount options
Date: Tue, 13 Feb 2018 17:48:42 +0800
Message-ID: <20180213094842.GJ18267@eguan.usersys.redhat.com>
References: <20180213070832.43159-1-yi.zhang@huawei.com>
 <20180213070832.43159-7-yi.zhang@huawei.com>
 <CAOQ4uxg6kvt30dg0G=A-qwVH1QJUV4_fefkDQmXEK-dC4bfdHQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxg6kvt30dg0G=A-qwVH1QJUV4_fefkDQmXEK-dC4bfdHQ@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: "zhangyi (F)" <yi.zhang@huawei.com>, fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, Miao Xie <miaoxie@huawei.com>, yangerkun <yangerkun@huawei.com>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Feb 13, 2018 at 11:26:30AM +0200, Amir Goldstein wrote:
> On Tue, Feb 13, 2018 at 9:08 AM, zhangyi (F) <yi.zhang@huawei.com> wrote:
> > Current overlay's _test_mount functions mount base test filesystem
> > with TEST_FS_MOUNT_OPTS and mount test overlayfs with MOUNT_OPTIONS
> > instead of TEST_FS_MOUNT_OPTS. The TEST_FS_MOUNT_OPTS variable
> > should be used for test overlayfs like MOUNT_OPTIONS use for scratch
> > overlayfs.
> >
> > This patch rename OVL_BASE_MOUNT_OPTIONS to
> > OVL_BASE_SCRATCH_MOUNT_OPTIONS and introduce an counterpart variable
> > OVL_BASE_TEST_MOUNT_OPTIONS for test base filesystem, and then use
> > TEST_FS_MOUNT_OPTS for test overlayfs. We also modify overlay mount
> > helpers to adapt mount options.
> >
> > Signed-off-by: zhangyi (F) <yi.zhang@huawei.com>
> > ---
> >  common/config     | 17 +++++++++++++----
> >  common/overlay    | 31 +++++++++++++++++++++++--------
> >  tests/overlay/022 |  2 +-
> >  tests/overlay/025 |  2 +-
> >  tests/overlay/029 |  6 +++---
> >  tests/overlay/036 | 20 ++++++++++----------
> >  6 files changed, 51 insertions(+), 27 deletions(-)
> >
> > diff --git a/common/config b/common/config
> > index 20f0e5f..fd04a16 100644
> > --- a/common/config
> > +++ b/common/config
> > @@ -346,6 +346,9 @@ _test_mount_opts()
> >         glusterfs)
> >                 export TEST_FS_MOUNT_OPTS=$GLUSTERFS_MOUNT_OPTIONS
> >                 ;;
> > +       overlay)
> > +               export TEST_FS_MOUNT_OPTS=$OVERLAY_MOUNT_OPTIONS
> > +               ;;
> >         ext2|ext3|ext4|ext4dev)
> >                 # acls & xattrs aren't turned on by default on older ext$FOO
> >                 export TEST_FS_MOUNT_OPTS="-o acl,user_xattr $EXT_MOUNT_OPTIONS"
> > @@ -546,16 +549,19 @@ _overlay_config_override()
> >         # Store original base fs vars
> >         export OVL_BASE_TEST_DEV="$TEST_DEV"
> >         export OVL_BASE_TEST_DIR="$TEST_DIR"
> > -       # If config does not set MOUNT_OPTIONS, its value may be
> > -       # leftover from previous _overlay_config_override, so
> > +       # If config does not set MOUNT_OPTIONS and TEST_FS_MOUNT_OPTS, its
> > +       # value may be leftover from previous _overlay_config_override, so
> >         # don't use that value for base fs mount
> >         [ "$MOUNT_OPTIONS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset MOUNT_OPTIONS
> > -       export OVL_BASE_MOUNT_OPTIONS="$MOUNT_OPTIONS"
> > +       export OVL_BASE_SCRATCH_MOUNT_OPTIONS="$MOUNT_OPTIONS"
> > +       [ "$TEST_FS_MOUNT_OPTS" != "$OVERLAY_MOUNT_OPTIONS" ] || unset TEST_FS_MOUNT_OPTS
> > +       export OVL_BASE_TEST_MOUNT_OPTIONS="$TEST_FS_MOUNT_OPTS"
> >
> >         # Set TEST vars to overlay base and mount dirs inside base fs
> >         export TEST_DEV="$OVL_BASE_TEST_DIR"
> >         export TEST_DIR="$OVL_BASE_TEST_DIR/$OVL_MNT"
> >         export MOUNT_OPTIONS="$OVERLAY_MOUNT_OPTIONS"
> > +       export TEST_FS_MOUNT_OPTS="$OVERLAY_MOUNT_OPTIONS"
> >
> >         [ -b "$SCRATCH_DEV" ] || return 0
> >
> > @@ -580,7 +586,10 @@ _overlay_config_restore()
> >         [ -z "$OVL_BASE_TEST_DIR" ] || export TEST_DIR=$OVL_BASE_TEST_DIR
> >         [ -z "$OVL_BASE_SCRATCH_DEV" ] || export SCRATCH_DEV=$OVL_BASE_SCRATCH_DEV
> >         [ -z "$OVL_BASE_SCRATCH_MNT" ] || export SCRATCH_MNT=$OVL_BASE_SCRATCH_MNT
> > -       [ -z "$OVL_BASE_MOUNT_OPTIONS" ] || export MOUNT_OPTIONS=$OVL_BASE_MOUNT_OPTIONS
> > +       [ -z "$OVL_BASE_SCRATCH_MOUNT_OPTIONS" ] || \
> > +               export MOUNT_OPTIONS=$OVL_BASE_SCRATCH_MOUNT_OPTIONS
> > +       [ -z "$OVL_BASE_TEST_MOUNT_OPTIONS" ] || \
> > +               export TEST_FS_MOUNT_OPTS=$OVL_BASE_TEST_MOUNT_OPTIONS
> >  }
> >
> >  # Parse config section options. This function will parse all the configuration
> > diff --git a/common/overlay b/common/overlay
> > index 29f9bf8..058b025 100644
> > --- a/common/overlay
> > +++ b/common/overlay
> > @@ -20,7 +20,19 @@ _overlay_mount_dirs()
> >         shift 3
> >
> >         $MOUNT_PROG -t overlay -o lowerdir=$lowerdir -o upperdir=$upperdir \
> > -                   -o workdir=$workdir `_common_dev_mount_options $*`
> > +                   -o workdir=$workdir $*
> > +}
> > +
> > +# Mount overlayfs with optional dirs and mount point
> > +_overlay_mount_optional_dirs()
> > +{
> > +       local lowerdir=$1
> > +       local upperdir=$2
> > +       local workdir=$3
> > +       shift 3
> > +
> > +       _overlay_mount_dirs $lowerdir $upperdir $workdir \
> > +                           `_common_dev_mount_options $*`
> >  }
> >
> 
> Instead of changing the name of the helper and change all the tests
> that call it,
> factor out a "local" helper __overlay_mount_dirs_o() that takes all options
> from argument and keep the helper name _overlay_mount_dirs(), which the
> tests use, unchanged.

Agreed, I just don't like the name __overlay_mount_dirs_o that much :)
How about something like _do_overlay_mount_dirs?

Thanks,
Eryu

> 
> Then, the only user of the "local" helper __overlay_mount_dirs_o() will be
> the "local" helper _overlay_mount(), which you should also rename to
> __overlay_mount_o(), as it should not be used directly by tests.
> 
> > # Mount with same options/mnt/dev of scratch mount, but optionally
> > @@ -33,7 +45,8 @@ _overlay_scratch_mount_dirs()
> >        shift 3
> >
> >         _overlay_mount_dirs $lowerdir $upperdir $workdir \
> > -                               $* $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
> > +                           `_common_dev_mount_options $*` \
> > +                           $OVL_BASE_SCRATCH_MNT $SCRATCH_MNT
> > }
> 
> This doesn't need to change either.
> 
> Thanks,
> Amir.
