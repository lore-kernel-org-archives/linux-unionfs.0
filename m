From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 1/2] common/rc: Add syncfs check and a helper
 _scratch_shutdown()
Date: Wed, 6 Dec 2017 01:14:16 +0800
Message-ID: <20171205171416.GO2749@eguan.usersys.redhat.com>
References: <2D8A66F2-6AB9-4B7D-90B0-D3B6807FB353@icloud.com>
 <CAOQ4uxi35dTxBJSXPjVnx7Ei+Mfud2370Pikzf6KEESpGLdFog@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <fstests-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAOQ4uxi35dTxBJSXPjVnx7Ei+Mfud2370Pikzf6KEESpGLdFog@mail.gmail.com>
Sender: fstests-owner@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>, Chengguang Xu <cgxu519@icloud.com>
Cc: fstests <fstests@vger.kernel.org>, overlayfs <linux-unionfs@vger.kernel.org>
List-Id: linux-unionfs@vger.kernel.org

On Tue, Dec 05, 2017 at 06:13:35PM +0200, Amir Goldstein wrote:
> On Tue, Dec 5, 2017 at 5:50 PM, Chengguang Xu <cgxu519@icloud.com> wrote:
> > 1. Add a check case in _require_xfs_io_command() to support syncfs.
> > 2. Introduce a helper to support scratch shutdown for overlayfs.
> >
> > Signed-off-by: Chengguang Xu <cgxu519@icloud.com>
> > ---
> > common/rc | 22 ++++++++++++++++++++--
> > 1 file changed, 20 insertions(+), 2 deletions(-)
> >
> > diff --git a/common/rc b/common/rc
> > index 4c053a5..e36ee24 100644
> > --- a/common/rc
> > +++ b/common/rc
> > @@ -669,6 +669,21 @@ _scratch_cleanup_files()
> >         esac
> > }
> >
> > +_scratch_shutdown()
> > +{
> > +
> > +       case $FSTYP in
> > +       overlay)
> 
> Looks good,
> but first you need to check for [ -z "$OVL_BASE_SCRATCH_MNT" ]
> meaning that tester is using "old" overlay config and we are not allowed to
> mess with base fs.

Agreed, we don't want to shutdown the root fs accidently.

> 
> > +               src/godown -f $OVL_BASE_SCRATCH_MNT 2>&1 \
> > +                       || _notrun "Underlying filesystem does not support shutdown"
> > +               ;;
> > +       *)
> > +               src/godown -f $SCRATCH_MNT 2>&1 \
> > +                       || _notrun "$FSTYP does not support shutdown"
> > +               ;;
> > +       esac
> > +}

I think this _scratch_shutdown() should be folded into
_require_scratch_shutdown(). The name _scratch_shutdown indicates it
shuts down the scratch device, and call _notrun from it would be a
surprise to users.

> > +
> > _scratch_mkfs()
> > {
> >         local mkfs_cmd=""
> > @@ -2087,6 +2102,10 @@ _require_xfs_io_command()
> >         "utimes" )
> >                 testio=`$XFS_IO_PROG -f -c "utimes" 0 0 0 0 $testfile 2>&1`
> >                 ;;
> > +       "syncfs")
> > +               touch $testfile
> > +               testio=`$XFS_IO_PROG -c "syncfs" $testfile 2>&1`
> > +               ;;
> >         *)

This part should be in a separate patch.

Thanks,
Eryu

> >                 testio=`$XFS_IO_PROG -c "help $command" 2>&1`
> >         esac
> > @@ -2908,8 +2927,7 @@ _require_scratch_shutdown()
> >
> >         _scratch_mkfs > /dev/null 2>&1
> >         _scratch_mount
> > -       src/godown -f $SCRATCH_MNT 2>&1 \
> > -               || _notrun "$FSTYP does not support shutdown"
> > +       _scratch_shutdown
> >         _scratch_unmount
> > }
> >
> > --
> > 1.8.3.1
