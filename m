From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v2 00/20] Overlayfs inodes index
Date: Wed, 7 Jun 2017 17:58:18 +0300
Message-ID: <CAOQ4uxjptLTC_qX5RpcCAwQyyRCq+Y7RHuXThCN32oChZL50Kg@mail.gmail.com>
References: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f52.google.com ([209.85.218.52]:34743 "EHLO
        mail-oi0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751716AbdFGO6T (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 7 Jun 2017 10:58:19 -0400
In-Reply-To: <1496821884-5178-1-git-send-email-amir73il@gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Jun 7, 2017 at 10:51 AM, Amir Goldstein <amir73il@gmail.com> wrote:
> Miklos,
>
> This set is an independent series a top of current overlayfs-next.
> I yanked all the dependencies from previous postings (consistent d_ino,
> dir_lock, verify_lower) and included everything needed in this posting.
>
> This work introcuding the inodes index opt-in feature, which provides:
> - Hardlinks are not broken on copy up
> - Infrastructure for overlayfs NFS export
>
> Hardlink copy up tests including concurrent copy up of lower hardlinks
> are available on my xfstests dev branch [1].
>
> There are some more TODO items before this is ready for v4.13, but I'd
> love to hear what you think about the direction this has taken so far.
>
> Thanks,
> Amir.
>
> TODO:
> - Consistency of lower and upper hardlinks (*)
> - Cleanup stale and orphan index entries on mount (**)
> - Document the inodes index feature
>
> (*) When any lower hardlink has been copied up, we get the indexed
>     upper inode on lookup of all lower hardlinks and since they all
>     share the same overlay inode, they have the same 'realinode'.
>     Opening the lower hardlinks for read gives that lower inode
>     and not the indexed upper 'realinode'. The tests in [1] demostrate
>     this problem.

Miklos,

I have fix for the lower/upper hardlink inconsistency issue.
Pushed the patches to branch:
https://github.com/amir73il/linux/commits/ovl-hardlinks-rocopyup

It now passes all the xfstests hardlink copy up tests [1].
Note that you will need to use my unionmount-testsuite dev branch [2]
to test with inodes index enabled.
The one test that fails the constant inode verification on v4.12-rc1
(due to hardlink non constant ino) now passes:
./run --ov=1 --samefs rename-mass-5

Thanks,
Amir.

[1] https://github.com/amir73il/xfstests/commits/overlayfs-devel
[2] https://github.com/amir73il/unionmount-testsuite/commits/overlayfs-devel
