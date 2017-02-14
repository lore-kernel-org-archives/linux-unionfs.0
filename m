From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Tue, 14 Feb 2017 08:43:36 +0200
Message-ID: <CAOQ4uxj131n=dadiuCzJZWTTC0Jkw=Bdpp1QpX=keBOOySYySg@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com> <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:35985 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752306AbdBNGni (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 14 Feb 2017 01:43:38 -0500
In-Reply-To: <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 2:23 AM, Theodore Ts'o <tytso@mit.edu> wrote:
> On Sun, Feb 12, 2017 at 10:43:44PM +0200, Amir Goldstein wrote:
>> When TEST/SCRATCH_DEV are configured to the base fs block device,
>> use this information to mount base fs before running tests,
>> unmount it after running tests and cycle on _test_cycle_mount
>> along with the overlay mounts.
>
> So I don't normally use the multi-section config file --- and I
> confess the exact semantics of the config file, and how things are
> inherited across sections has always been confusing to me (there are
> bits of README.config-sections which seem to be mutually
> contradictory[1]).  So apologies in advance, but when you have
> something like this:
>

Indeed. Multi section config does not give the tester super power.
Tester needs to know what she is doing.
As I replied on the linux-fsdevel thread, I found out that interleaving
overlay sections post non-overlay sections work and thought
it may be useful for some, so I added the example.
I do not intend to fix problems with multi section config + overlay
so I may as well remove that example and leave this a useful but
undocumented feature.

Having written that disclaimer, I will go on to answer your questions.

>> diff --git a/README.config-sections b/README.config-sections
>> index df7c929..d45d6da 100644
>> --- a/README.config-sections
>> +++ b/README.config-sections
>> @@ -102,6 +102,9 @@ MKFS_OPTIONS="-q -F -b4096"
>>  FSTYP=ext4
>>  RESULT_BASE="`pwd`/results/`date +%d%m%y_%H%M%S`"
>>
>> +[ext4_overlay]
>> +FSTYP=overlay
>> +
>>  [ext4_1k_block_size]
>>  MKFS_OPTIONS="-q -F -b1024"
>
> How do you know that the base file system type should be ext4?  Is it
> because the previous file system type in a previous config section
> (OLD_FSTYP in the check script) is ext4?
>

Correct. The only thing that overlay does not do is format the base fs,
as the README says:
        - for overlay tests: ./check -overlay [test(s)]
          The TEST and SCRATCH partitions should be pre-formatted
          with another base fs, where the overlay dirs will be created

> If so, what happens if the first sectionis FSTYP=overlay.  Also, what
> happens previous sections are skipped?  Suppose you have a config file
> that looks like this:
>
> [ext4]
> ...
> FSTYP=ext4
>
> [ext4_overlay]
> FSTYP=overlay
>
> [xfs]
> ...
> FSTYP=xfs
>
> [xfs_overlay]
> FSTYP=overlay
>
> What is supposed to happen (and what does happen) if the user runs:
>
> ./check -s xfs_overlay
>
> or
>
> ./check -s ext4 -s xfs_overlay
>
> ?

You know what will happen :-) only bad things.

> Speaking more generally, I'm not a big fan of the config file approach
> for handling iterations, because of the fact that previous sections
> will have side effects on follow-on sections, and I'm interested in
> adding support for test sharding, where different file system test
> scenarios are run on different GCE VM's, and the ambiguities of how
> variables are carried over from one section to another makes life hard.
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

It seems to me that multi section config file is not the right tool for
the job to test many types of file systems, but it may be useful
for testing different MKFS/MOUNT options for the same FSTYP.

For that purpose, if interleaving overlay section is helpful,
it could be used, but what won't work correctly is './check -overlay'
because it will not mkfs base fs when changing sections.

Actually, it may not be that hard to add support for mkfs of base
fs so check -overlay on multi section config will work, but I did
not know if that was an important use case.

Therefore, the feedback from prospect overlay testers and
the configurations that they use is important.
What would be your config if you were to test overlay?
P.S. I still did not get around to migrate kvm-xfstests to use new config,
but I will. For now patch 8/9 breaks some tests in kvm-xfstests
(old config) so I still need to fix that.

Amir.
