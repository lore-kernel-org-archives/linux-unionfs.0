From: ebiederm@xmission.com (Eric W. Biederman)
Subject: Re: [PATCH v3 1/6] vfs: create vfs helper vfs_tmpfile()
Date: Thu, 09 Mar 2017 11:31:08 -0600
Message-ID: <87tw72fjc3.fsf@xmission.com>
References: <1484588765-9397-1-git-send-email-amir73il@gmail.com>
        <1484588765-9397-2-git-send-email-amir73il@gmail.com>
        <CAJfpegsDzNot=z8oP7DecuXtNkYPYOejDWWXs6KjD6=Le=Wohg@mail.gmail.com>
        <20170219032743.GH29622@ZenIV.linux.org.uk>
        <CAJfpegsLHq8qhv+nBrgF3f0tM_LDLoOk1vTxpsdnwnc78hcppA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from out03.mta.xmission.com ([166.70.13.233]:50323 "EHLO
        out03.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754508AbdCISFG (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 9 Mar 2017 13:05:06 -0500
In-Reply-To: <CAJfpegsLHq8qhv+nBrgF3f0tM_LDLoOk1vTxpsdnwnc78hcppA@mail.gmail.com>
        (Miklos Szeredi's message of "Thu, 9 Mar 2017 12:13:29 +0100")
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Amir Goldstein <amir73il@gmail.com>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel@vger.kernel.org

Miklos Szeredi <miklos@szeredi.hu> writes:

> On Sun, Feb 19, 2017 at 4:27 AM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>> On Mon, Jan 16, 2017 at 08:47:32PM +0100, Miklos Szeredi wrote:
>>
>>> > +                          umode_t mode, int open_flag)
>>> > +{
>>> > +       static const struct qstr name = QSTR_INIT("/", 1);
>>> > +       struct dentry *child = NULL;
>>> > +       struct inode *inode;
>>> > +       int error;
>>> > +
>>> > +       /* we want directory to be writable */
>>> > +       error = inode_permission(dir, MAY_WRITE | MAY_EXEC);
>>>
>>> This is not in the scope of this patch, but shoudln't we be using
>>> may_create() here?   Or at least a variant without the audit thing...
>>>
>>> Al?
>>
>> may_create() expects directory + child dentry; here we have only parent.
>> IS_DEADDIR is rather pointless here - directory is not locked, for
>> starters, so rmdir might happen right under you.  Or right after you've
>> returned from your function, for that matter.  userns checks...
>> FWIW, no such checks are done in ->atomic_open() paths, so I'm not sure
>> how much are those worth...
>
> Eric would know since he added those checks.

Unless I am missing something the atomic_open path was fixed this merge
window when may_o_create was fixed.  Missing places any place where
we create files is an oversight.

The point of those checks is when we have a filesystem mounted by root
in a user namespace like tmpfs or hopefully soon fuse that it will let
the vfs filter out uids and gids that the filesystem does not know how
to map thus has no hope of understanding.  Since the filesystem does not
care about the uids and gids odds are filesystems won't be bothered to
test or deal with that case and corruption will result.  As far as I can
see not filtering out umappable uids and gids is just laying a trap for
filesystem developers.

Which means vfs_tmpfile is definitely something that needs to be patched
to verify that the current_fsuid and current_fsgid are valid from
the filesystems point of view.

At the same time this only matters for filesystems that set
FS_USERNS_MOUNT and implement tmpfile.  Which right now is tmpfs.  Given
that tmpfs actually only uses the vfs inode, there are no corruption or
other filesystem misbehaviors right now.  So it won't kill us if we
don't fix this for 4.11.

I am hoping things are far enough along that we can merge the patches to
fuse that make it safe to set FS_USER_NS for 4.12-rc1, and have truly
unprivileged fuse mounts.  At which point this will matter more.

Eric
