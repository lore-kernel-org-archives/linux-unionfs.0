From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Fri, 30 Jun 2017 17:50:19 +0300
Message-ID: <CAOQ4uxh=3poJ=TDi5jj2xrb68xvLPTdv+NzoUX=dUDDcGK0D0w@mail.gmail.com>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com>
 <2369642.ypcN4zZqWi@localhost.localdomain> <2041782.HUJ34Am32x@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:36154 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752054AbdF3OuZ (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 30 Jun 2017 10:50:25 -0400
Received: by mail-oi0-f67.google.com with SMTP id n2so5125731oig.3
        for <linux-unionfs@vger.kernel.org>; Fri, 30 Jun 2017 07:50:25 -0700 (PDT)
In-Reply-To: <2041782.HUJ34Am32x@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Fri, Jun 30, 2017 at 1:58 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Tuesday, June 27, 2017 1:01:17 PM IST Chandan Rajendra wrote:
>> On Friday, June 23, 2017 7:04:57 PM IST Amir Goldstein wrote:
>> > On Fri, Jun 23, 2017 at 2:01 PM, Chandan Rajendra
>> > <chandan@linux.vnet.ibm.com> wrote:
>> > > For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
>> > > provides unique values for st_dev. The unique values are obtained by
>> > > allocating anonymous bdevs for each of the lowerdirs in the overlayfs
>> > > instance.
>> > >
>> > > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> > > ---
>> >
>> > Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> > Tested-by: Amir Goldstein <amir73il@gmail.com>
>> >
>> > Miklos,
>> >
>> > I re-created the branch ovl-constino [1] on top of ovl-hardlinks and without
>> > the consistent dino patches.
>> >
>> > Applied Chandan's patch and resolved conflicts with my patches.
>> > Then, applied my patch to relax constant st_ino  for non-samefs on stat(2).
>> >
>> > Mutilated unionmount-testsuite layers check [2] to get over the unexpected
>> > pseudo dev and now tests pass for non samefs including constant ino
>> > verification and persistent ino verification for non-dir.
>> >
>> > Chandan,
>> >
>> > If you can fix the mutilated unionmount-testsuite check_layer(), that would be
>> > nice.
>> >
>>
>
> Hi Amir,
>
> In dentry.created(), we have
>
>         self.__upper = on_upper or not inode or inode.filetype() == "d"
>
> Do you happen to know why we mark the dentry as being present on the upperdir
> filesystem when "inode" evaluates to false?

I don't know why that was done this way, but IIUC, only way for inode
to be None is by passing None as filetype to record_file.

>
> Consider the case of /lowerdir/a/foo101 file being created in
> set_up.py. ctx.record_file() ends up creating a new 'dentry' object with no
> inode associated with it. Hence self.__upper is set to the value True. Isn't
> this incorrect since the file foo101 is actually being created on lowerdir?

IIUC, self.__upper will only be true for no_foo and no_dir, which are
created with filetype None.

>
> I added the following new test scenario to check_layer() code,
>
>    elif dentry.on_upper() and not self.config().is_samefs() and dev != self.upper_fs():
>           raise TestError(name + ": Upperdir file has incorrect dev id")
>
> In the above code snippet, dentry.on_upper() incorrectly evaluates to True and
> hence we end up raising an exception.
>
> Maybe dentry.created should have the following statement instead,
>
>      self.__upper = on_upper or (inode and inode.filetype() == "d")

That looks correct to me.
That change will only make a difference for dentries that are
dentry.is_negative(),
but this use case is already checked above in check_layer() anyway.

Thanks,
Amir.
