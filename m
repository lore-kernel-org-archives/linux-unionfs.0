Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C9B5CA0FF3
	for <linux-unionfs@archiver.kernel.org>; Fri,  1 Sep 2023 20:02:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343513AbjIAUCK (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Fri, 1 Sep 2023 16:02:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236019AbjIAUCK (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Fri, 1 Sep 2023 16:02:10 -0400
Received: from mail-oi1-x229.google.com (mail-oi1-x229.google.com [IPv6:2607:f8b0:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A89C10FB
        for <linux-unionfs@vger.kernel.org>; Fri,  1 Sep 2023 13:02:07 -0700 (PDT)
Received: by mail-oi1-x229.google.com with SMTP id 5614622812f47-3a9c59cccd3so1606196b6e.1
        for <linux-unionfs@vger.kernel.org>; Fri, 01 Sep 2023 13:02:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1693598526; x=1694203326; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CYyQqnpXjzbvVT0TiLnl0crJesCORGUJ+y3WGYeeRzk=;
        b=MfyffNaYl2tyTtRTG63mU8Se8cE6xyX4AV/6KSjzX21OsaImcCKbOt7vysjYuRIK1j
         3I0nPkfwKAmz7dyxItZoeDQmRcfav2aFQSuCFT5Fwpx5OJEIyZSTDkfkYhWfBUtBGJXI
         hGcNsRrAqSCdngjZ/E1diG6e2kCmBEngPsxJ7kM5GnmdoHLVnHwAdgH7dL5jaAoXpg/K
         CRU7Iqo0jobKBjcldr/+bHPfE7wsGvk5RFpcrMETk431ZNvH20T8vXivO8aALM1h9TsY
         GWM24xKnqXljPTXvkpNmPBkshDzkMnlvVcSG1G2qxrVV0YQrQbUGKEE6zlRXqSlMykq3
         JxPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693598526; x=1694203326;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CYyQqnpXjzbvVT0TiLnl0crJesCORGUJ+y3WGYeeRzk=;
        b=eMj2mIWTEwafjRmeGubn+CT+zFRtp7TZ1LgKfgC+7rGYdin++oMo9SVMOv8Rv32blc
         r7nN5awD2krfDySIoxmrKxm6f3bKop0aq3oif6JFk6QdKHCvhc7EMoQCw+I+lJrgKCU1
         qHPkGcZtVirbXnrVruoKY/6XSFOnoTwmWZ99m9xTRsYo3KIrpVHsV+HobMOt4Ivtwo5h
         CZn1Hat/05k4Hq1ZLF3pu5owd1FVrVZCZKZ4LBXKieNxNoBS7kxvznZe9VJgGBUDrR/w
         FyshUONN/LIc4TWJUXdzqmLvtt8Yox5yZ7jKDHX9HhkepqF0hJUu4HLzSnJfkKifIPg7
         nlow==
X-Gm-Message-State: AOJu0YxGumqiiNi100Z1M/dlIIDuhK+YLTcvndJaeTuEgIg/6EI5dShB
        l2FntEn6nIH4PRge9Mzwmhff88RRh9uOvFnM8dgoxA==
X-Google-Smtp-Source: AGHT+IEASxRTxA8OV1NHaxW6KHzCqeCbPbatH9Mg6OibxMoTgsFJ2urmFF/6RQZLFoDSCeAPW6RlBCS5PxQUcInroj8=
X-Received: by 2002:a05:6808:44:b0:3a7:4a89:7510 with SMTP id
 v4-20020a056808004400b003a74a897510mr3652971oic.30.1693598526220; Fri, 01 Sep
 2023 13:02:06 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
 <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com>
 <CAKd=y5Gsz1z1xSmHGyoEs+SckC=M0T7nrP7t5mvvuoWkCWkDLg@mail.gmail.com>
 <CAOQ4uxiQtSSHL0gLohBpRs7vwUrF5LqCLB=Oh6kSz1O-ga04Tw@mail.gmail.com>
 <CAJfpegvCEsvac5j3CSVWjjZLsxDvZ-_vX-6u1ZQra26dnUk-jg@mail.gmail.com>
 <CAOQ4uxjHob=nDUghkGHpcfoAYSUNV_MZB5YHEkTUXB+bOuUBoA@mail.gmail.com> <CAKd=y5FZ+imzR_bWK+g-xhBNvxhV2OpuHYLtm3dd4y+k0pMyNw@mail.gmail.com>
In-Reply-To: <CAKd=y5FZ+imzR_bWK+g-xhBNvxhV2OpuHYLtm3dd4y+k0pMyNw@mail.gmail.com>
From:   Ruiwen Zhao <ruiwen@google.com>
Date:   Fri, 1 Sep 2023 13:01:53 -0700
Message-ID: <CAKd=y5Hpg7J2gxrFT02F94o=FM9QvGp=kcH1Grctx8HzFYvpiA@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Amir Goldstein <amir73il@gmail.com>
Cc:     Miklos Szeredi <miklos@szeredi.hu>, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

(Sending again in plain-text mode because previous email was blocked)

Hi all,

Thanks for all the help! I tested the easy fix (i.e. to ignore ENXIO,
see git diff here [1]), and can confirm it worked. The setup is the
same as the repro steps I mentioned above, so I am only pasting the
last step here:

```
ruiwen@instance-1:/tmp # mv merged/home/ruiwen/foolink
merged/home/ruiwen/foolink2
ruiwen@instance-1:/tmp # ls -l merged/home/ruiwen/ -l
total 0
-rw-r--r-- 1 root root 0 Sep  1 18:46 foo
lrwxrwxrwx 1 root root 3 Sep  1 18:47 foolink2 -> foo
```

I also checked dmesg and can confirm that there is no error. I can
send out a PR for this fix. Meanwhile I have a followup question on
the source of ENXIO.

Amir - you mentioned that ENXIO might come from no_open() default
->open() method. I found no_open in fs/inode.c returned ENXIO [2], but
cannot connect it to ovl_security_fileattr. If the error happens on
every open, then it will happen on even reading the symlink, instead
of only moving it, right? Can you elaborate on no_open() default
->open() method?

[1] https://gist.github.com/ruiwen-zhao/93ebe0b4ad20fab005d0300e9f0194c2

[2] https://github.com/torvalds/linux/blob/b84acc11b1c9552c9ca3a099b1610a60=
18619332/fs/inode.c#L145

Thanks,
Ruiwen


On Fri, Sep 1, 2023 at 12:27=E2=80=AFPM Ruiwen Zhao <ruiwen@google.com> wro=
te:
>
> Hi all,
>
> Thanks for all the help! I tested the easy fix (i.e. to ignore ENXIO, see=
 git diff here [1]), and can confirm it worked. The setup is the same as th=
e repro steps I mentioned above, so I am only pasting the last step here:
>
> ```
> ruiwen@instance-1:/tmp # mv merged/home/ruiwen/foolink merged/home/ruiwen=
/foolink2
> ruiwen@instance-1:/tmp # ls -l merged/home/ruiwen/ -l
> total 0
> -rw-r--r-- 1 root root 0 Sep  1 18:46 foo
> lrwxrwxrwx 1 root root 3 Sep  1 18:47 foolink2 -> foo
> ```
>
> I also checked dmesg and can confirm that there is no error. I can send o=
ut a PR for this fix. Meanwhile I have a followup question on the source of=
 ENXIO.
>
> Amir - you mentioned that ENXIO might come from no_open() default ->open(=
) method. I found no_open in fs/inode.c returned ENXIO [2], but cannot conn=
ect it to ovl_security_fileattr. If the error happens on every open, then i=
t will happen on even reading the symlink, instead of only moving it, right=
? Can you elaborate on no_open() default ->open() method?
>
>
> [1] https://gist.github.com/ruiwen-zhao/93ebe0b4ad20fab005d0300e9f0194c2
>
> [2] https://github.com/torvalds/linux/blob/b84acc11b1c9552c9ca3a099b1610a=
6018619332/fs/inode.c#L145
>
> Thanks,
> Ruiwen
>
> On Fri, Sep 1, 2023 at 10:58=E2=80=AFAM Amir Goldstein <amir73il@gmail.co=
m> wrote:
>>
>> On Fri, Sep 1, 2023 at 1:14=E2=80=AFPM Miklos Szeredi <miklos@szeredi.hu=
> wrote:
>> >
>> > On Fri, 1 Sept 2023 at 12:08, Amir Goldstein <amir73il@gmail.com> wrot=
e:
>> > >
>> > > On Fri, Sep 1, 2023 at 12:59=E2=80=AFAM Ruiwen Zhao <ruiwen@google.c=
om> wrote:
>> > > >
>> > > > Thanks for the reply Amir! Really helps. I will try the easy fix (=
i.e. ignoring ENXIO) and test it. Meanwhile I have two questions:
>> > > >
>> > > > 1. Since ENXIO comes from ovl_security_fileattr() trying to open t=
he symlink, I was trying to find who returns ENXIO in the first place. I di=
d some code search on libfuse (https://github.com/libfuse/libfuse), but can=
not find ENXIO anywhere. Could it be from the kernel side? (I am trying to =
use this as a justification of the easy fix.)
>> > > >
>> > >
>> > > I think ENXIO comes from no_open() default ->open() method.
>> > >
>> > > > 2. Miklos's commit message says "The reason is that ovl_copy_filea=
ttr() is triggered due to S_NOATIME being
>> > > > set on all inodes (by fuse) regardless of fileattr." Does that mea=
n `ovl_copy_fileattr` should not be triggered on symlink files but it is, a=
nd therefore it is getting the errors like ENXIO and ENOTTY?
>> > > >
>> > >
>> > > Miklos' comment explains why ovl_copy_fileattr() passes the gate:
>> > >
>> > >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK) {
>> > >
>> > > S_NOATIME is an indication that the file MAY have fileattr FS_NOATIM=
E_FL,
>> > > but in the case of FUSE and NFS, S_NOATIME is there for another unre=
lated
>> > > reason.
>> > >
>> > > In any case, S_NOATIME on a symlink is never an indication of fileat=
tr,
>> > > so I think the correct solution is to add the conditions to the gate=
:
>> > >
>> > >         if (inode->i_flags & OVL_COPY_I_FLAGS_MASK &&
>> > >            ((S_ISDIR(inode->i_mode) || S_ISREG(inode->i_mode))) {
>> > >
>> >
>> > I don't think this is correct: symlink's atime is updated on readlink
>> > or following.
>>
>> I am not saying that symlink cannot have S_NOATIME, but
>> i_flags of the symlink have already been copied to ovl inode.
>> I don't think that symlink can have fileattr, because symlink
>> cannot be opened for the FS_IOC_SETFLAGS ioctl, so there
>> is never a reason to call ovl_copy_fileattr() for anything other
>> than dir or regular file. Right?
>>
>> Thanks,
>> Amir.
