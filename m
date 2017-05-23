From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: constant st_ino/st_dev for non-samefs case
Date: Tue, 23 May 2017 15:57:42 +0300
Message-ID: <CAOQ4uxhJdyETb96yKr_bRes9OGEeHSOUAH=L4nfX3c2ryYD6Mw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-oi0-f49.google.com ([209.85.218.49]:36066 "EHLO
        mail-oi0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S967502AbdEWM5o (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Tue, 23 May 2017 08:57:44 -0400
Received: by mail-oi0-f49.google.com with SMTP id h4so199658255oib.3
        for <linux-unionfs@vger.kernel.org>; Tue, 23 May 2017 05:57:43 -0700 (PDT)
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Chandan Rajendra <chandan@linux.vnet.ibm.com>
Cc: Miklos Szeredi <miklos@szeredi.hu>, "linux-unionfs@vger.kernel.org" <linux-unionfs@vger.kernel.org>

On Wed, May 17, 2017 at 3:46 PM, Chandan Rajendra
<chandan@linux.vnet.ibm.com> wrote:
> On Wednesday, May 17, 2017 5:56:31 PM IST Amir Goldstein wrote:
>> On Wed, May 17, 2017 at 2:42 PM, Chandan Rajendra

>> There is actually one task that should be very simple to do and can also
>> bring large benefit for many users.
>>
>> In his pull request for kernel 4.12 Miklos writes:
>> "The biggest part of this is making st_dev/st_ino on the overlay behave like a
>> normal filesystem ... future work will move the general case towards more sane
>> behavior."
>> https://marc.info/?l=linux-unionfs&m=149442365202823&w=2
>>
>> The work towards constant st_dev/st_ino for the general case is not within my
>> immediate scope of interest, but it shouldn't be hard. The basic idea was
>> explained by  Miklos here:
>> https://marc.info/?l=linux-unionfs&m=149259338809700&w=2
>>
> Amir, I will work on this task. Thanks for the guidance.
>

Hi Chandan,

Were you able to figure out the scope of the task?
Or didn't get around to it yet?

I forgot to mention that I have written tests to cover constant inode
across copy up.
If you have never used unionmount-testsuite before, now would be a good time to
start.

You should pull my master branch from github:
https://github.com/amir73il/unionmount-testsuite

Just do:
# cd unionmount-testsuite
# sudo ./run --ov

It takes only ~13 sec for the basic test run to compete on my laptop.

Then, you should remove the relaxing of constant ino check for non samefs:
https://github.com/amir73il/unionmount-testsuite/commit/958b737a0a886b6949964d51dbf8e0786ea52d02#diff-2d2badb93764e2d3fa25662025095014R496

And you will hit the ino check error, for example:

# sudo ./run --ov rename-file
***
*** ./run --ov --ts=0 rename-file
***
TEST rename-file.py:10: Rename file and rename back
 ./run --rename /mnt/a/foo100 /mnt/a/no_foo100
/mnt/a/no_foo100: inode number wrong (got 35985, want 35584)


Please let me know if you intend to work on this soon, because I may be
working on some parts of this task for a different feature.

Thanks,
Amir.
