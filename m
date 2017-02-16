From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3 9/9] overlay: mount/unmount base fs before/after
 running tests
Date: Thu, 16 Feb 2017 10:50:20 +0200
Message-ID: <CAOQ4uxgxWg2o2co8L4fcje0yKrNN7gv3V90t7d=CFrsT4fbD+Q@mail.gmail.com>
References: <1486932224-17075-1-git-send-email-amir73il@gmail.com>
 <1486932224-17075-10-git-send-email-amir73il@gmail.com> <20170214002356.dxrmf5jzwr6sivlu@thunk.org>
 <CAOQ4uxj131n=dadiuCzJZWTTC0Jkw=Bdpp1QpX=keBOOySYySg@mail.gmail.com>
 <20170214170757.nuhxnvhtctreelxt@thunk.org> <CAOQ4uxgV++ZdecBfUth2TN4A451hP_7UXRkBkgVhOTEwCzhNMA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f196.google.com ([74.125.82.196]:35884 "EHLO
        mail-ot0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753625AbdBPIuV (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 16 Feb 2017 03:50:21 -0500
In-Reply-To: <CAOQ4uxgV++ZdecBfUth2TN4A451hP_7UXRkBkgVhOTEwCzhNMA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Theodore Ts'o <tytso@mit.edu>
Cc: Eryu Guan <eguan@redhat.com>, Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>

On Tue, Feb 14, 2017 at 7:55 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Tue, Feb 14, 2017 at 7:07 PM, Theodore Ts'o <tytso@mit.edu> wrote:
>> On Tue, Feb 14, 2017 at 08:43:36AM +0200, Amir Goldstein wrote:
>>>
>>> Correct. The only thing that overlay does not do is format the base fs,
>>> as the README says:
>>>         - for overlay tests: ./check -overlay [test(s)]
>>>           The TEST and SCRATCH partitions should be pre-formatted
>>>           with another base fs, where the overlay dirs will be created
>>>
>>
>> So this means that if I only want to do the equivalent of:
>>
>>    gce-xfstests -c overlay generic/013
>>
>> as part of a bisection search, it's impossible to do this via the
>> config file and "./check -s ext4-overlay generic/013" alone.  Someone
>> who wants to do this will have to use their own wrapper script to
>> format the base file system with the proper file system.
>>
>> Correct?
>>
>
> Correct.
>
> I guess it wouldn't be that hard to add mkfs/fsck support for base fs,
> but for now my budget to deal with this is over. I may get to it another
> time.
>
>> Which is fine, I have my own wrapper script system.  :-)
>>
>
> Do we have something like:
> ./check -s ext4 --setup-only
>
> Should we have something like this?
>
> Will this do the trick?
> ./check -s ext4 -n generic/013

FYI, for upcoming V4, I recalled the support for overlay sections
(i.e. it is an undocumented feature), but verified that multi section can run
with -overlay, as long as the sections only change mount options, e.g.:

[xfs]
TEST_DEV=/dev/sda5
TEST_DIR=/mnt/test
SCRATCH_DEV=/dev/sda6
SCRATCH_MNT=/mnt/scratch
MKFS_OPTIONS="-f -m rmapbt=1,reflink=1"
FSTYP=xfs

[xfs_pquota]
MOUNT_OPTIONS="-o pquota"
TEST_FS_MOUNT_OPTS="-o noatime"
OVERLAY_MOUNT_OPTIONS="-o redirect_dir=off"

I will collect some of these example in README.overlay
