From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [RFC][PATCH 02/13] ovl: redirect dir by file handle on copy up
Date: Fri, 21 Apr 2017 18:29:08 +0300
Message-ID: <CAOQ4uxh33H8_kA2-o5bDADeNz=AgFah+HfFutdc3jh-GX7K7cA@mail.gmail.com>
References: <1492387183-18847-1-git-send-email-amir73il@gmail.com>
 <1492387183-18847-3-git-send-email-amir73il@gmail.com> <CAJfpegsiy9_-qmMhFRVq7L23WHq_f0HM4+gQQYeW06-3-guD8Q@mail.gmail.com>
 <CAOQ4uxgQ4naPLq2n2GBEyAL0qW=Pwm=Qkw4QX8nwiNmCESDoTA@mail.gmail.com>
 <CAOQ4uxgyqeAxMgewLhpOXQpdKMWRdiQxESZwpSacL1naAD75YA@mail.gmail.com> <CAJfpegsPZ5Ybbk_Xj36fySY83H0txM0-rOTRxnFpo=DFC9HYKA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f47.google.com ([209.85.218.47]:34266 "EHLO
        mail-oi0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1041362AbdDUQjb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 21 Apr 2017 12:39:31 -0400
In-Reply-To: <CAJfpegsPZ5Ybbk_Xj36fySY83H0txM0-rOTRxnFpo=DFC9HYKA@mail.gmail.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Al Viro <viro@zeniv.linux.org.uk>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>

On Fri, Apr 21, 2017 at 6:02 PM, Miklos Szeredi <miklos@szeredi.hu> wrote:
> On Thu, Apr 20, 2017 at 10:55 AM, Amir Goldstein <amir73il@gmail.com> wrote:
>
>> File handles are only unique for a single fs namespace.
>> Right now, the copy up stores the lower handle in overlay.fh
>> without storing lower layer number and/or lower fs device id.
>
> Hmm, would need to be careful with the security implications of
> decoding fh on the wrong fs.
>
>>
>> The overlay.fh format has a header with version and magic:
>> struct ovl_fh {
>>         unsigned char version;  /* 0 */
>>         unsigned char magic;    /* 0xfb */
>>
>> So we can easily extend this format later on to support non
>> same fs redirect_fh.
>>
>> That said, to answer your question, there is no disadvantage to
>> storing the lower handle for non-samefs case, there is only
>> a problem with lookup in the case of several lower layers
>> no on the same fs.
>
> Why?
>

Because decoding an fh takes a vfsmnt as input arg, looking up
by fh is implemented:

    for (i = 0; i < numlower; i++) {
          this = ovl_lookup_fh(lowerstack[i].mnt, d.fh);
          if (this == NULL)
               continue;
    }

and ovl_lookup_fh() even verifies ovl_dentry_under_mnt() for
accepting the decoded dentry.

So unless we are in the "same lower sb" case this lookup
can return a dentry from the wrong layer.

>> So we can actually relax the samefs constrain for redirect_fh
>> to exclude upper layer and specifically, we can always use redirect_fh
>> in the single lower layer case.
>>
>> There is one more advantage to storing overlay.fh unconditionally.
>> Even with multi non-samefs lower layers, the overlay.fh on upper
>> can be used to distinguish between "merge" and "pure" upper
>> for non dirs.
>>
>> I would like to extend the meaning of OVL_TYPE_MERGE
>> to represent an upper non-dir that has been copied up.
>> Patch #5 already takes the first step and sets numlower = 1
>> for non-dirs that have been copied up on samefs.
>>
>> The next steps would be:
>> 1. remove d_is_dir() check from ovl_path_type()
>>     BTW, can you please explain this comment.
>>     I don't understand how this could be:
>>
>>                 /*
>>                  * Non-dir dentry can hold lower dentry from previous
>>                  * location.
>>                  */
>>                 if (oe->numlower && d_is_dir(dentry))
>>                         type |= __OVL_PATH_MERGE;
>
> I guess the comment says, that when a non-dir is copied up it will
> have positive __upperdentry and a positive numlower (actually, always
> one).

Ok, I guess I wasn't sure what "previous location" was referring to
it implied rename.

>
> If you remove the d_is_dir() then it will change the meaning from
> "merge" to "copied up".  The two meanings are distinct: consider the
> ovl_clear_empty() case.  It starts with a merged dir and ends up with
> an opaque one.  But the opaque one is still the same object as the
> original, lower one, so both need to have the same overlay.fh
> attribute.
>

Well, technically, an opaque object should not have overlay.fh
but I see that it can happen with an unhashed just-deleted entry.
so yes, need to be able to make that distinction.

>>
>> 2. check merge_or_lower() in ovl_rename() also for non-dir case
>>     this will cause setting overlay.redirect on non-dir
>>     and then hardlinks could work better when copying layers
>>     even without reverse mapping and recovery
>>
>> 3. set __OVL_PATH_MERGE flag during lookup for non-samefs
>>     In non-samefs case, __OVL_PATH_MERGE may not always be
>>     deduced from numlower, so need to use my patch that add
>>     ovl_update_type() [1]
>
> So lets not confuse "merge" with "copied up".  The two are similar for
> directories, but not the same, and "merge" doesn't make sense for
> regular files.
>

It make sense if you consider that the overlay inode of non-dir is a merge
of the upper attributes and data and the lower ino (and maybe st_dev).

But it is a hack nonetheless, so I'll think up a new flag name for
COPIED_UP. suggestions are welcome.

Thanks,
Amir.
