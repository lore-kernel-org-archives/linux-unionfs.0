From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Thu, 20 Apr 2017 11:55:57 +0300
Message-ID: <CAOQ4uxgyqeAxMgewLhpOXQpdKMWRdiQxESZwpSacL1naAD75YA@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-3-git-send-email-amir73il@gmail.com> <CAJfpegsiy9_-qmMhFRVq7L23WHq_f0HM4+gQQYeW06-3-guD8Q@mail.gmail.com>
 <CAOQ4uxgQ4naPLq2n2GBEyAL0qW=Pwm=Qkw4QX8nwiNmCESDoTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:34516 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S943238AbdDTIz6 (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 20 Apr 2017 04:55:58 -0400
In-Reply-To: <CAOQ4uxgQ4naPLq2n2GBEyAL0qW=Pwm=Qkw4QX8nwiNmCESDoTA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Wed, Apr 19, 2017 at 6:27 PM, Amir Goldstein <amir73il@gmail.com> wrote:
> On Wed, Apr 19, 2017 at 6:16 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
>> On Mon, Apr 17, 2017 at 1:59 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>>> When mounted with mount option redirect_dir=fh,
>>> every copy up of lower directory stores the lower
>>> dir file handle in overlay.fh xattr of upper dir.
>>
>> Is there a disadvantage to doing this unconditionally? (Same goes for patch 4)
>>
>> Is there a disadvantage to doing this even for the non-samefs case?
>>
>
> Not that I can think of. It's just that all the features that stable
> inode brings
> to the table only work for same_fs right now, but we can store overlay.fh
> anyway.
>

Sorry, I remembered what the reason was.

File handles are only unique for a single fs namespace.
Right now, the copy up stores the lower handle in overlay.fh
without storing lower layer number and/or lower fs device id.

The overlay.fh format has a header with version and magic:
struct ovl_fh {
        unsigned char version;  /* 0 */
        unsigned char magic;    /* 0xfb */

So we can easily extend this format later on to support non
same fs redirect_fh.

That said, to answer your question, there is no disadvantage to
storing the lower handle for non-samefs case, there is only
a problem with lookup in the case of several lower layers
no on the same fs.

So we can actually relax the samefs constrain for redirect_fh
to exclude upper layer and specifically, we can always use redirect_fh
in the single lower layer case.

There is one more advantage to storing overlay.fh unconditionally.
Even with multi non-samefs lower layers, the overlay.fh on upper
can be used to distinguish between "merge" and "pure" upper
for non dirs.

I would like to extend the meaning of OVL_TYPE_MERGE
to represent an upper non-dir that has been copied up.
Patch #5 already takes the first step and sets numlower = 1
for non-dirs that have been copied up on samefs.

The next steps would be:
1. remove d_is_dir() check from ovl_path_type()
    BTW, can you please explain this comment.
    I don't understand how this could be:

                /*
                 * Non-dir dentry can hold lower dentry from previous
                 * location.
                 */
                if (oe->numlower && d_is_dir(dentry))
                        type |= __OVL_PATH_MERGE;

2. check merge_or_lower() in ovl_rename() also for non-dir case
    this will cause setting overlay.redirect on non-dir
    and then hardlinks could work better when copying layers
    even without reverse mapping and recovery

3. set __OVL_PATH_MERGE flag during lookup for non-samefs
    In non-samefs case, __OVL_PATH_MERGE may not always be
    deduced from numlower, so need to use my patch that add
    ovl_update_type() [1]

[1] https://marc.info/?l=linux-unionfs&m=149079818122017&w=2

Amir.
