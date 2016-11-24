From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 0/7] overlayfs: fix ro/rw fd data inconsistecies
Date: Thu, 24 Nov 2016 22:50:48 +0200
Message-ID: <CAOQ4uxiQMrR83Y5vPEUcXDYvarcpb7AdkDAXZiwF7Rhjt7hWsA@mail.gmail.com>
References: <1479984944-1017-1-git-send-email-mszeredi@redhat.com>
 <1479984944-1017-2-git-send-email-mszeredi@redhat.com> <CAJfpegtdfSBPti9scGe7ztQ_DdsKAemfkQ=kxkbJbctj173Mnw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:36340 "EHLO
        mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933643AbcKXUuv (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 24 Nov 2016 15:50:51 -0500
In-Reply-To: <CAJfpegtdfSBPti9scGe7ztQ_DdsKAemfkQ=kxkbJbctj173Mnw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Miklos Szeredi <mszeredi@redhat.com>

On Thu, Nov 24, 2016 at 4:14 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Nov 24, 2016 at 11:55 AM, Miklos Szeredi <mszeredi@redhat.com> wrote:
>> A file is opened for read-only, opened read-write (resulting in a copy up)
>> and modified.  The data read back from the the read-only fd will be stale
>> in this case (the read-only file descriptor still refers to the lower,
>> unmodified file).
>>
>> This patchset fixes issues related to this corner case.
>>
>> The VFS impact is minimal and performance in the non-corner cases shouldn't
>> suffer.
>
> Git tree is here:
>
> git://git.kernel.org/pub/scm/linux/kernel/git/mszeredi/vfs.git #overlayfs-rorw
>

passed my tests.
I now run all my tests (including unionmount-testsuite) on a setup of
overlayfs over xfs with reflink:
- xfstests - from my github overlayfs-devel branch
  -g quick and overlay/*
  including new test 016 to check ro/rw fd data inconsistencies
- pjdfstest - from my github overlayfs-devel branch
  including acl/xattr tests
- unionmount-testsuite - from my github overlayfs-devel branch
  without recycling (--ov), with mount recycle -(-ov=0) and with mount
recycle and
  layers (--ov=10)

Tested-by: Amir Goldstein <amir73il@gmail.com>
