From: Eryu Guan <eguan@redhat.com>
Subject: Re: [xfstests v3 0/8] bunch of overlay tests
Date: Tue, 21 Feb 2017 13:23:33 +0800
Message-ID: <20170221052333.GO24562@eguan.usersys.redhat.com>
References: <1487580524-21503-1-git-send-email-xzhou@redhat.com>
 <CAOQ4uxhzYPkp3YHEuGHrvQ8+0SCmQuiXDO=2osOAga2NEWeZUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44528 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750896AbdBUFXf (ORCPT <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 21 Feb 2017 00:23:35 -0500
Content-Disposition: inline
In-Reply-To: <CAOQ4uxhzYPkp3YHEuGHrvQ8+0SCmQuiXDO=2osOAga2NEWeZUw@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Amir Goldstein <amir73il@gmail.com>
Cc: Xiong Zhou <xzhou@redhat.com>, fstests@vger.kernel.org, linux-unionfs@vger.kernel.org

On Mon, Feb 20, 2017 at 01:37:57PM +0200, Amir Goldstein wrote:
> On my mobile email client so can't post to the list, but ACK on the series.

Thanks for the review! I'll give them some test runs and queue them in
stage tree.

Thanks,
Eryu

> 
> Cheers,
> Amir.
> 
> On Feb 20, 2017 9:49 AM, "Xiong Zhou" <xzhou@redhat.com> wrote:
> 
>     v3:
>       cc linux-unionfs
>       rm -rf $tmp in cleanup
>       checking exact errno in set/getfattr case
>       sleep less in flock case
> 
>     Xiong Zhou (8):
>       overlay: disallow overlayfs as upperdir
>       overlay: work dir in overlay inherits no ACLs
>       overlay: test workdir cleanup in mounting
>       overlay: permission check with cached acls in tmpfs
>       overlay: filter out xattr starts with "trusted.overlay."
>       overlay: can not change underlying immutable file
>       overlay: test flock after copied up
>       overlay: accessing stacked overlayfs files
> 
>      tests/overlay/022     |  82 +++++++++++++++++++++++++++++++++++++++++
>      tests/overlay/022.out |   2 +
>      tests/overlay/023     |  81 ++++++++++++++++++++++++++++++++++++++++
>      tests/overlay/023.out |   8 ++++
>      tests/overlay/024     |  80 ++++++++++++++++++++++++++++++++++++++++
>      tests/overlay/024.out |   2 +
>      tests/overlay/025     |  85 ++++++++++++++++++++++++++++++++++++++++++
>      tests/overlay/025.out |   2 +
>      tests/overlay/026     |  99 ++++++++++++++++++++++++++++++
>     +++++++++++++++++++
>      tests/overlay/026.out |   5 +++
>      tests/overlay/027     |  87 +++++++++++++++++++++++++++++++++++++++++++
>      tests/overlay/027.out |   2 +
>      tests/overlay/028     |  80 ++++++++++++++++++++++++++++++++++++++++
>      tests/overlay/028.out |   2 +
>      tests/overlay/029     | 100 ++++++++++++++++++++++++++++++
>     ++++++++++++++++++++
>      tests/overlay/029.out |   5 +++
>      tests/overlay/group   |   8 ++++
>      17 files changed, 730 insertions(+)
>      create mode 100755 tests/overlay/022
>      create mode 100644 tests/overlay/022.out
>      create mode 100755 tests/overlay/023
>      create mode 100644 tests/overlay/023.out
>      create mode 100755 tests/overlay/024
>      create mode 100644 tests/overlay/024.out
>      create mode 100755 tests/overlay/025
>      create mode 100644 tests/overlay/025.out
>      create mode 100755 tests/overlay/026
>      create mode 100644 tests/overlay/026.out
>      create mode 100755 tests/overlay/027
>      create mode 100644 tests/overlay/027.out
>      create mode 100755 tests/overlay/028
>      create mode 100644 tests/overlay/028.out
>      create mode 100755 tests/overlay/029
>      create mode 100644 tests/overlay/029.out
> 
>     --
>     1.8.3.1
> 
>     --
>     To unsubscribe from this list: send the line "unsubscribe fstests" in
>     the body of a message to majordomo@vger.kernel.org
>     More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
