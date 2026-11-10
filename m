Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794314781;
	b=z56FazVMJg8NoqgjZAp9L7g/M2wIATCyA7lJsdBpW/ABw88XqHyUBV2gDrxZwudU12Qi
	 wqY5KYqDzaptRJ23+1AYOQuJiWv1Hgk5oOn5IJHy9FXlUHFhm93dvcAQLAEU69TZwcmi4
	 5zgW17f1S8dUTr3gxAEt1KBx7F5I3qhSxZ+3HpdtBFinHoyxp7W9ANLsCe9bRmk0qtw13
	 BMjA4gbcMT/qts0PYHmqcjB2MIftRd5t0IhBNc2eXzr1xmywIRT76lLxv3hT9Vk8C4WQu
	 O7NVfLJSRcTz70kpEhQhDpAgA3UlI5htX4oCYpZ5+nRrANeaoDtzf9jxGU+MPOFis3g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794314781;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 Mail-Followup-To:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=nANGvihsOES8ExtyjGxx88kNMT34dkgEJGTD4o8zk9k=;
	b=yot5yNC/A1bNywVmzidJSPPHLsEEP0x2GG/XRRkd5c14sG0raHKFwg3uVCKVFn38v4qS
	 WU0XUiM5N7vFLPEv56VKLzj854+ppWTT7tAlBrdok0quasO0QeO6zf2Aeo+JdHHpt6Ab6
	 HjSxJq7OPS+UksJZ/So8b5wRxb02ZuNu28RXQCJS8Dg067j4ZOsBXTyzS8Ks0vEeZNtex
	 xKJ3EXdY24DMTtrpZl/JjaA9HphXMgHanP+dn7pzORZVYNEnM3PnNh4aPB5KU5GWxhCtR
	 aeCq4XCl2B+K5wWdS9LD6Tch0z+jVb9vCXRPs7XNTlkBVPGLHxskBZeZJAC2pG6JSQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRZLDYyu;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F317606A31C;
	Tue, 10 Nov 2026 12:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=XRZLDYyu
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A33B1F0089F;
	Tue, 10 Nov 2026 12:46:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794314780;
	bh=nANGvihsOES8ExtyjGxx88kNMT34dkgEJGTD4o8zk9k=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=XRZLDYyuj+kcPy4uadoVlBh+yrH3hp95e9/U6B1yXllOvMtiHAAVsBgKeEq7TaEyM
	 4KfNGCI0merglthj6i02A4Rdwc8xgs42T8FuoK5TaxnKVmErQZk09h1YiNcKXFgVVW
	 Q6gwJXX9XIgG/iOfwMV0Xs1PBSeHUcDS/FWH8cjnqt6mgdiQspy8GeDxEG9Vh+sd82
	 1+cT+QrPos6NN1FAMfBYdpMzAYJHkaMuAmZdphf5R3SwcmHebO6EqdD68CWq5oyzGf
	 eWqAc0ORHsweHCCyefqGzly+e6vp5OXBG0slb45pOFA84iziYmA/m2iUmrM5oU9rQO
	 sWQUxAe6QqSsw==
Date: Tue, 10 Nov 2026 20:46:11 +0800
From: Zorro Lang <zlang@kernel.org>
To: Amir Goldstein <amir73il@gmail.com>
Cc: Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org, 
	Christian Brauner <brauner@kernel.org>, linux-unionfs@vger.kernel.org
Subject: Re: [PATCH fstests v3] overlay: test that syncfs and unmount persist
 all changes
Message-ID: <avMMEm2YEIQWu8E2@zlang-mailbox>
Mail-Followup-To: Amir Goldstein <amir73il@gmail.com>, 
	Josef Bacik <josef@toxicpanda.com>, fstests@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	linux-unionfs@vger.kernel.org
References: <773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com>
 <946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com>
 <94833333cf2c5dd487022cb290174393.josef@toxicpanda.com>
 <CAOQ4uxjM_-yFt5is2k0Vrk_5LrLBoPqgmepTzSrmJf561_uRnQ@mail.gmail.com>
X-Mailing-List: linux-unionfs@vger.kernel.org
List-Id: <linux-unionfs.vger.kernel.org>
List-Post: <mailto:linux-unionfs@vger.kernel.org>
List-Help: <mailto:linux-unionfs+help@vger.kernel.org>
List-Subscribe: <mailto:linux-unionfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-unionfs+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-unionfs+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAOQ4uxjM_-yFt5is2k0Vrk_5LrLBoPqgmepTzSrmJf561_uRnQ@mail.gmail.com>

On Tue, Nov 10, 2026 at 11:42:57AM +0100, Amir Goldstein wrote:
> On Mon, Nov 9, 2026 at 11:52 PM Josef Bacik <josef@toxicpanda.com> wrote:
> >
> > overlayfs is about to stop syncing the whole upper filesystem on syncfs(2)
> > and unmount.  With fsync=relaxed it only writes the upper inodes that were
> > modified through the overlay, so it has to know about all of them.
> >
> > Modify an overlay in many ways: new files and directories, data and
> > metadata copy up, stores through a shared mapping, sendfile, copy_range,
> > an O_TMPFILE, a short and a long symlink, hard links, renames, whiteouts.
> > Do the same to files that were synced before, so that nothing but the
> > modification itself tells overlayfs about them.  Then drop the caches, sync
> > or unmount the overlay, shut down the base filesystem without flushing its
> > log, cycle the mounts and check that nothing has changed.
> >
> > Do that with every fsync mode that syncs, with and without redirect_dir and
> > metacopy.
> >
> > The base filesystem has to have a journal, so what gets lost if overlayfs
> > misses a modification is data in the page cache.  Changes of metadata are
> > in the log, which overlayfs commits in any case.
> >
> > Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> > ---
> > v1: https://lore.kernel.org/r/773faf2a275e0a51bd38cf68f492856c.josef@toxicpanda.com
> > v2: https://lore.kernel.org/r/946b46fbf1c555a47a8a9304f2ee31af.josef@toxicpanda.com
> >
> > v2->v3:
> > - It's overlay/090 now. (Amir)
> 
> Sorry to nag. Zorro renumbers test conflicts anyway before merge,
> but I have a staged 090 test for bugfix already staged on ovl-fixes:
> https://lore.kernel.org/linux-unionfs/20261109134006.2555438-1-giuseppe@scrivano.org/
> so please take 091 to ease my own workflow (apply and test your patch).

Hi Amir,

Thanks to the developers of each filesystem for helping review the patches.
No need to worry about the case number:) If you're concerned about conflicts,
feel free to use 999 or any higher 4-digit number.

Although having a large dummy number makes merging much easier than dealing with a
conflicting one, I'll handle both cases during the merge anyway. If you have a
specific number range in mind, just let me know when you send a patch.

Thanks,
Zorro

> 
> > - Every round passes fsync=, with fsync=auto in place of the default, and
> >   _exclude_scratch_mount_option is gone. (Amir)
> > - Added _require_scratch_overlay_features fsync redirect_dir metacopy. That
> >   needs [2], and the test doesn't run on older kernels any more. (Amir)
> > - The rounds are in the golden output. (Amir)
> > - Every fsync mode runs with redirect_dir and metacopy off and on, that's 16
> >   rounds. It takes 70s here, so it's not in quick any more. (Amir)
> 
> Damn, this sucks. This is a simple test is should by all means be quick.
> Some suggestion (pick any):
> 1. Test only relaxed and on, which your patch set add
>     auto is always one of them and strict is not related to syncfs/umount at all
> 2. md5sum all the file at one invocation
> 3. find . -printf '%p %y %m %U:%G %n %s %l\n' in place of many stat invocations
> 
> 2 and 3 are quick suggestions from Opus 5.5 based on guess work
> I am sure that your models with access to the test run can do much better
> no need to overdo and no need to pay penalty for test readability
> but 70 seconds is way off the mark for a test like this
> 
> > - The mmap step with the syncfs in it comes first, it used to write
> >   everything that came before it. (Sashiko, Amir)
> > - The caches are dropped after the snapshot, for all files. (Sashiko, Amir)
> > - The overlay is mounted with noatime. The snapshot reads every file, the
> >   atime update marks the overlay inode dirty, and that hid any modification
> >   that overlayfs had missed.
> > - Added files that are synced before they are modified. Creating a file and
> >   copying it up mark the overlay inode dirty, and that hid any later
> >   modification that overlayfs had missed.
> > - Added fallocate, and a copy_range that isn't aligned so xfs can't reflink
> >   it.
> 
> Oh my, so many "hid modification that missed"
> I guess I need to trust the AI test/review process which found them ;)
> 
> Thanks,
> Amir.
> 
> >
> > This is for "ovl: only sync what was written through the overlay" [1].
> >
> > It passes on ext4 and xfs with the series, and with only the first patch of
> > it, which adds the mount options and still syncs the whole upper file
> > system.
> >
> > I ran it on four kernels that I broke on purpose. All of them fail, only in
> > the fsync=auto and fsync=relaxed rounds:
> >
> > - The function that marks the overlay inode dirty does nothing: the file
> >   data is gone.
> > - Only ovl_copyattr() doesn't mark the inode: the pwrite, the sendfile and
> >   the copy_range to the files that were synced before are gone. v2 passes on
> >   this one.
> > - A dirty overlay inode isn't kept after the last iput(): the file data is
> >   gone. v2 only notices in its unmount rounds.
> > - Nothing is written at unmount: the unmount rounds lose the file data.
> >
> > [1] https://lore.kernel.org/r/20261107-b4-ovl-containerized-sync-v5-0-d34b4ae57fdf@toxicpanda.com
> > [2] https://lore.kernel.org/r/20261106155832.3867017-1-amir73il@gmail.com
> >
> >  tests/overlay/090     | 214 ++++++++++++++++++++++++++++++++++++++++++
> >  tests/overlay/090.out |  17 ++++
> >  2 files changed, 231 insertions(+)
> >  create mode 100755 tests/overlay/090
> >  create mode 100644 tests/overlay/090.out
> >
> > diff --git a/tests/overlay/090 b/tests/overlay/090
> > new file mode 100755
> > index 00000000..7f6e58f4
> > --- /dev/null
> > +++ b/tests/overlay/090
> > @@ -0,0 +1,214 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2026 Josef Bacik.  All Rights Reserved.
> > +#
> > +# FS QA Test 090
> > +#
> > +# Test that syncfs(2) on an overlay, and unmounting one, persist everything
> > +# that was modified through it.
> > +#
> > +# overlayfs used to sync the whole upper filesystem for that.  With
> > +# fsync=relaxed it only writes the upper inodes that were modified through this
> > +# overlay, so it has to know about all of them.
> > +#
> > +# Modify the overlay in every way we can think of, sync it, shut down the base
> > +# filesystem without flushing its log, cycle the mounts and check that nothing
> > +# has changed.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto shutdown copyup whiteout mmap redirect metacopy
> > +
> > +. ./common/attr
> > +
> > +_require_scratch
> > +_require_scratch_shutdown
> > +_require_metadata_journaling $SCRATCH_DEV
> > +_require_scratch_overlay_features fsync redirect_dir metacopy
> > +_require_xfs_io_command "syncfs"
> > +_require_xfs_io_command "sendfile"
> > +_require_xfs_io_command "copy_range"
> > +_require_xfs_io_command "falloc"
> > +_require_xfs_io_command "-T"
> > +_require_xfs_io_command "flink"
> > +_require_attrs
> > +_require_chown
> > +_require_mknod
> > +
> > +lowerdir=$OVL_BASE_SCRATCH_MNT/$OVL_LOWER
> > +
> > +create_lower()
> > +{
> > +       local f
> > +
> > +       # This leaves the base filesystem mounted
> > +       _scratch_mkfs >> $seqres.full 2>&1
> > +
> > +       mkdir -p $lowerdir/dir $lowerdir/rmdir $lowerdir/mvdir
> > +       for f in append truncate mmap chmod chown chown_append xattr link \
> > +                rename remove dir/append rmdir/file mvdir/file; do
> > +               $XFS_IO_PROG -f -c "pwrite -S 0x6c 0 256k" $lowerdir/$f \
> > +                       >> $seqres.full
> > +       done
> > +
> > +       # These were not written through the overlay, so it does not have to
> > +       # sync them.
> > +       $XFS_IO_PROG -c "syncfs" $OVL_BASE_SCRATCH_MNT
> > +}
> > +
> > +# Creating a file and copying it up are modifications.  overlayfs remembers them
> > +# until the file is synced, and a later modification that it misses does not
> > +# show.  So make files that are in the upper layer and have been synced.
> > +prepare()
> > +{
> > +       local m=$SCRATCH_MNT
> > +       local f
> > +
> > +       mkdir $m/clean
> > +       for f in pwrite truncate fallocate mmap sendfile copy_range chmod \
> > +                chown xattr link rename remove; do
> > +               $XFS_IO_PROG -f -c "pwrite -S 0x70 0 256k" $m/clean/$f \
> > +                       >> $seqres.full
> > +       done
> > +       $XFS_IO_PROG -c "syncfs" $m
> > +}
> > +
> > +modify()
> > +{
> > +       local m=$SCRATCH_MNT
> > +
> > +       # Stores through a shared mapping, also after a syncfs, no msync.  This
> > +       # has to be the first one, the syncfs must not write anything else.
> > +       $XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x66 0 64k" \
> > +               -c "syncfs" -c "mwrite -S 0x67 64k 64k" $m/mmap >> $seqres.full
> > +
> > +       # The files that overlayfs has nothing to remember about
> > +       $XFS_IO_PROG -c "pwrite -S 0x71 64k 64k" $m/clean/pwrite >> $seqres.full
> > +       $XFS_IO_PROG -c "truncate 4k" $m/clean/truncate
> > +       $XFS_IO_PROG -c "falloc 256k 64k" $m/clean/fallocate
> > +       $XFS_IO_PROG -c "mmap -rw 0 256k" -c "mwrite -S 0x72 64k 64k" \
> > +               $m/clean/mmap >> $seqres.full
> > +       $XFS_IO_PROG -c "sendfile -i $m/link 0 64k" $m/clean/sendfile \
> > +               >> $seqres.full
> > +       # Not aligned, so that the data is copied and not shared
> > +       $XFS_IO_PROG -c "copy_range -s 1 -d 1 -l 64k $m/link" \
> > +               $m/clean/copy_range
> > +       chmod 640 $m/clean/chmod
> > +       chown 1234:1234 $m/clean/chown
> > +       $SETFATTR_PROG -n user.test -v value $m/clean/xattr
> > +       ln $m/clean/link $m/clean/link2
> > +       mv $m/clean/rename $m/clean/renamed
> > +       rm $m/clean/remove
> > +
> > +       # New files and directories
> > +       $XFS_IO_PROG -f -c "pwrite -S 0x61 0 1m" $m/new >> $seqres.full
> > +       mkdir $m/newdir
> > +       $XFS_IO_PROG -f -c "pwrite -S 0x62 0 64k" $m/newdir/new >> $seqres.full
> > +       $XFS_IO_PROG -f -c "pwrite -S 0x63 0 64k" $m/dir/new >> $seqres.full
> > +       ln -s new $m/symlink
> > +       # Too long to be stored in the inode
> > +       ln -s $(printf 'a%.0s' $(seq 1000)) $m/longsymlink
> > +       mkfifo $m/fifo
> > +
> > +       # Copy up, then change the data
> > +       $XFS_IO_PROG -c "pwrite -S 0x64 256k 64k" $m/append >> $seqres.full
> > +       $XFS_IO_PROG -c "pwrite -S 0x65 256k 64k" $m/dir/append >> $seqres.full
> > +       $XFS_IO_PROG -c "truncate 4k" $m/truncate
> > +
> > +       # The other ways to write data
> > +       $XFS_IO_PROG -f -c "sendfile -i $m/link 0 256k" $m/sendfile \
> > +               >> $seqres.full
> > +       $XFS_IO_PROG -f -c "copy_range -l 256k $m/link" $m/copy_range
> > +       $XFS_IO_PROG -T -c "pwrite -S 0x69 0 64k" -c "flink $m/tmpfile" $m \
> > +               >> $seqres.full
> > +
> > +       # Copy up, then change the metadata
> > +       chmod 640 $m/chmod
> > +       chown 1234:1234 $m/chown
> > +       $SETFATTR_PROG -n user.test -v value $m/xattr
> > +
> > +       # With metacopy=on the first one only copies up the metadata
> > +       chown 1234:1234 $m/chown_append
> > +       $XFS_IO_PROG -c "pwrite -S 0x6a 256k 64k" $m/chown_append \
> > +               >> $seqres.full
> > +
> > +       # Names
> > +       ln $m/link $m/link2
> > +       mv $m/rename $m/renamed
> > +       # Without redirect_dir=on mv gets EXDEV and copies the directory
> > +       mv $m/mvdir $m/mvdir2
> > +       rm $m/remove
> > +       rm -r $m/rmdir
> > +}
> > +
> > +# No inode numbers, no timestamps, and no sizes and link counts of directories
> > +snapshot()
> > +{
> > +       local f
> > +
> > +       cd $SCRATCH_MNT
> > +       find . | LC_ALL=C sort | while read -r f; do
> > +               if [ -L "$f" ]; then
> > +                       echo "$f $(stat -c '%F %u:%g' "$f") $(readlink "$f")"
> > +               elif [ -f "$f" ]; then
> > +                       echo "$f $(stat -c '%F %a %u:%g %h %s' "$f")" \
> > +                            "$(md5sum < "$f")"
> > +               else
> > +                       echo "$f $(stat -c '%F %a %u:%g' "$f")"
> > +               fi
> > +       done
> > +       _getfattr --absolute-names -n user.test xattr clean/xattr 2>&1
> > +       cd - > /dev/null
> > +}
> > +
> > +# <syncfs|umount> <mount options>
> > +do_test()
> > +{
> > +       local how=$1
> > +       local opts=$2
> > +
> > +       echo "=== $how $opts" | tee -a $seqres.full
> > +
> > +       create_lower
> > +
> > +       # An atime update is a modification too.  With atime the snapshot would
> > +       # make overlayfs write every file that it reads, also one that
> > +       # overlayfs has lost track of.
> > +       _scratch_mount -o noatime,$opts
> > +
> > +       prepare
> > +       modify
> > +       snapshot > $tmp.before
> > +
> > +       # Nobody holds on to the overlay inodes when they are synced
> > +       echo 2 > /proc/sys/vm/drop_caches
> > +
> > +       if [ $how = syncfs ]; then
> > +               $XFS_IO_PROG -c "syncfs" $SCRATCH_MNT
> > +               _scratch_shutdown | tee -a $seqres.full
> > +               _scratch_unmount
> > +       else
> > +               # Only the overlay, the base filesystem stays mounted
> > +               _unmount $SCRATCH_MNT
> > +               _scratch_shutdown | tee -a $seqres.full
> > +               _unmount $OVL_BASE_SCRATCH_MNT
> > +       fi
> > +
> > +       _scratch_mount -o noatime,$opts
> > +       snapshot > $tmp.after
> > +       cat $tmp.after >> $seqres.full
> > +       diff -u $tmp.before $tmp.after
> > +       _scratch_unmount
> > +}
> > +
> > +for how in syncfs umount; do
> > +       for mode in auto relaxed on strict; do
> > +               for meta in off on; do
> > +                       do_test $how \
> > +                               fsync=$mode,redirect_dir=$meta,metacopy=$meta
> > +               done
> > +       done
> > +done
> > +
> > +# success, all done
> > +status=0
> > +exit
> > diff --git a/tests/overlay/090.out b/tests/overlay/090.out
> > new file mode 100644
> > index 00000000..d6b46515
> > --- /dev/null
> > +++ b/tests/overlay/090.out
> > @@ -0,0 +1,17 @@
> > +QA output created by 090
> > +=== syncfs fsync=auto,redirect_dir=off,metacopy=off
> > +=== syncfs fsync=auto,redirect_dir=on,metacopy=on
> > +=== syncfs fsync=relaxed,redirect_dir=off,metacopy=off
> > +=== syncfs fsync=relaxed,redirect_dir=on,metacopy=on
> > +=== syncfs fsync=on,redirect_dir=off,metacopy=off
> > +=== syncfs fsync=on,redirect_dir=on,metacopy=on
> > +=== syncfs fsync=strict,redirect_dir=off,metacopy=off
> > +=== syncfs fsync=strict,redirect_dir=on,metacopy=on
> > +=== umount fsync=auto,redirect_dir=off,metacopy=off
> > +=== umount fsync=auto,redirect_dir=on,metacopy=on
> > +=== umount fsync=relaxed,redirect_dir=off,metacopy=off
> > +=== umount fsync=relaxed,redirect_dir=on,metacopy=on
> > +=== umount fsync=on,redirect_dir=off,metacopy=off
> > +=== umount fsync=on,redirect_dir=on,metacopy=on
> > +=== umount fsync=strict,redirect_dir=off,metacopy=off
> > +=== umount fsync=strict,redirect_dir=on,metacopy=on
> > --
> > 2.55.0
> >
