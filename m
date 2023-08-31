Return-Path: <linux-unionfs-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B113CC83F2F
	for <linux-unionfs@archiver.kernel.org>; Thu, 31 Aug 2023 19:54:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347303AbjHaTyg (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Thu, 31 Aug 2023 15:54:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347308AbjHaTye (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Thu, 31 Aug 2023 15:54:34 -0400
Received: from mail-vs1-xe2b.google.com (mail-vs1-xe2b.google.com [IPv6:2607:f8b0:4864:20::e2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 772EFE5C
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Aug 2023 12:54:31 -0700 (PDT)
Received: by mail-vs1-xe2b.google.com with SMTP id ada2fe7eead31-44e3a4d0a6fso614712137.0
        for <linux-unionfs@vger.kernel.org>; Thu, 31 Aug 2023 12:54:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693511670; x=1694116470; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HlGSr+E63P4CYcZCnYHLbLFb7ehHb8IjwS8Zej3isyc=;
        b=SvD3TmdFT9nkEg1HMeomDQJ1xHqGMrnEHpA88d3/gb8R2M3lTvKM5s55RA0MG23BpR
         QnUuAGr7+C4f+OpuiMJJ5n018YFFH4i0v6YeYvSTYCUYoUMGIdkn/KyX6msPzi/2xsc3
         LIXni+TegC2aMpaQ1p0F+2Io5nM6mCEcAqZ03z31NUMnLA/2II8we1a/9tQQ7aOH/+wf
         eSRD8VuMQxhLRYDnJCmV5bLa45ntjjLTnHeeixUyuLZSoIPeluPjd4MlqBFKCfL+S/58
         BKpGJgweV3DKXZ/by0rzs4hwq5BBbPT76R5827QeWa/jJ2OSmRbSJi/AhHvj5bR/ppLE
         smng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693511670; x=1694116470;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=HlGSr+E63P4CYcZCnYHLbLFb7ehHb8IjwS8Zej3isyc=;
        b=Z0i4hgUVy/fQ7MsRBkEvH1wbzYJSxWCqjtypxKGH1uCoSPKMpNRENg67J9hns8GlXd
         hdvkEvxSPZRwWkVgy/oDBLNeuEDmRubEO3L9MMGhEikw08iE8ZAaal9EACSwSS3lsr8i
         FNNlO2oLw6jXKa1EWAidxw40rBrwZ0ilSOs2emPygkiz/jFsHhOLBl90ETgWpDa/iYb7
         2tF1DnwMbEsj5P5CxBGYzIvWDEeSBBWYyg+wZeQSgiI/DQAIqpGDEuTQgfb0YzXSHjgc
         aLJmwYAHaVajKuyxZ7Cd0CtSlWQyeGgCAM8WuWELtTjSWlGz0QRULnZxvXDJIuh91qxS
         vlZA==
X-Gm-Message-State: AOJu0Ywufq2wAX6RPX90hXZws39rP0ulsKXm1xBhc+rOYMp0dJKKJkAw
        W+29PiveqYN/xmXCl7/nBhB4d8lhLFWkej2W92PZJSiBs8fuiA==
X-Google-Smtp-Source: AGHT+IGpgrFRvRKy9xQnOSKl2z+pbDK0Lge5z02UlNhrZNaaqd0uJRno1cNuMjsT7cnxe1qk5JBVG3ka9XnRDU+bRwA=
X-Received: by 2002:a05:6102:103:b0:44e:9ee6:b002 with SMTP id
 z3-20020a056102010300b0044e9ee6b002mr633172vsq.34.1693511670463; Thu, 31 Aug
 2023 12:54:30 -0700 (PDT)
MIME-Version: 1.0
References: <CAKd=y5EeKfC6vBXh1xqTfeW6OQZiNWaZ04J1SNWxyEjY4QxhHw@mail.gmail.com>
 <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
In-Reply-To: <CAKd=y5HZ0nJJ9XN9i6vnyhzM=COijmuSzgqJPAPFn6dguQyFQA@mail.gmail.com>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Thu, 31 Aug 2023 22:54:19 +0300
Message-ID: <CAOQ4uxid-eDr2XBHo_JoPhiP99PrXj0eNKgEQXP-SOEbg4hn_Q@mail.gmail.com>
Subject: Re: [Bug report] overlayfs: cannot rename symlink if lower filesystem
 is FUSE/NFS
To:     Ruiwen Zhao <ruiwen@google.com>
Cc:     miklos@szeredi.hu, linux-unionfs@vger.kernel.org,
        Sergey Kanzhelev <skanzhelev@google.com>,
        Michael Sheinin <msheinin@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Thu, Aug 31, 2023 at 8:25=E2=80=AFPM Ruiwen Zhao <ruiwen@google.com> wro=
te:
>
> + Amir Goldstein
>
> On Thu, Aug 31, 2023 at 10:22=E2=80=AFAM Ruiwen Zhao <ruiwen@google.com> =
wrote:
>>
>> Hi,
>>
>> We recently found a regression on linux kernel: rename(2) on a symlink t=
hrough an overlayfs fails with ENXIO, when the lowerdir is FUSE. I reported=
 this bug to https://bugzilla.kernel.org/show_bug.cgi?id=3D217850 as well.
>>
>> *What happened*
>>
>> When running `mv` command on a symlink file through overlayfs, and the o=
verlayfs's lowdir on FUSE or NFS, the command fails with "No such device or=
 address". This issue happens on kernel 5.15 and 6.1, but not on 5.10.
>>
>> *How to reproduce*
>> Environment: Debian bookworm (kernel 6.1.0)
>>
>> 1. To prepare the FUSE fs, create a file and a symlink under the VM's ro=
ot dir:
>>
>> ```
>> ruiwen@instance-1:/tmp$ ls / -l | grep foo
>> -rw-r--r--   1 root root     0 Aug 30 23:10 foo
>> lrwxrwxrwx   1 root root     3 Aug 30 23:12 foolink -> foo
>> ```
>> and then run libfuse's passthrough (https://github.com/libfuse/libfuse/b=
lob/master/example/passthrough.c), which mounts a FUSE filesystem by mirror=
ing the root dir:
>>
>> ```
>> ruiwen@instance-1:~/fuse-3.16.1/build/example$ ./passthrough -o allow_ot=
her /tmp/fusemount
>> ruiwen@instance-1:~/fuse-3.16.1/build/example$ ls /tmp/fusemount/ -l | g=
rep foo
>> -rw-r--r--   1 root root     0 Aug 30 23:10 foo
>> lrwxrwxrwx   1 root root     3 Aug 30 23:12 foolink -> foo
>> ```
>>
>> 2. Create an overlayfs mount, with lower dir being the the mount point o=
f FUSE filesystem.
>> ```
>> ruiwen@instance-1:/tmp$ mkdir -p fusemount upper work merged
>> ruiwen@instance-1:/tmp$ sudo mount -t overlay overlay -o lowerdir=3Dfuse=
mount,upperdir=3Dupper,workdir=3Dwork merged
>> ruiwen@instance-1:/tmp$ ls -l merged/ | grep foo
>> -rw-r--r--   1 root root     0 Aug 30 23:10 foo
>> lrwxrwxrwx   1 root root     3 Aug 30 23:12 foolink -> foo
>> ```
>>
>> 3. Try to move the symlink and see the failure:
>> ```
>> ruiwen@instance-1:/tmp$ mv merged/foolink merged/foolink2
>> mv: cannot move 'merged/foolink' to 'merged/foolink2': No such device or=
 address
>> ```
>>
>> *Some observations*
>>
>> 1. Same bug has been reported at Debian Bug, where overlayfs is used wit=
h NFS: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1049885. This ma=
kes me think that the bug is more on overlayfs, but not on FUSE or NFS.
>>
>> 2. This issue can be reproduced on kernel 5.15, 6.10, but CANNOT be repr=
oduced on kernel 5.10. There is a noticeable change on 5.15 that is related=
 to overlayfs: (https://github.com/torvalds/linux/commit/72db82115d2bdfbfba=
8b15a92d91872cfe1b40c6), which introduces copyup fileattr.
>>
>> 3. When reproducing this bug, we found that the error ENXIO was actually=
 from getting lower fileattr. In dmesg we see: "failed to retrieve lower fi=
leattr (/link, err=3D-6)". So it seems that overlayfs for some reason fails=
 to get the file attributes of the source file from the underlying filesyst=
em.
>>
>>

Looks like ENXIO is coming from ovl_security_fileattr() trying to open
the symlink.
The reason why this happens on FUSE and NFS is explained by Miklos in the
Side note: in commit message of:
5b0a414d06c3 ovl: fix filattr copy-up failure

The commit above relaxes failure to copy up fileattr on errors ENOTTY
and EINVAL for Ntfs-3g.

The easy fix would be to relax failure of getting fileattr from lower also =
on
ENXIO (and explain why in a comment).
Can you test this fix? Can you send a patch if it works?

It may be nicer to call ovl_copy_fileattr() only for directory and regular =
files
to begin with, but I am not sure.

Thanks,
Amir.
