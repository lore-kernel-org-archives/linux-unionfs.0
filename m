From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: constant st_ino/st_dev for non-samefs case
Date: Tue, 23 May 2017 23:33:29 +0300
Message-ID: <CAOQ4uxh5anMdr7HbgCjP5v=nSC4y0gQzmq+MgD5O5P-fjmMf2g@mail.gmail.com>
References: <CAOQ4uxhJdyETb96yKr_bRes9OGEeHSOUAH=L4nfX3c2ryYD6Mw@mail.gmail.com>
 <4951608.hM2HNRSCh0@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f66.google.com ([209.85.218.66]:36287 "EHLO
        mail-oi0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1032053AbdEWUdb (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 16:33:31 -0400
Received: by mail-oi0-f66.google.com with SMTP id w138so29606781oiw.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 13:33:30 -0700 (PDT)
In-Reply-To: <4951608.hM2HNRSCh0@localhost.localdomain>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Tue, May 23, 2017 at 4:19 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Tuesday, May 23, 2017 6:27:42 PM IST Amir Goldstein wrote:
>> On Wed, May 17, 2017 at 3:46 PM, Chandan Rajendra
>> <chandan@linux.vnet.ibm.com> wrote:
>> > On Wednesday, May 17, 2017 5:56:31 PM IST Amir Goldstein wrote:
>> >> On Wed, May 17, 2017 at 2:42 PM, Chandan Rajendra
>>
>> >> There is actually one task that should be very simple to do and can also
>> >> bring large benefit for many users.
>> >>
>> >> In his pull request for kernel 4.12 Miklos writes:
>> >> "The biggest part of this is making st_dev/st_ino on the overlay behave like a
>> >> normal filesystem ... future work will move the general case towards more sane
>> >> behavior."
>> >> https://marc.info/?l=linux-unionfs&m=149442365202823&w=2
>> >>
>> >> The work towards constant st_dev/st_ino for the general case is not within my
>> >> immediate scope of interest, but it shouldn't be hard. The basic idea was
>> >> explained by  Miklos here:
>> >> https://marc.info/?l=linux-unionfs&m=149259338809700&w=2
>> >>
>> > Amir, I will work on this task. Thanks for the guidance.
>> >
>>
>> Hi Chandan,
>>
>> Were you able to figure out the scope of the task?
>> Or didn't get around to it yet?
>
> Hi Amir,
>
> I spent time understanding current overlayfs code. I am now starting to
> work on the problem statement.
>
> I should be able to post the patches to the mailing list by the end of
> this week.
>
...
>>
>> Please let me know if you intend to work on this soon, because I may be
>> working on some parts of this task for a different feature.

Chandan,

My apologies for biting into your task, but as I wrote, I needed some parts
for another feature, so implemented partial non-samefs support [1].
At least one of the 2 "relax same fs" patches was not as trivial as I indented
for your task to be.

You still need to implement this part:
"The only extra thing needed compared to the samefs case is the allocation
of dummy device numbers for lower layers."

I also fixes unionmount-testsuite to check constant inode for non samefs [2].

The problem now is that all the test pass, although, as I wrote, I only
implemented partial support for non samefs. This means that the test coverage
for constant st_ino/st_dev is insufficient to validate the results of your task.
Which is good, because it will give you an opportunity to enhance the tests :)

It would be great if you could add validation to the fact that the
overlay st_ino/
st_dev pair is different from the underlying inode st_ino/st_dev.
That is not the case with upstream overlayfs and that is not the case with
my partial work on non same fs constant st_ino.

A new overlay xfstest, along the lines of overlay/017 that validates
the uniqueness of st_ino/st_dev would also be a good idea.

Thanks,
Amir.

[1] https://github.com/amir73il/linux/commits/ovl-constino
[2] https://github.com/amir73il/unionmount-testsuite/commits/ovl-constino
