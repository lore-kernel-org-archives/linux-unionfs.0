From: Vivek Goyal <vgoyal@redhat.com>
Subject: Re: [ANNOUNCE] unionmount-testsuite: Amir's master branch updated
Date: Wed, 6 Dec 2017 13:17:00 -0500
Message-ID: <20171206181700.GA7967@redhat.com>
References: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44488 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751718AbdLFSRB (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 6 Dec 2017 13:17:01 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxiiaiq8dettBvZScC59KV-07B-muxE3SS60BDK3dugJow@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>, David Howells <dhowells@redhat.com>, fstests <fstests@vger.kernel.org>

On Tue, Dec 05, 2017 at 10:20:25PM +0200, Amir Goldstein wrote:
> Hi All,
> 
> The master branch on my unionmount-testsuite tree [1] has been updated.
> 
> The head of the master branch is commit:
> 6d04664 Add a test for rename over empty union dir
> 
> This small update contains:
> - A few new simple dir rename and dir remove tests
> - A fix for running on kernel <= v4.9 with no redirect_dir support
> - A new setup option --squashfs to setup lower as read-only squashfs
> 

Hi Amir,

It would be nice to also update README file and explain different options.

Also, how to test with different mount options enabled/disable (index,
redirect etc).

> With index enabled, there are no known failures.
> With index disabled this test fails on non-constant st_ino for lower hardlink
> copy up:
>   run --ov=1 --samefs --verify rename-mass-5

I ran "./run --ov" and that seems to fail with 4.15.0-rc2 kernel.

# ./run --ov
***
*** ./run --ov --ts=0 open-plain
***
TEST open-plain.py:10: Open O_RDONLY
/mnt/a/foo100: File on unexpected layer

Vivek
