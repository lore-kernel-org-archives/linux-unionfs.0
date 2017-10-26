From: Amir Goldstein <amir73il@gmail.com>
Subject: Re: [PATCH 04/13] ovl: Provide a mount option metacopy=on/off for
 metadata copyup
Date: Thu, 26 Oct 2017 16:57:44 +0300
Message-ID: <CAOQ4uxhhp_EukHuW6zkDCuHngM1vLGhtR2=zc1=AARxWOHx4eQ@mail.gmail.com>
References: <1508958575-14086-1-git-send-email-vgoyal@redhat.com>
 <1508958575-14086-5-git-send-email-vgoyal@redhat.com> <CAOQ4uxhV3-8ytms+M5n2QVYGmZJNL527H7KYpXnzbE93fOsBdA@mail.gmail.com>
 <20171026131505.GB28005@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-unionfs-owner@vger.kernel.org>
Received: from mail-yw0-f193.google.com ([209.85.161.193]:51720 "EHLO
        mail-yw0-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932234AbdJZN5q (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 26 Oct 2017 09:57:46 -0400
Received: by mail-yw0-f193.google.com with SMTP id k3so2958849ywk.8
        for <linux-unionfs@vger.kernel.org>; Thu, 26 Oct 2017 06:57:46 -0700 (PDT)
In-Reply-To: <20171026131505.GB28005@redhat.com>
Sender: linux-unionfs-owner@vger.kernel.org
List-Id: linux-unionfs@vger.kernel.org
To: Vivek Goyal <vgoyal@redhat.com>
Cc: overlayfs <linux-unionfs@vger.kernel.org>, Miklos Szeredi <miklos@szeredi.hu>

On Thu, Oct 26, 2017 at 4:15 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
> On Thu, Oct 26, 2017 at 08:39:28AM +0300, Amir Goldstein wrote:
>> On Wed, Oct 25, 2017 at 10:09 PM, Vivek Goyal <vgoyal@redhat.com> wrote:
>> > By default metadata only copy up is disabled. Provide a mount option so
>> > that users can choose one way or other.
>> >
>> > Also provide a kernel config and module option to enable/disable
>> > metacopy feature.
>> >
>> > Like index feature, when overlay is mounted, on root upper directory we
>> > set ORIGIN which points to lower. And at later mount time it is verified
>> > again. This hopes to get the configuration right. But this does only so
>> > much as we don't verify all the lowers. So it is possible that a lower is
>> > missing and later data copy up fails.
>>
>> Since you bother to specify the motivation for verifying lower root dir,
>> FYI, the main motivation was to detect the case of copied layers.
>
> What are copied layers? You mean I remove original layer and bring in
> another one with same top dir name?
>

I mean admin is out of disk space so she cp -a some folders
between volumes or maybe copying all layers a side to backup
a machine.

There is a section in Documentation/filesystems/overlayfs.txt
"Sharing and copying layers" where I wrote:
"It is quite a common practice to copy overlay layers to a different
directory tree on the same or different underlying filesystem, and even
to a different machine"

This was my impression.
Please fix me if you think this statement is not accurate.


> But this tests only one layer, right. So if there are multiple lower
> layers, I can still copy/remove or do something else with other layers
> and it will not detect.
>
> Also I should be able to retain top dir name same and replace anything
> underneath and that will not be detected either.
>
> So it provides only so much of protection, IIUC.

It provides merely a big red sign if user used to practice
"copying layers", user cannot do that anymore with index=on
and she cannot do that with metacopy=on either.
the test is there as a heuristic to detect that use case and alert the user.

I would rephrase commit message to something like:
"Like index feature, we verify on mount that upper root is not being
 reused with a different lower root. This hopes to get the configuration
 right and detect the copied layers use case. But this does only..."

Less 'what' more 'why'.

>
>> I still hold the opinion that new incompat features should enforce
>> exclusive dir lock, so withholding Reviewed-by on this one for now.
>
> I am really not happy about enforcing exlusive dir lock because
> this breaks userspace.
>
> I like the idea of making it hard to get configuration wrong, but overlay
> was like this since the beginning and how many issues have we faced
> that users ended up sharing upper. Atleast I have not come across
> even a single one.
>
> If that's the case, I would rahter wait that a proper fix comes along
> (finding existing super block and returning that) and then harden it.
>
> If I enforce it now, I most likely can't even use it with current
> container run time because there is a possibility they can leak
> mount points. So what's the point of introducing this feature.
>
> Miklos, what do you think?
>
> Vivek
