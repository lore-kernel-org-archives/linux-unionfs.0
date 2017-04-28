From: Eryu Guan <eguan@redhat.com>
Subject: Re: [PATCH 0/5] fstests: more tests for overlay constant inode
 numbers
Date: Fri, 28 Apr 2017 13:30:20 +0800
Message-ID: <20170428053020.GK26397@eguan.usersys.redhat.com>
References: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:52102 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1164556AbdD1FaW (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 28 Apr 2017 01:30:22 -0400
Content-Disposition: inline
In-Reply-To: <1493305775-12559-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, Xiong Zhou <xzhou@redhat.com>, linux-unionfs@vger.kernel.org, fstests@vger.kernel.org

On Thu, Apr 27, 2017 at 06:09:30PM +0300, Amir Goldstein wrote:
> Hi Eryu,
> 
> This series contains enhancements to overlay/017, which I used to test
> my work on overlayfs constant inode numbers. [1]
> 
> The original test was a bit naiive, not taking into account renames,
> drop caches and mount cycle. All those are added by this series.

Thanks for the tests! Though usually we don't add new tests to existing
test cases, given that overlay/017 never passed before and won't pass
after adding these tests too, I think it's fine to merge this patchset,
as overlay/017 won't cause any false regression in tests.

Some minor comments go to individual patches.

Thanks,
Eryu

> 
> My work covers only the inode numbers returned from stat(2) and not
> the inode numbers returned in d_ino from readdir(3), so the 'find -inum'
> part of this test could still fail with my overlayfs patches.
> 
> However, I ran my tests in kvm-xfstests VM, where 'find -inum' called
> stat(2) for each entry, so the test did pass.
> 
> I will dig deeper into this behavior when I work on fixing d_ino
> values in the next part of my work.
> 
> Amir.
> 
> [1] https://marc.info/?l=linux-unionfs&m=149324252301397&w=2
> 
> Amir Goldstein (5):
>   overlay/017: silence test output
>   overlay/017: use af_unix to create socket test file
>   overlay/017: create a helper to record inode number
>   overlay/017: verify constant inode number after rename
>   overlay/017: test persistent inode numbers after mount cycle
> 
>  tests/overlay/017     | 69 +++++++++++++++++++++++++++++++++++++++++++++------
>  tests/overlay/017.out |  7 +-----
>  2 files changed, 62 insertions(+), 14 deletions(-)
> 
> -- 
> 2.7.4
> 
