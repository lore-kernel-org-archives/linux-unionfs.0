Return-Path: <amir73il@gmail.com>
MIME-Version: 1.0
In-Reply-To: <CAJfpegvJN_CDHcGw7sXbAgE_a3r0V5hC70COMuv6Z6o4yef=NA@mail.gmail.com>
References: <1526379972-20923-1-git-send-email-amir73il@gmail.com>
 <1526379972-20923-3-git-send-email-amir73il@gmail.com> <CAJfpegs3AC6zTeHYmn0r9dNTHhf=jRpkkkyOegB+r=CDZCyk4w@mail.gmail.com>
 <CAOQ4uxiX3tNDV+aT1BFei4HReXybdTBgGQHGss1VOF5d0HX9VA@mail.gmail.com> <CAJfpegvJN_CDHcGw7sXbAgE_a3r0V5hC70COMuv6Z6o4yef=NA@mail.gmail.com>
From: Amir Goldstein <amir73il@gmail.com>
Date: Wed, 16 May 2018 16:46:29 +0300
Message-ID: <CAOQ4uxh4Ad3G3w+98hsdHaY=_9tBzm7w9jOgAtLk8r+RgZU8OA@mail.gmail.com>
Subject: Re: [PATCH v3 2/4] ovl: relax WARN_ON() real inode attributes mismatch
Content-Type: text/plain; charset="UTF-8"
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, Vivek Goyal <vgoyal@redhat.com>, overlayfs <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>
List-ID: <linux-unionfs@vger.kernel.org>

On Wed, May 16, 2018 at 2:18 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Wed, May 16, 2018 at 1:06 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>> On Wed, May 16, 2018 at 1:29 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>>> On Tue, May 15, 2018 at 12:26 PM, Amir Goldstein <amir73il@gmail.com> wrote:
>>>> Overlayfs should cope with online changes to underlying layer
>>>> without crashing the kernel, which is what xfstest overlay/019
>>>> checks.
>>>>
>>>> This test may sometimes trigger WARN_ON() in ovl_create_or_link()
>>>> when linking an overlay inode that has been changed on underlying
>>>> layer.
>>>>
>>>> Replace those WARN_ON() with pr_warn_ratelimited() to prevent
>>>> test from failing and because this is more appropriate to the
>>>> use case.
>>>>
>>>> Signed-off-by: Amir Goldstein <amir73il@gmail.com>
>>>> ---
>>>>  fs/overlayfs/dir.c | 14 +++++++++++---
>>>>  1 file changed, 11 insertions(+), 3 deletions(-)
>>>>
>>>> diff --git a/fs/overlayfs/dir.c b/fs/overlayfs/dir.c
>>>> index 62e6733b755c..25b339278684 100644
>>>> --- a/fs/overlayfs/dir.c
>>>> +++ b/fs/overlayfs/dir.c
>>>> @@ -525,9 +525,17 @@ static int ovl_create_or_link(struct dentry *dentry, struct inode *inode,
>>>>         if (!err) {
>>>>                 struct inode *realinode = d_inode(ovl_dentry_upper(dentry));
>>>>
>>>> -               WARN_ON(inode->i_mode != realinode->i_mode);
>>>> -               WARN_ON(!uid_eq(inode->i_uid, realinode->i_uid));
>>>> -               WARN_ON(!gid_eq(inode->i_gid, realinode->i_gid));
>>>> +               if (inode->i_mode != realinode->i_mode ||
>>>> +                   !uid_eq(inode->i_uid, realinode->i_uid) ||
>>>> +                   !gid_eq(inode->i_gid, realinode->i_gid)) {
>>>> +                       pr_warn_ratelimited("overlayfs: real inode attributes mismatch (%pd2, %o.%u.%u != %o.%u.%u).\n",
>>>> +                               dentry, inode->i_mode,
>>>> +                               from_kuid(&init_user_ns, inode->i_uid),
>>>> +                               from_kgid(&init_user_ns, inode->i_gid),
>>>> +                               realinode->i_mode,
>>>> +                               from_kuid(&init_user_ns, realinode->i_uid),
>>>> +                               from_kgid(&init_user_ns, realinode->i_gid));
>>>> +               }
>>>
>>> How about just dropping the warnings altogether.  They didn't discover
>>> an issue with the code, just something normal, so IMO we should just
>>> get rid of them.
>>>
>>

I guess it would be wise to leave that check in at least for the case we end
up using a cached inode instead of the new inode we created...

Thanks,
Amir.
