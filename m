From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH v3] ovl: Sync upper dirty data when sync overlayfs
Date: Tue, 28 Nov 2017 16:58:48 +0200
Message-ID: <CAOQ4uxjVekor=Bk26=OS4E2=L8+qMUw08nsY_Bn=iDsLSs6Dcg@mail.gmail.com>
References: <1511872768-12759-1-git-send-email-cgxu@mykernel.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yb0-f172.google.com ([209.85.213.172]:36988 "EHLO
        mail-yb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753128AbdK1O6t (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 28 Nov 2017 09:58:49 -0500
Received: by mail-yb0-f172.google.com with SMTP id 5so43415ybp.4
        for <linux-unionfs@vger.kernel.org>; Tue, 28 Nov 2017 06:58:49 -0800 (PST)
In-Reply-To: <1511872768-12759-1-git-send-email-cgxu@mykernel.net>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chengguang Xu <cgxu@mykernel.net>
Cc: Miklos Szeredi <miklos@szeredi.hu>, overlayfs <linux-unionfs@vger.kernel.org>

On Tue, Nov 28, 2017 at 2:39 PM, Chengguang Xu <cgxu@mykernel.net> wrote:
> Executes filesystem sync or umount on overlayfs,

When executing...

> dirty data does not be synced as expected on upper filesystem.

...does not get synced...

> This patch fixes sync filesystem method to keep data consistency
> for overlayfs.
>
> Signed-off-by: Chengguang Xu <cgxu@mykernel.net>
>
> ---
>

Chengguang,

This patch looks fine, but it is not based on overlayfs-next nor on master.
I guess by "mainline" you meant latest release or something.
Please rebase V4 on overlayfs-next from Miklos' tree.

I enhanced my origin syncfs test to check for syncing of upper files:
https://github.com/amir73il/overlayfs/blob/master/tests/xfs_syncfs.sh

Without your fix, the upper file delalloc blocks are not flushed after syncfs,
but only after fsync. With your fix delalloc blacks are flushed by syncfs.

Can you take the task to make this simple test into an xfstest?
If you need help finding your way around xfstests, I can help you with that.
You do not need the xfs specific parts of the test, only the generic delalloc
part.

I think it is best to make a generic/* test (i.e. not fs specific), which tests
flushing of delalloc blocks on sync/syncfs/fsync for fs that support delalloc,
but it may also make sense to have an overlay/* specific regression test for
syncfs. We can discuss those details after you post a test.

Thanks,
Amir.
