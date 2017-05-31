From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 2/2] ovl: get exclusive ownership on upper/work dirs
Date: Wed, 31 May 2017 16:05:21 +0300
Message-ID: <CAOQ4uxhFCsFECtbof50Xq9nouR8vooUknOzOGvVzG_q7oyx5NQ@mail.gmail.com>
References: <1495533033-22367-1-git-send-email-amir73il@gmail.com>
 <1495533033-22367-3-git-send-email-amir73il@gmail.com> <CAJfpegsZWjPhJA==FF7YAw0XtCyhVcn1YtuPep+od6h8f=0DOA@mail.gmail.com>
 <CAOQ4uxidR+Rua_GatJK=WR7Yk=UiD9j8ygT+4BG_w=BYcP1u3Q@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f65.google.com ([209.85.218.65]:36715 "EHLO
        mail-oi0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751011AbdEaNFX (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Wed, 31 May 2017 09:05:23 -0400
In-Reply-To: <CAOQ4uxidR+Rua_GatJK=WR7Yk=UiD9j8ygT+4BG_w=BYcP1u3Q@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, May 31, 2017 at 3:47 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, May 31, 2017 at 1:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Tue, May 23, 2017 at 11:50 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> Bad things can happen if several concurrent overlay mounts try to
>>> use the same upperdir path and/or workdir path.
>>>
>>> Try to get the 'inuse' advisory lock on upper and work dir.
>>> Fail mount if another overlay mount instance or another user
>>> holds the 'inuse' lock.
>>>
>>> Note that this provides no protection for concurrent overlay
>>> mount that use overlapping (i.e. descendant) upper dirs or
>>> work dirs.
>>>
>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>> ---
...
>>> @@ -407,6 +437,14 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
>>>                         if (retried)
>>>                                 goto out_dput;
>>>
>>> +                       /*
>>> +                        * We have parent i_mutex, so this test is race free
>>> +                        * w.r.t. ovl_dir_lock() below by another overlay mount.
>>> +                        */
>>> +                       err = -EBUSY;
>>> +                       if (inode_inuse(work->d_inode))
>>> +                               goto out_dput;
>>> +
>>
>> Why not lock it here?

Because we are locking 'work' inode, not workdir
and the 'work' inode is about to be zapped and replaced with a new
work inode on retry.
Are you suggesting to move the inuse lock to the workdir inode? doable.
I guess I choose to lock workdir/work because of the may_delete
protection it provides,
but you questioned that part anyway.

>>
>>>                         retried = true;
>>>                         ovl_workdir_cleanup(dir, mnt, work, 0);
>>>                         dput(work);
>>> @@ -446,6 +484,14 @@ static struct dentry *ovl_workdir_create(struct vfsmount *mnt,
>>>                 inode_unlock(work->d_inode);
>>>                 if (err)
>>>                         goto out_dput;
>>> +
>>> +               /*
>>> +                * Protect our work dir from being deleted/renamed and from
>>> +                * being reused by another overlay mount.
>>> +                */
>>> +               err = -EBUSY;
>>> +               if (!ovl_dir_lock(work))
>>> +                       goto out_dput;
>>>         }
>>>  out_unlock:
>>>         inode_unlock(dir);
>>> @@ -849,6 +895,16 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>>                         pr_err("overlayfs: failed to clone upperpath\n");
>>>                         goto out_put_lowerpath;
>>>                 }
>>> +               /*
>>> +                * Protect our upper dir from being deleted/renamed and from
>>> +                * being reused by another overlay mount.
>>> +                */
>>> +               err = -EBUSY;
>>> +               if (!ovl_dir_lock(upperpath.dentry)) {
>>> +                       pr_err("overlayfs: upperdir in-use by another overlay mount?\n");
>>> +                       goto out_put_upper_mnt;
>>> +               }
>>> +
>>>                 /* Don't inherit atime flags */
>>>                 ufs->upper_mnt->mnt_flags &= ~(MNT_NOATIME | MNT_NODIRATIME | MNT_RELATIME);
>>>
>>> @@ -857,6 +913,10 @@ static int ovl_fill_super(struct super_block *sb, void *data, int silent)
>>>                 ufs->workdir = ovl_workdir_create(ufs->upper_mnt, workpath.dentry);
>>>                 err = PTR_ERR(ufs->workdir);
>>>                 if (IS_ERR(ufs->workdir)) {
>>> +                       if (err == -EBUSY) {
>>> +                               pr_err("overlayfs: workdir in-use by another overlay mount?\n");
>>
>> Why ask?  Aren't we sure?
>>

So I think ovl_workdir_cleanup() can also return EBUSY if one of the
dirs/files inside
it are used as a mount point or a dir used as a rootdir.
Also, since inode_inuse() is not overlay specific, cannot rule out the
option of some
other code setting inode_inuse on workdir, thus the "?".
I don't mind dropping the "?" though - perhaps phrase the error more
generically:
    pr_err("overlayfs: workdir is in-use by another mount\n");

The man page for mount(2) has a broad phrasing for EBUSY -
"target is still busy (... etc.)".
