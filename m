Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <20180404122924.GB10495@redhat.com>
References: <20180329193854.13814-1-vgoyal@redhat.com> <20180329193854.13814-28-vgoyal@redhat.com>
 <CAOQ4uxhU6U=PRXod37xNJPC0B081CrLtuVBmOECnTG7j6VWn+g@mail.gmail.com> <20180404122924.GB10495@redhat.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 4 Apr 2018 15:51:37 +0300
Message-ID: <CAOQ4uxjQTtgXyohfz+_krgCX88jC8Bxt02RaYfN6FC=4TPcxJw@mail.gmail.com>
Subject: Re: [PATCH v13 27/28] ovl: Verify a data dentry has been found for
 metacopy inode
Content-Type: text/plain; charset="UTF-8"
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, Apr 4, 2018 at 3:29 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Fri, Mar 30, 2018 at 01:53:24PM +0300, Amir Goldstein wrote:
>> On Thu, Mar 29, 2018 at 10:38 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > If we find a upper metacopy inode, make sure we also found associated data
>> > dentry in lower. Otherwise copy up operation later will fail.
>> >
>> > There are two cases where this can happen. First case is that somehow
>> > data file was removed from lower layer. Other case is that REDIRECT
>> > xattr was removed due to copy up of file on another cpu (when inode is
>> > shared between two dentries) and hence ovl_lookup() could not find the
>> > correct dentry.
>> >
>>
>> Remind me again why we remove REDIRECT xattr?
>> Is it a must for functionality or just for being boy scouts?
>> I would prefer to avoid having to deal with races of this sort.
>> You can cleanup REDIRECT for non-dir that is not metacopy
>> on lookup when finding a I_NEW inode.
>
> Ok, thinking more about it. If we were to clean REDIRECT on lookup when
> finding I_NEW inode, that means we will have to always do
> vfs_removexattr(OVL_XATTR_REDIRECT) on all non-metacopy non-dir files.
> That does not sound like a very good idea. Its unnecessary overhead in
> lookup path.
>
> IOW, I think removing REDIRECT and doing appropriate locking around
> ovl_inode->redirect is probably better.
>

Here is what I propose.
During lookup, you anyway check REDIRECT and check METACOPY
on upper and then call ovl_get_inode() with upper redirect and upper
metacopy information.

IF this is a new inode AND both REDIRECT and METACOPY were
found on upper THEN it is safe to remove REDIRECT xattr.

Maybe I am missing something, but I don't see where the extra overhead
is, beyond the overhead already there for metacopy enabled lookup.

OTOH, I don't see what cleaning REDIRECT gets us in the first place.
During lookup, REDIRECT does not affect non metacopy non-dir,
because we skip ovl_check_redirect().
REDIRECT could actually be useful for reconstructing ORIGIN xattr
and index after copying layers, so not sure its a good thing to remove it
at all. After all, redirects are pretty rare as it is.

Thanks,
Amir.
