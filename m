Return-Path: <SRS0=5TWu=5O=vger.kernel.org=linux-unionfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6162DC43331
	for <linux-unionfs@archiver.kernel.org>; Sun, 29 Mar 2020 15:06:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 26F5F206F6
	for <linux-unionfs@archiver.kernel.org>; Sun, 29 Mar 2020 15:06:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FWFZB+Ub"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728245AbgC2PGz (ORCPT
        <rfc822;linux-unionfs@archiver.kernel.org>);
        Sun, 29 Mar 2020 11:06:55 -0400
Received: from mail-io1-f50.google.com ([209.85.166.50]:36584 "EHLO
        mail-io1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbgC2PGz (ORCPT
        <rfc822;linux-unionfs@vger.kernel.org>);
        Sun, 29 Mar 2020 11:06:55 -0400
Received: by mail-io1-f50.google.com with SMTP id n10so891946iom.3
        for <linux-unionfs@vger.kernel.org>; Sun, 29 Mar 2020 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=fx45S/OXRcgiAPWy2/2fh+AsP0MR2z8FWZPjhKDRAyY=;
        b=FWFZB+UbCzrKSontAteK+D5QdhJBd6XYq/+HYxjfGbwVh8YhvDW3gSXa8uCXRTxpBi
         70zDxtIGxyTxb9TQswFF72HXuVKS5s+pV64VNRFB/kviTeqCKH7qsPoqZyI+vtBwURmk
         MBpYQkjyTdVXcz4O9iuu6YFlES/O9xSWv9Q/WUS50+qxj6ZNLJD9L7FYgE1/Jt2yrYe3
         Avc4mMX4FMFblU9OWnnFdAEnWaLkpAx4aJKGTbW2lG5oVGu692r7k5CnO0kcPbgzTXVR
         Gc6Hq67iVQCIr/kDWpFOPBH1691Vq+3p2Y1rsXXf3VjV8nMFJtDRfXnNdtBZXASREMfR
         DdPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=fx45S/OXRcgiAPWy2/2fh+AsP0MR2z8FWZPjhKDRAyY=;
        b=tz8456Mk3oNDKqWsXqFfONKEswOjtAaWr7Jju4tpskGBAPov2rIoA4wse0c3+jmJGZ
         81+lfwjnByE9Ab524wScyKfdcP2oIfz06Tf02fNXhvxXKmh1a2fCIKIOKrqIjOLN74pU
         69LrGL03rMu9dXPZtpQP439CAFIGwilBVfabsv3MpFWxOQzc3tzbIX11Pu8E1nmnIo62
         OSD4YxIulkREDGViUrL6ict7jFn5zbIJ3RmQUxmZLLA+ZHGR61VySSiZAuPyFh5Smwy0
         TKpGl5m9VV9e+c9WIz+DccjmbmTDeNVA9hcReeFRgysxlDT6KWESmKsNa4ov75AswZX8
         AbbA==
X-Gm-Message-State: ANhLgQ2W6TdA3OvnqGMKFpl9JNwTzk5QNNjVqUwKDqQJ2LQrZ6/QhJQu
        2ppdjVjhfV5/tDTAPwQ4rjILEmpMUfxwIF6LEJA=
X-Google-Smtp-Source: ADFU+vuDi4cIqtp5WxoEC5uR1mLDSYrjFGHKOjGPChw02UITE0epTTRy0hPdle7EfrlgGqKVBZi8F5kMACsCvF2j6uw=
X-Received: by 2002:a5d:980f:: with SMTP id a15mr6791738iol.203.1585494414199;
 Sun, 29 Mar 2020 08:06:54 -0700 (PDT)
MIME-Version: 1.0
References: <171155f7fb1.fb0dc6a422928.8465401279980458758@mykernel.net>
 <CAOQ4uxgAubW72xGej-Tg4juicRe3nY0gmH32p0Sf3OWV45fviA@mail.gmail.com>
 <1711a6d7ebf.1251ea7b024963.4823296748033142049@mykernel.net>
 <CAOQ4uxj-6upXZkAKVDocuLSwveO8hb5_pdbd=_0zbRx2UD9gsg@mail.gmail.com> <17126a9038c.d17770b728105.8827100903005997785@mykernel.net>
In-Reply-To: <17126a9038c.d17770b728105.8827100903005997785@mykernel.net>
From:   Amir Goldstein <amir73il@gmail.com>
Date:   Sun, 29 Mar 2020 18:06:42 +0300
Message-ID: <CAOQ4uxg+-nbV=pq_He7xTkBdikRAwq0DXpt9d-FV8tx0MdLV_w@mail.gmail.com>
Subject: Re: Inode limitation for overlayfs
To:     Chengguang Xu <cgxu519@mykernel.net>
Cc:     linux-unionfs <linux-unionfs@vger.kernel.org>,
        miklos <miklos@szeredi.hu>, Hou Tao <houtao1@huawei.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-unionfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-unionfs.vger.kernel.org>
X-Mailing-List: linux-unionfs@vger.kernel.org

On Sun, Mar 29, 2020 at 5:19 PM Chengguang Xu <cgxu519@mykernel.net> wrote:
>
>  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E4=BA=94, 2020-03-27 17:45:37 Amir Gol=
dstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > On Fri, Mar 27, 2020 at 8:18 AM Chengguang Xu <cgxu519@mykernel.net> w=
rote:
>  > >
>  > >  ---- =E5=9C=A8 =E6=98=9F=E6=9C=9F=E5=9B=9B, 2020-03-26 15:34:13 Ami=
r Goldstein <amir73il@gmail.com> =E6=92=B0=E5=86=99 ----
>  > >  > On Thu, Mar 26, 2020 at 7:45 AM Chengguang Xu <cgxu519@mykernel.n=
et> wrote:
>  > >  > >
>  > >  > > Hello,
>  > >  > >
>  > >  > > On container use case, in order to prevent inode exhaustion on =
host file system by particular containers,  we would like to add inode limi=
tation for containers.
>  > >  > > However,  current solution for inode limitation is based on pro=
ject quota in specific underlying filesystem so it will also count deleted =
files(char type files) in overlay's upper layer.
>  > >  > > Even worse, users may delete some lower layer files for getting=
 more usable free inodes but the result will be opposite (consuming more in=
odes).
>  > >  > >
>  > >  > > It is somewhat different compare to disk size limitation for ov=
erlayfs, so I think maybe we can add a limit option just for new files in o=
verlayfs. What do you think?
>  >
>  > You are saying above that the goal is to prevent inode exhaustion on
>  > host file system,
>  > but you want to allow containers to modify and delete unlimited number
>  > of lower files
>  > thus allowing inode exhaustion. I don't see the logic is that.
>  >
>
> End users do not understand kernel tech very well, so we just want to mit=
igate
> container's different user experience as much as possible. In our point o=
f view,
> consuming more inode by deleting lower file is the feature of overlayfs, =
it's not
> caused by user's  abnormal using. However, we have to limit malicious use=
r
> program which is endlessly creating new files until host inode exhausting=
.
>
>
>  > Even if we only count new files and present this information on df -i
>  > how would users be able to free up inodes when they hit the limit?
>  > How would they know which inodes to delete?
>  >
>  > >  >
>  > >  > The questions are where do we store the accounting and how do we =
maintain them.
>  > >  > An answer to those questions could be - in the inode index:
>  > >  >
>  > >  > Currently, with nfs_export=3Don, there is already an index dir co=
ntaining:
>  > >  > - 1 hardlink per copied up non-dir inode
>  > >  > - 1 directory per copied-up directory
>  > >  > - 1 whiteout per whiteout in upperdir (not an hardlink)
>  > >  >
>  > >
>  > > Hi Amir,
>  > >
>  > > Thanks for quick response and detail information.
>  > >
>  > > I think the simplest way is just store accounting info in memory(may=
be  in s_fs_info).
>  > > At very first, I just thought  doing it for container use case, for =
container, it will be
>  > > enough because the upper layer is always empty at starting time and =
will be destroyed
>  > > at ending time.
>  >
>  > That is not a concept that overlayfs is currently aware of.
>  > *If* the concept is acceptable and you do implement a feature intended=
 for this
>  > special use case, you should verify on mount time that upperdir is emp=
ty.
>  >
>  > >
>  > > Adding a meta info to index dir is a  better solution for general us=
e case but it seems
>  > > more complicated and I'm not sure if there are other use cases conce=
rn with this problem.
>  > > Suggestion?
>  >
>  > docker already supports container storage quota using project quotas
>  > on upperdir (I implemented it).
>  > Seems like a very natural extension to also limit no. of inodes.
>  > The problem, as you wrote it above is that project quotas
>  > "will also count deleted files(char type files) in overlay's upper lay=
er."
>  > My suggestion to you was a way to account for the whiteouts separately=
,
>  > so you may deduct them from total inode count.
>  > If you are saying my suggestion is complicated, perhaps you did not
>  > understand it.
>  >
>
> I think the key point here is the count of whiteout inode. I would like t=
o
> propose share same inode with different whiteout files so that we can sav=
e
> inode significantly for whiteout files. After this, I think we can just i=
mplement
> normal inode limit for container just like block limit.
>

Very good idea. See:
https://lore.kernel.org/linux-unionfs/20180301064526.17216-1-houtao1@huawei=
.com/

I don't think Tao ever followed up with v3 patch.

Thanks,
Amir.
