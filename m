From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH V2] ovl: Allocate anonymous devs for lowerdirs
Date: Tue, 27 Jun 2017 12:04:19 +0300
Message-ID: <CAOQ4uxi3Ebb-8a-yYkGgs+R3fZ=wXE52+Hvxe=3-MMq1LX3tFA@mail.gmail.com>
References: <20170623110118.19975-1-chandan@linux.vnet.ibm.com>
 <CAOQ4uxjf-MUQTisMHL96Ao3P+NXRG5QnJmmd0iptcgyYGB72=Q@mail.gmail.com> <2369642.ypcN4zZqWi@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f67.google.com ([209.85.218.67]:35238 "EHLO
        mail-oi0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752161AbdF0JEU (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 27 Jun 2017 05:04:20 -0400
Received: by mail-oi0-f67.google.com with SMTP id l130so1872298oib.2
        for <linux-unionfs@vger.kernel.org>; Tue, 27 Jun 2017 02:04:20 -0700 (PDT)
In-Reply-To: <2369642.ypcN4zZqWi@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Tue, Jun 27, 2017 at 10:31 AM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Friday, June 23, 2017 7:04:57 PM IST Amir Goldstein wrote:
>> On Fri, Jun 23, 2017 at 2:01 PM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > For stat(2) on lowerdir non-dir entries in non-samefs case, this commit
>> > provides unique values for st_dev. The unique values are obtained by
>> > allocating anonymous bdevs for each of the lowerdirs in the overlayfs
>> > instance.
>> >
>> > Signed-off-by: Chandan Rajendra <chandan@linux.vnet.ibm.com>
>> > ---
>>
>> Reviewed-by: Amir Goldstein <amir73il@gmail.com>
>> Tested-by: Amir Goldstein <amir73il@gmail.com>
>>
>> Miklos,
>>
>> I re-created the branch ovl-constino [1] on top of ovl-hardlinks and without
>> the consistent dino patches.
>>
>> Applied Chandan's patch and resolved conflicts with my patches.
>> Then, applied my patch to relax constant st_ino  for non-samefs on stat(2).
>>
>> Mutilated unionmount-testsuite layers check [2] to get over the unexpected
>> pseudo dev and now tests pass for non samefs including constant ino
>> verification and persistent ino verification for non-dir.
>>
>> Chandan,
>>
>> If you can fix the mutilated unionmount-testsuite check_layer(), that would be
>> nice.
>>
>
> Amir,
>
> In check_layer() we have the following,
>
>             # TODO: for non-samefs, check file dev matches pseudo dev
>             # and that pseduo dev != real dev
>             raise TestError(name + ": File on unexpected layer")
>
> "check file dev matches pseudo dev" ... To do this we would have to
> have the list of pseudo dev ids for each of the lowerdirs.  One crude
> way of getting such a list would be to create files having names with
> a known prefix under each of the lowerdirs before mounting the
> overlayfs instance.  After mounting the overlayfs instance we could do
> a stat(2) on $overlay_mount/tempfile[i] to get the pseudo dev ids.
>
> These pseudo dev ids can then be used in check_layer().
>
> Please let me know your views on this.
>

I think that "check file dev matches pseudo dev" part is probably not worth
the effort.

Better concentrate on "pseduo dev != real dev" part. real dev is already
recorded (note_lower_fs/note_upper_fs) so it should be easier.
Please go over the check_layer tests and specifically the changes I've
made to them. It's possible that the tests could be improved also for the
samefs case (i.e. verify that in samefs st_dev is always overlay dev).

BTW, I just force push the ovl-constino unionmount branch to include
an opt-in run option --verify.
Without this option, constant ino is not checked at all.
This is so older kernels could still be tested with latests unionmount
testsuite.
Please rebase.

Thanks,
Amir.
