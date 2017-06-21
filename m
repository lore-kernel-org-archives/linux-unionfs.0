From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v4 00/25] Overlayfs inodes index
Date: Wed, 21 Jun 2017 23:03:57 +0300
Message-ID: <CAOQ4uxib==ga=V-J8nohSFiSS3eaPdxWN0e8okYN=Aa6-b0Sww@mail.gmail.com>
References: <1498048136-28218-1-git-send-email-amir73il@gmail.com> <CAOQ4uxgY_+aB1SLpnQOth_HsQooqbL4yUxGxBgNEeAHrCo4PMw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-ot0-f195.google.com ([74.125.82.195]:34336 "EHLO
        mail-ot0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751028AbdFUUD6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 21 Jun 2017 16:03:58 -0400
In-Reply-To: <CAOQ4uxgY_+aB1SLpnQOth_HsQooqbL4yUxGxBgNEeAHrCo4PMw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jun 21, 2017 at 8:02 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Jun 21, 2017 at 3:28 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> Miklos,
>>
>> This is it.
>> All done on my end, so unless you have any rejects that you want me
>> to fix, you may start mangling.
>>
>> I've added another xfstest for nlink accounting and may add another
>> one that mangles with lower hardlinks to get negative overlay nlink.
>> It's a behavior I observed with lower/upper stress xfstest overlay/019
>> and fixed in patch 25.
>
> FYI1: I wrote that test and pushed to my xfstests dev branch.
> The test found another corner case of lower hardlinks mangling.
> I fixed that other case and re-posted patch 25 and force pushed
> ovl-hardlinks.v4.
>
> FYI2: Occasionally, I get the WARN_ON from drop_nlink() when
> running the generic xfstest fsstress test generic/013:
>
> generic/013 [16:50:00]run fstests generic/013 at 2017-06-21 16:50:00
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 10920 at
> /home/amir/build/src/linux/fs/inode.c:282 drop_nlink+0x10/0x29
> Call Trace:
>  ovl_do_remove.part.2+0x353/0x3bd
>  ovl_unlink+0x23/0x26
>  vfs_unlink+0xde/0x17d
>  do_unlinkat+0x10a/0x215
>
> Since this is not an overlay specific test, all fsstress operation
> are on pure upper, so I'm not sure how my patches could break
> this test case. Because it happens rarely, its going to take me time
> to bisect the problem.
>
> My only immediate suspect is "ovl: fix nlink leak in ovl_rename()",
> which is a generic change that drops nlink. Could you please take
> a closer look at this patch to see if I missed something.
> I will try to reproduce the issue with just this one patch.
>

This patch is not to blame, nor are any of the other patches.
The problem goes back at least as far as kernel v4.10.
