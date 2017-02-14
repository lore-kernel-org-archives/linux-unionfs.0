From: Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Mon, 13 Feb 2017 19:23:56 -0500
Message-ID: <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from imap.thunk.org ([74.207.234.97]:36648 "EHLO imap.thunk.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751408AbdBNAYC (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 13 Feb 2017 19:24:02 -0500
Content-Disposition: inline
In-Reply-To: <1486932224-17075-10-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Sun, Feb 12, 2017 at 10:43:44PM +0200, Amir Goldstein wrote:
> When TEST/SCRATCH_DEV are configured to the base fs block device,
> use this information to mount base fs before running tests,
> unmount it after running tests and cycle on _test_cycle_mount
> along with the overlay mounts.

So I don't normally use the multi-section config file --- and I
confess the exact semantics of the config file, and how things are
inherited across sections has always been confusing to me (there are
bits of README.config-sections which seem to be mutually
contradictory[1]).  So apologies in advance, but when you have
something like this:

> diff --git a/README.config-sections b/README.config-sections
> index df7c929..d45d6da 100644
> --- a/README.config-sections
> +++ b/README.config-sections
> @@ -102,6 +102,9 @@ MKFS_OPTIONS="-q -F -b4096"
>  FSTYP=ext4
>  RESULT_BASE="`pwd`/results/`date +%d%m%y_%H%M%S`"
>  
> +[ext4_overlay]
> +FSTYP=overlay
> +
>  [ext4_1k_block_size]
>  MKFS_OPTIONS="-q -F -b1024"

How do you know that the base file system type should be ext4?  Is it
because the previous file system type in a previous config section
(OLD_FSTYP in the check script) is ext4?

If so, what happens if the first sectionis FSTYP=overlay.  Also, what
happens previous sections are skipped?  Suppose you have a config file
that looks like this:

[ext4]
...
FSTYP=ext4

[ext4_overlay]
FSTYP=overlay

[xfs]
...
FSTYP=xfs

[xfs_overlay]
FSTYP=overlay

What is supposed to happen (and what does happen) if the user runs:

./check -s xfs_overlay

or

./check -s ext4 -s xfs_overlay

?

Speaking more generally, I'm not a big fan of the config file approach
for handling iterations, because of the fact that previous sections
will have side effects on follow-on sections, and I'm interested in
adding support for test sharding, where different file system test
scenarios are run on different GCE VM's, and the ambiguities of how
variables are carried over from one section to another makes life hard.

It also makes it hard to have multiple file system developers editing
a single config file since you have to worry about side effects.
Having separate files and separate directories for differnt file
system types means that patch collisions are much less likely to have
unanticipated side effects, or cause merge conflicts for that matter.
I recognize that the local config file is not something that is
intended to be managed centrally, but I acutally *like* the fact that
I can separate file system test scenarios (and where I want to have a
common understanding across ext4 file system developers for what the
"bigalloc_1k" test scenario means), from the details of the local
hardware configuration.

All of this being said, I doubt I'll be able to convince others about
changing how the local config system works.  I do want to be sure I
understand what are the supported way of testing overlayfs (e.g., will
the "deprecated" way continue to work forever, or is it going to
disappear eventually), and while I'd prefer to not have to play games
with the config file if I want to test using overlayfs, if I *do* get
forced to do it, it would be useful if there were a bit more explicit
description of how things like the mkfs mount options, etc. are side
effected by previous config sections, and how to set up overlayfs
correctly using such a scheme.  (e.g., more documentation than just an
a few lines demonstration of what might go in the config file without
any detailed semantic explanation of how it all works.)

						- Ted

[1] The ambiguity I was taking about.  In one part of the
README.config-state file, it states:

   Note that options are carried between sections so the same options does not
   have to be specified in each and every sections. However caution should be
   exercised not to leave unwanted options set from previous sections.

(What does this mean when stanzas are skipped?)

and later on, it says this:

   Multiple file systems
   ---------------------

   Having different file systems in different config sections is allowed. When
   FSTYP differs in the following section the FSTYP file system will be created
   automatically before running the test.

   Note that if MOUNT_OPTIONS, MKFS_OPTIONS, or FSCK_OPTIONS are not directly
   specified in the section it will be reset to the default for a given file
   system.

This seems to imply that configuration paramters such as MKFS_OPTIONS
do *not* carry over from one config section to another, and is in
direct contradiction to the above paragraph.
