From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: ACL test failures on overlayfs over tmpfs
Date: Mon, 31 Oct 2016 17:12:26 +0200
Message-ID: <CAOQ4uxj82NLb_dJ=UDMdvcWY_GpAqCe0Hq5vWF0E23Bdago3wg@mail.gmail.com>
References: <CAOQ4uxgFBZumexGm0qtN70qwmYraxMMEzHgSLHHzT1ZYUnn-hw@mail.gmail.com>
 <20161031135144.GB8412@veci.piliscsaba.szeredi.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:36345 "EHLO
        mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943880AbcJaPM3 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Mon, 31 Oct 2016 11:12:29 -0400
Received: by mail-wm0-f68.google.com with SMTP id c17so18844764wmc.3
        for <linux-unionfs@vger.kernel.org>; Mon, 31 Oct 2016 08:12:28 -0700 (PDT)
In-Reply-To: <20161031135144.GB8412@veci.piliscsaba.szeredi.hu>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Andreas Gruenbacher <agruenba@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, linux-unionfs@vger.kernel.org

On Mon, Oct 31, 2016 at 3:51 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Sun, Oct 30, 2016 at 03:35:04PM +0200, Amir Goldstein wrote:
>> Hi guys,
>>
>> I recently learned about a set of ACL tests that were added
>> by Tuxera to pjdtests. I pushed a branch to my github with
>> some fixes to build and run on recent Linux:
>>
>> https://github.com/amir73il/pjdfstest.git #tuxera-acl-tests
>>
>> While the set of ACL tests pass on overlayfs over xfs/ext4
>> some fail on overlayfs over tmpfs.
>> Below is a snippet from one of the failed tests.
>> The test setup grants read-only access to a 'foreign' user
>> and write-only access to a 'foreign' group (i.e. not the owner).
>>
>> The return value from the 4 open statements at the bottom
>> of the test are correct when run on tmpfs/xfs/ext4 and they
>> are correct when run on overlayfs over xfs/ext4.
>>
>> However, when running the same test on overlayfs over tmpfs
>> (both lower and upper) all 4 open statements fail with EACCESS
>> as if the ACL permission grant for the foreign user/group are skipped.
>>
>> I tried following the permission checks code and got lost.
>>
>> Can you shed some light on this for me?
>
> Following patch should fix it.
>

Confirmed

> Pushed, with a bunch of other fixes, to #overlayfs-linus.
>
> Thanks,
> Miklos
>
> ---
> From: Miklos Szeredi <mszeredi@redhat.com>
> Subject: ovl: fix get_acl() on tmpfs
>
> tmpfs doesn't have ->get_acl() because it only uses cached acls.
>
> This fixes the acl tests in pjdfstest when tmpfs is used as the upper layer
> of the overlay.
>
> Reported-by: Amir Goldstein <amir73il@gmail.com>
> Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
> ---
>  fs/overlayfs/inode.c |    3 ---
>  1 file changed, 3 deletions(-)
>
> --- a/fs/overlayfs/inode.c
> +++ b/fs/overlayfs/inode.c
> @@ -270,9 +270,6 @@ struct posix_acl *ovl_get_acl(struct ino
>         if (!IS_ENABLED(CONFIG_FS_POSIX_ACL) || !IS_POSIXACL(realinode))
>                 return NULL;
>
> -       if (!realinode->i_op->get_acl)
> -               return NULL;
> -
>         old_cred = ovl_override_creds(inode->i_sb);
>         acl = get_acl(realinode, type);
>         revert_creds(old_cred);
