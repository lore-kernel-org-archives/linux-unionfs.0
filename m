Return-Path: <guaneryu@gmail.com>
Return-Path: <guaneryu@gmail.com>
Date: Fri, 16 Mar 2018 10:55:54 +0800
From: Eryu Guan <guaneryu@gmail.com>
Subject: Re: [PATCH V3] xfstest: overlay: Absolute redirect should be
 followed even if ancestor is opaque
Message-ID: <20180316025554.GM30836@localhost.localdomain>
References: <20180314131618.GA1001@redhat.com>
 <20180316025320.GL30836@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20180316025320.GL30836@localhost.localdomain>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: fstests@vger.kernel.org, Amir Goldstein <amir73il@gmail.com>, linux-unionfs@vger.kernel.org, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Fri, Mar 16, 2018 at 10:53:20AM +0800, Eryu Guan wrote:

> > +# Create opaque parent with absolute redirect child in middle layer
> > +mkdir $SCRATCH_MNT/pure
> > +mv $SCRATCH_MNT/origin $SCRATCH_MNT/pure/redirect
> > +$UMOUNT_PROG $SCRATCH_MNT
> > +_overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir -o redirect_dir=on
> > +mv $SCRATCH_MNT/pure/redirect $SCRATCH_MNT/redirect
> 
> I think we'd better do a "ls $SCRATCH_MNT/redirect/" here too, right
> after the rename and before mount cycle, to make sure 'foo' is there as
> well. I can add it on commit (and change the .out file too) if this
> change looks OK to you.

Something like this:

git a/tests/overlay/057 b/tests/overlay/057
index 10b46bfa8cff..d54024e98bcd 100644
--- a/tests/overlay/057
+++ b/tests/overlay/057
@@ -86,6 +86,8 @@ mv $SCRATCH_MNT/origin $SCRATCH_MNT/pure/redirect
 $UMOUNT_PROG $SCRATCH_MNT
 _overlay_scratch_mount_dirs $lowerdir2:$lowerdir $upperdir $workdir -o redirect_dir=on
 mv $SCRATCH_MNT/pure/redirect $SCRATCH_MNT/redirect
+# Verify that redirects are followed
+ls $SCRATCH_MNT/redirect/
 
 # Verify that redirects are followed after mount cycle
 $UMOUNT_PROG $SCRATCH_MNT
diff --git a/tests/overlay/057.out b/tests/overlay/057.out
index 750830212460..b3b4017d32ae 100644
--- a/tests/overlay/057.out
+++ b/tests/overlay/057.out
@@ -1,2 +1,3 @@
 QA output created by 057
 foo
+foo

Thanks,
Eryu
