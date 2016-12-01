From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH] overlay: test ro/rw fd data inconsistecies
Date: Thu, 1 Dec 2016 18:42:00 +0200
Message-ID: <CAOQ4uxjSZuKocjcLdn6eWmJJdRqYrXonoq0Czvk-UCH6aWfseA@mail.gmail.com>
References: <1480018332-16567-1-git-send-email-amir73il@gmail.com>
 <CAOQ4uxgEgNJtFfauUTXAr9YedbJeNFrZaWAUbEJUzycf=r3Emw@mail.gmail.com> <20161129113715.GN22989@eguan.usersys.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f65.google.com ([74.125.82.65]:32851 "EHLO
        mail-wm0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754978AbcLAQmp (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 1 Dec 2016 11:42:45 -0500
In-Reply-To: <20161129113715.GN22989@eguan.usersys.redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Eryu Guan <eguan@redhat.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org, fstests <fstests@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Tue, Nov 29, 2016 at 1:37 PM, Eryu Guan <eguan@redhat.com> wrote:
> On Tue, Nov 29, 2016 at 10:53:36AM +0200, Amir Goldstein wrote:

>>
>> Eryu and all,
>>
>> I wanted to ask what is the common practice for introducing tests for
>> know issues
>> that are *about* to be solved.
>>
>> What is the preferred timing for merging these sort of tests?
>> Is it productive to have these tests merged before a fix is merged to master?
>> Before a fix is queued for next?
>> Before a fix is available?
>
> Basically new regression tests will be merged as soon as possible, as
> long as there're no objections from reviewers or all comments are
> addressed.
>
> One exception is that for tests that could crash latest maintainer's
> tree (even there's a known fix), I'd perfer letting the fix go upstream
> first, so that the test doesn't break anyone's tests by crashing all the
> testing hosts. It's great if the test author could give a notification
> on the test to say that the fix has been merged, so the test could be
> merged too. I'll watch the patch status too, but maybe not so timely.
>

Nothing of a sort lurking with the tests I am planning to write.
Just tests that check for "Non-standard behavior" of overlayfs,
some of it described in Documentation/filesystems/overlayfs.txt.

>
>>
>> FYI, the fix for the test in this patch (test ro/rw fd data inconsistencies)
>> is not queued for next yet, but I am hoping it will be.
>> Miklos?
>
> FYI, this test is already in my last pull request to Dave.
>

Eryu,

I am getting this error when running my test with an older xfs_io (4.3.0).
I generated the good output with xfs_io from Dave's for-next branch (4.8.0).

Have you any idea why in one setup I see the commands echoed
to output and not in the other?

I realize that the use of redirecting commands from here document
to xfs_io has not been used in xfstests before, but I could not find
another way to use 'open' commands, which are needed for this test.

Amir.

overlay/016      - output mismatch (see
/home/amir/src/xfstests-dev/results//overlay/016.out.bad)
    --- tests/overlay/016.out   2016-12-01 12:19:02.710370574 +0200
    +++ /home/amir/src/xfstests-dev/results//overlay/016.out.bad
 2016-12-01 18:29:23.684327009 +0200
    @@ -1,12 +1,22 @@
     QA output created by 016
    -xfs_io> xfs_io> xfs_io> wrote 16/16 bytes at offset 0
    +xfs_io> open -r foo
    +xfs_io> open foo
    +xfs_io> pwrite -S 0x61 0 16
    +wrote 16/16 bytes at offset 0
     XXX Bytes, X ops; XX:XX:XX.X (XXX YYY/sec and XXX ops/sec)
    ...
