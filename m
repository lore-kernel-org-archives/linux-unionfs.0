From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Tue, 14 Feb 2017 13:24:10 +0800
Message-ID: <20170214052410.GJ24562@eguan.usersys.redhat.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com>
 <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42346 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750930AbdBNFYM (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 00:24:12 -0500
Content-Disposition: inline
In-Reply-To: <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Amir Goldstein <amir73il@gmail.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Mon, Feb 13, 2017 at 07:23:56PM -0500, Theodore Ts'o wrote:
[snip]
> Speaking more generally, I'm not a big fan of the config file approach
> for handling iterations, because of the fact that previous sections
> will have side effects on follow-on sections, and I'm interested in
> adding support for test sharding, where different file system test
> scenarios are run on different GCE VM's, and the ambiguities of how
> variables are carried over from one section to another makes life hard.

I agreed, the section configs are not perfect, sometimes I have
SCRATCH_RTDEV "leaked" to other non-rt test sections. I was considering
fixing this problem, but haven't got enough time to figure out a
reasonable idea yet.

> 
> It also makes it hard to have multiple file system developers editing
> a single config file since you have to worry about side effects.
> Having separate files and separate directories for differnt file
> system types means that patch collisions are much less likely to have
> unanticipated side effects, or cause merge conflicts for that matter.
> I recognize that the local config file is not something that is
> intended to be managed centrally, but I acutally *like* the fact that
> I can separate file system test scenarios (and where I want to have a
> common understanding across ext4 file system developers for what the
> "bigalloc_1k" test scenario means), from the details of the local
> hardware configuration.
> 
> All of this being said, I doubt I'll be able to convince others about
> changing how the local config system works.  I do want to be sure I
> understand what are the supported way of testing overlayfs (e.g., will
> the "deprecated" way continue to work forever, or is it going to
> disappear eventually), and while I'd prefer to not have to play games

I'm considering making the old way unsupported eventually at some point,
after a long enough soak time. But if people still want it, I can live
with it too :)

> with the config file if I want to test using overlayfs, if I *do* get
> forced to do it, it would be useful if there were a bit more explicit

With this update, things get simpler if you're not using multi-section
config file, there's an example in commit log of patch 6/9, README is
also updated, but seems we need that kind of detailed example in README
too.

"
For example, the following config file can be used to run tests on
xfs test/scratch partitions:

 TEST_DEV=/dev/sda5
 TEST_DIR=/mnt/test
 SCRATCH_DEV=/dev/sda6
 SCRATCH_MNT=/mnt/scratch
 FSTYP=xfs

Using the same config file, but executing './check -overlay'...
"

> description of how things like the mkfs mount options, etc. are side
> effected by previous config sections, and how to set up overlayfs

FWIW, Multi-section configs are optional not mandatory for testing
overlayfs. But I agreed that we need more documentation.

> correctly using such a scheme.  (e.g., more documentation than just an
> a few lines demonstration of what might go in the config file without
> any detailed semantic explanation of how it all works.)
> 
> 						- Ted
> 
> [1] The ambiguity I was taking about.  In one part of the
> README.config-state file, it states:
> 
>    Note that options are carried between sections so the same options does not
>    have to be specified in each and every sections. However caution should be
>    exercised not to leave unwanted options set from previous sections.
> 
> (What does this mean when stanzas are skipped?)
> 
> and later on, it says this:
> 
>    Multiple file systems
>    ---------------------
> 
>    Having different file systems in different config sections is allowed. When
>    FSTYP differs in the following section the FSTYP file system will be created
>    automatically before running the test.
> 
>    Note that if MOUNT_OPTIONS, MKFS_OPTIONS, or FSCK_OPTIONS are not directly
>    specified in the section it will be reset to the default for a given file
>    system.
> 
> This seems to imply that configuration paramters such as MKFS_OPTIONS
> do *not* carry over from one config section to another, and is in

Yes, four paramters are not carried across sections, they're unset at
the beginning of each section. In common/config we have

        unset MOUNT_OPTIONS                                                                                                                                                                    
        unset MKFS_OPTIONS                                                                                                                                                                     
        unset FSCK_OPTIONS                                                                                                                                                                     
        unset USE_EXTERNAL

Thanks,
Eryu
