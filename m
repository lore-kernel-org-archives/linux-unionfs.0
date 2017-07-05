From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 5/7] overlay: test concurrent copy up of lower hardlinks
Date: Wed, 5 Jul 2017 13:46:51 +0300
Message-ID: <CAOQ4uxjLCGZ3hHfkZzgZiHctC1x6s_EF7J1g0-zjXYCOzqoHwQ@mail.gmail.com>
References: <1499168434-23859-1-git-send-email-amir73il@gmail.com>
 <1499168434-23859-6-git-send-email-amir73il@gmail.com> <20170705095902.GR23360@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:33581 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751626AbdGEKqw (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 5 Jul 2017 06:46:52 -0400
In-Reply-To: <20170705095902.GR23360@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>, fstests <fstests@vger.kernel.org>

On Wed, Jul 5, 2017 at 12:59 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Jul 04, 2017 at 02:40:32PM +0300, Amir Goldstein wrote:
>> Two tasks make a modification concurrently on two hardlinks of a large
>> lower inode.  The copy up should be triggered by one of the tasks and the
>> other should be waiting for copy up to complete.  Both copy up targets
>> should end up being upper hardlinks and both metadata changes should be
>> visible in both hardlinks.
>>
>> With kernel <= v4.12, hardlinks are broken on copy up, meaning that copy up
>
> So this will be fixed in 4.13-rc1 kernel?

It is fixed on current overlayfs-next branch. Yes.


>> +
>> +_do_cmd()
>
> I'd rename it to do_cmd for a local helper function.
>

sure

>> +{
>> +     echo "`date +%T` $1..." >> $seqres.full
>> +     eval "$1"
>> +     echo "`date +%T` ...$1" >> $seqres.full
>> +}
>> +
>> +# Perform one modification on each hardlink (size and owner)
>> +_do_cmd "echo >> $SCRATCH_MNT/one" &
>> +#
>> +# When hardlinks are broken and overlayfs supports concurrent copy up,
>> +# $seqres.full will show that file two copy up started ~2s after file one
>> +# copy up started and ended ~2s after file one copy up ended.
>> +# With synchronized copy up of lower inodes, $seqres.full will show that
>> +# file two copy up ended at the same time as file one copy up.
>> +#
>> +sleep 2
>
> If the first copyup finished within 2 seconds, it's not a concurrent
> modification on the two hardlinks. Does that break the test assumption?

It will not be a race, plain 2 consequent copy ups, so not testing anything
special, but won't cause test to fail.

I am testing overlayfs with 2 underlying fs configurations:
1. xfs with clone support
2. ext4

With xfs clone up takes fraction of a second, the test is not really concurrent.
With ext4, on my laptop with SSD, the 500M copy up takes ~3 seconds,
which is quite close to the 2 seconds delay.
I increased the copy up file size to 1G and now first copy up takes ~6 seconds,
so there is more slack for the 2 sec delay, but still keeps the test 'quick'.

>
>> +_do_cmd "chown 100 $SCRATCH_MNT/two" &
>> +
>> +wait
>> +
>> +# Expect all hardlinks to show both metadata modifications
>> +for f in zero one two; do
>> +     _ls_l -n $SCRATCH_MNT/$f | awk '{ print $2, $3, $5, $9 }' | _filter_scratch
>
> Better to comment on what are the 4 fields.
>

They show the metadata that was changes by chown and write.
Will add a comment.

Thanks,
Amir.
